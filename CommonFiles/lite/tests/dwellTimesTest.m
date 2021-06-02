classdef dwellTimesTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testTrivialHybridTimeDomain(testCase)
            t = [0]; %#ok<NBRAK>
            j = [0]; %#ok<NBRAK>
            dwellTimes = HybridUtils.dwellTimes(t, j);
            testCase.assertEqual(dwellTimes, [0]); %#ok<NBRAK>
        end

        function testNoJumps(testCase)
            t_end = 100;
            t = linspace(0, t_end, 12)';
            j = zeros(12, 1);
            dwellTimes = HybridUtils.dwellTimes(t, j);
            testCase.assertEqual(dwellTimes, t_end);
        end

        function testOneJumpNotAtEnd(testCase)
            t = [0, 2.0, 2.0, 5.0];
            j = [1; 1; 2; 2];
            dwellTimes = HybridUtils.dwellTimes(t, j);
            testCase.assertEqual(dwellTimes, [2.0, 3.0]);
        end

        function testOneJumpAtEnd(testCase)
            t = [0; 1.0; 2.0; 2.0];
            j = [1; 1; 1; 2];
            dwellTimes = HybridUtils.dwellTimes(t, j);
            testCase.assertEqual(dwellTimes, 2.0);
        end

        function testTwoJumps(testCase)
            t = [0; 3; 3; 4; 5; 10];
            j = [0; 0; 1; 1; 2; 2];
            dwellTimes = HybridUtils.dwellTimes(t, j);
            testCase.assertEqual(dwellTimes, [3; 2; 5]);
        end

    end

end