classdef HybridSolutionTest < matlab.unittest.TestCase
    
    properties
        dummySystem = HybridSystemBuilder().build();
    end

    methods (Test)

        %%%%%%%%%%%%%%%% Test jump_times and dwell_times %%%%%%%%%%%%%%%%%
        % Thorough testing of jump time and dwell time calculations are in
        % jumpTimesTest.m and dwellTimesTest.m. The tests here simply
        % verify that the HybridSolution class is wired up correctly.
        function testJumpTimes(testCase)
            t = linspace(0, 12, 5)'; % Not important
            j = [0; 1; 1; 1; 2]; % Jump at second index
            x = zeros(5, 1); % Not important
            sol = HybridSolution(testCase.dummySystem, t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(sol.jump_times, [t(2); t(5)])
        end

        function testDwellTimes(testCase)
            t = [0; 0.5; 0.5; 2; 3; 3; 4];
            j = [0;   0;   1; 1; 1; 2; 2];
            x = zeros(7, 1); % Not important
            sol = HybridSolution(testCase.dummySystem, t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(sol.dwell_times, [0.5; 2.5; 1])
            testCase.assertEqual(sol.min_dwell_time, 0.5)
        end

        %%%%%%%%%%%%%%%% Test Data Validation %%%%%%%%%%%%%%%%%

        function testInconsistenVectorLengths(testCase)
            % We define vectors that are all the same length...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 1);
            % ... then truncate them one at a time to make them not match.
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t(1:2), j, x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t, j(1:2), x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t, j, x(1:2), [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
        end

        function testTimeVectorsOfWrongShape(testCase)
            % We make column vectors...
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = zeros(3, 1);
             % ...then transpose t and j one at a time to make them row vectors.
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t', j, x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
            testCase.verifyError(@()HybridSolution(testCase.dummySystem, t, j', x, [0, 100], [0, 100]), ...
                    'HybridSolution:WrongShape')
        end

        %%%%%%%%%%%%% Test TerminationCause Identification %%%%%%%%%%%%%%
        % We only need to test that this works in one case, because all the
        % various cases are tested in TerminationCauseTest.m
        function testTerminationCause(testCase)
            t = linspace(0, 12, 3)'; 
            j = zeros(3, 1); 
            x = [0; 1; inf];
            sol = HybridSolution(testCase.dummySystem, t, j, x, [0, 100], [0, 100]);
            testCase.assertEqual(sol.termination_cause, TerminationCause.STATE_IS_INFINITE)
        end

    end

end