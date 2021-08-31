function [jump_t, jump_start_j, jump_start_indices, is_jump_start] = jumpTimes(t, j)
% JUMPTIMES Takes the t and j vectors output by HyEQsolver to find the time
% values where jump events occur. Also returns the corresponding values
% of j, the indices of the events, and an array containing ones in each
% entry where a jump did occured and a zero otherwise.
assert(length(t) == length(j), "length(t)=%d ~= length(j)=%d", length(t), length(j))
assert(~isempty(t), "t and j are empty")

if length(t) == 1 % Handle the case of a trivial solution.
    jump_t = [];
    jump_start_j = [];
    jump_start_indices = [];
    is_jump_start = 0;
    return;
end

is_jump_start = [diff(j) > 0; 0];
jump_start_indices = find(is_jump_start);
jump_t = t(jump_start_indices);
jump_start_j = j(jump_start_indices);
end