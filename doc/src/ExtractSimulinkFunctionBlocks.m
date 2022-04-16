function ExtractSimulinkFunctionBlocks()
% Script to rebuild tex files from source files

disp('===== Generating .m files from source files =====')

warning('off','Simulink:Commands:LoadingOlderModel')

%% Split the main simulator script in functions

% Open the simulator source file
toolbox_root = hybrid.getFolderLocation();
Str  = fileread(fullfile(toolbox_root, 'matlab', 'HyEQsolver.m'));
CStr = regexp(Str, '\n', 'split'); 

%% Search functions
Index = [find(strncmp(CStr, 'function', 8)), length(CStr) + 1];

%% Save functions by name
filenames = {'HyEQsolver_inst','zeroevents_inst','jump_inst', 'fun_wrap_inst'};
assert(length(Index) >= length(filenames))
out_dir = hybrid.getFolderLocation('doc', 'src');
for iP = 1:length(filenames)
    FID = fopen(fullfile(out_dir, 'Matlab2tex', [filenames{iP},'.m']), 'w');
    if FID == - 1
        error('Cannot open file for writing');
    end
    fprintf(FID,'%s\n', CStr{Index(iP):Index(iP + 1)-1});
    fclose(FID);
end

%% Folder Matlab2tex_1_2
example_1_2_package = 'hybrid.examples.bouncing_ball.';
out_dir_1_2 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_1_2');
copyfile(which([example_1_2_package, 'C']), out_dir_1_2, 'f')
copyfile(which([example_1_2_package, 'D']), out_dir_1_2, 'f')
copyfile(which([example_1_2_package, 'f']), out_dir_1_2, 'f')
copyfile(which([example_1_2_package, 'g']), out_dir_1_2, 'f')

%% Folder Matlab2tex_1_3
extract('bouncing_ball_with_input', 'ball_with_input', 'HS/flow set C', 'Matlab2tex_1_3', 'C')
extract('bouncing_ball_with_input', 'ball_with_input', 'HS/jump set D', 'Matlab2tex_1_3', 'D')
extract('bouncing_ball_with_input', 'ball_with_input', 'HS/flow map f', 'Matlab2tex_1_3', 'f')
extract('bouncing_ball_with_input', 'ball_with_input', 'HS/jump map g', 'Matlab2tex_1_3', 'g')

%% Folder Matlab2tex_1_5
extract('vehicle_on_constrained_path', 'vehicle_on_path', 'HS/flow set C', 'Matlab2tex_1_5', 'C')
extract('vehicle_on_constrained_path', 'vehicle_on_path', 'HS/jump set D', 'Matlab2tex_1_5', 'D')
extract('vehicle_on_constrained_path', 'vehicle_on_path', 'HS/flow map f', 'Matlab2tex_1_5', 'f')
extract('vehicle_on_constrained_path', 'vehicle_on_path', 'HS/jump map g', 'Matlab2tex_1_5', 'g')

%% Folder Matlab2tex_CPS_ContinuousPlant2
extract('mobile_robot', 'mobile_robot', 'HSu/flow set C', 'Matlab2tex_CPS_ContinuousPlant_2', 'C')
extract('mobile_robot', 'mobile_robot', 'HSu/jump set D', 'Matlab2tex_CPS_ContinuousPlant_2', 'D')
extract('mobile_robot', 'mobile_robot', 'HSu/flow map f', 'Matlab2tex_CPS_ContinuousPlant_2', 'f')
extract('mobile_robot', 'mobile_robot', 'HSu/jump map g', 'Matlab2tex_CPS_ContinuousPlant_2', 'g')

%% Folder Matlab2tex_1_6

% Subsystem 1
extract('coupled_subsystems', 'coupled', 'Ball/flow set C', 'Matlab2tex_1_6', 'C1')
extract('coupled_subsystems', 'coupled', 'Ball/jump set D', 'Matlab2tex_1_6', 'D1')
extract('coupled_subsystems', 'coupled', 'Ball/flow map f', 'Matlab2tex_1_6', 'f1')
extract('coupled_subsystems', 'coupled', 'Ball/jump map g', 'Matlab2tex_1_6', 'g1')

