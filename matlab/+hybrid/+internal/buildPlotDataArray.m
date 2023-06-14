function plot_data_array = buildPlotDataArray(axis_symbols, x_label_ndxs, hybrid_sol, plot_settings)
% Create a cell array of PlotData objects. 
%  axis_symbols: cell array containing 't', 'j', and 'x'
%  x_label_ndxs: numeric row vector containing the state component indices to use for
%               the label, legend, title, and limits. 
%    hybrid_sol: HybridSolution object that provides the values for t, j, and x.
% plot_settings: PlotSetting object that provides the current configuration.
% 
% Each plot will either be a phase plot with multiple state axes or a nonphase
% plot with a single state axis.

% We check if the plot is a phase plot by counting how many axes are state axes.
% If it's more than one, then the plot is a phase plot.
n_state_axes = sum(strcmp(axis_symbols, 'x'));
is_phase_plot = n_state_axes > 1;
is_time_domain_plot = n_state_axes == 0;

if is_time_domain_plot
    n_plts = 1;
elseif is_phase_plot
    n_plts = 1;
else
    n_plts = numel(x_label_ndxs);
end

% The number of axis symbols gives the dimension of the plot.
plt_dimension = size(axis_symbols, 2);
is2D = plt_dimension == 2;
is3D = plt_dimension == 3;
assert(is2D || is3D, 'plot dimension must be 2 or 3, instead was %d', plt_dimension);

% x_values_ndxs: numeric array containing the state component indices to use for
%               the values to plot. Each row gives, in each column, the indices 
%               for a single curve.
x_values_ndxs = 1:numel(x_label_ndxs);

assert(isequal(numel(x_label_ndxs), numel(x_values_ndxs)), ...
    'numel(x_label_ndxs)=%d ~= numel(x_values_ndxs)=%d', ...
    numel(x_label_ndxs), numel(x_values_ndxs))
if ~is_phase_plot && ~is_time_domain_plot
    % When not making a phase plot, each entry in x_label_ndxs and x_values_ndxs
    % represents a separate curve to plot. This is denoted by making them column
    % vectors instead of row vectors.
    x_label_ndxs = x_label_ndxs';
    x_values_ndxs = x_values_ndxs';
end

labels_axis_ids = hybrid.internal.makeAxisIds(x_label_ndxs, axis_symbols);
values_axis_ids = hybrid.internal.makeAxisIds(x_values_ndxs, axis_symbols);

plot_data_array = hybrid.internal.PlotData.empty(n_plts, 0);
for i = 1:n_plts
    plot_data_array(i) = hybrid.internal.PlotData(hybrid_sol); 
end

plot_data_array.addPlotArguments(plot_settings);

for i = 1:n_plts
    plot_data_array(i).addLabels(plot_settings, labels_axis_ids(i, :));
    plot_data_array(i).addAxisLimits(labels_axis_ids(i, :))
    plot_data_array(i).addPlotValues(hybrid_sol, values_axis_ids(i, :), plot_settings.timesteps_filter)

    if size(x_label_ndxs, 1) >= i
        i_state_ndx = x_label_ndxs(i,:);
        plot_data_array(i).state_ndx = i_state_ndx;
    else
        i_state_ndx = [];
    end
    
    if is_time_domain_plot || is_phase_plot
        plot_data_array(i).legend_label = plot_settings.createLegendLabel('single');
    else
        plot_data_array(i).legend_label = plot_settings.createLegendLabel(i_state_ndx);
    end

    if plot_settings.auto_subplots && ~is_time_domain_plot
        plot_data_array(i).title = plot_settings.getTitle(i_state_ndx);
        plot_data_array(i).subplot_ndx = i;
    else
        plot_data_array(i).title = plot_settings.getTitle('single');
        plot_data_array(i).subplot_ndx = 1;
    end
end

check_legend_count(x_label_ndxs, plot_settings.component_legend_labels);

% Check title count and label count.
n_titles = length(plot_settings.component_titles);
n_labels = length(plot_settings.component_labels);
if ~plot_settings.auto_subplots && n_titles > 1
    % When not using automatic subplots, only the first title is used. Thus, we
    % warn the user if there are extra titles to prevent them from being
    % confused.
    warning('Hybrid:ExtraTitles', ...
        ['Multiple (%d) titles were given but only the first (at index=1) ' ...
        'was used because automatic subplots are ''off''.'], ...
        n_titles)
end
if ~is_phase_plot && ~plot_settings.auto_subplots && n_labels > 1 
    % When not using automatic subplots, only the first label is used UNLESS the
    % plot is a phase plot. Thus, we warn the user if there are extra labels to
    % prevent them from being confused.
    warning('Hybrid:ExtraLabels', ...
        ['Multiple (%d) labels were given but only the first (at index=1) ' ...
        'was used because automatic subplots are ''off''.'], ...
        n_labels)
end

end % end of main function.

% === Local Functions === %

function check_legend_count(state_ndxs, lgd_labels)
% Print a warning if the number of plots and labels do not match.

if isempty(lgd_labels)
    % Nothing to check.
    return
end

lgd_count = length(lgd_labels);
is_phase_plot =  size(state_ndxs, 2) > 1;
is_time_domain_plot = isempty(state_ndxs);

if is_phase_plot
    % In a phase plot, only one legend entry is added.
    if lgd_count > 1
       warning('Hybrid:ExtraLegendLabels', ['Multiple (%d) legend labels were given ' ...
           'but only the first (at index=1) was used because the plot is a phase plot.'], ...
           lgd_count)
    end
    return
end

if is_time_domain_plot
    % In a time domain plot, only one legend entry is added.
    if lgd_count > 1
       warning('Hybrid:ExtraLegendLabels', ['Multiple (%d) legend labels were given ' ...
           'but only the first (at index=1) was used because the plot is a time domain plot.'], ...
           lgd_count)
    end
    return
end

expected_count = max(state_ndxs);

if expected_count == lgd_count
    return
end
warning_msg = 'Expected %d legend label(s) but %d were provided.';
if expected_count < lgd_count
    id = 'Hybrid:ExtraLegendLabels';
elseif expected_count > lgd_count
    id = 'Hybrid:MissingLegendLabels';
else
    error('Unexpected case.')
end
warning(id, warning_msg, expected_count, lgd_count)
end
