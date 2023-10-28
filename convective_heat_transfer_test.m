%%%% TEMPERATURES %%% 
theta_N = 303.15;       % [K] 
theta_N_1 = 304.15;     % [K] 

%%% TANK GEOMETRY %%%
radius_0 = 0.1;         % [m] - Radius der Ladelanze (Mitte Zylinder)
radius_1 = 1;           % [m] - Radius der Wassersäule 
delta_z = 0.1;          % [m] - Höhe der Zylinderschicht #als fkt: ändert sich mit N

%%% TIME %%%
delta_t = 1;            % [s] # muss noch der richtige schritt sein

%%% TESTS %%%
%testlauf = convective_heat_transfer(theta_N, theta_N_1, radius_0, radius_1, delta_z);
%assert(round(testlauf, 4) == 2.1867, 'Convective heat transfer: Testlauf 1');

%theta_N_1 = theta_N;
%testlauf = convective_heat_transfer(theta_N, theta_N_1, radius_0, radius_1, delta_z);
%assert(round(testlauf, 4) == 0.0, 'Convective heat transfer: Testlauf 2');
