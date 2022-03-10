%% Example: Analog to Digital Converter in Simulink
% In this example, an analog to digital converter (ADC) is 
% modeled in Simulink as a hybrid system with an input, where the input
% is sampled periodically by the ADC.
% Click
% <matlab:hybrid.internal.openExampleFile({'CPS_examples','ADC_V001'},'ADC_example1.slx') here> 
% to change your working directory to the ADC_V001 folder and open the
% Simulink model. 
%% Mathematical Model
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
%    & D: = \{(x,u) \in \mathbf{R}^2 \times \mathbf{R} \mid x_2 > T_s \}
% \end{array}$$
% 
% where $u$ is the input to the ADC, $x_1$ is a memory state used to store
% the samples of $u$, $x_2$ is a timer that causes the ADC to sample
% $u$ every $T_s$ seconds, and $T_s > 0$ denotes the time between samples of $u$.
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |ADC_example1.slx|:
% 
% * Navigate to the directory <matlab:hybrid.internal.openExampleFile({'CPS_examples','ADC_V001'}) Examples/CPS_examples/ADC_V001>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.internal.openExampleFile({'CPS_examples','ADC_V001'},'ADC_example1.slx') |ADC_example1.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
wd_before = hybrid.internal.openExampleFile({'CPS_examples','ADC_V001'});

% Run the initialization script.
initialization_exADC

% Run the Simulink model.
sim('ADC_example1')

% Convert the values t, j, x, and vs output by the simulation into a HybridArc objects.
sol_u = HybridArc(t, 0*t, vs);
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open subsystem "ACD" in ADC_example1.slx.
open_system('ADC_example1')

%%
% The following Matlab embedded functions that describe the sets $C$ and $D$
% and the functions $f$ and $g$ for the ADC system.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_1/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_1/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_1/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ADC_1/D.m</include>

%% Example Output
% Let the input function be $u(t,j) = sin(t)$ and let $T_s = \pi/8$. 
% The solution to the ADC system from $x(0,0)=[0,0]^\top$ and with
% |T=10, J=20, rule=1| shows that the ADC samples the sinusoidal input 
% every $\pi/8$ seconds.

clf
subplot(2,1,1)
pb = HybridPlotBuilder();
hold on
pb.legend('ADC input')...
    .slice(1)...
    .flowColor('green')...
    .jumpColor('none')...
    .plotFlows(sol_u);
pb.legend('ADC output')...
    .slice(1)...
    .flowColor('blue')...
    .jumpColor('red')...
    .plotFlows(sol);

subplot(2,1,2)
HybridPlotBuilder()...
.legend('','ADC timer')...
.slice(2)...
.plotFlows(sol);

%% Modifying the Model
% * The _Embedded MATLAB function blocks_ |f, C, g, D| are edited by
%   double-clicking on the block and editing the script. In each embedded function
%   block, parameters must be added as inputs and defined as parameters by
%   selecting |Tools>Edit Data/Ports|, and setting the scope to |Parameter|. For
%   this example, |Ts| is defined in this way.    
% * In the initialization script |initialization_exADC.m|,
%   the flow time and jump horizons, |T| and |J| are defined as well as the
%   initial conditions for the state vector, $x0ADC$, and
%   a rule for jumps, |rule|.
% * The simulation stop time and other simulation parameters are set to the
%   values defined in |initialization_exADC.m| by selecting |Simulation>Configuration
%   Parameters>Solver| and inputting |T|, |RelTol|, |MaxStep|, etc..  

%% 

% Close the Simulink file.
close_system 

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
