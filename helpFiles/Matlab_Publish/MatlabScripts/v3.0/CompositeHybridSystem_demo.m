%% Create and Simulate Multiple Interlinked Hybrid Systems
%% Mathematical Formulation
% In this document, we demonstrate how to simulate multiple interlinked hybrid systems. 
% Consider the controlled hybrid systems $\mathcal H_1$ and $\mathcal H_2$ with 
% data $(f_1, g_1, C_1, D_1)$ and $(f_2, g_2, C_2, D_2)$ and state spaces 
% $\mathcal X_1$ and $\mathcal X_2.$ Let $x_1 \in \mathcal X_1$ and $x_2 \in \mathcal X_2.$
% The dynamics of $\mathcal H_1$
% 
% $$ \left\{\begin{array}{ll} 
%    \dot{x}_1 = f_1(x_1, u_1, t, j_1) \quad &(x_1, u_1) \in C'_1 \times U_{C1} =: C_1 \\
%    x_1^+ = g_1(x_1, u_1, t, j_1) \quad &(x_1, u_1) \in D'_1 \times U_{D1} =: D_1 
% \end{array} \right. $$
% 
% and the dynamics of $\mathcal H_2$ are 
%
% $$ \left\{\begin{array}{ll} 
%    \dot{x}_2 = f_2(x_2, u_2, t, j_2) \quad &(x_2, u_2) \in C'_2 \times U_{C2} =: C_2 \\
%    x_2^+ = g_2(x_2, u_2, t, j_2) \quad &(x_2, u_2) \in D'_2 \times U_{D2} =: D_2 
% \end{array} \right. $$
%
% Note that $\mathcal H_1$ and $\mathcal H_2$ use the same continuous time
% $t$ but different discrete times $j_1$ and $j_2.$ 
%
% To create feedback connections between $\mathcal H_1$ and $\mathcal H_2,$ 
% we choose the inputs
% $u_1 = \kappa_{1C}(x_1, x_2)$ when $x_1 \in C'_1$; 
% $u_1 = \kappa_{1D}(x_1, x_2)$ when $x_1 \in D'_1$;
% $u_2 = \kappa_{2C}(x_1, x_2)$ when $x_2 \in C'_2$; and 
% $u_2 = \kappa_{2D}(x_1, x_2)$ when $x_2 \in D'_2$. 
%
% We now define the system $\tilde H$ that is the composition of subsystems 
% $\mathcal H_1$ and $\mathcal H_2.$ The state $\tilde x$ of $\tilde H$ is the
% concatenation of $x_1$ and $x_2$ along with $j_1, j_2\in N$
% that track the discrete times of the subsystems (since they can jump at
% different times). That is, $\tilde x = (x_1, x_2, j_1, j_2).$ 
% We want the system to flow whenever both subsystems are in their respective 
% flow sets and to jump whenever either is in their jump set. Priority
% is given to jumps.
% Thus, we use the flow set $\tilde C := C_1' \times C_2',$ and the jump set 
% $\tilde D = (D_1'\times \mathcal X_2) \bigcup (\mathcal X_1 \times D_2').$
% The flow map is 
%
% $$ \dot{\tilde{x}} = \tilde{f}(\tilde x):= \left[\begin{array}{c}
%       f_1(x_1, \kappa_{1C}(x_1, x_2), t, j_1) \\ 
%       f_2(x_2, \kappa_{2C}(x_1, x_2), t, j_2) \\ 
%       0 \\ 
%       0 \end{array}\right].$$
%
% The jump map depends on whether $\tilde x$ is in $D_1'\times \mathcal X_2$
% or $\mathcal X_1 \times D_2'$. If $\tilde x \in D_1'\times \mathcal X_2,$
% then
%
% $$\tilde x^+ = \tilde{g}_1(\tilde x):= \left[\begin{array}{c}
%       g_1(x_1, \kappa_{1D}(x_1, x_2), t, j_1) \\ 
%       x_2 \\ 
%       j_1 + 1 \\ 
%       j_2 \end{array}\right]$$
%
% and if $\tilde x \in \mathcal X_1 \times D_2',$ then
%
% $$\tilde x^+ = \tilde{g}_2(\tilde x):= \left[\begin{array}{c}
%       x_1 \\ 
%       g_2(x_2, \kappa_{2D}(x_1, x_2), t, j_2) \\ 
%       j_1 \\ 
%       j_2 + 1 \end{array}\right].$$

%% Implement a Hybrid Subsystem
% To create a composition of two hybrid subsystems, we first write subclasses of
% the |HybridSubsystem| class. In the following example, we
% will use |ExampleHybridSubsystem|, which is a bouncing ball-like
% system, except that gravity is not constant, rather it is controlled by
% the input. 
% 
% <include>ExampleHybridSubsystem.m</include>
%
% Then, we can create two instances (here they happen to both be the same class, 
% but they will generally be different classes):
subsystem1 = ExampleHybridSubsystem();
subsystem2 = ExampleHybridSubsystem();

%% Create a Composite Hybrid System
% Now that we have two subsystems, we pass these to the
% |CompositeHybridSystem| constructor to create a coupled system.
sys = CompositeHybridSystem(subsystem1, subsystem2);

%%
% Next, we set the input functions for each subsystem. The flow
% input functions generate the input for the respective subsystem during
% flows and the jump input functions generates the input at jumps. 
% The first argument identifies the subsystem for the given function and can be
% the ordinal number of a subsystem, an object reference to a subsystem, or
% (explained later) a string name of a subsystem.
sys.setJumpInput(1, @(y1, y2) y1(1)); 
sys.setFlowInput(subsystem2, @(y1, y2) y1(1)-y2(1));

%% 
% The input functions must have between zero and $N+2$ input arguments,
% where $N$ is the number of subsystems. The first $N$ arguments are passed
% the output values of each corresponding subsystem, and, if present, the
% $N+1$ argument is passed the continuous time |t| for the composite system
% (same as the continuous time of the subsystems), and the $N+2$ argument is passed the discrete
% time |j| for that subsystem, whic is _not_ (in general) the same as the
% discrete time of the subsystem.
% 
% For example, we can make downward acceleration ("gravity") of the first
% ball decrease every time it bounces with the following feedback:
sys.setFlowInput(1, @(y1, y2, t, j) -9.8/(j+1));

%%
% The display function prints useful information regarding the connections
% between the subsystems. Note that by default, feedback functions return a
% zero vector of the appropriate size.
disp(sys)

%% Alternative Ways to Reference Subsystems
% In addition to referencing subsystems by their index number, they can
% also be referenced by passing the subsystem object.
% Thus, the command |sys.setJumpInput(1, @(y1, y2) y1(1));| can be replaced
% by 
sys.setJumpInput(subsystem1, @(y1, y2) y1(1)); 

%%
% Additionally, names can be given to each subsystem by passing strings before
% each subsystem in the |CompositeHybridSystem| constructor. If any subsystems
% are named, then all the subsystems must be named. 
sys_named = CompositeHybridSystem("Plant", subsystem1, "Controller", subsystem2)

%% 
% If the subsystems are named, we can use the names when setting inputs.
% Thus, the following three lines are equivalent:
sys_named.setFlowInput(1, @(y1, y2) -y2);
sys_named.setFlowInput(subsystem1, @(y1, y2) -y2);
sys_named.setFlowInput("Plant", @(y1, y2) -y2);

%%
% Hereafter, we call the collection of these three means of referring to
% subsystems as _subsystem IDs_.

%% Compute a solution
% To compute a solution, we call |solve| on the system, similar to a
% standard |HybridSystem|, but the first two arguments are the initial
% states of the two subsystems (rather than passing the concatenated
% composite state). The solve function handles the necessary concatenation
% of the states and appends the discrete time variables |j1| and |j2|.
x1_initial = [10;  0];
x2_initial = [ 0; 10];
tspan = [0, 30];
jspan = [0, 30];
sol = sys.solve({x1_initial; x2_initial}, tspan, jspan);

%% Interpret and Plot the Solution
% The |solve| function returns a |CompositeHybridSolution| object that contains all the
% information from |HybridSolution|.
sol

%% 
% Plotting |sol|, we see that the system jumped whenever the first or third
% components reached zero.
HybridPlotBuilder()...
    .labels("$h_1$", "$v_1$", "$h_2$", "$v_2$")...
    .slice(1:4)... % Only plot subsystem state vectors, not j1, j2.
    .plotFlows(sol);

%% Subsystem Solutions
% The solutions to subsystems can be accessed by placing a subsystem ID within
% parenteses immediately after |sol|.
sol(1);
sol(subsystem2);

%% 
% If names were passed to the constructor when |sys| was created, we could also
% reference the subsystem references by name, e.g., |sol('Plant')|.
% Subsystem solutions have all the same properties as a |HybridSolution|, as
% well as the control input, which is stored in the property |u|. 
sol(1).termination_cause

%% 
% The solutions to the subystems can plotted just like any other solution.
% Note that when the solution to one subsystem jumps, the others do not
% necessarily jump at the same time.

figure()
hpb = HybridPlotBuilder()...
    .labels("$h$", "$v$")...
    .legend("$\mathcal H_1$", "$\mathcal H_1$")...
    .titles("Height", "Velocity");
hpb.plotFlows(sol(1));
hold on
hpb.flowColor("k").jumpColor("g")...
    .plotFlows(sol(subsystem2));

%% Plotting Control Signal
% We are still developing easy ways to plot the control signal, but for now
% you can simply pass the t, j, and u from the 
% subystem solutions to |plotFlows|.
HybridPlotBuilder().plotFlows(sol(2), sol(2).u)

%% Example: Single System
% The |CompositeHybridSystem| class can also be used with a single subsystem
% for cases where you want to be able to modify the feedback functions
% without modifying the code for the system. 
sys_1 = CompositeHybridSystem(subsystem1);
sys_1.setFlowInput(1, @(y1, t, j) -5);   
sys_1.setJumpInput(1, @(y1, t, j) 0);   
sol_1 = sys_1.solve({x1_initial}, tspan, jspan);

%% Example: Zero-order Hold
% As a case study in creating a composition of hybrid systems, consider the
% following example. First, we create a linear time-invariant plant. The
% class |hybrid.subsystems.LinearContinuousSubsystem| is a subclass of
% |HybridSubsystem|. 

A_c = [0, 1; -1, 0];
B_c = [0; 1];
plant = hybrid.subsystems.LinearContinuousSubsystem(A_c, B_c);
     
%% 
% Create a linear feedback for the plant that asymptotically stabilizes the
% origin of the closed loop system.
K = [0, -2];
controller = hybrid.subsystems.MemorylessSubsystem(2, 1, @(x, u) K*u);

%% 
% Next, we create a zero-order hold subsystem. 
zoh_dim = plant.input_dimension;
sample_time = 0.3;
zoh = hybrid.subsystems.ZeroOrderHold(zoh_dim, sample_time);
 
%% 
% Remark: The creation of the subsystem objects included the full package path
% to each class (That is "hybrid.subsystems"). The package path can be omitted
% if the package is first omitted:
import hybrid.subsystems.*
zoh = ZeroOrderHold(zoh_dim, sample_time);

%%
% For the sake of clarity, we use the explicit path throughout.

%% 
% Next, we create the composite hybrid system by passing the plant, controller,
% and ZOH subsystems to the |CopoundHybridSystem| constructor.
cl_sys = CompositeHybridSystem(plant, controller, zoh);

%%
% Set inputs functions for each subsystem.
cl_sys.setInput(plant, @(~, ~, y_zoh) y_zoh);
cl_sys.setInput(controller, @(y_plant, ~, ~) y_plant);
cl_sys.setInput(zoh, @(~, y_controller, ~) y_controller );

%% 
% Print the system to check that everything is connected as expected.
cl_sys

%% 
% Finally, simulate and plot.
sol_zoh = cl_sys.solve({[10; 0], [], [0; zoh.sample_time]}, [0, 10], [0, 100]);
HybridPlotBuilder().slice(1:3).labels("$x_1$", "$x_2$", "$u_{ZOH}$")...
    .plotFlows(sol_zoh)

%% 
% The subsystem solutions can also be plotted in isolation.
HybridPlotBuilder()...
    .title("Trajectory of Plant State")...
    .plot(sol_zoh(plant))
axis equal
axis padded

%% Example: Switched System
% We create a composite system that consists of a plant, two controllers, and a
% switch that toggles between the controllers based on some criteria. 
clf 
A = [0, 1; 0, 0];
B = [0; 1];
plant = hybrid.subsystems.LinearContinuousSubsystem(A, B);
controller_0 = hybrid.subsystems.MemorylessSubsystem(2, 1, @(~, z_plant) [-1, -1]*z_plant);
controller_1 = hybrid.subsystems.MemorylessSubsystem(2, 1, @(~, z_plant) [ 2, -1]*z_plant);
switcher = hybrid.subsystems.SwitchSubsystem(1);
sys = CompositeHybridSystem(plant, controller_0, controller_1, switcher);

%% 
% The full state vector is passed as input to the controllers. We can ommit the
% '~'s from the argument list since we only use the first argument is used. 
sys.setInput(controller_0, @(z_plant, ~, ~, ~) z_plant);  % '~'s included 
sys.setInput(controller_1, @(z_plant) z_plant); % '~'s omitted

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
sys.setInput(switcher, @(z_plant, u0, u1) ...
                        switcher.wrapInput(u0, u1, norm(z_plant) >= 3, norm(z_plant) <= 1));
                    
%% 
% The output of the switch is passed to the plant.
sys.setInput(plant, @(~, ~, ~, u_switched) u_switched);

%%
% Compute a solution. Note that the MemorylessSubsystems have no state, so empty
% arrays are given in |x0| for the corresponding subsystems.
x0 = {[10; 0], [], [], 1};
sol = sys.solve(x0, [0, 100], [0, 100]);

HybridPlotBuilder()....
    .labels("$z_1$", "$z_2$", "$q$")...
    .slice(1:3)... % Ignore j1,j2,j3 components
    .configurePlots(@(ndx) ylim("padded"))... % Might not work on older versions of Matlab.
    .plotFlows(sol)
