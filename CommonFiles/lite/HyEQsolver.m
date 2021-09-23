function [t, j, x] = HyEQsolver(f,g,C,D,x0,TSPAN,JSPAN,rule,options,solver,E,progress)
%HYEQSOLVER solves hybrid equations.
%   Syntax: [t j x] = HYEQSOLVER(f,g,C,D,x0,TSPAN,JSPAN,rule,options,solver,E)
%   computes solutions to the hybrid equations
%
%   \dot{x} = f(x,t,j)  x \in C x^+ = g(x,t,j)  x \in D
%
%   where x is the state, f is the flow map, g is the jump map, C is the
%   flow set, and D is the jump set. It outputs the state trajectory (t,j)
%   -> x(t,j), where t is the flow time parameter and j is the jump
%   parameter.
%
%   x0 defines the initial condition for the state.
%
%   TSPAN = [TSTART TFINAL] is the time interval. JSPAN = [JSTART JSTOP] is
%       the interval for discrete jumps. The algorithm stop when the first
%       stop condition is reached.
%
%   rule (optional parameter) - rule for jumps
%       rule = 1 (default) -> priority for jumps rule = 2 -> priority for
%       flows
%
%   options (optional parameter) - options for the solver see odeset f.ex.
%       options = odeset('RelTol',1e-6);
%       options = odeset('InitialStep',eps);
%
%   solver (optional parameter. String) - selection of the desired ode
%       solver. All ode solvers are suported, exept for ode15i.  See help
%       odeset for detailed information.
%
%   E (optional parameter) - Mass matrix [constant matrix | function_handle]
%       For problems: 
%       E*\dot{x} = f(x) x \in C 
%       x^+ = g(x)  x \in D
%       set this property to the value of the constant mass matrix. For
%       problems with time- or state-dependent mass matrices, set this
%       property to a function that evaluates the mass matrix. See help
%       odeset for detailed information.
%
%         Example: Bouncing ball with Lite HyEQ Solver
%
%         % Consider the hybrid system model for the bouncing ball with data given in
%         % Example 1.2. For this example, we consider the ball to be bouncing on a
%         % floor at zero height. The constants for the bouncing ball system are
%         % \gamma=9.81 and \lambda=0.8. The following procedure is used to
%         % simulate this example in the Lite HyEQ Solver:
%
%         % * Inside the MATLAB script run_ex1_2.m, initial conditions, simulation
%         % horizons, a rule for jumps, ode solver options, and a step size
%         % coefficient are defined. The function HYEQSOLVER.m is called in order to
%         % run the simulation, and a script for plotting solutions is included.
%         % * Then the MATLAB functions f_ex1_2.m, C_ex1_2.m, g_ex1_2.m, D_ex1_2.m
%         % are edited according to the data given below.
%         % * Finally, the simulation is run by clicking the run button in
%         % run_ex1_2.m or by calling run_ex1_2.m in the MATLAB command window.
%
%         % For further information, type in the command window:
%         web(['Example_1_2.html']);
%
%         % Define initial conditions
%         x1_0 = 1;
%         x2_0 = 0;
%         x0   = [x1_0; x2_0];
%
%         % Set simulation horizon
%         TSPAN = [0 10];
%         JSPAN = [0 20];
%
%         % Set rule for jumps and ODE solver options
%         %
%         % rule = 1 -> priority for jumps
%         %
%         % rule = 2 -> priority for flows
%         %
%         % set the maximum step length. At each run of the
%         % integrator the option 'MaxStep' is set to
%         % (time length of last integration)*maxStepCoefficient.
%         %  Default value = 0.1
%
%         rule               = 1;
%
%         options            = odeset('RelTol',1e-6,'MaxStep',.1);
%
%         % Simulate using the HYEQSOLVER script
%         % Given the matlab functions that models the flow map, jump map,
%         % flow set and jump set (f_ex1_2, g_ex1_2, C_ex1_2, and D_ex1_2
%         % respectively)
%
%         [t j x] = HYEQSOLVER( @f_ex1_2,@g_ex1_2,@C_ex1_2,@D_ex1_2,...
%             x0,TSPAN,JSPAN,rule,options,'ode45');
%
%         % plot solution
%
%         figure(1) % position
%         clf
%         subplot(2,1,1),plotflows(t,j,x(:,1))
%         grid on
%         ylabel('x1')
%
%         subplot(2,1,2),plotjumps(t,j,x(:,1))
%         grid on
%         ylabel('x1')
%
%         figure(2) % velocity
%         clf
%         subplot(2,1,1),plotflows(t,j,x(:,2))
%         grid on
%         ylabel('x2')
%
%         subplot(2,1,2),plotjumps(t,j,x(:,2))
%         grid on
%         ylabel('x2')
%
%         % plot hybrid arc
%         
%         figure(3)
%         plotHybridArc(t,j,x)
%         xlabel('j')
%         ylabel('t')
%         zlabel('x1')
%
%         % plot solution using plotHarc and plotHarcColor
%
%         figure(4) % position
%         clf
%         subplot(2,1,1), plotHarc(t,j,x(:,1));
%         grid on
%         ylabel('x_1 position')
%         subplot(2,1,2), plotHarc(t,j,x(:,2));
%         grid on
%         ylabel('x_2 velocity')
%
%
%         % plot a phase plane
%         figure(5) % position
%         clf
%         plotHarcColor(x(:,1),j,x(:,2),t);
%         xlabel('x_1')
%         ylabel('x_2')
%         grid on
%
%--------------------------------------------------------------------------
% Matlab M-file Project: HyEQ Toolbox @  Hybrid Systems Laboratory (HSL),
% https://hybrid.soe.ucsc.edu/software
% http://hybridsimulator.wordpress.com/
% Filename: HYEQSOLVER.m
%--------------------------------------------------------------------------
%   See also HYEQSOLVER, PLOTARC, PLOTARC3, PLOTFLOWS, PLOTHARC,
%   PLOTHARCCOLOR, PLOTHARCCOLOR3D, PLOTHYBRIDARC, PLOTJUMPS.
%   Copyright @ Hybrid Systems Laboratory (HSL),
%   Revision: 3.0.0 Date: 08/14/2021


