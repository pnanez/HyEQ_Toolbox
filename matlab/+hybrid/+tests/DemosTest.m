classdef DemosTest < matlab.unittest.TestCase
    
    methods (Test)
       
        function testHybridSystem_demo(testCase) %#ok<MANU> 
            set(groot,'defaultFigureVisible','off')
            evalc('HybridSystem_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
        function testCompositeHybridSystem_demo(testCase) %#ok<MANU> 
            set(groot,'defaultFigureVisible','off')
            evalc('CompositeHybridSystem_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
        function testHybridPlotBuilder_demo(testCase) %#ok<MANU> 
            set(groot,'defaultFigureVisible','off')
            evalc('HybridPlotBuilder_demo()'); % Run without printing to terminal.
            set(groot,'defaultFigureVisible','on')
        end
        
    end

end