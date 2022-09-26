function xdot = f(x, parameters)
    % Flow map for Bouncing Ball.
    gamma = parameters.gamma; % Gravity constant
    xdot = [x(2); gamma];
end