function delta_Q = aerial_heat_transfer(theta_W,theta_air, radius_W, radius_steel, radius_isolation) 

% heat losses through top and bottom lid, respectiveley

    c_p = 4185.1;           % [J/kg K] 
    alpha_1 = 70;           % [W/m^2 K] - water natural convection
    alpha_2 = 9.4;          % [W/m^2 K] - air around isolated pipes
    lambda_W = 0.61;        % [W/m K] - water
    lambda_1 = 50;          % [W/m K] - steel 
    lambda_2 = 0.032;       % [W/m K] - isolation

    numerator = pi*radius_W^2*(theta_W-theta_air);
    denumerator = 1/alpha_1 + (radius_steel-radius_W)/(lambda_1) + (radius_isolation-radius_steel)/lambda_2 + 1/alpha_2;
    
    delta_Q = numerator / denumerator;
end