function plot_temperature_spread(heights, thetas)
    function closest_index = closest(a, val)     % first column: array; second column: time
            % in the in/outflow-arrays, the             
            [~,closest_index] = min(abs(a(:)-val));
        end

% plotting the temperature spread within the tank after 24 hours

    t_24h = thetas(SimulationHandler.get_closest_index(thetas, 24*3600), 2:end);
    f=figure;
    hold on
    ylim([0,max(heights)]);
    f.Position = [100,100,900,600]; %right above wide tall
    y = heights;
    a = plot(t_24h, y);
    al = "Temperature spread after 24 hours";
    legend(a, al);
    xlabel("Temperature [°C]");
    ylabel("Height [m]");
    hold off
    
    disp(t_24h(closest(heights, 0.5)));
    disp(t_24h(closest(heights, 1.5)));
end