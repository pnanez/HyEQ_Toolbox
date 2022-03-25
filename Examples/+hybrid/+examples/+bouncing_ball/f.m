function xdot = f(x)
    % Flow map for Bouncing Ball.
    gravity = -9.81;
    xdot = [x(2); gravity];
end