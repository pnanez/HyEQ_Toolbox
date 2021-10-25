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
            if ~exist('string', 'class')
                % Pass. Strings are not supported on current version of Matlab'
                return
            end
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
            plot_settings = PlotSettings();
            function check(name)
               % Set property to empty string.
               plot_settings.set(name, '')
               testCase.assertEqual(plot_settings.get(name), 'none')
               plot_settings.reset();
               
               % Set property to empty array.
               plot_settings.set(name, [])
               testCase.assertEqual(plot_settings.get(name), 'none')
               plot_settings.reset();
               
               % Set property to empty cell array.
               plot_settings.set(name, {})
               testCase.assertEqual(plot_settings.get(name), 'none')
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
            ps.flow_color = {'red', [1 0 0]};
            ps.flow_color = 'matlab';
            ps.flow_color = {'r', {}}; % Nested cell array is OK only if the inner array is empty.
            
            function assertInvalidColorArg(color_arg)
                testCase.verifyError(@() ps.set('flow_color', color_arg),...
                    'Hybrid:InvalidColor');
                testCase.verifyError(@() ps.set('jump_color', color_arg),...
                    'Hybrid:InvalidColor');
            end

            % Check invalid color, except on versions of Matlab before 9.9 (R2020b).
            if ~verLessThan('matlab', '9.9')
                
                assertInvalidColorArg('blurg'); % Not a color name
                assertInvalidColorArg([1.5 0 0]); % channel  > 1
                assertInvalidColorArg([0 0.1, 0.2, 0.3]); % Too many entries
                assertInvalidColorArg({'r', 'blurg'}); % Invalid value in cell array.
                assertInvalidColorArg({'r', {'b'}}); % Nested nonempty cell arrays.
            end
        end

        function testRotatingFlowColors(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            ps.flow_color = {'r', 'g', 'b'};
            flow_args1 = ps.flowArguments();
            flow_args2 = ps.flowArguments();
            flow_args3 = ps.flowArguments();
            flow_args4 = ps.flowArguments();
            color_ndx = find(strcmp(flow_args1, 'Color'), 1) + 1;
            flow_color_1 = flow_args1{color_ndx};
            flow_color_2 = flow_args2{color_ndx};
            flow_color_3 = flow_args3{color_ndx};
            flow_color_4 = flow_args4{color_ndx};
            testCase.assertEqual(flow_color_1, 'r')
            testCase.assertEqual(flow_color_2, 'g')
            testCase.assertEqual(flow_color_3, 'b')
            testCase.assertEqual(flow_color_4, 'r') % Loops back to 'r'
        end

        function testRotatingJumpColors(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            ps.jump_color = {'r', 'g', 'b'};
            function checkNext(color_expected)
                jump_args_struct = ps.jumpArguments();
                for k = {'line', 'start', 'end'}
                    jump_args = jump_args_struct.(k{1});
                    color_ndx = 2; % find(contains(args, 'Color'), 1) + 1;
                    color_actual = jump_args{color_ndx};
                    testCase.assertEqual(color_actual, color_expected);
                end
            end
            checkNext('r')
            checkNext('g')
            checkNext('b')
            checkNext('r')
        end

        function testSetMatlabColorScheme(testCase)
            import hybrid.internal.*
            ps = PlotSettings();
            ps.flow_color = 'matlab';
            testCase.assertEqual(ps.flow_color, PlotSettings.MATLAB_DEFAULT_PLOT_COLORS)
            ps.jump_color = 'MATLAB';
            testCase.assertEqual(ps.jump_color, PlotSettings.MATLAB_DEFAULT_PLOT_COLORS_DARKENED)
        end
        
        function testCheckInterpreters(testCase)
            import hybrid.internal.*
            ps = PlotSettings(); 
            
            % Strings and char arrays are OK
            ps.set('title_interpreter', 'tex')
            ps.set('label_interpreter', 'tex')
            ps.set('tick_label_interpreter', 'tex')
            
            % Must be one of 'none', 'text', or 'latex'.
            testCase.verifyError(@() ps.set('title_interpreter', 'blurg'),...
                                    'Hybrid:InvalidInterpreter');
            testCase.verifyError(@() ps.set('label_interpreter', 'blarg'),...
                                    'Hybrid:InvalidInterpreter');
            testCase.verifyError(@() ps.set('tick_label_interpreter', 'blorg'),...
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
            testCase.verifyError(@() ps.set('auto_subplots', 'blarg'), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() ps.set('auto_subplots', 2), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() ps.set('auto_subplots', [1 2]), 'Hybrid:InvalidArgument');
            testCase.verifyError(@() ps.set('auto_subplots', [true false]), 'Hybrid:InvalidArgument');
        end
        
        function testSetLegendAsString(testCase)
            if ~exist('string', 'class')
                % Pass. Strings are not supported on current version of Matlab'
                return
            end
            import hybrid.internal.*
            ps = PlotSettings(); 
            ps.component_legend_labels = {string('String 1'), string('String 2')}; %#ok<STRQUOT>
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