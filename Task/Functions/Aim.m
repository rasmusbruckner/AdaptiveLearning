function Aim(taskParam, parameter)
% This function draws the last position of the outcome (the black tick mark).

% wegen rotAngle

xAim = ((taskParam.circle.rotationRad-35) * sin(parameter*taskParam.circle.unit));
yAim = ((taskParam.circle.rotationRad-35) * (-cos(parameter*taskParam.circle.unit)));

AimPosition = OffsetRect(taskParam.circle.centBoatRect, xAim, yAim);

Screen('DrawTexture',taskParam.gParam.window,taskParam.aimTxt, [], AimPosition,parameter, [], [0], [0 0 0], [], []) %605 335 835 565 taskParam.circle.outcSize

end

