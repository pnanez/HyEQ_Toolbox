classdef HybridPlotBuilderTest < matlab.unittest.TestCase
    
    properties
        sol_1
        sol_2
        sol_3
        sol_4
        fig_cleanup
    end
    
    methods
        function this = HybridPlotBuilderTest()
            close all
            t = [linspace(0, 1, 50)'; linspace(1, 2, 50)'];
            j = [zeros(50, 1); ones(50, 1)];
            x = (t + j).^2;
            this.sol_1 = HybridArc(t, j, x);
            this.sol_2 = HybridArc(t, j, [1.2*x, 2.2*x]);
            this.sol_3 = HybridArc(t, j, [1.3*x, 2.3*x, 3.3*x]);
            this.sol_4 = HybridArc(t, j, [1.4*x, 2.4*x, 3.4*x, 4.4*x]);
        end
    end
    
    methods(TestMethodSetup)
        function setup(testCase) %#ok<MANU>
            clf
            HybridPlotBuilder.defaults.reset();
        end
    end

    methods(TestClassSetup)
        function setupTearDown(testCase)
            testCase.addTeardown(@() close()) % Close the figure
        end
    end
    
    methods (Test)
        function testSubplotsDefaultOff(testCase)
            pb = HybridPlotBuilder();
            pb.plotFlows(testCase.sol_3);
            testCase.assertSubplotCount(1)
            testCase.assertSubplotTitles('')
            testCase.assertSubplotYLabels('')
        end

        function testSubplotsOn(testCase)
            pb = HybridPlotBuilder().subplots('on');
            pb.plotFlows(testCase.sol_3);
            testCase.assertSubplotCount(3)
            testCase.assertSubplotTitles('', '', '')
            testCase.assertSubplotYLabels('$x_{1}$', '$x_{2}$', '$x_{3}$')
        end
        
        function testWithoutSubplots(testCase)
            pb = HybridPlotBuilder().subplots('off')...
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
        
        function testSliceWithSubplots(testCase)
            pb = HybridPlotBuilder().subplots('on')...
                .titles('Title 1', 'Title 2', 'Title 3')...
                .labels('A', 'B', 'C')...
                .select([1 3]);
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


        function testOnlyIntegerTicksOnJ(testCase)
            % For the j-axis, the locations of tickmarks should only be at
            % integers.
            ax = gca();
            ruler = get(ax, 'XAxis');
            if ischar(ruler) || ~isprop(ruler, 'LimitsChangedFcn') ...
                    || ~isprop(ruler, 'TickValues')
                testCase.assumeFail(['On the current version of MATLAB, we ', ...
                    'don''t remove noninteger ticks from the j-axis.']);
            end
            function is_all = allInteger(property_name)
                prop = get(gca(), property_name);
                is_integer = abs(fix(prop) - prop) < 1e-6;
                is_all = all(is_integer);
            end

            % Scale so the y ticks have decimal values.
            sol = testCase.sol_1.transform(@(x) 0.01*x); 
            sol3 = testCase.sol_3.transform(@(x)0.01*x);
            plotJumps(sol);
            testCase.assertTrue(allInteger('XTick')) % j-axis
            testCase.assertFalse(allInteger('YTick'))

            plotFlows(sol);
            testCase.assertFalse(allInteger('XTick'))
            testCase.assertFalse(allInteger('YTick'))

            plotHybrid(sol);
            testCase.assertFalse(allInteger('XTick'))
            testCase.assertTrue(allInteger('YTick')) % j-axis
            testCase.assertFalse(allInteger('ZTick'))

            plotPhase(sol3);
            testCase.assertFalse(allInteger('XTick'))
            testCase.assertFalse(allInteger('YTick'))
            testCase.assertFalse(allInteger('ZTick'))

            plotTimeDomain(sol3);
            testCase.assertFalse(allInteger('XTick'))
            testCase.assertTrue(allInteger('YTick'))% j-axis
        end
        
        function testSliceSwitchedOrderWithSubplots(testCase)
            pb = HybridPlotBuilder().subplots('on')...
                .titles('Title 1', 'Title 2', 'Title 3')...
                .labels('A', 'B', 'C')...
                .select([3 1]);
            
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
        
        function testAutomaticTimeLabelsWithSubplots(testCase)
            pb = HybridPlotBuilder().subplots('on');
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
        
        function testPlotTJX(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_2;
            HybridPlotBuilder().subplots('on').plotJumps(sol.t, sol.j, -sol.x);
            testCase.assertSubplotCount(2);
            clf
            HybridPlotBuilder().plotPhase(sol.t, sol.j, -sol.x);
            testCase.assertSubplotCount(1);
        end
        
        function testPlotSolX(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_3;
            HybridPlotBuilder().subplots('on').plotHybrid(sol, -sol.x);
            testCase.assertSubplotCount(3);
            clf
            HybridPlotBuilder().plotPhase(sol, -sol.x);
            testCase.assertSubplotCount(1);
        end
        
        function testPlotSolFncHandWithXArg(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_4;
            HybridPlotBuilder().subplots('on').plotFlows(sol, @(x) [x(2); x(1)]);
            testCase.assertSubplotCount(2);
            clf
            HybridPlotBuilder().plotPhase(sol, @(x) [x(2); x(1)]);
            testCase.assertSubplotCount(1);
        end
        
        function testPlotSolFncHandWithXTArg(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_4;
            HybridPlotBuilder().subplots('on').plotHybrid(sol, @(x, t) [x(2)-t; x(1)]);
            testCase.assertSubplotCount(2);
            clf
            HybridPlotBuilder().plotPhase(sol, @(x, t) [x(2)-t; x(1)+t]);
            testCase.assertSubplotCount(1);
        end
        
        function plotSolFncHandWithXTJArg(testCase)
            % This is just a smoke test. The selection of the values to plot are
            % tested in convert_varargin_to_solution_objTest.m
            sol = testCase.sol_4;
            HybridPlotBuilder().subplots('on').plotJumps(sol, @(x, t, j) [x(2)-t*j; x(4)-j]);
            testCase.assertSubplotCount(2);
            clf
            HybridPlotBuilder().plotPhase(sol, @(x, t, j) [x(2); t*j; x(1)+t-j]);
            testCase.assertSubplotCount(1);
        end
        
        function testLabelSize(testCase)
           pb = HybridPlotBuilder();
           pb.labelSize(17);
           testCase.assertEqual(pb.settings.label_size, 17);
           pb.last_function_call = []; % To prevent a warning.
        end
        
        function testTitleSize(testCase)
           pb = HybridPlotBuilder();
           pb.titleSize(17);
           testCase.assertEqual(pb.settings.title_size, 17);
           pb.last_function_call = []; % To prevent a warning.
        end
        
        function testTickLabelSize(testCase)
           pb = HybridPlotBuilder();
           pb.tickLabelSize(17);
           testCase.assertEqual(pb.settings.tick_label_size, 17);
           pb.last_function_call = []; % To prevent a warning.
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

            pb.last_function_call = []; % To prevent a warning.
        end
        
        function testSetFlowSettings(testCase)
            pb = HybridPlotBuilder()...
                .flowColor('r')...
                .flowLineStyle(':')...
                .flowMarker('*')...
                .flowMarkerSize(18)...
                .flowLineWidth(5);
            testCase.assertEqual(pb.settings.flow_color, 'r');
            testCase.assertEqual(pb.settings.flow_line_style, ':');
            testCase.assertEqual(pb.settings.flow_marker, '*');
            testCase.assertEqual(pb.settings.flow_marker_size, 18);
            testCase.assertEqual(pb.settings.flow_line_width, 5);
            pb.last_function_call = []; % To prevent a warning.
        end
        
        function testSetJumpLineSettings(testCase)
            pb = HybridPlotBuilder()...
                .jumpColor('g')...
                .jumpLineStyle(':')...
                .jumpLineWidth(5);
            testCase.assertEqual(pb.settings.jump_color, 'g');
            testCase.assertEqual(pb.settings.jump_line_style, ':');
            testCase.assertEqual(pb.settings.jump_line_width, 5);
            pb.last_function_call = []; % To prevent a warning.
        end
        
        function testSetColor(testCase)
            pb = HybridPlotBuilder().color('cyan');
            testCase.assertEqual(pb.settings.jump_color, 'cyan');
            testCase.assertEqual(pb.settings.flow_color, 'cyan');
            pb.last_function_call = []; % To prevent a warning.
        end
        
        function testSetJumpMarkerSettingsStartAndEndTogether(testCase)
            pb = HybridPlotBuilder()...
                .jumpMarker('square')...
                .jumpMarkerSize(12.3);
            testCase.assertEqual(pb.settings.jump_start_marker, 'square');
            testCase.assertEqual(pb.settings.jump_end_marker, 'square');
            testCase.assertEqual(pb.settings.jump_start_marker_size, 12.3);
            testCase.assertEqual(pb.settings.jump_end_marker_size, 12.3);
            pb.last_function_call = []; % To prevent a warning.
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
            pb.last_function_call = []; % To prevent a warning.
        end
        
        function testDefaultTextSize(testCase)
            SCALE = 2.5;
            LABEL_SIZE = 14;
            TITLE_SIZE = 17;
            TICK_LABEL_SIZE = 3;
            HybridPlotBuilder.defaults.set(...
                'label Size ', LABEL_SIZE, ...
                'title_size', TITLE_SIZE, ...
                'tick label size', TICK_LABEL_SIZE, ...
                'text_scale', SCALE);

            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.label_size, SCALE*LABEL_SIZE);
            testCase.assertEqual(pb.settings.title_size, SCALE*TITLE_SIZE);
            testCase.assertEqual(pb.settings.tick_label_size, SCALE*TICK_LABEL_SIZE);
        end
        
        function testDefaultLineSizes(testCase)
            SCALE = 6;
            HybridPlotBuilder.defaults.set(...
                'Flow line width', 2, ...
                'jump_line_width', 7, ...
                'line_scale', SCALE);

            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.flow_line_width, SCALE*2);
            testCase.assertEqual(pb.settings.jump_line_width, SCALE*7); 
        end
        
        function testDefaultMarkerSizes(testCase)
            SCALE = 2;
            HybridPlotBuilder.defaults.set(...
                'jump start marker size', 3, ...
                'jump end marker size', 4, ...
                'marker_scale', SCALE);

            pb = HybridPlotBuilder();
            testCase.assertEqual(pb.settings.jump_start_marker_size, SCALE*3);
            testCase.assertEqual(pb.settings.jump_end_marker_size, SCALE*4); 
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
        
        function testSetXLabelFormatWithSubplots(testCase)
            HybridPlotBuilder().subplots('on')...
                .xLabelFormat('$z_{%d}$')...
                .select([1 3])...
                .plotFlows(testCase.sol_3);
            testCase.assertSubplotYLabels('$z_{1}$', '$z_{3}$')
        end
        
        function testTitlesAsCellArrayWithSubplots(testCase)
            titles{1} = 'Title 1';
            titles{3} = 'Title 3';
            HybridPlotBuilder().subplots('on')...
                .titles(titles)...
                .plotFlows(testCase.sol_3);
            testCase.assertSubplotTitles('Title 1', '', 'Title 3')
        end
        
        function testErrorTitlesWithOptionsWithSubplots(testCase)
            titles = {'Title 1', 'Title 2'};
            pb = HybridPlotBuilder().subplots('on');
            fh = @() pb.titles(titles, 'FontSize', 3);
            testCase.verifyError(fh, 'Hybrid:UnexpectedOptions');
            pb.last_function_call = []; % To prevent a warning.
        end
        
        function testWarnMultipleTitlesWhenAutoSubplotsOff(testCase)
            titles = {'Title 1', 'Title 2'};
            hpb = HybridPlotBuilder().titles(titles);
            fh = @() hpb.plotFlows(testCase.sol_2);
            testCase.verifyWarning(fh, 'Hybrid:ExtraTitles');
        end
        
        function testLabelsAsCellArrayWithSubplots(testCase)
            labels{1} = 'Label 1';
            labels{3} = 'Label 3';
            HybridPlotBuilder().subplots('on')...
                .labels(labels)...
                .plotFlows(testCase.sol_3);
            testCase.assertSubplotYLabels('Label 1', '', 'Label 3')
        end
        
        function testErrorLabelsWithOptions(testCase)
            labels = {'Label 1', 'Label 2'};
            fh = @() HybridPlotBuilder().labels(labels, 'FontSize', 3);
            testCase.verifyError(fh, 'Hybrid:UnexpectedOptions');
        end
        
        function testNoWarnExtraLabelsInPhasePlot(testCase)
            labels = {'Label 1', 'Label 2', 'Label 2'};
            hpb = HybridPlotBuilder().labels(labels).select(1:2);
            fh = @() hpb.plotPhase(testCase.sol_3);
            testCase.verifyWarningFree(fh);
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
            HybridPlotBuilder().subplots('on')...
                .legend('Subplot 1', 'Subplot 2')...
                .plotFlows(testCase.sol_2);
            testCase.assertLegendLabels('Subplot 1', 'Subplot 2');
        end
        
        function testTwoLegendsInTwoSubplots(testCase)
            pb = HybridPlotBuilder().subplots('on');
            pb.legend('Subplot 1.1', 'Subplot 2.1')...
                .plotFlows(testCase.sol_2);
            hold on
            pb.legend('Subplot 1.2', 'Subplot 2.2')...
                .plotFlows(testCase.sol_2);
            testCase.assertLegendLabels({'Subplot 1.1','Subplot 1.2'},...
                                        {'Subplot 2.1','Subplot 2.2'});
        end
        
        function testTwoLegendsInOneSubplot(testCase)
            pb = HybridPlotBuilder().subplots('on');
            pb.legend('Legend 1')...
                .plotTimeDomain(testCase.sol_1);
            hold on
            pb.legend('Legend 2')...
                .plotTimeDomain(testCase.sol_1);
            testCase.assertLegendLabels({'Legend 1', 'Legend 2'})
        end
        
        function testMultipleLegendsIn3DPlot(testCase)
            pb = HybridPlotBuilder();
            pb.legend('Plot 1')...
                .plotPhase(testCase.sol_3);
            hold on
            pb.legend('Plot 2')...
                .plotPhase(testCase.sol_3);
            testCase.assertLegendLabels({'Plot 1', 'Plot 2'})
        end
        
        function testLegendWithoutHold(testCase)
            pb = HybridPlotBuilder();
            pb.legend('Plot 1')...
                .plotPhase(testCase.sol_3);
            hold off
            pb.legend('Plot 2')...
                .plotPhase(testCase.sol_2);
            testCase.assertLegendLabels('Plot 2')
        end
        
        function testExtraLegendLabelsInPhasePlot(testCase)
            pb = HybridPlotBuilder().subplots('on')...
                .legend('Subplot 1', 'Subplot 2');
            testCase.verifyWarning(@() pb.plotPhase(testCase.sol_2), ...
                'Hybrid:ExtraLegendLabels');
            testCase.assertLegendLabels('Subplot 1')
        end
        
        function testTooFewLegendEntries(testCase)
            pb = HybridPlotBuilder().legend('Subplot 1');
            fh = @() pb.plotJumps(testCase.sol_2);
            testCase.verifyWarning(fh, 'Hybrid:MissingLegendLabels');
            testCase.assertLegendLabels('Subplot 1', '')
        end
        
        function testWarnExtraLegendLabelsInPlotFlows(testCase)
            pb = HybridPlotBuilder().subplots('on')...
                .legend('Subplot 1', 'Subplot 2', 'Subplot 3');
            testCase.verifyWarning(@() pb.plotJumps(testCase.sol_2), ...
                'Hybrid:ExtraLegendLabels');
            testCase.assertLegendLabels('Subplot 1', 'Subplot 2');
        end
        
        function testWarnExtraLegendLabelsInPlotTimeDomain(testCase)
            pb = HybridPlotBuilder()...
                .legend('Legend 1', 'Legend 2');
            testCase.verifyWarning(@() pb.plotTimeDomain(testCase.sol_2), ...
                'Hybrid:ExtraLegendLabels');
            testCase.assertLegendLabels('Legend 1');
        end

        function testExistingLegendIsOverwritten(testCase)
            % Make a legend with non-default settings.
            plot(1, 1)
            legend({'A plot'}, 'Location', 'south', 'NumColumns', 2)
            hold on
            
            % Create a plot with a legend using HPB. 
            pb = HybridPlotBuilder().subplots('off');
            pb.legend('Legend 1')...
                .plotFlows(testCase.sol_1);

            % The default legend options are used despite the existing legend,
            % which had non-default settings.
            testCase.assertEqual(gca().Legend.Location, 'northeast');
            testCase.assertEqual(gca().Legend.NumColumns, 1);

            % The legend entry added without the HPB is not included in the
            % final legend.
            testCase.assertLegendLabels('Legend 1')
        end

        function testLegendWithOptionsMultipleSubplots(testCase)
            pb = HybridPlotBuilder().subplots('on');
            pb.legend({'Legend 1', 'Legend 2'}, 'Location', 'best', 'NumColumns', 3)...
                .plotFlows(testCase.sol_2);

            plt_1 = subplot(2, 1, 1);
            testCase.assertEqual(plt_1.Legend.NumColumns, 3);
            testCase.assertEqual(plt_1.Legend.Location, 'best');
            
            plt_2 = subplot(2, 1, 2);
            testCase.assertEqual(plt_2.Legend.NumColumns, 3);
            testCase.assertEqual(plt_2.Legend.Location, 'best');
        end

        function testLegendOptions(testCase)
            pb = HybridPlotBuilder().subplots('on');

            % Call legend without options.
            pb.legend('Legend 1', 'Legend 2')...
                .plotFlows(testCase.sol_2);

            % Check that the defaults are used.
            plt_1 = subplot(2, 1, 1);
            testCase.assertEqual(plt_1.Legend.NumColumns, 1);
            testCase.assertEqual(plt_1.Legend.Location, 'northeast');
            
            plt_2 = subplot(2, 1, 2);
            testCase.assertEqual(plt_2.Legend.NumColumns, 1);
            testCase.assertEqual(plt_2.Legend.Location, 'northeast');

            % Call legendOptions.
            pb.legendOptions('Location', 'best', 'NumColumns', 3)

            % Check that the given options are used.
            plt_1 = subplot(2, 1, 1);
            testCase.assertEqual(plt_1.Legend.NumColumns, 3);
            testCase.assertEqual(plt_1.Legend.Location, 'best');
            
            plt_2 = subplot(2, 1, 2);
            testCase.assertEqual(plt_2.Legend.NumColumns, 3);
            testCase.assertEqual(plt_2.Legend.Location, 'best');

            % Call legend with options.
            pb.legend({'Legend 1', 'Legend 2'}, 'Location', 'south', 'NumColumns', 2)...
                .plotFlows(testCase.sol_2);

            % Check that the given options are used.
            plt_1 = subplot(2, 1, 1);
            testCase.assertEqual(plt_1.Legend.NumColumns, 2);
            testCase.assertEqual(plt_1.Legend.Location, 'south');
            
            plt_2 = subplot(2, 1, 2);
            testCase.assertEqual(plt_2.Legend.NumColumns, 2);
            testCase.assertEqual(plt_2.Legend.Location, 'south');

            % Call legend without options.
            pb.legend('Legend 1', 'Legend 2')...
                .plotFlows(testCase.sol_2);

            % Check that the default options are used.
            plt_1 = subplot(2, 1, 1);
            testCase.assertEqual(plt_1.Legend.NumColumns, 1);
            testCase.assertEqual(plt_1.Legend.Location, 'northeast');
            
            plt_2 = subplot(2, 1, 2);
            testCase.assertEqual(plt_2.Legend.NumColumns, 1);
            testCase.assertEqual(plt_2.Legend.Location, 'northeast');
        end

        function testReorderLegendEntriesSingleSubplot(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('off');
            pb.legend('Legend 1', 'Legend 2', 'Legend 3')...
                .plotFlows(testCase.sol_3);

            % Apply reordering.
            pb.reorderLegendEntries([3 1 2])

            % Check the reordering.
            testCase.assertLegendLabels({'Legend 3', 'Legend 1', 'Legend 2'});
        end

        % The behavior in this test case is a bit weird, but the amount of
        % effort would not be worth the benefit. 
        function testReorderLegendEntriesSingleSubplotWhenAnEntryIsBlank(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('off');
            pb.legend('Legend 1', '', 'Legend 3')...
                .plotFlows(testCase.sol_3);

            % Apply reordering. Only two indices are given because the blank
            % label does not generate a legend entry.
            pb.reorderLegendEntries([2 1])

            % Check the reordering.
            testCase.assertLegendLabels({'Legend 3', 'Legend 1'});
        end

        function testReorderLegendEntriesOmitEntryInSingleSubplot(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('off');
            pb.legend('Legend 1', 'Legend 2', 'Legend 3')...
                .plotFlows(testCase.sol_3);

            % Apply reordering.
            pb.reorderLegendEntries([3 2])

            % Check the reordering.
            testCase.assertLegendLabels({'Legend 3', 'Legend 2'});
        end

        function testReorderLegendEntriesMultipleSubplots(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('on');
            pb.legend('Legend 1', 'Legend 1')...
                .plotFlows(testCase.sol_2);
            hold on
            
            pb.legend('Legend 2', 'Legend 2')...
                .plotFlows(testCase.sol_2);

            pb.legend('Legend 3', 'Legend 3')...
                .plotFlows(testCase.sol_2);

            % Apply reordering.
            pb.reorderLegendEntries([3 1 2])

            % Check the reordering.
            expected_legends = {'Legend 3', 'Legend 1', 'Legend 2'};
            testCase.assertLegendLabels(expected_legends, expected_legends);
        end

        function testReorderLegendEntriesOmitEntryMultipleSubplots(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('on');
            pb.legend('Legend 1', 'Legend 1')...
                .plotFlows(testCase.sol_2);
            hold on
            
            pb.legend('Legend 2', 'Legend 2')...
                .plotFlows(testCase.sol_2);

            pb.legend('Legend 3', 'Legend 3')...
                .plotFlows(testCase.sol_2);

            % Apply reordering.
            pb.reorderLegendEntries([1 2])

            % Check the reordering.
            expected_legends = {'Legend 1', 'Legend 2'};
            testCase.assertLegendLabels(expected_legends, expected_legends);
        end

        function testCircshiftLegendEntriesSingleSubplot(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('off');
            pb.legend('Legend 1', 'Legend 2', 'Legend 3')...
                .plotFlows(testCase.sol_3);

            % Apply positive shift.
            pb.circshiftLegendEntries(1)

            % Check the reordering.
            testCase.assertLegendLabels({'Legend 3', 'Legend 1', 'Legend 2'});

            % Apply negative shift.
            pb.circshiftLegendEntries(-2)

            % Check the reordering.
            testCase.assertLegendLabels({'Legend 2', 'Legend 3', 'Legend 1'});
        end


        function testCircshiftLegendEntriesMultipleSubplots(testCase)
            % Generate plot.
            pb = HybridPlotBuilder().subplots('on');
            pb.legend('Legend 1', 'Legend 1')...
                .plotFlows(testCase.sol_2);
            hold on
            
            pb.legend('Legend 2', 'Legend 2')...
                .plotFlows(testCase.sol_2);

            pb.legend('Legend 3', 'Legend 3')...
                .plotFlows(testCase.sol_2);

            % Apply negative shift.
            pb.circshiftLegendEntries(-1)

            % Check the reordering.
            expected_legends = {'Legend 2', 'Legend 3', 'Legend 1'};
            testCase.assertLegendLabels(expected_legends, expected_legends);

            % Apply positive shift.
            pb.circshiftLegendEntries(2)

            % Check the reordering.
            expected_legends = { 'Legend 3', 'Legend 1', 'Legend 2'};
            testCase.assertLegendLabels(expected_legends, expected_legends);
        end
        
        function testAddLegendEntry(testCase)
            pb = HybridPlotBuilder().subplots('on')...
                .legend('Subplot 1', 'Subplot 2');
            pb.plotJumps(testCase.sol_2);
            hold on
            plt = plot([1, 5], [0, 8]);
            q = quiver(1, 1, -1, 2);
            pb.addLegendEntry(plt, 'A plot') % in subplot 2.
            pb.addLegendEntry(q, 'A quiver') % in subplot 2.
            testCase.assertLegendLabels('Subplot 1', {'Subplot 2', 'A plot', 'A quiver'})
        end
        
        function testAddLegendEntry_failingTest(testCase)
            testCase.assumeTrue(false)
            t_grid = linspace(0.5, 1.5, 15);
            grid_plt = plot(t_grid(:), 0);
            HybridPlotBuilder().addLegendEntry(grid_plt, 'Interpolation grid');
        end
        
        function testLegendsInMultipleFigures(testCase)
            % A single |HybridPlotBuilder| object can be used to add plots and legends to
            % multiple figures. Each legend entry should only appear in the
            % figure that the associated plot is in.
            pb = HybridPlotBuilder()...
                .legend('First Figure')...
                .plotFlows(testCase.sol_1); % Ignored in second figure
            testCase.assertLegendLabels('First Figure')
            
            figure();
            pb.legend('Second Figure')...
                .plotFlows(testCase.sol_1); % Still using 'pb'
            testCase.assertLegendLabels('Second Figure')
            close()
        end
        
        function testPlotConfig(testCase)  
            select_ndxs = [1, 3];
            plt_fnc_callback = @(pb) pb.select([1, 3]).plotFlows(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, ...
                length(select_ndxs), num2cell(select_ndxs))  
            
            select_ndxs = 1:4;
            plt_fnc_callback = @(pb) pb.select(select_ndxs).plotJumps(testCase.sol_4);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, ...
                length(select_ndxs), num2cell(select_ndxs))
            
            select_ndxs = 2;
            plt_fnc_callback = @(pb) pb.select(2).plotHybrid(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, ...
                length(select_ndxs), num2cell(select_ndxs))
        end
        
        function testPlotConfigNosubplots(testCase)
            plt_fnc_callback = @(pb) pb.subplots('off')...
                                        .select([3, 2])...
                                        .plotFlows(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, 2, {3, 2})
        end
        
        function testPlotConfigForPlotFunction(testCase)       
            % If there are two or three components, then one plot is drawn and
            % the component id is given as -1.
            plt_fnc_callback = @(pb) pb.subplots('off').plotPhase(testCase.sol_3);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, 1, {[1, 2, 3]})
            
            % If there are four or more components, then defaults to plotFlows
            plt_fnc_callback = @(pb) pb.subplots('off').plotFlows(testCase.sol_4);
            testCase.assertConfigurePlotsCallbackCalls(plt_fnc_callback, 4, {1, 2, 3, 4})
        end
               
        function testHoldOnMaintainedWithsubplots(testCase)
            hold on
            pb = HybridPlotBuilder().subplots('on');

            pb.plotFlows(testCase.sol_2)
            testCase.assertTrue(ishold())

            pb.plotJumps(testCase.sol_2)
            testCase.assertTrue(ishold())

            pb.plotHybrid(testCase.sol_2)
            testCase.assertTrue(ishold())
            
            % 'plotPhase' also preserves hold on but resets subplots
            testCase.assertSubplotCount(2);
            pb.plotPhase(testCase.sol_3);
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(1);
        end
               
        function testHoldOnMaintainedWithoutsubplots(testCase)
            hold on
            pb = HybridPlotBuilder().subplots('off');
            pb.plotFlows(testCase.sol_2)
            testCase.assertTrue(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertTrue(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(1);
            
            % Check 'plot' also preserves hold on and subplots
            pb.plotPhase(testCase.sol_3);
            testCase.assertTrue(ishold())
            testCase.assertSubplotCount(1);
        end
        
        function testHoldOffMaintainedWithsubplots(testCase)
            hold off
            pb = HybridPlotBuilder().subplots('on');
            pb.plotFlows(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(2);
            
            % 'plot' also preserves hold off
            pb.plotPhase(testCase.sol_3);
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(1);
        end
        
        function testHoldOffMaintainedWithoutsubplots(testCase)
            hold off
            pb = HybridPlotBuilder().subplots('off');
            pb.plotFlows(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotJumps(testCase.sol_2)
            testCase.assertFalse(ishold())
            pb.plotHybrid(testCase.sol_2)
            testCase.assertFalse(ishold())
            testCase.assertSubplotCount(1);
            
            % 'plot' also preserves hold off
            pb.plotPhase(testCase.sol_3);
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
            function config(~, arg)
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
if N == 0
    ncols = 0;
    nrows = 0;
else
    for n = 1:N
        pos1(n) = subplots(n).Position(1); %#ok<*AGROW>
        pos2(n) = subplots(n).Position(2);
    end
    ncols = numel(unique(pos1));
    nrows= numel(unique(pos2));
end
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