if ~exist('rule','var')
    rule = 1;
end

if ~exist('options','var')
    options = odeset();
end
if exist('E','var') && ~exist('solver','var')
    solver = 'ode15s';
end
if ~exist('solver','var') || isempty(solver)
    solver = 'ode45';
end
if ~exist('E','var')
    E = [];
end
if ~exist('progress', 'var')
    progress = PopupHybridProgress();
elseif strcmp(progress, 'silent')
    progress = SilentHybridProgress();
end
% mass matrix (if existent)
isDAE = false;
if ~isempty(E)
    isDAE = true;
    switch isa(E,'function_handle')
        case true % Function E(x)
            M = E;
            options = odeset(options,'Mass',M,'Stats','off',...
                'MassSingular','maybe','MStateDependence','strong',...
                'InitialSlope',f_hdae(x0,TSPAN(1))); 
        case false % Constant double matrix
            M = double(E);
            options = odeset(options,'Mass',M,'Stats','off',...
                'MassSingular','maybe','MStateDependence','none');
    end
end

options = odeset(options, 'OutputFcn', @ODE_callback);

odeX = str2func(solver);
f = wrap_with_3args(f);
g = wrap_with_3args(g);
C = wrap_with_3args(C);
D = wrap_with_3args(D);

% simulation horizon
tstart = TSPAN(1);
tfinal = TSPAN(end);
jout = JSPAN(1);
j = jout(end);

% simulate
tout = tstart;
[rx,cx] = size(x0);
if rx == 1
    xout = x0;
elseif cx == 1
    xout = x0.';
else
    error('Error, x0 does not have the proper size')
end

progress.init(TSPAN, JSPAN);
function stop = ODE_callback(t, ~, flag)
    if isempty(flag) % Only update if not 'init' or 'done'   
        progress.setT(t);
    end
    stop = progress.is_cancel_solver;     
end

% Configure the progress bar to automatically close when the 'cleanup'
% object is destroyed (e.g., when the function exits, throws an error, etc.)
cleanup = onCleanup(@progress.done);

