classdef StratifiedHeatStorage < handle

    properties
        N
        vol_elements
        inlets = [1,1,1,1]
        heat_outlets
        out_v = 0
        out_theta = 0
        exchanges  % convective condecitve radial
        highest_dt
        dt
        dt_epsilon = 0.05  % seconds
        intermediate_res  % results to be applied on the different vol els
    end

    methods
        function obj = StratifiedHeatStorage(thetas, N, dz, radius_element, radius_steel, radius_isolation, dt)
            %thetas: theta(0) = min temp, theta(1) = max temp
            obj.vol_elements = {};  % array of vol. elements
            %n=(thetas(2)-thetas(1))/(N-1);
            TEMP_SPREAD = 10;
            n_l = TEMP_SPREAD/(N/2);

            %%% initial temperature profile/ out of two temperatures %%%
            lower_half = thetas(1):n_l:thetas(1)+TEMP_SPREAD-n_l;     
            upper_half = thetas(2)-TEMP_SPREAD+n_l:n_l:thetas(2);    
            %thetas_i = thetas(1):n:thetas(2);
            thetas_i = cat(2, lower_half, upper_half);

            disp(thetas_i);
            for e = 1:N
                obj.vol_elements = [obj.vol_elements, VolumeElement(radius_element, dz, thetas_i(e), radius_steel, radius_isolation, dt)];
                if e > 1
                    obj.vol_elements(e).below = obj.vol_elements(e-1);
                end
                if (e>1)&&(e < N)
                    obj.vol_elements(e-1).above = obj.vol_elements(e);
                end
            end
            obj.inlet_index(N);
            obj.layers_heat_exchange(N);
            obj.N = N;
            obj.highest_dt = dt;  % this is the dt set at the beginning and will be left as it is
            obj.dt = dt;  % this will be adapted during simulation
            obj.exchanges = zeros(N, 3); % conductive, convective, radial
            obj.intermediate_res = zeros(1,obj.N);
            
        end
        function [resimulate, new_dt] = simulate(obj, ingoing_v, ingoing_theta, heat_demand)
            obj.out_theta = 0;
            obj.out_v = 0;
            for i = 1:obj.N
                obj.exchanges(i,:) = obj.vol_elements(i).idle(i==6);  % the exchanges are already relative to dt => J
                obj.intermediate_res(i) = sum(obj.exchanges(i,:));
            end

            %%% adaptive time step  %%%
            resimulate = false;
            new_dt = obj.dt;
            if max(obj.exchanges(:,2)) ~= 0  % convective heat transfer -> adapt dt
                new_dt = min((obj.dt + critical_time_step(obj.vol_elements(1).thickness, max([obj.vol_elements(:).velocity]))/5)/2, obj.highest_dt);
                if abs(new_dt - obj.dt) < obj.dt_epsilon  % the difference between ideal time step and actual time step is small enough -> this simulation is carried out to the end
                    resimulate = false;
                else
                    resimulate = true;
                    new_dt = min(obj.highest_dt, new_dt);
                end
            elseif obj.dt ~= obj.highest_dt
                resimulate = true;
                new_dt = obj.highest_dt;
            end
            if ~resimulate
                for i = 1:obj.N
                    obj.vol_elements(i).apply_heat(obj.intermediate_res(i));
                end
                if ingoing_v > 0
                    index = obj.decide_which_inlet(ingoing_theta);
                    [obj.out_v, obj.out_theta] = obj.vol_elements(index).external_flow(ingoing_v, ingoing_theta); %!!!
                    if obj.out_v == 0
                        disp("out = " + obj.out_v + " "  + obj.out_theta);
                        disp("in = " + ingoing_v + " " + ingoing_theta);
                        disp("index = " + index + " t= " + obj.vol_elements(index).theta(1) + "->" + obj.vol_elements(index).theta(2) + " diff= " + obj.vol_elements(index).theta(2) - obj.vol_elements(index).theta(1));
                    end
                end
                if heat_demand > 0 % heat demand is defined positive an in W*dt
                    if obj.vol_elements(obj.heat_outlets(1)).theta <= obj.vol_elements(1).theta_air  % NO HEAT EXTRACTION POSSIBLE IF AIR_TEMP IS REACHED
                        return
                    end
                    heat_demand = heat_demand/length(obj.heat_outlets);
                    vol_els = obj.vol_elements(obj.heat_outlets);
                    for v = vol_els
                        v.apply_heat(-heat_demand);
                    end
                end
            end
        end

        function storage_index = decide_which_inlet(obj, ingoing_theta)
            thetas = [obj.vol_elements(obj.inlets).theta];
            thetas = thetas(2:2:end);
            [~,closestIndex] = min(abs(thetas-ingoing_theta));
            storage_index = obj.inlets(closestIndex);
        end
        function [ ] = inlet_index(obj, N)
            obj.inlets(2) = round(N/3);
            obj.inlets(3) = round(2*N/3);
            obj.inlets(4) = N;
        end
        function obj = layers_heat_exchange(obj, N)  % calculates how many layers are affected by the heat exchanger directly
            Z_HEAT_EXCHANGE = 0.4;      % [m] - thickness of the heat exchanger unit within the tank
            k = round(Z_HEAT_EXCHANGE/ obj.vol_elements(1).thickness);
            obj.heat_outlets = (N-(k-1)):N;
        end
        function set_dt(obj, dt)
            for v = obj.vol_elements
                v.dt = dt;
            end
            obj.dt = dt;
        end
    end


end