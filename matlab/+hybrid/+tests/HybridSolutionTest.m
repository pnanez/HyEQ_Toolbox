classdef HybridSolutionTest < matlab.unittest.TestCase

    methods (Test)

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

        function testTimeVectorsWrongShape(testCase)
            % We make column vectors...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 2);
             % ...then transpose t and j one at a time to make them row vectors.
            testCase.verifyError(@()HybridSolution(t', j, x, 0, 0, [0, 100], [0, 100]), ...
                    'HybridArc:WrongShape')
            testCase.verifyError(@()HybridSolution(t, j', x, 0, 0, [0; 100], [0, 100]), ...
                    'HybridArc:WrongShape')

            % Test with arguments out of order.
            testCase.verifyError(@()HybridSolution(x, t, j, 0, 0, [0; 100], [0, 100]), ...
                    'HybridArc:WrongShape')
        end

    end

end