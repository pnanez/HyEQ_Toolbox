function flow_lengths = flowLengths(t, j)
% FLOWLENGTHS Compute the flow lengths of each interval of flows (i.e., the duration between each jump).

% If the solution ends with an interval of flow, rather
% than a jump, then we append the length of that last
% interval of flow to the flow lengths. We calculate the minimum
% flow length before appending the last interval of flow in case
% that last interval happens to be shorter than the minimum.

jump_times = hybrid.internal.jumpTimes(t, j);
flow_lengths = diff([0; jump_times]);

% Unless there was a jump at the final time, we append the
% length of the final interval of flow to the flow lengths. If
% there weren't any jumps, then this interval is the entire
% length of t(end) - t(1), otherwise it is
% t(end) - jump_times(end).
if isempty(jump_times)
    flow_lengths(end+1) = t(end) - t(1);
elseif(jump_times(end) ~= t(end))
    flow_lengths(end+1) = t(end) - jump_times(end);
end
end