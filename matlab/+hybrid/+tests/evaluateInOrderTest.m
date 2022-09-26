classdef evaluateInOrderTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testConstantValues(testCase)
            import hybrid.internal.*
            order = ['u1'; 'y1'; 'u2'; 'y2'];
            kappas = {@(y1, y2, t, j) 1, @(y1, y2, t, j) 2};
            outputs =  {@(x1, u1, t, j) -1, @(x2, u2, t, j) -2};
            xs = {1, 2};
            t = 0;
            js = {0, 0};
            [us, ys] = evaluateInOrder(order, kappas, outputs, xs, t, js);
            testCase.assertEqual(us, {1, 2});
            testCase.assertEqual(ys, {-1, -2});
        end
        
        function testOutputsThenInputs(testCase)
            import hybrid.internal.*
            order = ['y1'; 'y2'; 'u2'; 'u1'];
            kappas = {@(y1, y2, t, j) y1+y2, @(y1, y2, t, j) -(y1+y2)};
            outputs =  {@(x1, u1, t, j) x1, @(x2, u2, t, j) x2};
            xs = {1, 2};
            t = 0;
            js = {0, 0};
            [us, ys] = evaluateInOrder(order, kappas, outputs, xs, t, js);
            testCase.assertEqual(ys, xs);
            testCase.assertEqual(us, {3, -3});
        end
        
        function testInputsThenOutputs(testCase)
            import hybrid.internal.*
            order = ['u1'; 'u2'; 'y1'; 'y2'];
            kappas = {@(y1, y2, t, j) 4, @(y1, y2, t, j) 5};
            outputs =  {@(x1, u1, t, j) -u1, @(x2, u2, t, j) -u2};
            xs = {1, 2};
            t = 0;
            js = {0, 0};
            [us, ys] = evaluateInOrder(order, kappas, outputs, xs, t, js);
            testCase.assertEqual(us, { 4,  5});
            testCase.assertEqual(ys, {-4, -5});
        end
        
        function testSystem1ThenSystem2(testCase)
            import hybrid.internal.*
            order = ['u1'; 'y1'; 'u2'; 'y2'];
            kappas = {@(y1, y2, t, j) 4, @(y1, y2, t, j) -y1};
            outputs =  {@(x1, u1, t, j) 6, @(x2, u2, t, j) -x2};
            xs = {NaN, 12};
            t = 0;
            js = {0, 0};
            [us, ys] = evaluateInOrder(order, kappas, outputs, xs, t, js);
            testCase.assertEqual(us, {4, -6});
            testCase.assertEqual(ys, {6, -12});
        end
        
        function testVarArgs(testCase)
            import hybrid.internal.*
            order = ['y1'; 'y2'; 'u1'; 'u2'];
            kappas = {@(y1, y2) y1+y2, @(y1, y2, t) -y1 + t};
            outputs =  {@(x1) x1, @(x2, u2, t) t + x2};
            xs = {20, 12};
            t = pi;
            js = {0, 0};
            [us, ys] = evaluateInOrder(order, kappas, outputs, xs, t, js);
            testCase.assertEqual(us, {xs{1} + xs{2} + t, -xs{1} + t});
            testCase.assertEqual(ys, {xs{1}, t + xs{2}});
        end
        
        function testErrorWhenNonunique(testCase)
            import hybrid.internal.*
            order = ['y1'; 'y1'; 'u1'; 'u2']; % y1 is repeated.
            kappas = {@(y1, y2) y1+y2, @(y1, y2, t) -y1 + t};
            outputs =  {@(x1) x1, @(x2, u2, t) t + x2};
            xs = {20, 12};
            t = pi;
            js = {0, 0};
            testCase.verifyError(@() evaluateInOrder(order, kappas, outputs, xs, t, js), 'Hybrid:NonuniqueRows');
        end

    end

end


