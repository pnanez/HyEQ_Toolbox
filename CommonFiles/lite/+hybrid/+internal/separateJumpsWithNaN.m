function [jumps_x, jumps_befores, jumps_afters] = separateJumpsWithNaN(t, j, x)
[~, ~, jump_indices] = hybrid.internal.jumpTimes(t, j);

jump_count = length(jump_indices);

% Create an array to hold the values with NaN padding between
% flows.
n = size(x, 2);
jumps_befores = NaN(3*jump_count, n);
jumps_afters = NaN(3*jump_count, n);
jumps_x = NaN(3*jump_count, n);

for i=1:jump_count
    jump_ndx = jump_indices(i);
    offset = 3*(i-1);
    jumps_befores(1 + offset, :) = x(jump_ndx, :);
    if jump_ndx < size(x, 1)
        jumps_afters(1 + offset, :) = x(jump_ndx+1, :);
    end
end
jumps_x(1:3:end, :) = jumps_befores(1:3:end, :);
jumps_x(2:3:end, :) = jumps_afters(1:3:end, :);
end