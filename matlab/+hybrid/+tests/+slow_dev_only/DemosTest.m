classdef DemosTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        function setup(~)
            addpath(hybrid.getFolderLocation('doc'))
        end
    end
    
    methods(TestMethodTeardown)
        function teardown(~)
            rmpath(hybrid.getFolderLocation('doc'))
        end
    end

    methods (Test)
       
        %%% MATLAB DEMOS %%%

        function testHybridSystem_demo(testCase)
            testCase.testDoc('HybridSystem_demo()');
        end
        
        function testCompositeHybridSystem_demo(testCase)
            testCase.testDoc('CompositeHybridSystem_demo()');
        end
        
        function testHybridPlotBuilder_demo(testCase)
            testCase.testDoc('HybridPlotBuilder_demo()');
        end
        
        function testConvertingLegacyCodeToVersion3_demo(testCase)
            testCase.testDoc('ConvertingLegacyCodeToVersion3_demo()');
        end
        
        function test_switched_system_example_demo(testCase)
            testCase.testDoc('MATLAB_switched_system_example_demo()')
        end
        
        function test_ZOH_example_demo(testCase)
            testCase.testDoc('MATLAB_ZOH_example_demo()');
        end
        
    end

    methods
        
        function testDoc(testCase, name)
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')
            set(groot,'defaultFigureVisible','off')
            evalc(name); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end

    end

end