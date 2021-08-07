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

    end

end