%%%% TEMPERATURES %%%
theta_N = 303.15;        % [K] # muss in jedem zeitschritt angepasst werden
theta_N_1 = 303.15;      % [K] # muss in jedem zeitschritt angepasst werden

%%% TANK GEOMETRY %%%
radius_0 = 0.1;     % [m] - Radius der Ladelanze (Mitte Zylinder)
radius_1 = 1;       % Radius der Wassersäule [m]
radius_2 = 1.01;    % [m] - Radius der Wassersäule + Eisenrohr
radius_3 = 1.05;    % [m] - Radius der Wassersäule + Eisenrohr + Isolation
delta_z = 0.1;      % [m] - Höhe der Zylinderschicht #als fkt: ändert sich mit N

%%% TESTS %%%
testlauf = conductive_heat_transfer(theta_N, theta_N_1, radius_0, radius_1, delta_z);
assert(round(testlauf, 4) == 16.7110, 'Conductive heat transfer: Testlauf 1');

theta_N = theta_N_1;   % [K] 
testlauf = conductive_heat_transfer(theta_N, theta_N_1, radius_0, radius_1, delta_z);
assert(round(testlauf, 4) == 0.0, 'Conductive heat transfer: Testlauf 2');