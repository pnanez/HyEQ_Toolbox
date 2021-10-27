function plot_data_array = buildPlotDataArray(axis_symbols, state_ndxs, hybrid_sol, plot_settings)
axis_ids = hybrid.internal.makeAxisIds(state_ndxs, axis_symbols);
n_plts = size(axis_ids, 1);
plt_dimension = size(axis_ids, 2);
is2D = plt_dimension == 2;
is3D = plt_dimension == 3;
assert(is2D || is3D, 'plot dimension must be 2 or 3, instead was %d', plt_dimension);

check_legend_count(state_ndxs, plot_settings.component_legend_labels);

plot_data_array = hybrid.internal.PlotData.empty(n_plts, 0);
for i = 1:n_plts
    plot_data_array(i) = hybrid.internal.PlotData(hybrid_sol);
end

plot_data_array.addPlotArguments(plot_settings);

for i = 1:n_plts
    plot_data_array(i).addLabels(plot_settings, axis_ids(i, :));
    plot_data_array(i).addAxisLimits(axis_ids(i, :))
    plot_data_array(i).addPlotValues(hybrid_sol, axis_ids(i, :), plot_settings.timesteps_filter)

    state_ndx = state_ndxs(i,:);
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
