function al_indicateDresdenCondition(taskParam, txt)
% AL_INDICATEDRESDENCONDITION This function indicates the current condition
% in the Dresden version
%
%   Input
%       taskParam: Task-parameter-object instance
%       txt: Header text
%
%   Output
%       None
%
%   This function will be extended when I update the Dresden code.


header = txt;
txt = 'Placeholder text';
feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end