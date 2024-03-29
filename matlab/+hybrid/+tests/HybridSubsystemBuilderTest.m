classdef HybridSubsystemBuilderTest < matlab.unittest.TestCase

    methods (Test)

        function testDefaultBuilderWithStateDim1(testCase)
            sys = HybridSubsystemBuilder().build();

            testCase.assertEqual(sys.state_dimension, 1);
            testCase.assertEqual(sys.input_dimension, 0);
            testCase.assertEqual(sys.output_dimension, 1);

            % Functions (g, f, C_indicator, D_indicator) return 0 by default.
            testCase.assertEqual(sys.flowMap(nan, nan, nan, nan), 0);
            testCase.assertEqual(sys.jumpMap(nan, nan, nan, nan), 0);
            testCase.assertEqual(sys.flowSetIndicator(nan, nan, nan, nan), 0);
            testCase.assertEqual(sys.jumpSetIndicator(nan, nan, nan, nan), 0);

            % Output returns full state vector.
            testCase.assertEqual(sys.output(7.6), 7.6);
            testCase.assertEqual(sys.flowOutput(17.6), 17.6);
            testCase.assertEqual(sys.jumpOutput(2.6), 2.6);
        end

        function testOutputDimTruncatesStateIfOutputFunctionsNotSet(testCase)
            sys = HybridSubsystemBuilder()...
                .stateDimension(3)...
                .outputDimension(1).build();
            testCase.assertEqual(sys.output([1.1; 2.2; 3.3]), 1.1);
        end

        function testFullStateOutputIfOutputDimAndOutputFunctionsNotSet(testCase)
            sys = HybridSubsystemBuilder().stateDimension(2).build();
            testCase.assertEqual(sys.output([1.1; 2.2]), [1.1; 2.2]);
        end

        function testBuilderPropertiesNotModifiedIfDefaultsUsed(testCase)
            hsb = HybridSubsystemBuilder();
            hsb.build(); % Call build.
            testCase.assertEmpty(hsb.flow_output_handle);
            testCase.assertEmpty(hsb.jump_output_handle);
            testCase.assertEmpty(hsb.output_dim);
        end

        function testErrorIfOutputDimLargerThanStateDimAndNoOutputFncs(testCase)
            hsb = HybridSubsystemBuilder().stateDimension(1).outputDimension(2);
            testCase.verifyError(@() hsb.build(), 'HybridSubsystemBuilder:InvalidOutput')
            hsb.jumpOutput(@(x) [x; x]);
            testCase.verifyError(@() hsb.build(), 'HybridSubsystemBuilder:InvalidOutput')
            hsb.jumpOutput([]);
            hsb.flowOutput(@(x) [x; x]);
            testCase.verifyError(@() hsb.build(), 'HybridSubsystemBuilder:InvalidOutput')
        end

        function testFunctionSetters(testCase)
            f = @(x) sin(x);
            g = @(x) -x;
            C_ind = @(x) x <= 0;
            D_ind = @(x) x >= 0;
            output = @(x) -x^2;

            b = HybridSubsystemBuilder()...
                .flowMap(f) ...
                .jumpMap(g) ...
                .flowSetIndicator(C_ind) ...
                .jumpSetIndicator(D_ind) ...
                .output(output);
            system = b.build();

            % Test the output for the functions for various state values.
            for x=linspace(-10, 10, 5)
                testCase.assertEqual(system.flowMap(x, NaN, NaN, NaN), f(x));
                testCase.assertEqual(system.jumpMap(x, NaN, NaN, NaN), g(x));
                testCase.assertEqual(system.flowSetIndicator(x, NaN, NaN, NaN), C_ind(x));
                testCase.assertEqual(system.jumpSetIndicator(x, NaN, NaN, NaN), D_ind(x));
                testCase.assertEqual(system.output(x), output(x));
                testCase.assertEqual(system.flowOutput(x), output(x));
                testCase.assertEqual(system.jumpOutput(x), output(x));
            end
        end

        function testFunctionSettersWithAllInputArguments(testCase)
            f = @(x, u, t, j) sin(x - u) + t + j;
            g = @(x, u, t, j) cos(x - u) + t + j;
            C_ind = @(x, u, t, j) sin(x - u) + t - j <= 0;
            D_ind = @(x, u, t, j) sin(x - u) + t - j >= 0;
            output = @(x, u, t, j) -(sin(x - u) + t + j)^2;

            b = HybridSubsystemBuilder()...
                .flowMap(f) ...
                .jumpMap(g) ...
                .flowSetIndicator(C_ind) ...
                .jumpSetIndicator(D_ind) ...
                .output(output);
            system = b.build();

            % Test the output for the functions for various values.
            for vals=rand(4, 10)
                v_cell = num2cell(vals);
                testCase.assertEqual(system.flowMap(v_cell{:}), f(v_cell{:}));
                testCase.assertEqual(system.jumpMap(v_cell{:}), g(v_cell{:}));
                testCase.assertEqual(system.flowSetIndicator(v_cell{:}), C_ind(v_cell{:}));
                testCase.assertEqual(system.jumpSetIndicator(v_cell{:}), D_ind(v_cell{:}));
                testCase.assertEqual(system.output(v_cell{:}), output(v_cell{:}));
                testCase.assertEqual(system.flowOutput(v_cell{:}), output(v_cell{:}));
                testCase.assertEqual(system.jumpOutput(v_cell{:}), output(v_cell{:}));
            end
        end

        function testAbbreviatedFunctionSetters(testCase)
            f = @(x) sin(x);
            g = @(x) -x;
            C_ind = @(x) x <= 0;
            D_ind = @(x) x >= 0;

            builder = HybridSubsystemBuilder() ...
                .f(f) ...
                .g(g) ...
                .C(C_ind) ...
                .D(D_ind);
            system = builder.build();

            % Test the output for the functions for various state values.
            for x=linspace(-10, 10, 5)
                testCase.assertEqual(system.flowMap(x, NaN, NaN, NaN), f(x));
                testCase.assertEqual(system.jumpMap(x, NaN, NaN, NaN), g(x));
                testCase.assertEqual(system.flowSetIndicator(x, NaN, NaN, NaN), C_ind(x));
                testCase.assertEqual(system.jumpSetIndicator(x, NaN, NaN, NaN), D_ind(x));
            end
        end

        function testBadFunctionHandles(testCase)
            hsb = HybridSubsystemBuilder();
            testCase.verifyError(@() hsb.flowMap(1), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.jumpMap('hello'), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.flowSetIndicator(@() 1), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.jumpSetIndicator(@(x, u, t, j, extra) x), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.output(@(x, u, t, j, extra) x), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.f(1), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.g('hello'), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.C(@() 1), 'Hybrid:InvalidFunction');
            testCase.verifyError(@() hsb.D(@(x, u, t, j, extra) x), 'Hybrid:InvalidFunction');
        end

        function testSetDimensions(testCase)
            sys = HybridSubsystemBuilder()...
                .stateDimension(3)...
                .inputDimension(1)...
                .outputDimension(2)...
                .build();
            testCase.assertEqual(sys.state_dimension, 3);
            testCase.assertEqual(sys.input_dimension, 1);
            testCase.assertEqual(sys.output_dimension, 2);
        end

        function testSetDimensionsAbbreviations(testCase)
            sys = HybridSubsystemBuilder()...
                .stateDim(3)...
                .inputDim(1)...
                .outputDim(2)...
                .build();
            testCase.assertEqual(sys.state_dimension, 3);
            testCase.assertEqual(sys.input_dimension, 1);
            testCase.assertEqual(sys.output_dimension, 2);
        end

        function testBadDimensions(testCase)
            hsb = HybridSubsystemBuilder();
            testCase.verifyError(@() hsb.stateDimension('string'), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.inputDim(3.14), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() hsb.outputDim(-2), 'Hybrid:InvalidArgument');
        end

    end

end