/*
 * ppMex.c
 *
 * Compile in MATLAB:
 * > mex ppMex.c [-O] [-g] [-v]
 *
 * For documentation see pp.m
 *
 * following:
 * http://as6edriver.sourceforge.net/Parallel-Port-Programming-HOWTO/accessing.html
 * http://people.redhat.com/twaugh/parport/html/parportguide.html
 *
 * Copyright (C) 2011 Erik Flister, University of Oregon, erik.flister <at> gmail
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include "mex.h"

#include <sys/io.h>
#include <string.h>
#include <errno.h>

#include <math.h>

#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <sys/ioctl.h>
#include <linux/parport.h>
#include <linux/ppdev.h>

#define NUM_ADDRESS_COLS 2
#define NUM_DATA_COLS 3

#define ADDR_BASE "/dev/parport"

#define DEBUG false
#define ENABLE_WRITE true
#define USE_PPDEV false /* just sketched in atm */

#define DATA_OFFSET 0
#define STATUS_OFFSET 1
#define CONTROL_OFFSET 2
#define ECR_OFFSET 0x402

#define OFFSETS {DATA_OFFSET,STATUS_OFFSET,CONTROL_OFFSET,ECR_OFFSET}
#define NUM_REGISTERS 4

#define CONTROL_BIT_0 PARPORT_CONTROL_STROBE
#define CONTROL_BIT_1 PARPORT_CONTROL_AUTOFD
#define CONTROL_BIT_2 PARPORT_CONTROL_INIT
#define CONTROL_BIT_3 PARPORT_CONTROL_SELECT

#define STATUS_BIT_3 PARPORT_STATUS_ERROR
#define STATUS_BIT_4 PARPORT_STATUS_SELECT
#define STATUS_BIT_5 PARPORT_STATUS_PAPEROUT
#define STATUS_BIT_6 PARPORT_STATUS_ACK
#define STATUS_BIT_7 PARPORT_STATUS_BUSY

bool getBit(const unsigned char b, const unsigned char n) {
    return (true && (b & 1<<n)); /* need a bona fide bool */
}

void printBits(const unsigned char b) {
    int i;
    for (i = 7; i >= 0; i--) {
        printf("%c",getBit(b,i) ? '1' : '0');
    }
}

void ppd(const int parportfd, const int action, void * const b, const char * const msg) {
    int result;
    
    if (b==NULL) {
        result = ioctl(parportfd,action);
    } else {
        result = ioctl(parportfd,action,b);
    }
    
    if (result != 0) {
        printf("PPD ioctl %d: %d (%s)\n",action,result,strerror(errno));
        mexErrMsgTxt(msg);
    }
}

void read(const uint64_T reg, void * const b, const int parportfd, const int reader, const int o) {
    if USE_PPDEV {
        ppd(parportfd,reader,b,"couldn't read pport");
        /*         printf("%d\n",o); */
    } else {
        *(unsigned char *)b = inb(reg);
    }
}

