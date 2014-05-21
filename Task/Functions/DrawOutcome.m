function DrawOutcome(taskParam, outcome)
% This function calculates the position of the outcome (the boat).
    % The idea is that we express 360 degrees as a 


%xOutc = taskParam.rotationRad * cos(outcome); 
%yOutc = taskParam.rotationRad * sin(outcome);  


%degree = 360/(2*pi); % Divide 360 degrees by length of the line which is used to define the circle   

OutcSpot = outcome + 77 ; % Multiply the outcome with    

% nicht mehr ganz richtig, weil boot jetzt 31.41.. ist
%OutcSpot = OffsetRect(taskParam.outcCentSpotRect, xOutc, yOutc);

screensize = get(0,'MonitorPositions'); 
screensize = (screensize(3:4));

zero = screensize / 2;

Screen('FrameArc',taskParam.gParam.window,[0 0 0],[zero(1) - 115, zero(2) - 115, zero(1) + 115, zero(2) + 115],OutcSpot, 26, 30, [], [])
                                            %605 335 835 565

end


%% position
% einheit = wieviel grad muss ich gehen, wenn outcome um 1 zunimmt?
% daher: outcome * einheit --> ist bei 0 auf Bildschirm weil 90° verschoben
% daher + 90 aber weil boot 30 grad hat nochmal 90 - (30/2) = 75

% wenn boot 22.9183 ist dann 90 - (22.9183/2) = 78.5409
           % 45.8366            90 - (45.8366/2) =  67.0817

% Ship size
% es geht um die Berechnung des Winkels  
%
%
%
% % einheit = wieviel grad muss ich gehen, wenn outcome um 1 zunimmt?
%
% Eine sd entspricht .4 Einheiten (wurde von mir halt so festgelegt) 
% (360/(2*pi))*.4 =   22.9183
% 
% bei sd = .8  
% (360/(2*pi))*.8 = 45.8366
%%%%%noch einbauen, sonst stimmt der rest nicht mehr