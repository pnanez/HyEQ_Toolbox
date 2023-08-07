%% Demo: Hybrid Arcs and Solutions
% In this tutorial, we show how to create, modify, and get information from
% |HybridArc| and |HybridSolution| objects. 

%% Creating a |HybridArc| object from arrays
% A |HybridArc| object can be created directly by passing values of the state |x|,
% continuous-time |t|, and discrete-time |j| as tall arrays (each time-step is
% a row) to the |HybridArc| constructor function.
% 
% The inputs |t| and |j| must be column vectors of the same length. The input
% |x| must be an array containing the same number of rows as t and j, and a
% number of columns equal to the state dimension. 
t = linspace(0, 10, 100)'; % Column vector
j = zeros(100, 1);         % Column vector
x = t.^2;                  % Tall array
HybridArc(t, j, x)

%% 
% Here is an example of constructing a |HybridArc| that includes a jump.
n_time_steps = 100;
t = [linspace(0, pi, n_time_steps/2)'; linspace(pi, 2*pi, n_time_steps/2)'];
j = [zeros(n_time_steps/2, 1); ones(n_time_steps/2, 1)];
% 3D state. Draws a circle in x- and y-axes. Z-axis shows number of jumps.
x = [cos(t), sin(t), j];
plotPhase(HybridArc(t, j, x))

%% Creating a |HybridSolution| object via |HybridSystem.solve()|
% Typically, instead of explcitly constructing a |HybridArc|, 
% you will generate a |HybridArc| by computing a numerical approximation of a
% solution to a |HybridSystem| using |HybridSystem.solve()|.
% The output of |HybridSystem.solve()| is a |HybridSolution| object, which is a 
% type of |HybridArc| object includes additional information related to solutions. 
% The |HybridSolution| class is a subclass of the |HybridArc| class, so every
% |HybridSolution| object is a |HybridArc| object as well.
 
bb_system = hybrid.examples.BouncingBall();

x0 = [10, 0];
tspan = [0, 20];
jspan = [0, 30];

% We set the "refine" option to 32 to improve the smoothness of plots by adding
% interpolated points to the solution.
% This does not improve the accuracy of the ODE solver.
config = HybridSolverConfig('refine', 32); 
sol = bb_system.solve(x0, tspan, jspan, config);
plotFlows(sol); % Display solution

%% Information About Solutions
% 
% Displaying the solution returned by the |solve| method shows the properties of
% |HybridSolution| objects: 
sol

%% 
% The |HybridSolution| class inherits the following properties from |HybridArc|:
% 
% * |t|: The continuous time values of the solution's hybrid time domain.
% * |j|: The discrete time values of the solution's hybrid time domain.
% * |x|: The state vector of the hybrid arc at each time step.
% * |jump_count|: the number of discrete jumps.
% * |jump_times|: the continuous times when each jump occured.
% * |is_jump_end| Column vector containing |1| at each entry where a jump end and |0| otherwise.
% * |is_jump_start| Column vector containing |1| at each entry where a jump starts and |0| otherwise.
% * |jump_end_indices| Column vector containing each index in t, j, and x arrays
% that is the end of a jump in the domain of the hybrid arc.
% * |jump_start_indices| Column vector containing each index in t, j, and x arrays
% that is the end of a jump in the domain of the hybrid arc.
% * |flow_lengths|: the durations of each interval of flow.
% * |shortest_flow_length|: the length of the shortest interval of flow.
% * |total_flow_length|: the length of the entire solution in continuous time.
% 
% |HybridSolution| objects also have the following additional properties:
%
% * |x0|: The initial state of the solution.
% * |xf|: The final state of the solution.
% * |termination_cause|: the reason that the solution terminated. 
%
% The possible values for |termination_cause| are 
% 
% * |STATE_IS_INFINITE|
% * |STATE_IS_NAN|
% * |STATE_NOT_IN_C_UNION_D|  
% * |T_REACHED_END_OF_TSPAN| 
% * |J_REACHED_END_OF_JSPAN|
% * |CANCELED|

