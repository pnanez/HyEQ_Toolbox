% Script to rebuild tex files from source files

%% Split the main simulator script in functions

% Open the simulator source file

Str   = fileread('../../matlab/HyEQsolver.m');
CStr  = regexp(Str, '\n', 'split');

%% Search functions
Index = [find(strncmp(CStr, 'function', 8)), length(CStr) + 1];

%% Save functions by name
filenames = {'HyEQsolver_inst','zeroevents_inst','jump_inst', 'fun_wrap_inst'};
for iP = 1:min(length(Index), length(filenames)) - 1
    FID = fopen(sprintf(['Matlab2tex/',filenames{iP},'.m']), 'w');
    if FID == - 1
        error('Cannot open file for writing');
    end
    fprintf(FID,'%s\n', CStr{Index(iP):Index(iP + 1)-1});
    fclose(FID);
end

%%
% Folder Matlab2tex

m2tex('Matlab2tex/config_inst.m','num')
m2tex('Matlab2tex/HyEQsolver_inst.m','num')
m2tex('Matlab2tex/initialization_inst.m','num')
m2tex('Matlab2tex/initializationBB_inst.m','num')
m2tex('Matlab2tex/jump_inst.m','num')
m2tex('Matlab2tex/postprocesing_inst.m','num')
m2tex('Matlab2tex/postprocesingBB_inst.m','num')
m2tex('Matlab2tex/zeroevents_inst.m','num')
m2tex('Matlab2tex/fun_wrap_inst.m','num')


%%
% Folder Matlab2tex_1_2

copyfile '../../Examples/Example_1.2a-Bouncing_Ball_with_simulink_External_files/C_ex1_2a.m'...
    '../../helpFiles/Instructions_Main/Matlab2tex_1_2/C.m'
copyfile '../../Examples/Example_1.2a-Bouncing_Ball_with_simulink_External_files/D_ex1_2a.m'...
    '../../helpFiles/Instructions_Main/Matlab2tex_1_2/D.m'
copyfile '../../Examples/Example_1.2a-Bouncing_Ball_with_simulink_External_files/f_ex1_2a.m'...
    '../../helpFiles/Instructions_Main/Matlab2tex_1_2/f.m'
copyfile '../../Examples/Example_1.2a-Bouncing_Ball_with_simulink_External_files/g_ex1_2a.m'...
    '../../helpFiles/Instructions_Main/Matlab2tex_1_2/g.m'
copyfile '../../Examples/Example_1.2a-Bouncing_Ball_with_simulink_External_files/run_ex1_2a.m'...
    '../../helpFiles/Instructions_Main/Matlab2tex_1_2/run.m'
m2tex('Matlab2tex_1_2/C.m','num')
m2tex('Matlab2tex_1_2/D.m','num')
m2tex('Matlab2tex_1_2/f.m','num')
m2tex('Matlab2tex_1_2/g.m','num')
m2tex('Matlab2tex_1_2/run.m','num')

delete('../../helpFiles/Instructions_Main/Matlab2tex_1_2/C.m');
delete('../../helpFiles/Instructions_Main/Matlab2tex_1_2/D.m');
delete('../../helpFiles/Instructions_Main/Matlab2tex_1_2/f.m');
delete('../../helpFiles/Instructions_Main/Matlab2tex_1_2/g.m');
delete('../../helpFiles/Instructions_Main/Matlab2tex_1_2/run.m');


%%
% Folder Matlab2tex_1_3

% flow set
SimFnc2tex('../../Examples/Example_1.3-Bouncing_Ball_with_Input/Example1_3',...
    'Example1_3/HS/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_1_3/C.m')
% jump set
SimFnc2tex('../../Examples/Example_1.3-Bouncing_Ball_with_Input/Example1_3',...
    'Example1_3/HS/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_1_3/D.m')
% flow map
SimFnc2tex('../../Examples/Example_1.3-Bouncing_Ball_with_Input/Example1_3',...
    'Example1_3/HS/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_1_3/f.m')
% jump map
SimFnc2tex('../../Examples/Example_1.3-Bouncing_Ball_with_Input/Example1_3',...
    'Example1_3/HS/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_1_3/g.m')


%%
% Folder Matlab2tex_1_5

