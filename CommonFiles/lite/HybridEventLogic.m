classdef HybridEventLogic < handle
    
    properties
        priority = HybridPriority.JUMP
    end
    
    methods(Abstract)
        
        [inC, inD] = inFlowOrJump(this, C, D, x, t, j)
        
        % Returns a function handle with the following signiture:
        %   [value,isterminal,direction] = zeroevents(x,t,j,C,D)
        % This function is used by the ODE solver to determine when to
        % terminate each interval of flow.
        fh = getOdeEventsFunction(this)
    end
    
    methods
        
        function obj = HybridEventLogic(priority)
            if ~exist("priority", "var")
                priority = HybridPriority.default();
            end
            obj.priority = HybridPriority(priority);
        end
        
        function [doFlow, doJump] = doFlowOrJump(this, inC, inD)
            switch this.priority
                case HybridPriority.JUMP
                    doFlow = inC && ~inD;
                    doJump = inD;
                case HybridPriority.FLOW
                    doFlow = inC;
                    doJump = inD & ~inC;
            end
            assert(~(doFlow && doJump), ...
                "doFlow and doJump should not both be true.")
        end 
    end
    
end