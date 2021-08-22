classdef SublevelSetsHybridEventLogic < HybridEventLogic
    
    methods
        function [inC, inD] = inFlowOrJump(this, C, D, x, t, j) %#ok<INUSL> "this" unused.
            inC = C(x,t,j) <= 0;
            inD = D(x,t,j) <= 0;
        end
        
        function fh = getOdeEventsFunction(this)
            switch this.priority
                case HybridPriority.JUMP
                    fh = @eventsJumpPriority;
                case HybridPriority.FLOW
                    fh = @eventsFlowPriority;
            end
        end
    end
end

function [value,isterminal,direction] = eventsJumpPriority(x,t,j,C,D)

% Events. 
% (1) Leaving C.
% (2) Entering D. 

% Event (1) is triggered when (x, t, j) leaves C, that is when C(x, t, j)
% moves from negative to positive.
isterminal(1) = 1;
value(1)      = C(x,t,j);
direction(1)  = 1;

% Event (2) is triggered when (x, t, j) enters D, that is when D(x, t, j)
% moves from positive to negative.
isterminal(2) = 1;
value(2)      = D(x,t,j);
direction(2)  = -1;
end

function [value,isterminal,direction] ...
                = eventsFlowPriority(x,t,j,C,D) %#ok<INUSD> "D" is unused.
% An event is triggered when (x, t, j) leaves C, that is when C(x, t, j)
% moves from negative to positive.
isterminal = 1;
value      = C(x,t,j);
direction  = 1;
end