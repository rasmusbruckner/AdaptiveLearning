function trigger(number)

%--------------------------------------------------------------------------
%   UPDATED VERSION (array of trigger numbers possible as input) 
%
% Sends trigger(s) specified by pins via parallel port.
%
% ARGUMENTS (of wrapped pp.m function)
%
% pins          vector of pin numbers.
% output        logical vector same size as pins indicating TTL levels to
%               write -- omit or use [] to merely read.
% slowChecks    optional logical scalar (default true)
%               indicates whether to run extensive and slow input
%               validation.
% port          port number
% address       port address
%
% if you want pp to be as fast as possible, supply both the port
% and addr, and set slowChecks to false.
%--------------------------------------------------------------------------

bstr = dec2bin(number, 8);
pins = find(str2num(reshape(flip(bstr)',[],1))') + 1;


% check if input is valid (throw error/abort if not)
if isempty(pins)
    error('Error using trigger: no pins selected.')
else
    % create [true] & [false] output array same length as input
    onOut    = repmat([true],1,length(pins)); % to turn pins on
    resetOut = repmat([false],1,length(pins));% to turn pins off
end

% send specified trigger
vals = pp(uint8(pins),onOut,false,uint8(0), 888);

WaitSecs(0.001);
%WaitSecs(2);
% reset pins to zero
vals = pp(uint8(pins),resetOut,false,uint8(0), 888);

end