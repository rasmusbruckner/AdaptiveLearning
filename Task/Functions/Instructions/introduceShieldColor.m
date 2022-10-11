function Data = introduceShieldColor(taskParam, Data, header, txt)
%INTRODUCESHIELDCOLOR   This function introduce the color of the shield to participants
%
%   Input
%       taskParam: structure containing task parameters
%       subject: structure containing subject-specific information
%       screenIndex: indicates current sceen of instruction phase
%       Data: data from the previous trials
%
%   Output
%       screenIndex: updated screenIndex
%       Data: data from the previous trials


feedback = false;
fw = al_bigScreen(taskParam, header, txt, feedback);
if fw == 1
    %screenIndex = screenIndex + 1;
elseif bw == 1
    %screenIndex = screenIndex - 7;
end
WaitSecs(0.1);
end