classdef seperateFlowsWithNaNTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testTrivialHybridTimeDomain(testCase)
            import hybrid.internal.separateFlowsWithNaN
            t = 1.2;
            j = 3;
            x = pi;
            flows_x = separateFlowsWithNaN(t, j, x);
            testCase.assertEmpty(flows_x);
        end
        
        function testOneFlow(testCase)
            import hybrid.internal.separateFlowsWithNaN
            n = 5;
            t = linspace(1, 10, n)';
            j = zeros(n, 1);
            x = 3*rand(n, 3);
            flows_x = separateFlowsWithNaN(t, j, x);
            testCase.assertEqual(flows_x, x);
        end
        
        function testTwoFlows(testCase)
            import hybrid.internal.separateFlowsWithNaN
            n1 = 5;
            n2 = 7;
            t = [linspace(1, 10, n1), linspace(10, 20, n2)]';
            j = [zeros(n1, 1); ones(n2, 1)];
            x = [3*ones(n1, 1); 2*ones(n2, 1)];
            flows_x_expected = [3*ones(n1, 1); NaN; 2*ones(n2, 1)];
            flows_x = separateFlowsWithNaN(t, j, x);
            testCase.assertEqual(flows_x, flows_x_expected);
        end
        
        function testTwoSequentialJumps(testCase)
            import hybrid.internal.separateFlowsWithNaN
            n1 = 3;
            n2 = 2;
            t = [linspace(1, 10, n1), 10, linspace(10, 20, n2)]';
            j = [zeros(n1, 1); 1; 2*ones(n2, 1)];
            x = [ones(n1, 1); 2; 3*ones(n2, 1)];
            flows_x_expected = [x(1:n1); NaN; x((n1+1)+(1:n2))];
            flows_x = separateFlowsWithNaN(t, j, x);
            testCase.assertEqual(flows_x, flows_x_expected);
        end

    end

end