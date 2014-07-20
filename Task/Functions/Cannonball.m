function Cannonball(taskParam, taskData, k)
% This function animates the cannonball shot. 
%   Detailed explanation goes here
  

    % ------------------------
    % Barrel Punkt
    % ------------------------
 zero = taskParam.gParam.zero;
   
 xTarget = ((taskParam.circle.rotationRad-5) * sind(taskData.distMean(k)));
 yTarget = ((taskParam.circle.rotationRad-5) * -cosd(taskData.distMean(k)));
 
 %xDistMean = ((taskParam.circle.rotationRad-5) * sind(taskData.distMean(k)));
 %yDistMean = ((taskParam.circle.rotationRad-5) * -cosd(taskData.distMean(k)));
 
 TargetSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xTarget, yTarget);
 
 
 Target = [xTarget yTarget]
 
 TargetSpotStart = taskParam.circle.outcCentSpotRect;
 
 
 TargetDist = TargetSpotEnd - TargetSpotStart;  

 % St = TargetDiff / 3
 Barrel = TargetSpotStart + TargetDist/3
 BallStart = TargetSpotStart + TargetDist/5

 
 CannonEndStart = taskParam.circle.cannonEndCent;
 CannonEnd = OffsetRect(taskParam.circle.cannonEndCent, xTarget, yTarget);
 CannonDist = CannonEnd - CannonEndStart
 Ding = CannonEndStart + ((CannonDist/6)*-1)
 %Zuendung = CannonEndStart + ((CannonDist/10)*-1)
 
 %Ding = TargetSpotStart + ((TargetDist/30)*-1)
 
 
 
 



 
BarrelLength = TargetDist / 3

BarrelWidth = 20

BarrelCenter = [(zero(1) + BarrelLength(1)/20) zero(2) + BarrelLength(2)/20]

%dstRect = CenterRectOnPoint(imageRect, BarrelCenter(1), BarrelCenter(2)); 
 
 %zero = [zero(1)+10 zero(2)]
 %Barrel = [Target zero]
 
 %target = OffsetRect(taskParam.circle.centSpotRectMean, xTarget, yTarget);
    
 

 

  
 %Screen('DrawTexture', taskParam.gParam.window, ShipTxt,[], dstRect, [], [], [], color);  %Boat
   
    
nFrames = 50%taskParam.circle.rotationRad-5  ;  
    
    
%xStart = taskParam.gParam.zero(1);
%yStart = taskParam.gParam.zero(2);
%OutcSpotStart = OffsetRect(taskParam.circle.outcCentSpotRect, xStart, yStart);
OutcSpotStart = taskParam.circle.outcCentSpotRect;


xEnd = ((taskParam.circle.rotationRad-5) * sind(taskData.outcome(k)));
yEnd = ((taskParam.circle.rotationRad-5) * (-cosd(taskData.outcome(k))));
OutcSpotEnd = OffsetRect(taskParam.circle.outcCentSpotRect, xEnd, yEnd);

%OutcSpotDiff = OutcSpotEnd - OutcSpotStart; 
OutcSpotDiff = OutcSpotEnd - BallStart; 

Step = OutcSpotDiff / nFrames;
OutcSpotAct = BallStart;



%%%%%%%%%%
RadWidth = 5
RadLength = BarrelLength / 4

Radverschiebung = CannonEnd - CannonEndStart
Radverschiebung = [Radverschiebung(1)*-1 Radverschiebung(2)]

imageRect = [0 0 BarrelWidth sqrt(BarrelLength(1)^2 + BarrelLength(2)^2)];
RadImageRect = [0 0 RadWidth sqrt(RadLength(1)^2 + RadLength(2)^2)];

dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
%radRect = CenterRectOnPoint(RadImageRect, taskParam.gParam.windowRect);
%radRect = OffsetRect(radRect, Radverschiebung(1), Radverschiebung(2))
%radRect = OffsetRect(radRect, 20, 40)
%radRect = [radRect(1) radRect(2) radRect(3) radRect(4)]
%radRect = radRect + 10
 TargetDist = zero - Target
 BarrelLength = TargetDist / 3
  %BarrelLength = 60
 BarrelCenter = [(zero(1)+BarrelLength(1)/2) zero(2)+BarrelLength(2)/2]

 BarrelWidth = 30
 %Barrel = zero + BarrelLength
% 
%BarrelRect = [0 0 BarrelLength(1) BarrelLength(2)]
BarrelRect = [0 0 10 10]

BarrelSpot = CenterRectOnPoint(BarrelRect, Barrel(1), Barrel(2));

rohr = zeros(10) 
rad = zeros(10) + 250
    
rohrTxt = Screen('MakeTexture', taskParam.gParam.window, rohr)
radTxt = Screen('MakeTexture', taskParam.gParam.window, rad)


%RadRect = [0 0 3 10]
%%%%%%%%%%%%%%%%%%%%%%%

imageRect = [0 0 120 120];
dstRect = CenterRect(imageRect, taskParam.gParam.windowRect);
[Ship, ~, alpha]  = imread('kanone.png');
Ship(:,:,4) = alpha(:,:);
Screen('BlendFunction', taskParam.gParam.window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
ShipTxt = Screen('MakeTexture', taskParam.gParam.window, Ship);
%Screen('DrawTexture', taskParam.gParam.window, ShipTxt,[], dstRect, [], [], [], []);  %Boat


%%%%%%%%%%%%%%%%%%%%%%










for i = 1:nFrames
    %DrawCross(taskParam)
    %Screen('DrawTexture', taskParam.gParam.window, rohrTxt, [], dstRect, taskData.distMean(k))  
    %Screen('DrawTexture', taskParam.gParam.window, radTxt, [], radRect, taskData.distMean(k), [], [], [255 0 0 ])  

    %Screen('FillRect', taskParam.gParam.window, [0 0 0], [200 200 600 600])
    %Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), Barrel(1), Barrel(2), 7); %xNeedle, yNeedle  720, 450, 720 , 250 
    %xAct = ((taskParam.circle.rotationRad-5) * sin(taskData.outcome(k)*taskParam.circle.unit));
%     yAct = ((taskParam.circle.rotationRad-5) * (-cos(outcome*taskParam.circle.unit)));
    %OutcSpotAct = OffsetRect(taskParam.circle.outcCentSpotRect, xAct, yAct);
    
    Screen('DrawTexture', taskParam.gParam.window, ShipTxt,[], dstRect, taskData.distMean(k), [], [0], [0 0 0], [], []);  %Boat

    OutcSpotAct = OutcSpotAct + Step;
    DrawCircle(taskParam)
    Screen('FillOval', taskParam.gParam.window, [0 0 0], OutcSpotAct);
    %Screen('FillOval', taskParam.gParam.window, [255 0 0], Zuendung)
    %Screen('FillOval', taskParam.gParam.window, [0 0 0], Ding)

    Screen('DrawingFinished', taskParam.gParam.window);
    t = GetSecs;
    Screen('Flip', taskParam.gParam.window, t + 0.01);  

end




% zero = taskParam.gParam.zero;
% yNeedle = taskParam.circle.rotationRad * (-cos(distMean*taskParam.circle.unit));            %(outcome(i));
% xNeedle = taskParam.circle.rotationRad * sin(distMean*taskParam.circle.unit);
% meanSpot = OffsetRect(taskParam.circle.centSpotRectMean, xNeedle, yNeedle);
% Screen('FillOval', taskParam.gParam.window, [0 0 127], meanSpot);
% Screen('DrawLine', taskParam.gParam.window, [0 0 0], zero(1), zero(2), meanSpot(1)+1, meanSpot(2)+1, 2); %xNeedle, yNeedle  720, 450, 720 , 250
