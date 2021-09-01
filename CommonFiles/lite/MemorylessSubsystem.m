classdef MemorylessSubsystem < HybridSubsystem
    
    properties(SetAccess = immutable)
        input_dimension
        state_dimension = 0;
        output_dimension
    end
    
    methods
        function obj = MemorylessSubsystem(input_dimension, output_dimension, output)
            obj.input_dimension = input_dimension;
            obj.output_dimension = output_dimension;
            obj.output = output;
        end
        
        function xdot = flowMap(this, x, u, t, j)   %#ok<INUSD>
           xdot = []; 
        end
        
        % The system does not jump.
        function xplus = jumpMap(this, x, u, t, j)   %#ok<INUSD>
           xplus = []; 
        end

        % The system always flows.
        function C = flowSetIndicator(this, x, u, t, j)  %#ok<INUSD>
            C = 1;
        end

        % The system does not jump.
        function D = jumpSetIndicator(this, x, u, t, j) %#ok<INUSD>
           D = 0; 
        end
    end
    
end