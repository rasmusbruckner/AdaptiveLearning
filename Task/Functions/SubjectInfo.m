function [subjInfo] = SubjectInfo
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



    prompt={'ID:','Alter:', 'Geschlecht:'};
    name='SubjInfo';
    numlines=1;
    defaultanswer={'9999','99', 'M'};
    subjInfo=inputdlg(prompt,name,numlines,defaultanswer);





end

