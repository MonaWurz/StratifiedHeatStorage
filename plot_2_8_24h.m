function plot_2_8_24h(heights, thetas)

% plotting the 2,8,24,48 h temperature development within the tank

    t_2h = thetas(SimulationHandler.get_closest_index(thetas, 2*3600), 2:end);
    t_8h = thetas(SimulationHandler.get_closest_index(thetas, 8*3600), 2:end);
    t_24h = thetas(SimulationHandler.get_closest_index(thetas, 24*3600), 2:end);
    t_48h = thetas(SimulationHandler.get_closest_index(thetas, 48*3600), 2:end); % the set time must exceed 48h 
    f=figure;
    hold on
    ylim([0,max(heights)]);
    f.Position = [100,100,900,600]; %right above wide tall
    y = heights;
    a = plot(t_2h, y);
    al = "2 hours";
    b = plot(t_8h, y);
    bl = "8 hours";
    c = plot(t_24h, y);
    cl = "24 hours";
    d = plot(t_48h, y);
    dl = "48 hours";
    legend([a,b,c, d], [al, bl, cl, dl]);
    xlabel("Temperature [°C]");
    ylabel("Height [m]");
    hold off
end