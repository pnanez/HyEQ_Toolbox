%% Creating plots with HybridPlotBuilder
%% Setup
% We first create several solutions that are used in
% subsequent examples.
system = hybrid.examples.ExampleBouncingBallHybridSystem();
system_3D = hybrid.examples.Example3DHybridSystem();
config = HybridSolverConfig('Refine', 15); % 'Refine' option makes the plots smoother.
sol = system.solve([10, 0], [0 30], [0 30], config);
sol_3D = system_3D.solve([0; 1; 0], [0, 20], [0, 100], config);
sol_8D = HybridSolution(sol.t, sol.j, sol.x(:, 1)*(1:8));

%% Basic Plotting
% The Hybrid Equations Toolbox provides two approaches to plotting hybrid
% solutions, depending the level of control required. The first approach,
% designed for quickly viewing solutions, is to 
% pass a |HybridSolution| object to |plotFlows|, |plotJumps|,
% |plotHybrid|, or |plotPhase|.
% The |plotFlows| function plots each component of the solution versus
% discrete time $t$.
plotFlows(sol); % x vs. t

%%
% The |plotJumps| function plots each component of the solution versus
% discrete time $j$.
plotJumps(sol); % x vs. j

%%
% The |plotHybrid| function plots each component of the solution versus
% hybrid time $(t, j)$.
plotHybrid(sol); % x vs. (t, j)

%%
% The |plotPhase| function plots a 2D or 3D solution vector |x| in phase space.
plotPhase(sol); % x1 vs. x2
title('2D Phase Plot')
snapnow; clf
plotPhase(sol_3D)
title('3D Phase Plot')
view([63.6 28.2]) % Set the view angle.

%%
% For solutions with four or less components, |plotFlows|, |plotJumps|,
% |plotHybrid| plot each components in separate subplots, as shown above.
% Solutions with five or more components are plotted in
% a single subplot with each colors and a legend included to label each component.
plotFlows(sol_8D)

%% 
% The second plotting approach is to
% use the |HybridPlotBuilder| class explicitly (the first approach also uses
% |HybridPlotBuilder| "under the hood" to draw plots). This approach
% allows for extensive customization and is therefore, better suited for
% creation of plots for publication. The remainder of this document discusses
% how to use the second approach. The first step is to 
% create an instance of |HybridPlotBuilder|. 
hpb = HybridPlotBuilder();

%% 
% Properties are set by calling functions (described below) on the
% |HybridPlotBuilder| object.
hpb.flowColor('black'); % Set the flow color to black.

%% 
% To create a plot, one of the plotting functions |plotFlows|, |plotJumps|,
% |plotHybrid|, or |plotPhase| is called. Note that subplots are not created,
% by default.
hpb.plotFlows(sol)

%%
% If the plot builder is only used once, it can be used immediately without
% assign it to a variable by _chaining_ a series of function calls.
clf() % Clear figure
HybridPlotBuilder().flowColor('black').plotFlows(sol);

%% 
% WARNING: prior to MATLAB version R2016a, function calls cannot be chained
% directly after a constructor, so the code above must be 
% split into a variable assignment, followed by the function calls:
% 
%   hpb = HybridPlotBuilder();
%   hpb.flowColor('black').plotFlows(sol);

%% Automatic Subplots
% When using |HybridPlotBuilder|, automatic subplots can be enabled via the
% |subplots| function. Note that state components are automatically labeled.
HybridPlotBuilder().subplots('on').plotFlows(sol)

%% Choosing Components to Plot
% The |slice| function selects which components to plot and which order to plot them.
% To plot components 1 and 2, pass the array |[1, 2]| to |slice| 
% (equivalently, |slice(1:2)|).
HybridPlotBuilder().slice([1,2]).plotPhase(sol_3D);

%% 
% To switch the order of components in the plot, simply switch the order in the
% array. Note that the labels update accordingly.
HybridPlotBuilder().slice([2,1]).plotPhase(sol_3D);

%% Plotting Values Other Than Solution Components 
% It is possible to plot non-state values. 
% To accomplish this, pass a |HybridSolution| object as the first argument to
% a plotting function, which provides the hybrid time domain, and pass an
% array of values to the second argument, which are the actual values plotted.
% The length of the first dimension of the values array must match the entries
% in |sol.t|.
height = sol.x(:, 1); % Extract height component
HybridPlotBuilder().plotFlows(sol, -height) % Plot negative height
title('Negative Height')

