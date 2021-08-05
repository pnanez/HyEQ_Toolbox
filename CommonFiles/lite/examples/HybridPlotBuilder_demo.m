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

%% Replacing vs. Adding Plots to a Figure
% By default, each call to a HybridPlotBuilder plot function overwrites the 
% previous plots. In the following code, we call |plotflows| twice. The
% first call plots a solution in green, but the second call resets the figure
% and plots a solution in black.

figure(1)
HybridPlotBuilder().plotflows(sol1) % Plots blue flows and red jumps by default.
HybridPlotBuilder().flowColor('black').jumpColor("green")...
    .title("Multiple Calls to $\texttt{plotflows}$ with ``\texttt{hold off}''") ...
    .plotflows(sol2)
%% 
% We can plot multiple graphs on the same figure, however, by using 
% |hold on|, similar to standard MATLAB plot functions.

figure(2)
HybridPlotBuilder().plotflows(sol1) % Plots blue flows and red jumps by default.
hold on
HybridPlotBuilder().flowColor('black').jumpColor("green")...
    .title("Multiple Calls to $\texttt{plotflows}$ with ``\texttt{hold on}''")...
    .plotflows(sol2)