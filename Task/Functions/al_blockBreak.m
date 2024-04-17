function al_blockBreak(taskParam, half, currBlock)
%AL_BLOCKBREAK This function implements breaks between blocks
%
%   Input
%       taskParam: Task-parameter-object instance
%       half: Block half
%       currBlock: Current block number
%
%   Output
%       None

% Present text indicating the break
if half == 1
    txt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgängen geschafft.', currBlock, taskParam.gParam.nBlocks*2);
elseif half == 2
    txt = sprintf('Kurze Pause!\n\nSie haben bereits %i von insgesamt %i Durchgängen geschafft.', currBlock+taskParam.gParam.nBlocks, taskParam.gParam.nBlocks*2);
else
    error('half parameter undefined')
end

% Display above text
header = ' ';
feedback = true;
al_bigScreen(taskParam, header, txt, feedback);

end