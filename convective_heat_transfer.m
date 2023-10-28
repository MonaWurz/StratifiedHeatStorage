function [delta_Q, velocity] = convective_heat_transfer(theta_below, theta_above, radius, delta_t, velocity_old, print)

    G_ACC = 9.81;                           % [m/s^2]   - gravitational acceleration
    C_P = 4.18 * 10^3;                      % [J/kg K]  - specific heat capacity of water
        
    roh_below = density(theta_below);       % [kg/m^3] 
    roh_above = density(theta_above);       % [kg/m^3] 
    
    velocity = ((roh_above - roh_below) / roh_above) * G_ACC * delta_t ;
    %disp("theta_above = " + theta_above + "roh_above: " +roh_above );
    %disp("theta_below = " + theta_below + "roh_below: " + roh_below);
    
    if velocity > 0                         % if velocity arises from density differences
        delta_Q = volume_to_heat_flow(velocity * pi * (radius^2), theta_below-theta_above);
    else
        velocity = 0;
        delta_Q = 0 ;                       % because the less dense volume is already above
    end
    if print && velocity > 0
    %disp("velocity = " + velocity + "delta_Q = " + delta_Q);
    end
end