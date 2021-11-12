classdef ZeroOrderHold < HybridSubsystem
% Periodically samples the input to generate a continuous-time output using constant interpolation between sample times. 

    properties
        sample_time;
    end
    
    properties(SetAccess = immutable, GetAccess = private)
        zoh_dim
        zoh_indices
        timer_index
    end
        
    methods
        function obj = ZeroOrderHold(zoh_dim, sample_time)
            zoh_dim = int32(zoh_dim);
            state_dim = zoh_dim + 1;
            input_dim = zoh_dim;
            output_dim = zoh_dim;
            output = @(x) x(1:zoh_dim);
            obj = obj@HybridSubsystem(state_dim, input_dim, output_dim, output);
            obj.zoh_dim = zoh_dim;
            obj.zoh_indices = 1:zoh_dim;
            obj.timer_index = zoh_dim + 1;
            obj.sample_time = sample_time;
        end
        
        function xdot = flowMap(this, ~, ~, ~, ~)  
            zoh_dot = zeros(this.zoh_dim, 1);
            xdot = [zoh_dot; 1];
        end

        function xplus = jumpMap(~, ~, u, ~, ~) 
            zoh = u;
            xplus = [zoh; 0];
        end

        function C = flowSetIndicator(this, x, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        function D = jumpSetIndicator(this, x, ~, ~, ~)
            timer = x(this.timer_index);
            D = timer >= this.sample_time;
        end
        
        function x0 = initial(this)
            x0 = [zeros(this.input_dimension, 1); this.sample_time];
        end
    end
    
end


