classdef DemosTest < matlab.unittest.TestCase
    
    methods(TestMethodSetup)
        function setup(~)
            addpath(hybrid.getFolderLocation('doc'))

            % Close all Simulink systems.
            while ~isempty(gcs())
                close_system(gcs());
            end
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

        %%% SIMULINK DOCS %%%
        function testSimulinkDocs(testCase) 
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')

            set(groot,'defaultFigureVisible','off')
            cleanup_obj = onCleanup( @() set(groot,'defaultFigureVisible','on'));
            
            path = hybrid.getFolderLocation('doc');
            files = ls(path); % ls outputs a char array with each file in a row.
            for f = files'
                file_name = strtrim(f');
                if ~endsWith(file_name, '.m') || endsWith(file_name, '_demo.m') 
                    continue
                end
                script_name = file_name(1:(end-2)); % Remove '.m' extension.

                % Run the script in the base namespace. This is necessary so
                % that the variables saved by the Simulink model are accessible
                % by the scripts and vice versa.
                evalin('base', script_name);
            end
        end
        
    end

    methods
        
        function testDoc(testCase, name)
            hybrid.tests.internal.assumeVersion(testCase, 'R2021b')
            set(groot,'defaultFigureVisible','off')
            cleanup_obj = onCleanup( @() set(groot,'defaultFigureVisible','on'));
            evalc(name); % Run without printing to terminal.
        end

    end

end