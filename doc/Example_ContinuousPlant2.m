%% CPS Example: A Mobile Robot
% In this example a unicycle type mobile robot is simulated using the hybrid
% system toolbox. It is assumed that the forward 
% velocity can be either 1 or 0, and the control command is $u\in\mathbf{R}$.
% The control input is assumed be remain between $\pm 1$, i.e., $u \in
% [U_{\min},\ U_{\max}] := [-1,+1]$. Moreover, the unicycle is initialized at
% the origin and required to reach the boundry of a circle of radius $X_{\max}$
%  
% Click
% <matlab:hybrid.examples.mobile_robot.mobile_robot here> 
% to open the Simulink model. 
%% Mathematical Model
% A unicycle mobile robot is a continuous time nonlinear system. Let $x_1$ and
% $x_2$ be the position of the unicycle on 2D plane and $x_3$ be the
% orientation. The kinematics model is given by
%
% $$\begin{array}{ll}
% \dot x_1 = v \sin x_3\\
% \dot x_2 = v \cos x_3\\
% \dot x_3 = u,
% \end{array}$$
%
% where the forward velocity $v$ is assumed to be constant, and without
% loss of generality $v = 1$. The states and input of the system are
% $(x_1,x_2,x_3)\in\mathbf{R}^{3}$ and $u \in \mathbf{R}$, respectively.
% We express this system as a hybrid control system with the following
% data:
% 
% $$\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%    \sin x_{3} \\
%    \cos x_{3} \\
%    u
%  \end{array}\right],
%    & C := \{ (x,u) \in \mathbf{R}^{3} \times \mathbf{R} 
%               \mid u \in [U_{\min},\ U_{\max}], x_1^2 + x_2^2 \leq X^2_{\max}\} \\ \\
% g(x,u):=\left[ \begin{array}{c} 
%                    0 \\
%                    0 \\   
%                    0
%                \end{array}\right],
%    & D: = \emptyset
% \end{array}$$

% Run the initialization script.
hybrid.examples.mobile_robot.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.mobile_robot.mobile_robot');
sim(simulink_model_path)
close_system
close all

%% Simulink Model
% The following diagram shows the Simulink model of the continuous plant

% Open .slx model. A screenshot of the subsystem will be
% automatically included in the published document.
example_name = 'mobile_robot';
model_path = ['hybrid.examples.', example_name ,'.', example_name];
open_system(which(model_path))

%%
% The Simulink blocks for the hybrid system in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant_2/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant_2/g.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant_2/C.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_CPS_ContinuousPlant_2/D.m</include>

%% Example Output
% The following plot shows a solution to the closed-loop system.
hybrid.examples.mobile_robot.postprocess

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Change to the doc directory so that the example code is correctly included.
cd(hybrid.getFolderLocation('doc'))