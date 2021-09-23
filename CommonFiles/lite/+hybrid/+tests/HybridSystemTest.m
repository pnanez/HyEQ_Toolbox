classdef HybridSystemTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testOnlyJumps(testCase)
            f = @(x, t, j) 0;
            g = @(x, t, j) -x;
            C_indicator = @(x, t, j) 0;
            D_indicator = @(x, t, j) 1;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            sol = system.solve(1, [0, 1], [0, 10], 'silent');
            testCase.assertTrue(all(sol.x(1:2:end) ==  1))
            testCase.assertTrue(all(sol.x(2:2:end) == -1))
        end
        
        function testOnlyFlows(testCase)
            f = @(x, t, j) 2;
            g = @(x, t, j) NaN;
            C_indicator = @(x, t, j) 1;
            D_indicator = @(x, t, j) 0;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            sol = system.solve(0, [0, 1], [0, 10], 'silent');
            testCase.assertEqual(sol.x, 2*sol.t, 'AbsTol', 1e-8)
        end

        function testBouncingBall(testCase)
            system = ExampleBouncingBallHybridSystem();
            sol = system.solve([1; 0], [0, 1], [0, 10], 'silent');
        end

        %%%%%%%%%%%%%%%% Test JumpTime calculations %%%%%%%%%%%%%%%%%
        
%         function testSingleJumpTime(testCase)
%             t = linspace(0, 12, 3)'; % Values not important
%             j = [0; 1; 1]; % Jump at second index
%             x = zeros(3, 1); % Not important
%             sol = HybridSolution([], t, j, x, [0, 100], [0, 100]);
%             testCase.assertEqual(sol.jump_times, t(2))
%         end

    end

end