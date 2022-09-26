%% Example Hybrid System with External Functions (Bouncing Ball)
% In this example, a bouncing ball is modeled in Simulink as a hybrid system.
%% 
% The files for this example are found in the <matlab:hybrid.internal.openHelp('MATLAB_packages') package>
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
%     -\gamma
%  \end{array}\right],
%    & C := \{ x \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \geq 0 \} 
% \\ \\
% g(x) := \left[ \begin{array}{c} 
%              0 \\ -\lambda x_{2}
%         \end{array}\right],
%    & D := \{x \in \mathbf{R}^2 \times \mathbf{R} \mid x_1 \leq 0,\ x_2 \leq 0\}
% \end{array}$$
% 
% where $\gamma > 0$ is the gravity constant
% and $\lambda \in [0,1)$ is the restitution coefficient.
% For this example, we consider a ball bouncing on a floor at zero height.

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open subsystem "HS" in Example1_3.slx. A screenshot of the subsystem will be
% automatically included in the published document.
warning('off','Simulink:Commands:LoadingOlderModel')
example_name = 'bouncing_ball';
model_path = ['hybrid.examples.', example_name ,'.', example_name];
load_system(which(model_path))
open_system(example_name)
snapnow
close_system()

%%
% Double-click black hybrid system $\mathcal{H}$ block open a dialog box where
% you can specify function handles for $f$, $g$, $C$, and $D$, and other system
% configuration options. 
% 
% <html> 
% <img src="images/bb_mask_dialog.png"  style='width: 100%; max-width: 450px; object-fit: contain'> 
% </html>

%% 
% To "look inside" the block, click the arrow in the
% lower-left corner of the block or open the block's context menu and select
% Mask > Look Under Mask. (To implement a hybrid system with external functions,
% you do not need to modify anything under the mask. All the necessary
% configuration is done in the mask dialog box.)
% The contents of the hybrid system block are shown here. 
block_path = [example_name, '/Hybrid System'];
load_system(which(model_path))
open_system(block_path, 'force')
snapnow
close_system()

%%
% The *flow map* |f|, *flow set* |C|, *jump map* |g|, and 
% *jump set* |D| are defined by interpreted MATLAB function blocks. 
% These blocks call the MATLAB functions chosen in the mask dialog, namely 
% <matlab:open('hybrid.examples.bouncing_ball.C') |C.m|>,  
% <matlab:open('hybrid.examples.bouncing_ball.f') |f.m|>, 
% <matlab:open('hybrid.examples.bouncing_ball.D') |D.m|>,
% <matlab:open('hybrid.examples.bouncing_ball.g') |g.m|> 
% in the 
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+bouncing_ball')) |hybrid.examples.bouncing_ball|>
% package.
% The MATLAB source code each function is included below.
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
% |TSPAN = [0 10]|, |JSPAN = [0 20]|, |rule = 1|, $g = -9.8$, and $\lambda =
% 0.9$
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
hpb.plotHybrid(sol.select(1))     
grid on
view(37.5,30)

%%

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 

warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.
