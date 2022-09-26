%% Example: Composite Hybrid System with Multiple Subsystems
% In this example, a bouncing ball with an input is created using the
% CompositeHybridSystem and HybridSubsystem classes. The input determines the  
% strength of an impulse given to the ball at each bounce. It is computed by a 
% feedback controller. The composite system we model consists
% of two subsystems, namely the ball and the controller.
% 
% The controller subsystem decides the strength of each
% impluse with the goal of achieving periodic bouncing. The control strategy is
% very simple. At each bounce, the controller resets a timer. If the timer at
% the next bounce is less than the target period, then the strength of the
% impulse is increased, and if it is less, then the impulse is decreased.
% 
% For a full description of this example, find the following page in the  
% HyEQ Toolbox Help:
%   Hybrid Equations MATLAB Library > Composite Hybrid Subsystems 

%% Create each subsystem
% Instantiate the ball subsystem.
ball_subsys = hybrid.examples.BouncingBallSubsystem();

% Instantiate the controller subsystem.
target_period = 2.0;

% The indices for each component in the state vector.
p_ndx = 1; % the strength of the impulse at the next jump.
tau_ndx = 2; % timer.

% During flows, p is constant and tau increases at a constant rate.
f = @(x) [0; 1];

% At each jump, the controller updates the first component based on whether the
% timer was more or less than the target period.
g = @(x, u) [max(0, x(p_ndx) + target_period-x(tau_ndx)); 0];

 hsb = HybridSubsystemBuilder();
 controller_subsys = hsb.stateDimension(2)... % state: p and \tau
                    .inputDimension(1)... % input: u=1 if ball should bounce and 0 otherwise.
                    .outputDimension(1)... % output: impulse p
                    .flowMap(f)...
                    .jumpMap(g)...
                    .flowSetIndicator(@(x) 1)...
                    .jumpSetIndicator(@(~, u) u)... % 'u' will be 1 when the ball bounces.
                    .output(@(x) x(p_ndx))... % Output 'p'
                    .build();

%% Check the data for the ball subsystem.

% Check a point above ground.
ball_subsys.assertInC([1; 0]);
ball_subsys.assertNotInD([1; 0]);

% Check a point at the ground (and stationary).
ball_subsys.assertInC([0; 0]); 
ball_subsys.assertInD([0; 0]);

% Check a point below ground (and moving down).
ball_subsys.assertNotInC([-1; -1]); 
ball_subsys.assertInD([-1; -1]);

%% Construct the composite system.
sys_bb = CompositeHybridSystem('Ball', ball_subsys, 'Controller', controller_subsys);

%% Set the inputs for the subsystems
% Set the jump input for the ball so that the output of the
% controller is passed as the input to the ball.
sys_bb.setJumpInput('Ball',  @( ~, y_controller) y_controller);

% The input for the controller is set such that the output of the ball's
% jumpSetIndicator function is passed to the input of the controller. 
% Thus, the input to the controller is 1 if the ball should jump and 0 otherwise.
% This allows the controller to know when the ball hits the ground.
controller_fcn = @(y_ball,  ~) ball_subsys.jumpSetIndicator(y_ball);
sys_bb.setInput('Controller', controller_fcn);

%% Compute Solution
% Create the initial condition as a cell array 
% that contains the initial states of each subsystem.
x_ball_initial = [1;  0];
x_controller_initial = [0; 0];
x0_cell = {x_ball_initial; x_controller_initial};

% Time horizons for the solver
tspan = [0, 60];
jspan = [0, 30];

% Compute solution
sol = sys_bb.solve(x0_cell, tspan, jspan);

%% Plot Solutions
figure(1)
clf
hpb = HybridPlotBuilder();
hpb.subplots('on')...
   .labels('$h$', '$v$')...
   .title('Ball Subsystem');
hpb.plotFlows(sol('Ball'));

figure(2)
clf
hpb = HybridPlotBuilder();
hpb.subplots('on')...
   .labels('$u$', '$\tau$')...
   .title('Controller Subsystem');
hpb.plotFlows(sol('Controller'));

%% Plot Input and Output Signals
figure(3)
clf
% Plot Input Signal
subplot(2, 1, 1)
% We reuse a single HybridPlotBuilder for u_C and u_D so they are both 
% included in the legend. 
hpb = HybridPlotBuilder();
hpb.title('Input Signal')...
    .jumpColor('none')...
    .filter(~sol.is_jump_start)...
    .legend('$u_{C}$')...
    .plotFlows(sol, sol('Ball').u); 
hold on
hpb.jumpMarker('*')...
    .jumpColor('r')...
    .flowColor('none')...
    .filter(sol.is_jump_start)...
    .legend({'$u_D$'}, 'location', 'northeast')...
    .plotFlows(sol, sol('Ball').u)
title('Plant Input')

% Plot Output Signal
subplot(2, 1, 2)
hpb = HybridPlotBuilder();
hpb.color('matlab')...
   .legend({'$h$', '$v$'}, 'location', 'southeast')...
   .plotFlows(sol, sol('Ball').y) % Select output
title('Plant Output')