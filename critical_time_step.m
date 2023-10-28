function delta_t = critical_time_step(delta_z, v_in)

    CLF = 1;    % [-] Courant-Friedrichs-Lewy-number

    delta_t = (CLF * delta_z)/ v_in;
    %disp("v_in = " + v_in);

end