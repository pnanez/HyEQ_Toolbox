%% Example 1.5: Vehicle on Path with Boundaries
% In this example, <update summary>
% 
% Consider a vehicle modeled by a Dubins vehicle model traveling along a given 
% track with state vector $x=[\xi_1, \xi_2, \xi_3]^\top$ and with dynamics given by 
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
% The state of the closed-loop system is given by $x := [\xi^\top\ q]^\top$. % 
% 
% Click
% <matlab:hybrid.open('Example_1.5-Vehicle_on_Path_with_Boundaries','Example1_5.slx') here> 
% to change your working directory to the Example 1.5 folder and open the
% Simulink model. 
%% Mathematical Model
% A model of such a closed-loop system is given by
% 
% $$ \begin{array}{ll}
% f(x,u) := \left[
% \begin{array}{c}
%  \left[
% \begin{array}{c}
%    u\cos(\xi_3) \\
%    u\sin(\xi_3)\\
%    -\xi_3+r(q) \\
% \end{array} \right] \\
% u
% \end{array} \right], 
% r(q) := \left\{
% \begin{array}{cc}
% \frac{3\pi}{4} & \textrm{if } q=1\\
% \frac{\pi}{4} & \textrm{if } q=2 \\
% \end{array} \right. \\
% C := \{(\xi, q, u)\in \mathbf{R}^{3}\times\{1,2\}\times \mathbf{R}\mid (\xi_1 \leq 1 , q = 2) \textrm{ or } (\xi_1 \geq -1 , q=1)\}, \\
% g(\xi,u) :=
% \left\{
% \begin{array}{ll}
% \left[\begin{array}{cc} \xi \\ 2 \end{array}\right]
% & \textrm{if } \xi_1\leq-1,\ q=1\\
% \left[\begin{array}{cc}\xi \\ 1 \end{array}\right]
% & \textrm{if } \xi_1\geq 1,\ q=2,
% \end{array} \right. \\
%     D := \{(\xi, q, u)\in \mathbf{R}^{3}\times\{1,2\} \times \mathbf{R}
%                   \mid(\xi_1 \geq 1 ,  q = 2) \textrm{ or } (\xi_1 \leq -1,  q=1)\}
% \end{array} $$
% 
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |Example_1_5.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open('Example_1.5-Vehicle_on_Path_with_Boundaries') Examples/Example_1.5-Vehicle_on_Path_with_Boundaries>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open('Example_1.5-Vehicle_on_Path_with_Boundaries','Example1_5.slx') |Example_1_5.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
wd_before = hybrid.open('Example_1.5-Vehicle_on_Path_with_Boundaries');

% Run the initialization script.
initialization_ex1_5

% Run the Simulink model.
sim('Example1_5')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol = HybridArc(t, j, x); %#ok<IJCL> (suppress a warning about 'j')

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open subsystem "HS" in Example1_5.slx. A screenshot of the subsystem will be
% automatically included in the published document.
open_system('Example1_5/HS')

%%
% The Simulink blocks for the hybrid system in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_5/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_5/g.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_5/C.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_5/D.m</include>
% 
% The MATLAB scripts in each of the function blocks of the implementation above
% are given as follows. The tangential velocity of the vehicle is chosen to be
% $u=1$, the initial position on the plane is chosen to be
% $(\xi_1,\xi_2)=(0,0)$, and the initial orientation angle is chosen to be
% $\xi_3=\frac{\pi}{4}$ radians. 

%% Example Output
%
% A solution to the system of a vehicle following a track in $\{(\xi_1,\xi_2):-1\leq \xi_1 \leq1\}$, and with
% $T=15, J=10$, $rule =1$, is depicted in the following plot.

clf
subplot(3, 1, 1)
hpb = HybridPlotBuilder().color('matlab')...
    .legend('$\xi_1$', '$\xi_2$');%, '$\xi_3$', '$q$');
hpb.title('Position');
hpb.plotFlows(sol.slice(1:2))
ylim('padded')

subplot(3, 1, 2)
hpb.legend('$\xi_3$');
hpb.title('Orientation Angle');
hpb.plotFlows(sol.slice(3))
ylim('padded')

subplot(3, 1, 3)
hpb.legend('$q$').title('Mode').color('black');
hpb.plotFlows(sol.slice(4))
ylim('padded')

%%
% The following plot depicts the trajectory of the vehicle.
clf
HybridPlotBuilder().xLabelFormat('$\\xi_{%d}$')...
    .plotPhase(sol.slice(1:2))
ylim('tight')

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 











