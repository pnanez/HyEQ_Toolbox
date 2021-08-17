%% Creating plots with HybridPlotBuilder
%% Setup
% The |HybridPlotBuilder| class provides an easy and configurable way to plot 
% hybrid solutions. To demonstrate, we first create solutions to a 2D
% system and a 3D system.

close all
system = ExampleBouncingBallHybridSystem();
system_3D = Example3DHybridSystem();
config = HybridSolverConfig("MaxStep", 0.1); % Smaller steps make the plots look better.
sol = system.solve([10, 0], [0 30], [0 30], config);
sol_3D = system_3D.solve([0; 1; 0], [0, 20], [0, 100], config);

%% Default Plotting
% To create a plot without any customization, we create an instance of
% HybridPlotBuilder by calling the constructor |HybridPlotBuilder()|, then
% passing a solution to |plotflows|, |plotjumps|, |plotHybridArc|, or
% simply |plot|.
% 
% The |plotflows| function plots each component of the solution versus
% continuous time $t$. For |plotflows|, |plotjumps|, |plotHybridArc|, each 
% component (up to four) is placed in a separate subplot.
HybridPlotBuilder().plotflows(sol);

%% 
% The |plotjumps| function plots each component of the solution versus
% discrete time $j$.
HybridPlotBuilder().plotjumps(sol);

%% 
% The |plotHybridArc| function plots each component of the solution versus
% hybrid time $(t, j)$.
HybridPlotBuilder().plotHybridArc(sol);

%%
% The |plot| function chooses the type of plot based on the number of
% components. For solutions with two or three components, then |plot|
% produces a plot in 2D or 3D state space. Otherwise, each component is
% plotted using |plotflows|.
HybridPlotBuilder().plot(sol);

%% 
% Each of the four preceeding function calls can be abbreviated as
% |plotflows(sol)|, |plotjumps(sol)|, |plotHybridArc(sol)|, and
% |plot(sol)|. This approach does not support customization.
plot(sol)

%% Choosing Components to Plot
% For solutions with multiple components, the |slice| function allows for the
% selection of which components to plot and which order to plot them.
% We will look at the solution to a 3D system.
plot(sol_3D)
view([63.6 28.2]) % Adjust the view angle.

%%
% We plot only the first two components by passing the array.
% [1, 2] to |slice| (The same result can be achieved using the abbreviation |plot(sol_3D,
% [1,2])|).
HybridPlotBuilder().slice([1,2]).plot(sol_3D);

%% 
% The |slice| function also allows the order of components to be changed.
HybridPlotBuilder().slice([2,1]).plot(sol_3D);

%% Customizing Plot Appearance
% The following functions modify the appearance of flows.
HybridPlotBuilder().slice(1)...
    .flowColor("black")...
    .flowLineWidth(2)...
    .flowLineStyle(":")...
    .plotflows(sol)

%% 
% Similarly, we can change the appearance of jumps.
HybridPlotBuilder().slice(1:2)...
    .jumpColor("m")...
    .jumpLineWidth(1)...
    .jumpLineStyle("-.")...
    .jumpStartMarker("+")...
    .jumpStartMarkerSize(16)...
    .jumpEndMarker("o")...
    .jumpEndMarkerSize(10)...
    .plot(sol_3D)
xlim([-1.1, 1.1])
ylim([-1.1, 1.1])

%% 
% To confiugre the the jump markers on both sides of jumps, omit "Start"
% and "End" from the function names:
HybridPlotBuilder().slice(1:2)...
    .jumpMarker("s")... % square
    .jumpMarkerSize(12)...
    .plot(sol_3D)
xlim([-1.1, 1.1])
ylim([-1.1, 1.1])

%% 
% To hide jumps or flows, set the corresponding color to "none." Jump
% markers can be hidden by setting the marker style to "none" and jump
% lines can be hidden by setting the jump line style to "none."
HybridPlotBuilder().slice(2)...
    .flowColor("none")...
    .jumpEndMarker("none")...
    .jumpLineStyle("none")...
    .plotflows(sol)
title("Starting point of each jump") % An alternative way to add titles is shown below.

%% Component Labels
% Plot labels are set component-wise. In the bouncing ball system, the first
% component is height and the second is velocity, so we will add the labels
% $h$ and $v$. |HybridPlotBuilder| automatically adds labels for $t$ and $j$.
HybridPlotBuilder()...
    .labels("$h$", "$v$")...
    .plotflows(sol)

