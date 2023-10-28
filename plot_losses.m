function plot_losses(time, exchanges)

% plots the cumulated losses

    cs = exchanges(:,4:3:end);
    cs = sum(cs, 2)/(3600*1000); % -> J -> kWh
    cs = cumsum(cs);
    f=figure;
    hold on
    f.Position = [100,100,900,600];
    x = time/3600;
    a = plot(x, cs);
    al = "Cumulative sum heat loss";
    legend(a,al);
    ylabel("Losses [kWh]");
    xlabel("Time [hours]");
    hold off
    disp("heat loss after 24h: " + cs(SimulationHandler.get_closest_index(x, 24)));
end