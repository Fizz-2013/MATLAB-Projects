function newRodState = heatingRodTimeStep( lastRodState, dt, parameters )
% heatingRodTimeStep calculates the the heat flow discretely through a rod,
% where lastRodState is an array containing the temperature through the rod
% at a certain time. dt is the duration of the time step.
% The rod parameters can be specified with parameters:
% 
%     parameters.rodlength    % Length of the rod
%     parameters.kappa        % Kappa value for the rod material
%     parameters.c            % Specific Heat Capacity of rod material
%     parameters.density      % Density of the rod material
%     parameters.crossArea    % Cross sectional area of rod
%     

%% Discrete Variables

segments = length(lastRodState);
% Length of the small segment, measured from the centers
dx = parameters.rodLength/segments;
% Mass of small segment
dm = parameters.crossArea*dx*parameters.density;


%% Initializations
newRodState = lastRodState;


%% Leftmost Segment
    
% 100W coming in from left, 100J/s * dt = Joules gained in that time
heatIntoSegmentLeft = 100*dt;

tempDiffRight = lastRodState(1)-lastRodState(2);

heatIntoSegmentRight = (-parameters.kappa*parameters.crossArea)*(dt/dx)*tempDiffRight;

heatIntoSegment = heatIntoSegmentLeft + heatIntoSegmentRight;

tempIncrease = heatIntoSegment/(parameters.specificHeatCapacity*dm);
newRodState(1) = newRodState(1) + tempIncrease;

    
%% Middle segments (excluding end points)
for segment = 2:(segments-1)
    %offset to exclude the first data point, which represents left side
    %of rod


    tempDiffLeft = lastRodState(segment)-lastRodState(segment-1);
    tempDiffRight = lastRodState(segment) - lastRodState(segment+1);
    tempDiff = tempDiffLeft + tempDiffRight;

    heatIntoSegment = (-parameters.kappa*parameters.crossArea)*(dt/dx)*tempDiff;

    tempIncrease = heatIntoSegment/(parameters.specificHeatCapacity*dm);

    newRodState(segment) = newRodState(segment) + tempIncrease;
end


%% Rightmost Segment

% Losing heat to 0 celsius at right end

tempDiffLeft = lastRodState(end)-lastRodState(end-1);
tempDiffRight = lastRodState(end) - 0;
tempDiff = tempDiffLeft + tempDiffRight;

heatIntoSegment = (-parameters.kappa*parameters.crossArea)*(dt/dx)*tempDiff;

tempIncrease = heatIntoSegment/(parameters.specificHeatCapacity*dm);

newRodState(end) = newRodState(end) + tempIncrease;


%% Finishing
end

