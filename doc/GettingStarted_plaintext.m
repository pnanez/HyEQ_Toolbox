%% Getting Started with Hybrid Equations Toolbox
%% Mathematical Formulation of Hybrid Systems
% To get started, a webinar introducing the HyEQ Toolbox is available <http://www.mathworks.com/videos/hyeq-a-toolbox-for-simulation-of-hybrid-dynamical-systems-81992.html 
% here> (a free registration is required).
% 
% A hybrid system is a dynamical system with continuous and discrete dynamics. 
% Several mathematical models for hybrid systems have appeared in literature. 
% In this paper, we consider the framework for a hybrid system $\mathcal H$ on 
% a state space $\mathbb{R}^n$ with input space $\mathbb{R}^m$ is defined by the 
% following objects:
%% 
% * A set $C \subset \mathbb{R}^n \times \mathbb{R}^m$ called the _flow set_.
% * A function $f : \mathbb{R}^n \times\mathbb{R}^m \to \mathbb{R}^n$ called 
% the _flow map_.
% * A set $D \subset \mathbb{R}^n \times \mathbb{R}^m$ called the _jump set_.
% * A function $g : \mathbb{R}^n \times \mathbb{R}^m \to \mathbb{R}^n$ called 
% the _jump map._
%% 
% We consider the simulation in MATLAB/Simulink of hybrid systems $\mathcal  
% H = (C,f,D,g)$ written as
% 
% $$\mathcal H: \begin{cases}\dot x = f(x, u) & x \in C \\ x^+ = g(x, u) & x 
% \in D \end{cases}$$
% 
% where $x \in \mathbb{R}^n, u \in \mathbb{R}^{m}$.
% 
% The flow map $f$ defines the continuous dynamics on the flow set $C$, while 
% the jump map $g$ defines the discrete dynamics on the jump set $D$. These objects 
% are referred to as the _data_ of the hybrid system $\mathcal H$, which at times 
% is explicitly denoted as $\mathcal H = (C,f,D,g)$. We illustrate this framework 
% in a simple, yet rich in behavior, hybrid system.
%% New Features in v3.0
% Hybrid Equations Toolbox v3.0 introduces the use of object-oriented programming 
% to improve the capabilities and ease of use of the Hybrid Equations Toolbox. 
% A selection of the new features is listed here and is followed by examples.
%% 
% * *Encapsulated Definitions of Hybrid Systems.* A hybrid system can be defined 
% in a single file by creating a subclass of the |HybridSystem| class. This (1) 
% allows the creation of multiple hybrid systems without name conflicts, (2) enables 
% the definition of system parameters without using global variables, and (3) 
% introduces extra error checking to catch errors early and make debugging easier.
% * *Easy Definitions of Interconnected Hybrid Systems.* It is now possible 
% to define, separately, two hybrid systems with inputs, such as a plant and a 
% controller, along with the input functions for each. Solutions to the coupled 
% system can then be simulated like any other system.
% * *Improved Solutions.* Solutions computed using the |HybridSystem| class 
% contain additional information such as the values of $f$ and $g$ along the solution, 
% the duration of each interval of flow, and the reason the solution terminated.
% * *Improved Progress Updates.* While computing solutions, a progress bar displays 
% the percent completed and the current hybrid time. The displayed progress now 
% updates during both flows and at jumps instead of only at jumps (as was the 
% case in v2.04).
% * *Improved Plotting.* Plotting hybrid solutions is easier and allows more 
% control over the appearance of plots. New features include (1) easy control 
% of the colors, thickness, and line styles of flows and jumps, (2) choice of 
% markers at both the beginnings and ends of jumps, (3) ability to hide portions 
% of hybrid solutions from plots using a filter (useful for plotting different 
% modes in different styles), (4) support for legends, and (5) automatic creation 
% of subplots for solutions with multiple components.
% * *Backward Compatibility.* All code that works in v2.04 is expected to work 
% in v3.0 without modification.
%% 
% 
%% Examples
% *Bouncing Ball System*
% In this example, we demonstrate a new approach to solving a hybrid system 
% and plotting a solution. In |BouncingBallHybridSystem.m|, we define a hybrid 
% system by creating a subclass of the |HybridSystem| class and implementing the 
% |flow_map, jump_map, flow_set_indicator, jump_set_indicator| functions in order 
% to specify $f, g, C$, and $D$, respectively.
% 
% We can then create an instance of the bouncing ball system:

