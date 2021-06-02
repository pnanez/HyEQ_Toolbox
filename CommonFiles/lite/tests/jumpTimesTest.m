classdef jumpTimesTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testTrivialHybridTimeDomain(testCase)
            [jump_t, jump_j, jump_indices] = HybridUtils.jumpTimes([0], [0]);
            testCase.assertEmpty(jump_t);
            testCase.assertEmpty(jump_j);
            testCase.assertEmpty(jump_indices);
        end

        function testNoJumps(testCase)
            t = linspace(0, 100, 12)';
            j = zeros(12, 1);
            [jump_t, jump_j, jump_indices] = HybridUtils.jumpTimes(t, j);
            testCase.assertEmpty(jump_t);
            testCase.assertEmpty(jump_j);
            testCase.assertEmpty(jump_indices);
        end

        function testOneJump(testCase)
            t = [0, 0.1, 0.1, 0.2];
            j = [1; 1; 2; 2];
            [jump_t, jump_j, jump_indices] = HybridUtils.jumpTimes(t, j);
            testCase.assertEqual(jump_t, 0.1);
            testCase.assertEqual(jump_j, 2); % The value of j after the jump.
            testCase.assertEqual(jump_indices, 3);
        end

        function testTwoJumps(testCase)
            t = [0; 2.17; 2.17; 3.14; 3.14];
            j = [0; 0;    1;    1;    2];
            [jump_t, jump_j, jump_indices] = HybridUtils.jumpTimes(t, j);
            testCase.assertEqual(jump_t, [2.17; 3.14]);
            testCase.assertEqual(jump_j, [1; 2]); % The values of j after the jumps.
            testCase.assertEqual(jump_indices, [3; 5]);
        end

    end

end