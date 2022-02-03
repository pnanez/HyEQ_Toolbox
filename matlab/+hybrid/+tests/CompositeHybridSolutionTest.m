classdef CompositeHybridSolutionTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testReferencingSubsystemsWithoutNames(testCase)
            dims = [1, 2, 3];
            [sol, subsystems] = createCompositeSolution(dims);            
            testCase.assertEqual(sol.subsys_count, length(dims))
            testCase.assertLength(sol.x(1, :), sum(dims)+length(dims));
            for i = 1:length(dims)
                dim = dims(i);
                ss = subsystems{i};
                testCase.assertLength(sol(i).x(1, :), dim);
                testCase.assertLength(sol(ss).x(1, :), dim);
            end
        end
        
        function testReferencingSubsystemsWithEnd(testCase)
            dims = [2, 3];
            sol = createCompositeSolution(dims);
            testCase.assertLength(sol(end).x(1, :), dims(end));
        end
        
        function testReferencingSubsystemsWithNames(testCase)
            dims = [2, 10];
            names = {'sys 1', 'sys 2'};
            sol = createCompositeSolution(dims, names);            
            for i = 1:length(dims)
                dim = dims(i);
                name = names{i};
                testCase.assertLength(sol(name).x(1, :), dim);
            end
        end
        
        function testPropertyOnSubsystemViaName(testCase)
            dims = [2, 10];
            names = {'sys 1', 'sys 2'};
            sol = createCompositeSolution(dims, names);            
            testCase.assertEqual(sol('sys 1').termination_cause, ...
                                hybrid.TerminationCause.J_REACHED_END_OF_JSPAN)
        end
        
        function testArrayOfSolutions(testCase)
            % In the hybrid.CompositeHybridSolution class, we mess around with the way
            % objects are indexed, so this test is to verify that we have
            % preserved standard array behavior.
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            sol_end = createCompositeSolution(dims);
            
            array = [sol; sol; sol; sol_end];
            testCase.assertEqual(array(1), sol)
            testCase.assertEqual(array(1:2), [sol; sol])
            testCase.assertLength(array, 4)
            testCase.assertEqual(size(array), [4, 1])
            testCase.assertEqual(sol_end, array(end));
        end
        
        function testCellArrayBraceIndexing(testCase)
            % In the hybrid.CompositeHybridSolution class, we mess around with the way
            % objects are indexed, so this test is to verify that we have
            % preserved standard cell array behavior.
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            cellarray = {sol, sol};
            testCase.assertEqual(cellarray{1}, sol);
            testCase.verifyError(@() sol{1}, 'CompositeHybridSolution:subsref')
        end
        
        function testCellArrayParenthesesRangeIndexing(testCase)
            % In the hybrid.CompositeHybridSolution class, we mess around with the way
            % objects are indexed, so this test is to verify that we have
            % preserved standard cell array behavior.
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            cellarray = {sol, sol, sol};
            testCase.assertEqual(cellarray(1:2), {sol, sol});
        end

        function testCellArrayBraceRangeIndexing(testCase)
            % In the hybrid.CompositeHybridSolution class, we mess around with the way
            % objects are indexed, so this test is to verify that we have
            % preserved standard cell array behavior.

            % Brace indexing doesn't work the same way on older versions of
            % MATLAB, so we only run this test on newer versions.
            hybrid.tests.internal.assumeVersion(testCase, 'R2016b');

            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            cellarray = {sol, sol, sol};
            testCase.assertEqual(cellarray{2:3}, {sol, sol});
        end
        
        function testNumEl(testCase)
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            
            % Scalar
            testCase.assertEqual(numel(sol), 1);
            % Row array.
            testCase.assertEqual(numel([sol, sol]), 2);
            % Column array
            testCase.assertEqual(numel([sol; sol]), 2);
            % 2x2 array
            testCase.assertEqual(numel([sol, sol; sol, sol]), 4);
            % Cell array
            testCase.assertEqual(numel({sol, sol, sol}), 3);
        end
        
        function testLength(testCase)
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);

            % Scalar
            testCase.assertEqual(length(sol), 1);
            % Row array.
            testCase.assertEqual(length([sol, sol]), 2);
            % Column array
            testCase.assertEqual(length([sol; sol]), 2);
            % 2x2 array
            testCase.assertEqual(length([sol, sol; sol, sol]), 2);
            % Cell array
            testCase.assertEqual(length({sol, sol, sol}), 3);
        end
        
        function testDotIndexingCompositeProperties(testCase)
            % Check to make sure we still can access the properties on the
            % CompositeHybridSolution.
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            testCase.assertEqual(sol.termination_cause, hybrid.TerminationCause.J_REACHED_END_OF_JSPAN);
        end
        
    end

end

function [sol, subsystems] = createCompositeSolution(dims, names)
import hybrid.tests.internal.*
subsystems = {};
x0 = {};
for dim = dims
    subsystems{end+1} = MockHybridSubsystem(dim, 1, 1); %#ok<AGROW>
    x0{end+1} = zeros(dim, 1); %#ok<AGROW>
end

if exist('names', 'var')
    subs_interleaved = cell(1, 2*length(subsystems));
    for i = 2*(1:length(subsystems))
        subs_interleaved(i-1) = names(i/2);
        subs_interleaved(i) = subsystems(i/2);
    end
    subsystems = subs_interleaved;
end

sys = CompositeHybridSystem(subsystems{:});

sol = sys.solve(x0, [0, 10], [0, 10]);
end
