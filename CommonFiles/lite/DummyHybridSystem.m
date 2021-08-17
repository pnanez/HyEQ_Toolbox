classdef DummyHybridSystem < HybridSystem
% The DummyHybridSystem class is provided to use as a default value for classes that have
% HybridSystem property values. It's also useful as a template for creating
% new HybridSystem subclasses.

    methods 
        
        function xdot = flow_map(this, x, t, j)  %#ok<*INUSD> (Surpress warnings in this file)
            
        end

        function xplus = jump_map(this, x, t, j)  
            
        end

        function C = flow_set_indicator(this, x, t, j) 
        
        end
        
        function D = jump_set_indicator(this, x, t, j)
            
        end
    end
    
end