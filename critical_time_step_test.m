%%% INFLOW VELOCITY %%%
v_in = 0.034;                       % [m/s] - 4L/min

%%% VOLUME ELEMENT THICKNESS %%%
delta_z = vol_el_thickness(2, 10);  % [m] - 10 layers

%%% TESTS %%%
testlauf = critical_time_step(delta_z, v_in);
assert(round(testlauf, 2) == 5.88,'critical_time_step: Testlauf 1');

delta_z = vol_el_thickness(2, 100);  % [m] - 10 layers
testlauf = critical_time_step(delta_z, v_in);
assert(round(testlauf, 3) == 0.588,'critical_time_step: Testlauf 2');