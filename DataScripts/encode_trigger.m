function [events, encoded_trigger] = encode_trigger(summary_trigger)
%UNTITLED Convert summary trigger coded in decimal representation to base representation

% Subtract 100, because this was added to obtain three digits
encoded_trigger = summary_trigger - 100;

% Convert from decimal to base representation
%encoded_trigger = dec2base(encoded_trigger,2);
encoded_trigger = str2num(dec2base(encoded_trigger,2));


%initialize 
condition = 0
cp = 0;
hit = 0;
actRew = 0;
catchTrial = 0;

encoded_trigger_str = num2str(encoded_trigger)

code = [0,0,0,0,0]
if encoded_trigger < 10
    code(end) = encoded_trigger
elseif encoded_trigger >= 10 && encoded_trigger < 100

    code(end-1) = str2num(encoded_trigger_str(end-1))
    code(end) = str2num(encoded_trigger_str(end))
    
elseif encoded_trigger >= 100 && encoded_trigger < 1000

    code(end-2) = str2num(encoded_trigger_str(end-2))
    code(end-1) = str2num(encoded_trigger_str(end-1))
    code(end) = str2num(encoded_trigger_str(end))
    
elseif encoded_trigger >= 1000 && encoded_trigger < 10000

    code(end-3) = str2num(encoded_trigger_str(end-3))
    code(end-2) = str2num(encoded_trigger_str(end-2))
    code(end-1) = str2num(encoded_trigger_str(end-1))
    code(end) = str2num(encoded_trigger_str(end))

elseif encoded_trigger >= 10000 && encoded_trigger < 100000
    code(end-4) = str2num(encoded_trigger_str(end-4))
    code(end-3) = str2num(encoded_trigger_str(end-3))
    code(end-2) = str2num(encoded_trigger_str(end-2))
    code(end-1) = str2num(encoded_trigger_str(end-1))
    code(end) = str2num(encoded_trigger_str(end))
else
    code = [0,0,0,0,0,0]
    code(end-5) = str2num(encoded_trigger_str(end-5))
    code(end-4) = str2num(encoded_trigger_str(end-4))
    code(end-3) = str2num(encoded_trigger_str(end-3))
    code(end-2) = str2num(encoded_trigger_str(end-2))
    code(end-1) = str2num(encoded_trigger_str(end-1))
    code(end) = str2num(encoded_trigger_str(end))
end

% das muss dann für 1000000 noch angepasst werden!
condition = code(1);
cp = code(2);
hit = code(3);
actRew = code(4);
catchTrial = code(5);


% if encoded_trigger == 0
%     % das muss 00000 sein, also keine veränderung
%     % kann man also wegmachen
% 
% elseif encoded_trigger == 1
%     % muss 00001 sein. also nur letzten verändern
%     
%     catchTrial = 1;
%     
% elseif encoded_trigger == 10
%     
%     actRew = 1;
%     
% elseif encoded_trigger == 11
%     % muss 00011 sein, also zwei letzte
%     
%     actRew = 1;
%     catchTrial = 1;
%     
% elseif encoded_trigger == 100
%     
%     hit = 1;
%     
% elseif encoded_trigger == 101
%     
%     hit = 1;
%     catchTrial = 1;
% 
% elseif encoded_trigger == 110
%     
%     hit = 1;
%     actRew = 1;
% 
% elseif encoded_trigger == 111
%     
%     hit = 1;
%     actRew = 1;
%     catchTrial = 1;
%     
% elseif encoded_trigger == 1000
%     cp = 1;
% 
% elseif encoded_trigger == 1001
%     cp = 1;
%     catchTrial = 1;
%     
% elseif encoded_trigger == 1011
%     cp = 1;
%     actRew = 1;
%     catchTrial = 1;
%     
% elseif encoded_trigger == 1010
%     cp = 1;
%     actRew = 1;
%     
% elseif encoded_trigger == 1100
%     cp = 1;
%     hit = 1;
%     
% elseif encoded_trigger == 1101
%     cp = 1;
%     hit = 1;
%     catchTrial = 1;
%     
% elseif encoded_trigger == 1110
%     cp = 1;
%     hit = 1;
%     actRew = 1;
%     
% elseif encoded_trigger == 1111
%     cp = 1;
%     hit = 1;
%     actRew = 1;
%     catchTrial = 1;
%     
% elseif strcmp(encoded_trigger, '10011011')
%     
%     condition = nan;
%     cp = nan;
%     hit = nan;
%     actRew = nan;
%     catchTrial = nan;
% 
% 
%    
% 
% elseif strcmp(encoded_trigger, '4')
%     
%     condition = 'main';
%     cp = 0;
%     hit = 1;
%     actRew = 0;
%     catchTrial = 0;
% 
% elseif strcmp(encoded_trigger, '10')
%     
%     condition = 'main';
%     cp = 0;
%     hit = 0;
%     actRew = 1;
%     catchTrial = 0;
%     
% 
%     
% elseif strcmp(encoded_trigger, '101')
%     
%     catchTrial = 1;
%     actRew = 0;
%     hit = 1;
%     cp = 0;
%     condition = 'main'; 
% 
% elseif strcmp(encoded_trigger, '110')
%     
%     catchTrial = 0;
%     actRew = 1;
%     hit = 1;
%     cp = 0;
%     condition = 'main';     
% 
% 
%     
% else 
%     
% if length(encoded_trigger) == 4
% 
% % If length == 4, first digit must have been 0; add this
% 
%     encoded_trigger = ['0', encoded_trigger];
% end
% % List associated events
% % ----------------------
% 
% % Check catch trials
% if strcmp(encoded_trigger(end), '1')
%     catchTrial = 1;
% else
%     catchTrial = 0;
% end
% 
% % Check actual reward
% if strcmp(encoded_trigger(end-1), '1')
%     actRew = 1;
% else
%     actRew = 0;
% end
% 
% % Check hit versus miss
% if strcmp(encoded_trigger(end-2), '1')
%     hit = 1;
% else
%     hit = 0;
% end
% 
% % Check length of trigger
% if length(encoded_trigger) == 6
%     % If length = 6, then we know that we are in contition "followCannon"
%     
%     % Check change point
%     if strcmp(encoded_trigger(3), '1')
%         cp = 1;
%     else
%         cp = 0;
%     end
% 
%     % Save condition
%     condition = 'followCannon';
%     
% else
%     % If length = 5, we are either in condition "followCannon" or "main" -
%     % check this first
%     if strcmp(encoded_trigger(1), '1')
%        condition = 'followOutcome';
%     else 
%        condition = 'main'; 
%     end
%     
%     % Check change point
%     if strcmp(encoded_trigger(2), '1')
%         cp = 1;
%     else
%         cp = 0;
%     end 
% end
%end   
% Put results into structure
events = struct('condition', condition, 'cp', cp, 'hit', hit, 'actRew', actRew, 'catchTrial', catchTrial);
end

