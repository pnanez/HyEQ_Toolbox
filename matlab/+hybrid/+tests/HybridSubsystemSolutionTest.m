classdef HybridSubsystemSolutionTest < matlab.unittest.TestCase
    
methods(Test)
    function testEvaluateFunctionWithInputs(testCase)
        n_timesteps = 12;
        x = rand(n_timesteps, 3);
        u = rand(n_timesteps, 2);
        y = rand(n_timesteps, 5);
        t = linspace(0, 10, n_timesteps)';
        j = zeros(n_timesteps, 1);
        sol = HybridSubsystemSolution(t, j, x, u, y, 0, 0, [0 0], [0 0]);

        function out = function_handle_with_checks(x, u, t, j)
            testCase.assertSize(x, [3, 1])
            testCase.assertSize(u, [2, 1])
%             testCase.assertSize(y, [5, 1])
            testCase.assertTrue(isscalar(j));
            testCase.assertTrue(isscalar(t));
            out = j;
        end
        output = sol.evaluateFunctionWithInputs(@function_handle_with_checks);
        testCase.assertEqual(output, j);

        y = sol.evaluateFunctionWithInputs(@(x, u, t) t);
        testCase.assertEqual(y, t);

        y = sol.evaluateFunctionWithInputs(@(x, u) u);
        testCase.assertEqual(y, u);

        y = sol.evaluateFunctionWithInputs(@(x) x);
        testCase.assertEqual(y, x);
        
        testCase.verifyError(...
            @()sol.evaluateFunctionWithInputs(@(x, u, t, j, extra) x), ...
            'Hybrid:InvalidFunctionArguments');
    end
end
    
end