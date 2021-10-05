classdef HybridSolutionTest < matlab.unittest.TestCase
    
    properties
        dummySystem = HybridSystemBuilder().build();
    end

    methods (Test)

        function testWithoutOptionalArguments(testCase)
            n = 5;
            t = linspace(0, 10, n)';
            j = (1:n)';
            x = rand(n, 3);
            sol = HybridSolution(t, j, x);
            testCase.assertEqual(sol.t, t)
            testCase.assertEqual(sol.j, j)
            testCase.assertEqual(sol.x, x)
            testCase.assertEqual(sol.termination_cause, TerminationCause.UNDETERMINED)
        end
        
        %%%%%%%%%%%%%%%% Test jump_times and flow_lengths %%%%%%%%%%%%%%%%%
        % Thorough testing of jump time and flow length calculations are in
        % jumpTimesTest.m and flowLengthTest.m. The tests here simply
        % verify that the HybridSolution class is wired up correctly.
        function testJumpTimes(testCase)
            t = linspace(0, 12, 5)'; % Not important
            j = [0; 1; 1; 1; 2]; % Jump at indices 1 and 4.
            x = NaN(5, 1); % Not important
            sol = HybridSolution(t, j, x);
            testCase.assertEqual(sol.jump_times, hybrid.internal.jumpTimes(t, j))
        end

        function testFlowLengths(testCase)
            t = [0; 0.5; 0.5; 2; 3; 3; 4];
            j = [0;   0;   1; 1; 1; 2; 2];
            x = NaN(7, 1); % Not important
            sol = HybridSolution(t, j, x);
            testCase.assertEqual(sol.flow_lengths, [0.5; 2.5; 1])
            testCase.assertEqual(sol.shortest_flow_length, 0.5)
        end

        function testSolverConfigIsImmutable(testCase)
            t = [0; 0.5; 0.5; 2; 3; 3; 4];
            j = [0;   0;   1; 1; 1; 2; 2];
            x = NaN(7, 1); % Not important
            C = 1;
            D = 1;
            tspan = [0 1];
            jspan = [0 1];
            config = HybridSolverConfig();
            config.odeSolver('ode23');
            sol = HybridSolution(t, j, x, C, D, tspan, jspan, config);
            config.odeSolver('ode45');
            testCase.assertEqual(sol.solver_config.ode_solver, 'ode23');
        end

        function testInconsistenVectorLengths(testCase)
            % We define vectors that are all the same length...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 1);
            % ... then truncate them one at a time to make them not match.
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t(1:2), j, x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t, j(1:2), x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t, j, x(1:2), [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
        end

        function testTimeVectorsOfWrongShape(testCase)
            % We make column vectors...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 1);
             % ...then transpose t and j one at a time to make them row vectors.
            testCase.verifyError(@()HybridSolution(t', j, x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(t, j', x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
        end

    end

end