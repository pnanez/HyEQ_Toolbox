%% CPS Component: Finite State Machine
% In this example, a finite state machine (FSM) is 
% modeled in Simulink as a hybrid system with an input, where the input
% triggers the discrete transitions (or jumps).

%% 
% The files for this example are found in the package
% |hybrid.examples.finite_state_machine|:
% 
% * <matlab:open('hybrid.examples.finite_state_machine.initialize') initialize.m> 
% * <matlab:hybrid.examples.finite_state_machine.fsm fsm.slx> 
% * <matlab:open('hybrid.examples.finite_state_machine.postprocess') postprocess.m> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+finite_state_machine')) |Examples\+hybrid\+examples\finite_state_machine|>
% (clicking this link changes your working directory). 

%% Mathematical Model
% A _finite state machine_ (FSM), also called a _deterministic finite automaton_ (DFA) is a system with
% inputs, states, and outputs taking values from finite sets that are updated at discrete transitions (or jumps)
% triggered by its inputs. 
% For a FSM with state $q \in Q$ and input $u \in \Sigma,$ the update mechanism
% at jumps is determined by the difference equation 
% 
% $$
% q^+ = \delta(q,u) \qquad (q,u) \in Q \times \Sigma
% $$
% 
% and the output of the system is 
% 
% $$y = h(q) \qquad q \in Q.$$
% 
% The FSM system is modeled as a hybrid system with the following data: 
% 
% $$\begin{array}{ll}
% f(q,u):=\left[\begin{array}{c}
%    0 \\
%    0
%  \end{array}\right],
%    & C := \{ (q,u) \in Q \times \Sigma \mid \delta(q, u) = q \} 
% \\ 
% g(q,u):= \delta(q, u) = \left[ \begin{array}{c} 
%                    u_{1} + u_2 \\ u_1 - u_{2}
%                \end{array}\right],
%    & D: = \{ (q,u) \in Q \times \Sigma \mid \delta(q, u) \neq q\} 
% \\ 
%   y:= h(q) = q
% \end{array}$$
%
% where the state is given by $q = (q_{1}, q_{2})\in Q := \{0, 1, 2\}\times \{-1, 0, 1\}$ 
% and the input is given by $u = (u_{1}, u_{2})\in \Sigma := \{0, 1\}\times \{0, 1\}$.
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |FSM_example.slx|:
% 
% * Open
% <matlab:hybrid.examples.finite_state_machine.fsm |hybrid.examples.finite_state_machine.fsm.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.

% Run the initialization script.
hybrid.examples.finite_state_machine.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.finite_state_machine.fsm');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the FSM.
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open .slx model. A screenshot of the subsystem will be
% automatically included in the published document.
model_path = 'hybrid.examples.finite_state_machine.fsm';
open_system(which(model_path))

%%
% The functions used to define $f, g, C,$ and $D$ in the |FSM| blocks 
% are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_FSM/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_FSM/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_FSM/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_FSM/D.m</include>

%% Example Output
% Let the input function be 
% 
% $$\begin{array}{ll}
% u_{1}(t,u):=\left\{\begin{array}{ll}
%    1 & \textrm{if } t\in[2k,\ 2k + 0.4) = [0, 0.4) \cup [2, 2.4) \cup \cdots \\
%    0 & \textrm{otherwise} \\
%  \end{array}\right., \\ \\
% u_{2}(t,u):=\left\{\begin{array}{ll}
%    1 & \textrm{if } t\in[3k + 1,\ 3k + 1.6) = [1, 1.6) \cup [4, 4.6) \cup \cdots\\
%    0 & \textrm{otherwise} \\
%  \end{array}\right.
% \end{array}
% $$
% 
% for all $k\in \mathbf{N}$.
clf
input = HybridArc(t, j, vs); %#ok<IJCL> 
% stairs(vs)
HybridPlotBuilder().subplots('on')...
    .color('matlab')...
    .jumpMarker('none')...
    .labels('$u_{1}$', '$u_{2}$')...
    .legend('$u_{1}$', '$u_{2}$')...
    .configurePlots(@(ax, ndx) ylim(ax, 'padded'))...
    .plotFlows(input)

%%
% The solution to the FSM system from $x(0,0)=[0,0]^\top$ and with
% |T=10|, |J=20|, |rule=1| shows the mode transition of the FSM system.
% By comparing with the prior figure, we see that $q_1 = u_1 + u_2$ and 
% $q_2 = u_1 - u_1,$ as expected. 

clf
HybridPlotBuilder().subplots('on')...
    .labels('$q_{1}$', '$q_{2}$')...
    .legend({'$q_{1}$', '$q_{2}$'}, 'Location', 'best')...
    .configurePlots(@(ax, ndx) ylim(ax, 'padded'))...
    .plotFlows(sol)

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