%% 
% Alternatively, a function handle can be evaluated along the solution and plotted
% as follows. The evaluation of the function is done via the function
% |HybridSolution.evaluateFunction()|. See 
% 
%    doc HybridSolution.evaluateFunction
% 
% for details.
g = system.gravity;
HybridPlotBuilder().plotFlows(sol, @(x) g*x(1) + 0.5*x(2)^2); 
title('Total Energy')

%% 
% The function handle passed to plotting function must have the input arguments 
% |@(x)|, |@(x, t)| or |@(x, t, j)| and return a column vector.

%% Customizing Plot Appearance
% The following functions modify the appearance of flows.
HybridPlotBuilder().slice(1)...
    .flowColor('black')...
    .flowLineWidth(2)...
    .flowLineStyle(':')...
    .plotFlows(sol)

%% 
% Similarly, we can change the appearance of jumps.
HybridPlotBuilder().slice(1:2)...
    .jumpColor('m')... % magenta
    .jumpLineWidth(1)...
    .jumpLineStyle('-.')...
    .jumpStartMarker('+')...
    .jumpStartMarkerSize(16)...
    .jumpEndMarker('o')...
    .jumpEndMarkerSize(10)...
    .plotPhase(sol_3D)

%% 
% To confiugre the the jump markers on both sides of jumps, omit 'Start'
% and 'End' from the function names:
HybridPlotBuilder().slice(1:2)...
    .jumpMarker('s')... % square
    .jumpMarkerSize(12)...
    .plotPhase(sol_3D)

%% 
% To hide jumps or flows, set the corresponding color to 'none.' To hide jump
% markers only, but show jump lines set the marker style to 'none'. Similarly,
% to hide only jump lines, set the jump line style to 'none.'
HybridPlotBuilder().slice(2)...
    .flowColor('none')...
    .jumpEndMarker('none')...
    .jumpLineStyle('none')...
    .plotFlows(sol)
title('Start of Each Jump') % An alternative way to add titles is shown below.

%%
% Sequences of colors can be set by passing a cell array to
% the color functions. When auto-subplots are off, the color
% that each component is plotted rotates through the given colors. The following
% commands create a plot where the first 
% component is plotted with blue flows and red jumps, and the second component
% is plotted with black flows and green jumps. (If the solution had a third
% component, the colors would cycle back to blue flows and red jumps.)
clf
HybridPlotBuilder().subplots('off')...
    .flowColor({'blue', 'black'})...
    .jumpColor({'red', 'green'})...
    .legend('$h$', '$v$')...
    .plotFlows(sol);

%%
% When auto-subplots are enabled, then all the plots added by a single call to a
% plotting function are the same color, and all the plots added by the next call
% to a plotting function are the next color, and so on. Note, here, we set both
% flow and jump color via the |color| function. Furthermore, the |'matlab'|
% argument tells |HybridPlotBuilder| to use the default colors used by MATLAB plots. 
hpb = HybridPlotBuilder().subplots('on').color('matlab');
hold on
hpb.legend('$h$', '$v$').plotFlows(sol);
hpb.legend('$2h$', '$2v$').plotFlows(sol, @(x) 2*x);
hpb.legend('$3h$', '$3v$').plotFlows(sol, @(x) 3*x);

%% Axis Labels
% For state axes, labels are set via the |labels| functions (or, optionally,
% the |label| function if there is only one label). 
% If auto-subplots is off, then all state components are placed in a
% single plot, so a single label displayed, which is set by the |label|
% function. 
clf
HybridPlotBuilder()...
    .label('My Label')...
    .plotFlows(sol)

%% 
% Labels are also displayed for plots in 2D or 3D phase space.
clf
HybridPlotBuilder().slice([2 1])...
    .labels('$h$', '$v$')...
    .plotPhase(sol)

%%
% For phase plots and when auto-subplots are enabled, then state-axis labels are set
% component-wise. For example, to plot and label only the second and third
% components, it is necessary to provide three labels (the first is unused,
% in this case): 
clf
HybridPlotBuilder().subplots('on').slice(2:3)...
    .labels('', 'Component 2', 'Component 3')...
    .plotFlows(sol_3D)

