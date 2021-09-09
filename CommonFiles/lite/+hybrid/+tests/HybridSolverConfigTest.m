classdef HybridSolverConfigTest < matlab.unittest.TestCase
    
    % Test Method Block
    methods (Test)
        
        function testUseDefaultsWhenNoConstructorArgsIn(testCase)
           options = HybridSolverConfig().ode_options;
           default_options = odeset();
           testCase.assertEqual(options, default_options)
        end
        
        function testRelTolInConstructor(testCase)
           options = HybridSolverConfig("RelTol", 1e-4).ode_options;
           default_options = odeset("RelTol", 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidRelTolInConstructor(testCase)
            f = @() HybridSolverConfig("RelTol", -5);
            testCase.verifyError(f, "MATLAB:expectedNonnegative");
        end
        
        function testAbsTolInConstructor(testCase)
           options = HybridSolverConfig("AbsTol", 1e-4).ode_options;
           default_options = odeset("AbsTol", 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidAbsTolInConstructor(testCase)
            f = @() HybridSolverConfig("AbsTol", -5);
            testCase.verifyError(f, "MATLAB:expectedNonnegative");
        end
        
        function testMaxStepInConstructor(testCase)
           options = HybridSolverConfig("MaxStep", 1e-4).ode_options;
           default_options = odeset("MaxStep", 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidMaxStepInConstructor(testCase)
            f = @() HybridSolverConfig("MaxStep", -5);
            testCase.verifyError(f, "MATLAB:expectedNonnegative");
        end
        
        function testDefaultProgress(testCase)
           progress = HybridSolverConfig().progressListener;
           metaclass = ?PopupHybridProgress;
           testCase.assertInstanceOf(progress, metaclass)
        end
        
        function testSilentProgressFromString(testCase)
           progress = HybridSolverConfig().progress("silent").progressListener;
           metaclass = ?SilentHybridProgress;
           testCase.assertInstanceOf(progress, metaclass)
        end
        
        function testSilentProgressFromCharArray(testCase)
           progress = HybridSolverConfig().progress('silent').progressListener;
           metaclass = ?SilentHybridProgress;
           testCase.assertInstanceOf(progress, metaclass)
        end
        
        function testProgressFromObject(testCase)
           popupProgress = PopupHybridProgress();
           popupProgress.min_delay = 2.3;
           progress = HybridSolverConfig().progress(popupProgress).progressListener;
           testCase.assertEqual(progress, popupProgress)
        end
        
        function testProgressFromInvalidString(testCase)
            config = HybridSolverConfig();
            testCase.verifyError(@() config.progress('whatever'), ...
                'HybridSolverConfig:InvalidProgress');
        end
        
        function testProgressFromInvalidObject(testCase)
            config = HybridSolverConfig();
            testCase.verifyError(@() config.progress(23948), ...
                'HybridSolverConfig:InvalidProgress');
        end

    end

end