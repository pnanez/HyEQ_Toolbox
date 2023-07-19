classdef jumpTimesTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testTrivialHybridTimeDomain(testCase)
            t = 0;
            j = 0;
            [jump_t, jump_j, jump_indices, is_jump] = hybrid.internal.jumpTimes(t, j);
            testCase.assertEmpty(jump_t);
            testCase.assertEmpty(jump_j);
            testCase.assertEmpty(jump_indices);
            testCase.assertEqual(is_jump, false);
        end

        function testNoJumps(testCase)
            n = 12;
            t = linspace(0, 100, n)';
            j = zeros(n, 1);
            [jump_t, jump_j, jump_indices, is_jump] = hybrid.internal.jumpTimes(t, j);
            testCase.assertEmpty(jump_t);
            testCase.assertEmpty(jump_j);
            testCase.assertEmpty(jump_indices);
            testCase.assertEqual(is_jump, false(n, 1));
        end

        function testOneJump(testCase)
            t = [0; 0.1; 0.1; 0.2];
            j = [1;   1;   2;   2];
            [jump_t, jump_j, jump_indices, is_jump] = hybrid.internal.jumpTimes(t, j);
            testCase.assertEqual(jump_t, 0.1);
            testCase.assertEqual(jump_j, 1); % The value of j before the jump.
            testCase.assertEqual(jump_indices, 2);
            testCase.assertEqual(is_jump, logical([0; 1; 0; 0]));
        end

        function testTwoJumps(testCase)
            t = [0; 2.17; 2.17; 3.14; 3.14];
            j = [0; 0;    1;    1;    2];
            [jump_t, jump_j, jump_indices, is_jump] = hybrid.internal.jumpTimes(t, j);
            testCase.assertEqual(jump_t, [2.17; 3.14]);
            testCase.assertEqual(jump_j, [0; 1]); % The values of j after the jumps.
            testCase.assertEqual(jump_indices, [2; 4]);
            testCase.assertEqual(is_jump, logical([0; 1; 0; 1; 0]));
        end

    end

end