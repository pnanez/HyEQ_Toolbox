%% Example 1.2: Bouncing ball with Lite HyEQ Solver (Still "In progress")
% In this example, a bouncing ball is modeled in Simulink as a hybrid system.
%
% Click
% <matlab:hybrid.open('Example_1.2-Bouncing_Ball','Example1_2.slx') here> 
% to change your working directory to the Example 1.2 folder and open the
% Simulink model. For the same system modeled using the MATLAB-based HyEQ
% solver, see <matlab:showdemo('HybridSystem_demo') here>.
%% Mathematical Model
% 
% The bouncing ball is modeled as a hybrid system with the following data: 
% 
% $$\begin{array}{ll}
% f(x) := \left[\begin{array}{c}
%       x_{2} \\
%     -g
%  \end{array}\right],
%    & C := \{ x \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \geq 0 \} \\
% g(x) := \left[ \begin{array}{c} 
%              0 \\ -\lambda x_{2}
%         \end{array}\right],
%    & D := \{x \in \mathbf{R}^2 \times \mathbf{R} \mid x_1 \leq 0,\ x_2 \leq 0\}
% \end{array}$$
% 
% where $g > 0$ is the gravity constant
% and $\lambda \in [0,1)$ is the restitution coefficient.
% For this example, we consider a ball bouncing on a floor at zero height. 
% The constants for the bouncing ball system are |g = 9.81| and |\lambda=0.8|.

%% How to Run Example
% The following procedure is used to simulate this example in the Lite HyEQ Solver:
% 
% * Inside the MATLAB script |run.m|, initial conditions, simulation horizons, 
%   a rule for jumps, ode solver options, and a step size coefficient are defined. 
%   The function |HyEQsolver.m| is called in order to run the simulation, 
%   and a script for plotting solutions is included.
% * Then the MATLAB functions |f.m, C.m, g.m, D.m| 
%   are edited according to the data given above.
% * Finally, the simulation is run by clicking the run button in |run.m| 
%   or by calling |run.m| in the MATLAB command window.

wd_before = hybrid.open('Example_1.2-Bouncing_Ball'); 

%% Solution
% A solution to the bouncing ball system from 
% $x(0,0)=[1,0]^\top$ and with 
% |TSPAN = [0 10], JSPAN = [0 20], rule = 1|, 
% is depicted in Figure~\ref{fig:lite-1} (height) 
% and Figure~\ref{fig:lite-2} (velocity).  
% Both the projection onto $t$ and $j$ are shown. 
% Figure~\ref{fig:lite-3} depicts the corresponding hybrid arc for the position state.
% 
%% Figure 1 (to-do)
% * Graphic: "figures/Example_1_2/FlowsAndJumpsHeight", 
%            "figures/Example_1_2/FlowsAndJumpsVelocity"
% * Caption: Solution of Example 1.2
% 
%% Figure 2 (to-do)
% * Graphic: "figures/Example_1_2/plotHybrid.eps"
% * Caption: "Hybrid arc corresponding to a solution of bouncing ball example.
%%
% The MATLAB source code for this example, located at 
% <matlab:hybrid.open('Example_1.2-Bouncing_Ball') Examples/Example_1.2-Bouncing_Ball>, 
% is included below.

%% Example Code
%
% *f_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/f_ex1_2.m</include>
%
% *C_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/C_ex1_2.m</include>
%
% *g_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/g_ex1_2.m</include>
%
% *D_ex1_2.m:*
% 
% <include>../Examples/Example_1.2-Bouncing_Ball/D_ex1_2.m</include>

cd(wd_before)