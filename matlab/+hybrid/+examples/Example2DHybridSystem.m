classdef Example2DHybridSystem < HybridSystem
 % Example 6.20 from Hybrid Dynamical Systems textbook by Goebel, 
 % Sanfelice, and Teel.

    methods
        function this = Example2DHybridSystem()
            this = this@HybridSystem(2);
        end

        function xdot = flowMap(this, x) %#ok<INUSL>
            xdot = [x(2); -x(1)];
        end

        function xplus = jumpMap(this, x) %#ok<INUSL> 
            xplus = [x(2); -x(1)];        
        end

        function C = flowSetIndicator(this, x) %#ok<INUSL> 
            C = x(2) >= 0;
        end

        function D = jumpSetIndicator(this, x) %#ok<INUSL>
            D = x(2) <= 0;
        end

    end
end