%%
% If there are a large number of components, it can be more convienient to
% specify the labels in a cell array, as follows:
clf
labels = {}; % Make sure 'labels' starts as an empty array.
labels{2} = 'Component 2';
labels{3} = 'Component 3';
HybridPlotBuilder().subplots('on').slice(2:3)...
    .labels(labels)...
    .plotFlows(sol_3D)

%%
% The |t| and |j| axis labels and the default label for the state
% components can be modified as follows. If the string passed to
% |xLabelFormat| contains |'%d'|, then it is substituted with the index
% number of the component.
clf
HybridPlotBuilder()...
    .tLabel('$t$ [s]')...
    .jLabel('$j$ [k]')...
    .xLabelFormat('$z_{%d}$')...
    .plotHybrid(sol)

%% Plot Titles
% Adding titles is similar to adding labels. (Update?)
clf
HybridPlotBuilder().subplots('on').slice([2 1])...
    .titles('Component 1', 'Component 2')...
    .plotFlows(sol)

%% 
% One place where the behavior of labels and titles differ are in 2D or 3D
% plots of a solution in phase space. 
% A plot in phase space only contains one subplot, so only the first title
% is displayed. For this case, the |title| function can be used instead of
% |titles|.
clf
HybridPlotBuilder().title('Phase Plot').plotPhase(sol)


%% Legends
% When using auto-subplots, legends are added to each subplot on a
% component-wise basis. This means that legends switch locations when |slice| is
% used.
clf
HybridPlotBuilder().subplots('on')...
    .legend('Component 1', 'Component 2')...
    .slice([2 1])...
    .plotFlows(sol);

%%
% If |slice| is used to omit components, it is necessary to include a legend
% entry for omitted components so that the legend entries for displayed components
% are displayed correctly. 
HybridPlotBuilder().subplots('on')...
    .legend('', 'Component 2')...
    .slice(2)...
    .plotFlows(sol);

%%
% Graphic objects added to a figure without |HybridPlotBuilder|
% can be added to the legend by passing the graphic handle to |addLegendEntry|.
clf
pb = HybridPlotBuilder()...
    .legend('Hybrid Plot')...
    .plotPhase(sol);
hold on
axis equal
% Plot a circle.
theta = linspace(0, 2*pi);
plt_handle = plot(10*cos(theta), 10*sin(theta), 'black');
% Pass the circle to the plot builder.
pb.addLegendEntry(plt_handle, 'Circle');

