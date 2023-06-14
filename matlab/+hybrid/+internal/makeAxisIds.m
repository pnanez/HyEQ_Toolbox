function axis_ids = makeAxisIds(x_ndxs, axis_symbols)
% Given x_ndxs=[1, 2, 3] and axis_symbols={'x', 'x', 'x'}, create axis_ids={1, 2, 3}.
% Given x_ndxs=[1; 2] and axis_symbols={'t', 'j', 'x'}, create axis_ids={'t', 'j', 1; 
%                                                                        't', 'j', 2};.
% Given x_ndxs=[] and axis_symbols={'t', 'j'}, create axis_ids {'t', 'j'};.
% 
% The array x_ndxs contains, in each row, the state component indices
% for zero, one, two, or three axes. The cell array axis_symbols contains, in each
% row, one to three entries that are either 't', 'j', or 'x'. The output
% argument is a cell array that contains, in each row, entries equal to 't',
% 'j', or a state component index corresponding to the location of 't', 'j', or
% 'x', respectively, in axis_symbols. See makeAxisIdsTest.m for examples.

is_phase_plot = all(strcmp(axis_symbols, 'x'));
is_time_domain_plot = ~any(strcmp(axis_symbols, 'x'));

if is_phase_plot || is_time_domain_plot
    n_plots = 1;
else
    n_plots = numel(x_ndxs);
end

axis_ids = {};
next_out_ndx = 1;
n_state_nxds_required = n_plots*sum(strcmp(axis_symbols, 'x'));
assert(numel(x_ndxs) == n_state_nxds_required, ...
    'Required %d x_ndxs, but instead had %d.', ...
    n_state_nxds_required, size(x_ndxs, 2));
for i=1:length(axis_symbols)
    if strcmp(axis_symbols{i}, 'x')
        next_x_out_ndx = x_ndxs(:, next_out_ndx);
        axis_ids(:, i) = num2cell(next_x_out_ndx); %#ok<AGROW>
        next_out_ndx = next_out_ndx+1;
    elseif strcmp(axis_symbols{i}, 't')
        axis_ids(:, i) = cellstr(repmat('t', n_plots, 1)); %#ok<AGROW>
    elseif strcmp(axis_symbols{i}, 'j')
        axis_ids(:, i) = cellstr(repmat('j', n_plots, 1)); %#ok<AGROW>
    end
end
end