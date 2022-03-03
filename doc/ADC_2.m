%% Example: Interconnection of a Bouncing Ball and an Analog to Digital Converter in Simulink
% In this example, the interconnection of a bouncing ball system and an
% analog to digital converter (ADC) is modeled in Simulink as a hybrid system.
% 
% Click
% <matlab:hybrid.open('ADC_V002','ADC_example2.slx') here> 
% to change your working directory to the ADC_V002 folder and open the
% Simulink model. 
%% Mathematical Model
% 
% The bouncing ball system is modeled as a hybrid system
% with the following data: 
% 
% $$\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%  x_2 \\
%  - \gamma
%  \end{array}\right],
%    & C := \{ (x,u) \in \mathbf{R}^2 \times \mathbf{R} \mid x_1 \geq 0 \}
%    \\ \\
% g(x,u):=\left[ \begin{array}{c} 
%                    0 \\ - \lambda x_2
%                \end{array}\right],
%    & D: = \{ (x,u) \in \mathbf{R}^2 \times \mathbf{R} \mid x_1 \leq 0, x_2 \leq 0 \}
% \end{array}$$
% 
% where the input $u$ is the height of the platform on which the ball bounces,
% $x_1$ is the poition of the ball, $x_2$ is the velocity of the ball, 
% $\gamma > 0$ is the gravity constant, and $\lambda \in [0,1)$ is the 
% restitution coefficient.
%
% The analog to digital converter is modeled as a hybrid system
% with the following data: 
% 
% $$\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%  0 \\
%  1
%  \end{array}\right],
%    & C := \{ (x,u) \in \mathbf{R}^2 \times \mathbf{R} \mid (x_2 \geq 0)
%    \wedge (x_2 \leq T_s) \} \\ \\
% g(x,u):=\left[ \begin{array}{c} 
%                    u \\ 0
%                \end{array}\right],
%    & D: = \{ (x,u) \in \mathbf{R}^2 \times \mathbf{R} \mid x_2 > T_s \}
% \end{array}$$
% 
% where the input $u$ to the ADC is the ball position and velocity, $x_1$ is a memory state used to store
% the samples of $u$, $x_2$ is a timer that causes the ADC to sample
% $u$ every $T_s$ seconds, and $T_s > 0$ denotes the time between samples of $u$.
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |ADC_example2.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open('ADC_example2') Examples/CPS_examples/ADC_V002>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open('CPS_examples/ADC_V002','ADC_example2.slx') |ADC_example2.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
wd_before = hybrid.open(fullfile('CPS_examples','ADC_V002'));

% Run the initialization script.
initialization_exADCV02

% Run the Simulink model.
sim('ADC_example2')

% Convert the values t, j, x, and t1, j1, x1 output by the simulation into a HybridArc objects.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j)
sol1 = HybridArc(t1, j1, x1); %#ok<IJCL> (suppress a warning about 'j1')

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open the system in ADC_example2.slx.
open_system('ADC_example2')

%%
% For each hybrid system in the figure above (HSu and ADC), we have the
% following Matlab embedded functions that describe the sets $C$ and $D$
% and the functions $f$ and $g$.
%
% * Bouncing ball (HSu):
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/D.m</include>

%%
%
% * ADC:
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/f_ADC.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/C_ADC.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/g_ADC.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_2/D_ADC.m</include>

%% Example Output
% Let the input function to the bouncing ball be $u(t,j) = 0.2$ and let 
% $\gamma = -9.81$, $\lambda = 0.8$, and $T_s = 0.1$. 
% The solution to the interconnection from an initial condition of $x(0,0)=[0,0]^\top$
% for the bouncing ball and $x(0,0)=[0,0]^\top$ for the ADC, and with
% |T=10, J=20, rule=1|, shows that the ADC samples the ball position and 
% velocity every $0.1$ seconds.

clf
pb = HybridPlotBuilder()...
.subplots('on')...
.legend('Ball position', 'Ball velocity')...
.slice([1 2])...
.flowColor('black')...
.jumpColor('green')...
.plotFlows(sol1);
hold on
pb.legend('ADC output', 'ADC output')...
.slice([1 2])...
.flowColor('blue')...
.jumpColor('red')...
.plotFlows(sol);

%%
% The following plot depicts the hybrid arc for the ADC output in hybrid time. 
clf
plotHybrid(sol.slice(1))      
grid on
view(37.5, 30) 

%% Modifying the Model
% * The _Embedded MATLAB function blocks_ |f, C, g, D| are edited by
%   double-clicking on the block and editing the script. In each embedded function
%   block, parameters must be added as inputs and defined as parameters by
%   selecting |Tools>Edit Data/Ports|, and setting the scope to |Parameter|. For
%   this example, |gamma|, |lambda|, and |Ts| are defined in this way.    
% * The initialization script |initialization_exADCV02.m| is edited by opening the file
%   and editing the script.  
%   The flow time and jump horizons, |T| and |J| are defined as well as the
%   initial conditions for the state vectors, $x0bb$ and $x0ADC$, and
%   a rule for jumps, |rule|.
% * The postprocessing script |postprocessing_exADCV02.m| is edited by opening the file
%   and editing the script. Flows and jumps may be plotted by calling the
%   functions |plotflows| and |plotjumps|, respectively. The hybrid arc
%   may be plotted by calling the function |plotHybridArc|.   
% * The simulation stop time and other simulation parameters are set to the
%   values defined in |initialization_exADCV02.m| by selecting |Simulation>Configuration
%   Parameters>Solver| and inputting |T|, |RelTol|, |MaxStep|, etc..  
% * The masked integrator system is double-clicked and the simulation horizons
%   and initial conditions are set as desired. 

%% 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 
