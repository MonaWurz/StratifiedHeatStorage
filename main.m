tic
%%% TANK GEOMETRY %%%
radius_1 = 0.5642;                 % [m] - radius of the water column 
%radius_1 = 1;
radius_2 = radius_1 + 0.01;         % [m] - radius of the water column + steel mantle
%radius_3 = 0.5842;                 % [m] - radius of the water column + steel mantle + isolation (1 cm)
%radius_3 = 0.6042;                 % [m] - radius of the water column + steel mantle + isolation (3 cm)
radius_3 = 0.6942;                 % [m] - radius of the water column + steel mantle + isolation (12 cm)
%radius_3 = radius_2+0.5;           % [m] - radius of the water column + steel mantle + isolation (var)
height = 2;                        % [m] - height of tank

%%% COEFFICIENTS %%%
c_p = 4185.1;                       % [J/kg K] 
alpa_1 = 70;                        % [W/m^2 K] - water natural convection
alpha_2 = 9.4;                      % [W/m^2 K] - air around isolated pipes
lambda_W = 0.61;                    % [W/m K] - water
lambda_1 = 50;                      % [W/m K] - steel 
lambda_2 = 0.032;                   % [W/m K] - isolation

%%% LAYERS %%%
N = 10;                             % [-] - number of layers 

%%% INFLOW %%%          
v_in = 4/(60*1000)/(pi*radius_1^2);             % [m/s] - 4L/min
delta_z = vol_el_thickness(height, N);          % [m] - layer thickness
delta_t = critical_time_step(delta_z, v_in)/2;  % [s] - time tep (here CLF = 0.5)

%%% CHANGE TEMPERATURE-SPREAD HERE %%%
storage = StratifiedHeatStorage([30,90], N, delta_z, radius_1, radius_2, radius_3, delta_t);    % spread between [cold, hot] in [C]
simulation_handler =SimulationHandler(7*24*3600, delta_t, storage);                             % overall time in seconds
[thetas, exchanges, in_outflows] = simulation_handler.start_simulation();

heights = 0+delta_z/2:delta_z:height-delta_z/2;
heights(1) = 0;
heights(end) = height;

%%% PLOTS %%%
%plot_temperature_spread(heights, thetas);
%plot_2_8_24h(heights, thetas);
%plot_mean(thetas);
%plot_all_thetas(thetas);
%plot_losses(thetas(:,1), exchanges);

toc