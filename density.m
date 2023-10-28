function roh = density(theta) % for water until 150°C

% function based on the density anomaly of water
    
    A_0 = 9.9983952 * 10^2;     % [kg/m^3]
    A_1 = 1.6952577 * 10^1;     % [kg/(m^3 °C)] 
    A_2 = -7.9905127 * 10^(-3);   % [kg/(m^3 °C^2)]
    A_3 = -4.6241757 * 10^(-5);   % [kg/(m^3 °C^3)]
    A_4 = 1.0584601 * 10^(-7);    % [kg/(m^3 °C^4)]
    A_5 = -2.8103006 * 10^(-10);  % [kg/(m^3 °C^5)]
    B = 1.6887236 * 10^(-2);      % [1/°C]
    
    numerator = A_0 + A_1*theta + A_2*theta^2 + A_3*theta^3 + ...
        A_4*theta^4 + A_5*theta^5;

    roh = numerator / (1 + (B * theta));
    
end

