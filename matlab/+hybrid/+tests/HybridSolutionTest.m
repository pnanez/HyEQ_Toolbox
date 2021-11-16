classdef HybridSolutionTest < matlab.unittest.TestCase

    methods (Test)
        
        %%%%%%%%%%%%%%%% Test jump_times and flow_lengths %%%%%%%%%%%%%%%%%
        % Thorough testing of jump time and flow length calculations are in
        % jumpTimesTest.m and flowLengthTest.m. The tests here simply
        % verify that the HybridSolution class is wired up correctly.
        function testJumpTimes(testCase)
            t = linspace(0, 12, 5)'; % Not important
            j = [0; 1; 1; 1; 2]; % Jump at indices 1 and 4.
            x = NaN(5, 1); % Not important
            sol = HybridArc(t, j, x);
            testCase.assertEqual(sol.jump_times, hybrid.internal.jumpTimes(t, j))
            testCase.assertEqual(sol.is_jump_start, [1; 0; 0; 1; 0])
        end

        function testFlowLengths(testCase)
            t = [0; 0.5; 0.5; 2; 3; 3; 4];
            j = [0;   0;   1; 1; 1; 2; 2];
            x = NaN(7, 1); % Not important
            sol = HybridArc(t, j, x);
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
            
            % Subsequent changes to the odeSolver are not reflected in
            % sol.solver_config.ode_solver.
            config.odeSolver('ode45');
            testCase.assertEqual(sol.solver_config.ode_solver, 'ode23');
        end

        function testInconsistentVectorLengths(testCase)
            % We define vectors that are all the same length...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 1);
            % ... then truncate them one at a time to make them not match.
            testCase.verifyError(@()HybridArc(t(1:2), j, x),...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridArc(t, j(1:2), x), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridArc(t, j, x(1:2)), ...
                    'HybridSolution:WrongShape')
        end

        function testTimeVectorsWrongShape(testCase)
            % We make column vectors...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 1);
             % ...then transpose t and j one at a time to make them row vectors.
            testCase.verifyError(@()HybridSolution(t', j, x, 0, 0, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(t, j', x, 0, 0, [0; 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
        end

        function testTransform(testCase)
            t = linspace(0, 10)';
            j = zeros(100, 1);
            x = rand(100, 3);

            sol = HybridArc(t, j, x);
            transformed_sol = sol.transform(@(x) [x(1); -x(2)]);
            testCase.assertEqual(transformed_sol.t, t)
            testCase.assertEqual(transformed_sol.j, j)
            testCase.assertEqual(transformed_sol.x, [x(:, 1), -x(:, 2)])
        end

        function testSlice(testCase)
            t = linspace(0, 10)';
            j = zeros(100, 1);
            x = rand(100, 3);

            sol = HybridArc(t, j, x);
            sliced_sol = sol.slice([1, 3]);
            testCase.assertEqual(sliced_sol.t, t)
            testCase.assertEqual(sliced_sol.j, j)
            testCase.assertEqual(sliced_sol.x, [x(:, 1), x(:, 3)])
        end

        function testRestrictT(testCase)
            t = [0; 1; 2; 2];
            j = [0; 0; 0; 1];
            x = [0.1, 0.2;
                 1.1, 1.2;
                 2.1, 2.2;
                 3.1, 3.2;];
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictT([1, 2]);
            testCase.assertEqual(restricted_sol.t, [1; 2; 2])
            testCase.assertEqual(restricted_sol.j, [0; 0; 1])
            testCase.assertEqual(restricted_sol.x, [1.1, 1.2; ...
                                                    2.1, 2.2; ...
                                                    3.1, 3.2])
        end

        function testRestrictT_NoOverlap(testCase)
            t = [0; 1];
            j = [0; 0];
            x = [0.1, 0.2;
                 1.1, 1.2];
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictT([10, 11]);
            testCase.assertEqual(restricted_sol.t, double.empty(0, 1))
            testCase.assertEqual(restricted_sol.j, double.empty(0, 1))
            testCase.assertEqual(restricted_sol.x, double.empty(0, 2))
        end

        function testRestrictJ_span(testCase)
            t = [0; 1; 1; 2; 2; 3; 3];
            j = [0; 0; 1; 1; 2; 2; 3];
            x = rand(length(t), 2);
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictJ([1, 2]);
            testCase.assertEqual(restricted_sol.t, [1; 2; 2; 3])
            testCase.assertEqual(restricted_sol.j, [1; 1; 2; 2])
            testCase.assertEqual(restricted_sol.x, x(3:6, :))
        end

        function testRestrictJ_single(testCase)
            t = [0; 1; 1; 2; 2; 3; 3];
            j = [0; 0; 1; 1; 2; 2; 3];
            x = rand(length(t), 2);
            sol = HybridArc(t, j, x);
            restricted_sol = sol.restrictJ(2);
            testCase.assertEqual(restricted_sol.t, [2; 3])
            testCase.assertEqual(restricted_sol.j, [2; 2])
            testCase.assertEqual(restricted_sol.x, x(5:6, :))
        end

    end

end