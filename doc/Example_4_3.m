%% CPS Component: Zero Order Hold (ZOH)
% A zero-order hold (ZOH) converts a digital signal at its input into an analog signal at
% its output. Its output is updated at discrete time instants, typically
% periodically, and held constant in between updates, until new information
% is available at the next sampling time.
% In this example, a ZOH model is modeled in Simulink as a hybrid system 
% with an input, where the input is the signal to sample.

%% 
% The files for this example are found in the package
% |hybrid.examples.zero_order_hold|:
% 
% * <matlab:open('hybrid.examples.zero_order_hold.initialize') initialize.m> 
% * <matlab:hybrid.examples.zero_order_hold.zero_order_hold zero_order_hold.slx> 
% * <matlab:open('hybrid.examples.zero_order_hold.postprocess') postprocess.m> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+zero_order_hold')) |Examples\+hybrid\+examples\zero_order_hold|>
% (clicking this link changes your working directory). 

%% Mathematical Model
% 
% The ZOH system is modeled as a hybrid system
% with the following data: 
% 
% $$\begin{array}{ll}
% f(q,u):=\left[\begin{array}{c}
%   0 \\
%   0 \\
%   1
%  \end{array}\right],
%    & C := \{ (x,u) \mid \tau\in [0, T^{*}_{s}] \} \\ \\
% g(x,u):= \left[ \begin{array}{c} 
%                    u \\ 
%                    0
%                \end{array}\right],
%    & D: = \{ (x,u) \mid \tau_{s} \geq T^{*}_{s}\}
% \end{array}$$
%
% $$
%   y = h(x) := x
% $$
%
% 
% where the input and the state are given by $u \in \mathbf{R}^{2}$, and $x = (m_{s}, \tau_{s})\in \mathbf{R}\times \mathbf{R}^{2}$, respectively.
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |zero_order_hold.slx|:
% 
% * Open
% <matlab:hybrid.hybrid.examples.zero_order_hold.zero_order_hold |zero_order_hold.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Run the initialization script.
hybrid.examples.zero_order_hold.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.zero_order_hold.zero_order_hold');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol_zoh = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

% Convert the values t, j, and the input to ZOH x1 into a HybridArc object.
sol_input = HybridArc(t1, j1, x1);

%% Simulink Model
% The following diagram shows the Simulink model of the ZOH. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open .slx model. A screenshot of the subsystem will be
% automatically included in the published document.
example_name = 'zero_order_hold';
model_path = ['hybrid.examples.', example_name ,'.', example_name];
open_system(which(model_path))

%%
% The Simulink blocks for the hybrid system in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_ZOH/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_ZOH/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_ZOH/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_ZOH/D.m</include>

%% Example Output
% In this example, the signal to process is the state of the bouncing ball system 
% in <matlab:hybrid.internal.openHelp('Example_1_3') Example 1.3> with the input chosen 
% to be constant, equal to $0.2$.
% The initial state of the bouncing ball system is $[1, 0]^\top$. The solution to
% the ZOH system from $x(0,0)=[1, 0, 0]^\top$ and with |T=10|, |J=100|, |rule=1| shows
% the output signal after the ZOH process.

clf
hpb = HybridPlotBuilder().subplots('on');
hold on
hpb.legend('ZOH input', 'ZOH input')...
    .color('green')...
    .plotFlows(sol_input);
hpb.legend('ZOH output', 'ZOH output')...
    .color('blue')...
    .plotFlows(sol_zoh.slice(1:2));

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 