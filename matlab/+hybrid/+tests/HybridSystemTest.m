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
            x0 = [1; 0];
            tspan = [0, 30];
            jspan = [0, 60];
            sol = system.solve(x0, tspan, jspan, 'silent');
            
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
        
        function testSolve_WarnIfJumpMapErrorAtInitialPointAndNotInJumpSet(testCase)
            f = @(x, t, j) 2;
            g = @(x, t, j) error('Not in jump set.');
            C_indicator = @(x, t, j) 1;
            D_indicator = @(x, t, j) 0;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            testCase.assertWarning(@() system.solve(0, [0, 1], [0, 10], 'silent'), ...
                'HybridSystem:JumpMapErrorOutsideJumpSet');
        end
        
        function testSolve_WarnIfFlowMapErrorAtInitialPointAndNotInFlowSet(testCase)
            f = @(x, t, j) error('Not in jump set.');
            g = @(x, t, j) x;
            C_indicator = @(x, t, j) 0;
            D_indicator = @(x, t, j) 1;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            testCase.assertWarning(@() system.solve(0, [0, 1], [0, 10], 'silent'), ...
                'HybridSystem:FlowMapErrorOutsideFlowSet');
        end
        
        function testSolve_ErrorIf_f_CannotBeEvaluatedAtInitialPoint(testCase)
            f = @(x, t, j) throwErrorWithAnOutputVariable('Test:Error');
            g = @(x, t, j) x;
            C_indicator = @(x, t, j) 1;
            D_indicator = @(x, t, j) 1;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            testCase.assertError(@() system.solve(0, [0, 1], [0, 10], 'silent'), ...
                'Test:Error');
        end
        
        function testSolve_ErrorIf_g_CannotBeEvaluatedAtInitialPoint(testCase)
            f = @(x, t, j) x;
            g = @(x, t, j) throwErrorWithAnOutputVariable('Test:Error');
            C_indicator = @(x, t, j) 1;
            D_indicator = @(x, t, j) 1;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            testCase.assertError(@() system.solve(0, [0, 1], [0, 10], 'silent'), ...
                'Test:Error');
        end
        
        function testSolve_ErrorIf_C_CannotBeEvaluatedAtInitialPoint(testCase)
            f = @(x, t, j) x;
            g = @(x, t, j) x;
            C_indicator = @(x, t, j) throwErrorWithAnOutputVariable('Test:Error');
            D_indicator = @(x, t, j) 1;
            system = HybridSystem(f, g, C_indicator, D_indicator);
            testCase.assertError(@() system.solve(0, [0, 1], [0, 10], 'silent'), ...
                'Test:Error');
        end
        
        function testSolve_ErrorIf_D_CannotBeEvaluatedAtInitialPoint(testCase)
            f = @(x, t, j) x;
            g = @(x, t, j) x;
            C_indicator = @(x, t, j) 1;
            D_indicator = @(x, t, j) throwErrorWithAnOutputVariable('Test:Error');
            system = HybridSystem(f, g, C_indicator, D_indicator);
            testCase.assertError(@() system.solve(0, [0, 1], [0, 10], 'silent'), ...
                'Test:Error');
        end

        function testCheckFunctions_flowMapWrongSizeOut(testCase)
            ss = HybridSystemBuilder().stateDimension(1).flowMap(@(x) [1;1]).build();
            testCase.verifyError(@() ss.checkFunctions(), ...
                                'HybridSystem:FlowMapWrongSizeOutput');
            testCase.verifyError(@() ss.checkFunctions([1]), ...
                                'HybridSystem:FlowMapWrongSizeOutput');
        end

        function testCheckFunctions_flowMapOutputDoesntMatchInput(testCase)
            ss = HybridSystemBuilder().flowMap(@(x) [1;1]).build(); % No stateDimension given
            testCase.verifyError(@() ss.checkFunctions(1), ...
                                'HybridSystem:FlowMapWrongSizeOutput');
        end

        function testCheckFunctions_flowMapOutputMatchesInputWithNoStateDim(~)
            ss = HybridSystemBuilder()...
                .flowMap(@(x) [1;1])... % 2D output
                .jumpMap(@(x) [0;0])... % 2D output
                .build(); % No stateDimension given
            ss.checkFunctions([2;3]); % 2D input
        end

        function testCheckFunctions_NoStateDimensionAndNoTestPoint(testCase)
            ss = HybridSystemBuilder().build(); % No stateDimension given
            testCase.verifyError(@() ss.checkFunctions(), ...
                                'HybridSystem:NoStateDimensionAndNoTestPoint');
        end

        function testCheckFunctions_jumpMapWrongSizeOut(testCase)
            ss = HybridSystemBuilder()...
                .stateDimension(2)...
                .flowMap(@(x) zeros(2, 1))...
                .jumpMap(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(), ...
                                'HybridSystem:JumpMapWrongSizeOutput');
            testCase.verifyError(@() ss.checkFunctions([1;4]), ...
                                 'HybridSystem:JumpMapWrongSizeOutput');
        end

        function testCheckFunctions_jumpMapNotNumeric(testCase)
            ss = HybridSystemBuilder().jumpMap(@(x) 'hello').build();
            testCase.verifyError(@() ss.checkFunctions(1), 'HybridSystem:JumpMapNotNumeric');
        end

        function testCheckFunctions_CNotScalar(testCase)
            ss = HybridSystemBuilder().flowSetIndicator(@(x) [x;x]).build();
            testCase.verifyError(@() ss.checkFunctions(1), ....
                'HybridSystem:FlowSetIndicatorNonScalar');
        end

        function testCheckFunctions_DNotLogical(testCase)
            a_function_handle = @(x) x;
            ss = HybridSystemBuilder().jumpSetIndicator(@(x) a_function_handle).build();
            testCase.verifyError(@() ss.checkFunctions(0), ....
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
                    .jumpSetIndicator(@(x, t, j) x > 0)...
                    .build();
            ss.assertInD(1, 1, 2);
            testCase.verifyError(@() ss.assertInD(-1, 1, 2), ...
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

        % Check that assertions fail if no 'x' is given or if too many inputs arguments.
        function testAssertFcnsNarginchk(testCase)
            ss = HybridSystemBuilder().stateDimension(1).build();

            % Check not enough arguments
            testCase.verifyError(@() ss.assertInC(), 'MATLAB:narginchk:notEnoughInputs')
            testCase.verifyError(@() ss.assertNotInC(), 'MATLAB:narginchk:notEnoughInputs')
            testCase.verifyError(@() ss.assertInD(), 'MATLAB:narginchk:notEnoughInputs')
            testCase.verifyError(@() ss.assertNotInD(), 'MATLAB:narginchk:notEnoughInputs')

            % Check too many arguments
            testCase.verifyError(@() ss.assertInC(1, 2, 3, 4), 'MATLAB:narginchk:tooManyInputs')
            testCase.verifyError(@() ss.assertNotInC(1, 2, 3, 4), 'MATLAB:narginchk:tooManyInputs')
            testCase.verifyError(@() ss.assertInD(1, 2, 3, 4), 'MATLAB:narginchk:tooManyInputs')
            testCase.verifyError(@() ss.assertNotInD(1, 2, 3, 4), 'MATLAB:narginchk:tooManyInputs')
        end

    end

end

function x_out = throwErrorWithAnOutputVariable(error_id) %#ok<STOUT>
    error(error_id, 'dummy message')
end