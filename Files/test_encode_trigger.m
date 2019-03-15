% test encode trigger

% Main:
% 0: 0,0,0,0,0
% 1: 0,0,0,0,1
% 2: 0,0,0,1,0
% 3: 0,0,0,1,1
% 4: 0,0,1,0,0
% 5: 0,0,1,0,1
% 6: 0,0,1,1,0
% 7: 0,0,1,1,1
% 8: 0,1,0,0,0
% 9: 0,1,0,0,1
%10: 0,1,0,1,0
%11: 0,1,0,1,1
%12: 0,1,1,0,0
%13: 0,1,1,0,1
%14: 0,1,1,1,0
%15: 0,1,1,1,1
% ok, alle fälle durchgetestet

% followOutcome: 
%15: 1,1,1,1,1

% 0. - 100 0,0,0,0,0 
digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 1. - 101 0,0,0,0,1 
digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 2. - 102 0,0,0,1,0
digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 3. 103 - 0, 0,0,1,1 
digit1 = 0;
digit2 = 0;
digit3 = 0;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 4. 104, 0,0,1,0,0 
digit1 = 0;
digit2 = 0;
digit3 = 1;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)


% 5. 105 - 0,0,1,0,1
digit1 = 0;
digit2 = 0;
digit3 = 1;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 6. 106 - 0,0,1,1,0
digit1 = 0;
digit2 = 0;
digit3 = 1;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)



% 7. 107, 0,0,1,1,1 
digit1 = 0;
digit2 = 0;
digit3 = 1;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 8. 108 - 0,1,0,0,0 
digit1 = 0;
digit2 = 1;
digit3 = 0;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 9. 109 - 0,1,0,0,1
digit1 = 0;
digit2 = 1;
digit3 = 0;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 10. 110 - 0,1,0,1,0
digit1 = 0;
digit2 = 1;
digit3 = 0;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)


% 11. 111 - 0,1,0,1,1
digit1 = 0;
digit2 = 1;
digit3 = 0;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 12. 112 - 0,1,1,0,0
digit1 = 0;
digit2 = 1;
digit3 = 1;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 13. 113 - 0,1,1,0,1
digit1 = 0;
digit2 = 1;
digit3 = 1;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 14. 114 - 0,1,1,1,0
digit1 = 0;
digit2 = 1;
digit3 = 1;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 15. 115 - 0,1,1,1,1 
digit1 = 0;
digit2 = 1;
digit3 = 1;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)












% 16: 116 - 1,0,0,0,0 
digit1 = 1;
digit2 = 0;
digit3 = 0;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 17: 117 - 1,0,0,0,1 
digit1 = 1;
digit2 = 0;
digit3 = 0;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 18: 118 - 1,0,0,1,0 
digit1 = 1;
digit2 = 0;
digit3 = 0;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 19: 119 - 1,0,0,1,1 
digit1 = 1;
digit2 = 0;
digit3 = 0;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 20: 120 - 1,0,1,0,0 
digit1 = 1;
digit2 = 0;
digit3 = 1;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)


% 21: 121 1,0,1,0,1 
digit1 = 1;
digit2 = 0;
digit3 = 1;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 22: 122 - 1,0,1,1,0 
digit1 = 1;
digit2 = 0;
digit3 = 1;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)


% 23: 123 - 1,0,1,1,1 
digit1 = 1;
digit2 = 0;
digit3 = 1;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)






% 24: 124 - 1,1,0,0,0 
digit1 = 1;
digit2 = 1;
digit3 = 0;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)


% 25: 125, 1,1,0,0,1 
digit1 = 1;
digit2 = 1;
digit3 = 0;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)


% 26: 126 - 1,1,0,1,0 
digit1 = 1;
digit2 = 1;
digit3 = 0;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 27: 127 - 1,1,0,1,1 
digit1 = 1;
digit2 = 1;
digit3 = 0;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 28: 128 - 1,1,1,0,0 
digit1 = 1;
digit2 = 1;
digit3 = 1;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 29: 129 - 1,1,1,0,1 
digit1 = 1;
digit2 = 1;
digit3 = 1;
digit4 = 0;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)



% 30: 130 - 1,1,1,1,0 
digit1 = 1;
digit2 = 1;
digit3 = 1;
digit4 = 1;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)

% 31, 131 - 1,1,1,1,1 
digit1 = 1;
digit2 = 1;
digit3 = 1;
digit4 = 1;
digit5 = 1;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)








% 32, - 132 10,0,0,0,0
digit1 = 10;
digit2 = 0;
digit3 = 0;
digit4 = 0;
digit5 = 0;
trigger =  base2dec(strcat(num2str(digit1),num2str(digit2),num2str(digit3), num2str(digit4), num2str(digit5)), 2) + 100
encode_trigger(trigger)