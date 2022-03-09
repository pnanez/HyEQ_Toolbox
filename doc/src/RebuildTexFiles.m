% Script to rebuild tex files from source files
disp('===== Generating .m files from source files =====')

%% Split the main simulator script in functions

% Open the simulator source file
Str  = fileread('../../matlab/HyEQsolver.m');
CStr = regexp(Str, '\n', 'split'); 

%% Search functions
Index = [find(strncmp(CStr, 'function', 8)), length(CStr) + 1];

%% Save functions by name
filenames = {'HyEQsolver_inst','zeroevents_inst','jump_inst', 'fun_wrap_inst'};
assert(length(Index) >= length(filenames))
for iP = 1:length(filenames)
    FID = fopen(sprintf(['Matlab2tex/',filenames{iP},'.m']), 'w');
    if FID == - 1
        error('Cannot open file for writing');
    end
    fprintf(FID,'%s\n', CStr{Index(iP):Index(iP + 1)-1});
    fclose(FID);
end

%% Folder Matlab2tex_1_2
example_dir_1_2 = hybrid.getFolderLocation('Examples', 'Example_1.2-Bouncing_Ball');
out_dir_1_2 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_1_2');
copyfile(fullfile(example_dir_1_2, 'C_ex1_2.m'), out_dir_1_2, 'f')
copyfile(fullfile(example_dir_1_2, 'D_ex1_2.m'), out_dir_1_2, 'f')
copyfile(fullfile(example_dir_1_2, 'f_ex1_2.m'), out_dir_1_2, 'f')
copyfile(fullfile(example_dir_1_2, 'g_ex1_2.m'), out_dir_1_2, 'f')

%% Folder Matlab2tex_1_3
example_dir_1_3 = hybrid.getFolderLocation('Examples', 'Example_1.3-Bouncing_Ball_with_Input');
example_1_3_slx_file = fullfile(example_dir_1_3, 'Example1_3');
out_dir_1_3 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_1_3');
SimFnc2tex(example_1_3_slx_file, 'Example1_3/HS/flow set C', fullfile(out_dir_1_3, 'C.m'))
SimFnc2tex(example_1_3_slx_file, 'Example1_3/HS/jump set D', fullfile(out_dir_1_3, 'D.m'))
SimFnc2tex(example_1_3_slx_file, 'Example1_3/HS/flow map f', fullfile(out_dir_1_3, 'f.m'))
SimFnc2tex(example_1_3_slx_file, 'Example1_3/HS/jump map g', fullfile(out_dir_1_3, 'g.m'))

%% Folder Matlab2tex_1_5
example_dir_1_5 = hybrid.getFolderLocation('Examples', 'Example_1.5-Vehicle_on_Path_with_Boundaries');
example_1_5_slx_file = fullfile(example_dir_1_5, 'Example1_5');
out_dir_1_5 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_1_5');
SimFnc2tex(example_1_5_slx_file, 'Example1_5/HS/flow set C', fullfile(out_dir_1_5, 'C.m'))
SimFnc2tex(example_1_5_slx_file, 'Example1_5/HS/jump set D', fullfile(out_dir_1_5, 'D.m'))
SimFnc2tex(example_1_5_slx_file, 'Example1_5/HS/flow map f', fullfile(out_dir_1_5, 'f.m'))
SimFnc2tex(example_1_5_slx_file, 'Example1_5/HS/jump map g', fullfile(out_dir_1_5, 'g.m'))

%% Folder Matlab2tex_1_6
example_dir_1_6 = hybrid.getFolderLocation('Examples', 'Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform');
example_1_6_slx_file = fullfile(example_dir_1_6, 'Example1_6');
out_dir_1_6 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_1_6');

% Subsystem 1
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Ball/flow map f', fullfile(out_dir_1_6, 'f1.m'))
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Ball/flow set C', fullfile(out_dir_1_6, 'C1.m'))
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Ball/jump set D', fullfile(out_dir_1_6, 'D1.m'))
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Ball/jump map g', fullfile(out_dir_1_6, 'g1.m'))

% Subsystem 2
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Platform/flow map f', fullfile(out_dir_1_6, 'f2.m'))
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Platform/flow set C', fullfile(out_dir_1_6, 'C2.m'))
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Platform/jump map g', fullfile(out_dir_1_6, 'g2.m'))
SimFnc2tex(example_1_6_slx_file, 'Example1_6/Platform/jump set D', fullfile(out_dir_1_6, 'D2.m'))

%% Folder Matlab2tex_1_7
example_dir_1_7 = hybrid.getFolderLocation('Examples', 'Example_1.7-Synchronization_of_Fireflies');
example_1_7_slx_file = fullfile(example_dir_1_7, 'Example1_7');
out_dir_1_7 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_1_7');

