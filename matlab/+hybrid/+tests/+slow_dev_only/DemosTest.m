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
       
        function testHybridSystem_demo(testCase)
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')
            set(groot,'defaultFigureVisible','off')
            evalc('HybridSystem_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
        function testCompositeHybridSystem_demo(testCase)
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')
            set(groot,'defaultFigureVisible','off')
            evalc('CompositeHybridSystem_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
        function testHybridPlotBuilder_demo(testCase)
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')
            set(groot,'defaultFigureVisible','off')
            evalc('HybridPlotBuilder_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
        function testConvertingLegacyCodeToVersion3_demo(testCase)
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')
            set(groot,'defaultFigureVisible','off')
            evalc('ConvertingLegacyCodeToVersion3_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
    end

end