%% Modifying Hybrid Arcs
% Often, after calculating a solution to a hybrid system, we wish to manipulate 
% the resulting data, such as evaluating a function along the solution, removing 
% some of the components, or truncating the hybrid domain. Several functions 
% to this end are included in the |HybridArc| class.
% In particular, the functions are |select|, |transform|, |restrictT| and
% |restrictJ|, |interpolateToArray|, |interpolateToHybridArc|. 
% See |<matlab:doc('HybridArc') doc('HybridArc')>| for details.
% Modifying a |HybridSolution| using the functions described in this
% section creates a |HybridArc| object---not a |HybridSolution| object---because
% the values |x0|, |xf|, and |termination_cause| may no longer be well-defined.

modified_harc = sol.select(1);                      % Pick the 1st component.
class(modified_harc)

modified_harc = modified_harc.transform(@(x) -x);   % Negate the value.
modified_harc = modified_harc.restrictT([1.5, 12]); % Truncate to t-values between 4.5 and 7.
modified_harc = modified_harc.restrictJ([2, inf]);  % Truncate to j-values >= 2.

% Plot hybrid arcs
clf
hpb = HybridPlotBuilder();
hpb.color('black').legend('Original').plotFlows(sol.select(1));
hold on
hpb.color('red').legend('Modified').plotFlows(modified_harc)

%% 
% *Example:* Suppose we want to compute the total energy
% of the bouncing ball: 
%
% $$E(x) = \gamma x_1 + \frac{1}{2} x_2^2.$$
%
% We can map the |HybridArc| object |sol| to a new |HybridArc| with the
% |transform| function. (Note that the state dimension before ($n=2$) and after ($n=1$)
% are not the same.)
% 
clf
energy_fnc = @(x) bb_system.gamma*x(1) + 0.5*x(2)^2;
plotFlows(sol.transform(energy_fnc))
title('Total Energy of Bouncing Ball')
ylabel('Energy')

%% Interpolation
% There are two functions for interpolating hybrid arcs to different time
% grids, which are called |interpolateToArray| and |interpolateToHybridArc|. 
% The function |interpolateToArray| creates (as the name suggests) an
% array of values |x_interp| of $x$ at the $t$ locations given as an array |t_grid|.

t_grid = linspace(1.2, 5.5, 10);
sol_x1 = sol.select(1); % Select only first component.
x1_interp = sol_x1.interpolateToArray(t_grid);

clf
% Plot original Hybrid Arc
hpb = HybridPlotBuilder().color('black').label('$x_1$')...
    .legend('Hybrid Arc')...
    .plotFlows(sol_x1.restrictT([0, 6]));
hold on

% Plot interpolated array.
interp_plt = plot(t_grid, x1_interp, 'red*-');
hpb.addLegendEntry(interp_plt, 'Interpolated Array');

% Plot interpolation grid.
grid_plt = plot(t_grid, 0*t_grid, 'r|');
hpb.addLegendEntry(grid_plt, 'Interpolation Grid');


%% 
% An evenly spaced interpolation grid can also be automatically generated by
% passing a single natural number |n_interp >= 2|. 
% In this case, you can use two output arguments, where the first is
% set to the interpolated values of $x$ and the second is set to the values of the
% interpolation grid for $t$.

n_interp = 300;
sol_x1 = sol.select(1); % Select only first component.
[x_interp, t_interp] = sol_x1.interpolateToArray(n_interp);
clf
plot(t_interp, x_interp, '.-')

%% 
% Alternatively, you can also use the |interpolateToHybridArc| function to
% create a new |HybridArc| object.
% The resulting hybrid arc interpolates the value of $x$ at each given point in
% time, but also includes the values at jumps (both before and after) so that
% the hybrid time domain is preserved (at least within the range of the given
% time grid---the range can be restricted).

% Create a few different grids, for illustration.
                 a_grid = linspace(0, 1, 40);
      t_grid_even_space = sol.t(end)*a_grid;
t_grid_increasing_space = sol.t(end)*a_grid.^2;
t_grid_decreasing_space = sol.t(end)*(1 - (1 - a_grid).^2);

% Create interpolated array.
sol_x1 = sol.select(1); % Select only first component.
sol_x1_interp_even = sol_x1.interpolateToHybridArc(t_grid_even_space);
sol_x1_interp_inc = sol_x1.interpolateToHybridArc(t_grid_increasing_space);
sol_x1_interp_dec = sol_x1.interpolateToHybridArc(t_grid_decreasing_space);

