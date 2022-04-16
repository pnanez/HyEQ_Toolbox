classdef ExamplesTest < matlab.unittest.TestCase

    methods(TestMethodSetup)
        function disableWarningAboutOldSimulinkFiles(~)
            warning('off','Simulink:Commands:LoadingOlderModel')
        end
    end
    
    methods(TestMethodTeardown)
        function reenableWarningAboutOldSimulinkFiles(~)
            warning('on','Simulink:Commands:LoadingOlderModel')
            close all
        end
    end

    methods (Test)
       
        function test_analog_to_digital_converter(~)
            clear
            checkExample('analog_to_digital_converter', 'adc')
        end

        function test_behavior_in_C_intersection_D(~)
            clear
            checkExample('behavior_in_C_intersection_D', 'hybrid_priority')
        end

        function test_bouncing_ball(~)
            clear
            checkExample('bouncing_ball')
        end

        function test_bouncing_ball_with_adc(~)
            clear
            checkExample('bouncing_ball_with_adc', 'ball_with_adc')
        end

        function test_bouncing_ball_with_input(~)
            clear
            checkExample('bouncing_ball_with_input', 'ball_with_input')
        end

        function test_bouncing_ball_with_input_alternative(~)
            clear
            checkExample('bouncing_ball_with_input', 'ball_with_input2')
        end

        function test_coupled_subsystems(~)
            clear
            checkExample('coupled_subsystems', 'coupled')
        end

        function test_finite_state_machine(~)
            clear
            checkExample('finite_state_machine', 'fsm')
        end

        function test_fireflies(~)
            clear
            checkExample('fireflies')
        end

        function test_mobile_robot(~)
            clear
            checkExample('mobile_robot')
        end

        function test_network_estimation1(~)
            clear
            checkExample('network_estimation','network')
        end

        function test_network_estimation2(~)
            clear
            checkExample('network_estimation', 'network_with_input')
        end

        function test_vehicle_on_constrained_path(~)
            clear
            checkExample('vehicle_on_constrained_path', 'vehicle_on_path')
        end

        function test_zero_order_hold(~)
            clear
            checkExample('zero_order_hold', 'zoh')
        end

        function test_zoh_feedback_control(~)
            clear
            checkExample('zoh_feedback_control', 'zoh_feedback')
        end
    end
end

function checkExample(example_name, model_name)
    if ~exist('model_name', 'var')
        model_name = example_name;
    end
    model_package_path = ['hybrid.examples.', example_name, '.', model_name];
    model_file_path = which(model_package_path);

    % We define a variable 'block_auto_run_scripts' that is checked for
    % existence within the postprocessing callback of each Simulink model.
    global block_auto_run_scripts %#ok<GVMIS> 
    block_auto_run_scripts = true; %#ok<NASGU> % Variable is used within model in the postprocess callback.
    try
        eval(['hybrid.examples.', example_name, '.initialize']) %#ok<EVLDOT> 
        sim(model_file_path)
        close_system()
        eval(['hybrid.examples.', example_name, '.postprocess']) %#ok<EVLDOT> 
    catch exception
        % We check and rethrow the error later, after clearing the value of
        % block_auto_run_scripts.
    end
    % We clear the value of block_auto_run_scripts here.
    block_auto_run_scripts = []; 
    if exist('exception', 'var')
       rethrow(exception) 
    end
end