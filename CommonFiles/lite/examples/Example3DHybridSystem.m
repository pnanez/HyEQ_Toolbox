classdef Example3DHybridSystem < HybridSystem
 % Example 6.20 from Hybrid Dynamical Systems textbook by Goebel, 
 % Sanfelice, and Teel, modified by adding a third state component that is
 % equal to time.

    methods
        function xdot = flowMap(this, x) %#ok<INUSL>
            xdot = [x(2); -x(1); 1];
        end

        function xplus = jumpMap(this, x) %#ok<INUSL> 
            xplus = [x(2); -x(1); x(3)];        
        end

        function C = flowSetIndicator(this, x) %#ok<INUSL> 
            C = x(2) >= 0;
        end

        function D = jumpSetIndicator(this, x) %#ok<INUSL>
            D = x(2) <= 0;
        end

    end
end