%% Example 1.6: Interconnection of Bouncing ball and Moving Platform
% In this example, a ball bouncing on a moving platform is modeled in Simulink
% as a pair of interconnected hybrid systems with inputs.  
% Click
% <matlab:hybrid.internal.openExampleFile('Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform','Example1_6.slx') here> 
% to change your working directory to the Example 1.6 folder and open the
% Simulink model. 
%% Mathematical Model
% Consider a bouncing ball $\mathcal{H}_1$ bouncing on a moving platform
% $\mathcal{H}_2$ that accelerates due to gravity and and has discrete changes
% in velocity due to collisions with the ball. This problem  
% lends itself to being modeled by a pair of interconnected hybrid systems
% because the states of each system affect the 
% behavior of the other system. In this interconnection, the bouncing ball will
% contact the platform, bounce back up, and pushing the
% platform toward the ground. In order to model this system,
% the output of the bouncing ball becomes the input of the moving platform, and
% vice versa. The model includes disturbances to the velocities
% of the ball and platform.
% 
% The bouncing ball is modeled as a hybrid subsystem $\mathcal{H}_1$ with 
% 
% * state $\xi = [\xi_1 ,\xi_2]^\top$ where $\xi_1$ is the height of the ball and 
% $\xi_2$ is its velocity, 
% * output $y_1 \in \mathbf{R}$, which is set to the height of the ball, 
% * inputs $u_1 \in \mathbf{R}$, which is set to the height of the platform, and
% * disturbances $v_1 = [v_{11} , v_{12}]^\top \in \mathbf{R}^{2}$ to the
% velocity of the ball during flows and jumps, respectively. 
% 
% The model of $\mathcal{H}_1$ is then given as
% 
% $$
% \left\{\begin{array}{ll}
% f_1(\xi, u_1,v_1):=\left[\begin{array}{c}
%    \xi_2 \\
%    -\gamma + v_{11}
%  \end{array}\right],
% & C_1 : = \{(\xi,u_1) \mid \xi_1 \geq u_1, u_1 \geq 0\}
% \\ \\
% g_1(\xi, u_1, v_1):=\left[\begin{array}{c}
%    \xi_1 \\
%    \lambda|\xi_2| + v_{12}
% \end{array}\right],
%      &D_1: =\{(\xi,u_1) \mid \xi_1 =u_1, u_1 \geq 0\}, 
% \\ \\
% y_1 = h_1(\xi) := \xi_1
% \end{array}\right.
% $$
% 
% where $\gamma>0$ is the acceleration due to gravity, and $\lambda \in [0,1)$
% is the cofficient of restitution for 
% collisions between the ball and the platform. 
% 
% The platform is modeled as a hybrid subsystem $\mathcal{H}_2$ with 
% 
% * state $\eta = [\eta_1 , \eta_2]^\top \in \mathbf{R}^{2}$
%  where $\eta_1$ is the height of the platform and $\eta_2$ is its velocity,
% * output $y_2 \in \mathbf{R}$ is set to the height of the platform, 
% * intput $u_2 \in \mathbf{R}$ is set to the height of the ball, and 
% * disturbances $v_2 = [v_{21} , v_{22}]^\top \in \mathbf{R}^{2}$ to velocity of
% the platform during flows and jumps, respecitvely.
% 
% The model of the platform system $\mathcal{H}_2$ is given by
% 
% $$\left\{\begin{array}{ll}
% f_2(\eta,u_2,v_2):=\left[\begin{array}{c}
%    \eta_2 \\
%    -\eta_1-2\eta_2 +v_{12}
%  \end{array} \right],
%    & C_2 : = \{(\eta,u_2) \mid \eta_1 \leq u_2, \eta_1 \geq 0\}
%  \\ \\
% g_2(\eta,u_2,v_2):=\left[\begin{array}{c}
%    \eta_1 \\
%    -\lambda|\eta_2| + v_{22}
% \end{array} \right],
%    & D_2: =\{(\eta,u_2) \mid \eta_1 = u_2, \eta_1 \geq 0 \},
%  \\ \\
% y_2 = h_2(\eta) := \eta_1.    
% \end{array}\right.$$
% 
% The interconnection between $\mathcal H_1$ and $\mathcal H_2$ is
% defined by the input assignment 
% 
% $$u_1 = y_2, \quad u_2 = y_1.$$
%
% The signals $v_1$  and $v_2$ are included as external inputs to the model 
% to simulate the effects of environmental perturbations, such as a wind
% gust, on the system.

% Change working directory to the example folder.
wd_before = hybrid.internal.openExampleFile('Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform');

% Run the initialization script.
initialization_ex1_6

% Run the Simulink model.
sim('Example1_6')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol_1 = HybridArc(t1, j1, x1);
sol_2 = HybridArc(t2, j2, x2);

xi1_arc = sol_1.slice(1);                   
xi2_arc = sol_1.slice(2);               
eta1_arc = sol_2.slice(1);            
eta2_arc = sol_2.slice(2);

%% Simulink Model
% The following diagram shows the Simulink model for the interconnected hybrid
% systems. The contents of the blocks *flow map* |f|, *flow set* |C|, etc., are
% shown below.

% Open Example1_6.slx. A screenshot of the subsystem will be
% automatically included in the published document.
open_system('Example1_6')

%% 
% *The Simulink blocks for the bouncing ball $\mathcal{H}_{1}$:*
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_6/f1.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_6/C1.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_6/g1.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_6/D1.m</include>
%%
% *The Simulink blocks for the moving platform $\mathcal{H}_{2}$:*
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_6/f2.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_6/C2.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_6/g2.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_6/D2.m</include>

%% Example Output
% 
% A solution to the composition of $\mathcal{H}_1$ and
% $\mathcal{H}_2$ is shown below with $\gamma = 0.8$, $b=0.1$, |T=18|, |J=20|,
% and |rule=1|. The inputs $v_{11}$, $v_{12}$, $v_{22}$ are zero and $v_{21}$ is a
% sinusoidal signal.
figure(1) % H1 Flows and Jumps        
clf       

hpb = HybridPlotBuilder();

sp1 = subplot(2,1,1);
hpb.flowColor('blue')...
    .jumpColor([0 0 0.5]) % dark blue.
hpb.legend('$\xi_1$ (Ball)').plotFlows(xi1_arc) 
hold on
hpb.flowColor('red')...
    .jumpColor([0.7 0 0]) % dark red. 
hpb.legend('$\eta_1$ (Platform)').title('Height').plotFlows(eta1_arc) 
grid on         
ylim([min(0, min(xi1_arc.x)), inf])                    
                                      
sp2 = subplot(2,1,2);
hpb.flowColor('blue')...
    .jumpColor([0 0 0.5]) % dark blue.
hpb.legend('$\xi_2$ (Ball)').plotFlows(xi2_arc) 
hold on
hpb.flowColor('red')...
    .jumpColor([0.7 0 0]) % dark red. 
hpb.legend({'$\eta_2$ (Platform)'}, 'Location', 'best').title('Velocity').plotFlows(eta2_arc) 
grid on   
ylim('padded')                   

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 

% This example was writen by Ricardo Sanfelice and revised by Paul Wintz.
