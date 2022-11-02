classdef al_subject
    %AL_SUBJECT This class definition file specifies the 
    %   properties and methods of a subject object
    %
    %   A subject object contains general subject information and tests
    %   whether the subject information has correctly been specified.
    
    
    % Properties of the subject object
    % --------------------------------
    
    properties
        
        ID
        age
        sex
        group
        cBal
        rew
        testDay
        date
        session
        
    end
    
    % Methods of the subject object
    % --------------------------------
    methods
        
        function subobj = al_subject()
            %AL_GPARAM This function creates a subject object of
            % class al_subject

            subobj.ID = nan; 
            subobj.age = nan;
            subobj.sex = nan;
            subobj.group = nan; 
            subobj.cBal = nan; 
            subobj.rew = nan; 
            subobj.testDay = nan;
            subobj.date = nan;
            subobj.session = 1;
            
        end
    end
    
    methods
        function checkID(subobj, checkString)
            %CHECKID This function tests input related to the subject ID
            %
            %   If ID is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: subject object
            %       checkString: XX Comment
            %
            %   Output
            %       ~
            
            % Todo: Just check if not equal to 5 instead of both directions
            if numel(num2str(subobj.ID)) < 5 || numel(num2str(subobj.ID)) > 5
                error('ID: Please use five numbers!')
            end

            % Todo: Comment properly
            checkIdInData = checkString;
            fileNames = {checkIdInData.name};
            
            if  ~isempty(fileNames)
                error('Dataset already exists!');
            end
            
        end
        
        
        function checkGroup(subobj)
            %CHECKGROUP This function tests input related to the group
            %
            %   If group is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: subject object
            %
            %   Output
            %       ~


            if subobj.group ~= 0 && subobj.group ~= 1
                error('Group: "0" or "1"?');
            end

        end
        
        
        function checkSex(subobj)
            %CHECKSEX This function tests input related to the subject's
            % sex
            %
            %   If sex is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: subject object
            %
            %   Output
            %       ~

            if subobj.sex ~= 'm' && subobj.sex ~= 'f' && subobj.sex ~= 'd'
                error('Sex: "m", "f", or "d"?');
            end
            
        end
        
        function checkCBal(subobj)
            %CHECKCBAL This function tests input related to
            % counterbalancing
            %
            %   If cbal is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: subject object
            %
            %   Output
            %       ~

            % Todo: Since different versions have different cBals, 
            % this needs to be more general, maybe based on additional
            % input specifying how many conditions we have
            if subobj.cBal ~= 1 && subobj.cBal ~= 2 && subobj.cBal ~= 3 && subobj.cBal ~= 4
                error('cBal: 1, 2, 3, or 4?');
            end
            
        end
        
        function checkTestDay(subobj)
            %CHECKTESTDAY This function tests input related to the test day
            %
            %   If test day is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: subject object
            %
            %   Output
            %       ~

            if subobj.testDay ~= 1 && subobj.testDay ~= 2
                error('Day: 1 or 2?')
            end

        end
        
          % Does not seem to be necessary anymore
%         % Todo: This should be a static function
%         % I think not necessary anymore
%         function check_N_Trials(~, gParam)
%         if  (gParam.trials > 1 && mod(gParam.trials, 2)) == 1
%             msgbox('All trials must be even or equal to 1!');
%             return
%         end
%         end
    end
end
