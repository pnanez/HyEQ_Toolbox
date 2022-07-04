function xdot = f(x, parameters)
    % Flow map for Bouncing Ball.
    gravity = parameters.gravity;
    xdot = [x(2); gravity];
end