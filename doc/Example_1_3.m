%% Modeling a Hybrid System with Embedded MATLAB Function Blocks (Bouncing Ball with Input)
% In this example, a ball bouncing on a moving platform is 
% modeled in Simulink as a hybrid system with an input, where the input
% determines the height of the platform.

%% 
% The files for this example are found in the package
% |hybrid.examples.bouncing_ball_with_input|:
% 
% * <matlab:open('hybrid.examples.bouncing_ball_with_input.initialize') initialize.m> 
% * <matlab:hybrid.examples.bouncing_ball_with_input.bouncing_ball_with_input bouncing_ball_with_input.slx> 
% * <matlab:hybrid.examples.bouncing_ball_with_input.bouncing_ball_with_input bouncing_ball_with_input_alternative.slx> 
% * <matlab:open('hybrid.examples.bouncing_ball_with_input.postprocess') postprocess.m> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+bouncing_ball_with_input')) |Examples\+hybrid\+examples\bouncing_ball_with_input|>
% (clicking this link changes your working directory). 

%% Mathematical Model
% 
% The bouncing ball system on a moving platform is modeled as a hybrid system
% with the following data: 
% 
% $$\left\{\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%    x_{2} \\
%  -\gamma
%  \end{array}\right],
%    & C := \{ (x,u) \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \geq u \}
%    \\ \\
% g(x,u):=\left[ \begin{array}{c} 
%                    u \\ -\lambda x_{2}
%                \end{array}\right],
%    & D: = \{ (x,u) \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \leq u, \
%   x_{2} \leq 0\}
% \end{array}\right.$$
% 
% where $\gamma >0$ is the gravity constant, $u$ is the height of the platform
% given as an input, and $\lambda \in [0,1)$ is the restitution coefficient.

%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |Example_1_3.slx|:
% 
% # Open
% <matlab:hybrid.examples.bouncing_ball_with_input.bouncing_ball_with_input |hybrid.examples.bouncing_ball_with_input.bouncing_ball_with_input.slx|> 
% in Simulink.   
% # In Simulink, double click the block "Double Click to Initialize" to 
% <matlab:open('hybrid.examples.bouncing_ball_with_input.initialize') |initialize variables|> 
% (parameters, initial values, etc.). 
% # Start the simulation by clicking the "Run" button. Let the simulation
% finish.
% # Double click the block "Double Click to Plot Solutions" to
% <matlab:open('hybrid.examples.bouncing_ball_with_input.postprocess') |generate plots|> 

% Change working directory to the example folder.
hybrid.examples.bouncing_ball_with_input.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.bouncing_ball_with_input.bouncing_ball_with_input');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open subsystem "HS" in Example1_3.slx. A screenshot of the subsystem will be
% automatically included in the published document.
example_name = 'bouncing_ball_with_input';
model_path = ['hybrid.examples.', example_name ,'.', example_name];
block_path = [example_name, '/HS'];
load_system(which(model_path))
open_system(block_path)

%%
% The Simulink blocks for the hybrid system in this example are included below.
% The _Embedded MATLAB function blocks_ |f, C, g, D| are edited by
% double-clicking on the blocks in Simulink.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_3/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_3/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_3/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_3/D.m</include>

%% Alternative Simulink Model
% The Simulink model, below, shows the jump set |D| modeled in Simulink using
% operational blocks instead of a MATLAB function block.

% Open subsystem "HS" in Example1_4.slx. A screenshot of the subsystem will be
% automatically included in the published document.
warning('off','Simulink:Commands:LoadingOlderModel')
model_path = 'hybrid.examples.bouncing_ball_with_input.bouncing_ball_with_input_alternative';
load_system(which(model_path))
open_system('bouncing_ball_with_input_alternative/HS')
snapnow();

%% Example Output
% Let the input function be $u(t,j) = 0.5$ for $t \in [0, 2.5)$ and $u(t, j) = 0$
% for $t \geq 2.5$, and let $\gamma = 9.81$ and $\lambda=0.8$. 
% The solution to the bouncing ball system from $x(0,0)=[1,0]^\top$ and with
% |T=10, J=20, rule=1| shows that the ball bounces at a height of |0.5| until $t
% = 2.5$, when the platform drops to $0$.

clf
plotFlows(sol)

%%
% The following plot depicts the hybrid arc for the height of the ball in hybrid time. 
clf
plotHybrid(sol.slice(1))     
grid on
view(37.5, 30) 

%% Defining Parameters
% To add parameters to an embedded function block, 
% open the function, navigate to the |Function| tab,
% select |Ports and Data Manager| in the toolbar, and click |Add>Data|. 
% A new item will appear in the list. 
% Set the name as desired and change the scope to |Parameter|.
% Once a parameter is defined this way, it is passed to the function as an
% input with the given name.
% In this example, |gamma| and |lambda| are defined in this way and the values
% are set within
% <matlab:open('hybrid.examples.bouncing_ball_with_input.initialize') initialize.m>. 

%% Defining the Simulation Time-Horizon and Initial Condition
% The time flow time horizon |T|, the jump horizon |J|, the
% initial condition |x0| are defined in
% <matlab:open('hybrid.examples.bouncing_ball_with_input.initialize') initialize.m>.
% The names of the variables must match the names specificied in the 
% |Integrator System| settings, which are opened by double-clicking |HS| and
% then on the |Integrator System|.
% 
% <<images/IntegratorSettings.png>>

%% Solver Configuration
% The initialization script 
% <matlab:open('hybrid.examples.bouncing_ball_with_input.initialize') initialize.m>, 
% also sets the values for the priority |rule| for $C \cap D$
% and solver tolerances |RelTol| and |MaxStep|. 
% The solver tolerances are defined in Simulink by opening 
% |Modeling>Model Settings>Solver| and inputting |T|, |RelTol|, |MaxStep|, etc.

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
