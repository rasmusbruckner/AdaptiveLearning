%% Instructions section.
function instructions


% Set text display options.
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, 24);  

% Open a new window.
[ window, windowRect ] = Screen('OpenWindow', 0);

Instructions = cell(1,3);
    
Willkommen='Schatzsuche';
Schatzsuche='Du gehst auf Schatzsuche. \n\n Dazu benutzt du einen Kompass, um den Weg zu einem der Schätze zu finden.';
pressSpace='Weiter mit Leertaste';    
  

Instructions={Willkommen; Schatzsuche; pressSpace}  
assignin ('base','Instructions',Instructions);
    




%for 
    k = 1%:length(Instructions)
        
    
        if k == 1;
        
            DrawFormattedText(window, Instructions{1}, 'center', 'center'); 
    
             Screen('Flip', window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;

        if keyIsDown    
            if keyCode(space)
            %break
            end
        end
            
        else
        
            DrawFormattedText(window, Instructions{i}, 'center', 100); 
            DrawFormattedText(window, pressSpace, 'center', 800);
            xHand = rotationRadius * cos(4);           
            yHand = rotationRadius * sin(4);   
            drawBackground
            drawHand
        
        
        Screen('Flip', window);
        
        [ keyIsDown, seconds, keyCode ] = KbCheck;

        if keyIsDown    
            if keyCode(space)
            %break
            end
        end
        
        end
        
        
%end


 %DrawFormattedText(window,Schatzsuche,'center', 100);
        
        
        
        %DrawFormattedText(window, pressSpace, 'center', 800); 
        %Screen('Flip', window);
        

%{
    while k > 2
        
        xHand = rotationRadius * cos(4);            %(outcome(i));
        yHand = rotationRadius * sin(4);   
           
    
        DrawFormattedText(window, pressSpace, 'center', 800); 
        %DrawFormattedText(window,Schatzsuche,'center', 100);
        drawBackground
        drawHand
        Screen('Flip', window);
        
        
        DrawFormattedText(window, pressSpace, 'center', 800); 
        Screen('Flip', window);
        end
        
    
    end


%intr=fopen('instruktionen.txt');   
        %text=fscanf(intr,'%c'); 
        %DrawFormattedText(window,text,'center','center');
    
%Wait until all keys are released to prevent input from instructions block.
KbReleaseWait();



%}




%{

    % Contol blue spot.
    while 1
   
    xBlue = rotationRadius * cos(rotationAngle);
    yBlue = rotationRadius * sin(rotationAngle);
    xGreen = rotationRadius * cos(outcome(i)); 
    yGreen = rotationRadius * sin(outcome(i));   
    xHand = rotationRadius * cos(distMean(i));            %(outcome(i));
    yHand = rotationRadius * sin(distMean(i));        %(outcome(i));
    
        
        
    drawBackground
    
    
    drawHand
    
    
    blueSpot
   
    Screen('Flip', window);

    [ keyIsDown, seconds, keyCode ] = KbCheck;

        if keyIsDown
            if keyCode(rightKey)
                if rotationAngle < 2 * pi
                    rotationAngle = rotationAngle + 0.02; %0.02
                else
                    rotationAngle = 0;
                end
            elseif keyCode(leftKey)
                if rotationAngle > 0
                    rotationAngle = rotationAngle - 0.02;
                else
                    rotationAngle = 2 * pi;
                end
            elseif keyCode(space) %Log position of blue spot which is prediction of participant
                prediction(i) = rotationAngle;
                break;
            end

        end

    end
    
    
    drawBackground
    
    
    drawHand
    
    
    greenSpot
    blueSpot
    Screen('Flip', window);
    WaitSecs(1);
    
    %Calculate prediction error and learning rate
    predErr(i)=prediction(i) - outcome(i);
    predErr(i)=sqrt((predErr(i)^2));
    if i >= 2 
    learnR(i)= (prediction(i) - prediction(i-1))/predErr(i-1);
    learnR(i)=sqrt(learnR(i)^2);
    end
    
end

%Show outro.
%outro

%Plot Behavior
%plotBehavior

    
%%%%%%%%%%%%%%%%%%%   
%%% End of Task %%%
%%%%%%%%%%%%%%%%%%%

%}

end