%% Text Interpreters
% The default interpreter for text is |latex| and can be changed by calling
% |titleInterpreter()| or |labelInterpreter()|. Use one of these values:
% |none| | |tex| | |latex|. The default labels automatically change to
% match the label interpreter.
HybridPlotBuilder().subplots('on')...
    .titleInterpreter('none')...
    .labelInterpreter('tex')...
    .titles('''tex'' is used for labels and ''none'' for titles',...
            'In ''tex'', dollar signs do not indicate a switch to math mode', ...
            'default label is formatted to match interpreter') ...
    .labels('z_1', '$z_2$')... % only two labels provided.
    .plotFlows(sol_3D)

%%
% When automatic subplots are off, only the first label and title are used.
% For legends, however, as many legend entries are used as plots have been
% added. 
clf
pb = HybridPlotBuilder();
pb.subplots('off')...
    .labels('Label 1', 'Label 2')... % Only first label is used.
    .titles('Title 1', 'Title 2')... % Only first title is used.
    .legend('Legend 1', 'Legend 2')... % Both two legend entries are used.
    .plotFlows(sol)

%%
% Legend options can be set simlar to the MATLAB legend function. The legend
% labels are passed as a cell array (enclosed with braces '{}') and name/value
% pairs are passed in subsequent arguments.
clf
HybridPlotBuilder()...
    .legend({'h', 'v'}, 'Location', 'southeast')...
    .plotFlows(sol);

%% 
% Passing legend labels as a cell array is also useful when not plotting the
% first several entries. The following notation creates a cell array with the
% first two entries empty and the third set to the given value. 
lgd_labels = {}; % This line is only necessary if lgd_labels is previously defined (but a good idea just in case).
lgd_labels{3} = 'Component 3';

%% 
% We can then set the relevant legend label without explicitly putting empty
% labels for the first two components (i.e., |legend('', '', 'Component 3').|
clf
HybridPlotBuilder()...
    .legend(lgd_labels, 'Location', 'southeast')...
    .slice(3)...
    .plotFlows(sol_3D);

%%
% The 'titles' and 'labels' functions also accept values given as a cell array,
% but do not accept subsequent options.
clf
labels{2} = '$y_2$';
titles{2} = 'Plot of second component';
HybridPlotBuilder()...
    .labels(labels)...
    .titles(titles)...
    .slice(2)...
    .plotFlows(sol_3D);

%%
% The above method applies the same settings to the legends in all subplots. 
% To modify legend options separately for each subplot, use the |configurePlots|
% function described below.

%% Filtering Solutions
% Portions of solutions can be hidden with the |filter| function. In this
% example, we create a filter that only includes points where the second
% component (velocity) is negative. (If the time-step size
% along flows is large, deleted lines connected to filtered points may
% extends a noticible distance into the portion of the solution that should
% be visible.)
is_falling = sol.x(:,2) < 0;
HybridPlotBuilder().subplots('on')...
    .filter(is_falling)...
    .plotFlows(sol)

%% Plotting System Modes
% Filtering is useful for plotting systems where an integer-value
% component indicates the mode of the system. 
% Here, we create a 3D system with a continuous variable $z \in \bf{R}^2$
% and a discrete variable $q \in \{0, 1\}$. Points in the solution where 
% $q = 0$ are plotted in blue, and points where $q = 1$ are plotted in
% black. The same |HybridPlotBuilder| object is used for both plots by saving it 
% to the |builder| variable (this allows us to specify the labels only
% once and add a legend for both plots). 
clf
system_with_modes = hybrid.examples.ExampleModesHybridSystem();

% Create initial condition and solve.
z0 = [-7; 7];
q0 = 0;
sol_modes = system_with_modes.solve([z0; q0], [0, 10], [0, 10], 'silent');

% Extract values for q-component.
q = sol_modes.x(:, 3);

% Plot the [1, 2] components (that is, the first two components) of
% sol_modes at all time steps where q == 0. 
builder = HybridPlotBuilder();
builder.title('Phase Portrait') ...
    .labels('$x_1$', '$x_2$') ...
    .legend('$q = 0$') ...
    .slice([1,2]) ... % Pick which state components to plot
    .filter(q == 0) ... % Only plot points where q is 0.
    .plotPhase(sol_modes)
hold on % See the section below about 'hold on'
% Plot in black the solution (still only the [1,2] components) for all time
% steps where q == 1. 
builder.flowColor('black') ...
    .jumpColor('none') ...
    .filter(q == 1) ... % Only plot points where q is 1.
    .plotPhase(sol_modes)
axis padded
axis equal

%%
% For the bouncing ball system, we can change the color of the plot based on
% whether the ball is falling.
clf
is_falling = sol.x(:, 2) < 0;
pb = HybridPlotBuilder()....
    .subplots('on')...
    .filter(is_falling)...
    .jumpColor('none')...
    .flowColor('k')...
    .legend('Falling', 'Falling')...
    .plotFlows(sol);
hold on
pb.filter(~is_falling)...
    .flowColor('g')...
    .legend('Rising', 'Rising')...
    .plotFlows(sol);

%% Replacing vs. Adding Plots to a Figure
% By default, each call to a |HybridPlotBuilder| plot function overwrites the 
% previous plots. In the following code, we call |plotFlows| twice. The
% first call plots a solution in blue and red, but the second call resets the figure
% and plots a solution in black and green.
tspan = [0 10];
jspan = [0 30];
sol1 = system.solve([10, 0], tspan, jspan, config);
sol2 = system.solve([ 5, 10], tspan, jspan, config);

clf
HybridPlotBuilder().slice(1)... % Plots blue flows and red jumps by default.
    .plotFlows(sol1)
HybridPlotBuilder().slice(1).flowColor('black').jumpColor('green')...
    .title('Multiple Calls to $\texttt{plotFlows}$ with \texttt{hold off}') ...
    .plotFlows(sol2)
%% 
% To plot multiple graphs on the same figure, use |hold on|, similar to
% standard MATLAB plotting functions.
clf
HybridPlotBuilder().slice(1).plotFlows(sol1) % Plots blue flows and red jumps by default.
hold on
HybridPlotBuilder().slice(1).flowColor('black').jumpColor('green')...
    .title('Multiple Calls to $\texttt{plotFlows}$ with \texttt{hold on}')...
    .plotFlows(sol2)

%% Modifying Defaults
% The default values of all |HybridPlotBuilder| settings can be modified by
% calling 'set' on the 'defaults' property. The arguments are must be name-value
% pairs, where the name is a string that matches one of the
% properties in PlotSettings (names are case insensitive and underscores can be
% replaced with spaces). 
clf
HybridPlotBuilder.defaults.set('auto_subplots', 'on', ...
                             'Label Size', 14, ...
                             'Title Size', 16, ...
                             'label interpreter', 'tex', ...
                             'title interpreter', 'none', ...
                             'flow_color', 'k', ...
                             'flow line width', 2, ...
                             'jump_color', 'k', ...
                             'jump line width', 2, ...
                             'jump line style', ':', ...
                             'jump start marker', 's', ...
                             'jump start marker size', 10, ...
                             'jump end marker', 'none', ...
                             'x_label_format', 'z_{%d}', ...
                             't_label', 't [s]')
HybridPlotBuilder()...
    .title('Title')...
    .legend('Legend A', 'Legend B')...
    .plotFlows(sol);

%% 
% The defaults can be reset to their original value with the following command.
HybridPlotBuilder.defaults.reset()

%% Default Scaling
% Matlab is inconsistent about the size of text and graphics in plots on
% different devices. To mitigate this difference, three values are included in
% the settings to adjust the size of text, lines, and markers.
clf
HybridPlotBuilder.defaults.set('text scale', 1.5, ...
                                'line scale', 3, ...
                                'marker scale', 2)
% Example output:
HybridPlotBuilder()...
    .slice(1)...
    .title('Title')...
    .legend('height')...
    .plotFlows(sol);

HybridPlotBuilder.defaults.reset() % Cleanup

%%
% To set the default values in every MATLAB session, create a script named
% 'startup.m' in the folder returned by the |userpath()| command. 
% The commands in this script will run every time MATLAB starts.

%% Additional configuration
% There are numerous options for configuring the appearance of Matlab plots
% that are not included explicitly in |HybridPlotBuilder| (see
% <https://www.mathworks.com/help/matlab/ref/matlab.graphics.axis.axes-properties.html
% here>).
% For plots with a single subplot, the appearance can be modified just like any
% other Matlab plot.
HybridPlotBuilder().plotPhase(sol);
grid on
ax = gca;
ax.YAxisLocation = 'right';

%%
% Plots with multiple subplots can also be configured as described above by
% calling |subplot(2, 1, 1)| and making the desired modifications, then
% calling |subplot(2, 1, 2)|, etc., but that approach 
% is messy and tediuous. Instead, the |configurePlots| function provides a
% cleaner alternative. A function handle is passed to |configurePlots|,
% which is then called by |HybridPlotBuilder| within each (sub)plot.
% The function handle passed to |configurePlots| must take two input
% arguments. The first is the axes for the subplot and the second is the index
% for the state component(s) plotted in the plot. For |plotFlows|, |plotJumps|,
% and |plotHybrid|, this will be one 
% integer, and for phase plots generated with |plot|, this will be an array of
% two or three integers, depending on the dimension of the plot.
HybridPlotBuilder()...
    .subplots('on')...
    .legend('A', 'B')...
    .configurePlots(@apply_plot_settings)...
    .plotFlows(sol);

function apply_plot_settings(ax, component)
    title(ax, sprintf('This is the plot of component %d', component))
    subtitle(ax, 'An Insightful Subtitle','FontAngle','italic')
    % Set the location of the legend in each plot to different positions.
    switch component 
        case 1
            ax.Legend.Location = 'northeast';
        case 2
            ax.Legend.Location = 'southeast';
    end
    % Configure grid
    grid(ax, 'on')
    grid(ax, 'minor')
    ax.GridLineStyle = '--';
end