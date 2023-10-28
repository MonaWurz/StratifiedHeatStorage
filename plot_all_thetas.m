function plot_all_thetas(thetas)

% plots the development of the temperature of a respective layer

    f=figure;
    hold on
    f.Position = [100,100,900,600];
    [rows, cols] = size(thetas);
    t_mean = zeros(rows, 1);
    t_mean(:,1) = mean(thetas(:,2:end),2);
    labels = strings(cols-1, 1);
    for c = 1:cols-1
        labels(c) = "Vol # " + c;
    end
    f.Position = [100,100,900,600];
    x = thetas(:,1)/(3600);
    a = plot(x, thetas(:,2:end));
    b = plot(x, t_mean, '-.');
    legend(cat(1,a,b), cat(1, labels, "Mean Temperature"));
    xlabel("Time [hours]");
    ylabel("Temperature [°C]");
    hold off
end