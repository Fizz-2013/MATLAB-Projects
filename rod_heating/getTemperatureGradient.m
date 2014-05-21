function temperature = getTemperatureGradient(time, dt)
% getTemperatureGradient returns the temperature gradient matrix of copper
% rod, with a plot of temperature vs. time at the specified distance x
% from the left end of the rod.
%
% The heating conditions is specified by heatingRodTimeStep.m, using the
% given time step dt.
%
% Each row of the temperature matrix is a snapshot of the rod's temperature
% at the time. The row is geographically mapped; i.e. the leftmost cell
% holds the temperature of the leftmost segment of the rod.
%
% The rod parameters can be specified with parameters:
%
%     parameters.rodlength    % Length of the rod
%     parameters.kappa        % Kappa value for the rod material
%     parameters.c            % Specific Heat Capacity of rod material
%     parameters.density      % Density of the rod material
%     parameters.crossArea    % Cross sectional area of rod
%


% Initialize Parameters
parameters = struct;
timePoints = [];

setParameters();

calculateTemperatureGradient;

plot(temperature(:, getDistanceIndex(0.10)), 'r');
hold on;
plot(temperature(:, getDistanceIndex(0.50)), 'g');
plot(temperature(:, getDistanceIndex(0.90)), 'b');
xlabel('Time (s)');
ylabel('Temperature (Celsius)');



%% Function Definitions
    function setParameters()
        % ===== Setting parameters and stuff
        % K of Copper is approx. 300
        parameters.kappa = 300;
        
        % For copper, at 25 Celsius, 385 J/kgC
        parameters.specificHeatCapacity = 385;
        
        % For copper, at 9000 kg/m^3
        parameters.density = 9000;
        
        % Cross-sectional area of circle radius 0.01m
        parameters.crossArea = 0.005^2 * pi;
        
        parameters.rodLength = 1;
        
        parameters.segments = 40;
        
        
        timePoints = time/dt;
        temperature = zeros(timePoints, parameters.segments);
    end

    function calculateTemperatureGradient()
        % Skips the first row of data
        for t=2:timePoints
            lastRodState = temperature(t-1,:);
            
            rodState = heatingRodTimeStep(lastRodState, ...
                dt, parameters);
            
            temperature(t, :)  = rodState;
        end
        
    end

    function distanceIndex = getDistanceIndex(x)
        % Calculates the index of the specified distance x
        if x<=0
            distanceIndex = 1;
        elseif x>=parameters.rodLength
            distanceIndex = parameters.segments;
        else
            distanceIndex = round((x/parameters.rodLength)*parameters.segments);
        end
    end


end

