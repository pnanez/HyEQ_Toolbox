classdef HybridPlotBuilderTest < matlab.unittest.TestCase

    properties
       sol_1
       sol_2
       sol_3
    end
    
    methods
        function this = HybridPlotBuilderTest()
            close all
            t = linspace(0, 1)';
            j = zeros(100, 1);
            x = linspace(0, 10)';
            this.sol_1 = HybridSolution(t, j, x);
            this.sol_2 = HybridSolution(t, j, [x, x]);
            this.sol_3 = HybridSolution(t, j, [x, x, x]);
        end 
    end
    
    methods (Test)
        
        function testAutoSubplotsDefaultOn(testCase)  
            clf
            pb = HybridPlotBuilder();
            pb.plotFlows(testCase.sol_3)
            testCase.assertSubplotCount(3)
            testCase.assertSubplotTitles('', '', '')
        end
        
        function testAutoSubplotsOff(testCase) 
            clf   
            pb = HybridPlotBuilder().autoSubplots("off")...
                .title("Title")...
                .label('Label');
            
            % Check plotFlows
            pb.plotFlows(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles("Title")
            testCase.assertSubplotYLabels("Label")
            
            % Check plotJumps
            pb.plotJumps(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles("Title")
            testCase.assertSubplotYLabels("Label")
            
            % Check plotHybrid
            pb.plotHybrid(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles("Title")
            testCase.assertSubplotZLabels("Label")
        end
        
        function testSlice(testCase)  
            clf
            pb = HybridPlotBuilder()...
                .titles("Title 1", "Title 2", "Title 3")...
                .labels("A", "B", "C")...
                .slice([1 3]);
            pb.plotFlows(testCase.sol_3)
            testCase.assertSubplotCount(2)
            testCase.assertSubplotTitles('Title 1', 'Title 3')
            testCase.assertSubplotYLabels('A', 'C')
        end
        
        function testAutomaticTimeLabels(testCase)  
            clf
            pb = HybridPlotBuilder();
            function verify(testCase, pb, tlabel, jlabel)
                pb.plotFlows(testCase.sol_2)
                testCase.assertSubplotXLabels(tlabel, tlabel)
                pb.plotJumps(testCase.sol_2)
                testCase.assertSubplotXLabels(jlabel, jlabel)
                pb.plotHybrid(testCase.sol_2)
                testCase.assertSubplotXLabels(tlabel, tlabel)
                testCase.assertSubplotYLabels(jlabel, jlabel)
            end
            verify(testCase, pb, '$t$', '$j$');
            pb.labelInterpreter('none');
            verify(testCase, pb, 't', 'j');
            pb.labelInterpreter('latex');
            verify(testCase, pb, '$t$', '$j$');
            pb.labelInterpreter('tex');
            verify(testCase, pb, 't', 'j');
        end
         
    end
    
    methods
        function assertSubplotCount(this, rows, cols)
            if ~exist("cols", "var")
                cols = 1;
            end
            [nrows, ncols] = subplotCount(gcf);
            this.assertEqual(nrows, rows);
            this.assertEqual(ncols, cols);
        end
        
        function assertSubplotTitles(this, varargin)
            this.assertSubplotValues("Title", varargin{:})
        end
        
        function assertSubplotXLabels(this, varargin)
            this.assertSubplotValues("XLabel", varargin{:})
        end
        
        function assertSubplotYLabels(this, varargin)
            this.assertSubplotValues("YLabel", varargin{:})
        end
        
        function assertSubplotZLabels(this, varargin)
            this.assertSubplotValues("ZLabel", varargin{:})
        end
        
        function assertSubplotValues(this, key, varargin)
            nrows = subplotCount(gcf);
            this.assertGreaterThanOrEqual(nrows, length(varargin));
            for n = 1:nrows
                if nrows == 1
                    sp = gca();
                else
                    sp = subplot(nrows, 1, n);
                end
                value = decell(sp.(key).String);
                expected = char(varargin{n});
                if length(varargin) < n || isempty(varargin{n})
                    this.assertEmpty(value)
                else
                    this.assertEqual(value, expected)
                end
            end
        end
    end

end 

function [nrows, ncols] = subplotCount(h)
N = length(h.Children);
for n = 1:N
    pos1(n) = h.Children(n).Position(1); %#ok<*AGROW>
    pos2(n) = h.Children(n).Position(2);
end
ncols = numel(unique(pos1));
nrows= numel(unique(pos2));
end

function val = decell(possible_cell)
    if iscell(possible_cell)
        assert(length(possible_cell) == 1);
        val = possible_cell{1};
    else 
       val = possible_cell; 
    end
end