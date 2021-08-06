classdef HybridSystemTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testFunctionOne(testCase)
            f = @(x, t, j) 0;
            g = @(x, t, j) -x;
            C_indicator = @(x, t, j) 0;
            D_indicator = @(x, t, j) 1;
            system = EZHybridSystem(f, g, C_indicator, D_indicator);
            sol = system.solve(1, [0, 1], [0, 10], "silent");
        end

        function testBouncingBall(testCase)
            system = ExampleBouncingBallHybridSystem();
            sol = system.solve([1; 0], [0, 1], [0, 10], "silent");
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