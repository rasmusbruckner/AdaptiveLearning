% Hey René
% Ok, das sind ein paar Dinge die ich im Internet gefunden habe
% aber im Grunde das gleiche machen, was wir eben probiert haben.

trials = 200;
cps = 25;
safe = 3;

% irgendwie checkt der das mit einer Null nicht, daher ist ein CP eine 2!
l = 2;
z = repmat(l, 1, cps);

while 1
    
    cp = shuffle([ones(1,(trials-cps)), z ]);
    
    % cp: not two cps in a row.
    q = diff([0 cp 0] == 2);
    v = find(q == -1) - find(q == 1);
    
    % no cp: at least three in a row.
    x = diff([0 cp 0] == 1);
    y = find(x == -1) - find(x == 1);
    
    if isempty(find(v >=2 )) && isempty(find(y <= safe -1))
        break
        
    end
end

cp = cp'


% Also 25 CPs sind schon aufwändig. Alles was drüber geht scheint schwierig.
% eigentlich kommt ja noch der constraint, dass erster trial cp sein muss
% naja, mal sehen was Ben zu dem Problem sagt.

