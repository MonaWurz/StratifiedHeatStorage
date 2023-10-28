classdef VolumeElement < handle

    % VOLUME ELEMENT & BORDER FLOWS
    %
    % processes regarding the volume element
    % functions conductive, convective, radial are linked and incorporated here
    %
    % flows into the volume element are positive
    % theta(1) = old temperature
    % theta(2) = new temperature


    properties(Constant)
        c_p = 4185.1            % [J/kg K]
        theta_air = 20          % [C] - ambient temperature
    end
    properties
        theta = [1.0,1.0];      % Temperature [old temp, new temp]
        rho = 0;
        dt = 0;
        thickness ;             % dz
        area;
        radius;                 % radius of the water column 
        radius_steel;
        radius_isolation;
        volume;                 % volume of the element
        velocity = 0;           % velocity in the element; positive = upwards
        above VolumeElement;    % volume element above
        below VolumeElement;    % volume element below
    end

    methods
        function obj = VolumeElement(radius, dz, theta, radius_steel, radius_isolation, dt)
            obj.radius = radius;
            obj.thickness = dz;
            obj.volume = calc_volume(dz, radius);
            obj.theta(2) = theta;
            obj.rho = density(obj.theta(1));
            obj.radius_steel = radius_steel;
            obj.radius_isolation = radius_isolation;
            obj.dt = dt;
            obj.area = radius^2*pi;
        end
        function [v, theta] = external_flow(obj, v, theta)                          % [outputs] (inputs)
            obj.theta(1) = obj.theta(2);                                            % old = new (overwrite)
            obj.theta(2) = 1/obj.volume * ((obj.volume - v)*obj.theta(1)+v*theta);  % new = weighted mean (by volume)
            
            if isempty(obj.below)                                                   % bottom layer is reached
                v = v;                                                              % volume
                theta = obj.theta(1);                                               % final element gives an outflow
            else
                [v, theta] = obj.below.external_flow(v, obj.theta(1));              % excess volume is passed on downwards %%%!!!
            end
        end
        function apply_heat(obj, heat)                                           % temperature of element
            obj.theta(1) = obj.theta(2);                                         % old = new (overwrite)
            obj.theta(2) = obj.theta(1) + heat/(obj.rho * obj.volume * obj.c_p); % new = mean
        end
        function Q_N = heat_N(obj, x)
            Q_N = obj.density_N * obj.volume_N * obj.cp * obj.temperature*x;     % heat of element
        end

        function exchanges = idle(obj, print) % exchanges happening in idle state
            radial = - radial_heat_transfer(obj.theta(2), obj.theta_air, obj.radius, obj.radius_steel, obj.radius_isolation, obj.thickness);
            
            if isempty(obj.above)       % uppermost element
                [conv, obj.velocity] = convective_heat_transfer(obj.below.theta(2), obj.theta(2), obj.radius, obj.dt, obj.velocity, print);
                cond = conductive_heat_transfer(obj.theta(2), obj.below.theta(2), obj.radius, obj.thickness);
                radial = radial - aerial_heat_transfer(obj.theta(2), obj.theta_air, obj.radius, obj.radius_steel, obj.radius_isolation); 
                    % additional heat transfer through top lid
            
            elseif isempty(obj.below)   % bottommost element
                [conv, obj.velocity] = convective_heat_transfer(obj.theta(2), obj.above.theta(2) ,obj.radius, obj.dt, obj.velocity, print);
                conv = -conv;
                obj.velocity = -obj.velocity;
                cond = conductive_heat_transfer(obj.theta(2), obj.above.theta(2), obj.radius, obj.thickness);
                radial = radial - aerial_heat_transfer(obj.theta(2), obj.theta_air, obj.radius, obj.radius_steel, obj.radius_isolation);
                    % additional heat transfer through bottom lid

            else                        % middle elements
                [conv, obj.velocity] = convective_heat_transfer(obj.below.theta(2), obj.theta(2), obj.radius, obj.dt, obj.velocity, print);
                cond = conductive_heat_transfer(obj.theta(2), obj.below.theta(2), obj.radius, obj.thickness);
                [other_conv, other_velocity] = convective_heat_transfer(obj.theta(2), obj.above.theta(2), obj.radius, obj.dt, obj.velocity, print);
                conv = conv - other_conv;
                obj.velocity = obj.velocity - other_velocity;
                cond = cond + conductive_heat_transfer(obj.theta(2), obj.above.theta(2), obj.radius, obj.thickness);
            end
            
            exchanges = [cond, conv, radial]*obj.dt;
        end
    end
 end