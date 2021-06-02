classdef TerminationCauseTest < matlab.unittest.TestCase
    
    % Test Method Block
    methods (Test)
        
        function testInfinite(testCase)
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = [0, 1;  
                 1, 2; 
                 0, Inf]; % Only one entry in the last row need be Inf.
            cause = TerminationCause.getCause([], t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.STATE_IS_INFINITE)
        end
        
        function testNaN(testCase)
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = [0, 1; 
                 1, 2; 
                 NaN, 0]; % Only one entry in the last row need be NaN.
            cause = TerminationCause.getCause([], t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.STATE_IS_NAN)
        end
        
        function testContinuousTimeLeftTSpan(testCase)
            t = linspace(0, 100, 3)'; 
            j = zeros(3, 1); 
            x = [0; 1; 3];
            cause = TerminationCause.getCause([], t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.T_REACHED_END_OF_TSPAN)
        end

        function testDiscreteTimeLeftJSpan(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            cause = TerminationCause.getCause([], t, j, x, [0, 100], [0, 2]);
            testCase.assertEqual(cause, TerminationCause.J_REACHED_END_OF_JSPAN)
        end

        function testNotInFlowOrJumpSets(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            empty_sets_system = EZHybridSystem(@(x) x.^2, @(x) -x, @(x) 0, @(x) 0); 
            cause = TerminationCause.getCause(empty_sets_system, t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.STATE_NOT_IN_C_UNION_D)
        end

        function testInJumpSetThenNoCause(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            always_jump_system = EZHybridSystem(@(x) x.^2, @(x) -x, @(x) 0, @(x) 1); 
            cause = TerminationCause.getCause(always_jump_system, t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.NO_CAUSE)
        end

        function testInFlowSetThenNoCause(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            always_flow_system = EZHybridSystem(@(x) x.^2, @(x) -x, @(x) 1, @(x) 0); 
            cause = TerminationCause.getCause(always_flow_system, t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.NO_CAUSE)
        end
       
        function testSystemNotProvidedAndCauseNotOtherwiseApparent(testCase)
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = [0; 1; 2];
            cause = TerminationCause.getCause([], t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.SYSTEM_NOT_PROVIDED)
        end

    end

end