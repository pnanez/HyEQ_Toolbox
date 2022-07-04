function xplus = g(x, parameters)
    % Jump map for Bouncing Ball.
    lambda = parameters.lambda; % Coefficient of bounce restitution.
    xplus = [-x(1); -lambda*x(2)];
end