% Plot hybrid arcs.
clf
hpb = HybridPlotBuilder();

% Plot original hybrid arcs.
hpb.color('black').flowMarker('').jumpMarker('').legend('Original');
subplot(3, 1, 1); hpb.plotFlows(sol_x1); hold on
subplot(3, 1, 2); hpb.plotFlows(sol_x1); hold on
subplot(3, 1, 3); hpb.plotFlows(sol_x1); hold on

% Plot interpolated arcs.
hpb.color('red').jumpMarker('*').flowMarker('.');
subplot(3, 1, 1); hpb.legend('Interpolated (Even Space)').plotFlows(sol_x1_interp_even)
subplot(3, 1, 2); hpb.legend('Interpolated (Increasing Space)').plotFlows(sol_x1_interp_inc)
subplot(3, 1, 3); hpb.legend('Interpolated (Decreasing Space)').plotFlows(sol_x1_interp_dec)

%%
% For both interpolation functions, |interpolateToArray| and
% |interpolateToHybridArc| you can
% 
% * Pass a single integer instead of a time grid. The function then generates an
% evenly spaced time grid with the given number of points (in the case of
% |interpolateToHybridArc|, though, the number of output time steps will be
% generally be higher due to the time steps added at jumps!)
% * The interpolation method can be modified by using the name-value arguments
% |'InterpMethod'| followed by the desired interpolation method given as a
% string, such as |'previous'|, |'linear'|, etc. 
% See <matlab:doc('interp1') |interp1|> for a full list.
% 

%%
% The |interpolateToArray| function also has an option to set how to handle
% interpolation points that occur exactly at a jump time. 
% In such cases, there are two or more values of $x$ at a single value of $t$,
% so standard interpolation is not well defined. 
% The default behavior for |interpolateToArray| is to use the mean value of
% before and after (possibly multiple) jumps.

jump_time = 2;
t = [0; jump_time; jump_time; 4];
j = [0;         0;         1; 1];
x = [3;         3;         5; 5];
hybrid_arc = HybridArc(t, j, x);

% Grid for interpolation.
t_grid = [0; 1.5; jump_time; 3; 4];

x_interp = hybrid_arc.interpolateToArray(t_grid);

% Plot
clf
% Plot original HybridArc
HybridPlotBuilder().color('black').plotFlows(hybrid_arc)
hold on
% Plot interpolated values.
plot(t_grid, x_interp, 'redo-')

%%
% Setting the output to a NaN values causes it to be omitted from plots. 

x_interp = hybrid_arc.interpolateToArray(t_grid, 'ValueAtJump', 'nan');

% Plot
clf
HybridPlotBuilder().color('black').plotFlows(hybrid_arc)
hold on
plot(t_grid, x_interp, 'redo-')

%% 
% Setting 'ValueAtJump' to 'both' causes the values before and after the jump to
% both be included in the interpolated array (if a grid point aligns with the
% jump time). Consequently the number of rows in |x_interp| might be more than
% the number of entries in the given time grid |t_grid|. 
% Thus, to plot the interpolated points, use the second output argument
% |t_interp| which includes added entries to account for rows added to
% |x_interp| at jumps.
% rows.
[x_interp, t_interp] = hybrid_arc.interpolateToArray(t_grid, 'ValueAtJump', 'both');

clf
% Plot the origal arc. 
HybridPlotBuilder().color('black').plotFlows(hybrid_arc)
hold on
% Plot interpolated values
plot(t_interp, x_interp, 'redo-')

%% 
% Two other options for |"ValueAtJump"| are |"start"| and |"end"|, which
% included only the value before or after a jump.
x_interp_start = hybrid_arc.interpolateToArray(t_grid, 'ValueAtJump', 'start');
x_interp_end = hybrid_arc.interpolateToArray(t_grid, 'ValueAtJump', 'end');

clf
HybridPlotBuilder().color('black').plotFlows(hybrid_arc)
hold on
plot(t_grid, x_interp_start, '-', 'Color', 'red', 'Marker', 'd')
plot(t_grid, x_interp_end, '-', 'Color', 'blue', 'Marker', 'o')

