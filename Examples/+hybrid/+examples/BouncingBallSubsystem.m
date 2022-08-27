classdef BouncingBallSubsystem < HybridSubsystem
% A bouncing ball with an input modeled as a HybridSubsystem subclass.


    % Define properties of the system that can be modified.
    properties
        gamma = -9.8; % Acceleration due to gravity.
        lambda = 0.9; % Coefficient of bounce restitution.
    end

    % Define properties of the system that cannot be modified (i.e., "immutable").
    properties(SetAccess = immutable)
        % The index of the ball's height within the state vector.
        height_index = 1;
        % The index of the ball's velocity within the state vector.
        velocity_index = 2;
    end
    
    methods
        function obj = BouncingBallSubsystem() % Constructor.
            state_dim = 2;
            input_dim = 1;
            output_dim = 2; % Matches state_dim (default).
            output_fnc = @(x) x; % Full-state output (default).

            % Call the constructor of the superclass 'HybridSubsystem' to create
            % the object.
            obj = obj@HybridSubsystem(state_dim, input_dim, output_dim, output_fnc);
        end

        % To define the data (f, g, C, D) of the system, we implement 
        % the abstract functions from HybridSubsystem.m
        
        function xdot = flowMap(this, x, u, t, j)  
            % Extract the state component 'v'.
            v = x(this.velocity_index);

            % Define the value of f(x, u). 
            xdot = [v; this.gamma];
        end

        function xplus = jumpMap(this, x, u, t, j) 
            % Extract the state components.
            h = x(this.height_index);
            v = x(this.velocity_index);
            % Define the value of g(x, u). 
            xplus = [h; -this.lambda*v + u];
        end 

        function inC = flowSetIndicator(this, x, u, t, j)
            % Extract the state components.
            h = x(this.height_index);
            v = x(this.velocity_index);

            % Set 'inC' to 1 if 'x' is in the flow set and to 0 otherwise.
            inC = h >= 0 || v >= 0;
        end 

        function inD = jumpSetIndicator(this, x, u, t, j)
            % Extract the state components.
            h = x(this.height_index);
            v = x(this.velocity_index);

            % Set 'inD' to 1 if 'x' is in the jump set and to 0 otherwise.
            inD = h <= 0 && v <= 0;
        end
    end
end