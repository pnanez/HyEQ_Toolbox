classdef makeAxisIdsTest < matlab.unittest.TestCase
   
    methods (Test)
       
        function testTSymbolPreserved(testCase)
            import hybrid.internal.*
            x_ndxs = double.empty(1, 0);
            axis_ids = makeAxisIds(x_ndxs, {'t'});
            testCase.assertEqual(axis_ids, {'t'});
        end

        function testJSymbolPreserved(testCase)
            import hybrid.internal.*
            x_ndxs = double.empty(1, 0);
            axis_ids = makeAxisIds(x_ndxs, {'j'});
            testCase.assertEqual(axis_ids, {'j'});
        end

        function testXSymbolReplaced(testCase)
            import hybrid.internal.*
            x_ndxs = 1;
            axis_ids = makeAxisIds(x_ndxs, {'x'});
            testCase.assertEqual(axis_ids, {1});
        end

        function testXSymbolReplacedMultiplePlots(testCase)
            import hybrid.internal.*
            x_ndxs = [1; 2];
            axis_ids = makeAxisIds(x_ndxs, {'x'});
            testCase.assertEqual(axis_ids, {1; 2});
        end

        function testXSymbolReplacedSinglePlotMultipleIndices(testCase)
            import hybrid.internal.*
            x_ndxs = [1, 2];
            axis_ids = makeAxisIds(x_ndxs, {'x', 'x'});
            testCase.assertEqual(axis_ids, {1, 2});
        end

        function testXSymbolReplacedMultiplePlotsWithTJ(testCase)
            import hybrid.internal.*
            x_ndxs = [1; 2];
            axis_ids = makeAxisIds(x_ndxs, {'t', 'j', 'x'});
            expected = {'t', 'j', 1; 
                        't', 'j', 2};
            testCase.assertEqual(axis_ids, expected);
        end

    end

end