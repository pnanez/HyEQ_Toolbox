classdef ExampleNonautonomousHybridSystem < HybridSystem
 % Example 6.20 from Hybrid Dynamical Systems textbook by Goebel, 
 % Sanfelice, and Teel.

    methods
        function xdot = flow_map(this, x, t, j) %#ok<INUSL>
            xdot = j;
        end

        function xplus = jump_map(this, x, t) %#ok<INUSL>
            xplus = 0;        
        end

        function C = flow_set_indicator(this, x) %#ok<INUSD> 
            C = 1;
        end

        function D = jump_set_indicator(this, x, t) %#ok<INUSL>
            D = x >= 1+t/2;
        end

    end
end