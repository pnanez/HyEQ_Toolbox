%% Example 4.1: Finite State Machine with Input in Simulink
% In this example, a finite state machine (FSM) is 
% modeled in Simulink as a hybrid system with an input, where the input
% triggers the discrete transitions (or jumps).
% 
% Click
% <matlab:hybrid.open('../Examples/CPS_examples/FSM','FSM_example.slx') here> 
% to change your working directory to the FSM folder and open the
% Simulink model. 
%% Mathematical Model
% 
% The FSM system is modeled as a hybrid system
% with the following data: 
% 
% $$\begin{array}{ll}
% f(q,u):=\left[\begin{array}{c}
%    0 \\
%  0
%  \end{array}\right],
%    & C := \{ (q,u) \in \{1, 2\} \times \{1, 2\} \times \{1, 2\} \times \{1, 2\} \mid \delta(q, u) = q \} 
% \\ \\ 
% g(x,u):= \delta(q, u) = \left[ \begin{array}{c} 
%                    3 - u_{1} \\ 3 - u_{2}
%                \end{array}\right],
%    & D: = \{ (q,u) \in \{1, 2\} \times \{1, 2\} \times \{1, 2\} \times \{1, 2\} \mid \delta(q, u) \in \{1, 2\}\times \{1, 2\}\backslash q\}
% \end{array}$$
%
% $$
%   y:= h(q) = q
% $$
%
% 
% where the input and the state are given by $u = (u_{1}, u_{2})\in \{1, 2\}\times \{1, 2\}$, and $q = (q_{1}, q_{2})\in \{1, 2\}\times \{1, 2\}$, respectively.
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |FSM_example.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open('../Examples/CPS_examples/FSM') Examples/CPS_examples/FSM>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open('../Examples/CPS_examples/FSM','FSM_example.slx') |FSM_example.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
wd_before = hybrid.open('../Examples/CPS_examples/FSM');

% Run the initialization script.
initialization_exFSM

% Run the Simulink model.
sim('FSM_example')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the FSM. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open FSM_example.slx. A screenshot will be
% automatically included in the published document.
open_system('FSM_example')

%%
% The Simulink blocks for the hybrid system in this example are included below.
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
%    2 \quad t\in[2k, 2k + 0.4)\\
%  1 \quad t\notin [2k, 2k + 0.4)\\
%  \end{array}\right., \\ \\
% u_{2}(t,u):=\left\{\begin{array}{ll}
%    2 \quad t\in[3k + 1, 3k + 1.6)\\
%  1 \quad t\notin [3k + 1, 3k + 1.6)\\
%  \end{array}\right.
% \end{array}
% $$
% 
% for all $k\in \mathbf{N}$
% The solution to the FSM system from $x(0,0)=[1,2]^\top$ and with
% |T=10, J=20, rule=1| shows the mode transition of the FSM system.

clf
HybridPlotBuilder().subplots('on')...
    .labels('$q_{1}$', '$q_{2}$')...
    .legend('$q_{1}$', '$q_{2}$')...
    .plotFlows(sol)

%% Modifying the Model
% * The _Embedded MATLAB function blocks_ |f, C, g, D| are edited by
%   double-clicking on the block. In each embedded function
%   block, parameters must be added as inputs and defined as parameters by
%   selecting |Tools>Edit Data/Ports|, and setting the scope to |Parameter|. 
% * In the initialization script |initialization_exFSM.m|, the flow time and jump
%   horizons, |T| and |J| are defined as well as the 
%   initial conditions for the state vector, $x_0$, and input vector, $u_0$, and
%   a rule for jumps, |rule|. 
% * The simulation stop time and other simulation parameters are set to the
%   values defined in |initialization_exFSM.m| by selecting |Simulation>Configuration
%   Parameters>Solver| and inputting |T|, |RelTol|, |MaxStep|, etc..  

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 
