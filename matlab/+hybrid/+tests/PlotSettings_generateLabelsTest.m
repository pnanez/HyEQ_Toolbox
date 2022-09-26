classdef PlotSettings_generateLabelsTest < matlab.unittest.TestCase
        
    methods (Test)

        function testTJXAutoSubplotsOn(testCase)
            import hybrid.*;
            ps = PlotSettings();
            ps.auto_subplots = true; 
            ps.t_label = 'T';
            ps.j_label = 'J';
            ps.component_labels = {'label 1', 'label 2'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({'t', 'j', 2});

            testCase.assertEqual(xlabel, 'T')
            testCase.assertEqual(ylabel, 'J')
            testCase.assertEqual(zlabel, 'label 2')
        end

        function testTXAutoSubplotsOn(testCase)
            import hybrid.*;
            ps = PlotSettings();
            ps.auto_subplots = true; 
            ps.t_label = 'T';
            ps.component_labels = {'label 1', 'label 2'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({'t', 1});

            testCase.assertEqual(xlabel, 'T')
            testCase.assertEqual(ylabel, 'label 1')
            testCase.assertEqual(zlabel, [])
        end

        function testXXAutoSubplotsOn(testCase)
            import hybrid.*;
            ps = PlotSettings();
            ps.auto_subplots = true; 
            ps.component_labels = {'label 1', 'label 2'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({2, 1});

            testCase.assertEqual(xlabel, 'label 2')
            testCase.assertEqual(ylabel, 'label 1')
            testCase.assertEqual(zlabel, [])
        end

        function testXXXAutoSubplotsOn(testCase)
            import hybrid.*;
            ps = PlotSettings();
            ps.auto_subplots = true; 
            ps.component_labels = {'label 1', 'label 2', 'label 3'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({2, 1, 3});

            testCase.assertEqual(xlabel, 'label 2')
            testCase.assertEqual(ylabel, 'label 1')
            testCase.assertEqual(zlabel, 'label 3')
        end

        function testTJXAutoSubplotsOff(testCase)
            import hybrid.*;
            ps = PlotSettings();
            % ps.auto_subplots = false; % Default
            ps.t_label = 'T';
            ps.j_label = 'J';
            ps.component_labels = {'label 1', 'label 2'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({'t', 'j', 2});

            testCase.assertEqual(xlabel, 'T')
            testCase.assertEqual(ylabel, 'J')
            testCase.assertEqual(zlabel, 'label 1')
        end

        function testTXAutoSubplotsOff(testCase)
            import hybrid.*;
            ps = PlotSettings();
            % ps.auto_subplots = false; % Default
            ps.t_label = 'T';
            ps.component_labels = {'label 1', 'label 2'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({'t', 3});

            testCase.assertEqual(xlabel, 'T')
            testCase.assertEqual(ylabel, 'label 1')
            testCase.assertEqual(zlabel, [])
        end

        function testXXAutoSubplotsOff(testCase)
            import hybrid.*;
            ps = PlotSettings();
            % ps.auto_subplots = false; % Default
            ps.component_labels = {'label 1', 'label 2'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({2, 1});

            testCase.assertEqual(xlabel, 'label 2')
            testCase.assertEqual(ylabel, 'label 1')
            testCase.assertEqual(zlabel, [])
        end

        function testXXXAutoSubplotsOff(testCase)
            import hybrid.*;
            ps = PlotSettings();
            % ps.auto_subplots = false; % Default
            ps.component_labels = {'label 1', 'label 2', 'label 3'};
            [xlabel, ylabel, zlabel] = ps.generateLabels({2, 1, 3});

            testCase.assertEqual(xlabel, 'label 2')
            testCase.assertEqual(ylabel, 'label 1')
            testCase.assertEqual(zlabel, 'label 3')
        end
    end
end