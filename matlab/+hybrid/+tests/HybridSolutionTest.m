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

        function testInterpolationConstantxNoJumps(testCase)
            x = ones(10,1);
            t = linspace(0,9,10)';
            j = zeros(10,1);
            t_grid = linspace(0,9);
            sol = HybridArc(t, j, x);
            interpolated_sol = sol.interpolate(t_grid);
            testCase.assertEqual(interpolated_sol, ones(size(interpolated_sol)))
        end

        function testInterpolationConstantxOneJump(testCase)
            x = ones(10,1);
            t = [0; 1; 2; 3; 4; 4; 5; 6; 7; 8]; % jump at t=4
            j = [0; 0; 0; 0; 0; 1; 1; 1; 1; 1];
            t_grid = linspace(0,8);
            sol = HybridArc(t,j,x);
            interpolated_sol = sol.interpolate(t_grid);
            testCase.assertEqual(interpolated_sol, ones(size(interpolated_sol)))
        end

        function testInterpolationLinearxNoJump(testCase)
            x = linspace(0,100,51)';
            t = linspace(0,50,51)';
            j = zeros(51,1);
            t_grid = linspace(0,50,101);
            sol = HybridArc(t,j,x);
            interpolated_sol = sol.interpolate(t_grid);
            testCase.assertEqual(interpolated_sol, 2*t_grid) % slope of 2
        end

        function testInterpolationLinearxOneJump(testCase)
            x = [linspace(0,50,26)'; linspace(0,45,10)'];
            t = [linspace(0,25,26)'; linspace(25,34,10)'];
            j = [zeros(26,1); ones(10,1)];
            t_grid = linspace(0,34,18);
            sol = HybridArc(t,j,x);
            interpolated_sol = sol.interpolate(t_grid);
            testCase.assertEqual(interpolated_sol(:,13), 2 * t_grid(:,13)) % slope of 2
            testCase.assertEqual(interpolated_sol(:, 14:end), 5 * t_grid(:, 14:end) - 25*5) % slope of 5
        end

    end

end