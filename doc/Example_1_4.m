%% Example 1.4: Modeling Hybrid System Data with Simulink Blocks
% This example continues the discussion of the system presented in 
% <matlab:showdemo('Example_1_3') Example 1.3>, namely a ball bouncing on a
% moving platform is modeled in Simulink. We show here that a MATLAB function
% block can be replaced with operational blocks in Simulink. 
% Click
% <matlab:hybrid.open('Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks','Example1_4.slx') here> 
% to change your working directory to the Example 1.4 folder and open the
% Simulink model. 

%%
% The Simulink model, below, shows the jump set |D| modeled in Simulink using
% operational blocks instead of a MATLAB function block. The other functions for
% $f$, $C$, and $g$ are the same as in  
% <matlab:showdemo('Example_1_3') Example 1.3>.

% Open subsystem "HS" in Example1_4.slx. A screenshot of the subsystem will be
% automatically included in the published document.
wd_before = hybrid.open('Example_1.4-Bouncing_Ball_with_Simulink_operator_blocks');
open_system('Example1_4') % Open the model...
open_system('Example1_4/HS') % ...then open the subsystem "HS".
snapnow();

%%
% Solutions computed by this model are identical to those in
% <matlab:showdemo('Example_1_3') Example 1.3>.

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 


