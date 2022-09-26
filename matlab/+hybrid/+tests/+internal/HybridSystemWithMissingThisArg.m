classdef HybridSystemWithMissingThisArg < HybridSystem
% HybridSystem that is missing the 'this' argument from one of the functions.

    methods 
        
        function xdot = flowMap(x, t, j) %#ok<*STOUT,*INUSD> % Missing 'this' argument
            
        end

        function xplus = jumpMap(this, x, t, j)  
        end

        function C = flowSetIndicator(this, x, t, j) 
        end
        
        function D = jumpSetIndicator(this, x, t, j) 
        end
    end
    
end