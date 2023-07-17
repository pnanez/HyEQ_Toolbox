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
            [t, ~, ~] = HyEQsolver(f, g, C, D, x0, tspan, jspan); % 'rule' not specified.
            
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
            rule = 1; % jump priority
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
            
            % A spurious jump appears to occur before the last entry.
            testCase.assertEqual(j(end-1), 1) % This assertion is OK
            testCase.assertEqual(j(end), 1) % This assertion fails

            % Because f(x) = 0, the value of x should be constant. 
            testCase.assertEqual(x(end), x(1))
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
            
            testCase.assertEqual(j(end-1), 1)
        end

        function testFlowPriorityFromBoundaryOfC(testCase)
            x0 = 1.5;
            tspan = [0, 5];
            jspan = [0, 1];
            rule = 2;
            f = @(x) 1;
            g = @(x) 0;
            C = @(x) x <= 1.5;
            D = @(x) 1;
            [t, j, x] = HyEQsolver(f, g, C, D, x0, tspan, jspan, rule);   
            sol = HybridSolution(t, j, x, C, D, tspan, jspan);

            % Check that x does not increase above 1.5.
            testCase.assertLessThanOrEqual(sol.x, 1.500001)
            % Check that the system jumps when it realizes that it cannot flow
            % from x=1.5.
            testCase.assertEqual(sol.j(end), 1);
        end
        
        function testTrivialSolution(testCase)
            x0 = 1.5;
            tspan = [3, 5];
            jspan = [4, 5];
            rule = 2;
            f = @(x) x;
            g = @(x) 0;
            C = @(x) 0;
            D = @(x) 0;
            [t, j, x] = HyEQsolver(f, g, C, D, x0, tspan, jspan, rule);
            
            sol = HybridSolution(t, j, x, C, D, tspan, jspan);
            
            testCase.assertEqual(sol.x, x0')
            testCase.assertEqual(sol.t, tspan(1))
            testCase.assertEqual(sol.j, jspan(1))
        end

        function testBouncingBallStaysAboveGround(testCase)
            import hybrid.tests.internal.*
            bounce_coeff = 0.9;
            gravity = 9.8;
            
            tspan = [0, 1];
            jspan = [0, 10];
            x0 = [ -1.4492455619629799e-37; -3.2736386525349252e-18];
            f = @(x)[x(2); -gravity];
            g = @(x)[x(1); -bounce_coeff*x(2)];
            C = @(x) x(1) >= 0 || x(2) >= 0;
            D = @(x) x(1) <= 0 && x(2) <= 0;
            
            options = odeset('Refine', 1);
            [t, j, x] = HyEQsolver(f, g, C, D, ...
                                x0, tspan, jspan, 1, options, [], [], 'silent');
                            
            sol = HybridSolution(t, j, x, C, D, tspan, jspan);
            [~, ~, C_vals, D_vals] = HybridSystem(f, g, C, D).generateFGCD(sol);

            verifyHybridSolutionDomain(sol.t, sol.j, C_vals, D_vals)
            testCase.assertGreaterThanOrEqual(x(:, 1), -1e-7)
        end

        function testValidityOfHybridSolutionDomain(testCase) %#ok<MANU>
            f = @(x)[x(2); -9.8];
            g = @(x)[x(1); -0.9*x(2)];
            C = @(x) 1;
            D = @(x) x(1) <= 0 && x(2) <= 0;
            tspan = [0, 10];
            jspan = [0, 10];
            x0 = [1; 0];
            verifySolver(f, g, C, D, x0, tspan, jspan)
        end
        
        function test3ArgFunctions(testCase) %#ok<MANU>
            f = @(x, t, j) 0.2*(x + 2*t + 3*j); % 
            g = @(x, t, j) 0.1*(x + 2*t + 3*j);
            C = @(x, t, j) norm(x) + j + t <= 2;
            D = @(x, t, j) norm(x) + j + t >= 2;
            tspan = [0, 10];
            jspan = [0, 10];
            x0 = [1; 0];
            verifySolver(f, g, C, D, x0, tspan, jspan)
        end
        
        function test2ArgFunctions(testCase) %#ok<MANU>
            f = @(x, t) 0.2*(x + 2*t);
            g = @(x, t) 0.1*(x + 2*t);
            C = @(x, t) norm(x) + t <= 2;
            D = @(x, t) norm(x) + t >= 2;
            tspan = [0, 10];
            jspan = [0, 10];
            x0 = [1; 0];
            verifySolver(f, g, C, D, x0, tspan, jspan)
        end
        
        function test1ArgFunctions(testCase) %#ok<MANU>
            f = @(x) x;
            g = @(x) 0.1*x;
            C = @(x) norm(x) <= 2;
            D = @(x) norm(x) >= 2;
            tspan = [0, 10];
            jspan = [0, 10];
            x0 = [1; 0];
            verifySolver(f, g, C, D, x0, tspan, jspan)
        end
        
        function testMixedArgFunctions(testCase) %#ok<MANU>
            f = @(x, t) x - t;
            g = @(x, t, j) 0.1*x + sin(j)*cos(t);
            C = @(x) norm(x) <= 2;
            D = @(x, t) t * norm(x) >= 2;
            tspan = [0, 10];
            jspan = [0, 10];
            x0 = [1; 0];
            verifySolver(f, g, C, D, x0, tspan, jspan)
        end
        
        function testFiniteTimeBlowup(testCase)
            f = @(x) x.^2; % Goes to infinity.
            sys = HybridSystemBuilder()...
                .flowMap(f)...
                .flowSetIndicator(@(x) 1)...
                .build();
            warning('off') % Hide expected warnings.
            sol = sys.solve([0; 1; 1; 0], [0, 400], [0, 1]);
            warning('on') % Renable warnings.
            testCase.assertEqual(sol.termination_cause, ...
                hybrid.TerminationCause.STATE_IS_NAN);
        end
        
        function testErrorIfX0NotValid(testCase)
            f = @(x, t) x - t;
            g = @(x, t, j) 0.1*x + sin(j)*cos(t);
            C = @(x) norm(x) <= 2;
            D = @(x, t) t * norm(x) >= 2;
            tspan = [0, 10];
            jspan = [0, 10];

            % Test "not numeric"
            x0 = struct('This',' is not numeric');
            testCase.assertError( ...
                @() HyEQsolver(f, g, C, D, x0, tspan, jspan), ...
                'HyEQsolver:x0NotNumeric')

            % Test "not a vector"
            x0 = ones(2, 2);
            testCase.assertError( ...
                @() HyEQsolver(f, g, C, D, x0, tspan, jspan), ...
                'HyEQsolver:x0NotAVector')

            % Test "is NaN"
            x0 = NaN(2, 1);
            testCase.assertError( ...
                @() HyEQsolver(f, g, C, D, x0, tspan, jspan), ...
                'HyEQsolver:x0isNaN')
        end
    end
end

function verifySolver(f, g, C, D, x0, tspan, jspan, priority)
import hybrid.tests.internal.*
if ~exist('priority', 'var')
    priority = hybrid.Priority.default();
end
% We enforce a small maximum step so that a first-order approximation of
% dxdt is close to f(x), allowing us to verify they are almost equal.
options = odeset('MaxStep', 0.01); 
[t, j, x] = HyEQsolver(f, g, C, D, x0, tspan, jspan, priority, options);
sol = HybridSolution(t, j, x, C, D, tspan, jspan);
[f_vals, g_vals, C_vals, D_vals] = HybridSystem(f, g, C, D).generateFGCD(sol);
verifyHybridSolutionDomain(sol.t, sol.j, C_vals, D_vals);
checkHybridSolution(sol, f_vals, g_vals, C_vals, D_vals, priority);
end


