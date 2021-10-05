classdef HybridSubsystemTest < matlab.unittest.TestCase
    
    methods (Test)
      
        function testGenerateFGCD(testCase)
            import hybrid.tests.internal.*;
            n_timesteps = 12;
            x = rand(n_timesteps, 3);
            u = rand(n_timesteps, 2);
            t = linspace(0, 10, n_timesteps)';
            j = zeros(n_timesteps, 1);
            sol = HybridSolutionWithInput(t, j, x, u);
            
            subsys = MockHybridSubsystem(3, 2, 1);
            subsys.f = @(x, u, t, j) x + j;
            subsys.g = @(x, u, t, j) x - t;
            subsys.C_indicator = @(x, u, t, j) norm(u) < 0.2;
            subsys.D_indicator = @(x, u, t, j) norm(u) > 0.6;
            [f_vals, g_vals, C_vals, D_vals] = subsys.generateFGCD(sol);
            testCase.assertEqual(f_vals, x + j);
            testCase.assertEqual(g_vals, x - t);
            testCase.assertEqual(C_vals, double(vecnorm(u, 2, 2) < 0.2));
            testCase.assertEqual(D_vals, double(vecnorm(u, 2, 2) > 0.6));
        end
        
    end

end