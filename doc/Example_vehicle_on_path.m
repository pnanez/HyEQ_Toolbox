%% Example 1: Vehicle on Path with Boundaries
% In this example, a vehicle is controlled such that it moves along
% a path. 

%% 
% The files for this example are found in the <matlab:hybrid.internal.openHelp('MATLAB_packages') package>
% |hybrid.examples.vehicle_on_constrained_path|:
% 
% * <matlab:open('hybrid.examples.vehicle_on_constrained_path.initialize') |initialize.m|> 
% * <matlab:hybrid.examples.vehicle_on_constrained_path.vehicle_on_path |vehicle_on_path.slx|> 
% * <matlab:open('hybrid.examples.vehicle_on_constrained_path.postprocess') |postprocess.m|> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+vehicle_on_constrained_path')) |Examples\+hybrid\+examples\vehicle_on_constrained_path|>
% (clicking this link changes your working directory). 

%%
% Consider a vehicle modeled by a Dubins vehicle model
% with state vector $x=[\xi_1, \xi_2, \xi_3]^\top$ and with dynamics given by 
% $\dot{\xi_1}=u\cos{\xi_3}$, $\dot{\xi_2}=u\sin{\xi_3}$, and 
% $\dot{\xi_3}=-\xi_3+r(q)$. 
% The input $u$ is the tangential velocity of the vehicle, 
% $\xi_1$ and $\xi_2$ describe the vehicle's position on the plane, 
% and $\xi_3$ is the vehicle's orientation angle. 
% Also consider a switching controller attempting to keep the vehicle inside the 
% boundaries of a track given by $\{(\xi_1,\xi_2):-1\leq\xi_1\leq1\}$. 
% A state $q \in \{1,2\}$ is used to define the modes of operation of the controller. 
% When $q=1$, the vehicle is traveling to the left, and when $q=2$, 
% the vehicle is traveling to the right. 
% A logic variable $r$ is defined in order to steer the vehicle back inside the boundary. 
% The state of the closed-loop system is given by $x := [\xi^\top\ q]^\top$.
% 
%% Mathematical Model
% A model of such a closed-loop system is given by
% 
% $$ \begin{array}{l}
% f(x,u) := \left[\begin{array}{c}
%    u\cos(\xi_3) \\
%    u\sin(\xi_3)\\
%    -\xi_3+r(q) \\
%    0
% \end{array}\right] +
% \left[\begin{array}{c}
%   0 \\ 0 \\ 0 \\ 1
% \end{array}\right] u, \quad
% r(q) := \left\{\begin{array}{cc}
%   \frac{3\pi}{4} & \textrm{if } q=1 \\
%   \frac{\pi}{4} & \textrm{if } q=2 \\
% \end{array}\right. \\ \\
% C := \{(\xi, q, u)\in \mathbf{R}^{3}\times\{1,2\}\times \mathbf{R}\mid (\xi_1 \leq 1,\ q = 2) \textrm{ or } (\xi_1 \geq -1,\ q=1)\}, 
% \\ \\ 
% g(x,u) :=
% \left\{\begin{array}{ll}
%   \left[\begin{array}{c} 
%     \xi \\ 2 
%   \end{array}\right]
%   & \textrm{if } \xi_1\leq-1,\ q=1 \\ \\
%   \left[\begin{array}{c}
%     \xi \\ 1 
%   \end{array}\right]
%   & \textrm{if } \xi_1\geq 1,\ q=2,
% \end{array} \right.
% \\ \\ 
% D := \{(\xi, q, u)\in \mathbf{R}^{3}\times\{1,2\} \times \mathbf{R}
%                  \mid(\xi_1 \geq 1,\  q = 2) \textrm{ or } (\xi_1 \leq -1,\  q=1)\}
% \end{array}$$

% Run the initialization script.
hybrid.examples.vehicle_on_constrained_path.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.vehicle_on_constrained_path.vehicle_on_path');
sim(simulink_model_path)
close_system
close all

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The Simulink blocks for the hybrid system in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_5/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_5/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_5/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_5/D.m</include>
%

%% Example Output
% A solution to the system above is plotted below with
% initial position $(\xi_1,\xi_2)=(0,0)$, initial orientation angle 
% $\xi_3=\frac{\pi}{4}$ radians, |T=15|, |J=10|, and |rule=1|.

clf
subplot(3, 1, 1)
hpb = HybridPlotBuilder().color('matlab')...
    .legend('$\xi_1$', '$\xi_2$');
hpb.title('Position');
hpb.plotFlows(sol.select(1:2))
ylim('padded')

subplot(3, 1, 2)
hpb.legend('$\xi_3$');
hpb.title('Orientation Angle');
hpb.plotFlows(sol.select(3))
ylim('padded')

subplot(3, 1, 3)
hpb.legend('$q$').title('Mode').color('black');
hpb.plotFlows(sol.select(4))
ylim('padded')

%%
% The following plot depicts the trajectory of the vehicle.
clf
HybridPlotBuilder().xLabelFormat('$\\xi_{%d}$')...
    .plotPhase(sol.select(1:2))
ylim('tight')

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
