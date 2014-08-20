function [computer, Computer2] = identifyPC()
% This function identifies the computer the task is running on by checking
% the software identifier of its network card.

sid = '';
ni = java.net.NetworkInterface.getNetworkInterfaces;
while ni.hasMoreElements
    addr = ni.nextElement.getHardwareAddress;
    if ~isempty(addr)
        addrStr = dec2hex(int16(addr)+128);
        sid = [sid, '.', reshape(addrStr,1,2*length(addr))];
    end
end

computer='';
Computer2='';
if strcmp(sid, '.EDB04B8B5134')
    computer = 'D_Pilot';
    Computer2 = false;
elseif strcmp(sid, '.EDB0518B54C7')
    computer = 'D_Pilot';
    Computer2 = true;
elseif strcmp(sid, '.139DEA01CE83.8888888600000000.8888888600000000.8888888600000000')
    computer = 'Dresden';
elseif strcmp(sid, '.F5B0D5445F09.8888888600000000.88A8B78070C3.8888888600000000.8888888600000000')
    computer = 'Dresden_Rene';
elseif strcmp(sid, '.0928C78F12F8')
    computer = 'Macbook';
elseif strcmp(sid, '??')
    computer = 'Matt';
else
    computer = 'Brown';
end


end