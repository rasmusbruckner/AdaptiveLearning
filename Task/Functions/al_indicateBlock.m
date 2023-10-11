function block = al_indicateBlock(i, blockIndices)
%AL_INDICATEBLOCK This function codes the current block of in the cannon task.
%
%   Input
%       i: current trial number
%       blockIndices: indices when blocks start
%
%   Output
%       block: Block number

    if i >= blockIndices(1) && i < blockIndices(2)
        block = 1;
    elseif i >= blockIndices(2) && i < blockIndices(3)
        block = 2;
    elseif i >= blockIndices(3) && i < blockIndices(4)
        block = 3;
    elseif i >= blockIndices(4)
        block = 4;
    end
end 