% Test Class Definition
classdef HybridSystemBuilderTest < matlab.unittest.TestCase
    
    % Test Method Block
    methods (Test)
       
        function testDefaultBuilderProducesTrivalSolution(testCase)
            system = HybridSystemBuilder().build();
            x0 = 0.34;
            sol = system.solve(x0, [0, 1], [0, 10], 'silent');
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
            for x=linspace(-10, 10, 5)
                testCase.assertEqual(system.flowMap(x, NaN, NaN), f(x));
                testCase.assertEqual(system.jumpMap(x, NaN, NaN), g(x));
                testCase.assertEqual(system.flowSetIndicator(x, NaN, NaN), C_ind(x));
                testCase.assertEqual(system.jumpSetIndicator(x, NaN, NaN), D_ind(x));
            end
        end

        function testAbbreviatedFunctionSetters(testCase)
            f = @(x) sin(x);
            g = @(x) -x;
            C_ind = @(x) x <= 0;
            D_ind = @(x) x >= 0;

            builder = HybridSystemBuilder() ...
                            .f(f) ...
                            .g(g) ...
                            .C(C_ind) ...
                            .D(D_ind);
            system = builder.build();

            % Test the output for the functions for various state values.
            for x=linspace(-10, 10, 5)
                testCase.assertEqual(system.flowMap(x, NaN, NaN), f(x));
                testCase.assertEqual(system.jumpMap(x, NaN, NaN), g(x));
                testCase.assertEqual(system.flowSetIndicator(x, NaN, NaN), C_ind(x));
                testCase.assertEqual(system.jumpSetIndicator(x, NaN, NaN), D_ind(x));
            end
        end

        function testBadFunctionHandles(testCase)
            hsb = HybridSystemBuilder();   
            testCase.verifyError(@() hsb.flowMap(1), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.jumpMap('hello'), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.flowSetIndicator(@() 1), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.jumpSetIndicator(@(x, t, j, extra) x), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.f(1), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.g('hello'), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.C(@() 1), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.D(@(x, t, j, extra) x), 'Hybrid:InvalidFunction');
            
        end

        function testDefaultStateDimension(testCase)
            sys = HybridSystemBuilder().build();
            testCase.assertEqual(sys.state_dimension, []);
        end

        function testSetStateDimension(testCase)
            sys = HybridSystemBuilder()...
                .stateDimension(4)...
                .build();
            testCase.assertEqual(sys.state_dimension, 4);
        end

%         function 
    end

end