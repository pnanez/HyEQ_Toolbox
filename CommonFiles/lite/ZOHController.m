classdef ZOHController < ControlledHybridSystem

    properties
        sample_time;
        kappa; % Feedback function
    end
    
    properties(SetAccess = immutable)
        zoh_dim
        zoh_indices;
        timer_index;
    end
    
    properties
        state_dimension
        control_dimension
    end
        
    methods
        function obj = ZOHController(zoh_dim, kappa, sample_time)
            obj.kappa = kappa;
            obj.sample_time = sample_time;
            obj.zoh_dim = zoh_dim;
            obj.zoh_indices = 1:zoh_dim;
            obj.timer_index = zoh_dim + 1;
            obj.state_dimension = zoh_dim + 1;
            obj.control_dimension = zoh_dim;
        end
        
        function xdot = flow_map(this, ~, ~, ~, ~)  
            zoh_dot = zeros(this.zoh_dim, 1);
            xdot = [zoh_dot; 1];
        end

        function xplus = jump_map(this, ~, u, ~, ~) 
            zoh = this.kappa(u);
            xplus = [zoh; 0];
        end

        function C = flow_set_indicator(this, x, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        function D = jump_set_indicator(this, x, ~, ~, ~)
            timer = x(this.timer_index);
            D = timer >= this.sample_time;
        end
    end
    
end


