function flows_x = separateFlowsWithNaN(t, j, x)
[~, ~, ~, is_jump] = HybridUtils.jumpTimes(t, j);

if length(t) <= 1
    flows_x = [];
    return
end

% Modify is_jump by prepending a 1 and setting the last entry
% to 1. These changes emulate 'virtual' jumps immediately prior
% to and after the given hybrid time domain.
is_jump = [1; is_jump(1:(end-1)); 1];

% Everywhere in the domain where the previous entry was a jump
% and the next entry is not is the start of an interval of
% flow.
is_start_of_flow = diff(is_jump) == -1;

% Similarly, everywhere in the domain where the previous entry
% was not a jump and the next entry is a jump, is the end of
% an interval of flow.
is_end_of_flow = diff(is_jump) == 1;

start_of_flow_ndxs = find(is_start_of_flow);
end_of_flow_ndxs = find(is_end_of_flow);

n_flows = sum(is_start_of_flow);
n_interior_flow_boundaries = n_flows - 1;
n_flow_entries = sum(end_of_flow_ndxs - start_of_flow_ndxs + 1);

% Create an array to hold the values with NaN padding between
% flows.
flows_x = NaN(n_flow_entries+n_interior_flow_boundaries, size(x, 2));

% out_start_ndx tracks the starting index for the output array.
out_start_ndx = 1;
for i = 1:n_flows
    start_ndx = start_of_flow_ndxs(i);
    end_ndx = end_of_flow_ndxs(i);
    ndx_count = end_ndx - start_ndx + 1;
    
    in_ndxs = start_ndx:end_ndx;
    out_ndxs = out_start_ndx:(out_start_ndx + ndx_count - 1);
    flows_x(out_ndxs, :) = x(in_ndxs, :);
    
    out_start_ndx = out_start_ndx + ndx_count + 1;
end
end