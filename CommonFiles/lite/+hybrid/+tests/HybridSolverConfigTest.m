classdef HybridSolverConfigTest < matlab.unittest.TestCase
    
    % Test Method Block
    methods (Test)
        
        function testUseDefaultsWhenNoConstructorArgsIn(testCase)
           options = HybridSolverConfig().ode_options;
           default_options = odeset();
           testCase.assertEqual(options, default_options)
        end
        
        function testRelTolInConstructor(testCase)
           options = HybridSolverConfig('RelTol', 1e-4).ode_options;
           default_options = odeset('RelTol', 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidRelTolInConstructor(testCase)
            f = @() HybridSolverConfig('RelTol', -5);
            testCase.verifyError(f, 'MATLAB:expectedNonnegative');
        end
        
        function testAbsTolInConstructor(testCase)
           options = HybridSolverConfig('AbsTol', 1e-4).ode_options;
           default_options = odeset('AbsTol', 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidAbsTolInConstructor(testCase)
            f = @() HybridSolverConfig('AbsTol', -5);
            testCase.verifyError(f, 'MATLAB:expectedNonnegative');
        end
        
        function testMaxStepInConstructor(testCase)
           options = HybridSolverConfig('MaxStep', 1e-4).ode_options;
           default_options = odeset('MaxStep', 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidMaxStepInConstructor(testCase)
            f = @() HybridSolverConfig('MaxStep', -5);
            testCase.verifyError(f, 'MATLAB:expectedNonnegative');
        end
        
        function testMaxStepFromStringInConstructor(testCase)
            hybrid.tests.internal.assumeStringsSupported();
            config = HybridSolverConfig(string('MaxStep'), 1e-3); %#ok<STRQUOT>
            expected_options = odeset('MaxStep', 1e-3);
            testCase.assertEqual(config.ode_options, expected_options)
        end
        
        function testOtherOdeOptions(testCase)
            config = HybridSolverConfig();
            config.odeOption('JConstant', true);
            expected_options = odeset('JConstant', true);
            testCase.assertEqual(config.ode_options, expected_options)
        end
        
        function testDefaultProgress(testCase)
           progress = HybridSolverConfig().progressListener;
           metaclass = ?PopupHybridProgress;
           testCase.assertInstanceOf(progress, metaclass)
        end
        
        function testPopupProgressFromString(testCase)
           hybrid.tests.internal.assumeStringsSupported();
           str = string('popup'); %#ok<STRQUOT>
           progress = HybridSolverConfig().progress(str).progressListener;
           testCase.assertInstanceOf(progress, ?PopupHybridProgress)
        end
        
        function testPopupProgressFromCharArray(testCase)
            progress = HybridSolverConfig().progress('popup').progressListener;
            testCase.assertInstanceOf(progress, ?PopupHybridProgress)
        end
        
        function testSilentProgressFromString(testCase)
           hybrid.tests.internal.assumeStringsSupported();
           str = string('silent'); %#ok<STRQUOT>
           progress = HybridSolverConfig().progress(str).progressListener;
           testCase.assertInstanceOf(progress, ?SilentHybridProgress)
        end
        
        function testSilentProgressFromCharArray(testCase)
            progress = HybridSolverConfig().progress('silent').progressListener;
            testCase.assertInstanceOf(progress, ?SilentHybridProgress)
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