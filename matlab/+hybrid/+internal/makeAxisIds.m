function axis_ids = makeAxisIds(x_ndxs, axis_symbols)
% Given x_ndxs [1, 2, 3] and axis symbols {'x', 'x', 'x'}, create axis_ids {1, 2, 3}.
% Given x_ndxs [1; 2] and axis symbols {'t', 'j', 'x'}, create axis_ids {'t', 'j', 1; 
%                                                                        't', 'j', 2};.
% 
% The array x_ndxs contains, in each row, the state component indices
% for one, two, or three axes. The cell array axis_symbols contains, in each
% row, one to three entries that are either 't', 'j', or 'x'. The output
% argument is a cell array that contains, in each row, entries equal to 't',
% 'j', or a state component index corresponding to the location of 't', 'j', or
% 'x', respectively, in axis_symbols. See makeAxisIdsTest.m for examples.
plot_count = size(x_ndxs, 1);
axis_ids = {};
next_out_ndx = 1;
n_state_nxds_required = plot_count*sum(strcmp(axis_symbols, 'x'));
assert(numel(x_ndxs) == n_state_nxds_required, ...
    'Required %d x_ndxs, but instead had %d.', ...
    n_state_nxds_required, size(x_ndxs, 2));
for i=1:length(axis_symbols)
    if strcmp(axis_symbols{i}, 'x')
        next_x_out_ndx = x_ndxs(:, next_out_ndx);
        next_out_ndx = next_out_ndx+1;
        axis_ids(:, i) = num2cell(next_x_out_ndx); %#ok<AGROW>
    end
end
for i=1:length(axis_symbols)
    if strcmp(axis_symbols{i}, 't')
        axis_ids(:, i) = cellstr(repmat('t', plot_count, 1)); %#ok<AGROW>
    elseif strcmp(axis_symbols{i}, 'j')
        axis_ids(:, i) = cellstr(repmat('j', plot_count, 1)); %#ok<AGROW>
    end
end
end