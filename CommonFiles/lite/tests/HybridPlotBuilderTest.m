%% HybridPlotBuilder tests

%%% Setup hybrid solutions to use in tests.
close all
bb_system = ExampleBouncingBallHybridSystem();
tspan = [0 10];
jspan = [0 30];
sol1 = bb_system.solve([10, 0], tspan, jspan);
sol2 = bb_system.solve([ 2, 10], tspan, jspan);

%% Test plotflows with "hold off".
% Expected: A figure containing two subplots. Each subplot shows only
% one solution, plotted with black flows and red jumps.
figure()
HybridPlotBuilder().flowColor('green').plotflows(sol1)
HybridPlotBuilder().flowColor('black')...
    .title("Multiple Calls to $\texttt{plotflows}$ with `hold off'") ...
    .plotflows(sol2)

%% Test plotflows with "hold on".
% Expected: A figure containing two subplots. Each subplot shows two
% solutions, one plotted with black flows and one with green flows
% (both have red jumps).
figure()
HybridPlotBuilder().flowColor('green').plotflows(sol1)
hold on
HybridPlotBuilder().flowColor('black')...
    .title("Multiple Calls to $\texttt{plotflows}$ with 'hold on'")...
    .plotflows(sol2)

%% Test plotjumps with "hold off".
% Expected: A figure containing two subplots. Each subplot shows only
% one solution, plotted in black jumps and blue flows.
figure()
HybridPlotBuilder().jumpColor('green').plotjumps(sol1)
HybridPlotBuilder().jumpColor('black').plotjumps(sol2)

%% Test plotjumps with "hold on".
% Expected: A figure containing two subplots. Each subplot shows two
% solutions, one plotted with black jumps and one with green jumps (both 
% (both have blue flows).
figure()
HybridPlotBuilder().jumpColor('green').plotjumps(sol1)
hold on
HybridPlotBuilder().jumpColor('black').plotjumps(sol2)