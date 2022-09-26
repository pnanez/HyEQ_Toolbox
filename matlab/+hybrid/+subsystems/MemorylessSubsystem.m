classdef MemorylessSubsystem < HybridSubsystem
% Hybrid subsystems with output that is generated solely from the input (no state values).
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022).    
    methods
        function obj = MemorylessSubsystem(input_dimension, output_dimension, output)
            obj = obj@HybridSubsystem(0, input_dimension, output_dimension, output);
        end
    end
    
    methods(Sealed)
        function xdot = flowMap(this, x, u, t, j) %#ok<INUSD>
           xdot = []; 
        end

        function xplus = jumpMap(this, x, u, t, j) %#ok<INUSD>
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