% Subsystem 2
extract('coupled_subsystems', 'coupled', 'Platform/flow set C', 'Matlab2tex_1_6', 'C2')
extract('coupled_subsystems', 'coupled', 'Platform/jump set D', 'Matlab2tex_1_6', 'D2')
extract('coupled_subsystems', 'coupled', 'Platform/flow map f', 'Matlab2tex_1_6', 'f2')
extract('coupled_subsystems', 'coupled', 'Platform/jump map g', 'Matlab2tex_1_6', 'g2')

%% Folder Matlab2tex_1_7

% Firefly 1 and 2 have the same data
extract('fireflies', 'fireflies', 'Firefly 1/flow set C', 'Matlab2tex_1_7', 'C')
extract('fireflies', 'fireflies', 'Firefly 1/jump set D', 'Matlab2tex_1_7', 'D')
extract('fireflies', 'fireflies', 'Firefly 1/flow map f', 'Matlab2tex_1_7', 'f')
extract('fireflies', 'fireflies', 'Firefly 1/jump map g', 'Matlab2tex_1_7', 'g')

%% Folder Matlab2tex_CPS_ContinuousPlant

% Plant
extract('zoh_feedback_control', 'zoh_feedback', 'HSu/flow set C', 'Matlab2tex_CPS_ContinuousPlant', 'C')
extract('zoh_feedback_control', 'zoh_feedback', 'HSu/jump set D', 'Matlab2tex_CPS_ContinuousPlant', 'D')
extract('zoh_feedback_control', 'zoh_feedback', 'HSu/flow map f', 'Matlab2tex_CPS_ContinuousPlant', 'f')
extract('zoh_feedback_control', 'zoh_feedback', 'HSu/jump map g', 'Matlab2tex_CPS_ContinuousPlant', 'g')

% ADC
extract('zoh_feedback_control', 'zoh_feedback', 'ADC/flow set C', 'Matlab2tex_CPS_ContinuousPlant', 'C_ADC')
extract('zoh_feedback_control', 'zoh_feedback', 'ADC/jump set D', 'Matlab2tex_CPS_ContinuousPlant', 'D_ADC')
extract('zoh_feedback_control', 'zoh_feedback', 'ADC/flow map f', 'Matlab2tex_CPS_ContinuousPlant', 'f_ADC')
extract('zoh_feedback_control', 'zoh_feedback', 'ADC/jump map g', 'Matlab2tex_CPS_ContinuousPlant', 'g_ADC')

% ZOH
extract('zoh_feedback_control', 'zoh_feedback', 'ZOH/flow set C', 'Matlab2tex_CPS_ContinuousPlant', 'C_ZOH')
extract('zoh_feedback_control', 'zoh_feedback', 'ZOH/jump set D', 'Matlab2tex_CPS_ContinuousPlant', 'D_ZOH')
extract('zoh_feedback_control', 'zoh_feedback', 'ZOH/flow map f', 'Matlab2tex_CPS_ContinuousPlant', 'f_ZOH')
extract('zoh_feedback_control', 'zoh_feedback', 'ZOH/jump map g', 'Matlab2tex_CPS_ContinuousPlant', 'g_ZOH')

%% Folder Matlab2tex_CPS_Network

% Plant
extract('network_estimation', 'network', 'Continuous Process/flow set C', 'Matlab2tex_CPS_Network', 'C')
extract('network_estimation', 'network', 'Continuous Process/jump set D', 'Matlab2tex_CPS_Network', 'D')
extract('network_estimation', 'network', 'Continuous Process/flow map f', 'Matlab2tex_CPS_Network', 'f')
extract('network_estimation', 'network', 'Continuous Process/jump map g', 'Matlab2tex_CPS_Network', 'g')

