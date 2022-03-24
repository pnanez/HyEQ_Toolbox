function RebuildTexFiles()
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
extract('bouncing_ball_with_input', 'HS/flow set C', 'Matlab2tex_1_3', 'C')
extract('bouncing_ball_with_input', 'HS/jump set D', 'Matlab2tex_1_3', 'D')
extract('bouncing_ball_with_input', 'HS/flow map f', 'Matlab2tex_1_3', 'f')
extract('bouncing_ball_with_input', 'HS/jump map g', 'Matlab2tex_1_3', 'g')

%% Folder Matlab2tex_1_5
extract('vehicle_on_constrained_path', 'HS/flow set C', 'Matlab2tex_1_5', 'C')
extract('vehicle_on_constrained_path', 'HS/jump set D', 'Matlab2tex_1_5', 'D')
extract('vehicle_on_constrained_path', 'HS/flow map f', 'Matlab2tex_1_5', 'f')
extract('vehicle_on_constrained_path', 'HS/jump map g', 'Matlab2tex_1_5', 'g')

%% Folder Matlab2tex_CPS_ContinuousPlant2
extract('mobile_robot', 'HSu/flow set C', 'Matlab2tex_CPS_ContinuousPlant_2', 'C')
extract('mobile_robot', 'HSu/jump set D', 'Matlab2tex_CPS_ContinuousPlant_2', 'D')
extract('mobile_robot', 'HSu/flow map f', 'Matlab2tex_CPS_ContinuousPlant_2', 'f')
extract('mobile_robot', 'HSu/jump map g', 'Matlab2tex_CPS_ContinuousPlant_2', 'g')

%% Folder Matlab2tex_1_6

% Subsystem 1
extract('coupled_subsystems', 'Ball/flow set C', 'Matlab2tex_1_6', 'C1')
extract('coupled_subsystems', 'Ball/jump set D', 'Matlab2tex_1_6', 'D1')
extract('coupled_subsystems', 'Ball/flow map f', 'Matlab2tex_1_6', 'f1')
extract('coupled_subsystems', 'Ball/jump map g', 'Matlab2tex_1_6', 'g1')

% Subsystem 2
extract('coupled_subsystems', 'Platform/flow set C', 'Matlab2tex_1_6', 'C2')
extract('coupled_subsystems', 'Platform/jump set D', 'Matlab2tex_1_6', 'D2')
extract('coupled_subsystems', 'Platform/flow map f', 'Matlab2tex_1_6', 'f2')
extract('coupled_subsystems', 'Platform/jump map g', 'Matlab2tex_1_6', 'g2')

%% Folder Matlab2tex_1_7

% Firefly 1 and 2 have the same data
extract('fireflies', 'Firefly 1/flow set C', 'Matlab2tex_1_7', 'C')
extract('fireflies', 'Firefly 1/jump set D', 'Matlab2tex_1_7', 'D')
extract('fireflies', 'Firefly 1/flow map f', 'Matlab2tex_1_7', 'f')
extract('fireflies', 'Firefly 1/jump map g', 'Matlab2tex_1_7', 'g')

%% Folder Matlab2tex_CPS_ContinuousPlant

% Plant
extract('zoh_feedback_control', 'HSu/flow set C', 'Matlab2tex_CPS_ContinuousPlant', 'C')
extract('zoh_feedback_control', 'HSu/jump set D', 'Matlab2tex_CPS_ContinuousPlant', 'D')
extract('zoh_feedback_control', 'HSu/flow map f', 'Matlab2tex_CPS_ContinuousPlant', 'f')
extract('zoh_feedback_control', 'HSu/jump map g', 'Matlab2tex_CPS_ContinuousPlant', 'g')

% ADC
extract('zoh_feedback_control', 'ADC/flow set C', 'Matlab2tex_CPS_ContinuousPlant', 'C_ADC')
extract('zoh_feedback_control', 'ADC/jump set D', 'Matlab2tex_CPS_ContinuousPlant', 'D_ADC')
extract('zoh_feedback_control', 'ADC/flow map f', 'Matlab2tex_CPS_ContinuousPlant', 'f_ADC')
extract('zoh_feedback_control', 'ADC/jump map g', 'Matlab2tex_CPS_ContinuousPlant', 'g_ADC')

% ZOH
extract('zoh_feedback_control', 'ZOH/flow set C', 'Matlab2tex_CPS_ContinuousPlant', 'C_ZOH')
extract('zoh_feedback_control', 'ZOH/jump set D', 'Matlab2tex_CPS_ContinuousPlant', 'D_ZOH')
extract('zoh_feedback_control', 'ZOH/flow map f', 'Matlab2tex_CPS_ContinuousPlant', 'f_ZOH')
extract('zoh_feedback_control', 'ZOH/jump map g', 'Matlab2tex_CPS_ContinuousPlant', 'g_ZOH')

%% Folder Matlab2tex_CPS_Network_1

% Plant
extract('network_estimation1', 'Continuous Process/flow set C', 'Matlab2tex_CPS_Network_1', 'C')
extract('network_estimation1', 'Continuous Process/jump set D', 'Matlab2tex_CPS_Network_1', 'D')
extract('network_estimation1', 'Continuous Process/flow map f', 'Matlab2tex_CPS_Network_1', 'f')
extract('network_estimation1', 'Continuous Process/jump map g', 'Matlab2tex_CPS_Network_1', 'g')

