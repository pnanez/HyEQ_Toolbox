function plotFlowLengths(sol)
% Plot the length for each interval of flow for a given HybridArc object. 
%
% Argument: sol - A HybridArc object.
% 
% See also: HybridArc.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
values = sol.flow_lengths;
indices = 1:length(values);
semilogy(indices, values, "b*");
% xlim([0, indices(end) + 2])
hold on
title("Lengths of Intervals of Flow")
xlabel("$j$", "interpreter", "latex")
ylabel("$\Delta t$", "interpreter", "latex")

% Only draw ticks at (at most) 12 of the indices.
xtickindices = floor(indices(1):length(indices)/12:indices(end));
xtickindices = unique([xtickindices, indices(end)]); % Add tick at last index.
if length(xtickindices) == 1
    xtickindices = [xtickindices-1, xtickindices];
end
xticks(xtickindices)

% Set the x-axis limits
indices_span = indices(end) - indices(1);
x_padding = 0.03 * (indices_span + 1); % 3-percent on each side.
xlim([indices(1) - x_padding, indices(end) + x_padding])

% Zero values are not displayed in semilog plots, but flows
% of length zero correspond to instaneous jumping, which is
% important information to display, so we mark zero values in
% a different color at the bottom of the plot.
zero_indices = values == 0;
if all(~zero_indices)
    % No nonzero values to display.
    padding_multiple = 1.1;
    ylim([min(values)/padding_multiple, padding_multiple*max(values)]);
    return
end

if any(~zero_indices)
    % If any of the values are nonzero, we want to preserve the
    % scaling of the plot (more or less), so we place markers
    % for zeros at half the minimum value.
    smallest_nonzero = min(values(~zero_indices));
    zero_display_value = smallest_nonzero / 2;
else
    zero_display_value = eps;
end
semilogy(indices(zero_indices), zero_display_value, "r*");

ylim([zero_display_value, 1.5*max(values)]);

legend("Nonzero values", "Zero values")
end