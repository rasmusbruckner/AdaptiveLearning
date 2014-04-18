function  cases( counterPage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

switch counterPage
    
    
    case '1',
    
    Willkommen='Schiffeversenken';
    DrawFormattedText(taskParam.window, Willkommen, 'center', 'center');
    Screen('Flip', taskParam.window);
   

    case '2'
        
        
    %Second screen.

    Screen('FillRect', taskParam.window, [224,255,255], [100 50 1340 300] )
    Schatzsuche='Auf rauer See möchtest du möglichst viele Schiffe einer Schiffsflotte versenken.\n\nAls Hilfsmittel benutzt du einen Radar, der dir einen Hinweis darauf gibt, wo sich\n\ndie Schiffsflotte aufhält.';
    DrawFormattedText(taskParam.window,Schatzsuche,200,100);
    DrawFormattedText(taskParam.window,PressEnter,'center',800);
    DrawCircle(taskParam.window)
    DrawCross(taskParam.window)
    DrawHand(taskParam, distMean)
    Screen('Flip', taskParam.window);
    
%     [ keyIsDown, seconds, keyCode ] = KbCheck;
%     if keyIsDown
%         if find(keyCode) == 40
%             break
%             
%             
%         end
%         
%     end
%     
end

end

