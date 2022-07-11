classdef HybridSystemTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testOnlyJumps(testCase)
            f = @(x, t, j) 0;
            g = @(x, t, j) -x;
            C_indicator = @(x, t, j) 0;
            D_indicator = @(x, t, j) 1;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            sol = system.solve(1, [0, 1], [0, 10], 'silent');
            testCase.assertTrue(all(sol.x(1:2:end) ==  1))
            testCase.assertTrue(all(sol.x(2:2:end) == -1))
        end
        
        function testOnlyFlows(testCase)
            f = @(x, t, j) 2;
            g = @(x, t, j) NaN;
            C_indicator = @(x, t, j) 1;
            D_indicator = @(x, t, j) 0;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            sol = system.solve(0, [0, 1], [0, 10], 'silent');
            testCase.assertEqual(sol.x, 2*sol.t, 'AbsTol', 1e-8)
        end

        function testBouncingBall(testCase)
            system = hybrid.examples.BouncingBall();
            sol = system.solve([1; 0], [0, 1], [0, 10], 'silent');
            
            testCase.assertGreaterThan(sol.x(:,1), -1e-2);
        end

        function testMissingThisInMethod(testCase)
            fh = @() hybrid.tests.internal.HybridSystemWithMissingThisArg();
            testCase.verifyError(fh, 'Hybrid:InvalidMethodArgumentName')
        end
        
        function testCheckFunctions_NoArgsGiven_OK(~)
            ss = HybridSystemBuilder() ...
                    .flowMap(@(x) zeros(2, 1)) ...
                    .jumpMap(@(x, u) zeros(2, 1)) ...
                    .stateDimension(2) ...
                    .build();
            ss.checkFunctions();
        end
        
        function testCheckFunctions_ArgsGiven_OK(~)
            ss = HybridSystemBuilder() ...
                    .flowMap(@(x) zeros(2, 1)) ...
                    .jumpMap(@(x, u) zeros(2, 1)) ...
                    .stateDimension(2) ...
                    .build();
            ss.checkFunctions([1; 2], 0, 1);
        end

        function testCheckFunctions_flowMapWrongSizeOut(testCase)
            ss = HybridSystemBuilder().flowMap(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), ...
                                'HybridSystem:FlowMapWrongSizeOutput');
            testCase.verifyError(@() ss.checkFunctions([1;2]), ...
                                'HybridSystem:FlowMapWrongSizeOutput');
        end

        function testCheckFunctions_jumpMapWrongSizeOut(testCase)
            ss = HybridSystemBuilder().jumpMap(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), ...
                                'HybridSystem:JumpMapWrongSizeOutput');
            testCase.verifyError(@() ss.checkFunctions([1;4]), ...
                                 'HybridSystem:JumpMapWrongSizeOutput');
        end

        function testCheckFunctions_jumpMapNotNumeric(testCase)
            ss = HybridSystemBuilder().jumpMap(@(x) 'hello').build();
            testCase.verifyError(@() ss.checkFunctions(), 'HybridSystem:JumpMapNotNumeric');
        end

        function testCheckFunctions_CNotScalar(testCase)
            ss = HybridSystemBuilder().flowSetIndicator(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSystem:FlowSetIndicatorNonScalar');
        end

        function testCheckFunctions_DNotLogical(testCase)
            a_function_handle = @(x) x;
            ss = HybridSystemBuilder().jumpSetIndicator(@(x) a_function_handle).build();
            testCase.verifyError(@() ss.checkFunctions(), ....
                'HybridSystem:JumpSetIndicatorNotLogical');
        end

        % Test asssertions

        function testAssertInC(testCase)
            ss = HybridSystemBuilder() ...
                    .flowSetIndicator(@(x) x >= 0)...
                    .build();
            ss.assertInC(1, nan, nan);
            testCase.verifyError(@() ss.assertInC(-1, nan, nan), ...
                                 'HybridSystem:AssertInCFailed')
        end

        % Test assertNotInC
        function testAssertNotInC(testCase)
            ss = HybridSystemBuilder() ...
                    .flowSetIndicator(@(x) x >= 0)...
                    .build();
            ss.assertNotInC(-1, nan, nan);
            testCase.verifyError(@() ss.assertNotInC(1, nan, nan), ...
                                'HybridSystem:AssertNotInCFailed')
        end

        % Test assertInD
        function testAssertInD_x(testCase)
            ss = HybridSystemBuilder() ...
                    .jumpSetIndicator(@(x) x >= 0)...
                    .build();
            ss.assertInD(1, nan, nan);
            testCase.verifyError(@() ss.assertInD(-1, nan, nan), ...
                                    'HybridSystem:AssertInDFailed')
        end

        function testAssertInD_xtj(testCase)
            ss = HybridSystemBuilder() ...
                    .jumpSetIndicator(@(x, t, j) x(1) > 0)...
                    .build();
            ss.assertInD(1, 1, 2);
            testCase.verifyError(@() ss.assertInD([-1;4], 1, 2), ...
                'HybridSystem:AssertInDFailed')
        end

        % Test assertNotInC
        function testAssertNotInD(testCase)
            ss = HybridSystemBuilder() ...
                    .jumpSetIndicator(@(x, t, j) j > 0)...
                    .build();
            ss.assertNotInD(nan, nan, 0);
            testCase.verifyError(@() ss.assertNotInD(nan, nan, 1), ...
                                    'HybridSystem:AssertNotInDFailed')
        end

    end

end