%% 
% If |slice| is used to switch the order of components, then the labels
% automatically switch also.
HybridPlotBuilder().slice([2 1])...
    .labels("$h$", "$v$")...
    .plotflows(sol)

%% 
% Labels are also displayed for plots in phase space.
HybridPlotBuilder().slice([2 1])...
    .labels("$h$", "$v$")...
    .plot(sol)

%% 
% The default interpreter for text is |latex| and can be changed by calling
% |textInterpreter()|. Use one of these values: |none| | |tex| |
% |latex| .
HybridPlotBuilder()...
    .labels("h", "v")...
    .textInterpreter("none")...
    .plotflows(sol)

%% Plot Titles
% Adding titles is similar to adding labels.
HybridPlotBuilder().slice([2 1])...
    .titles("Height", "Velocity")...
    .plotflows(sol)

%% 
% One place where the behavior of labels and titles differ are in 2D or 3D
% plots of a solution in phase space. 
% A plot in phase space only contains one subplot, so only the first title
% is displayed. For this case, the |title| function can be used instead of
% |titles|.
HybridPlotBuilder().title("Phase Plot").plot(sol)

%% Filtering Solutions
% Portions of solutions can be hidden with the |filter| function. In this
% example, we create a filter that only includes points where the second
% component (velocity) is negative. (In this example, the time-step size
% along flows is large, so the hidden lines that connect to filtered points 
% extends a noticible distance into the portion of the solution that should
% be visible.)
figure()
is_falling = sol.x(:,2) < 0;
HybridPlotBuilder()...
    .filter(is_falling)...
    .plotflows(sol)

%% Plotting System Modes
% Filtering is useful for plotting systems where an integer-value
% component indicates the mode of the system. 
% Here, we create a 3D system with a continuous variable $z \in \bf{R}^2$
% and a discrete variable $q \in \{0, 1\}$. Points in the solution where 
% $q = 0$ are plotted in blue, and points where $q = 1$ are plotted in
% black. The same |HybridPlotBuilder| object is used for both plots by saving it 
% to the |builder| variable (this allows us to specify the labels only once).
system_with_modes = ExampleModesHybridSystem();

for i=1:10
    % Create a random initial condition and solve.
    z0 = 20*rand(2, 1) - 10;
    q0 = round(rand());
    sol_modes = system_with_modes.solve([z0; q0], [0, 10], [0, 10], "silent");
    
    q = sol_modes.x(:, 3);
    
    % Plot the [1, 2] components (that is, the first two components) of
    % sol_modes at all time steps where q == 0. 
    builder = HybridPlotBuilder();
    builder.title("Phase Portrait") ...
        .labels("$x_1$", "$x_2$") ...
        .slice([1,2]) ... % Pick which state components to plot
        .filter(q == 0) ... % Only plot points where q is 0.
        .plot(sol_modes)
    hold on % See the section below about "hold on"
    % Plot in black the solution (still only the [1,2] components) for all time
    % steps where q == 1. 
    builder.flowColor("black") ...
        .jumpColor("none") ...
        .filter(q == 1) ... % Only plot points where q is 1.
        .plot(sol_modes)
end
%% Legends
% Next, we add a legend to the last plot. 
% Note that in the loop above, a new instance of |HybridPlotBuilder| is 
% assigned to |builder| in each iteration, then |plot| is called twice, 
% so the legend will only have two entries. 
builder.legend("$q = 0$", "$q = 1$");

%% Replacing vs. Adding Plots to a Figure
% By default, each call to a HybridPlotBuilder plot function overwrites the 
% previous plots. In the following code, we call |plotflows| twice. The
% first call plots a solution in blue and red, but the second call resets the figure
% and plots a solution in black and green.
tspan = [0 10];
jspan = [0 30];
sol1 = system.solve([10, 0], tspan, jspan, config);
sol2 = system.solve([ 5, 10], tspan, jspan, config);

figure()
HybridPlotBuilder().flowColor('blue').jumpColor("red") ... % default colors.
    .plotflows(sol1)
HybridPlotBuilder().flowColor('black').jumpColor("green")...
    .title("Multiple Calls to $\texttt{plotflows}$ with \texttt{hold off}") ...
    .plotflows(sol2)
%% 
% To plot multiple graphs on the same figure, use |hold on|, similar to
% standard MATLAB plotting functions.
HybridPlotBuilder().plotflows(sol1) % Plots blue flows and red jumps by default.
hold on
HybridPlotBuilder().flowColor('black').jumpColor("green")...
    .title("Multiple Calls to $\texttt{plotflows}$ with \texttt{hold on}")...
    .plotflows(sol2)