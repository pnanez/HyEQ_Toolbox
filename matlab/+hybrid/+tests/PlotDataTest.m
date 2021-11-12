classdef PlotDataTest < matlab.unittest.TestCase
    
    properties
        sol_1
        sol_2
        sol_3
        sol_4
    end
    
    methods
        function this = PlotDataTest()
            t = [linspace(0, 1, 50)'; linspace(1, 2, 50)'];
            j = [zeros(50, 1); ones(50, 1)];
            x = (t + j).^2;
            this.sol_1 = HybridSolution(t, j, x);
            this.sol_2 = HybridSolution(t, j, [1.2*x, 2.2*x]);
            this.sol_3 = HybridSolution(t, j, [1.3*x, 2.3*x, 3.3*x]);
            this.sol_4 = HybridSolution(t, j, [1.4*x, 2.4*x, 3.4*x, 4.4*x]);
        end
    end
    
    methods(TestMethodSetup)
        function setup(testCase) %#ok<MANU>
%             clf
%             HybridPlotBuilder.defaults.reset();
        end
    end
    
    methods (Test)
        function testHybridDomainFromSol(testCase)
            import hybrid.internal.*;
            sol = testCase.sol_3;
            plot_data = PlotData(sol);
            testCase.assertEqual(plot_data.t, sol.t)
            testCase.assertEqual(plot_data.j, sol.j)
        end

        function testPlotArgumentsAllSameForAutoSubplotsOn(testCase)
            import hybrid.internal.*;
            ps = hybrid.PlotSettings();
            ps.set('auto subplots', true, ...
                'flow color', {'r', 'g', 'b'}, ...
                'jump color', {'m', 'y', 'c'});
            sol = testCase.sol_3;
            plot_data = [PlotData(sol); PlotData(sol); PlotData(sol)];
            plot_data.addPlotArguments(ps);
            testCase.assertEqual(plot_data(1).flow_args(2), {'r'})
            testCase.assertEqual(plot_data(2).flow_args(2), {'r'})
            testCase.assertEqual(plot_data(1).jump_args.line(2), {'m'})
            testCase.assertEqual(plot_data(2).jump_args.start(2), {'m'})
            testCase.assertEqual(plot_data(3).jump_args.end(2), {'m'})
        end

        function testPlotArgumentsRotateForAutoSubplotsOff(testCase)
            import hybrid.internal.*;
            ps = hybrid.PlotSettings();
            ps.set('auto subplots', 'off', ...
                'flow color', {'r', 'g', 'b'}, ...
                'jump color', {'m', 'y', 'c'});
            sol = testCase.sol_3;
            plot_data = [PlotData(sol); PlotData(sol); PlotData(sol)];
            plot_data.addPlotArguments(ps);
            % Check flow args
            testCase.assertEqual(plot_data(1).flow_args(2), {'r'})
            testCase.assertEqual(plot_data(2).flow_args(2), {'g'})
            testCase.assertEqual(plot_data(3).flow_args(2), {'b'})
            % Check jump args
            testCase.assertEqual(plot_data(1).jump_args.line(2), {'m'})
            testCase.assertEqual(plot_data(2).jump_args.start(2), {'y'})
            testCase.assertEqual(plot_data(3).jump_args.end(2), {'c'})
        end

        function testAddLabelsTJX(testCase)
            % PlotData.addLabels,does not contain any logic. All the the logic
            % is contained in PlotSettings.generateLabels, so we only do basic
            % testing here and perform more thorough checks in
            % PlotSettings_generateLabelsTest.
            import hybrid.internal.*;
            ps = hybrid.PlotSettings();
            ps.auto_subplots = true; 
            ps.t_label = 'T';
            ps.j_label = 'J';
            ps.component_labels = {'label 1', 'label 2'};
            plot_data = PlotData(testCase.sol_4);
            plot_data.addLabels(ps, {'t', 'j', 2});

            testCase.assertEqual(plot_data.xlabel, 'T')
            testCase.assertEqual(plot_data.ylabel, 'J')
            testCase.assertEqual(plot_data.zlabel, 'label 2')
        end

        function testAxisLimits(testCase)
            import hybrid.internal.*;
            plot_data = PlotData(testCase.sol_4);
            plot_data.addAxisLimits({'t', 'j'})
            testCase.assertEqual(plot_data.xlim, [-inf, inf])
            testCase.assertEqual(plot_data.ylim, [-inf, inf])

            plot_data.addAxisLimits({'t', 1})
            testCase.assertEqual(plot_data.xlim, [-inf, inf])
            testCase.assertEqual(plot_data.ylim, 'auto')

            plot_data.addAxisLimits({4, 1, 5})
            testCase.assertEqual(plot_data.xlim, 'auto')
            testCase.assertEqual(plot_data.ylim, 'auto')
        end
    end
end