% flow set
SimFnc2tex('../../Examples/Example_1.5-Vehicle_on_Path_with_Boundaries/Example1_5',...
    'Example1_5/HS/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_1_5/C.m')
% jump set
SimFnc2tex('../../Examples/Example_1.5-Vehicle_on_Path_with_Boundaries/Example1_5',...
    'Example1_5/HS/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_1_5/D.m')
% flow map
SimFnc2tex('../../Examples/Example_1.5-Vehicle_on_Path_with_Boundaries/Example1_5',...
    'Example1_5/HS/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_1_5/f.m')
% jump map
SimFnc2tex('../../Examples/Example_1.5-Vehicle_on_Path_with_Boundaries/Example1_5',...
    'Example1_5/HS/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_1_5/g.m')


%%
% Folder Matlab2tex_1_6

% flow set
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_1/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_1_6/C.m')
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_2/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_1_6/C2.m')
% jump set
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_1/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_1_6/D.m')
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_2/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_1_6/D2.m')
% flow map
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_1/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_1_6/f.m')
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_2/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_1_6/f2.m')
% jump map
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_1/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_1_6/g.m')
SimFnc2tex('../../Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform/Example1_6',...
    'Example1_6/HS_2/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_1_6/g2.m')

%%
% Folder Matlab2tex_1_7

% flow set
SimFnc2tex('../../Examples/Example_1.7-Synchronization_of_Fireflies/Example1_7',...
    'Example1_7/Firefly 1/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_1_7/C.m')
% jump set
SimFnc2tex('../../Examples/Example_1.7-Synchronization_of_Fireflies/Example1_7',...
    'Example1_7/Firefly 1/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_1_7/D.m')
% flow map
SimFnc2tex('../../Examples/Example_1.7-Synchronization_of_Fireflies/Example1_7',...
    'Example1_7/Firefly 1/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_1_7/f.m')
% jump map
SimFnc2tex('../../Examples/Example_1.7-Synchronization_of_Fireflies/Example1_7',...
    'Example1_7/Firefly 1/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_1_7/g.m')


%%
% Folder Matlab2tex_CPS_ContinuousPlant

% Plant
% flow set
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/HSu/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/C.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/HSu/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/D.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/HSu/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/f.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/HSu/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/g.m')

% ADC
% flow set
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ADC/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/C_ADC.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ADC/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/D_ADC.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ADC/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/f_ADC.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ADC/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/g_ADC.m')

% ZOH
% flow set
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ZOH/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/C_ZOH.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ZOH/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/D_ZOH.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ZOH/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/f_ZOH.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/ContinuousPlant/ContinuousPlant_example',...
    'ContinuousPlant_example/ZOH/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_CPS_ContinuousPlant/g_ZOH.m')

%%
% Folder Matlab2tex_CPS_Network_1

% Plant
% flow set
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/HSu/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/C.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/HSu/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/D.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/HSu/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/f.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/HSu/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/g.m')

% network
% flow set
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/network/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/C_network.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/network/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/D_network.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/network/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/f_network.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/network/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/g_network.m')

% Estimator
% flow set
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/Estimator/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/C_Estimator.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/Estimator/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/D_Estimator.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/Estimator/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/f_Estimator.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/Network_1/Network_example',...
    'Network_example/Estimator/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_CPS_Network_1/g_Estimator.m')

%%
% Folder Matlab2tex_FSM

% Plant
% flow set
SimFnc2tex('../../Examples/CPS_examples/FSM/FSM_example',...
    'FSM_example/FSM/flow set C','../../helpFiles/Instructions_Main/Matlab2tex_FSM/C.m')
% jump set
SimFnc2tex('../../Examples/CPS_examples/FSM/FSM_example',...
    'FSM_example/FSM/jump set D','../../helpFiles/Instructions_Main/Matlab2tex_FSM/D.m')
% flow map
SimFnc2tex('../../Examples/CPS_examples/FSM/FSM_example',...
    'FSM_example/FSM/flow map f','../../helpFiles/Instructions_Main/Matlab2tex_FSM/f.m')
% jump map
SimFnc2tex('../../Examples/CPS_examples/FSM/FSM_example',...
    'FSM_example/FSM/jump map g','../../helpFiles/Instructions_Main/Matlab2tex_FSM/g.m')










