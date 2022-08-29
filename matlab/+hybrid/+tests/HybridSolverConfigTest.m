classdef HybridSolverConfigTest < matlab.unittest.TestCase
    
    methods (Test) % Test Method Block
        
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
            testCase.verifyError(f, 'Hybrid:expectedNonnegative');
        end
        
        function testAbsTolInConstructor(testCase)
           options = HybridSolverConfig('AbsTol', 1e-4).ode_options;
           default_options = odeset('AbsTol', 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidAbsTolInConstructor(testCase)
            f = @() HybridSolverConfig('AbsTol', -5);
            testCase.verifyError(f, 'Hybrid:expectedNonnegative');
        end
        
        function testMaxStepInConstructor(testCase)
           options = HybridSolverConfig('MaxStep', 1e-4).ode_options;
           default_options = odeset('MaxStep', 1e-4);
           testCase.assertEqual(options, default_options)
        end
        
        function testInvalidMaxStepInConstructor(testCase)
            f = @() HybridSolverConfig('MaxStep', -5);
            testCase.verifyError(f, 'Hybrid:expectedNonnegative');
        end
        
        function testMaxStepFromStringInConstructor(testCase)
            % The 'string' class was added in MATLAB R2016b. 
            hybrid.tests.internal.assumeVersion(testCase, 'R2016b') 

            config = HybridSolverConfig(string('MaxStep'), 1e-3); %#ok<STRQUOT>
            expected_options = odeset('MaxStep', 1e-3);
            testCase.assertEqual(config.ode_options, expected_options)
        end
        
        % Test Refine option
        
        function testRefine(testCase)
            config = HybridSolverConfig();
            config.Refine(14);
            expected_options = odeset('Refine', 14);
            testCase.assertEqual(config.ode_options, expected_options)
        end
        
        function testRefineInvalid(testCase)
            config = HybridSolverConfig();
            testCase.verifyError(@() config.Refine(0), 'Hybrid:expectedPositive');
            testCase.verifyError(@() config.Refine(1.443), 'Hybrid:expectedInteger');
        end
        
        function testRefineInConstructor(testCase)
            config = HybridSolverConfig('Refine', 12);
            expected_options = odeset('Refine', 12);
            testCase.assertEqual(config.ode_options, expected_options)
        end
        
        function testOtherOdeOptions(testCase)
            config = HybridSolverConfig();
            config.odeOption('JConstant', true);
            expected_options = odeset('JConstant', true);
            testCase.assertEqual(config.ode_options, expected_options)
        end
        
        function testOdeSolver(testCase)
            config = HybridSolverConfig();
            config.odeSolver('ode23');
            testCase.assertEqual(config.ode_solver, 'ode23')
        end
        
        function testOdeSolverInvalid(testCase)
            config = HybridSolverConfig();
            testCase.verifyError(@()config.odeSolver('ode15i'), 'Hybrid:InvalidOdeSolver')
        end
        
        function testPriority(testCase)
            config = HybridSolverConfig();
            config.priority(hybrid.Priority.JUMP);
            testCase.assertEqual(config.hybrid_priority, hybrid.Priority.JUMP)
            config.priority(hybrid.Priority.FLOW);
            testCase.assertEqual(config.hybrid_priority, hybrid.Priority.FLOW)
            config.priority('jump');
            testCase.assertEqual(config.hybrid_priority, hybrid.Priority.JUMP)
            config.priority('FLOW');
            testCase.assertEqual(config.hybrid_priority, hybrid.Priority.FLOW)
            config.priority(1);
            testCase.assertEqual(config.hybrid_priority, hybrid.Priority.JUMP)
            config.priority(2);
            testCase.assertEqual(config.hybrid_priority, hybrid.Priority.FLOW)
            
            testCase.verifyError(@() config.priority('not enumeration value'), 'MATLAB:class:CannotConvert')
        end
        
        function testMassMatrix(testCase)
            config = HybridSolverConfig();
            config.massMatrix(magic(2));
            testCase.assertEqual(config.mass_matrix, magic(2))
        end
        
        function testDefaultProgress(testCase)
           progress = HybridSolverConfig().progressListener;
           metaclass = ?hybrid.PopupProgressUpdater;
           testCase.assertInstanceOf(progress, metaclass)
        end
        
        function testPopupProgressFromString(testCase)
            % The 'string' class was added in MATLAB R2016b. 
            hybrid.tests.internal.assumeVersion(testCase, 'R2016b') 

            str = string('popup'); %#ok<STRQUOT>
            progress = HybridSolverConfig().progress(str).progressListener;
            testCase.assertInstanceOf(progress, ?hybrid.PopupProgressUpdater)
        end
        
        function testPopupProgressFromCharArray(testCase)
            progress = HybridSolverConfig().progress('popup').progressListener;
            testCase.assertInstanceOf(progress, ?hybrid.PopupProgressUpdater)
        end
        
        function testSilentProgressFromString(testCase)
            % The 'string' class was added in MATLAB R2016b. 
            hybrid.tests.internal.assumeVersion(testCase, 'R2016b') 
            
            str = string('silent'); %#ok<STRQUOT>
            progress = HybridSolverConfig().progress(str).progressListener;
            testCase.assertInstanceOf(progress, ?hybrid.SilentProgressUpdater)
        end
        
        function testSilentProgressFromCharArray(testCase)
            progress = HybridSolverConfig().progress('silent').progressListener;
            testCase.assertInstanceOf(progress, ?hybrid.SilentProgressUpdater)
        end
        
        function testProgressFromObject(testCase)
           popupProgress = hybrid.PopupProgressUpdater();
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

        function testNoOutputWhenNoSemicolonAndNoAssignment(testCase)
            function call()
                config = HybridSolverConfig();
                config.progress('popup', 3) % no semicolon.
                config.odeSolver('ode23s') % no semicolon.
                config.priority('flow') % no semicolon.
                config.RelTol(1e-4) % no semicolon.
                config.AbsTol(1e-4) % no semicolon.
                config.MaxStep(1e-4) % no semicolon.
                config.Refine(12) % no semicolon.
                config.odeOption('Jacobian', eye(2)) % no semicolon.
                config.massMatrix(magic(3)) % no semicolon.
                config.progress(hybrid.SilentProgressUpdater()) % no semicolon.
                config.progress('silent') % no semicolon.
                config.progress('popup', 4) % no semicolon.
                fprintf('Finished.');
            end
            output = evalc('call');
            testCase.assertEqual(output, 'Finished.')
            
        end
        
    end

end