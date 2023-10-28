%%%% TEMPERATURES %%%
theta_W = 303.15;   % [K] 
theta_L = 293.15;   % [K] 

%%% TANK GEOMETRY %%%
radius_1 = 1;       % [m] - Radius der Wassersäule 
radius_2 = 1.01;    % [m] - Radius der Wassersäule + Eisenrohr
radius_3 = 1.05;    % [m] - Radius der Wassersäule + Eisenrohr + Isolation
delta_z = 0.1;      % [m] - Höhe der Zylinderschicht 

%%% TESTS %%%
testlauf = radial_heat_transfer(theta_W, theta_L, radius_1, radius_2, radius_3, delta_z);
assert(round(testlauf, 4) == 2.1867, 'Radial heat transfer: Testlauf 1');

theta_L = 303.15;   % [K] 
testlauf = radial_heat_transfer(theta_W, theta_L, radius_1, radius_2, radius_3, delta_z);
assert(round(testlauf, 4) == 0.0, 'Radial heat transfer: Testlauf 2');