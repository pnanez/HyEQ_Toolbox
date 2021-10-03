classdef getUsedArgumentsTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testErrorIfNotAFunctionHandle(testCase)
            import hybrid.internal.*
            testCase.verifyError(@() getUsedArguments(123), 'Hybrid:InvalidArgument');
        end
        
        function testErrorIfLocalFunctionUsed(testCase)
            import hybrid.internal.*
            function localFunction(x, t, j) %#ok<INUSD>
                % Empty
            end
            testCase.verifyError(@() getUsedArguments(@localFunction), 'Hybrid:UnsupportedFunctionType');
        end
        
        function testNoArgs(testCase)
            import hybrid.internal.*
            is_used = getUsedArguments(@() 1);
            testCase.assertEmpty(is_used);
        end
        
        function testAllUsed(testCase)
            import hybrid.internal.*
            is_used = getUsedArguments(@(x, y) 1);
            testCase.assertEqual(is_used, logical([1, 1]));
        end
        
        function testNoneUsed(testCase)
            import hybrid.internal.*
            is_used = getUsedArguments(@(~, ~, ~) 1);
            testCase.assertEqual(is_used, logical([0, 0, 0]));
        end
        
        function testMixed(testCase)
            import hybrid.internal.*
            is_used = getUsedArguments(@(x, ~, j) 1);
            testCase.assertEqual(is_used, logical([1, 0, 1]));
        end
        
        function testMultipleLetterArgNames(testCase)
            import hybrid.internal.*
            is_used = getUsedArguments(@(x123, ~, j98) 1);
            testCase.assertEqual(is_used, logical([1, 0, 1]));
        end
        
        function testExtraWhiteSpace(testCase)
            import hybrid.internal.*
            is_used = getUsedArguments(@(  x123   , ~ , j98, ~  ) 1);
            testCase.assertEqual(is_used, logical([1, 0, 1, 0]));
        end

    end

end


