classdef parseStringVararginWithOptionalOptionsTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testEmpty(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions();
            testCase.assertEmpty(strings);
        end
        
        function testOnlyCharArrayArgsNoOptions(testCase)
            chars = hybrid.internal.parseStringVararginWithOptionalOptions('A', 'B');
            testCase.assertEqual(chars, {'A', 'B'});
        end
        
        function testStringArgsConvertToCharArrays(testCase)
            hybrid.tests.internal.assumeStringsSupported();
            A = string('Apple'); %#ok<STRQUOT>
            B = string('Bat'); %#ok<STRQUOT>
            strings = hybrid.internal.parseStringVararginWithOptionalOptions(A, B);
            testCase.assertEqual(strings, {'Apple', 'Bat'});
        end
       
        function testOnlyCharArraysArgsNoOptions(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions('A', 'B');
            testCase.assertEqual(strings, {'A', 'B'});
        end
        
        function testEmptyOptions(testCase)
            [~, options] = hybrid.internal.parseStringVararginWithOptionalOptions('A', 'B');
            testCase.assertEmpty(options)
        end
        
        function testCellCharsNoOptions(testCase)
            strings = hybrid.internal.parseStringVararginWithOptionalOptions({'A', 'B'});
            testCase.assertEqual(strings, {'A', 'B'});
        end
        
        function testCellCharsWithEmptyEntries(testCase)
            in{1} = 'A';
            in{3} = 'C';
            strings = hybrid.internal.parseStringVararginWithOptionalOptions(in);
            testCase.assertEqual(strings, {'A', '', 'C'});
        end
        
        function testCellCharsEmptyOptions(testCase)
            [~, options] = hybrid.internal.parseStringVararginWithOptionalOptions({'A', 'B'});
            testCase.assertEmpty(options);
        end
        
        function testCellStringsWithOptions(testCase)
            import hybrid.internal.*
            strings = {'A', 'B'};
            [~, options] = parseStringVararginWithOptionalOptions(strings, 'Option 1', 5, 'Option 2', magic(3));
            testCase.assertEqual(options, {'Option 1', 5, 'Option 2', magic(3)});
        end
        
        function testStringsInOption(testCase)
            import hybrid.internal.*
            hybrid.tests.internal.assumeStringsSupported(testCase)
            strings = {'A', 'B'};
            [~, options] = parseStringVararginWithOptionalOptions(strings, ...
                string('Option 1'), string('a string'), ...
                string('Option 2'), magic(3)); %#ok<STRQUOT>
            testCase.assertEqual(options, {'Option 1', 'a string', 'Option 2', magic(3)});
        end
        
        function testErrorUnexpectedOptions(testCase)
            import hybrid.internal.*
            strings = {'A', 'B'};
            
            % function call within anonymous function has one output argument.
            fh = @() parseStringVararginWithOptionalOptions(strings, 'Unexpected', 5);
            testCase.verifyError(fh, 'Hybrid:UnexpectedOptions')
        end

    end

end