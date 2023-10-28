function delta_Q = conductive_heat_transfer(theta_self, theta_other, radius, delta_z)

    LAMBDA_0 = 0.597;   % [W/(m^2 K)]
    
    delta_Q = radius^2 * pi * LAMBDA_0 * (theta_other - theta_self) / delta_z;
end