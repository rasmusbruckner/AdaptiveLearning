function counterPage = counter

counterPage = 1;


ListenChar(2);

   
     [ keyIsDown, seconds, keyCode ] = KbCheck;
    if find(keyCode)==40 % don't know why it does not understand return or enter?
        counterPage = counterPage + 1
        KbReleaseWait();
    elseif find(keyCode)==42
        counterPage = counterPage - 1
        KbReleaseWait();
    end
    
    

end