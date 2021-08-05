%% How to Create and Simulate Systems of Two Interlinked Hybrid Systems with Inputs
%% Mathematical Formulation
% In this document, we demonstrate how to use the Hybrid Equations Toolbox
% to simulate multiple interlinked hybrid systems. 
% Consider the controlled hybrid systems $\mathcal H_1$ and $\mathcal H_2$ with 
% data $(f_1, g_1, C_1, D_1)$ and $(f_2, g_2, C_2, D_2)$ with state spaces 
% $\mathcal X_1$ and $\mathcal X_2.$ Let $x_1 \in \mathcal X_1$ and $x_2 \in \mathcal X_2.$
% Then dynamics of $\mathcal H_1$
% 
% $$ \dot{x}_1 = f_1(x_1, u_1, t, j_1) \quad (x_1, u_1) \in C'_1 \times U_{C1} =: C_1 $$
% 
% $$ x_1^+ = g_1(x_1, u_1, t, j_1) \quad (x_1, u_1) \in D'_1 \times U_{D1} =: D_1 $$
% 
% and the dynamics of $\mathcal H_2$ are 
%
% $$ \dot{x}_2 = f_2(x_2, u_2, t, j_2) \quad (x_2, u_2) \in C'_2 \times U_{C2} =: C_2$$
%
% $$x_2^+ = g_2(x_2, u_2, t, j_2) \quad (x_2, u_2) \in D'_2 \times U_{D2} =: D_2.$$
%
% Note that $\mathcal H_1$ and $\mathcal H_2$ use the same continuous time
% $t$ but different discrete times $j_1$ and $j_2.$ 
%
% To create feedback connections between $\mathcal H_1$ and $\mathcal H_2,$ 
% we choose the inputs
% $u_1 = \kappa_{1C}(x_1, x_2)$ while $x \in C'_1$; 
% $u_1 = \kappa_{1D}(x_1, x_2)$ while $x \in D'_1$;
% $u_2 = \kappa_{2C}(x_1, x_2)$ while $x \in C'_2$; and 
% $u_2 = \kappa_{2D}(x_1, x_2)$ while $x \in D'_2$. 
%
% We now define the compound system $\tilde H$ that consists of subsystems 
% $\mathcal H_1$ and $\mathcal H_2.$ The state $\tilde x$ of $\tilde H$ is the
% concatenation of $x_1$ and $x_2$ along with two natural numbers $j_1$ and $j_2$
% that track the discrete times of the subsystems (since they can jump at
% different times). That is, $\tilde x = (x_1, x_2, j_1, j_2).$ 
% We want the system to flow whenever both subsystems are in their respective 
% flow sets and to jump whenever either is in their jump set, and priority
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

%% Implement a Controlled Hybrid System in MATLAB
% To create a compound system of two hybrid subsystems, we first write subclasses of
% the |ControlledHybridSystem| class. In the following example, we
% will use |ExampleControlledHybridSystem|, which is a bouncing ball-like
% system, except that gravity is not constant, rather it is controlled by
% the input. 
% 
% <include>ExampleControlledHybridSystem.m</include>
%
% Then, we can create two instances (here they happen to both be the same class, 
% but they will generally be different classes):
subsystem1 = ExampleControlledHybridSystem();
subsystem2 = ExampleControlledHybridSystem();

%% Create a Compound Hybrid System
% Now that we have two subsystems, we merely pass these to the
% |CompoundHybridSystem| constructor to create a coupled system.
sys = CompoundHybridSystem(subsystem1, subsystem2);

%%
% Next, we set the feedback functions for each subsystem. The functions
% |kappa_1C| and |kappa_1D| generate the input for subsystem1 during flows
% and jumps, respectively, and |kappa_2C| and |kappa_2D| do the same for
% subsystem 2. 
sys.kappa_1C = @(x1, x2) -5;   
sys.kappa_1D = @(x1, x2) 0;   
sys.kappa_2C = @(x1, x2) x1(1) - x2(1);   
sys.kappa_2D = @(x1, x2) 0;     

%% Compute a solution
% To compute a solution, we call |solve| on the system, similar to a
% standard |HybridSystem|, but the first two arguments are the initial
% states of the two subsystems (rather than passing the concatenated
% compound state). The solve function handles the necessary concatenation
% of the states and appends the discrete time variables |j1| and |j2|.
x1_initial = [10;  0];
x2_initial = [ 0; 10];
tspan = [0 30];
jspan = [0, 30];
sol = sys.solve(x1_initial, x2_initial, tspan, jspan);

%% Interpret and Plot the Solution
% The |solve| function returns a |CompoundHybridSolution| object that contains all the
% information from |HybridSolution|.
sol

%% 
% Plotting |sol|, we see that the system jumped whenever the first or third
% components reached zero.
HybridPlotBuilder()...
    .labels("$h_1$", "$v_1$", "$h_2$", "$v_2$")...
    .slice(1:4).plotflows(sol);

%% 
% Now, we may want the solutions of the two subsystems separately. 
% The |CompoundHybridSolution| object contains two additional properties not 
% defined in the |HybridSolution| class: |subsystem1_sol| and |subsystem2_sol|.
% As the names suggest, these contain the solutions of the subsystems. 
% Looking at the solution for subystem1, we see all the data from |HybridSolution|
% along with a new property |u| that contains the input to |subsystem1| that 
% generated this solution:% 
sol.subsystem1_sol

%% 
% The solutions to the subystems can plotted just like any other solution.
% Note that when the solution to one subsystem jumps, the other does not
% necessarily jump at the same time.

figure()
hpb = HybridPlotBuilder()...
    .labels("$h$", "$v$")...
    .title("Height", "Velocity");
hpb.plotflows(sol.subsystem1_sol);
hold on
hpb.flowColor("k").jumpColor("g")...
    .plotflows(sol.subsystem2_sol);

hpb.legend("$\mathcal H_1$", "$\mathcal H_1$", "$\mathcal H_2$", "$\mathcal H_2$");

%%
% (Note: There is currently an  defect in the placement of legends for subplots, 
% so the legends for all subplots are placed in the first one.)
