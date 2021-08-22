classdef IndicatorFunctionHybridEventLogic < HybridEventLogic
    
    methods
        
        function [inC, inD] = inFlowOrJump(this, C, D, x, t, j) %#ok<INUSL> "this" unused.
            inC = C(x,t,j);
            inD = D(x,t,j);
        end
        
        function fh = getOdeEventsFunction(this)
            switch this.priority
                case HybridPriority.JUMP
                   fh = @zeroEventsJumpPriority;
                case HybridPriority.FLOW
                   fh = @zeroEventsFlowPriority;
            end
        end
    end
end

function [value,isterminal,direction] = zeroEventsJumpPriority(x,t,j,C,D)
% Stop if (x, t, j) is in D or not in C. 
stop = D(x,t,j) || ~C(x,t,j);

isterminal = 1;
value = 1 - stop; % Events happen when value == 0.
direction = -1;

end

function [value,isterminal,direction] = zeroEventsFlowPriority(x,t,j,C,D) %#ok<INUSD> "D" is unused.
% ZEROEVENTS Creates an event to terminate the ode solver when the state
% leaves C or (if rule == 1) when the state enters D .

% Stop if (x, t, j) is not in C. 
stop = ~C(x,t,j);

isterminal = 1;
value = 1 - stop; % Events happen when value == 0.
direction = -1;

end