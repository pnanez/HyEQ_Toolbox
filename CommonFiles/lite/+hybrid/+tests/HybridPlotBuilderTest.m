classdef HybridPlotBuilderTest < matlab.unittest.TestCase
    
    properties
        sol_1
        sol_2
        sol_3
        sol_4
    end
    
    methods
        function this = HybridPlotBuilderTest()
            close all
            t = [linspace(0, 1, 50)'; linspace(1, 2, 50)'];
            j = [zeros(50, 1); ones(50, 1)];
            x = (t + j).^2;
            this.sol_1 = HybridSolution(t, j, x);
            this.sol_2 = HybridSolution(t, j, [x, x]);
            this.sol_3 = HybridSolution(t, j, [x, x, x]);
            this.sol_4 = HybridSolution(t, j, [x, x, x, x]);
        end
    end
    
    methods(TestMethodSetup)
        function setup(testCase) %#ok<MANU>
            clf
            HybridPlotBuilder.resetDefaults();
        end
    end
    
    methods (Test)
        
        function testAutoSubplotsDefaultOn(testCase)
            pb = HybridPlotBuilder();
            pb.plotFlows(testCase.sol_3);
            testCase.assertSubplotCount(3)
            testCase.assertSubplotTitles('', '', '')
            testCase.assertSubplotYLabels('$x_{1}$', '$x_{2}$', '$x_{3}$')
        end
        
        function testAutoSubplotsOff(testCase)
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
            pb = HybridPlotBuilder()...
                .titles("Title 1", "Title 2", "Title 3")...
                .labels("A", "B", "C")...
                .slice([1 3]);
            pb.plotFlows(testCase.sol_3);
            function check(testCase, plot_dim)
                testCase.assertSubplotCount(2)
                testCase.assertSubplotTitles('Title 1', 'Title 3')
                if plot_dim == 2
                    testCase.assertSubplotYLabels('A', 'C')
                else
                    testCase.assertSubplotZLabels('A', 'C')
                end
            end
            testCase.check3PlottingFunctions(pb, testCase.sol_3, @check)
        end
        
        function testSliceSwitchedOrder(testCase)
            pb = HybridPlotBuilder()...
                .titles("Title 1", "Title 2", "Title 3")...
                .labels("A", "B", "C")...
                .slice([3 1]);
            
            function check(testCase, plot_dim)
                testCase.assertSubplotCount(2)
                testCase.assertSubplotTitles('Title 3', 'Title 1')
                if plot_dim == 2
                    testCase.assertSubplotYLabels('C', 'A')
                else
                    testCase.assertSubplotZLabels('C', 'A')
                end
            end
            
            testCase.check3PlottingFunctions(pb, testCase.sol_3, @check)
        end
        
        function testAutomaticTimeLabels(testCase)
            pb = HybridPlotBuilder();
            function verify(testCase, pb, tlabel, jlabel)
                pb.plotFlows(testCase.sol_2);
                testCase.assertSubplotXLabels(tlabel, tlabel)
                pb.plotJumps(testCase.sol_2);
                testCase.assertSubplotXLabels(jlabel, jlabel)
                pb.plotHybrid(testCase.sol_2);
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
        
        function testPlotFlowsIs2D(testCase)
            HybridPlotBuilder().plotFlows(testCase.sol_3);
            testCase.assert2DSubplots()
        end
        
        function testPlotJumpsIs2D(testCase)
            HybridPlotBuilder().plotJumps(testCase.sol_3);
            testCase.assert2DSubplots()
        end
        
        function testPlotHybridIs3D(testCase)
            HybridPlotBuilder().plotHybrid(testCase.sol_3);
            testCase.assert3DSubplots()
        end
        
        function testPlotAdjustsToDimension(testCase)
            % When there is one dimension, then plotFlows is used, so we
            % expect a 2D plot.
            HybridPlotBuilder().plot(testCase.sol_1)
            testCase.assert2DSubplots()
            
            % When there are two or three dimensions, then the dimension of
            % the plot matches the dimension of the solution.
            HybridPlotBuilder().plot(testCase.sol_2)
            testCase.assert2DSubplots()
            HybridPlotBuilder().plot(testCase.sol_3)
            testCase.assert3DSubplots()
            
            % When there are four dimensions, then plotFlows is used, so we
            % expect a 2D plot.
            HybridPlotBuilder().plot(testCase.sol_4)
            testCase.assert2DSubplots()
        end
        
        function testPlotTJX(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testPlotSolX(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testPlotSolFncHandWithXArg(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testPlotSolFncHandWithXTArg(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function plotSolFncHandWithXTJArg(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testSetFlowSettings(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testSetJumpSettings(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testUseDefaultSettings(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testSetDefaultSettings(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testResetDefaultSettings(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testSetStateLabelFormat(testCase)
            % Rename
            testCase.assumeFail("Incomplete")
        end
        
        function testFilter(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testSingleLegend(testCase)
            HybridPlotBuilder()...
                .legend("A legend")...
                .plotFlows(testCase.sol_1);
            testCase.assertLegendLabels("A legend")
        end
        
        function testLegendsInTwoSubplots(testCase)
            HybridPlotBuilder()...
                .legend("Subplot 1", "Subplot 2")...
                .plotFlows(testCase.sol_2);
            testCase.assertLegendLabels("Subplot 1", "Subplot 2");
        end
        
        function testTwoLegendsInTwoSubplots(testCase)
            pb = HybridPlotBuilder();
            pb.legend("Subplot 1.1", "Subplot 2.1")...
                .plotFlows(testCase.sol_2);
            hold on
            pb.legend("Subplot 1.2", "Subplot 2.2")...
                .plotFlows(testCase.sol_2);
            testCase.assertLegendLabels(["Subplot 1.1","Subplot 1.2"],...
                                        ["Subplot 2.1","Subplot 2.2"]);
        end
        
        function testTwoLegendsInOneSubplot(testCase)
            pb = HybridPlotBuilder();
            pb.legend("Legend 1")...
                .plotFlows(testCase.sol_1);
            hold on
            pb.legend("Legend 2")...
                .plotFlows(testCase.sol_1);
            testCase.assertLegendLabels(["Legend 1", "Legend 2"])
        end
        
        function testMultipleLegendsIn3DPlot(testCase)
            pb = HybridPlotBuilder();
            pb.legend("Plot 1")...
                .plot(testCase.sol_3);
            hold on
            pb.legend("Plot 2")...
                .plot(testCase.sol_3);
            testCase.assertLegendLabels(["Plot 1", "Plot 2"])
        end
        
        function testLegendWithoutHold(testCase)
            pb = HybridPlotBuilder();
            pb.legend("Plot 1")...
                .plot(testCase.sol_3);
            hold off
            pb.legend("Plot 2")...
                .plot(testCase.sol_2);
            testCase.assertLegendLabels("Plot 2")
        end
        
        function testTooManyLegendLabelsInPlotFlows(testCase)
            HybridPlotBuilder().legend("Subplot 1", "Subplot 2", "Subplot 3")...
                .plotJumps(testCase.sol_2);
            testCase.assertLegendLabels("Subplot 1", "Subplot 2")
        end
        
        function testWarnTooManyLegendLabelsInPlotFlows(testCase)
            testCase.assumeFail("Not yet implemented")
            pb = HybridPlotBuilder().legend("Subplot 1", "Subplot 2", "Subplot 3");
            testCase.verifyWarning(@() pb.plotJumps(testCase.sol_2), "");
        end
        
        function testTooManyLegendLabelsInPhasePlot(testCase)
            HybridPlotBuilder().legend("Subplot 1", "Subplot 2")...
                .plot(testCase.sol_2);
            testCase.assertLegendLabels("Subplot 1")
        end
        
        function testWarnTooManyLegendLabelsInPhasePlot(testCase)
            testCase.assumeFail("Not yet implemented")
            pb = HybridPlotBuilder().legend("Subplot 1", "Subplot 2");
            testCase.verifyWarning(@() pb.plot(testCase.sol_2), "");
        end
        
        function testTooFewLegendEntries(testCase)
            pb = HybridPlotBuilder().legend("Subplot 1");
            pb.plotJumps(testCase.sol_2);
            testCase.assertLegendLabels("Subplot 1", "")
        end
        
        function testWarnTooFewLegendEntries(testCase)
            testCase.assumeFail("Not yet implemented")
            pb = HybridPlotBuilder().legend("Subplot 1");
            fh = @() pb.plotJumps(testCase.sol_2);
            testCase.verifyWarning(@() fh, "");
        end
        
        function testAddLegendEntry(testCase)
            pb = HybridPlotBuilder().legend("Subplot 1", "Subplot 2");
            pb.plotJumps(testCase.sol_2);
            hold on
            plt = plot([1, 5], [0, 8]);
            q = quiver(1, 1, -1, 2);
            pb.addLegendEntry(plt, "A plot") % in subplot 2.
            pb.addLegendEntry(q, "A quiver") % in subplot 2.
            testCase.assertLegendLabels("Subplot 1", ["Subplot 2", "A plot", "A quiver"])
        end
        
        function testLegendsInMultipleFigures(testCase)
            % A single |HybridPlotBuilder| object can be used to add plots and legends to
            % multiple figures.
            pb = HybridPlotBuilder()...
                .legend("First Figure")...
                .plotFlows(testCase.sol_1); % Ignored in second figure
            testCase.assertLegendLabels("First Figure")
            
            figure()
            pb.legend("Second Figure")...
                .plotFlows(testCase.sol_1); % Still using "pb"
            testCase.assertLegendLabels("Second Figure")
        end
        
        function testPlotConfig(testCase)
            callback_inargs = {};
            function config(component_ndx)
                callback_inargs{end+1} = component_ndx;
            end
            
            HybridPlotBuilder().configurePlots(@config)...
                .slice([1, 3])...
                .plotFlows(testCase.sol_3);
            testCase.assertEqual(callback_inargs, {1, 3});
        end
        
        function testPlotConfigNoAutoSubplots(testCase)
            callback_inargs = {};
            function config(component_ndx)
                callback_inargs{end+1} = component_ndx;
            end
            
            HybridPlotBuilder().autoSubplots("off")...
                .configurePlots(@config)...
                .slice([3, 2])...
                .plotFlows(testCase.sol_3);
            testCase.assertEqual(callback_inargs, {3, 2});
        end
        
        function testPlotConfigForPlotFunction(testCase)
            callback_inargs = [];
            function config(component_ndxs)
                assert(isempty(callback_inargs), "Should only be called once!")
                callback_inargs = component_ndxs;
            end
            HybridPlotBuilder()...
                .configurePlots(@config)...
                .plot(testCase.sol_3);
            testCase.assertEqual(callback_inargs, 1:3);
        end
        
        function testHoldOnMaintained(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testHoldOffMaintained(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testConfigureSubplots(testCase)
            testCase.assumeFail("Incomplete")
        end
        
        function testCharArrayPassedToLabels(testCase)
            testCase.assumeFail("Incomplete")
        end
        
    end
    
    methods
        function check3PlottingFunctions(testCase, plot_builder, sol, check_fh)
            plot_builder.plotFlows(sol)
            check_fh(testCase, 2)
            plot_builder.plotJumps(sol)
            check_fh(testCase, 2)
            plot_builder.plotHybrid(sol)
            check_fh(testCase, 3)
        end
        
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
        
        function assert2DSubplots(this)
            forEachSubplot(@(sp, ndx) this.assertTrue(is2D(sp)))
        end

        
        function assert3DSubplots(this)
            forEachSubplot(@(sp, ndx) this.assertTrue(is3D(sp)))
        end
        
        function assertLegendLabels(this, varargin)
            labels = varargin;
            function checkLabels(sp, ndx)
                expected_labels = labels{ndx};
                lgd = sp.Legend;
                if isa(lgd, "matlab.graphics.GraphicsPlaceholder")
                    actual = '';
                else
                    actual = char(lgd.String(:));
                end
                
                expected = char(expected_labels(:));
                this.assertEqual(actual, expected);
            end
            forEachSubplot(@checkLabels);
        end
    end
end

function [nrows, ncols] = subplotCount(fig_hand)
subplots = findobj(fig_hand,'type','axes');
N = length(subplots);
for n = 1:N
    pos1(n) = subplots(n).Position(1); %#ok<*AGROW>
    pos2(n) = subplots(n).Position(2);
end
ncols = numel(unique(pos1));
nrows= numel(unique(pos2));
end   

function forEachSubplot(callback)
nrows = subplotCount(gcf());
for i = 1:nrows
    if nrows == 1
        sp = gca();
    else
        sp = subplot(nrows, 1, i);
    end
    callback(sp, i)
end
end

function v = is2D(ax)
v = numel(axis(ax))/2 == 2;
end

function v = is3D(ax)
v = numel(axis(ax))/2 == 3;
end

function val = decell(possible_cell)
% Convert a cell containing a single value, to its entry.
if iscell(possible_cell)
    assert(length(possible_cell) == 1);
    val = possible_cell{1};
else
    val = possible_cell;
end
end