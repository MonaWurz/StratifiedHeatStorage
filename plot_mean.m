function plot_mean(thetas)

% plots the devolpment of the tanks mean temperature

t_mean = thetas;
t_mean(:,2) = mean(t_mean(:,2:end),2);
    f=figure;
    hold on
    f.Position = [100,100,900,600];
    x = t_mean(:,1)/(3600);
    a = plot(x, t_mean(:,2));
    al = "Mean Temperature";
    legend([a], [al]);
    xlabel("Time [hours]");
    ylabel("Temperature [°C]");
    hold off
end