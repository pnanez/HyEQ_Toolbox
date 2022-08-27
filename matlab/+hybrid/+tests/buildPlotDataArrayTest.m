classdef buildPlotDataArrayTest < matlab.unittest.TestCase
    
    properties
        sol_1
        sol_2
        sol_3
        sol_4
    end
    
    methods
        function this = buildPlotDataArrayTest()
            t = [linspace(0, 1, 50)'; linspace(1, 2, 50)'];
            j = [zeros(50, 1); ones(50, 1)];
            x = (t + j).^2;
            this.sol_1 = HybridArc(t, j, x);
            this.sol_2 = HybridArc(t, j, [1.2*x, 2.2*x]);
            this.sol_3 = HybridArc(t, j, [1.3*x, 2.3*x, 3.3*x]);
            this.sol_4 = HybridArc(t, j, [1.4*x, 2.4*x, 3.4*x, 4.4*x]);
        end
    end

    methods (Test)

        function testWarnMultipleLabelsWhenAutoSubplotsOff(testCase)
            x_label_ndxs = [1, 2, 3];
            plotSettings = plotSettingsWithLabels('Label 1', 'Label 2');
            fh = @() hybrid.internal.buildPlotDataArray( ...
                {'t', 'x'}, x_label_ndxs, testCase.sol_3, plotSettings);
            testCase.verifyWarning(fh, 'Hybrid:ExtraLabels');
        end   

        function testNoWarnMultipleLabelsWhenAutoSubplotsOffIfPhasePlot(testCase)
            plotSettings = plotSettingsWithLabels('Label 1', 'Label 2');
            fh = @() hybrid.internal.buildPlotDataArray( ...
                {'x', 'x'}, [1, 2], testCase.sol_2, plotSettings);
            testCase.verifyWarningFree(fh);
        end
        
        function testWarnExtraLabels(testCase)
            plotSettings = plotSettingsWithLabels('Label 1', 'Label 2', 'Label 2');
            fh = @() hybrid.internal.buildPlotDataArray( ...
                {'t', 'x'}, [1, 2], testCase.sol_2, plotSettings);
            testCase.verifyWarning(fh, 'Hybrid:ExtraLabels');
        end
    end
end

function plotSettings = plotSettingsWithLabels(varargin)
    plotSettings = hybrid.PlotSettings();
    plotSettings.component_labels = varargin;
end
