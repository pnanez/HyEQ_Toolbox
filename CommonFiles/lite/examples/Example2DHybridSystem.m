classdef Example2DHybridSystem < HybridSystem
 % Example 6.20 from Hybrid Dynamical Systems textbook by Goebel, 
 % Sanfelice, and Teel.

    methods
        function xdot = flow_map(this, x) %#ok<INUSL>
            xdot = [x(2); -x(1)];
        end


        function xplus = jump_map(this, x) %#ok<INUSL> 
            xplus = [x(2); -x(1)];        
        end

        function C = flow_set_indicator(this, x) %#ok<INUSL> 
            C = x(2) >= 0;
        end

        function D = jump_set_indicator(this, x) %#ok<INUSL>
            D = x(2) <= 0;
        end

    end
end