classdef TerminationCauseTest < matlab.unittest.TestCase
    
    % Test Method Block
    methods (Test)
        
        function testInfinite(testCase)
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = [0, 1;  
                 1, 2; 
                 0, Inf]; % Only one entry in the last row need be Inf.
            C = 1;
            D = 1;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.STATE_IS_INFINITE)
        end
        
        function testNaN(testCase)
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = [0, 1; 
                 1, 2; 
                 NaN, 0]; % Only one entry in the last row need be NaN.
            C = 1;
            D = 1;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.STATE_IS_NAN)
        end
        
        function testContinuousTimeLeftTSpan(testCase)
            t = linspace(0, 100, 3)'; 
            j = zeros(3, 1); 
            x = [0; 1; 3];
            C = 1;
            D = 1;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.T_REACHED_END_OF_TSPAN)
        end

        function testDiscreteTimeLeftJSpan(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 1;
            D = 1;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 2]);
            testCase.assertEqual(cause, TerminationCause.J_REACHED_END_OF_JSPAN)
        end

        function testNotInFlowOrJumpSets(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 0;
            D = 0;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.STATE_NOT_IN_C_UNION_D)
        end

        function testInJumpSetThenNoCause(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 0;
            D = 1;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.CANCELED)
        end

        function testInFlowSetThenNoCause(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 1;
            D = 0;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100], [0, 100]);
            testCase.assertEqual(cause, TerminationCause.CANCELED)
        end

        function testNoJspanAndInFlowOrJumpSetsThenUndetermined(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 1;
            D = 0;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100]);
            testCase.assertEqual(cause, TerminationCause.UNDETERMINED)
        end

        function testNoJspanAndNotInFlowOrJumpSets(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 0;
            D = 0;
            cause = TerminationCause.getCause(t, j, x, C, D);
            testCase.assertEqual(cause, TerminationCause.STATE_NOT_IN_C_UNION_D)
        end

        function testNotInFlowSetAndNowJspanThenUndetermined(testCase)
            t = linspace(0, 2, 3)'; 
            j = [0; 1; 2]; 
            x = [0; 1; 3];
            C = 1;
            D = 0;
            cause = TerminationCause.getCause(t, j, x, C, D, [0, 100]);
            testCase.assertEqual(cause, TerminationCause.UNDETERMINED)
        end

    end

end