system_bb = ExampleBouncingBallHybridSystem();
%% 
% A solution is then computed by calling the |solve| function on |system_bb| 
% with the initial state and time spans as arguments. The |solve| function returns 
% a |HybridSolution| object that contains information about the solution (use 
% the |t, j,| and |x| properties to recover the standard output from |HyEQSolver|). 

x0 = [1;0];
tspan = [0, 20];
jspan = [0, 30];
sol_bb = system_bb.solve(x0, tspan, jspan)
% Plot flows
% The |HybridPlotBuilder| class is used to plot solutions and provides options 
% for configuring the color, line styles, markers, and plot orders. To generate 
% plots, we create a |HybridPlotBuilder| object then configure the plot via a 
% series of function calls. For the bouncing ball example, our state contains 
% two components, so we set two titles and two labels. When then pass the solution 
% object to the |plot_builder_bb.plotflows| function.

figure()
plot_builder_bb = HybridPlotBuilder();
plot_builder_bb.titles("Height", "Velocity") ...
    .labels('$h$', '$v$') ...
    .plotflows(sol_bb);
%% 
% In this example we chained together multiple function calls on |plot_builder_bb| 
% (note the line continuation syntax "|...|" at the end of each line). We could 
% rewrite the example more verbosely as 

plot_builder_bb.titles("Height", "Velocity");
plot_builder_bb.labels('$h$', '$v$');
% etc.
% Plot Hybrid Arcs
% In this next example, we switch the order of the plots by calling |slice([2, 
% 1])|, which causes component 2 to be plotted first, followed by component 1 
% (the |slice| function can be also be used to reduce the dimension of system 
% by specifying only some components, hence the name). The final call to |plotHyrbidArc| 
% generates plots of the solution versus both |t| and |j.|

figure()
plot_builder_bb.titles("Height", "Velocity") ... % The order of the titles must match the order of the components in the solution.
    .slice([2, 1]) ... % Switch the order
    .plotHyrbidArc(sol_bb);
%% 
% 
% Plot state
% We can also plot the trajectory of the system in phase space as follows. When 
% plotting in phase space, only the first title is used.

figure()
plot_builder_bb = HybridPlotBuilder();
plot_builder_bb.title("Phase Space: $v$ vs. $h$") ...
    .labels('$h$', '$v$') ...
    .plot(sol_bb)
%% 
% Next, we plot the trajectory of the system in phase space using a customized 
% plotting configuration. Note that we are using the same object |plot_builder_bb|, 
% so the values we set for the title and labels are preserved.

figure()
plot_builder_bb ...
    .flowColor("black") ...
    .flowLineStyle("--") ...
    .flowLineWidth(1) ...
    .jumpColor([0, 0.8, 0]) ... % RGB for jump color
    .jumpStartMarker("s") ... % square marker
    .jumpEndMarker(">") ... % triangle
    .jumpLineWidth(2) ...
    .jumpLineStyle(":") ...
    .jumpStartMarkerSize(6) ...
    .jumpEndMarkerSize(6) ...
    .slice([2, 1]) ... % Switch the order of the variables.
    .plot(sol_bb)
%% Plot Flow Lengths
% The |HybridUtils.plotFlowLengths| function plots the length for each interval 
% of flow for a given solution object. 

figure()
HybridUtils.plotFlowLengths(sol_bb)
% Plot state for a 3D system
% The following example shows a 3-dimensional hybrid system (based on Example 
% 6.20 from the _Hybrid Dynamical Systems_ textbook with continuous time $t$ as 
% the third component).

figure()
clf
system_3D = Example3DHybridSystem();
x0 = [0; 1; 0];
tspan = [0, 20];
jspan = [0, 100];
sol_3D = system_3D.solve(x0, tspan, jspan);

