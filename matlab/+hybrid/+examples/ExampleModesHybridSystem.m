classdef ExampleModesHybridSystem < HybridSystem
 % Example 6.20 from Hybrid Dynamical Systems textbook by Goebel, 
 % Sanfelice, and Teel, modified by adding a third state component that is
 % equal to time.

    properties
        A0 = [-1, 2; -2, -1];
        A1 = [-1, 0; 0, -1];
    end

    methods
        function xdot = flowMap(this, x)
            z = x(1:2);
            q = x(3);
            switch q
                case 0
                    xdot = [this.A0*z; 0];
                case 1
                    xdot = [this.A1*z; 0];
            end
        end

        function xplus = jumpMap(this, x) %#ok<INUSL> 
            z = x(1:2);
            q = x(3);
            xplus = [z; 1-q]; 
        end

        function C = flowSetIndicator(this, x) %#ok<INUSD> 
            C = 1;
        end

        function D = jumpSetIndicator(this, x) %#ok<INUSL>
            z = x(1:2);
            q = x(3);
            switch q
                case 0
                    D = mod(floor(sqrt(norm(z))), 2);
                case 1
                    D = ~mod(floor(sqrt(norm(z))), 2);
            end

        end

    end
end