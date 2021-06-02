classdef HyEQsolverTest < matlab.unittest.TestCase
    
    methods (Test)
     
        function testDefaultPriorityIsJumps(testCase)
            f = @(x) 1e5; % This shouldn't be used.
            g = @(x) 0; 
            C = @(x) 1;
            D = @(x) 1;
            x0 = 1;
            tspan = [0, 100];
            jspan = [1, 100];
            [t, ~, ~] = HyEQsolver(f, g, C, D, x0, tspan, jspan); % "rule" not specified.
            
            testCase.assertEqual(t(end), 0)
        end

        function testContinuousTimeConstantWhenPriorityIsJumps(testCase)
            f = @(x) 1e5; % This shouldn't be used.
            g = @(x) 0; 
            C = @(x) 1;
            D = @(x) 1;
            x0 = 1;
            tspan = [0, 100];
            jspan = [1, 100];
            rule = 1; % flow priority
            [t, ~, x] = HyEQsolver(f, g, C, D, x0, tspan, jspan, rule);
            
            testCase.assertEqual(t(end), 0) % This assertion is OK
            testCase.assertEqual(x(end), g(x(1))) % This assertion is OK
        end

        function testDiscreteTimeConstantWhenPriorityIsFlows(testCase)
            f = @(x) 0;
            g = @(x) 23; % This shouldn't be used.
            C = @(x) 1;
            D = @(x) 1;
            x0 = 1;
            tspan = [0, 100];
            jspan = [1, 100];
            rule = 2; % flow priority
            [~, j, x] = HyEQsolver(f, g, C, D, x0, tspan, jspan, rule);
            
            % A suprious jump appears to occur before the last entry.
            testCase.assertEqual(j(end-1), 1) % This assertion is OK
            testCase.assertEqual(j(end), 1) % This assertion fails

            % Because f(x) = 0, the value of x should be constant, but it 
            % is actually is reset to 0. 
            testCase.assertEqual(x(end-1), x(1)) % This assertion is OK
            testCase.assertEqual(x(end), x(1)) % This assertion fails
        end

        function testNonAutonomous(testCase)
            f = @(t, j, x) x^2;
            g = @(t, j, x) 0;
            C = @(t, j, x) 1;
            D = @(t, j, x) 1;
            x0 = 1;
            tspan = [0, 100];
            jspan = [1, 100];
            rule = 2; % flow priority
            [~, j, ~] = HyEQsolver(f, g, C, D, x0, tspan, jspan, rule);
            
            testCase.assertEqual(j(end-1), 1) % This assertion is OK
        end

        function testSolutionsWithFlowPriorityOnlyFlowInC(testCase)
            x0 = 1.5;
            tspan = [0, 5];
            jspan = [0, 5];
            rule = 2;
            f = @(x) x;
            g = @(x) 0;
            C = @(x) x <= 1.5;
            D = @(x) 1;
            [~, ~, x] = HyEQsolver(f, g, C, D, x0, tspan, jspan, rule);
            testCase.assertLessThanOrEqual(x, 1.5)
        end

        function testBouncingBallStaysAboveGround(testCase)
            bounce_coeff = 0.9;
            gravity = 9.8;

            tspan = [0, 100];
            jspan = [0, 1000];
            x0 = [1; 0];

            f = @(x)[x(2); -gravity];
            g = @(x)[x(1); -bounce_coeff*x(2)];
            C = @(x) 1;
            D = @(x) x(1) <= 0 && x(2) <= 0;
            [~, ~, x] = HyEQsolver(f, g, C, D, ...
                                x0, tspan, jspan);

            testCase.assertGreaterThanOrEqual(x(:, 1), 0)
        end

    end

end