classdef ExampleNonautonomousHybridSystem < HybridSystem
% Example 6.20 from Hybrid Dynamical Systems textbook by Goebel, 
% Sanfelice, and Teel.
% 
% Added in HyEQ Toolbox version 3.0 

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022). 
    methods
        function xdot = flowMap(this, x, t, j) %#ok<INUSL>
            xdot = j;
        end

        function xplus = jumpMap(this, x, t) %#ok<INUSL>
            xplus = 0;        
        end

        function C = flowSetIndicator(this, x) %#ok<INUSD> 
            C = 1;
        end

        function D = jumpSetIndicator(this, x, t) %#ok<INUSL>
            D = x >= 1+t/2;
        end

    end
end