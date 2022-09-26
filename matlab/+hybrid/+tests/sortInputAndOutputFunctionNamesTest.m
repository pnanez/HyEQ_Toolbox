classdef sortInputAndOutputFunctionNamesTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testNoDependenices(testCase)
            import hybrid.internal.*
            u1 = @( ~, ~, t, j) t;
            u2 = @(~, ~, t, j) j;
            y1 = @(x1, ~, t, j) 0.5*x1;
            y2 = @(x2,  ~, t, j) x2;
            outputs = {y1, y2};
            inputs  = {u1, u2};

            sorted_names = sortInputAndOutputFunctionNames(inputs, outputs);
            expected = ['u1'; 'u2'; 'y1'; 'y2'];
            testCase.assertEqual(sorted_names, expected);
        end
        
        function testOneSubsystem(testCase)
            import hybrid.internal.*
            u1 = @(~, t, j) t;
            y1 = @(x1, u, t, j) 0.5*x1;
            outputs = {y1};
            inputs  = {u1};

            sorted_names = sortInputAndOutputFunctionNames(inputs, outputs);
            expected = ['u1'; 'y1'];
            testCase.assertEqual(sorted_names, expected);
        end
        
        function testOneIndpendentThenChainOfDependenices(testCase)
            import hybrid.internal.*
            u1 = @( ~, y2, t, j) y2;
            u2 = @(y1, y2, t, j) y1;
            y1 = @(x1, u1, t, j) u1;
            y2 = @(x2,  ~, t, j) x2;
            outputs = {y1, y2};
            inputs  = {u1, u2};

            sorted_names = sortInputAndOutputFunctionNames(inputs, outputs);
            expected = ['y2'; 'u1'; 'y1'; 'u2'];
            testCase.assertEqual(sorted_names, expected);
        end
        
        function testWithoutTJU(testCase)
            import hybrid.internal.*
            u1 = @( ~, y2, t) y2;
            u2 = @(y1, y2)    y1;
            y1 = @(x1, u1)    u1;
            y2 = @(x2)        x2;
            outputs = {y1, y2};
            inputs  = {u1, u2};
            
            sorted_names = sortInputAndOutputFunctionNames(inputs, outputs);
            expected = ['y2'; 'u1'; 'y1'; 'u2'];
            testCase.assertEqual(sorted_names, expected);
        end
        
        function testNoSolution(testCase)
            import hybrid.internal.*
            u1 = @(y1, y2) y1;
            y1 = @(x1, u1) u1;
            outputs = {y1};
            inputs  = {u1};
            
            testCase.verifyError(...
                @() sortInputAndOutputFunctionNames(inputs, outputs), ...
                'sortInputAndOutputFunctionNames:DependencyLoop');
        end

    end

end