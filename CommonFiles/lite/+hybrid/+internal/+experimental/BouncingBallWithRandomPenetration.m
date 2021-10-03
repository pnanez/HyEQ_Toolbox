classdef BouncingBallWithRandomPenetration < HybridSystem
    
    properties 
       getRandT
       bb_sys = ExampleBouncingBallHybridSystem();
    end
    
    methods 
        
        function obj = BouncingBallWithRandomPenetration()
            rand_times = {};
            function T = getRandT(j)
                if length(rand_times) < j || isempty(rand_times{j})
                    rand_times{j} = rand(1);
                end
                T = rand_times{j};
            end
            obj.getRandT = @getRandT;
        end
        
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
            C = tau <= this.getRandT(j);
        end
        
        function D = jumpSetIndicator(this, x, t, j)
            tau = x(3);
            D = tau >= this.getRandT(j);            
        end
    end
    
end