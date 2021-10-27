classdef createPlotValuesFromIdsTest < matlab.unittest.TestCase
   
    properties
        sol_1
        sol_2
        sol_3
        sol_4
    end
    
    methods
        function this = createPlotValuesFromIdsTest()
            t = [linspace(0, 1, 50)'; linspace(1, 2, 50)'];
            j = [zeros(50, 1); ones(50, 1)];
            x = (t + j).^2;
            this.sol_1 = HybridSolution(t, j, x);
            this.sol_2 = HybridSolution(t, j, [1.2*x, 2.2*x]);
            this.sol_3 = HybridSolution(t, j, [1.3*x, 2.3*x, 3.3*x]);
            this.sol_4 = HybridSolution(t, j, [1.4*x, 2.4*x, 3.4*x, 4.4*x]);
        end
    end

    methods (Test)
       
        function testTX(testCase)
            import hybrid.internal.*
            sol = testCase.sol_3;
            plotValues = createPlotValuesFromIds(sol, {'t'}, 1, []);
            testCase.assertEqual(plotValues, [sol.t, sol.x(:, 1)]);
        end

        function testJX(testCase)
            import hybrid.internal.*
            sol = testCase.sol_3;
            plotValues = createPlotValuesFromIds(sol, {'j'}, 3, []);
            testCase.assertEqual(plotValues, [sol.j, sol.x(:, 3)]);
        end

        function testTJX(testCase)
            import hybrid.internal.*
            sol = testCase.sol_4;
            plotValues = createPlotValuesFromIds(sol, {'t'}, {'j'}, 4);
            testCase.assertEqual(plotValues, [sol.t, sol.j, sol.x(:, 4)]);
        end

        function testXX(testCase)
            import hybrid.internal.*
            sol = testCase.sol_4;
            plotValues = createPlotValuesFromIds(sol, 1, 4, []);
            testCase.assertEqual(plotValues, sol.x(:, [1, 4]));
        end

        function testXXX(testCase)
            import hybrid.internal.*
            sol = testCase.sol_4;
            plotValues = createPlotValuesFromIds(sol, 1, 3, 2);
            testCase.assertEqual(plotValues, sol.x(:, [1, 3, 2]));
        end

        function testInvalidStateNdx(testCase)
            import hybrid.internal.*
            sol = testCase.sol_4;
            testCase.verifyError(@() createPlotValuesFromIds(sol, 99, 3, 2), ...
                'HybridPlotBuilder:InvalidStateIndex');
        end
    end

end