HybridPlotBuilder().title("Phase Space") ...
    .labels("$x_1$", "$x_2$", "$t$") ...
    .jumpLineStyle(":") ...
    .plot(sol_3D)
view([63.6 28.2])
% Plotting System Modes
% This example demonstrates the ability to change the appearance of portions 
% of a hybrid plot. The system |system_with_modes| consists of a continuous-valued 
% variable $z \in \mathbb{R}^2$ and a discrete-valued variable $q \in \{0, 1\}$. 
% 
% We use |slice([1, 2])| to omit the $q$ variable from the plot. Then, we create 
% an array |q| that contains the value of $q$ at each time step. Calling |filter(q 
% == 0)| then allows us to plot only the time steps where $q(t, j) = 0$

figure();
% A 3D system with a continuous variable z \in \reals^2
% and a discrete variable q \in {0, 1}
system_with_modes = ExampleModesHybridSystem();

for i=1:7
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
    hold on
    % Plot in black the solution (still only the [1,2] components) for all time
    % steps where q == 1. 
    builder.flowColor("black") ...
        .jumpColor("none") ...
        .filter(q == 1) ... % Only plot points where q is 1.
        .plot(sol_modes)
end
%% 
% Next, we add a legend. Note that in the loop above, a new instance of |HybridPlotBuilder| 
% is created in each iteration, so the legend will only have two entries. 

builder.legend("$q = 0$", "$q = 1$");
%% Quick System Definition with _HybridSystemBuilder_
% We also provide a quicker way to create a hybrid system in-line instead of 
% creating a new subclass of |HybridSystem|. (This method creates systems that 
% are slower to solve and harder to debug, so it is not reccomended for anything 
% but testing out simple systems.)

figure()
system_EZ = HybridSystemBuilder() ...
            .f(@(x, t) t*x) ... % the function arguments can by (x), (x,t), or (x, t, j).
            .g(@(x) -x/2) ...
            .C(@(x) abs(x) <= 1) ...
            .D(@(x) 1) ...
            .flowPriority() ... % Select flow priority.
            .build();
sol_EZ = system_EZ.solve(0.5, [0, 10], [0, 10]);

% We can call "plot", "plotflows", and "plotjumps" on HybridSolution objects. 
% Doing so uses a HybridPlotBuilder with default settings to generate the plot. 
plot(sol_EZ) 
%% More Help
% For more details on how to write |HybridSystems| and |CompoundHybridSystems|, 
% uncomment and run the following commands: 

% f = publish("HybridSystem_demo"); web(f);
% f = publish("CompoundHybridSystems_demo"); web(f);
%% Works in Progress and Known Defects
%% 
% * Documentation is still a work in progress. Most the new features are demonstrated 
% above or in the documents generated in "More Help", but these have only been 
% lightly edited will likely be revised heavily.
% * We haven't yet integrated our examples and documentation in MATLAB's help 
% browser.
% * There is a lot of inconsistency in the naming of variables and functions, 
% so we plan to sweep through all the new code to make it consistent (perhaps 
% using <https://www.ee.columbia.edu/~marios/matlab/MatlabStyle1p5.pdf this document> 
% as a guide.<https://www.ee.columbia.edu/~marios/matlab/MatlabStyle1p5.pdf >)
% * Plots produced by |HybridPlotBuilder.plotjumps()| do not match plots created 
% by the |plotjumps| function in v2.04.
% * The |HybridPlotBuilder.legend()| function does not place the legends correctly 
% in a figure with multiple subfigures.
% * When multiple subplots are created by |HybridPlotBuilder.plotHybridArc()|, 
% the axes should be linked so rotation, zooming, etc., in one subplot is mirrored 
% in all the others plot (the one exception is vertical scaling, which is left 
% independent for each component).
% * When using |HybridPlotBuilder.filter()|, the line segements on both sides 
% of a filtered point are hidden. This can be undesirable if, say, every other 
% point is filtered, because it would cause the entire solution to be hidden. 
% Additionally, if the point on either side of a jump is filtered, then the entire 
% jump is hidden.