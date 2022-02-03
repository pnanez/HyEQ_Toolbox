classdef HybridSubsystemTest < matlab.unittest.TestCase
    
    methods (Test)
      
        function testGenerateFGCD(testCase)
            import hybrid.tests.internal.*;
            n_timesteps = 12;
            x = rand(n_timesteps, 3);
            u = rand(n_timesteps, 2);
            y = rand(n_timesteps, 4);
            t = linspace(0, 10, n_timesteps)';
            j = zeros(n_timesteps, 1);
            sol = HybridSubsystemSolution(t, j, x, u, y, 0, 0, [0 0], [0 0]);
            
            subsys = MockHybridSubsystem(3, 2, 1);
            subsys.f = @(x, u, t, j) x + j;
            subsys.g = @(x, u, t, j) x - t;
            subsys.C_indicator = @(x, u, t, j) norm(u) < 0.2;
            subsys.D_indicator = @(x, u, t, j) norm(u) > 0.6;
            [f_vals, g_vals, C_vals, D_vals] = subsys.generateFGCD(sol);
            testCase.assertEqual(f_vals, x + [j, j, j]);
            testCase.assertEqual(g_vals, x - [t, t, t]);
            
            assumeVersion(testCase,'R2021b') % The function vecnorm was added in R2017b.
            testCase.assertEqual(C_vals, double(vecnorm(u, 2, 2) < 0.2));
            testCase.assertEqual(D_vals, double(vecnorm(u, 2, 2) > 0.6));
        end

        function testCheckFunctions_OK(~)
            ss = HybridSubsystemBuilder() ...
                    .flowMap(@(x) zeros(2, 1)) ...
                    .jumpMap(@(x, u) zeros(2, 1)) ...
                    .output(@(x, u, t, j) j*zeros(3, 1)) ... % Output is value of D indicator.
                    .stateDimension(2) ...
                    .inputDimension(1) ...
                    .outputDimension(3) ...
                    .build();
            ss.checkFunctions();
        end

        function testCheckFunctions_flowMapWrongSizeOut(testCase)
            ss = HybridSubsystemBuilder().flowMap(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), 'HybridSubsystem:FlowMapWrongSizeOutput');
        end

        function testCheckFunctions_jumpMapWrongSizeOut(testCase)
            ss = HybridSubsystemBuilder().jumpMap(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), 'HybridSubsystem:JumpMapWrongSizeOutput');
        end

        function testCheckFunctions_jumpMapNotNumeric(testCase)
            ss = HybridSubsystemBuilder().jumpMap(@(x) 'hello').build();
            testCase.verifyError(@() ss.checkFunctions(), 'HybridSubsystem:JumpMapNotNumeric');
        end

        function testCheckFunctions_CNotScalar(testCase)
            ss = HybridSubsystemBuilder().flowSetIndicator(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSubsystem:FlowSetIndicatorNonScalar');
        end

        function testCheckFunctions_DNotLogical(testCase)
            a_function_handle = @(x) x;
            ss = HybridSubsystemBuilder().jumpSetIndicator(@(x) a_function_handle).build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSubsystem:JumpSetIndicatorNotLogical');
        end

        function testCheckFunctions_FlowOutputWrongLength(testCase)
            ss = HybridSubsystemBuilder()...
                .outputDimension(1)...
                .flowOutput(@(x) [1;2])...
                .build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSubsystem:FlowOutputWrongSize');
        end

        function testCheckFunctions_JumpOutputWrongShape(testCase)
            ss = HybridSubsystemBuilder().outputDimension(2)...
                .flowOutput(@(x)[1;2])...
                .jumpOutput(@(x)[1,2])...
                .build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSubsystem:JumpOutputWrongSize');
        end

        function testCheckFunctions_JumpOutputNotNumeric(testCase)
            ss = HybridSubsystemBuilder()....
                .jumpOutput(@(x)'hello')...
                .build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSubsystem:JumpOutputNotNumeric');
        end

        % Test assertInC

        function testAssertInC(testCase)
            ss = HybridSubsystemBuilder() ...
                    .flowSetIndicator(@(x) x >= 0)...
                    .build();
            ss.assertInC(1, nan, nan, nan);
            testCase.verifyError(@() ss.assertInC(-1, nan, nan, nan), ...
                                 'HybridSubsystem:AssertInCFailed')
        end

        % Test assertNotInC
        function testAssertNotInC(testCase)
            ss = HybridSubsystemBuilder() ...
                    .flowSetIndicator(@(x) x >= 0)...
                    .build();
            ss.assertNotInC(-1, nan, nan, nan);
            testCase.verifyError(@() ss.assertNotInC(1, nan, nan, nan), ...
                                'HybridSubsystem:AssertNotInCFailed')
        end

        % Test assertInD
        function testAssertInD(testCase)
            ss = HybridSubsystemBuilder() ...
                    .jumpSetIndicator(@(x) x >= 0)...
                    .build();
            ss.assertInD(1, nan, nan, nan);
            testCase.verifyError(@() ss.assertInD(-1, nan, nan, nan), ...
                                    'HybridSubsystem:AssertInDFailed')
        end

        % Test assertNotInC
        function testAssertNotInD(testCase)
            ss = HybridSubsystemBuilder() ...
                    .jumpSetIndicator(@(x, u, t, j) j > 0)...
                    .build();
            ss.assertNotInD(nan, nan, nan, 0);
            testCase.verifyError(@() ss.assertNotInD(nan, nan, nan, 1), ...
                                    'HybridSubsystem:AssertNotInDFailed')
        end
        
    end

end