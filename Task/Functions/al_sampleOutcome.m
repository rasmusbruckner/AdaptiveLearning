% Add comments

function outcome = al_sampleOutcome(mean, concentration)
            outcome = round(180 + rad2deg(circ_vmrnd(deg2rad(mean - 180), concentration, 1)));
end