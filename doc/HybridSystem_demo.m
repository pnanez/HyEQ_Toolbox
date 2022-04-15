%% Creating and Solving Hybrid Systems
%% How to create a HybridSystem Subclass
% In this tutorial, we show how to create and solve a hybrid system 
% using the |HybridSystem| class. A basic knowledge of hybrid systems is
% assumed. For in-depth descriptions of hybrid systems, see [1,2].
% 
% Consider a bouncing ball with height $x_1$ and vertical velocity $x_2$. The 
% ball can be modeled as the following hybrid system:
%
% $$ 
% \left\{\begin{array}{ll}
%     \left[\begin{array}{c} \dot x_1 \\ \dot x_2 \end{array}\right] 
%                    = \left[\begin{array}{c} x_2 \\ -g \end{array}\right] 
%            & x \in C := \{ (x_1, x_2) \in R^2 \mid x_1 \geq 0 \textrm{ or } x_2 \geq 0 \}  \\
%     \left[\begin{array}{c} x_1^+ \\ x_2^+ \end{array}\right]
%                    = \left[\begin{array}{c} x_1 \\ -\gamma x_2 \end{array}\right]
%            &x \in D := \{ (x_1, x_2) \in R^2 \mid x_1 \leq 0,\: x_2 \leq 0 \} 
% \end{array} \right.
% $$ 
%
% where $g >0$ is the acceleration due to gravity and $\gamma > 0$ is the
% coeffient of restitution when the ball hits the ground.
% We define a MATLAB implementation of the bouncing ball in 
% |<matlab:open('hybrid.examples.BouncingBall') hybrid.examples.BouncingBall.m>|:
% 
% <include>BouncingBall.m</include>

%% 
% In the first line of file, |"classdef BouncingBall  < 
% HybridSystem"| specifies that |BouncingBall| is a
% subclass of the |HybridSystem| class, 
% which means it inherits all the methods and properties of that class. Next, 
% we define several variables in the |properties| block and functions in the |methods| 
% block. Every subclass of |HybridSystem| must define the |flowMap, jumpMap, flowSetIndicator,| 
% and |jumpSetIndicator| functions. The indicator functions must return |1| 
% inside their respective sets and |0| otherwise.
% 
% Notice that the first argument in each function method is |this|, which
% provides a reference to the object on which the
% function was called. The object's properties are referenced using |this.gravity| and
% |this.bounce_coeff|. For more information about writing MATLAB classes, see
% the
% <https://www.mathworks.com/help/matlab/matlab_oop/create-a-simple-class.html
% online MATLAB documentation>.

% Create an instance of the BouncingBall class.
bb_system = hybrid.examples.BouncingBall();
%% 
% Values of the properties can be modified using dot indexing on the object:
bb_system.gravity = 3.72;
bb_system.bounce_coeff = 0.8;

%%% Asserting Conditions on Hybrid Systems
% When implementing a hybrid system, it is helpful to check whether $C$ and 
% $D$ contain particular points.
% This is accomplished in |HybridSystem| with four functions: 
% |assertInC|, |assertInD|, |assertNotInC|, and |assertNotInD|.

x_ball_above_ground = [1; 0];
x_ball_at_ground    = [0; 0];
x_ball_below_ground = [-1; -1]; % and moving down

% Above ground.
bb_system.assertInC(x_ball_above_ground);    
bb_system.assertNotInD(x_ball_above_ground);

% At ground, stationary.
bb_system.assertInC(x_ball_at_ground); 
bb_system.assertInD(x_ball_at_ground);

% Below ground, moving down.
bb_system.assertNotInC(x_ball_below_ground); 
bb_system.assertInD(x_ball_below_ground);

%%
% In addition to checking that a given point is in the desired set, the functions 
% |assertInC|, |assertInD| check that the flow or jump map, respectively, 
% can be evaluated at the point and produces a vector with the correct dimensions.
% 
% If an assertion fails, as in following code, then an error is thrown and execution 
% is terminated:

try
    bb_system.assertInD(x_ball_above_ground) % This fails.
catch e 
    fprintf(2,'Error: %s', e.message);
end

%%
% WARNING: For any given values |(x, t, j)|, the
% functions |flowMap|, |jumpMap|, |flowSetIndicator|, and |jumpSetIndicator|
% must always return the same value each time they are called while computing a
% solution. Modifying global variables or object properties within
% |flowMap|, |jumpMap|, etc., will produce unpredictable behavior because the hybrid
% solver sometimes backtracks in time (e.g., when searching for the time
% when a jump occurs). Therefore, all values that change during a solution must
% be included in the state vector |x|.
% For this reason, we recommend storing each parameter as an
% <https://www.mathworks.com/help/matlab/matlab_oop/mutable-and-immutable-properties.html immutable object property> 
% that is set in the constructor. 
% The value of an immutable property cannot be modified after an object is created.
% An example of how to implement an immutable property is included here:
%
%   classdef MyHybridSystem < HybridSystem
%      properties(SetAccess=immutable)
%          my_property % cannot be modified except in the constructor
%      end
%      methods
%          function this = MyHybridSystem(my_property) % Constructor
%              this.my_property = my_property; % set immutable property value.
%          end
%      end
%   end
%
% The value of |my_property| is set when a |MyHybridSystem| is constructed:
% 
%   sys = MyHybridSystem(3.14); 
%   assert(sys.my_property == 3.14)
%
% For more information about immutable properties see the MATLAB documentation
% <https://www.mathworks.com/help/matlab/matlab_oop/mutable-and-immutable-properties.html here>.

%% Compute Solutions
% A solution is computed by calling the |solve| function. 
% The |solve| function returns 
% a |HybridSolution| object that contains information about the solution (use 
% the properties |t|, |j,| and |x| to recover the standard output from |HyEQSolver|). 
% To compute a solution, pass the initial state and time spans to the 
% |solve| function (|solve| is defined in the |HybridSystem| class and |bb_system| is a 
% |HybridSystem| object because |BouncingBall| 
% is a subclass of |HybridSystem|). Optionally, a |HybridSolverConfig| object
% can be passed to the solver to set various configurations (see below).

x0 = [10, 0];
tspan = [0, 20];
jspan = [0, 30];
config = HybridSolverConfig('refine', 32); % Improves plot smoothness.
sol = bb_system.solve(x0, tspan, jspan, config);
plotFlows(sol);

%% 
% The use of |HybridSolverConfig| is described below, in 
% <#configuration_options "Solver Configuration Options">
% 
% The option |'refine'| for |HybridSolverConfig| causes computed ODE solutions
% to be smoothly interpolated between timesteps. 
% For documentation about plotting hybrid arcs, see 
% <matlab:hybrid.internal.openHelp('HybridPlotBuilder_demo') Plotting Hybrid Arcs>.

%% Information About Solutions
% 
% The return value of the |solve| method is a |HybridSolution| object that contains 
% information about the solution.
sol

%% 
% A description of each |HybridSolution| property is as follows:
%
% * |t|: The continuous time values of the solution's hybrid time domain.
% * |j|: The discrete time values of the solution's hybrid time domain.
% * |x|: The state vector of the solution.
% * |x0|: The initial state of the solution.
% * |xf|: The final state of the solution.
% * |flow_lengths|: the durations of each interval of flow.
% * |jump_times|: the continuous times when each jump occured.
% * |shortest_flow_length|: the length of the shortest interval of flow.
% * |total_flow_length|: the length of the entire solution in continuous time.
% * |jump_count|: the number of discrete jumps.
% * |termination_cause|: the reason that the solution terminated. 
%
% The possible values for |termination_cause| are 
% 
% * |STATE_IS_INFINITE|
% * |STATE_IS_NAN|
% * |STATE_NOT_IN_C_UNION_D|  
% * |T_REACHED_END_OF_TSPAN| 
% * |J_REACHED_END_OF_JSPAN|
% * |CANCELED|

%% Modifying Hybrid Arcs
% Often, after calculating a solution to a hybrid system, we wish to manipulate 
% the resulting data, such as evaluating a function along the solution, removing 
% some of the components, or truncating the hybrid domain. Several functions 
% to this end are included in the |HybridArc| class (|HybridSolution| is a subclass 
% of |HybridArc|, so the solutions generated by |HybridSystem.solve| are |HybridArc| 
% objects). 
% In particular, the functions are |slice|, |transform|, |restrictT| and
% |restrictJ|. 
% See |<matlab:doc('HybridArc') doc('HybridArc')>| for details.

hybrid_arc = sol.slice(1);                    % Pick the 1st component.
hybrid_arc = hybrid_arc.transform(@(x) -x);   % Negate the value.
hybrid_arc = hybrid_arc.restrictT([1.5, 12]); % Truncate to t-values between 4.5 and 7.
hybrid_arc = hybrid_arc.restrictJ([2, inf]);  % Truncate to j-values >= 2.

% Plot hybrid arcs
clf
hpb = HybridPlotBuilder();
hpb.color('black').legend('Original').plotFlows(sol.slice(1));
hold on
hpb.color('red').legend('Modified').plotFlows(hybrid_arc)

%% 
% *Example:* Suppose we want to compute the total energy
% of the bouncing ball: 
%
% $$E(x) = gx_1 + \frac{1}{2} x_2^2.$$
%
% We can map the |HybridArc| object |sol| to a new |HybridArc| with the
% |transform| function. (Note that the state dimension before ($n=2$) and after ($n=1$)
% are not the same.)
% 
clf
energy_fnc = @(x) bb_system.gravity*x(1) + 0.5*x(2)^2;
plotFlows(sol.transform(energy_fnc))
title('Total Energy of Bouncing Ball')
ylabel('E')
%%
% 
% <html><p id="configuration_options">
%   <!--Tag for linking to next section. We place it here to compenesate for 
%       MATLAB's misalignment when opening links to subsections.-->
% </html>

%% Solver Configuration Options
% 
% To configure the hybrid solver, create a
% |HybridSolverConfig| object and pass it to |solve| as follows:
config = HybridSolverConfig('AbsTol', 1e-3);
bb_system.solve(x0, tspan, jspan, config);

%% 
% There are three categories of options that can be configured with
% |HybridSolverConfig|:
% 
% # Jump/Flow Priority for determining the behavior of solutions in $C \cap D$.
% # ODE solver options.
% # Hybrid solver progress updates options.
% 
% <html><h3>Jump/Flow Priority</h3></html>
% 
% By default, the hybrid solver gives precedence to jumps when the solution
% is in the intersection of the flow and jump sets. This can be changed by
% setting the |priority| to one of the (case insensitive) strings |'flow'| or
% |'jump'|. For an example for how changing the priority affects solutions, see 
% <matlab:hybrid.internal.openHelp('Help_behavior_in_C_intersection_D') Jump/Flow Behavior in the Intersection of C and D> 
% (the linked example uses Simulink instead of MATLAB, which has an additional 
% "random" priority mode, not currently supported in the MATLAB HyEQ library). 
config.priority('flow');
config.priority('jump');
 
%%
% <html><h3>ODE Solver Options</h3></html>
% 
% The ODE solver function and solver options can be modified in |config|. 
% To set the ODE solver, pass the name of the ODE solver function name to
% the |odeSolver| function. The default is |'ode45'|. 
% For guidence in picking an ODE solver, 
% see <https://www.mathworks.com/help/matlab/math/choose-an-ode-solver.html this list>.

config.odeSolver('ode23s');

%% 
% Most of the options for the builtin MATLAB ODE solvers (described
% <matlab:doc('odeset') here>) can be set within |HybridSolverConfig|. 
% A list of supported functions is provided below.
% To set an ODE solver option, use the |odeOption| function:
config.odeOption('AbsTol', 1e-3); % Set the absolute error tolerance for each time step.

%% 
% Several commonly used options can be set by passing name-value pairs to the
% |HybridSolverConfig| constructor. The options that can be set this way are
% |'odeSolver'|, |'RelTol'|, |'AbsTol'|, |'MaxStep'|, |'Jacobian'|, and
% |'Refine'|.
config = HybridSolverConfig('odeSolver', 'ode23s', ...
                            'RelTol', 1e-3, 'AbsTol', 1e-4,  ...
                            'MaxStep', 0.5, 'Refine', 4);

% Display the options struct.
config.ode_options

%%
% Some of the ODE solver options have not been tested with the hybrid equation solver. 
% The following table lists all ODE solver options and information about whether 
% the HyEQ solver supports each. For a description of each option, see
% |<matlab:doc('odeset') doc('odeset')>.|
% 
% <html>
% <table>
%   <tr>
%     <th>ODE Option</th>
%     <th>Supported?</th>
%   </tr>
%   <tr>
%     <td>RelTol</td>
%     <td>Yes</td>
%   </tr>
%   <tr>
%     <td>AbsTol</td>
%     <td>Yes</td>
%   </tr>
%   <tr>
%     <td>NormControl</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>NonNegative</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>OutputFcn</td>
%     <td>No. Use 'progress' function.</td>
%   </tr>
%   <tr>
%     <td>OutputSel</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>Refine</td>
%     <td>Yes</td>
%   </tr>
%   <tr>
%     <td>Stats</td>
%     <td>Yes, but will print stats </br> after each interval of flow.</td>
%   </tr>
%   <tr>
%     <td>InitialStep</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>MaxStep</td>
%     <td>Yes</td>
%   </tr>
%   <tr>
%     <td>Events</td>
%     <td>No</td>
%   </tr>
%   <tr>
%     <td>Jacobian</td>
%     <td>Yes</td>
%   </tr>
%   <tr>
%     <td>JPattern</td>
%     <td>Yes</td>
%   </tr>
%   <tr>
%     <td>Vectorized</td>
%     <td>Untested, but probably won't work.</td>
%   </tr>
%   <tr>
%     <td>Mass</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>MStateDependence</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>MvPattern</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>MassSingular</td>
%     <td>Untested</td>
%   </tr>
%   <tr>
%     <td>InitialSlope </td>
%     <td>Yes, for DAEs</td>
%   </tr>
% </table>
% </html>

%%  
% <html><h3>Progress Updates</h3></html>
% 
% Computing a hybrid solution can take considerable time, so progress updates are
% displayed. Progress updates can be disabled by passing |'silent'| to
% |config.progess()|.
config.progress('silent');

% To restore the default behavior:
config.progress('popup');

%% 
% For brevity, |'silent'| can be also be passed as the first argument to the
% |HybridSolverConfig| constructor.
% 
%   HybridSolverConfig('silent', <other options>);
% 

%%
% Alternatively, |'silent'| can be passed directly to |solve| in place of
% |config|, if no other solver configurations are desired.
% 
%   bb_system.solve(x0, tspan, jspan, 'silent');

%% Concise Hybrid System Definitions
% We also provide a quicker way to create a hybrid system in-line instead of
% creating a new subclass of HybridSystem.
% This approach creates systems that are slower to solve and harder to debug, so
% use with care—creating a subclass of |HybridSystem| is the recommended method
% for defining complicated systems.
system_inline = HybridSystemBuilder() ...
            .f(@(x, t) t*x) ... 
            .g(@(x) -x/2) ...
            .C(@(x) 1) ...
            .D(@(x, t, j) abs(x) >= j) ...
            .build();
sol_inline = system_inline.solve(0.5, [0, 10], [0, 10]);
%%
% The functions |f|, |g|, |C| and |D| can have 1, 2, or 3 input arguments, namely 
% |(x)|, |(x,t)|, or |(x, t, j)|.

%%
% The definition of hybrid systems can be made even more concise by passing
% function handles for |f|, |g|, |C| and |D| to the |HybridSystem| function,
% which constructs a |HybridSystem| with the given data. Again, this approach is
% slower and harder to debug, so it is not generally recommended.
f = @(x, t) t*x;
g = @(x) -x/2;
C = @(x) 1;
D = @(x, t, j) abs(x) >= j;
system_inline = HybridSystem(f, g, C, D);

%% References
% [1] R. Goebel, R. G. Sanfelice, and A. R. Teel, 
% _Hybrid Dynamical Systems: Modeling, Stability, and Robustness._ 
% Princeton University Press, 2012.
% 
% [2] R. G. Sanfelice, _Hybrid Feedback Control._ Princeton University Press, 2021. 
