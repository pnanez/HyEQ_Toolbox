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
            
            figure('visible','off');
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
            HybridPlotBuilder.defaults.reset();
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
        
        function testWithoutAutoSubplots(testCase)
            pb = HybridPlotBuilder().autoSubplots('off')...
                .title('Title')...
                .label('Label');
            
            % Check plotFlows
            pb.plotFlows(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles('Title')
            testCase.assertSubplotYLabels('Label')
            
            % Check plotJumps
            pb.plotJumps(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles('Title')
            testCase.assertSubplotYLabels('Label')
            
            % Check plotHybrid
            pb.plotHybrid(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles('Title')
            testCase.assertSubplotZLabels('Label')
        end
        
        function testSlice(testCase)
            pb = HybridPlotBuilder()...
                .titles('Title 1', 'Title 2', 'Title 3')...
                .labels('A', 'B', 'C')...
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
                .titles('Title 1', 'Title 2', 'Title 3')...
                .labels('A', 'B', 'C')...
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
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_2;
            HybridPlotBuilder().plotJumps(sol.t, sol.j, -sol.x);
            testCase.assertSubplotCount(2);
            HybridPlotBuilder().plot(sol.t, sol.j, -sol.x);
            testCase.assertSubplotCount(1);
        end
        
        function testPlotSolX(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_3;
            HybridPlotBuilder().plotHybrid(sol, -sol.x);
            testCase.assertSubplotCount(3);
            HybridPlotBuilder().plot(sol, -sol.x);
            testCase.assertSubplotCount(1);
        end
        
        function testPlotSolFncHandWithXArg(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_4;
            HybridPlotBuilder().plotFlows(sol, @(x) [x(2); x(1)]);
            testCase.assertSubplotCount(2);
            HybridPlotBuilder().plot(sol, @(x) [x(2); x(1)]);
            testCase.assertSubplotCount(1);
        end
        
        function testPlotSolFncHandWithXTArg(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_4;
            HybridPlotBuilder().plotHybrid(sol, @(x, t) [x(2)-t; x(1)]);
            testCase.assertSubplotCount(2);
            HybridPlotBuilder().plot(sol, @(x, t) [x(2)-t; x(1)+t]);
            testCase.assertSubplotCount(1);
        end
        
        function plotSolFncHandWithXTJArg(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_4;
            HybridPlotBuilder().plotJumps(sol, @(x, t, j) [x(2)-t*j; x(4)-j]);
            testCase.assertSubplotCount(2);
            HybridPlotBuilder().plot(sol, @(x, t, j) [x(2); t*j; x(1)+t-j]);
            testCase.assertSubplotCount(1);
        end
        
        function testLabelSize(testCase)
           pb = HybridPlotBuilder();
           pb.labelSize(17);
           testCase.assertEqual(pb.settings.label_size, 17);
        end
        
        function testTitleSize(testCase)
           pb = HybridPlotBuilder();
           pb.titleSize(17);
           testCase.assertEqual(pb.settings.title_size, 17);
        end
        
        function testTickLabelSize(testCase)
           pb = HybridPlotBuilder();
           pb.tickLabelSize(17);
           testCase.assertEqual(pb.settings.tick_label_size, 17);
        end
        
        function testSetInterpreters(testCase)
            pb = HybridPlotBuilder();
            % Set individually.
            pb.labelInterpreter('tex');
            pb.titleInterpreter('none');
            pb.tickLabelInterpreter('tex');
            testCase.assertEqual(pb.settings.label_interpreter, 'tex');
            testCase.assertEqual(pb.settings.title_interpreter, 'none');
            testCase.assertEqual(pb.settings.tick_label_interpreter, 'tex');
            % Set both.
            pb.textInterpreter('latex');
            testCase.assertEqual(pb.settings.label_interpreter, 'latex');
            testCase.assertEqual(pb.settings.title_interpreter, 'latex');
            testCase.assertEqual(pb.settings.tick_label_interpreter, 'latex');
        end
        
        function testSetFlowSettings(testCase)
            pb = HybridPlotBuilder()...
                .flowColor('r')...
                .flowLineStyle(':')...
                .flowLineWidth(5);
            testCase.assertEqual(pb.settings.flow_color, 'r');
            testCase.assertEqual(pb.settings.flow_line_style, ':');
            testCase.assertEqual(pb.settings.flow_line_width, 5);
        end
        
        function testSetJumpLineSettings(testCase)
            pb = HybridPlotBuilder()...
                .jumpColor('g')...
                .jumpLineStyle(':')...
                .jumpLineWidth(5);
            testCase.assertEqual(pb.settings.jump_color, 'g');
            testCase.assertEqual(pb.settings.jump_line_style, ':');
            testCase.assertEqual(pb.settings.jump_line_width, 5);
        end
        
        function testSetColor(testCase)
            pb = HybridPlotBuilder().color('cyan');
            testCase.assertEqual(pb.settings.jump_color, 'cyan');
            testCase.assertEqual(pb.settings.flow_color, 'cyan');
        end
        
        function testSetJumpMarkerSettingsStartAndEndTogether(testCase)
            pb = HybridPlotBuilder()...
                .jumpMarker('square')...
                .jumpMarkerSize(12.3);
            testCase.assertEqual(pb.settings.jump_start_marker, 'square');
            testCase.assertEqual(pb.settings.jump_end_marker, 'square');
            testCase.assertEqual(pb.settings.jump_start_marker_size, 12.3);
            testCase.assertEqual(pb.settings.jump_end_marker_size, 12.3);
        end
        
        function testSetJumpSettingsStartAndEndSeparately(testCase)
            pb = HybridPlotBuilder()...
                .jumpStartMarker('o')...
                .jumpEndMarker('+')...
                .jumpStartMarkerSize(0.1)...
                .jumpEndMarkerSize(10);
            testCase.assertEqual(pb.settings.jump_start_marker, 'o');
            testCase.assertEqual(pb.settings.jump_end_marker, '+');
            testCase.assertEqual(pb.settings.jump_start_marker_size, 0.1);
            testCase.assertEqual(pb.settings.jump_end_marker_size, 10);
        end
        
        function testDefaultTextSize(testCase)
            scale = 2.5;
            HybridPlotBuilder.defaults.set(...
                'label Size ', 14, ...
                'title_size', 17, ...
                'tick label size', 3, ...
                'text_scale', scale);

            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.label_size, scale*14);
            testCase.assertEqual(pb.settings.title_size, scale*17);
            testCase.assertEqual(pb.settings.tick_label_size, scale*3);
        end
        
        function testDefaultLineSizes(testCase)
            scale = 6;
            HybridPlotBuilder.defaults.set(...
                'Flow line width', 2, ...
                'jump_line_width', 7, ...
                'line_scale', scale);
%             HybridPlotBuilder.setDefault('marker_scale', 4.0);

            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.flow_line_width, scale*2);
            testCase.assertEqual(pb.settings.jump_line_width, scale*7); 
        end
        
        function testDefaultMarkerSizes(testCase)
            scale = 2;
            HybridPlotBuilder.defaults.set(...
                'jump start marker size', 3, ...
                'jump end marker size', 4, ...
                'marker_scale', scale);

            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.jump_start_marker_size, scale*3);
            testCase.assertEqual(pb.settings.jump_end_marker_size, scale*4); 
        end
        
        function testDefaultColors(testCase)
            HybridPlotBuilder.defaults.set(...
                'flow color', 'k', ...
                'jump color', 'g');
            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.flow_color, 'k');
            testCase.assertEqual(pb.settings.jump_color, 'g'); 
        end
        
        function testDefaultInterpreters(testCase)
            HybridPlotBuilder.defaults.set(...
                'label interpreter', 'tex', ...
                'Title Interpreter', 'none', ...
                'tick label Interpreter', 'none'); 
            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.label_interpreter, 'tex');
            testCase.assertEqual(pb.settings.title_interpreter, 'none');
            testCase.assertEqual(pb.settings.title_interpreter, 'none');
        end
        
        function testSetXLabelFormat(testCase)
            HybridPlotBuilder()...
                .xLabelFormat('$z_{%d}$')...
                .slice([1 3])...
                .plotFlows(testCase.sol_3);
            testCase.assertSubplotYLabels('$z_{1}$', '$z_{3}$')
        end
        
        function testTitlesAsCellArray(testCase)
            titles{1} = 'Title 1';
            titles{3} = 'Title 3';
            HybridPlotBuilder()...
                .titles(titles)...
                .plotFlows(testCase.sol_3);
            testCase.assertSubplotTitles('Title 1', '', 'Title 3')
        end
        
        function testErrorTitlesWithOptions(testCase)
            titles = {'Title 1', 'Title 2'};
            fh = @() HybridPlotBuilder().titles(titles, 'FontSize', 3);
            testCase.verifyError(fh, 'Hybrid:UnexpectedOptions');
        end
        
        function testLabelsAsCellArray(testCase)
            labels{1} = 'Label 1';
            labels{3} = 'Label 3';
            HybridPlotBuilder()...
                .labels(labels)...
                .plotFlows(testCase.sol_3);
            testCase.assertSubplotYLabels('Label 1', '', 'Label 3')
        end
        
        function testErrorLabelsWithOptions(testCase)
            labels = {'Title 1', 'Title 2'};
            fh = @() HybridPlotBuilder().labels(labels, 'FontSize', 3);
            testCase.verifyError(fh, 'Hybrid:UnexpectedOptions');
        end
        
        function testSingleLegend(testCase)
            HybridPlotBuilder()...
                .legend('A legend')...
                .plotFlows(testCase.sol_1);
            testCase.assertLegendLabels('A legend')
        end
        
        function testClearLegend(testCase)
            HybridPlotBuilder()...
                .legend('A legend')...
                .legend()...
                .plotFlows(testCase.sol_1);
            testCase.assertLegendLabels('')
        end
        
        function testLegendsInTwoSubplots(testCase)
            HybridPlotBuilder()...
                .legend('Subplot 1', 'Subplot 2')...
                .plotFlows(testCase.sol_2);
            testCase.assertLegendLabels('Subplot 1', 'Subplot 2');
        end
        
        function testTwoLegendsInTwoSubplots(testCase)
            pb = HybridPlotBuilder();
            pb.legend('Subplot 1.1', 'Subplot 2.1')...
                .plotFlows(testCase.sol_2);
            hold on
            pb.legend('Subplot 1.2', 'Subplot 2.2')...
                .plotFlows(testCase.sol_2);
            testCase.assertLegendLabels({'Subplot 1.1','Subplot 1.2'},...
                                        {'Subplot 2.1','Subplot 2.2'});
        end
        
        function testTwoLegendsInOneSubplot(testCase)
            pb = HybridPlotBuilder();
            pb.legend('Legend 1')...
                .plotFlows(testCase.sol_1);
            hold on
            pb.legend('Legend 2')...
                .plotFlows(testCase.sol_1);
            testCase.assertLegendLabels({'Legend 1', 'Legend 2'})
        end
        
        function testMultipleLegendsIn3DPlot(testCase)
            pb = HybridPlotBuilder();
            pb.legend('Plot 1')...
                .plot(testCase.sol_3);
            hold on
            pb.legend('Plot 2')...
                .plot(testCase.sol_3);
            testCase.assertLegendLabels({'Plot 1', 'Plot 2'})
        end
        
        function testLegendWithoutHold(testCase)
            pb = HybridPlotBuilder();
            pb.legend('Plot 1')...
                .plot(testCase.sol_3);
            hold off
            pb.legend('Plot 2')...
                .plot(testCase.sol_2);
            testCase.assertLegendLabels('Plot 2')
        end
        
        function testWarnTooManyLegendLabelsInPlotFlows(testCase)
            pb = HybridPlotBuilder().legend('Subplot 1', 'Subplot 2', 'Subplot 3');
            testCase.verifyWarning(@() pb.plotJumps(testCase.sol_2), 'HybridPlotBuilder:TooManyLegends');
            testCase.assertLegendLabels('Subplot 1', 'Subplot 2');
        end
        
        function testTooManyLegendLabelsInPhasePlot(testCase)
            pb = HybridPlotBuilder().legend('Subplot 1', 'Subplot 2');
            testCase.verifyWarning(@() pb.plot(testCase.sol_2), ...
                'HybridPlotBuilder:TooManyLegends');
            testCase.assertLegendLabels('Subplot 1')
        end
        
        function testTooFewLegendEntries(testCase)
            pb = HybridPlotBuilder().legend('Subplot 1');
            fh = @() pb.plotJumps(testCase.sol_2);
            testCase.verifyWarning(fh, 'HybridPlotBuilder:TooFewLegends');
            testCase.assertLegendLabels('Subplot 1', '')
        end
        
        function testAddLegendEntry(testCase)
            pb = HybridPlotBuilder().legend('Subplot 1', 'Subplot 2');
            pb.plotJumps(testCase.sol_2);
            hold on
            plt = plot([1, 5], [0, 8]);
            q = quiver(1, 1, -1, 2);
            pb.addLegendEntry(plt, 'A plot') % in subplot 2.
            pb.addLegendEntry(q, 'A quiver') % in subplot 2.
            testCase.assertLegendLabels('Subplot 1', {'Subplot 2', 'A plot', 'A quiver'})
        end
        
        function testLegendsInMultipleFigures(testCase)
            % A single |HybridPlotBuilder| object can be used to add plots and legends to
            % multiple figures.
            pb = HybridPlotBuilder()...
                .legend('First Figure')...
                .plotFlows(testCase.sol_1); % Ignored in second figure
            testCase.assertLegendLabels('First Figure')
            
            figure('visible','off')
            pb.legend('Second Figure')...
                .plotFlows(testCase.sol_1); % Still using 'pb'
            testCase.assertLegendLabels('Second Figure')
        end
        
        function testPlotConfig(testCase)  
            slice_ndxs = [1, 3];
            plt_fnc_callback = @(pb) pb.slice([1, 3]).plotFlows(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, ...
                length(slice_ndxs), num2cell(slice_ndxs))  
            
            slice_ndxs = 1:4;
            plt_fnc_callback = @(pb) pb.slice(slice_ndxs).plotJumps(testCase.sol_4);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, ...
                length(slice_ndxs), num2cell(slice_ndxs))
            
            slice_ndxs = 2;
            plt_fnc_callback = @(pb) pb.slice(2).plotHybrid(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, ...
                length(slice_ndxs), num2cell(slice_ndxs))
        end
        
        function testPlotConfigNoAutoSubplots(testCase)
            plt_fnc_callback = @(pb) pb.autoSubplots('off')...
                                        .slice([3, 2])...
                                        .plotFlows(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, 2, {3, 2})
        end
        
        function testPlotConfigForPlotFunction(testCase)       
            % If there are two or three components, then one plot is drawn and
            % the component id is given as -1.
            plt_fnc_callback = @(pb) pb.autoSubplots('off').plot(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, 1, {-1})
            
            % If there are four or more components, then defaults to plotFlows
            plt_fnc_callback = @(pb) pb.autoSubplots('off').plot(testCase.sol_4);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, 4, {1, 2, 3, 4})
        end
               
        function testHoldOnMaintainedWithAutoSubplots(testCase)
            hold on
            pb = HybridPlotBuilder().autoSubplots('on');
            pb.plotFlows(testCase.sol_2)
            testCase.assertTrue(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertTrue(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(2);
            
            % 'plot' also preserves hold on but resets subplots
            pb.plot(testCase.sol_3);
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(1);
        end
               
        function testHoldOnMaintainedWithoutAutoSubplots(testCase)
            hold on
            pb = HybridPlotBuilder().autoSubplots('off');
            pb.plotFlows(testCase.sol_2)
            testCase.assertTrue(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertTrue(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(1);
            
            % Check 'plot' also preserves hold on and subplots
            pb.plot(testCase.sol_3);
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(1);
        end
        
        function testHoldOffMaintainedWithAutoSubplots(testCase)
            hold off
            pb = HybridPlotBuilder().autoSubplots('on');
            pb.plotFlows(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(2);
            
            % 'plot' also preserves hold off
            pb.plot(testCase.sol_3);
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(1);
        end
        
        function testHoldOffMaintainedWithoutAutoSubplots(testCase)
            hold off
            pb = HybridPlotBuilder().autoSubplots('off');
            pb.plotFlows(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(1);
            
            % 'plot' also preserves hold off
            pb.plot(testCase.sol_3);
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(1);
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
            if ~exist('cols', 'var')
                cols = 1;
            end
            [nrows, ncols] = subplotCount(gcf);
            this.assertEqual(nrows, rows);
            this.assertEqual(ncols, cols);
        end
        
        function assertSubplotTitles(this, varargin)
            this.assertSubplotValues('Title', varargin{:})
        end
        
        function assertSubplotXLabels(this, varargin)
            this.assertSubplotValues('XLabel', varargin{:})
        end
        
        function assertSubplotYLabels(this, varargin)
            this.assertSubplotValues('YLabel', varargin{:})
        end
        
        function assertSubplotZLabels(this, varargin)
            this.assertSubplotValues('ZLabel', varargin{:})
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
            assert(~isempty(varargin), 'Empty legend entries must be entered as empty strings or char arrays')
            labels_expected = varargin;
            legends = findobj(gcf, 'Type', 'Legend');
            subplots = findobj(gcf, 'Type', 'axes');
            function checkLabels(sp, sp_ndx)
                expected_labels = labels_expected{sp_ndx};

                if verLessThan('matlab', '9.1')
                    if numel(subplots) > 1
                        this.assumeFail('Prior to R2016b, we cannot check legend entries on multiple subplots');
                    end
                    if numel(legends) > 1
                        lgd = legends(sp_ndx);
                    else 
                        lgd = legends;
                    end
                else
                    lgd = sp.Legend;
                end

                if isa(lgd, 'matlab.graphics.GraphicsPlaceholder')
                    actual = '';
                else
                    actual = lgd.String;
                    if length(actual) == 1
                        actual = actual{1};
                    end
                end
                this.assertEqual(actual, expected_labels);
            end
            forEachSubplot(@checkLabels);
        end
        
        function assertConfigurePlotsCallbackCalls(testCase, ...
                plot_fnc_callback, expected_call_count, expected_args)
            % Given 'hybrid_plot_builder' assert that the configurePlots
            % callback function is called 'expected_call_count' number of times
            % with arguments matching the entries in 'expected_args' when
            % 'plot_fnc_callback' is called.
            callback_count = 0;
            function config(arg)
                callback_count = callback_count + 1;
                testCase.assertEqual(arg, expected_args{callback_count});
            end
            
            pb = HybridPlotBuilder().configurePlots(@config);
            plot_fnc_callback(pb);
            testCase.assertEqual(callback_count, expected_call_count);
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