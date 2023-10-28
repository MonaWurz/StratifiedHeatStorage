classdef SimulationHandler < handle             % handle class = func of methods can change the instanze (Instanz) 

    % MANAGER FOR HANDLING SIMULATION TASKS
    % 
    % class to embed the stratified heat storage reports 
    % & also the results
    % 
    % excel sheet are read and transformed

    properties
        time=0;                 % is the time in seconds (only considered as daily time)
        inflow_array
        outflow_array
        stratified_heat_storage StratifiedHeatStorage
        total_sim_time
        dt                      % this is adapted for given in/outflows
        result_array
        exchange_results   
        in_outflows
    end

    methods
        function obj = SimulationHandler(total_sim_time, dt, stratified_heat_storage)
            obj.stratified_heat_storage = stratified_heat_storage;
            obj.total_sim_time = total_sim_time;
            obj.dt = dt;
            obj.inflow_array = obj.convert_csv_to_array("inflow");
            obj.outflow_array = obj.convert_csv_to_array("outflow_dynamic");
            obj.result_array = zeros(ceil(total_sim_time/dt/1000), obj.stratified_heat_storage.N+1);        % creates arry with zeros; 2 columns
            obj.exchange_results = zeros(ceil(total_sim_time/dt/100), obj.stratified_heat_storage.N*3+1);   % creates arry with zeros ??? N*3+1 columns
            obj.in_outflows = zeros(ceil(total_sim_time/dt/1000), 4);                                       % 4 columns: time, inflow, outflow, actual_outflow
        end
        
        function [thetas, exchanges, in_outflows] = start_simulation(obj)                               % [outputs] (inputs)
            sim_counter = 1;

            while obj.time < obj.total_sim_time
                %%% inflow = inflow by inlets %%%
                inflow = obj.get_in_out_flow(obj.inflow_array); %row: (1) mean of theta (2) mean of vol
                inflow(2) = inflow(2)*obj.dt;
                    
                %%% outflow = outflow by heat exchangerv%%%    
                outflow = obj.get_in_out_flow(obj.outflow_array); %row: (1) mean of theta (2) mean of vol 
                outflow = outflow * obj.dt;
                %disp(outflow)
                
                %%% in/outflows on/off %%%
                [resimulate, new_dt] = obj.stratified_heat_storage.simulate(0, 0, 0);  % NO IN / OUTFLOWS   
                %[resimulate, new_dt] = obj.stratified_heat_storage.simulate(inflow(2), inflow(1), 0); % ONLY INFLOWS
                %[resimulate, new_dt] = obj.stratified_heat_storage.simulate(0, 0, outflow);  % ONLY OUTFLOWS
                %[resimulate, new_dt] = obj.stratified_heat_storage.simulate(inflow(2), inflow(1), outflow);  % IN AND OUTFLOWS
                
                if resimulate
                    obj.dt = new_dt;
                    obj.stratified_heat_storage.set_dt(new_dt);
                    %disp(obj.time/3600 + " setting new time_step to " + new_dt);
                    continue;
                end
                %obj.stratified_heat_storage.simulate(0, 0, 0);
                r = [obj.stratified_heat_storage.vol_elements(:).theta];
                exc = transpose([obj.stratified_heat_storage.exchanges]);

                %%%STORE RESULTS %%% 
                obj.result_array(sim_counter, 1) = obj.time;                        % first column: time
                obj.result_array(sim_counter, 2:end) = r(2:2:end);                  % other columns: results
                
                obj.exchange_results(sim_counter, 1) = obj.dt;                      % first column: time steps
                obj.exchange_results(sim_counter, 2:end) = exc(:);                  % other columns: exchanges cond. conv. rad.

                obj.in_outflows(sim_counter, 1) = obj.dt;                           % first column: time
                %disp(volume_to_heat_flow(inflow(3), inflow(2)));
                obj.in_outflows(sim_counter, 2:end) = [volume_to_heat_flow(inflow(2), inflow(1)), outflow, ...      %in_outflows() [dt, Q_in_inlet, Q_out_ex, Q_out_outlet]
                    volume_to_heat_flow(obj.stratified_heat_storage.out_v, obj.stratified_heat_storage.out_theta)]; 
                if obj.stratified_heat_storage.out_v == 0
                    %disp("theta = " + obj.stratified_heat_storage.out_theta + "resimulate = " + resimulate)
                   
                end

                %%% UPDATE TIME STEPS %%% 
                obj.time = obj.time + obj.dt;       % time = old time + timetsep
                sim_counter = sim_counter + 1;      
            end
            %%% RETURN RESULTS %%%%
            thetas = obj.result_array;
            exchanges = obj.exchange_results;
            in_outflows = obj.in_outflows;
        end

        function res = get_in_out_flow(obj, array)  % processes data from excel sheet (flow)
            index = obj.get_closest_index(array, obj.time);
            second_index = obj.get_closest_index(array, obj.time + obj.dt);
            if size(array, 2) > 2
                theta = mean(array(index:second_index, 2));
                flow = mean(array(index:second_index, 3));
                res = [theta, flow];
            else
                res =  mean(array(index:second_index, 2));
            end
        end
    end
    
    methods(Static)                                         % may be called on the class itself, not on instances of the class
        function array = convert_csv_to_array(sheet_name)   % first column: time; sec -> day
            a = readmatrix("flows.xlsx", Sheet=sheet_name);
            a(:,1) = a(:,1)*(24*3600);  % windows time format -> seconds
            if size(a, 2) > 2
                                       
                a(:,3) = a(:,3)/(60*1000);                       % l/min -> m^3/s
            end
            array = a;

        end
        function closest_index = get_closest_index(a, time)     % first column: array; second column: time
            % in the in/outflow-arrays, the 
            time = mod(time, a(end,1)); %this is just to wrap around 24h
            
            [~,closest_index] = min(abs(a(:,1)-time));
        end
    end
end