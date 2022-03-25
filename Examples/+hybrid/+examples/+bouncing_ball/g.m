function xplus = g(x)
    % Jump map for Bouncing Ball.
    lambda = 0.8; % Coefficient of bounce restitution.
    xplus = [-x(1); -lambda*x(2)];
end