classdef ZOHController < ControlledHybridSystem

    properties
        sample_time;
    end
    
    properties(SetAccess = immutable)
        state_dimension
        control_dimension
    end
    
    properties(SetAccess = immutable, Hidden)
        zoh_dim
        zoh_indices
        timer_index
    end
        
    methods
        function obj = ZOHController(zoh_dim, sample_time)
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

        function xplus = jump_map(~, ~, u, ~, ~) 
            zoh = u;
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


