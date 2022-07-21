classdef BouncingBallWithRandomPenetration < HybridSystem
    
    properties
       bb_sys = hybrid.examples.BouncingBall();
       rand_times = []
    end
    
    methods 
%         
%         function obj = BouncingBallWithRandomPenetration()
%         end
%         
        function xdot = flowMap(this, x, t, j)  %#ok<*INUSD> (Surpress warnings in this file)
            C = 1; %% this.bb_sys.flowSetIndicator(x);
            D = this.bb_sys.jumpSetIndicator(x);
            taudot = C && D;
            xdot = [this.bb_sys.flowMap(x); taudot];
        end

        function xplus = jumpMap(this, x, t, j)
            xplus = [this.bb_sys.jumpMap(x); 0];
        end

        function C = flowSetIndicator(this, x, t, j) 
            tau = x(3);
            C = tau <= this.rand_times(j);
        end
        
        function D = jumpSetIndicator(this, x, t, j)
            tau = x(3);
            D = tau >= this.rand_times(j);            
        end

        function sol = solve(this, x0, tspan, jspan, varargin)
            if numel(jspan) ~= 1
                assert(jspan(1) == 1, 'j must start at 1 for this class.')
            end
            x0 = [x0; 0]; % Append timer variable.
            this.rand_times = 0.4*rand(jspan(end) + 1);
            sol = this.solve@HybridSystem(x0, tspan, jspan, varargin{:});
        end
    end
    
end