%% HybridPlotBuilder Examples
% The |HybridPlotBuilder| class provides an easy and configurable way to plot 
% hybrid solutions. To demonstrate, we first create two solutions to the bouncing 
% ball system. 

close all
bb_system = ExampleBouncingBallHybridSystem();
tspan = [0 10];
jspan = [0 30];
sol1 = bb_system.solve([10, 0], tspan, jspan);
sol2 = bb_system.solve([ 5, 10], tspan, jspan);

% Multiple Plots in a Single Figure
% By default, each call to a HybridPlotBuilder plot function overwrites the 
% previous plots. In the following code, we call |plotflows| twice. The
% first call plots a solution in green, but the second call resets the figure
% and plots a solution in black.

figure(1)
HybridPlotBuilder().flowColor('green').plotflows(sol1)
HybridPlotBuilder().flowColor('black')...
    .title("Multiple Calls to $\texttt{plotflows}$ with `hold off'") ...
    .plotflows(sol2)
%% 
% We can plot multiple graphs on the same figure, however, by using |hold on, 
% similar to standard MATLAB plot functions.|

figure(2)
HybridPlotBuilder().flowColor('green').plotflows(sol1)
hold on
HybridPlotBuilder().flowColor('black')...
    .title("Multiple Calls to $\texttt{plotflows}$ with 'hold on'")...
    .plotflows(sol2)