classdef HybridProgressTest < matlab.unittest.TestCase


    methods (Test)
        function testT(testCase)
            hp = HybridProgress();
            hp.tspan = [0, 10];
            hp.jspan = [0, 5];
            hp.ODE_progress(1, [])
            f = hp.ODE_callback;
            f(0.6, [], [])
        end
    end

end 