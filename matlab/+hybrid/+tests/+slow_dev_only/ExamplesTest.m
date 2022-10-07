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
        
        % ===== Test MATLAB Examples =====

        function test_run_bouncing_ball(~)
            hybrid.examples.run_bouncing_ball
        end

        function test_run_bouncing_ball_with_input(~)
            hybrid.examples.run_bouncing_ball_with_input
        end

        % ===== Test Simulink Examples =====

        function test_analog_to_digital_converter(~)
            checkExample('analog_to_digital_converter', 'adc')
        end

        function test_behavior_in_C_intersection_D(~)
            checkExample('behavior_in_C_intersection_D', 'hybrid_priority')
        end

        function test_bouncing_ball(~)
            checkExample('bouncing_ball')
        end

        function test_bouncing_ball_with_adc(~)
            checkExample('bouncing_ball_with_adc', 'ball_with_adc')
        end

        function test_bouncing_ball_with_input(~)
            checkExample('bouncing_ball_with_input', 'ball_with_input')
        end

        function test_bouncing_ball_with_input_alternative(~)
            checkExample('bouncing_ball_with_input', 'ball_with_input2')
        end

        function test_coupled_subsystems(~)
            checkExample('coupled_subsystems', 'coupled')
        end

        function test_finite_state_machine(~)
            checkExample('finite_state_machine', 'fsm')
        end

        function test_fireflies(~)
            checkExample('fireflies')
        end

        function test_mobile_robot(~)
            checkExample('mobile_robot')
        end

        function test_network_estimation(~)
            checkExample('network_estimation','network')
        end

        function test_vehicle_on_constrained_path(~)
            checkExample('vehicle_on_constrained_path', 'vehicle_on_path')
        end

        function test_zero_order_hold(~)
            checkExample('zero_order_hold', 'zoh')
        end

        function test_zoh_feedback_control(~)
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

    % Load the system
    cs = load_system(model_file_path);

    % Automatically close the system when this function exits 
    % regardless of what happens next.
    oncleanup_callback_obj = onCleanup(@() close_system(cs, 0));

    % Run the model in the base workspace so that the output of the
    % simulation is accesible by the callbacks. 
    cmd = sprintf('clearvars; sim(''%s'')', model_file_path);
    evalin('base', cmd);
end