classdef al_keys
    %AL_KEYS This class definition file specifies the 
    % properties and methods of a keys object
    %
    %   A keys object contains the key codes.
    
    % Properties of the subject object
    % --------------------------------
    
    properties
        
        delete
        rightKey
        keySpeed
        rightArrow
        leftArrow
        rightSlowKey
        slowKeySpeed
        leftKey
        leftSlowKey
        space
        enter        
        s
        kbDev

    end
    
    % Methods of the conditions object
    % --------------------------------
    
    methods
        
        function keysobj = al_keys()
            %AL_KEYS This function creates a keys object of
            % class keys
            
            KbName('UnifyKeyNames')
            keysobj.delete = KbName('DELETE');
            keysobj.rightKey = KbName('j');
            keysobj.keySpeed = 0.75;
            keysobj.rightArrow = KbName('RightArrow');
            keysobj.leftArrow = KbName('LeftArrow');
            keysobj.rightSlowKey = KbName('h');
            keysobj.slowKeySpeed = 0.1;
            keysobj.leftKey = KbName('f');
            keysobj.leftSlowKey = KbName('g');
            keysobj.space = KbName('Space');
            keysobj.enter = 37;
            keysobj.s = 40;  
                      
        end

        function keysobj = al_kbdev(keysobj)
            % This function detects the keyboard devide, necessary on 
            % some Macs

            kbdevs = [];
            devs = PsychHID('Devices');
            for d = 1:numel( devs )
                if strcmp(devs(d).usageName,'Keyboard')
                    kbdevs(end+1) = devs(d).index;
                end
            end
            
            if numel( kbdevs > 1 )
              keysobj.kbDev = -1; % "merge" all keyboard in KbCheck
            else
              keysobj.kbDev = kbdevs;
            end
        end

    end
end





