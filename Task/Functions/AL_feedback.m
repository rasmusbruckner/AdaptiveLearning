function [txt, header] = al_feedback(Data, taskParam, subject, condition, whichBlock)
%AL_FEEDBACK   Displays feedback at the end of a block

if ~exist('whichBlock', 'var')
    whichBlock = ones(length(Data.hit),1);
end
    
% compute hits etc.
hits = sum(Data.hit(whichBlock == 1));
rewTrials = sum(Data.actRew(whichBlock == 1));
noRewTrials = sum(Data.actRew(whichBlock == 1));
rewCatches = round(max(Data.accPerf(whichBlock))/taskParam.gParam.rewMag);
noRewCatches = hits - rewCatches;
maxMon = (length(find(Data.shieldType(whichBlock == 1)))...
    * taskParam.gParam.rewMag);

if isequal(taskParam.gParam.taskType, 'oddball')...
        || isequal(taskParam.gParam.taskType, 'reversal')...
        || isequal(condition, 'reversalPractice')...
        || isequal(condition, 'reversalPracticeNoise')
    
    header = 'Performance';
    if subject.rew == 1
        colRewCap = 'Blue';
        colNoRewCap = 'Green';
    elseif subject.rew == 2
        colRewCap = 'Green';
        colNoRewCap = 'Blue';
    end
    
    if isequal(condition, 'practice')...
            || isequal(condition, 'practiceNoOddball')...
            || isequal(condition, 'practiceOddball')...
            || isequal(condition, 'reversalPractice')
        wouldHave = ' would have ';
    else
        wouldHave = ' ';
    end
    txt = sprintf(['%s shield catches: %.0f of '...
        '%.0f\n\n%s shield catches: %.0f of '...
        '%.0f\n\nIn this block you%searned %.2f of '...
        'possible $ %.2f.'], colRewCap, rewCatches,...
        rewTrials, colNoRewCap, noRewCatches, noRewTrials,...
        wouldHave, max(Data.accPerf), maxMon);
    
elseif isequal(taskParam.gParam.taskType, 'dresden')
    
    header = 'Leistung';
    if subject.rew == 1
        colRewCap = 'goldenen';
        colNoRewCap = 'grauen';
    elseif subject.rew == 2
        colRewCap = 'silbernen';
        colNoRewCap = 'gelben';
    end
    
    if isequal(condition, 'mainPractice')...
            || isequal(condition, 'followOutcomePractice')...
            ||  isequal(condition, 'followCannonPractice')
        wouldHave = 'hättest';
    else
        wouldHave = 'hast ';
    end
    
    if isequal(condition, 'mainPractice')...
            || isequal(condition, 'followCannonPractice')...
            || isequal(condition, 'main')...
            || isequal(condition, 'followCannon')
        
        schildVsKorb = 'Schild';
        gefangenVsGesammelt = 'abgewehrt';
        
    elseif isequal(condition, 'followOutcomePractice')...
            || isequal(condition, 'followOutcome')
        
        schildVsKorb = 'Korb';
        gefangenVsGesammelt = 'aufgesammelt';
    end
    
    if isequal(subject.group, '1')
        if isequal(condition, 'mainPractice')...
                || isequal(condition, 'followOutcomePractice')...
                ||  isequal(condition, 'followCannonPractice')
            wouldHave = 'hättest';
        else
            wouldHave = 'hast ';
        end
        
        txt = sprintf(['Weil du %.0f von %.0f Kugeln mit dem %s %s '...
            '%s hast,\n\n%s du %.2f von maximal %.2f Euro gewonnen.' ], rewCatches,...
            rewTrials, colRewCap, schildVsKorb, gefangenVsGesammelt, wouldHave, max(Data.accPerf), maxMon);
    else
        if isequal(condition, 'mainPractice')...
                || isequal(condition, 'followOutcomePractice')...
                ||  isequal(condition, 'followCannonPractice')
            wouldHave = 'hätten';
        else
            wouldHave = 'haben';
        end
        
        txt = sprintf(['Weil Sie %.0f von %.0f Kugeln mit dem %s %s '...
            '%s haben,\n\n%s Sie %.2f von maximal %.2f Euro gewonnen.'],...
            rewCatches,...
            rewTrials, colRewCap, schildVsKorb, gefangenVsGesammelt,...
            wouldHave, max(Data.accPerf), maxMon);
    end
    
elseif isequal(taskParam.gParam.taskType, 'chinese')
    
    header = 'Ergebnis';
    
    if isequal(condition, 'chinesePractice_1') ||...
            isequal(condition, 'chinesePractice_2') ||...
            isequal(condition, 'chinesePractice_3') ||...
            isequal(condition, 'chinesePractice_4')
        txt = sprintf(['Raketen abgewehrt: %.0f von %.0f.\n\n'...
            'In diesem Block hättest du %.2f von maximal %.2f Euro gewonnen.'],...
            hits, length(Data.hit), max(Data.accPerf), maxMon);
            
    elseif isequal(condition, 'chinese') 
           
        txt = sprintf(['Raketen abgewehrt: %.0f.\n\n'...
            'In diesem Block hast du %.2f von durchschnittlich 5.00 Euro gewonnen.'],...
            hits,  hits*taskParam.gParam.rewMag);
    end
    
elseif isequal(taskParam.gParam.taskType, 'ARC')
    
    header = 'Performance';
    if isequal(condition, 'mainPractice_1') ||...
            isequal(condition, 'mainPractice_2') ||...
            isequal(condition, 'mainPractice_3') 
        wouldHave = ' would have ';
    else
        wouldHave = ' ';
    end
    
    txt = sprintf(['Catches: %.0f of '...
        '%.0f\n\nIn this block you%searned £%.2f of '...
        'possible £%.2f.'], hits, length(whichBlock),...
        wouldHave, max(Data.accPerf), maxMon);
    
end


