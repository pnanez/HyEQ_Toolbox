function inside_C = C(x, ~) 
    % Flow set for Bouncing Ball.
    % Return 0 if outside of C, and 1 if inside C
    if x(1) >= 0 % Flow if height is nonnegative.
        inside_C = 1;
    else 
        inside_C = 0;
    end
end