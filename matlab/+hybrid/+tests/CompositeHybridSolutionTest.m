classdef CompositeHybridSolutionTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testReferencingSubsystemsWithoutNames(testCase)
            dims = [1, 2, 3];
            [sol, subsystems] = createCompositeSolution(dims);            
            testCase.assertLength(sol, length(dims))
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
        
        function testBraceIndexing(testCase)
            % In the hybrid.CompositeHybridSolution class, we mess around with the way
            % objects are indexed, so this test is to verify that we have
            % preserved standard cell array behavior.
            dims = [1, 2, 3];
            sol = createCompositeSolution(dims);
            cellarray = {sol, sol};
            testCase.assertEqual(cellarray{1}, sol);
            testCase.verifyError(@() sol{1}, 'CompositeHybridSolution:subsref')
        end
        
    end

end

function [sol, subs] = createCompositeSolution(dims, names)
import hybrid.tests.internal.*
subs = {};
x0 = {};
for dim = dims
    subs{end+1} = MockHybridSubsystem(dim, 1, 1); %#ok<AGROW>
    x0{end+1} = zeros(dim, 1); %#ok<AGROW>
end

if exist('names', 'var')
    subs_interleaved = cell(1, 2*length(subs));
    for i = 2*(1:length(subs))
        subs_interleaved(i-1) = names(i/2);
        subs_interleaved(i) = subs(i/2);
    end
    subs = subs_interleaved;
end

sys = CompositeHybridSystem(subs{:});

sol = sys.solve(x0, [0, 10], [0, 10]);
end
