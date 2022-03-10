%% Example 1.2: Bouncing ball
% In this example, a bouncing ball is modeled in Simulink as a hybrid system.
% 
% Click <matlab:hybrid.internal.openExampleFile('Example_1.2-Bouncing_Ball','Example1_2.slx') here> 
% to change your working directory to the Example 1.2 folder and open the
% Simulink model. For the same system modeled using the MATLAB-based HyEQ
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

%% How to Run
% The following procedure is used to simulate this example:
% 
% # Change your working directory to <matlab:hybrid.internal.openExampleFile('Example_1.2-Bouncing_Ball') Examples/Example_1.2-Bouncing_Ball/>.
% # Open <matlab:hybrid.internal.openExampleFile('Example_1.2-Bouncing_Ball','Example1_2.slx')
% Example1_2.slx>. It may take a few seconds for Simulink to open.
% # In Simulink, double click the block "Double Click to Initialize" to run
% <matlab:hybrid.internal.openExampleFile('Example_1.2-Bouncing_Ball','initialization_ex1_2') initialization_ex1_2>.
% # Start the simulation by clicking the "Run" button. Let the simulation
% finish.
% # Double click the block "Double Click to Plot Solutions" to run
% <matlab:hybrid.internal.openExampleFile('Example_1.2-Bouncing_Ball','postprocessing_ex1_2') postprocessing_ex1_2>.

hybrid.internal.openExampleFile('Example_1.2-Bouncing_Ball'); 

% Run the initialization script.
initialization_ex1_2

% Run the Simulink model.
sim('Example_1_2.slx')

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

%% Example Code
% The MATLAB source code for $f, C, g,$ and $D$ from this example is included below.
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

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
