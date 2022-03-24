function xplus = g(x)
    % Jump map for Example 1.2: Bouncing Ball.
    lambda = 0.8; % Coefficient of bounce restitution.
    xplus = [-x(1); -lambda*x(2)];
end