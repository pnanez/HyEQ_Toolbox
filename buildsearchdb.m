function buildsearchdb(TBfullpath)
% BUILDSEARCHDB   creates a database to allow Matlab to access the
% information within html files, such as help files
%%
disp('Updating the simulink library browser.')
disp('-----------------------------------')
if (verLessThan('matlab', '8.4'))  % R2014b
    lb = LibraryBrowser.StandaloneBrowser;
else   
    lb = LibraryBrowser.LibraryBrowser2;
end
lb.refreshLibraryBrowser;
disp('Update completed')
if (~verLessThan('matlab', '8.4'))  % R2014b
    % Add repository information if not yet done
    try
        load_system('HyEQ_Library_R2012b');
        if (strcmp(get_param('HyEQ_Library_R2012b', 'EnableLBRepository'), 'off'))
            set_param('HyEQ_Library_R2012b', 'Lock', 'off');
            set_param('HyEQ_Library_R2012b', 'EnableLBRepository', 'on');
            set_param('HyEQ_Library_R2012b', 'Lock', 'on');
            save_system('HyEQ_Library_R2012b');
        end
        close_system('HyEQ_Library_R2012b');
    catch
        disp('Error when updating simulink library browser');
    end
end
%%
disp('-----------------------------------')
htmlFolder = fullfile(TBfullpath,'helpFiles');
builddocsearchdb(htmlFolder)
disp('See under "Help, Documentation, Supplemental Software" for more informaton.')
disp('-----------------------------------')
disp('For documentation of the HyEQ toolbox, type')
disp(['web ' ,'HyEQ_Toolbox_v204.html'])
disp('-----------------------------------')

