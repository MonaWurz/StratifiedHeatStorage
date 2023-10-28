%%% TEMPERATURE %%%
theta_W = 323.15;   % [K] - 50°C

%%% TESTS %%%
testlauf = density(theta_W);
assert(round(testlauf, 3) == 988.030,'Density: Testlauf');