void doPort(
        const void * const addr,
        const unsigned char mask[NUM_REGISTERS],
        const unsigned char vals[NUM_REGISTERS],
        mxLogical * const out,
        const int n,
        const uint8_T * const data,hex2dec('378')
        const int numVals,
        const bool writing
        ) {
    static bool setup = false;
    
    uint64_T reg;
    unsigned char b;
    int result, i, j, parportfd, reader, writer, offsets[NUM_REGISTERS] = OFFSETS; /*lame*/
    
    if USE_PPDEV {
        /*PPDEV doesn't require root, is supposed to be faster, and is address-space safe, but only available in later kernels >=2.4?*/
        /*however, i seem to need to sudo matlab in order to open eg /dev/parport0 */
        
        /* note our design here is not fast -- we'd like to persist the state of the port for future calls instead of acquiring and releasing it for every call, but you aren't supposed to hold on to it for more than a second or so */
        
        parportfd = open(addr, O_RDWR);
        if (parportfd == -1) {
            printf("%s %s\n",addr,strerror(errno));
            mexErrMsgTxt("couldn't access port");
        }
        
        /*bug: if the following error out, we won't close parportfd or free addrStr -- need some exceptionish error handling */
        
        /* PPEXCL call succeeds, but causes following calls to fail
         * then dmesg has: parport0: cannot grant exclusive access for device ppdev0
         *                 ppdev0: failed to register device!
         *
         * web search suggests this is because lp is loaded -- implications of removing it?
         */
        /* ppd(parportfd,PPEXCL,NULL,"couldn't get exclusive access to pport"); */
        
        ppd(parportfd,PPCLAIM,NULL,"couldn't claim pport");
        
        int mode = IEEE1284_MODE_BYTE; /* or would we want COMPAT? */
        ppd(parportfd,PPSETMODE,&mode,"couldn't set byte mode");
    }
    
    if (!setup && !USE_PPDEV) {
        if DEBUG printf("setting up access to pport\n");
        
        /*requires >= -O2 compiler optimization to inline inb/outb macros from io.h*/
        
        result = iopl(3); /* requires sudo, allows access to the entire address space with the associated risks.*/
        /* required for ECR. safer alternative: ioperm, but probably prevents access to PCI/PCMCIA add-on ports */
        
        if (result != 0) {
            printf("iopl: %d (%s)\n",result,strerror(errno));
            mexErrMsgTxt("couldn't claim address space");
        }
        
        setup = true;
    }
    
    for (i = 0; i < NUM_REGISTERS; i++) {
        if (mask[i] != 0) {
            switch (offsets[i]) {
                case DATA_OFFSET:
                    reader = PPRDATA; /*need PPDATADIR set non-zero*/
                    writer = PPWDATA; /*need PPDATADIR set zero*/
                    break;
                case STATUS_OFFSET:
                    reader = PPRSTATUS;
                    break;
                case CONTROL_OFFSET:
                    reader = PPRCONTROL;
                    writer = PPWCONTROL;
                    break;
                case ECR_OFFSET:
                    if USE_PPDEV {
                        mexErrMsgTxt("ECR not supported under PPDEV (figure out correct PPSETMODE)");
                    }
                    break;
                default:
                    mexErrMsgTxt("bad offset");
                    break;
            }
            reg = *(uint64_T *)addr + offsets[i];
            read(reg,&b,parportfd,reader,offsets[i]);
            
            if (writing) {
                switch (offsets[i]) {
                    case STATUS_OFFSET:
                        mexErrMsgTxt("can't write to status register");
                        break;
                    case CONTROL_OFFSET:
                        for (j=4; j<=7; j++) {
                            if (getBit(mask[i],j)) {
                                mexErrMsgTxt("bad control bit for writing");
                            }
                        }
                        break;
                }
                if DEBUG {
                    printf("old %d:",i);
                    printBits(b);
                }
                b = (b & ~mask[i]) | vals[i]; /*frob*/
                if DEBUG {
                    printf(" -> ");
                    printBits(b);
                }
                if (offsets[i] != ECR_OFFSET && ENABLE_WRITE) {
                    if USE_PPDEV {
                        ppd(parportfd,writer,&b,"couldn't write pport");
                        /* printf("%d\n",offsets[i]); */
                    } else {
                        outb(b,reg);
                    }
                    if (out != NULL || DEBUG) {
                        read(reg,&b,parportfd,reader,offsets[i]);
                        
                        if DEBUG {
                            printf(" -> ");
                            printBits(b);
                            printf("\n");
                        }
                    }
                } else {
                    printf(" not actually writing to register, either writes disabled or ECR protection\n");
                }
            }
            
            if (out != NULL) {
                for (j = 0; j < numVals; j++) {
                    if (data[j+numVals] == offsets[i]) {
                        out[j+n*numVals] = getBit(b,data[j]);
                        if DEBUG {
                            printf("wrote a %d\n",out[j+n*numVals]);
                        }
                    }
                }
            }
        }
    }
    
    if USE_PPDEV {
        ppd(parportfd,PPRELEASE,NULL,"couldn't release pport");
        
        result = close(parportfd);
        if (result != 0) {
            printf("close: %d (%s)\n",result,strerror(errno));
            mexErrMsgTxt("couldn't close port");
        }
    }
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    int numAddresses, numVals, i, j, result, addrStrLen;
    
    uint64_T *addresses;
    uint8_T *data;
    mxLogical *out;
    
    uint64_T address, port;
    uint8_T bitNum, regOffset, value = 0;
    
    unsigned char mask[NUM_REGISTERS] = { 0 }, vals[NUM_REGISTERS] = { 0 }, pos;
    
    char *addrStr;
    void *addr;
    
    bool writing;
    
    if (nrhs != 2) {
        mexErrMsgTxt("exactly 2 arguments required");
    }
    
    for (i = 0; i < nrhs; i++) {
        if (mxGetNumberOfDimensions(prhs[i])!=2 || mxIsComplex(prhs[i]) || !mxIsNumeric(prhs[i]) || mxGetM(prhs[i])<1) {
            mexErrMsgTxt("arguments must be real numeric matrices with at least one row");
        }
    }
    
    if (mxGetN(prhs[0])!=NUM_ADDRESS_COLS || !mxIsUint64(prhs[0])) {
        mexErrMsgTxt("first argument must be uint64 two columns (portNum, address)");
    }
    
    if (!mxIsUint8(prhs[1])) {
        mexErrMsgTxt("second argument must be uint8");
    }
    
    numAddresses = mxGetM(prhs[0]);
    addresses = mxGetData(prhs[0]);
    
    numVals = mxGetM(prhs[1]);
    data = mxGetData(prhs[1]);
    
    switch (mxGetN(prhs[1])) {
        case NUM_DATA_COLS - 1:
            writing = false;
            break;
        case NUM_DATA_COLS:
            writing = true;
            break;
        default:
            mexErrMsgTxt("second argument must have 2 (reading) or 3 columns (writing): bitNum, regOffset, [value]");
            break;
    }
    
    if DEBUG printf("%d lhs\n",nlhs);
    switch (nlhs) {
        case 1:
            *plhs = mxCreateLogicalMatrix(numVals,numAddresses);
            if (*plhs == NULL) {
                mexErrMsgTxt("couldn't allocate output");
            }
            out = mxGetLogicals(*plhs);
            break;
        case 0:
            if (!writing) {
                mexErrMsgTxt("exactly 1 output argument required when reading");
            }
            out = NULL;
            break;
        default:
            mexErrMsgTxt("at most 1 output argument allowed");
            break;
    }
    
    if DEBUG printf("\n\ndata:\n");
    
    for (i = 0; i < numVals; i++) {
        bitNum    = data[i          ];
        regOffset = data[i+  numVals];
        if (writing) {
            value = data[i+2*numVals];
        }
        
        if DEBUG {
            printf("\t%d, %d", bitNum, regOffset);
            if (writing) printf(" %d", value);
            printf("\n");
        }
        
        if (bitNum>7 || regOffset>2 || value>1) {
            mexErrMsgTxt("bitNum must be 0-7, regOffset must be 0-2, value must be 0-1.");
        }
        
        pos = 1<<bitNum;
        mask[regOffset] |= pos;
        if (value) vals[regOffset] |= pos;
    }
    
    if DEBUG {
        for (j = 0; j < NUM_REGISTERS; j++) {
            printf("mask:");
            printBits(mask[j]);
            if (writing) {
                printf(" val:");
                printBits(vals[j]);
            }
            printf("\n");
        }
    }
    
    for (i = 0; i < numAddresses; i++) {
        port    = addresses[i];
        address = addresses[i+numAddresses];
        
        if DEBUG printf("addr %d: %" FMT64 "u, %" FMT64 "u\n", i, address, port);
        
        if USE_PPDEV {
            addrStrLen = strlen(ADDR_BASE) + (port == 0 ? 1 : 1 + floor(log10(port))); /* number digits in port */
            addrStr = (char *)mxMalloc(addrStrLen);
            if (addrStr == NULL) {
                mexErrMsgTxt("couldn't allocate addrStr");
            }
            
            result = snprintf(addrStr,addrStrLen+1,"%s%" FMT64 "u",ADDR_BASE,port); /* +1 for null terminator */
            if (result != addrStrLen) {
                printf("%d\t%d\t%s\n",result,addrStrLen,addrStr);
                mexErrMsgTxt("bad addrStr snprintf");
            }
            
            if DEBUG printf("%d\t%s.\n",addrStrLen,addrStr);
            
            addr = addrStr;
        } else {
            addr = &address;
        }
        
        doPort(addr, mask, vals, out, i, data, numVals, writing);
        
        if USE_PPDEV {
            mxFree(addrStr);
        }
    }
}
