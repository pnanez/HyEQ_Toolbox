classdef BouncingBall < HybridSystem
    % A bouncing ball modeled as a HybridSystem subclass.

    % Define variable properties that can be modified.
    properties
        gamma = 9.8;  % Acceleration due to gravity.
        lambda = 0.9; % Coefficient of restitution.
    end

    % Define constant properties that cannot be modified (i.e., "immutable").
    properties(SetAccess = immutable) 
        % The index of 'height' component 
        % within the state vector 'x'. 
        height_index = 1;
        
        % The index of 'velocity' component 
        % within the state vector 'x'. 
        velocity_index = 2;
    end

    methods 
        function this = BouncingBall()
            % Constructor for instances of the BouncingBall class.

            % Call the constructor for the HybridSystem superclass and
            % pass it the state dimension. This is not strictly necessary, 
            % but it enables more error checking.
            state_dim = 2;
            this = this@HybridSystem(state_dim);
        end

        % To define the data of the system, we implement 
        % the abstract functions from HybridSystem.m

        function xdot = flowMap(this, x, t, j)
            % Extract the state components.
            v = x(this.velocity_index);

            % Define the value of f(x). 
            xdot = [v; -this.gamma];
        end

        function xplus = jumpMap(this, x)
            % Extract the state components.
            h = x(this.height_index);
            v = x(this.velocity_index);

            % Define the value of g(x). 
            xplus = [h; -this.lambda*v];
        end
        
        function inC = flowSetIndicator(this, x)
            % Extract the state components.
            h = x(this.height_index);
            v = x(this.velocity_index);

            % Set 'inC' to 1 if 'x' is in the flow set and to 0 otherwise.
            inC = (h >= 0) || (v >= 0);
        end

        function inD = jumpSetIndicator(this, x)
            % Extract the state components.
            h = x(this.height_index);
            v = x(this.velocity_index);

            % Set 'inD' to 1 if 'x' is in the jump set and to 0 otherwise.
            inD = (h <= 0) && (v <= 0);
        end
    end
end