%% CPS Component: Analog-to-Digital Converter (ADC)
% In this example, an analog-to-digital converter (ADC) is 
% modeled in Simulink as a hybrid system with an input, where the input
% is sampled periodically by the ADC.
%% 
% The files for this example are found in the package
% |hybrid.examples.analog_to_digital_converter|:
% 
% * <matlab:open('hybrid.examples.analog_to_digital_converter.initialize') initialize.m> 
% * <matlab:hybrid.examples.analog_to_digital_converter.adc adc.slx> 
% * <matlab:open('hybrid.examples.analog_to_digital_converter.postprocess') postprocess.m> 
% 
% and in the package |hybrid.examples.bouncing_ball_with_adc|:
% 
% * <matlab:open('hybrid.examples.bouncing_ball_with_adc.initialize') initialize.m> 
% * <matlab:hybrid.examples.bouncing_ball_with_adc.ball_with_adc ball_with_adc.slx> 
% * <matlab:open('hybrid.examples.bouncing_ball_with_adc.postprocess') postprocess.m> 
% 
% The contents of these packages are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+bouncing_ball_with_adc')) 
%                   |Examples\+hybrid\+examples\bouncing_ball_with_adc|> and
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+analog_to_digital_converter')) 
%                   |Examples\+hybrid\+examples\analog_to_digital_converter|>
% (clicking these links changes your working directory).

%% Mathematical Model
% 
% The ADC is modeled as a hybrid system
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
% The following procedure is used to simulate this example:
% 
% * Open
% <matlab:hybrid.examples.analog_to_digital_converter.adc |hybrid.examples.analog_to_digital_converter.adc.slx|>.   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Run the initialization script.
hybrid.examples.analog_to_digital_converter.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.analog_to_digital_converter.adc');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, x, and vs output by the simulation into a HybridArc objects.
sol_u = HybridArc(t, 0*t, vs);
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open the simulink window to produce screenshot.
open_system(simulink_model_path)

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
% Let the input function be $u(t,j) = \sin(t)$ and let $T_s = \pi/8$. 
% The solution to the ADC system from $x(0,0)=[0,0]^\top$ and with
% |T=10|, |J=20, |rule=1| shows that the ADC samples the sinusoidal input 
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
    .color('blue')...
    .plotFlows(sol);

subplot(2,1,2)
HybridPlotBuilder()...
.legend('','ADC timer')...
.slice(2)...
.plotFlows(sol);


%% ADC Connected to Bouncing Ball
% In this section, the interconnection of a bouncing ball system and an
% ADC is modeled in Simulink. This shows how an
% ADC block can be used to discretize a hybrid system.
% 
% The model of the ADC is the same as above and the model of the bouncing ball
% subsystem is described in
% <matlab:hybrid.internal.openHelp('Example_1_3') 
%   Modeling a Hybrid System with Embedded Function Blocks (Bouncing Ball with
%   Input)>.

% Run the initialization script.
hybrid.examples.bouncing_ball_with_adc.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.bouncing_ball_with_adc.ball_with_adc');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, x, and t1, j1, x1 output by the simulation into a HybridArc objects.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j)
sol1 = HybridArc(t1, j1, x1);

%% Simulink Model for ADC Connected to Bouncing Ball
% The following diagram shows the Simulink model with an ADC subsystem 
% connected to the output of a bouncing ball subsystem. (The ball subsystem is
% given <matlab:hybrid.internal.openHelp('Example_1_3') here>.)

% Open the simulink window to produce screenshot.
open_system(simulink_model_path)

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
    .color('blue')...
    .plotFlows(sol);

%% 

% Close the Simulink file.
close_system 

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 


%% 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
