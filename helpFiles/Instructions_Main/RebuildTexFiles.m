% Script to rebuild tex files from source files

%% Split the main simulator script in functions

% Open the simulator source file

Str   = fileread('../../CommonFiles/lite/HyEQsolver.m');
CStr  = regexp(Str, '\n', 'split');

%% Search functions
Index = [find(strncmp(CStr, 'function', 8)), length(CStr) + 1];

%% Save functions by name
filenames = {'HyEQsolver_inst','zeroevents_inst','jump_inst'};
for iP = 1:length(Index) - 1;
    FID = fopen(sprintf(['Matlab2tex/',filenames{iP},'.m']), 'w');    
    if FID == - 1, error('Cannot open file for writing');
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

%%
% Folder Matlab2tex_1_2

m2tex('Matlab2tex_1_2/C.m','num')
m2tex('Matlab2tex_1_2/D.m','num')
m2tex('Matlab2tex_1_2/f.m','num')
m2tex('Matlab2tex_1_2/g.m','num')
m2tex('Matlab2tex_1_2/run.m','num')

%%
% Folder Matlab2tex_1_3

m2tex('Matlab2tex_1_3/C.m','num')
m2tex('Matlab2tex_1_3/D.m','num')
m2tex('Matlab2tex_1_3/f.m','num')
m2tex('Matlab2tex_1_3/g.m','num')


%%
% Folder Matlab2tex_1_5

m2tex('Matlab2tex_1_5/C.m','num')
m2tex('Matlab2tex_1_5/D.m','num')
m2tex('Matlab2tex_1_5/f.m','num')
m2tex('Matlab2tex_1_5/g.m','num')

%%
% Folder Matlab2tex_1_6

m2tex('Matlab2tex_1_6/C.m','num')
m2tex('Matlab2tex_1_6/D.m','num')
m2tex('Matlab2tex_1_6/f.m','num')
m2tex('Matlab2tex_1_6/g.m','num')
m2tex('Matlab2tex_1_6/C2.m','num')
m2tex('Matlab2tex_1_6/D2.m','num')
m2tex('Matlab2tex_1_6/f2.m','num')
m2tex('Matlab2tex_1_6/g2.m','num')

%%
% Folder Matlab2tex_1_7

m2tex('Matlab2tex_1_7/C.m','num')
m2tex('Matlab2tex_1_7/D.m','num')
m2tex('Matlab2tex_1_7/f.m','num')
m2tex('Matlab2tex_1_7/g.m','num')