while (j < JSPAN(end) && tout(end) < TSPAN(end) && ~progress.is_cancel_solver)
    options = odeset(options,'Events',@(t,x) zeroevents(x,t,j,C,D,rule));
    
    % Check if it is possible to flow from current position
    insideC = C(xout(end,:).',tout(end),j);
    insideD = D(xout(end,:).',tout(end),j);
    if ~insideC && ~insideD
        break
    end
    doFlow = insideC && (rule == 2 || (rule == 1 && ~insideD));
    doJump = insideD && (rule == 1 || (rule == 2 && ~insideC));
    assert(~(doFlow && doJump), 'Cannot do both flow and jump')
    assert(doFlow || doJump, 'Must either jump or flow')
    if doFlow
        if isDAE
            options = odeset(options,'InitialSlope',f(xout(end,:).',tout(end)));
        end
        [t_flow,x_flow] = odeX(@(t,x) f(x,t,j),[tout(end) tfinal],xout(end,:).', options);
        
        % Matlab ODE solvers miss events if they occur at the second time
        % step (such as the case as if the state in the boundary of a
        % closed set). To correct for this, we manually check if the second
        % state entry is at a point where flowing is allowed. If it is,
        % then we simply append the solution from the ODE solver to the
        % output. But if it's not, then we try time steps from the initial
        % point to find the longest time step that takes us out of C (or
        % into D, if using jump priority). The next state value is then
        % calculated using linear interpolation and appended to the output.
        second_state_in_C = C(x_flow(2, :)',t_flow(2),j);
        second_state_in_D = D(x_flow(2, :)',t_flow(2),j);
        will_second_state_flow = second_state_in_C && ~(second_state_in_D && rule == 1);
        if will_second_state_flow || length(t_flow) == 2
            nt = length(t_flow);
            
            % We add the new interval of flow to the solution--omitting the
            % first entry because it duplicates the previous entry in the
            % solution.
            tout = [tout; t_flow(2:end)]; %#ok<AGROW>
            xout = [xout; x_flow(2:end,:)]; %#ok<AGROW>
            jout = [jout; j*ones(1,nt-1)']; %#ok<AGROW>
        else 
            % If the second state in the flow will not flow, then this
            % indicates that the flow started in the flow set then
            % immediately left it. In this case, we calculate the next step
            % using the Euler forward method with a very small time step
            % to take us out of the flow set.
            delta_t_from_ode = t_flow(2) - tout(end); 
            for delta_t = 10.^(-9:9) % Iterate through 1e-9, 1e-8, etc.
                if delta_t_from_ode <= delta_t
                    % If delta_t is larger than the step used by the ODE
                    % solver, then larger steps sizes won't improve our
                    % solution and might cause use to miss the desired
                    % step, so we simply use the ODE solution.
                    t_next = t_flow(2);
                    x_next = x_flow(2,:)';
                    break;
                end
                x_now = xout(end, :)';
                t_next = tout(end) + delta_t;
                x_next = x_now + delta_t * f(x_now,tout(end),j);
                next_in_C = C(x_next,t_next,j);
                next_in_D = D(x_next,t_next,j);
                next_will_not_flow = ~next_in_C || (rule == 1 && next_in_D);
                if next_will_not_flow
                    break;
                end
            end
            
            tout = [tout; t_next]; %#ok<AGROW>
            xout = [xout; x_next']; %#ok<AGROW>
            jout = [jout; j]; %#ok<AGROW>
        end
    elseif doJump
        [j, tout, jout, xout] = jump(g,j,tout,jout,xout);
        progress.setJ(j);
    end
end

t = tout;
x = xout;
j = jout;

progress.done();

end

function [value,isterminal,direction] = zeroevents(x,t,j,C,D,rule)
% ZEROEVENTS Creates an event to terminate the ode solver when the state leaves C or enters D (if rule == 1).

insideC = C(x,t,j);
insideD = D(x,t,j);
switch rule
    case 1 % -> priority for jumps
        % For jump priority, we terminate flows whenever (1) the solution 
        % leaves C, or (2) the solution enters D. 
        stop = ~insideC || insideD;
    case 2 % -> priority for flows
        % For flow priority, we terminate flows whenever the solution 
        % leaves C.
        stop = ~insideC;
end
isterminal = 1;
value = 1 - stop;
direction = -1;

end

function [j, tout, jout, xout] = jump(g,j,tout,jout,xout)
% Jump
j = j+1;
y = g(xout(end,:).',tout(end),jout(end)); 
% Save results
tout = [tout; tout(end)];
xout = [xout; y.'];
jout = [jout; j];
end

function fh_out = wrap_with_3args(fh_in)
%wrap_with_3args Convert variable input function to take three arguments (x, t, j).
%   Given a function handle fh_in of 1, 2, or 3 input arguments,
%   wrap_with_3args(fh_in) converts fh_in to a function that takes exactly
%   three arguments, namely x, t, and j. 
%    x: state
%    t: time
%    j: discrete time

switch nargin(fh_in)
    case 1
        fh_out = @(x, t, j) fh_in(x);
    case 2
        fh_out = @(x, t, j) fh_in(x,t);
    case 3
        fh_out = fh_in;    
    otherwise
        error('The function handle ''%s'' must have 1, 2, or 3 input arguments. Instead it had %d.',...
            func2str(fh_in), nargin(fh_in))
end
end