% Network
extract('network_estimation1', 'Network/flow set C', 'Matlab2tex_CPS_Network_1', 'C_network')
extract('network_estimation1', 'Network/jump set D', 'Matlab2tex_CPS_Network_1', 'D_network')
extract('network_estimation1', 'Network/flow map f', 'Matlab2tex_CPS_Network_1', 'f_network')
extract('network_estimation1', 'Network/jump map g', 'Matlab2tex_CPS_Network_1', 'g_network')

% Estimator
extract('network_estimation1', 'Estimator/flow set C', 'Matlab2tex_CPS_Network_1', 'C_Estimator')
extract('network_estimation1', 'Estimator/jump set D', 'Matlab2tex_CPS_Network_1', 'D_Estimator')
extract('network_estimation1', 'Estimator/flow map f', 'Matlab2tex_CPS_Network_1', 'f_Estimator')
extract('network_estimation1', 'Estimator/jump map g', 'Matlab2tex_CPS_Network_1', 'g_Estimator')


%% Folder Matlab2tex_CPS_Network_2

% Plant
extract('network_estimation2', 'Continuous Process/flow set C', 'Matlab2tex_CPS_Network_2', 'C')
extract('network_estimation2', 'Continuous Process/jump set D', 'Matlab2tex_CPS_Network_2', 'D')
extract('network_estimation2', 'Continuous Process/flow map f', 'Matlab2tex_CPS_Network_2', 'f')
extract('network_estimation2', 'Continuous Process/jump map g', 'Matlab2tex_CPS_Network_2', 'g')

% Network
extract('network_estimation2', 'Network/flow set C', 'Matlab2tex_CPS_Network_2', 'C_network')
extract('network_estimation2', 'Network/jump set D', 'Matlab2tex_CPS_Network_2', 'D_network')
extract('network_estimation2', 'Network/flow map f', 'Matlab2tex_CPS_Network_2', 'f_network')
extract('network_estimation2', 'Network/jump map g', 'Matlab2tex_CPS_Network_2', 'g_network')

% Estimator
extract('network_estimation2', 'Estimator/flow set C', 'Matlab2tex_CPS_Network_2', 'C_Estimator')
extract('network_estimation2', 'Estimator/jump set D', 'Matlab2tex_CPS_Network_2', 'D_Estimator')
extract('network_estimation2', 'Estimator/flow map f', 'Matlab2tex_CPS_Network_2', 'f_Estimator')
extract('network_estimation2', 'Estimator/jump map g', 'Matlab2tex_CPS_Network_2', 'g_Estimator')

%% Folder Matlab2tex_FSM
% Plant
extract('finite_state_machine', 'FSM/flow set C', 'Matlab2tex_FSM', 'C')
extract('finite_state_machine', 'FSM/jump set D', 'Matlab2tex_FSM', 'D')
extract('finite_state_machine', 'FSM/flow map f', 'Matlab2tex_FSM', 'f')
extract('finite_state_machine', 'FSM/jump map g', 'Matlab2tex_FSM', 'g')

%% Folder ADC_1
extract('analog_to_digital_converter', 'ADC/flow set C', 'Matlab2tex_CPS_ADC_1', 'C')
extract('analog_to_digital_converter', 'ADC/jump set D', 'Matlab2tex_CPS_ADC_1', 'D')
extract('analog_to_digital_converter', 'ADC/flow map f', 'Matlab2tex_CPS_ADC_1', 'f')
extract('analog_to_digital_converter', 'ADC/jump map g', 'Matlab2tex_CPS_ADC_1', 'g')

%% Folder ADC_2

% Plant
extract('bouncing_ball_with_adc', 'HSu/flow set C', 'Matlab2tex_CPS_ADC_2', 'C')
extract('bouncing_ball_with_adc', 'HSu/jump set D', 'Matlab2tex_CPS_ADC_2', 'D')
extract('bouncing_ball_with_adc', 'HSu/flow map f', 'Matlab2tex_CPS_ADC_2', 'f')
extract('bouncing_ball_with_adc', 'HSu/jump map g', 'Matlab2tex_CPS_ADC_2', 'g')

% ADC
extract('bouncing_ball_with_adc', 'ADC/flow set C', 'Matlab2tex_CPS_ADC_2', 'C_ADC')
extract('bouncing_ball_with_adc', 'ADC/jump set D', 'Matlab2tex_CPS_ADC_2', 'D_ADC')
extract('bouncing_ball_with_adc', 'ADC/flow map f', 'Matlab2tex_CPS_ADC_2', 'f_ADC')
extract('bouncing_ball_with_adc', 'ADC/jump map g', 'Matlab2tex_CPS_ADC_2', 'g_ADC')

%% Folder Matlab2tex_ZOH

% Plant
extract('zero_order_hold', 'ZOH/flow set C', 'Matlab2tex_ZOH', 'C')
extract('zero_order_hold', 'ZOH/jump set D', 'Matlab2tex_ZOH', 'D')
extract('zero_order_hold', 'ZOH/flow map f', 'Matlab2tex_ZOH', 'f')
extract('zero_order_hold', 'ZOH/jump map g', 'Matlab2tex_ZOH', 'g')

warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.
disp('Finished.')
end

function extract(example, embfnc, outdir, mfilename)
slx_file = which(['hybrid.examples.', example, '.', example]);
out_dir = hybrid.getFolderLocation('doc', 'src', outdir);
mfilename = [mfilename, '.m'];
extractSimulinkFunction(slx_file, [example, '/', embfnc], fullfile(out_dir, mfilename))
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