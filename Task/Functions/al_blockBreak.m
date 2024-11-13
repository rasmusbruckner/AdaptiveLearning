function al_blockBreak(taskParam, currBlock)
%AL_BLOCKBREAK This function implements breaks between blocks
%
%   Input
%       taskParam: Task-parameter-object instance
%       currBlock: Current block number
%
%   Output
%       None

% Present text indicating the break
if taskParam.gParam.customInstructions
    taskParam.instructionText = taskParam.instructionText.giveBlockFeedback(taskParam.gParam.nBlocks, currBlock);
    txt = taskParam.instructionText.dynamicBlockTxt;
else
    txt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgängen geschafft.', currBlock, taskParam.gParam.nBlocks);
end

% Display above text
header = ' ';
feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end