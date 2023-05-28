%% Example: Composite Hybrid System with Switched Subsystem
% <html>
%   <!-- This meta block sets metadata that is used to generate the front matter 
%          for the Jekyll website.-->
%   <meta 
%     id="github_pages"
%     permalink="example-composite-hybrid-system-with-switch" 
%     category="matlab"
%   />
% </html>
% 
% We create a composite system that consists of a plant, two controllers, and a
% switch that toggles between the controllers based on some criteria. 
A = [0, 1; 0, 0];
B = [0; 1];
K0 = [-1, -1];
K1 = [ 2, -1];
input_dim = 1;
plant = hybrid.subsystems.LinearContinuousSubsystem(A, B);
controller_0 = hybrid.subsystems.MemorylessSubsystem(2, 1, @(~, z_plant) K0*z_plant);
controller_1 = hybrid.subsystems.MemorylessSubsystem(2, 1, @(~, z_plant) K1*z_plant);
switcher = hybrid.subsystems.SwitchSubsystem(input_dim);
sys = CompositeHybridSystem('plant', plant, ...
                             'kappa0', controller_0, ...
                             'kappa1', controller_1, ...
                             'switcher', switcher)

%% 
% The full state vector is passed as input to the controllers. We can ommit the
% '~'s from the argument list since we only use the first argument is used. 
sys.setInput(controller_0, @(z_plant, ~, ~, ~) z_plant);  % '~'s included 
sys.setInput(controller_1, @(z_plant) z_plant); % '~'s omitted

%%
% The current choice of controller is stored as state variable |q|
% in |switcher|, where |controller_0| is passed through as the output of
% |switcher| whenever |q = 0| and |controller_1| is passed through when |q = 1|.
% The plant state |z_plant| and output of the controllers, named |u0| and |u1|,
% are passed to the switcher. The |SwitchSubsystem| class provides a |wrapInput|
% method that handles the creation of the input vector from the given values. 
% The third argument to |wrapInput| is the criteria for switching to 
% to |q = 0| and the fourth argument is the criteria for switching to
% |q = 1|. If 
% # |q=0| and the third argument of |wrapInput| is zero, 
% # |q=1| and fourth argument of |wrapInput| is zero, or 
% # the third and fourth arguments of |wrapInput| are zero, 
% then |q| is held constant.
sys.setInput(switcher, @(z_plant, u0, u1) ...
             switcher.wrapInput(u0, u1, norm(z_plant) >= 3, norm(z_plant) <= 1));
                    
%% 
% The output of the switch is passed to the plant.
sys.setInput(plant, @(~, ~, ~, u_switched) u_switched);

%%
% Compute a solution. Note that the MemorylessSubsystems have no state, so empty
% arrays are given in |x0| for the corresponding subsystems.
x0 = {[10; 0], [], [], 1};
sol = sys.solve(x0, [0, 100], [0, 100])

%% 
% Plot the solution, using different colors when $q=0$ and $q=1$.
clf  
hold on
q = sol('switcher').x;
hpb = HybridPlotBuilder().jumpMarker('none');

% Plot solution where q=0 
hpb.filter(q == 0)...
    .legend('$q = 0$')...
    .plotPhase(sol('plant'));

% Plot solution where q=1
hpb.filter(q == 1)...
    .legend('$q = 1$')...
    .flowColor('green')...
    .plotPhase(sol('plant'));

% Configure plot appearance
axis equal
axis padded
set(gca(), 'XAxisLocation', 'origin'); 
set(gca(), 'YAxisLocation', 'origin');