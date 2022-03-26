classdef getFolderLocationTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testRoot(testCase)
            path = hybrid.getFolderLocation('root', 'LICENSE.txt');
            testCase.assertFileExists(path);
        end

        function testEmpty(testCase)
            path = hybrid.getFolderLocation('', 'LICENSE.txt');
            testCase.assertFileExists(path);
        end

        function testDoc(testCase)
            path = hybrid.getFolderLocation('doc', 'GettingStarted.mlx');
            testCase.assertFileExists(path);
        end

        function testExamples(testCase)
            path = hybrid.getFolderLocation('examples', '+hybrid', '+examples');
            testCase.assertDirectoryExists(path);
        end

        function testMatlab(testCase)
            path = hybrid.getFolderLocation('matlab', 'HyEQsolver.m');
            testCase.assertFileExists(path);
        end

        function testSimulink(testCase)
            path = hybrid.getFolderLocation('simulink', 'HyEQ_No_C_Compiler.slx');
            testCase.assertFileExists(path);
        end

        function testRootCaseInsensitive(testCase)
            path = hybrid.getFolderLocation('ROOT', 'LICENSE.txt');
            testCase.assertFileExists(path);
        end
        
    end

    methods
        function assertFileExists(testCase, path)
            out = exist(path, 'file');
            does_exist = out == 2 || out == 4;
            testCase.assertTrue(does_exist);
        end

        function assertDirectoryExists(testCase, path)
            testCase.assertTrue(exist(path, 'dir') == 7);
        end
    end
end