% Firefly 1 and 2 have the same data
SimFnc2tex(example_1_7_slx_file, 'Example1_7/Firefly 1/flow set C', fullfile(out_dir_1_7, 'C.m'))
SimFnc2tex(example_1_7_slx_file, 'Example1_7/Firefly 1/jump set D', fullfile(out_dir_1_7, 'D.m'))
SimFnc2tex(example_1_7_slx_file, 'Example1_7/Firefly 1/flow map f', fullfile(out_dir_1_7, 'f.m'))
SimFnc2tex(example_1_7_slx_file, 'Example1_7/Firefly 1/jump map g', fullfile(out_dir_1_7, 'g.m'))

%% Folder Matlab2tex_CPS_ContinuousPlant
example_CP_dir = hybrid.getFolderLocation('Examples', 'CPS_examples', 'ContinuousPlant');
example_CP_slx_file = fullfile(example_CP_dir, 'ContinuousPlant_example');
out_dir_CP = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_CPS_ContinuousPlant');

% Plant
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/HSu/flow set C', fullfile(out_dir_CP, 'C.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/HSu/jump set D', fullfile(out_dir_CP, 'D.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/HSu/flow map f', fullfile(out_dir_CP, 'f.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/HSu/jump map g', fullfile(out_dir_CP, 'g.m'))

% ADC
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ADC/flow set C', fullfile(out_dir_CP, 'C_ADC.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ADC/jump set D', fullfile(out_dir_CP, 'D_ADC.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ADC/flow map f', fullfile(out_dir_CP, 'f_ADC.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ADC/jump map g', fullfile(out_dir_CP, 'g_ADC.m'))

% ZOH
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ZOH/flow set C', fullfile(out_dir_CP, 'C_ZOH.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ZOH/jump set D', fullfile(out_dir_CP, 'D_ZOH.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ZOH/flow map f', fullfile(out_dir_CP, 'f_ZOH.m'))
SimFnc2tex(example_CP_slx_file, 'ContinuousPlant_example/ZOH/jump map g', fullfile(out_dir_CP, 'g_ZOH.m'))

%% Folder Matlab2tex_CPS_Network_1
example_network1_dir = hybrid.getFolderLocation('Examples', 'CPS_examples', 'Network_1');
example_network1_slx_file = fullfile(example_network1_dir, 'Network_example');
out_dir_network1 = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_CPS_Network_1');

% Plant
SimFnc2tex(example_network1_slx_file, 'Network_example/HSu/flow set C', fullfile(out_dir_network1, 'C.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/HSu/jump set D', fullfile(out_dir_network1, 'D.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/HSu/flow map f', fullfile(out_dir_network1, 'f.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/HSu/jump map g', fullfile(out_dir_network1, 'g.m'))

% Network
SimFnc2tex(example_network1_slx_file, 'Network_example/network/flow set C', fullfile(out_dir_network1, 'C_network.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/network/jump set D', fullfile(out_dir_network1, 'D_network.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/network/flow map f', fullfile(out_dir_network1, 'f_network.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/network/jump map g', fullfile(out_dir_network1, 'g_network.m'))

% Network
SimFnc2tex(example_network1_slx_file, 'Network_example/Estimator/flow set C', fullfile(out_dir_network1, 'C_Estimator.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/Estimator/jump set D', fullfile(out_dir_network1, 'D_Estimator.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/Estimator/flow map f', fullfile(out_dir_network1, 'f_Estimator.m'))
SimFnc2tex(example_network1_slx_file, 'Network_example/Estimator/jump map g', fullfile(out_dir_network1, 'g_Estimator.m'))

%% Folder Matlab2tex_FSM
example_FSM_dir = hybrid.getFolderLocation('Examples', 'CPS_examples', 'FSM');
example_FSM_slx_file = fullfile(example_FSM_dir, 'FSM_example');
out_dir_FSM = hybrid.getFolderLocation('doc', 'src', 'Matlab2tex_FSM');

% Plant
SimFnc2tex(example_FSM_slx_file, 'FSM_example/FSM/flow set C', fullfile(out_dir_FSM, 'C.m'))
SimFnc2tex(example_FSM_slx_file, 'FSM_example/FSM/jump set D', fullfile(out_dir_FSM, 'D.m'))
SimFnc2tex(example_FSM_slx_file, 'FSM_example/FSM/flow map f', fullfile(out_dir_FSM, 'f.m'))
SimFnc2tex(example_FSM_slx_file, 'FSM_example/FSM/jump map g', fullfile(out_dir_FSM, 'g.m'))

disp('Finished.')