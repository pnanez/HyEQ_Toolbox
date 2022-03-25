%% Introduction to the Hybrid Equations Toolbox
% The Hybrid Equation (HyEQ) Toolbox provides methods in MATLAB and Simulink 
% for computing and plotting numerical solutions to hybrid dynamical systems. 

%% Mathematical Formulation of Hybrid Systems
% A hybrid system is a dynamical system with both continuous-time and
% discrete-time dynamics.
% The model of a hybrid system $\mathcal H$ on a state space $\mathbf{R}^n$ is
% defined by the following objects:
% 
% * A set $C \subset \mathbf{R}^n$ called the _flow set_.
% * A function $f : \mathbf{R}^n \to \mathbf{R}^n$ called the _flow map_.
% * A set $D \subset \mathbf{R}^n$ called the _jump set_.
% * A function $g : \mathbf{R}^n \to \mathbf{R}^n$ called the _jump map_.
%% 
% We consider the simulation of hybrid systems $\mathcal  H = (C,f,D,g)$ written 
% as
% 
% $$
% \mathcal{H}: \left\{\begin{array}{ll}
%       \dot x = f(x) & x \in C \\ 
%       x^+ = g(x) & x \in D 
% \end{array}\right.$$
% 
% where $x \in \mathbf{R}^n$. The flow map $f$ defines the continuous dynamics 
% on the flow set $C$, while the jump map $g$ defines the discrete dynamics on 
% the jump set $D$. These objects are referred to as the _data_ of the hybrid 
% system $\mathcal H$ and are denoted$\mathcal H = (C,f,D,g)$. 

%% Directory Structure of the Hybrid Equations Toolbox
% * |matlab/|: contains the source code for the MATLAB portion of the toolbox. 
% * |simulink/|: contains the source code for the Simulink portion of the toolbox.
% * |docs/|: contains documentation, which is also accessible in MATLAB Help 
% (F1) > Supplemental Software > Hybrid Equations Toolbox.
% * |Examples/|: contains the source code for the examples that are described 
% in the documentation.

%% Where to Find Help
% * Documentation for the toolbox can be found in MATLAB Help (F1) at Supplemental 
% Software > Hybrid Equations Toolbox.
% * To see documentation for a particular component of the toolbox, execute  
% |help [name]| or |doc [name]| in the command line, where |[name]| is the name 
% of a class, function, or package
% (|help| prints a short description and |doc| opens the documentation page).
% * To report a problem, request a feature, or ask for help, <https://github.com/pnanez/HyEQ_Toolbox/issues/new 
% submit an issue> on our GitHub repository. 
% * A webinar introducing the HyEQ Toolbox v2.04 is available 
% <http://www.mathworks.com/videos/hyeq-a-toolbox-for-simulation-of-hybrid-dynamical-systems-81992.html here> 
% (a free registration is required).

%% Troubleshooting
% *Problem*: When I call |HybridSystem.solve()|, the following error appears: 
% "|Error using HyEQsolver. Too many input arguments.|" 
% 
% *Cause*: A previous version of the toolbox still installed. 
% 
% *Solution*: Uninstall the previous hybrid toolbox version by running |tbclean| 
% inside the installation directory of the prior version.
%% 
% *Problem*: I just uninstalled v2.40 and installed v3.0 of the Hybrid Equations 
% Toolbox. Now X is not working.
% 
% *Solution*: Restart MATLAB.
%% MATLAB-based Hybrid Simulator
% In this section, we will briefly demonstrate how to use the MATLAB-based portion 
% of the hybrid toolbox to compute, analyze, and plot solutions to a hybrid system. 
% We present these examples to introduction to what is possible and direct you 
% to other pages in the documentation for detailed explanations for how to create, 
% simulate, analyze and plot hybrid systems. For details about how to implement 
% a hybrid system with the toolbox, see <matlab:showdemo HybridSystem_demo How 
% to Implement and Solve a Hybrid System>. For more information about plotting 
% hybrid solution, see <matlab:showdemo HybridPlotBuilder_demo Creating plots 
% with HybridPlotBuilder>. 
% Creating and Solving a Hybrid System
% In this example, we demonstrate a new approach to solving a hybrid system 
% and plotting a solution. In |BouncingBallHybridSystem.m|, we define a hybrid 
% system by creating a subclass of the |HybridSystem| class and implementing the 
% |flowMap, jumpMap, flowSetIndicator, jumpSetIndicator| functions in order to 
% specify $f, g, C$, and $D$, respectively.
% 
% <include>../Examples/+hybrid/+examples/BouncingBall.m</include>
%% 
% We then create an instance of the bouncing ball system:

sys_bb = hybrid.examples.BouncingBall();
%% 
% A solution is then computed by calling the |solve| function on |system_bb| 
% with the initial state and time spans as arguments. The |solve| function returns 
% a |HybridSolution| object that contains information about the solution (use 
% the properties |t, j,| and |x| to recover the standard output from |HyEQSolver|). 

x0 = [1; 0];
tspan = [0, 20];
jspan = [0, 30];
config = HybridSolverConfig('Refine', 32); % 'Refine' makes plots smoother.
sol_bb = sys_bb.solve(x0, tspan, jspan, config)
% Plotting Hybrid Arcs
% A collection of plotting functions are provided to plot |HybridSolution| objects.  
%% 
% * |plotFlows|: plot a hybrid arc vs. ordinary time.
% * |plotJumps|: plot a hybrid arc vs. discrete time|.| 
% * |plotHybrid|: plot a hybrid arc vs. ordinary and discrete time.
% * |plotPhase|: plot the hybrid arc in phase space.
%% 
% Each function is called by passing a |HybridSolution| object to it. 

plotHybrid(sol_bb) 
%% 
% To customize the appearance of plots, use the |HybridPlotBuilder| class, which 
% has options for configuring lines, markers, text, etc. To generate plots, we 
% create a |HybridPlotBuilder| object,  configure the plot via a series of function 
% calls, and, finally, generate the plot with a call to one of the plotting functions 
% (|plotFlows|, |plotJumps|, etc). An example is presented below. For a how-to 
% guide to using HybridPlotBuilder, see <matlab:showdemo HybridPlotBuilder_demo 
% Creating plots with HybridPlotBuilder>.

figure()
HybridPlotBuilder()... % Create an instance of HybridPlotBuilder
    .title('Bouncing Ball') ...
    .subplots('on')... % Place each component in a separate subplot
    .labels('$h$', '$v$') ...
    .legend('height', 'velocity')...
    .flowColor('black') ...
    .flowLineStyle('--') ...
    .flowLineWidth(1) ...
    .jumpColor([0, 0.8, 0]) ... % RGB color
    .jumpStartMarker('s') ... % Square marker
    .jumpStartMarkerSize(8) ...
    .jumpEndMarker('none') ...
    .jumpLineWidth(2) ...
    .jumpLineStyle(':') ...
    .plotFlows(sol_bb) % Generate plot
% Modifying Hybrid Arcs
% Often, after calculating a solution to a hybrid system, we wish to manipulate 
% the resulting data, such as evaluating a function along the solution, removing 
% some of the components, or truncating the hybrid domain. A suite of functions 
% to this end are included in the |HybridArc| class (|HybridSolution| is a subclass 
% of |HybridArc|, so the solutions generated by |HybridSystem.solve| are |HybridArc| 
% objects|).|

clf
hybrid_arc = sol_bb.slice(1);                 % Pick the 1st component.
hybrid_arc = hybrid_arc.transform(@(x) -x);   % Negate the value.
hybrid_arc = hybrid_arc.restrictT([4.5, 7]);  % Truncate to t-values between 4.5 and 7.
plotFlows(hybrid_arc)
% Asserting Conditions on Hybrid Systems
% When implementing a hybrid system, it is helpful to verify whether $C$ and 
% $D$ contain particular points. This is accomplished with four functions in |HybridSystem: 
% assertInC|, |assertInD|, |assertNotInC,| and |assertNotInD|. 

x_ball_above_ground = [1; 0];
sys_bb.assertInC(x_ball_above_ground);
sys_bb.assertNotInD(x_ball_above_ground);
%% 
% In addition to checking that a given point is in the desired set, the functions 
% |assertInC|, |assertInD| also check that the flow or jump map, respectively, 
% can be evaluated at the point and produces a vector with the correct dimensions.
% 
% If an assertion fails, as in following code, then an error is thrown and execution 
% is terminated:

try
    sys_bb.assertInD(x_ball_above_ground) % This fails.
catch e 
    fprintf(2,'Error: %s', e.message);
end
% Multiple Interlinked Hybrid Systems
% The Hybrid Equations Toolbox also supports defining multiple subsystems that 
% are joined together to create a composite hybrid system. 
% 
% To implement a composite hybrid system, a |CompositeHybridSystem| object is 
% constructed from one or more |HybridSubsytem| objects. |HybridSubsystems| can 
% either be implemented by writing a subclass of |HybridSubsystem| or using one 
% of the existing subclasses in the |hybrid.subsystems| package. 
% 
% In the following example we create a composite system that consists of three 
% subsystems: a linear time-invariant plant, a controller, and a zero-order hold. 
% Each is a subclass of |HybridSubsystem|. As before, this only intended as an 
% introduction for what is possible. For details about about creating and using 
% composite systems, see <matlab:showdemo CompositeHybridSystem_demo Create and 
% Simulate Multiple Interlinked Hybrid Systems>.

% Create LTV plant
A_c = [0, 1; -1, 0];
B_c = [0; 1];
plant_zoh = hybrid.subsystems.LinearContinuousSubsystem(A_c, B_c);

% Create a linear feedback controller.
K = [0, -2];
controller_zoh = hybrid.subsystems.MemorylessSubsystem(2, 1, @(x, u) K*u);

% Create a zero-order hold subsystem. 
zoh_dim = plant_zoh.input_dimension;
sample_time = 0.3;
zoh = hybrid.subsystems.ZeroOrderHold(zoh_dim, sample_time);

% Create the composite system
sys_zoh = CompositeHybridSystem(plant_zoh, controller_zoh, zoh);

% Set the connections between the subsystems
sys_zoh.setInput(plant_zoh, @(~, ~, y_zoh) y_zoh);
sys_zoh.setInput(controller_zoh, @(y_plant, ~, ~) y_plant);
sys_zoh.setInput(zoh, @(~, y_controller, ~) y_controller);

% Create the initial state for each subsystem
x0_plant = [10; 0];
x0_controller = []; % Controller is memoryless, so the state is empty.
x0_zoh = [0; zoh.sample_time];
x0_composite = {x0_plant, x0_controller, x0_zoh}; 

% Compute a solution.
sol_zoh = sys_zoh.solve(x0_composite, [0, 10], [0, 100]);

% Plot the solution
HybridPlotBuilder().subplots('on')...
    .slice(1:3).labels('$x_1$', '$x_2$', '$u_{ZOH}$')...
    .plotFlows(sol_zoh)
%% Simulink-based Hybrid Simulator
% <TO-DO>