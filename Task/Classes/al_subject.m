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
        gender
        group
        cBal
        rew
        startingBudget
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
            subobj.gender = nan;
            subobj.group = nan; 
            subobj.cBal = nan; 
            subobj.rew = nan; 
            subobj.startingBudget = nan;
            subobj.testDay = nan;
            subobj.date = nan;
            subobj.session = 1;
            
        end
    end
    
    methods
        function checkID(subobj, checkString, ID_len)
            %CHECKID This function tests input related to the subject ID
            %
            %   If ID is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: Subject object
            %       checkString: XX Comment
            %
            %   Output
            %       ~
            
            if ~(numel(subobj.ID) == ID_len) 
                error('ID: Please use %i digits!', ID_len)
            end

            fileNames = {checkString.name};            
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
            %       subobj: Subject object
            %
            %   Output
            %       ~


            if subobj.group ~= 1 && subobj.group ~= 2
                error('Group: "1" or "2"?');
            end

        end
        
        
        function checkGender(subobj)
            %CHECKGENDER This function tests input related to the subject's
            % gender
            %
            %   If gender is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: Subject object
            %
            %   Output
            %       ~

            if subobj.gender ~= 'm' && subobj.gender ~= 'f' && subobj.gender ~= 'd'
                error('Gender: "m", "f", or "d"?');
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
            %       subobj: Subject object
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
            %       subobj: Subject object
            %
            %   Output
            %       ~

            if subobj.testDay ~= 1 && subobj.testDay ~= 2
                error('Day: 1 or 2?')
            end

        end

        function checkRew(subobj)
            %CHECKREW This function tests input related to the reward
            %variable
            %
            %   If rewarad is incorrectly specified, the function returns
            %   an error. 
            %
            %   Input
            %       subobj: Subject object
            %
            %   Output
            %       ~

            if subobj.rew ~= 1 && subobj.rew ~= 2
                error('Rew: 1 or 2?')
            end

        end
        
    end
end
