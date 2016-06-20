function [txt, header] = Feedback(Data, taskParam, subject, condition)

hits = sum(Data.hit == 1);
rewTrials = sum(Data.actRew == 1);
noRewTrials = sum(Data.actRew == 2);
rewCatches = max(Data.accPerf)/taskParam.gParam.rewMag;
noRewCatches = hits - rewCatches;
maxMon = (length(find(Data.shieldType == 1))...
    * taskParam.gParam.rewMag);

%if taskParam.gParam.oddball
if isequal(taskParam.gParam.taskType, 'oddball') || isequal(taskParam.gParam.taskType, 'reversal') || isequal(condition, 'reversalPractice') || isequal(condition, 'reversalPracticeNoise')
    header = 'Performance';
    if subject.rew == 1
        colRewCap = 'Blue';
        colNoRewCap = 'Green';
    elseif subject.rew == 2
        colRewCap = 'Green';
        colNoRewCap = 'Blue';
    end
    
    if isequal(condition, 'practice') || isequal(condition, 'practiceNoOddball') || isequal(condition, 'practiceOddball') || isequal(condition, 'reversalPractice')
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
    %condition
    
else
    
    header = 'Leistung';
    if subject.rew == 1
        colRewCap = 'goldenen';
        colNoRewCap = 'grauen';
    elseif subject.rew == 2
        colRewCap = 'silbernen';
        colNoRewCap = 'gelben';
    end
    
    
    
    if isequal(condition, 'mainPractice') || isequal(condition, 'followOutcomePractice') ||  isequal(condition, 'followCannonPractice')
        wouldHave = 'hättest';
    else
        wouldHave = 'hast ';
    end
    
    if isequal(condition, 'mainPractice') || isequal(condition, 'followCannonPractice') || isequal(condition, 'main') || isequal(condition, 'followCannon')
        
        schildVsKorb = 'Schild';
        gefangenVsGesammelt = 'abgewehrt';
        
    elseif isequal(condition, 'followOutcomePractice') || isequal(condition, 'followOutcome')
        
        schildVsKorb = 'Korb';
        gefangenVsGesammelt = 'aufgesammelt';
        
    end
    
    
    if isequal(subject.group, '1')
        if isequal(condition, 'mainPractice') || isequal(condition, 'followOutcomePractice') ||  isequal(condition, 'followCannonPractice')
            wouldHave = 'hättest';
        else
            wouldHave = 'hast ';
        end
        
        txt = sprintf(['Weil du %.0f von %.0f Kugeln mit dem %s %s '...
            '%s hast,\n\n%s du %.2f von maximal %.2f Euro gewonnen.' ], rewCatches,...
            rewTrials, colRewCap, schildVsKorb, gefangenVsGesammelt, wouldHave, max(Data.accPerf), maxMon);
    else
        if isequal(condition, 'mainPractice') || isequal(condition, 'followOutcomePractice') ||  isequal(condition, 'followCannonPractice')
            wouldHave = 'hätten';
        else
            wouldHave = 'haben';
        end
        txt = sprintf(['Weil Sie %.0f von %.0f Kugeln mit dem %s %s '...
            '%s haben,\n\n%s Sie %.2f von maximal %.2f Euro gewonnen.' ], rewCatches,...
            rewTrials, colRewCap, schildVsKorb, gefangenVsGesammelt, wouldHave, max(Data.accPerf), maxMon);
    end
    
    
end
end


