classdef PlotSettingsTest < matlab.unittest.TestCase
       
    methods (Test)
        
        function testResetDefaultSettings(testCase)
            settings = hybrid.internal.PlotSettings();
            settings.set(...
                'label Size ', 14, ...
                'title_size', 17, ...
                'label interpreter', 'tex', ...
                'Title Interpreter', 'none',...
                'Flow line width', 2, ...
                'Flow line style', 's', ...
                'flow color', 'k', ...
                'jump color', 'g',...
                'jump_line_width', 7, ...
                'jump_line_style', 'none', ...
                'jump start marker', 'o', ...
                'jump start marker size', 3, ...
                'jump end marker', 'o', ...
                'jump end marker size', 3, ...
                't label', 'T', ...
                'j label', 'J', ...
                'x label format', 'z{%d}', ...
                'text_scale', 1.3, ...
                'line_scale', 4, ...
                'marker_scale', 9);
            settings.reset();
            function assertEqualToDefault(name)
                default_name = ['DEFAULT_',upper(name)];
                testCase.assertEqual(settings.(name), settings.(default_name), ...
                    ['Setting ', name, ' does not match default']);
            end

            names = hybrid.internal.PlotSettings.getSettingNames();
            for n = names
                assertEqualToDefault(n{1});
            end
        end
        
        function testSetWithStrings(testCase)
            hybrid.tests.internal.assumeStringsSupported();
            ps = hybrid.internal.PlotSettings();
            ps.set(...
                string('label interpreter'), string('tex'), ...
                'title interpreter', string('none'), ...
                'jump color', string('g'),...
                'j label', string('J')); %#ok<STRQUOT>
            
            testCase.assertEqual(ps.label_interpreter, 'tex')
            testCase.assertEqual(ps.title_interpreter, 'none')
            testCase.assertEqual(ps.jump_color, 'g')
            testCase.assertEqual(ps.j_label, 'J')
        end
        
        function testErrorSetNonexistentProperty(testCase)
            % Check that there is an error if the property doesn't exist.
            import hybrid.internal.*
            % Moving the constructor within the no_property_fh function handle,
            % here, causes problems on older versions of Matlab (namely, 2016a). 
            ps = PlotSettings(); 
            no_property_fh = @() ps.set('not a property', 45);
            testCase.verifyError(no_property_fh, 'MATLAB:noPublicFieldForClass');            
        end
        
        function testErrorMissingValue(testCase)
            import hybrid.internal.*
            % Moving the constructor within the no_property_fh function handle,
            % here, causes problems on older versions of Matlab (namely, 2016a). 
            ps = PlotSettings();
            no_property_fh = @() ps.set('line width');
            testCase.verifyError(no_property_fh, 'Hybrid:MissingValue');            
        end
        
        function testErrorNameNotString(testCase)
            import hybrid.internal.*
            % Moving the constructor within the no_property_fh function handle,
            % here, causes problems on older versions of Matlab (namely, 2016a). 
            ps = PlotSettings();
            no_property_fh = @() ps.set('text scale', 3, 5, 6);
            testCase.verifyError(no_property_fh, 'Hybrid:NameNotString');            
        end
        
        function testCopyable(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            ps_copy = ps.copy();
            ps.flow_color = 'g';
            ps_copy.jump_color = 'black';
            testCase.assertNotEqual(ps.flow_color, ps_copy.flow_color)
            testCase.assertNotEqual(ps.jump_color, ps_copy.jump_color)
        end
        
        % TEST SET PROPERTY VALIDATION
        
        function testConvertToNone(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            function check(name)
               ps.set(name, '')
               testCase.assertEqual(ps.get(name), 'none')
               ps.reset();
               ps.set(name, [])
               testCase.assertEqual(ps.get(name), 'none')
            end
            check('flow_color');
            check('flow_line_style');
            check('jump_color');
            check('jump_line_style');
            check('jump_start_marker');
            check('jump_end_marker');
            
        end
        
        function testCheckColor(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            
            % Check valid colors
            ps.flow_color = 'black';
            ps.jump_color = 'm';
            ps.flow_color = [0 1 0.3];
            ps.flow_color = 'none';
            ps.flow_color = [];
            ps.flow_color = {};
            
            % Check invalid color, except on versions of Matlab before 9.9 (R2020b).
            if ~verLessThan('matlab', '9.9')
                testCase.verifyError(@() ps.set('flow_color', 'blurg'),...
                    'Hybrid:InvalidColor');
                testCase.verifyError(@() ps.set('flow_color', [1.5 0 0]),...
                    'Hybrid:InvalidColor');
                testCase.verifyError(@() ps.set('flow_color', [0 0.1, 0.2, 0.3]),...
                    'Hybrid:InvalidColor');
            end
        end
        
        function testCheckInterpreters(testCase)
            import hybrid.internal.*
            ps = PlotSettings(); 
            
            % Strings and char arrays are OK
            ps.set('title_interpreter', 'tex')
            ps.set('title_interpreter', 'tex')
            
            % Must be one of 'none', 'text', or 'latex'.
            testCase.verifyError(@() ps.set('title_interpreter', 'blurg'),...
                                    'Hybrid:InvalidInterpreter');
            testCase.verifyError(@() ps.set('label_interpreter', 'blarg'),...
                                    'Hybrid:InvalidInterpreter');
        end
        
        function testSetAutoSubplots(testCase)
            import hybrid.internal.*
            ps = PlotSettings(); 
            function assertSet(arg, logical_value)
                ps.set('auto_subplots', arg)
                testCase.assertEqual(ps.auto_subplots, logical_value)
            end
            assertSet('off', false)
            assertSet('on', true)
            assertSet(0, false)
            assertSet(1, true)
            assertSet(false, false)
            assertSet(true, true)
            testCase.verifyError(@() ps.set('auto_subplots', 'blarg'), '');
            testCase.verifyError(@() ps.set('auto_subplots', 2), '');
            testCase.verifyError(@() ps.set('auto_subplots', [1 2]), '');
            testCase.verifyError(@() ps.set('auto_subplots', [true false]), '');
        end
        
        function testSetLegendAsString(testCase)
            import hybrid.internal.*
            ps = PlotSettings(); 
            ps.component_legend_labels = {"String 1", "String 2"}; %#ok<CLARRSTR>
            testCase.assertEqual(ps.component_legend_labels, {'String 1', 'String 2'});
        end
        
        % TEST GET LABELS
        
        function testTLabel(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            testCase.assertEqual(ps.getTLabel(), '$t$')
            ps.label_interpreter = 'none';
            testCase.assertEqual(ps.getTLabel(), 't')
            ps.label_interpreter = 'tex';
            testCase.assertEqual(ps.getTLabel(), 't')
            ps.label_interpreter = 'latex';
            testCase.assertEqual(ps.getTLabel(), '$t$')
            
            ps.t_label = 't [s]';
            testCase.assertEqual(ps.getTLabel(), 't [s]')
        end
        
        function testJLabel(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            testCase.assertEqual(ps.getJLabel(), '$j$')
            ps.label_interpreter = 'none';
            testCase.assertEqual(ps.getJLabel(), 'j')
            ps.label_interpreter = 'tex';
            testCase.assertEqual(ps.getJLabel(), 'j')
            ps.label_interpreter = 'latex';
            testCase.assertEqual(ps.getJLabel(), '$j$')
            
            ps.j_label = 'J';
            testCase.assertEqual(ps.getJLabel(), 'J')
        end
        
        function testXLabelFormat(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            testCase.assertEqual(ps.getXLabelFormat(), '$x_{%d}$')
            ps.label_interpreter = 'none';
            testCase.assertEqual(ps.getXLabelFormat(), 'x(%d)')
            ps.label_interpreter = 'tex';
            testCase.assertEqual(ps.getXLabelFormat(), 'x_{%d}')
            ps.label_interpreter = 'latex';
            testCase.assertEqual(ps.getXLabelFormat(), '$x_{%d}$')
            
            ps.x_label_format = 'z^{%d}';
            testCase.assertEqual(ps.getXLabelFormat(), 'z^{%d}')
        end
%             testCase.assertEqual(settings.x_label_format, '$x_{%d}$')
    end
end