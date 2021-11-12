function plot_data_array = buildPlotDataArray(axis_symbols, x_label_ndxs, x_values_ndxs, hybrid_sol, plot_settings)
% Create a cell array of PlotData objects. 
%   axis_sybols: cell array containing 't', 'j', and 'x'
%  x_label_ndxs: numeric array containing the state component indices to use for
%               the label, legend, title, and limits. 
% x_values_ndxs: numeric array containing the state component indices to use for
%               the values to plot.
%    hybrid_sol: HybridSolution object that provides the values for t, j, and x.
% plot_settings: PlotSetting object that provides the current configuration.
assert(all(size(x_values_ndxs) == size(x_label_ndxs)))
labels_axis_ids = hybrid.internal.makeAxisIds(x_label_ndxs, axis_symbols);
values_axis_ids = hybrid.internal.makeAxisIds(x_values_ndxs, axis_symbols);
n_plts = size(labels_axis_ids, 1);
plt_dimension = size(labels_axis_ids, 2);
is2D = plt_dimension == 2;
is3D = plt_dimension == 3;
assert(is2D || is3D, 'plot dimension must be 2 or 3, instead was %d', plt_dimension);

check_legend_count(x_label_ndxs, plot_settings.component_legend_labels);

plot_data_array = hybrid.internal.PlotData.empty(n_plts, 0);
for i = 1:n_plts
    plot_data_array(i) = hybrid.internal.PlotData(hybrid_sol); 
end

plot_data_array.addPlotArguments(plot_settings);

for i = 1:n_plts
    plot_data_array(i).addLabels(plot_settings, labels_axis_ids(i, :));
    plot_data_array(i).addAxisLimits(labels_axis_ids(i, :))
    plot_data_array(i).addPlotValues(hybrid_sol, values_axis_ids(i, :), plot_settings.timesteps_filter)

    state_ndx = x_label_ndxs(i,:);
    plot_data_array(i).state_ndx = state_ndx;
    plot_data_array(i).legend_label = plot_settings.createLegendLabel(state_ndx);
    
    if plot_settings.auto_subplots
        plot_data_array(i).title = plot_settings.getTitle(state_ndx);
        plot_data_array(i).subplot_ndx = i;
    else
        plot_data_array(i).title = plot_settings.getTitle(1);
        plot_data_array(i).subplot_ndx = 1;
    end
end
end % end of main function.

function check_legend_count(state_ndxs, lgd_labels)
% Print a warning if the number of plots and labels do not match.

if isempty(lgd_labels)
    return
end
if size(state_ndxs, 2) > 1
    % If there are multiple state indices, then the plot will be plotted in
    % phase space and only one legend entry is added.
    expected_count = size(state_ndxs, 1);
else
    expected_count = max(state_ndxs);
end

lgd_count = length(lgd_labels);
warning_msg = 'Expected %d legend label(s) but %d were provided.';
if expected_count < lgd_count
    id = 'HybridPlotBuilder:TooManyLegends';
    warning(id, warning_msg, expected_count, lgd_count)
elseif expected_count > lgd_count
    id = 'HybridPlotBuilder:TooFewLegends';
    warning(id, warning_msg, expected_count, lgd_count)
end
end
