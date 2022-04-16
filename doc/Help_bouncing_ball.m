%% Modeling a Hybrid System with Interpreted MATLAB Function Blocks (Bouncing Ball)
% In this example, a bouncing ball is modeled in Simulink as a hybrid system.
%% 
% The files for this example are found in the package
% |hybrid.examples.bouncing_ball|:
% 
% * <matlab:open('hybrid.examples.bouncing_ball.initialize') |initialize.m|> 
% * <matlab:hybrid.examples.bouncing_ball.bouncing_ball |bouncing_ball.slx|> 
% * <matlab:open('hybrid.examples.bouncing_ball.C') |C.m|>,  
%   <matlab:open('hybrid.examples.bouncing_ball.f') |f.m|>, 
%   <matlab:open('hybrid.examples.bouncing_ball.D') |D.m|>,
%   <matlab:open('hybrid.examples.bouncing_ball.g') |g.m|> 
% * <matlab:open('hybrid.examples.bouncing_ball.postprocess') |postprocess.m|> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+bouncing_ball')) |Examples\+hybrid\+examples\bouncing_ball|>
% (clicking this link changes your working directory). 
% 
% For the same system modeled using the MATLAB-based HyEQ
% solver, see <matlab:hybrid.internal.openHelp('HybridSystem_demo') here>.

%% Mathematical Model
% 
% The bouncing ball is modeled as a hybrid system with the following data: 
% 
% $$\begin{array}{ll}
% f(x) := \left[\begin{array}{c}
%       x_{2} \\
%     -g
%  \end{array}\right],
%    & C := \{ x \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \geq 0 \} 
% \\ \\
% g(x) := \left[ \begin{array}{c} 
%              0 \\ -\lambda x_{2}
%         \end{array}\right],
%    & D := \{x \in \mathbf{R}^2 \times \mathbf{R} \mid x_1 \leq 0,\ x_2 \leq 0\}
% \end{array}$$
% 
% where $g > 0$ is the gravity constant
% and $\lambda \in [0,1)$ is the restitution coefficient.
% For this example, we consider a ball bouncing on a floor at zero height. 
% The constants for the bouncing ball system are $g = 9.81$ and $\lambda=0.8$.

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open subsystem "HS" in Example1_3.slx. A screenshot of the subsystem will be
% automatically included in the published document.
example_name = 'bouncing_ball';
model_path = ['hybrid.examples.', example_name ,'.', example_name];
load_system(which(model_path))
open_system(example_name)

%%
% Double-click |HS_ex| to see inside of the hybrid subsystem.
% The contents of the |HS_ex| block is shown here. 
block_path = [example_name, '/HS_ex'];
open_system(block_path)

%%
% The *flow map* |f|, *flow set* |C|, *jump map* |g|, and 
% *jump set* |D| are defined by interpreted MATLAB function blocks. 
% These blocks call the MATLAB functions in 
% <matlab:open('hybrid.examples.bouncing_ball.C') |C.m|>,  
% <matlab:open('hybrid.examples.bouncing_ball.f') |f.m|>, 
% <matlab:open('hybrid.examples.bouncing_ball.D') |D.m|>,
% <matlab:open('hybrid.examples.bouncing_ball.g') |g.m|> 
% in the 
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+bouncing_ball')) |hybrid.examples.bouncing_ball|>
% package.
% Defining a hybrid systems in this way makes it easier to track changes in a
% source control management tool, such as Git, because the code is stored as
% plain text. 
% The downsides to this approach, however, is that it does not support systems with 
% inputs and is slightly slower than using embedded function blocks (see
% <matlab:hybrid.internal.openHelp('Example_1_3') Bouncing ball with input>).

%% 
% The MATLAB source code for $f, C, g,$ and $D$ is included below.
%
% *f.m:*
% 
% <include>src/Matlab2tex_1_2/f.m</include>
%
% *C.m:*
% 
% <include>src/Matlab2tex_1_2/C.m</include>
%
% *g.m:*
% 
% <include>src/Matlab2tex_1_2/g.m</include>
%
% *D.m:*
% 
% <include>src/Matlab2tex_1_2/D.m</include>

%% How to Run
% The following procedure is used to simulate this example:
% 
% # Open <matlab:hybrid.examples.bouncing_ball.bouncing_ball
% hybrid.examples.bouncing_ball.bouncing_ball>. It may take a few seconds for Simulink to open.
% # In Simulink, double click the block "Double Click to Initialize" to
% <matlab:open('hybrid.examples.bouncing_ball.initialize') initialize values> (initial conditions, parameters, etc.).
% # Start the simulation by clicking the "Run" button. Let the simulation
% finish.
% # Double click the block "Double Click to Plot Solutions" to
% <matlab:open('hybrid.examples.bouncing_ball.postprocess') generate plots>.

hybrid.examples.bouncing_ball.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.bouncing_ball.bouncing_ball');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Solution
% A solution to the bouncing ball system from 
% $x(0,0)=[1,0]^\top$ and with 
% |TSPAN = [0 10], JSPAN = [0 20], rule = 1|, 
% is shown plotted against continuous time $t$:
figure(1)
clf
hpb = HybridPlotBuilder().subplots('on').titles('Height', 'Velocity');
hpb.plotFlows(sol)
%%
% and against discrete time $j$:
figure(1)
clf
hpb.plotJumps(sol)

%%
% The next plot depicts the corresponding hybrid arc for the position state.
clf
hpb.plotHybrid(sol.slice(1))     
grid on
view(37.5,30)

%%

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 

warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.
