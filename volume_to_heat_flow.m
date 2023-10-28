function heat_flow = volume_to_heat_flow(v,theta)   % heat flow out of volume flow
    c_p = 4185.1;                                   %[J/kg K]

    heat_flow = v*density(theta)*c_p*theta;         %[J/s]
end