function xdot = f(x)
    % Flow map for Example 1.2: Bouncing Ball.
    gravity = -9.81;
    xdot = [x(2); 
            gravity];
end