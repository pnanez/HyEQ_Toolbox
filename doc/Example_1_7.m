%% Example 2: Synchronization of Two Fireflies
% In this example, two hybrid subsystems in Simulink are used to model a pair of fireflies
% that exhibit synchronization of their flashes.

%% 
% The files for this example are found in the package
% |hybrid.examples.fireflies|:
% 
% * <matlab:open('hybrid.examples.fireflies.initialize') initialize.m> 
% * <matlab:hybrid.examples.fireflies.fireflies fireflies.slx> 
% * <matlab:open('hybrid.examples.fireflies.postprocess') postprocess.m> 
% 
% The contents of this package are located in
% <matlab:cd(hybrid.getFolderLocation('Examples','+hybrid','+examples','+fireflies')) |Examples\+hybrid\+examples\fireflies|>
% (clicking this link changes your working directory). 

%% 
% Consider a biological example of the synchronization of two fireflies
% flashing. The fireflies can be modeled mathematically as periodic oscillators
% which tend to synchronize their flashing until they are flashing in phase with
% each other. A state value of $\tau_i=1$ corresponds to a flash, and after each
% flash, the firefly automatically resets its internal timer (periodic cycle) to
% $\tau_i=0$. The synchronization of the fireflies can be modeled as an
% interconnection of two hybrid systems because every time one firefly flashes,
% the other firefly notices and jumps ahead in its internal timer $\tau$ by
% $(1+\varepsilon)\tau$, where $\varepsilon$ is a biologically determined
% coefficient. This happens until eventually both fireflies synchronize their
% internal timers and are flashing simultaneously.

%% Mathematical Model
% Each firefly can be modeled as a hybrid system given by
% 
% $$\begin{array}{ll}
% f_i(\tau_i,u_i) := 1, 
% & C_i := \{(\tau_i,u_i)\in \mathbf{R}^{2}\mid 0 \leq \tau_i \leq 1\}\cap
% \{(\tau_i,u_i)\in \mathbf{R}^{2}\mid 0 \leq u_i \leq 1\} \\
% g_i(\tau_i,u_i) :=
% \left\{
% \begin{array}{ll}
% (1+ \varepsilon)\tau_i
% & (1+\varepsilon)\tau_i<1 \\
% 0
% & (1+\varepsilon)\tau_i\geq 1
% \end{array}
% \right. &
%     D_i := \{(\tau_i,u_i)\in \mathbf{R}^{2} \mid \tau_i = 1\} \cup \{(\tau_i,u_i)\in \mathbf{R}^{2}\mid u_i = 1\}.
% \end{array}$$
%  

% Run the initialization script.
hybrid.examples.fireflies.initialize

% Run the Simulink model.
warning('off','Simulink:Commands:LoadingOlderModel')
simulink_model_path = which('hybrid.examples.fireflies.fireflies');
sim(simulink_model_path)
close_system
close all

% Construct HybridArc objects for the trajectory of each subsystem, 
% as computed by Simulink, so that we can use the plotting tools associated
% with HybridArcs, namely HybridPlotBuilder.
sol_1 = HybridArc(t1, j1, x1);
sol_2 = HybridArc(t2, j2, x2);

%% Simulink Model
% The following diagram shows the Simulink model of two interconnected
% firefly subsystems.
% 
% The interconnection diagram for this example is simpler than in the previous
% example <Add link> because now no external inputs are being considered. The only event
% that affects the flashing of a firefly is the flashing of the other firefly.
% The interconnection diagram can be seen here:

% Open .slx model. A screenshot of the subsystem will be
% automatically included in the published document.
example_name = 'fireflies';
model_path = ['hybrid.examples.', example_name ,'.', example_name];
open_system(which(model_path))

%%
% The Simulink blocks for the hybrid system in this example are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_7/f.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_7/C.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_7/g.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_7/D.m</include>

%% Example Output
% A solution to the interconnection of hybrid systems $\mathcal{H}_1$ and
% $\mathcal{H}_2$ with |T=15, J=15, rule = 1|, $\varepsilon=0.3$ is depicted in
% Figure~\ref{fig:fireflyH1H2}. Both the projection onto $t$ and $j$ are shown.
% A solution to the hybrid system $\mathcal{H}_1$ is depicted in
% Figure~\ref{fig:fireflyH1}. A solution to the hybrid system $\mathcal{H}_2$ is
% depicted in Figure~\ref{fig:fireflyH2}.    
% 
% These simulations reflect the expected behavior of the interconnected hybrid
% systems. The fireflies initially flash out of phase with one another and then
% synchronize to flash in the same phase.  

% Individual plots 
figure(1) % H1 Flows and Jumps        
clf                                   
subplot(2,1,1)   
hpb = HybridPlotBuilder();
hpb.color([0 0.447 0.741]).label('$\tau_1$').title('Firefly 1 (Flows)');
hpb.plotFlows(sol_1)
grid on                         
                                      
subplot(2,1,2)
hpb.title('Firefly 1 (Jumps)');
hpb.plotJumps(sol_1)     
grid on                                 
               
%%
figure(2) % H2 Flows and Jumps        
clf                            
subplot(2,1,1)   
hpb = HybridPlotBuilder();
hpb.color([0.85 0.325 0.098]).label('$\tau_2$').title('Firefly 2 (Flows)');
hpb.plotFlows(sol_2)
grid on                         
                                      
subplot(2,1,2)
hpb.title('Firefly 2 (Jumps)');
hpb.plotJumps(sol_2)     
grid on                                 
                                      
%%                                  
figure(3) % H1 and H2, Flows and Jumps
clf                  
                                
subplot(2,1,1)   
hpb = HybridPlotBuilder();
hpb.color('matlab').title('Fireflies (Flows)');
hpb.legend('Firefly 1 ($\tau_1$)').plotFlows(sol_1)
hold on
hpb.legend('Firefly 2 ($\tau_2$)').plotFlows(sol_2)                        
                                      
subplot(2,1,2)
hpb.color('matlab').title('Fireflies (Jumps)');
hpb.legend('Firefly 1 ($\tau_1$)').plotJumps(sol_1)
hold on
hpb.legend('Firefly 2 ($\tau_2)$').plotJumps(sol_2)   
xlim([0, 7])

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 
warning('on','Simulink:Commands:LoadingOlderModel') % Renable warning.

% Navigate to the doc/ directory so that code is correctly included with
% "<include>src/...</include>" commands.
cd(hybrid.getFolderLocation('doc')) 
