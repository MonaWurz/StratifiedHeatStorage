function delta_Q = radial_heat_transfer(theta_W, theta_L, radius_1, radius_2, radius_3, delta_z) 

    c_p = 4185.1;           % [J/kg K] 
    alpha_1 = 70;           % [W/m^2 K] - water natural convection
    alpha_2 = 9.4;          % [W/m^2 K] - air around isolated pipes
    lambda_W = 0.61;        % [W/m K] - water
    lambda_1 = 50;          % [W/m K] - steel 
    lambda_2 = 0.032;       % [W/m K] - isolation

    resistance_alpha_1 = 1 / (radius_1 * alpha_1);              % transfer resistance water & steel
    resistance_alpha_2 = 1 / (radius_3 * alpha_2);              % transfer resistance isolation & air
    resistance_lambda_1 = log(radius_2 / radius_1) / lambda_1;  % conductive resistance steel
    resistance_lambda_2 = log(radius_3 / radius_2) / lambda_2;  % conductive resistance isolation 

    zaehler = 2 * pi * lambda_W * (theta_W - theta_L); % theta_W = theta_N
    
    delta_Q = delta_z * zaehler ...
          / (resistance_alpha_1 ...
          + resistance_lambda_1 ...
          + resistance_lambda_2 ...
          + resistance_alpha_2);
    %disp(delta_Q);
end