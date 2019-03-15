% apply  encode_trigger

triggers = allBehavData.triggers(:,7)
clear count_cp
for i = 1:length(triggers)
    
    [a,b] = encode_trigger(triggers(i))
    
    if i > 1
        count_cp(i) = a.cp == allBehavData.cp(i)
    end
end

sum(count_cp)