function xdot = f_ex1_2(x)
    % Flow map for Example 1.2: Bouncing Ball.
    g = -9.81;
    xdot = [x(2); g];
end