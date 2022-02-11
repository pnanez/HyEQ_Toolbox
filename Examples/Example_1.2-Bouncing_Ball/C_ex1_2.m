function inside_C = C_ex1_2(x) 
    % Flow set for Example 1.2: Bouncing Ball.
    % Return 0 if outside of C, and 1 if inside C
    if x(1) >= 0 % Flow if height is nonnegative.
        inside_C = 1;
    else 
        inside_C = 0;
    end
end