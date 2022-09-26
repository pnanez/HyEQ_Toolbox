function openHelp(name)
    % Open a help page stored in doc/html/ (which are published based on the
    % MATLAB .m files stored in doc/. If no 'name' is given, then the root of
    % the HyEQ Toolbox help is opened.

    % Handle no input arguments.
    if nargin == 0
        name = 'TOC.html';
    end

    % Append '.html' if missing.
    if ~ends_with(name, '.html')
        name = [name, '.html'];
    end

    % Redirect links to renamed examples.
    name = replace(name, 'Example_1_2.html', 'Help_bouncing_ball.html');
    name = replace(name, 'Example_1_3.html', 'Help_bouncing_ball_with_input.html');
    name = replace(name, 'Example_1_5.html', 'Example_vehicle_on_path.html');
    name = replace(name, 'Example_1_6.html', 'Help_coupled_subsystems.html');
    name = replace(name, 'Example_1_7.html', 'Example_fireflies.html');
    name = replace(name, 'Example_1_8.html', 'Help_behavior_in_C_intersection_D.html');
%     name_with_html = replace(name_with_html, 'Example_4_0.html', ???);
    name = replace(name, 'Example_4_1.html', 'CPS_finite_state_machine.html');
    name = replace(name, 'Example_4_2.html', 'Example_network_estimation.html');
    name = replace(name, 'Example_4_3.html', 'CPS_zero_order_hold.html');
    name = replace(name, 'ADC_1.html',       'CPS_analog_to_digital_converter.html');
    name = replace(name, 'Example_ContinuousPlant.html',  'Example_zoh_feedback_control.html');
    name = replace(name, 'Example_ContinuousPlant2.html', 'CPS_continuous_plant.html');

    path = fullfile(hybrid.getFolderLocation('doc', 'html'), name);
    open(path);
end

function str_out = replace(str, name_to_replace, new_name)
    if strcmp(str, name_to_replace)
        str_out = new_name;
    else 
        str_out = str;
    end
end

function is_match = ends_with(str, suffix)
% We define our own function instead of using the builtin 'endswith' function
% because 'endswith' was not added until after R2014b.
    if length(suffix) > length(str)
        is_match = false;
        return
    end
    substr_start = length(str) - length(suffix) + 1;
    substr = str(substr_start:end);
    is_match = strcmp(substr, suffix);
end