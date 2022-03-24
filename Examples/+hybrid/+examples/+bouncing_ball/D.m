function inside_D = D(x) 
    % Jump set for Example 1.2: Bouncing Ball.
    % Return 0 if outside of D, and 1 if inside D
    if (x(1) <= 0 && x(2) <= 0)
        inside_D = 1;
    else 
        inside_D = 0;
    end
end