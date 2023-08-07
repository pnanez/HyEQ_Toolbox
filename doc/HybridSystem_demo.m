%% Creating and Simulating Hybrid Systems
% In this tutorial, we show how to create and solve a hybrid system 
% using the |HybridSystem| class. For a brief introduction to hybrid systems, 
% see 
% <matlab:hybrid.internal.openHelp('intro_to_hybrid_systems') here>.

%% How to create a HybridSystem Subclass 
% In this page, we will consider, as an example,
% a bouncing ball with state $x = (x_1, x_2),$ where $h := x_1$ is the height of the
% ball and $v := x_2$ is the vertical velocity. The ball can be modeled as the
% following hybrid system: 
%
% $$ 
% \left\{\begin{array}{ll}
%     \left[\begin{array}{c} \dot x_1 \\ \dot x_2 \end{array}\right] 
%                    = \left[\begin{array}{c} x_2 \\ -\gamma \end{array}\right] 
%            & x \in C := \{ (x_1, x_2) \in R^2 \mid x_1 \geq 0 \textrm{ or } x_2 \geq 0 \}  
%       \\ \\
%     \left[\begin{array}{c} x_1^+ \\ x_2^+ \end{array}\right]
%                    = \left[\begin{array}{c} x_1 \\ -\lambda x_2 \end{array}\right]
%            &x \in D := \{ (x_1, x_2) \in R^2 \mid x_1 \leq 0,\: x_2 \leq 0 \} 
% \end{array} \right.
% $$ 
%
% where $\gamma > 0$ is the acceleration due to gravity and $\lambda \geq 0$ is the
% coefficient of restitution when the ball hits the ground. 
% 
% We define a MATLAB implementation of the bouncing ball in 
% |<matlab:open('hybrid.examples.BouncingBall')
% hybrid.examples.BouncingBall.m>|. 
% A script for running the bouncing ball example is provided at
% <matlab:open('hybrid.examples.run_bouncing_ball')
% |hybrid.examples.run_bouncing_ball|> (the prefix |hybrid.examples.| indicates the 
% <matlab:hybrid.internal.openHelp('MATLAB_packages') package namespace> that 
% contains |BouncingBall.m| and |run_bouncing_ball.m|).
% The structure of |BouncingBall.m| is as
% follows.
% 
%   classdef BouncingBall < HybridSystem
%       % Define bouncing ball system as a subclass of HybridSystem.
%       properties
%           % Define variable class properties.
%           ...
%       end
%       properties(SetAccess = immutable)  
%           % Define constant (i.e., "immutable") class properties.
%           ...
%       end
%       methods 
%           % Define functions, including definitions of f, g, C, and D.
%           ...
%       end
%   end 
% 
% In the first line, |"classdef BouncingBall  < 
% HybridSystem"| specifies that |BouncingBall| is a
% subclass of the |HybridSystem| class,
% which means it inherits the attributes of that class.
% Within MATLAB classes, |properties| blocks define 
% variables and constants that can be accessed on instances of the class. For
% |BouncingBall|, there are two |properties| blocks. The first defines variable
% variables for the system parameters $\gamma$ and $\lambda$.
% 
%   classdef BouncingBall < HybridSystem
%       properties
%           gamma = 9.8; % Acceleration due to gravity.
%           lambda = 0.9; % Coefficient of bounce restitution.
%       end
%       ...  
%   end
% 
% The second properties block defines constants that cannot be modified. The
% block attribute |SetAccess = immutable| means that the values cannot be
% changed once an object is constructed. We define two "index" constants that
% are useful for referencing components of the state vector |x|. 
% 
%   classdef BouncingBall < HybridSystem
%       ...
%       properties(SetAccess = immutable) 
%           % The index of 'height' component within the state vector 'x'. 
%           height_index = 1;
%           % The index of 'velocity' component within the state vector 'x'. 
%           velocity_index = 2;
%       end
%       ...
%   end
% 
% For more complicated systems, it is sometimes useful to define constants for a
% range of indices. For example, if  $u, v \in \mathbf{R}^{4}$ and 
% 
% $$x = \left[\begin{array}{c} u, v \end{array}\right],$$
% 
% then we could define the following immutable properties:
% 
%   v_indices = 1:4;
%   u_indices = 4 + (1:4); % These parentheses are important!
% 
% Then, we can extract |u| and |v| from |x| as 
% 
%   v = x(v_indices);
%   u = x(u_indices);
% 
% 
% Next, in |BouncingBall|, the |methods| block defines functions that
% can be called on |BouncingBall| objects. 
% Every subclass of |HybridSystem| must define the functions
% |flowMap|, |jumpMap|, |flowSetIndicator|, and |jumpSetIndicator|. 
% The indicator functions must return |1| 
% inside their respective sets and |0| otherwise.
% 
%   function xdot = flowMap(this, x, t, j)
%       % Define the flow map f.
%       % Set xdot to the value of f(x, t, j).
%       ...
%   end
%
%   function xplus = jumpMap(this, x, t, j)
%       % Define the jump map g.
%       % Set xplus to the value of g(x, t, j).
%       ...
%   end
%     
%   function inC = flowSetIndicator(this, x, t, j)
%       % Define the flow set C. 
%       % Set 'inC' to 1 if 'x' is in the flow set C and to 0 otherwise.
%       ...
%   end
% 
%   function inD = jumpSetIndicator(this, x, t, j)
%       % Define the flow set C. 
%       % Set 'inD' to 1 if 'x' is in the jump set D and to 0 otherwise.
%       ...
%   end
% 
% Notice that the first argument in each function method is |this|, which
% provides a reference to the object on which the
% function was called. 
% The object's properties are referenced within the methods using 
% |this.gamma|, |this.lambda|, etc. After the |this| argument, there must be
% one, two, or three arguments that are either |(x)|, |(x, t)|, or |(x, t, j)|, 
% as needed.
% The full class definition of |BouncingBall| is shown next.
% 
% <include>BouncingBall.m</include>
%
% An instance of the |BouncingBall| class is then created as follows:  
bb_system = hybrid.examples.BouncingBall();

%% 
% Values of the properties can be modified using dot indexing on the object:
bb_system.gamma = 3.72;
bb_system.lambda = 0.8;

%%
% For more information about writing MATLAB classes, see
% the
% <https://www.mathworks.com/help/matlab/matlab_oop/create-a-simple-class.html
% online MATLAB documentation>.

%%
% WARNING: The functions |flowMap|, |flowSetIndicator|, and |jumpSetIndicator| must be
% deterministic—each time they are called for a given set of inputs 
% |(x, t, j)|, they must return the same output values.
% In other words, |flowMap|, |flowSetIndicator|, and |jumpSetIndicator| must be
% _functions_ in the mathematical sense. 
% If they depend on system parameters stored as object properties, then
% those parameters must be constant during each execution of
% |HybridSystem.solve| (described below).
% It is okay to change the system parameters
% in between calls to |solve|, but all values that change during a solution, must be
% included in the state vector |x|.  
% 
% The reason for this warning is that modifying system parameters within
% |flowMap|, |flowSetIndicator|, or |jumpSetIndicator| will produce
% unpredictable behavior because the hybrid 
% solver does not move monotonically forward in time;
% Sometimes, the solver backtracks while computing a solution to $\dot{x} = f(x),$ 
% such as when searching for the time when $x$ enters $D$ or leaves $C$.
% The |jumpMap|, on the other hand, can be
% nondeterministic, such as including random noise, without causing the same
% sort of problems because the solver never backtracks across a jump.
%  
% To protect against accidentally modifying system parameters,
% each parameter can be stored as an
% <https://www.mathworks.com/help/matlab/matlab_oop/mutable-and-immutable-properties.html immutable object property> 
% that is set when the |HybridSystem| object is constructed. 
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

%% Asserting Conditions on Hybrid Systems
% When implementing a hybrid system, it is helpful to verify 
% that certain points are or are not in $C$ or in $D.$
% This is accomplished in |HybridSystem| with four functions: 
% |assertInC|, |assertInD|, |assertNotInC|, and |assertNotInD|.

% Define some points.
x_ball_above_ground = [1; 0];
x_ball_at_ground    = [0; 0]; % and stationary
x_ball_below_ground = [-1; -1]; % and moving down

% Check the above-ground point.
bb_system.assertInC(x_ball_above_ground);    
bb_system.assertNotInD(x_ball_above_ground);

% Check the at-ground point.
bb_system.assertInC(x_ball_at_ground); 
bb_system.assertInD(x_ball_at_ground);

% Check the below-ground point.
bb_system.assertNotInC(x_ball_below_ground); 
bb_system.assertInD(x_ball_below_ground);

%%
% In addition to checking that a given point is in the desired set, the functions 
% |assertInC|, |assertInD| check that the flow or jump map, respectively, 
% can be evaluated at the point and produces a vector with the correct dimensions.
% 
% If an assertion fails, as in following code, then an error is thrown and execution 
% is terminated (unless caught by a try-catch block):

try
    bb_system.assertInD(x_ball_above_ground) % This fails.
catch e 
    fprintf(2,'Error: %s\n', e.message);
end

%% Compute Solutions
% A numerical approximation of a solution to the hybrid system is computed by calling the |solve|
% function. The |solve| function returns 
% a |HybridSolution| object that contains information about the (approximate) solution (use 
% the properties |t|, |j|, and |x| to recover the standard output from |HyEQSolver|). 
% To compute a solution, pass the initial state and time spans to the 
% |solve| function (|solve| is defined in the |HybridSystem| class and |bb_system| is a 
% |HybridSystem| object because |BouncingBall| 
% is a subclass of |HybridSystem|). Optionally, a |HybridSolverConfig| object
% can be passed to the solver to set various configurations (see below).

x0 = [10, 0];
tspan = [0, 20];
jspan = [0, 30];
config = HybridSolverConfig('refine', 32); % Improves plot smoothness for demo.
sol = bb_system.solve(x0, tspan, jspan, config);
plotFlows(sol); % Display solution

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
% A description of each |HybridSolution| property is described in...


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
% <matlab:hybrid.internal.openHelp('Help_behavior_in_C_intersection_D') Behavior in the Intersection of C and D> 
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