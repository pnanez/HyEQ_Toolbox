% Test Class Definition
classdef HybridSystemBuilderTest < matlab.unittest.TestCase
    
    % Test Method Block
    methods (Test)
       
        function testDefaultBuilderProducesTrivalSolution(testCase)
            system = HybridSystemBuilder().build();
            x0 = 0.34;
            sol = system.solve(x0, [0, 1], [0, 10], "silent");
            testCase.assertEqual(sol.t, 0);
            testCase.assertEqual(sol.j, 0);
            testCase.assertEqual(sol.x, x0);
        end
       
        function testFunctionSetters(testCase)
            f = @(x) sin(x);
            g = @(x) -x;
            C_ind = @(x) x <= 0;
            D_ind = @(x) x >= 0;

            builder = HybridSystemBuilder() ...
                            .flowMap(f) ...
                            .jumpMap(g) ...
                            .flowSetIndicator(C_ind) ...
                            .jumpSetIndicator(D_ind);
            system = builder.build();

            % Test the output for the functions for various state values.
            for x=linspace(-10, 10, 23)
                testCase.assertEqual(system.flowMap(x, NaN, NaN), f(x));
                testCase.assertEqual(system.jumpMap(x, NaN, NaN), g(x));
                testCase.assertEqual(system.flowSetIndicator(x, NaN, NaN), C_ind(x));
                testCase.assertEqual(system.jumpSetIndicator(x, NaN, NaN), D_ind(x));
            end
        end

        function testDefaultPriorityIsFlow(testCase)
            builder = HybridSystemBuilder() ...
                            .flowSetIndicator(@(x) 1) ...
                            .jumpSetIndicator(@(x) 1);
            system = builder.build();
            
            sol = system.solve(12, [0, 100], [1, 5], "silent");

            testCase.assertEqual(sol.t(end), 0);
            testCase.assertEqual(sol.j(end), 5);
        end

        function testJumpPriority(testCase)
            builder = HybridSystemBuilder() ...
                            .flowSetIndicator(@(x) 1) ...
                            .jumpSetIndicator(@(x) 1);

            system = builder.build();
            config = HybridSolverConfig("silent").jumpPriority();
            sol = system.solve(12, [0, 100], [1, 5], config);

            testCase.assertEqual(sol.t(end), 0);
            testCase.assertEqual(sol.j(end), 5);
        end

        function testFlowPriority(testCase)
            builder = HybridSystemBuilder() ...
                            .flowMap(@(x) 1)...
                            .flowSetIndicator(@(x) 1) ...
                            .jumpSetIndicator(@(x) 1);
            system = builder.build();
            
            tspan = [0, 100];
            jspan = [1, 5];
            config = HybridSolverConfig("silent").flowPriority();
            sol = system.solve(12, tspan, jspan, config);

            testCase.assertEqual(sol.t(end), 100);
            testCase.assertEqual(sol.j(end), jspan(1));
        end

    end

end