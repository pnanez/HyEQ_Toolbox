classdef parseStringVararginWithOptionalOptionsTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testEmpty(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions();
            testCase.assertEmpty(strings);
        end
        
        function testOnlyStringArgsNoOptions(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions("A", "B");
            testCase.assertEqual(strings, ["A", "B"]);
        end
       
        function testOnlyCharArraysArgsNoOptions(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions('A', 'B');
            testCase.assertEqual(strings, ["A", "B"]);
        end
        
        function testEmptyOptions(testCase)
            [~, options] = hybrid.internal.parseStringVararginWithOptionalOptions("A", "B");
            testCase.assertEmpty(options)
        end
        
        function testCellStringsNoOptions(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions({"A", 'B'});
            testCase.assertEqual(strings, ["A", "B"]);
        end
        
        function testCellStringsWithMissingEntries(testCase)
            in{1} = "A";
            in{3} = "C";
            strings = hybrid.internal.parseStringVararginWithOptionalOptions(in);
            testCase.assertEqual(strings, ["A", "", "C"]);
        end
        
        function testCellStringsEmptyOptions(testCase)
            [~, options] = hybrid.internal.parseStringVararginWithOptionalOptions({"A", 'B'});
            testCase.assertEmpty(options);
        end
        
        function testCellStringsWithOptions(testCase)
            import hybrid.internal.*
            strings = {"A", 'B'};
            [~, options] = parseStringVararginWithOptionalOptions(strings, "Option 1", 5, "Option 2", magic(3));
            testCase.assertEqual(options, {"Option 1", 5, "Option 2", magic(3)});
        end
        
        function testErrorUnexpectedOptions(testCase)
            import hybrid.internal.*
            strings = {"A", 'B'};
            
            % function call within anonymous function has one output argument.
            fh = @() parseStringVararginWithOptionalOptions(strings, "Unexpected", 5);
            testCase.verifyError(fh, "Hybrid:UnexpectedOptions")
        end

    end

end