% Network
extract('network_estimation', 'network', 'Network/flow set C', 'Matlab2tex_CPS_Network', 'C_network')
extract('network_estimation', 'network', 'Network/jump set D', 'Matlab2tex_CPS_Network', 'D_network')
extract('network_estimation', 'network', 'Network/flow map f', 'Matlab2tex_CPS_Network', 'f_network')
extract('network_estimation', 'network', 'Network/jump map g', 'Matlab2tex_CPS_Network', 'g_network')

% Estimator
extract('network_estimation', 'network', 'Estimator/flow set C', 'Matlab2tex_CPS_Network', 'C_Estimator')
extract('network_estimation', 'network', 'Estimator/jump set D', 'Matlab2tex_CPS_Network', 'D_Estimator')
extract('network_estimation', 'network', 'Estimator/flow map f', 'Matlab2tex_CPS_Network', 'f_Estimator')
extract('network_estimation', 'network', 'Estimator/jump map g', 'Matlab2tex_CPS_Network', 'g_Estimator')
 
%% Folder Matlab2tex_FSM
extract('finite_state_machine', 'fsm', 'FSM/flow set C', 'Matlab2tex_FSM', 'C')
extract('finite_state_machine', 'fsm', 'FSM/jump set D', 'Matlab2tex_FSM', 'D')
extract('finite_state_machine', 'fsm', 'FSM/flow map f', 'Matlab2tex_FSM', 'f')
extract('finite_state_machine', 'fsm', 'FSM/jump map g', 'Matlab2tex_FSM', 'g')

%% Folder ADC_1
extract('analog_to_digital_converter', 'adc', 'ADC/flow set C', 'Matlab2tex_CPS_ADC_1', 'C')
extract('analog_to_digital_converter', 'adc', 'ADC/jump set D', 'Matlab2tex_CPS_ADC_1', 'D')
extract('analog_to_digital_converter', 'adc', 'ADC/flow map f', 'Matlab2tex_CPS_ADC_1', 'f')
extract('analog_to_digital_converter', 'adc', 'ADC/jump map g', 'Matlab2tex_CPS_ADC_1', 'g')

%% Folder Matlab2tex_ZOH
extract('zero_order_hold', 'zoh', 'ZOH/flow set C', 'Matlab2tex_ZOH', 'C')
extract('zero_order_hold', 'zoh', 'ZOH/jump set D', 'Matlab2tex_ZOH', 'D')
extract('zero_order_hold', 'zoh', 'ZOH/flow map f', 'Matlab2tex_ZOH', 'f')
extract('zero_order_hold', 'zoh', 'ZOH/jump map g', 'Matlab2tex_ZOH', 'g')

warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.
disp('Finished.')
end

function extract(example, model_name, embfnc, outdir, mfilename)
slx_file = which(['hybrid.examples.', example, '.', model_name]);
out_dir = hybrid.getFolderLocation('doc', 'src', outdir);
mfilename = [mfilename, '.m'];
extractSimulinkFunction(slx_file, [model_name, '/', embfnc], fullfile(out_dir, mfilename))
end

function extractSimulinkFunction(simsys, embfnc, mfilename)
    %   Generates and save a .m file (mfilename) from an embedded
    %   simulink function (embfnc) of a simulink model (symsys).
    %   simsys: path of simulink system.
    %	embfnc: embedded function name e.g., simsys/subsys/embedded_function.
    %	mfilename: name of the generated m and tex file.
    sf = sfroot();
    load_system(simsys);
    block = sf.find('Path',embfnc,'-isa','Stateflow.EMChart');
    script = block.Script;
    fid = fopen(mfilename, 'w');
    fprintf(fid, '%s\r\n', script);
    fclose(fid);
    close_system(simsys);
    
    fprintf(['Extracted %s \n' ...
             '     from %s.\n'], mfilename, simsys)
end