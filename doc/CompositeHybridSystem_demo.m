%% Create and Simulate Multiple Interlinked Hybrid Systems
%% Mathematical Formulation
% In this document, we demonstrate how to simulate multiple interlinked hybrid systems. 
% Consider the controlled hybrid systems $\mathcal H_1$ and $\mathcal H_2$ with 
% data $(f_1, g_1, C_1, D_1)$ and $(f_2, g_2, C_2, D_2)$ and state spaces 
% $\mathcal X_1$ and $\mathcal X_2.$ Let $x_1 \in \mathcal X_1$ and $x_2 \in \mathcal X_2.$
% The dynamics of $\mathcal H_1$ and $\mathcal H_2$ are
% 
% $$ \left\{\begin{array}{ll} 
%    \dot{x}_1 = f_1(x_1, u_{C1}, t, j_1) &(x_1, u_{C1}, t, j_1) \in C_1 \\
%    x_1^+ = g_1(x_1, u_{D1}, t, j_1) &(x_1, u_{D1}, t, j_1) \in D_1 
% \end{array} \right. \quad $$ and 
% $$ \quad \left\{\begin{array}{ll} 
%    \dot{x}_2 = f_2(x_2, u_{C2}, t, j_2) &(x_2, u_{C2}, t, j_2) \in C_2 \\
%    x_2^+ = g_2(x_2, u_{D2}, t, j_2) &(x_2, u_{D2}, t, j_2) \in D_2.
% \end{array}. \right. $$
%
% Each subsystem also has output values
% 
% $$ \left\{\begin{array}{l} 
%    y_{C1} = h_{C1}(x_1, u_{C1}, t, j_1) \\
%    y_{D1} = h_{D1}(x_1, u_{D1}, t, j_1)  
% \end{array} \right. \quad $$ and $$ \quad 
%  \left\{\begin{array}{l} 
%    y_{C2} = h_{C1}(x_2, u_{C2}, t, j_2)  \\
%    y_{D2} = h_{D2}(x_2, u_{D2}, t, j_2) .
% \end{array} \right. $$
% 
% Note that $\mathcal H_1$ and $\mathcal H_2$ use the same continuous time
% $t$ but different discrete times $j_1$ and $j_2$ because they jump
% independently of each other.
%
% To create feedback connections between $\mathcal H_1$ and $\mathcal H_2,$ 
% we choose the inputs
%
% $$ \left\{\begin{array}{l}  
%   u_{C1} = \kappa_{1C}(y_{C1}, y_{C2}, t, j_1) \\  
%   u_{D1} = \kappa_{1D}(y_{D1}, y_{D2}, t, j_1)\end{array}\right.\quad $$ and 
% $$ \quad \left\{\begin{array}{l} 
%   u_{C2} = \kappa_{2C}(y_{C1}, y_{C2}, t, j_2) \\
%   u_{D2} = \kappa_{2D}(y_{D1}, y_{D2}, t, j_2)\end{array}.\right.$$ 
%
% We define the system $\tilde H$ as the composition of subsystems 
% $\mathcal H_1$ and $\mathcal H_2.$ The state $\tilde x$ of $\tilde H$ is the
% concatenation of $x_1$ and $x_2$ along with $j_1, j_2\in N$
% that track the discrete times of the subsystems (since they can jump at
% different times). That is, $\tilde x = (x_1, x_2, j_1, j_2).$ 
% The system will flow when both subsystems are in their respective 
% flow sets and to jump whenever either is in their jump set.
% Thus, we use the flow set $\tilde C := C_1 \times C_2,$ and the jump set 
% $\tilde D = (D_1 \times \mathcal X_2) \bigcup (\mathcal X_1 \times D_2).$ 
% In simulations, priority is given to jumps when $x$ in the intesection of $C$ and $D$.
% The flow map is 
%
% $$ \dot{\tilde{x}} = \tilde{f}(\tilde x):= \left[\begin{array}{c}
%       f_1(x_1, u_{1C}, t, j_1) \\ 
%       f_2(x_2, _{2C}, t, j_2) \\ 
%       0 \\ 
%       0 \end{array}\right].$$
%
% The jump map depends on whether $\tilde x$ is in $D_1\times \mathcal X_2$
% or $\mathcal X_1 \times D_2$. If $\tilde x \in D_1\times \mathcal X_2,$
% then
%
% $$\tilde x^+ = \tilde{g}_1(\tilde x):= \left[\begin{array}{c}
%       g_1(x_1, u_{1D}, t, j_1) \\ 
%       x_2 \\ 
%       j_1 + 1 \\ 
%       j_2 \end{array}\right],$$
%
% if $\tilde x \in \mathcal X_1 \times D_2,$ then
%
% $$\tilde x^+ = \tilde{g}_2(\tilde x):= \left[\begin{array}{c}
%       x_1 \\ 
%       g_2(x_2, u_{2D}, t, j_2) \\ 
%       j_1 \\ 
%       j_2 + 1 \end{array}\right],$$
% 
% and if $\tilde x \in D_1 \times D_2,$
% then 
% 
% $$\tilde x^+ = \tilde{g}_2(\tilde x):= \left[\begin{array}{c}
%       g_1(x_1, u_{1D}, t, j_1) \\ 
%       g_2(x_2, u_{2D}, t, j_2) \\ 
%       j_1 + 1\\ 
%       j_2 + 1 \end{array}\right].$$
% 

%% Creating Subsystems
% In the Hybrid Equations Toolbox, hybrid subsystems, such as $\mathcal{H}_1$ and
% $\mathcal{H}_2$ above, are represented by the |HybridSubsystem| class.  
% |HybridSubsystem| is an abstract class, which means that some of its methods
% are not fully defined, so a |HybridSubsystem| object cannot be created directly.
% Instead, it is necessary to implement a subclass of |HybridSubsystem| (or use
% an existing subclass) that provides the full definitions of the abstract
% methods in |HybridSubsystem|.
% In this tutorial, we use several |HybridSubsystem| subclasses located in the
% |hybrid.subsystems| package. 
help hybrid.subsystems

%% 
% Referencing a class from the hybrid.subsystems package requires 
% the full package path to each class. 
% For example, to use |ZeroOrderHold|, 
% it must be referenced as |hybrid.subsystems.ZeroOrderHold|. 
% The package path can be omitted
% if the package is first imported by calling 
% 
%   import hybrid.subsystems.*
% 
% For clarity, however, we use the explicit package path for classes throughout
% this document. 
%
% We will look at |hybrid.subsystem.BouncingBallSubsystem| as an example of how
% to implement a |HybridSubsystem|. Mathematically, we write the hybrid subsystem as
% 
% $$ \mathcal{H}_{\mathrm{BB}}:\left\{\begin{array}{ll} 
%    \dot{x} = f_{\mathrm{BB}}(x) := \left[\matrix{x_2 \\ -g}\right]
%       & x \in C_{\mathrm{BB}} := \{(x_1, x_2) \in R^2 \mid x_1 \geq 0, x_2 \geq 0\} \\
%    x^+ = g_{\mathrm{BB}}(x, u_{D}) := \left[\matrix{x_1 \\ \gamma x_2}\right] 
%                                       + \left[\matrix{0 \\ 1}\right]u_D
%       & x \in D_{\mathrm{BB}} := \{(x_1, x_2) \in R^2 \mid x_1 \leq 0, x_2 \leq 0\}
% \end{array} \right.$$
% 
% The bouncing ball subsystem is translated into MATLAB code as follows.
% 
% <include>BouncingBallSubsystem.m</include>
%
% In the constructor for |BouncingBallSubsystem|, the state, input,
% and output dimensions and the output function are set by passing values to the
% superclass constructor |obj@HybridSubsystem|. The |flowMap|, |jumpMap|,
% |flowSetIndicator|, and |jumpSetIndicator| functions are defined similarly to
% the corresponding functions in |HybridSystem| classes with two exceptions: 
% 
% # The subsystem input $u$ is included as the second input argument for each functions.
% # All four input arguments (i.e., |'x, u, t, j'|) must be included, even if they are
% unused. (Unused arguments can be replaced with |'~'|.)

%% Output Functions
% For each subsystem, the flow output function $h_C$ and a jump output function
% $h_D$ can be set by passing zero, one, or two function handles to the
% |HybridSubsystem| superclass constructor. If no output functions handles are
% given, explictly, then the output functions return the full subsystem state
% $h_C(x) = h_D(x) = x$. If one function handle is given, then it defines output
% for both flows and jumps. If two functions are given, then the first
% defines flow output and the second defines jump output. Both functions must
% have the same size outputs, which match the output_dimension.
% The output function handle must have input arguments in one of the following
% forms: |(x), (x, u), (x, u, t)|, or |(x, u, t, j)|.
% In order for the solver to determine the order to evaluate input and outputs,
% the |u| input argument must be omitted or replaced with |'~'| if it is unused.

%% Defining HybridSubsystems in-line
% As an alternative to writing new |HybridSubsystem| subclasses, the
% |HybridSubsystemBuilder| class can be used to create |HyrbidSubsystems|
% in-line (see |doc HybridSubsystemBuilder| for details).
HybridSubsystemBuilder()...
    .stateDimension(2)...
    .inputDimension(1)...
    .outputDimension(1)...
    .flowMap(@(x, u) x + [1; 0]*u)...
    .jumpMap(@(x) 0.5*x)...
    .flowSetIndicator(@(x) norm(x) <= 0)...
    .jumpSetIndicator(@(x) norm(x) >= 0)... 
    .flowOutput(@(x) x(1))...
    .jumpOutput(@(x) x(2))...
    .build();

%%
% Creating subsytems with |HybridSubsystemBuilder| is not recommended except for
% prototypes or demonstrations (such as this tutorial) becuase it makes code
% execution slower and dubugging more difficult.

%% Creating a Composition of Hybrid Subsystems
% Then, we can create two instances (here they happen to both be the same class, 
% but they will generally be different classes):
bounce_coeff = 0.7;
gravity = -9.8;
target_period = 2.0;

% The jump set contiains points where the height and velocity are negative, 
% which indicates the ball should bounce.
D_indicator = @(x) x(1) <= 0 && x(2) <= 0; 
ball_subsys = hybrid.examples.BouncingBallSubsystem();
controller_subsys = HybridSubsystemBuilder()...
                    .flowMap(@(x) [0; 1])... % udot = 0, taudot = 1.
                    .jumpMap(@(x, u) [max(0, x(1) + target_period-x(2)); 0])...
                    .flowSetIndicator(@(x) 1)...
                    .jumpSetIndicator(@(~, u) u)...
                    .output(@(x) x(1))...
                    .stateDimension(2)...
                    .inputDimension(1)...
                    .outputDimension(1)...
                    .build();

%%
% Now that we have two subsystems, we pass these to the
% |CompositeHybridSystem| constructor to create a coupled system.
% There are two forms of the constructor arguments. The first is to simply pass
% the list of subsystems. 
% 
%   sys = CompositeHybridSystem(bb_plant, bb_controller);
% 
% Alternatively, names can be given to each subsystem by passing strings before
% each subsystem in the |CompositeHybridSystem| constructor. If any subsystems
% are named, then all the subsystems must be named. 
sys_bb = CompositeHybridSystem('Ball', ball_subsys, 'Controller', controller_subsys)

%% Subsystem Identifiers
% For each subsystem, we define its _subsystem identifiers_ as the following:
% 
% # The positive integer matching the ordinal position of the subsystem in the
% |CompositeHybridSystem| constructor arguments.
% # A refernce to the |HybridSubsystem| object itself (such as the variables
% |ball_subsys| and |controller_subsys|, above). 
% # The subsystem's name, if given in the constructor.
% 
% For example, for the system constructed above, the subsystem identifiers for
% each subsystem are: 
% 
% * |1|, |ball_subsys|, and |'Ball'|.
% * |2|, |controller_subsys|, and |'Controller'|.

%% Input Functions
% Each subsystem has a _flow input function_ and a _jump input function._ 
% The flow input function determines the input values for the subsystem during each
% interval of flow and the jump input function determines the input at
% each jump. 
% The functions |setFlowInput|, and |setJumpInput| set the
% respective input functions for a given subsystem and |setInput| sets both the flow
% input and the jump input to a single function.
% The first argument is a subsystem identifier, described above. 
% The second argument is the input function, given as a function handle. 
% The input function must have one of
% the following forms:
%
% * |@()|
% * |@(y1)|
% * $\vdots$
% * |@(y1, y2, ..., yN)|
% * |@(y1, y2, ..., yN, t)|
% * |@(y1, y2, ..., yN, t, j)|
% where '...' is replaced with the appropriate number of arguments.
% 
%   sys.setJumpInput(1, @(y1, y2) y2); 
%   sys.setInput(bb_controller, @(y1, y2) y2);
%   sys.setFlowInput('Plant', @(y1, y2) y1(1)-y2(1));
% 
% The input functions must have between zero and $N+2$ input arguments,
% where $N$ is the number of subsystems. The first $N$ arguments are passed
% the output values of each corresponding subsystem, and, if present, the
% $N+1$ argument is passed the continuous time |t| for the composite system
% (which equals the continuous time of the subsystems), and the $N+2$ argument is passed the discrete
% time |j| for that subsystem, which is _not_ (in general) the same as the
% discrete time of the composite system.
% 
% As with output functions, any unused input arguments (especially |y1|, |y1|,
% etc.) should be omitted or replaced with |'~'| so that the solver can
% determine which order to evaluate the input and output functions.
% 
% For our example, we set the jump input for the ball to be the output of the
% controller. The input for the controller is set to be the output of
% |jumpSetIndicator| so that the controller knows when the ball is in its jump set
% (i.e., when it hits the ground).

sys_bb.setJumpInput('Ball',  @( ~, y_controller) y_controller);
sys_bb.setInput('Controller', @(y_ball,  ~) ball_subsys.jumpSetIndicator(y_ball));

%%
% Calling |sys_bb| without a semicolon prints useful information for verifying
% that the inputs are wired correctly.
sys_bb

%% Computing Solutions
% To compute a solution, we call |solve| on the system, similar to a
% standard |HybridSystem| except that the first argument is a cell array 
% that contains the initial states of each subsystem (rather than passing the
% entire composite state |[x_1; x_2; ... x_N]|). Internally, the solve function
% handles the % necessary concatenation of the states and appends the discrete
% time variables |j1| and |j2|. 
x_ball_initial = [1;  0];
x_controller_initial = [0; 0];
x0_cell = {x_ball_initial; x_controller_initial};
tspan = [0, 60];
jspan = [0, 30];
sol_bb = sys_bb.solve(x0_cell, tspan, jspan)

%%
% The |CompositeHybridSystem.solve| function supports the optional arguments
% supported by |HybridSystem.solve|, such as an |HybridSolverConfig| object or
% |'silent'|. See |doc HybridSystem.solve| and |doc HybridSolverConfig|.

%% Plotting Solutions
% Plotting |sol|, we see all of the states of the composite system.
hpb = HybridPlotBuilder().subplots('on')...
    .labels('$h$', '$v$', '$u$', '$\tau$', '$j_1$', '$j_2$')...
    .titles('Ball Subsystems', '', 'Controller Subsystem', '', 'Discrete Times');
hpb.slice(1:2).plotFlows(sol_bb); 
snapnow() % Show current figure in document.
hpb.slice(3:4).plotFlows(sol_bb);
snapnow() % Show current figure in document.
hpb.slice(5:6).plotFlows(sol_bb);

%% Subsystem Solutions
% The |solve| function returns a |CompositeHybridSolution| object that contains
% all the same information as |HybridSolution|, but allows accessing the
% subsystem solutions individually (which include the state, inputs, and outputs
% for each subsystem).
% The solutions to subsystems can be accessed by placing a subsystem ID within
% parentheses immediately after |sol|.
sol_bb(1);
sol_bb(controller_subsys);
sol_bb('Ball');

%% 
% Subsystem solutions have all the same properties as a |HybridSolution|,
sol_bb('Ball').termination_cause 

%% 
% as well as the input and output values, which are stored in the properties |u|
% and |y|, respectivley.
size(sol_bb('Ball').u) 
size(sol_bb('Ball').y) 

%% 
% The solutions to the subystems can plotted just like any other solution.
clf
hpb = HybridPlotBuilder().subplots('on')...
    .labels('$h$', '$v$')...
    .titles('Height', 'Velocity');
hpb.plotFlows(sol_bb('Ball'));

%% Plotting Input and Output Signals
% The control signal for a subsystem can be plotted by passing the subsystem
% solution object and the control signal to the plotting functions in
% |HybridPlotBuilder|. If flow inputs and jump inputs are different functions,
% we recommend plotting flows and jumps separately. In our case, the jump input
% was not set, so the plot shows that the values are zero.

clf
% Plot Input Signal
subplot(2, 1, 1)
% A single HybridPlotBuilder is used twice so both plots are included in the legend. 
hpb = HybridPlotBuilder().title('Input Signal').jumpColor('none')...
    .filter([diff(sol_bb.j) == 0; 0])...
    .legend('$u_{C}$')...
    ....legend('$\kappa_{2C}(y_1(t), y_2(t))$')...
    .plotFlows(sol_bb, sol_bb('Ball').u); 
hold on
hpb.jumpMarker('*').jumpColor('r').flowColor('none')...
    .filter([diff(sol_bb.j) == 1; 0])...
    .legend({'$u_D$'}, 'location', 'northeast')...
    ....legend({'$\kappa_{2D}(y_1(t), y_2(t))$'}, 'location', 'northeast')...
    .plotFlows(sol_bb, sol_bb('Ball').u)
title('Input')
ylim('padded')

% Plot Output Signal
subplot(2, 1, 2)
HybridPlotBuilder().color('matlab')...
    ....legend({'$y_1$', '$y_2$'}, 'location', 'southeast')...
    .plotFlows(sol_bb, sol_bb('Ball').y)
title('Output')

%% Example: Zero-order Hold
% As a case study in creating a composition of hybrid systems, consider the
% following example. First, we create a linear time-invariant plant. The
% class |hybrid.subsystems.LinearContinuousSubsystem| is a subclass of
% |HybridSubsystem|. 

A_c = [0, 1; -1, 0];
B_c = [0; 1];
plant_zoh = hybrid.subsystems.LinearContinuousSubsystem(A_c, B_c);
     
%% 
% Create a linear feedback for the plant that asymptotically stabilizes the
% origin of the closed loop system.
K = [0, -2];
controller_zoh = hybrid.subsystems.MemorylessSubsystem(2, 1, @(x, u) K*u);

%% 
% Next, we create a zero-order hold subsystem. 
zoh_dim = plant_zoh.input_dimension;
sample_time = 0.3;
zoh = hybrid.subsystems.ZeroOrderHold(zoh_dim, sample_time);

%% 
% The composite hybrid system is created by passing the plant, controller,
% and ZOH subsystems to the |CompositeHybridSystem| constructor.
sys_zoh = CompositeHybridSystem(plant_zoh, controller_zoh, zoh);

%%
% Set the inputs functions for each subsystem.
sys_zoh.setInput(plant_zoh, @(~, ~, y_zoh) y_zoh);
sys_zoh.setInput(controller_zoh, @(y_plant, ~, ~) y_plant);
sys_zoh.setInput(zoh, @(~, y_controller, ~) y_controller);

%% 
% Print the system to check that everything is connected as expected.
sys_zoh

%% 
% Finally, simulate and plot.
sol_zoh = sys_zoh.solve({[10; 0], [], [0; zoh.sample_time]}, [0, 10], [0, 100]);
HybridPlotBuilder().subplots('on')...
    .slice(1:3).labels('$x_1$', '$x_2$', '$u_{ZOH}$')...
    .plotFlows(sol_zoh)

%% 
% The subsystem solutions can also be plotted in isolation.
HybridPlotBuilder().subplots('on')...
    .title('Trajectory of Plant State')...
    .plotPhase(sol_zoh(plant_zoh))
axis equal
axis padded
grid on
set(gca(), 'XAxisLocation', 'origin'); 
set(gca(), 'YAxisLocation', 'origin');

%% Example: Single Subsystem
% The |CompositeHybridSystem| class can also be used with a single subsystem
% for cases where you want to be able to modify the feedback functions
% without modifying the code for the system. 
sys_1 = CompositeHybridSystem(ball_subsys);
sys_1.setFlowInput(1, @(y1, t, j) -5);   
sys_1.setJumpInput(1, @(y1, t, j) 0);   
sol_1 = sys_1.solve({x_ball_initial}, tspan, jspan);

%% Example: Switched System
% We create a composite system that consists of a plant, two controllers, and a
% switch that toggles between the controllers based on some criteria. 
A = [0, 1; 0, 0];
B = [0; 1];
K0 = [-1, -1];
K1 = [ 2, -1];
input_dim = 1;
plant_switched = hybrid.subsystems.LinearContinuousSubsystem(A, B);
controller_0 = hybrid.subsystems.MemorylessSubsystem(2, 1, @(~, z_plant) K0*z_plant);
controller_1 = hybrid.subsystems.MemorylessSubsystem(2, 1, @(~, z_plant) K1*z_plant);
switcher = hybrid.subsystems.SwitchSubsystem(input_dim);
sys_switched = CompositeHybridSystem('plant', plant_switched, ...
                                     'kappa0', controller_0, ...
                                     'kappa1', controller_1, ...
                                     'switcher', switcher);

%% 
% The full state vector is passed as input to the controllers. We can ommit the
% '~'s from the argument list since we only use the first argument is used. 
sys_switched.setInput(controller_0, @(z_plant, ~, ~, ~) z_plant);  % '~'s included 
sys_switched.setInput(controller_1, @(z_plant) z_plant); % '~'s omitted

%%
% The current choice of controller is stored as state variable |q|
% in |switcher|, where |controller_0| is passed through as the output of
% |switcher| whenever |q = 0| and |controller_1| is passed through when |q = 1|.
% The plant state |z_plant| and output of the controllers, named |u0| and |u1|,
% are passed to the switcher. The |SwitchSubsystem| class provides a |wrapInput|
% method that handles the creation of the input vector from the given values. 
% The third argument to |wrapInput| is the criteria for switching to 
% to |q = 0| and the fourth argument is the criteria for switching to
% |q = 1|. If 
% # |q=0| and the third argument of |wrapInput| is zero, 
% # |q=1| and fourth argument of |wrapInput| is zero, or 
% # the third and fourth arguments of |wrapInput| are zero, 
% then |q| is held constant.
sys_switched.setInput(switcher, @(z_plant, u0, u1) ...
                        switcher.wrapInput(u0, u1, norm(z_plant) >= 3, norm(z_plant) <= 1));
                    
%% 
% The output of the switch is passed to the plant.
sys_switched.setInput(plant_switched, @(~, ~, ~, u_switched) u_switched);

%%
% Compute a solution. Note that the MemorylessSubsystems have no state, so empty
% arrays are given in |x0| for the corresponding subsystems.
x0 = {[10; 0], [], [], 1};
sol_switched = sys_switched.solve(x0, [0, 100], [0, 100]);

%% 
% Plot the solution, using different colors when $q=0$ and $q=2$.
clf  
hold on
q = sol_switched('switcher').x;
HybridPlotBuilder().jumpMarker('none')...
    .filter(q == 0)...
    .legend('$q = 0$')...
    .plotPhase(sol_switched('plant'))...
    .filter(q == 1)...
    .legend('$q = 1$')...
    .flowColor('green')...
    .plotPhase(sol_switched('plant'));

% Configure plot appearance
axis equal
axis padded
set(gca(), 'XAxisLocation', 'origin'); 
set(gca(), 'YAxisLocation', 'origin');