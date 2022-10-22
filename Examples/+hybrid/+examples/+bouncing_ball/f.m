function xdot = f(x, parameters)
    % Flow map for Bouncing Ball.
    gamma = parameters.gamma; % Acceleration due to gravity.
    xdot = [x(2); gamma];
end