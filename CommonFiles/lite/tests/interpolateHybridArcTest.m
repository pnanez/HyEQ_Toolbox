classdef interpolateHybridArcTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testSmokeTest(testCase)
            t = [0; 1; 1; 2];
            j = [0; 0; 1; 1];
            x = [2, 2; 
                 3, 4;
                 3, 6;
                 4, 8];
            [t_interp, j_interp, x_interp] = HybridUtils.interpolateHybridArc(t, j, x, 11);
            testCase.assertEqual(length(t_interp), 22)
            testCase.assertEqual(length(j_interp), 22)
            testCase.assertEqual(length(x_interp(:,1)), 22)
        end

    end

end