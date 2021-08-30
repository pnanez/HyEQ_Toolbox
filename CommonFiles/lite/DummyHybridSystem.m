classdef DummyHybridSystem < HybridSystem
% The DummyHybridSystem class is provided to use as a default value for classes that have
% HybridSystem property values. It's also useful as a template for creating
% new HybridSystem subclasses.

    methods 
        
        function xdot = flowMap(this, x, t, j)  %#ok<*INUSD> (Surpress warnings in this file)
            
        end

        function xplus = jumpMap(this, x, t, j)  
            
        end

        function C = flowSetIndicator(this, x, t, j) 
        
        end
        
        function D = jumpSetIndicator(this, x, t, j)
            
        end
    end
    
end