%% Example 1.6: Interconnection of Bouncing ball and Moving Platform
% In this example, a ball bouncing on a moving platform is modeled in Simulink.
% 
% Click
% <matlab:hybrid.open('Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform','Example1_6.slx') here> 
% to change your working directory to the Example 1.6 folder and open the
% Simulink model. 

%%
% Consider a bouncing ball ($\mathcal{H}_1$) bouncing on a platform ($\mathcal{H}_2$) at some
% initial height and converging to the ground at zero height. This is an
% interconnection problem because the current states of each system affect the
% behavior of the other system. In this interconnection, the bouncing ball will
% contact the platform, bounce back up, and cause a jump in height of the
% platform so that it gets closer to the ground. After some time, both the ball
% and the platform will converge to the ground. In order to model this system,
% the output of the bouncing ball becomes the input of the moving platform, and
% vice versa. For the simulation of the described system with regular data where
% $\mathcal{H}_1$ is given by
% 
% $$
% \begin{array}{ll}
% f_1(\xi, u_1,v_1):=\left[
%  \begin{array}{c}
%    \xi_2 \\
%  -\gamma - b\xi_2 + v_{11}
%  \end{array}
% \right],
%    & C_1 : = \{(\xi,u_1) \mid \xi_1 \geq u_1, u_1 \geq 0\}
%    \\ \\
% g_1(\xi, u_1, v_1):=\left[ \begin{array}{c}
%  \xi_1+\alpha_1\xi_2^2 \\
% e_1|\xi_2| + v_{12}
% \end{array}
% \right]\ ,
%      &D_1: =\{(\xi,u_1) \mid \xi_1 =u_1, u_1 \geq 0\}, 
%   \\ \\
% y_1 = h_1(\xi) : =\xi_1
% \end{array}
% $$
% 
% where $\gamma, b, \alpha_1 >0, e_1 \in [0,1)$, $\xi = [\xi_1 , \xi_2]^\top$ is
% the state, $y_1 \in \mathbf{R}$ is the output, $u_1 \in \mathbf{R}$ and $v_1 =
% [v_{11} , v_{12}]^\top \in \mathbf{R}^{2}$ are the inputs, and the hybrid
% system $\mathcal{H}_2$ is given by
% 
% $$\begin{array}{ll}
% f_2(\eta,u_2,v_2):=\left[\begin{array}{c}
%    \eta_2 \\
%    -\eta_1-2\eta_2 +v_{12}
%  \end{array} \right],
%    & C_2 : = \{(\eta,u_2) \mid \eta_1 \leq u_2, \eta_1 \geq 0\}
%  \\ \\
% g_2(\eta,u_2,v_2):=\left[\begin{array}{c}
%    \eta_1-\alpha_2|\eta_2| \\
%    -e_2|\eta_2| + v_{22}
% \end{array} \right],
%    & D_2: =\{(\eta,u_2) \mid \eta_1 = u_2, \eta_1 \geq 0 \},
%  \\ \\
% y_2 = h_2(\eta) := \eta_1
% \end{array}$$
% 
% where $\alpha_2 >0, e_2 \in [0,1)$, $\eta = [\eta_1 , \eta_2]^\top \in
% \mathbf{R}^{2}$ is the state, $y_2 \in \mathbf{R}$ is the output, and $u_2 \in
% \mathbf{R}$ and $v_2 = [v_{21} , v_{22}]^\top \in \mathbf{R}^{2}$ are the inputs.
% 
% Therefore, the interconnection may be defined by the input assignment
% 
% $$u_1 = y_2, \quad u_2 = y_1.$$
%
% The signals $v_1$  and $v_2$ are included as external inputs in the model in
% order to simulate the effects of environmental perturbations, such as a wind
% gust, on the system.
% 
% The MATLAB scripts in each of the function blocks of the implementation above
% are given as follows. The constants for the interconnected system are $\gamma
% = 0.8$, $b=0.1$, and $\alpha_1, \alpha_2=0.1$. 

%% Mathematical Model
% 
% The bouncing ball system on a moving platform is modeled as a hybrid system
% with the following data: 
% 
% $$\begin{array}{ll}
% f(x,u):=\left[\begin{array}{c}
%    x_{2} \\
%  -\gamma
%  \end{array}\right],
%    & C := \{ (x,u) \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \geq u \} \\
% g(x,u):=\left[ \begin{array}{c} 
%                    u \\ -\lambda x_{2}
%                \end{array}\right],
%    & D: = \{ (x,u) \in \mathbf{R}^{2} \times \mathbf{R} \mid x_{1} \leq u \ , \
%   x_{2} \leq 0\}
% \end{array}$$
% 
% where $\gamma >0$ is the gravity constant, $u$ is the height of the platform
% given as an input, and $\lambda \in [0,1)$ is the restitution coefficient.
%% Steps to Run Model
% 
% The following procedure is used to simulate this example using the model in the file |Example_1_2a.slx|:
% 
% * Navigate to the directory <matlab:hybrid.open('Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform') Examples/Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform>
% (clicking this link changes your working directory).
% * Open
% <matlab:hybrid.open('Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform','Example1_6.slx') |Example_1_6.slx|> 
% in Simulink (clicking this link changes your working directory and opens the model).   
% * Double-click the block labeled _Double Click to Initialize_.
% * To start the simulation, click the _run_ button or select |Simulation>Run|.
% * Once the simulation finishes, click the block labeled _Double Click to Plot
% Solutions_. Several plots of the computed solution will open.
% 

% Change working directory to the example folder.
wd_before = hybrid.open('Example_1.6-Interconnection_of_Bouncing_Ball_and_Moving_Platform');

% Run the initialization script.
initialization_ex1_6

% Run the Simulink model.
sim('Example1_6')

% Convert the values t, j, and x output by the simulation into a HybridArc object.
sol_1 = HybridArc(t1, j1, x1);
sol_2 = HybridArc(t2, j2, x2);

xi1_arc = sol_1.slice(1);                   
xi2_arc = sol_1.slice(2);               
eta1_arc = sol_2.slice(1);            
eta2_arc = sol_2.slice(2);                                            
                                                                     
%% Individual plots                    
figure(1) % H1 Flows and Jumps        
clf       
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\xi_1$').plotFlows(xi1_arc)   
grid on                             
                                      
subplot(2,1,2)
hpb.plotJumps(xi1_arc)   
grid on                       
   
%%
figure(2) % H1 Velocity               
clf                
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\xi_2$').plotFlows(xi2_arc)   
grid on                             
                                      
subplot(2,1,2)
hpb.plotJumps(xi2_arc)   
grid on                       
     
%%
figure(3) % H2 Flows and Jumps        
clf                    

subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\eta_1$').plotFlows(eta1_arc)   
grid on                             
                              
subplot(2,1,2)
hpb.plotJumps(eta1_arc)   
grid on                         
           
%%
figure(4) % H2 Velocity               
clf                     
subplot(2,1,1)
hpb = HybridPlotBuilder();
hpb.label('$\eta_2$').plotFlows(eta2_arc)   
grid on                             
                                      
subplot(2,1,2)
hpb.plotJumps(eta2_arc)   
grid on   

%%                      
figure(5) % H1 and H2, Flows and Jumps
clf 
hpb = HybridPlotBuilder();
hpb.color('matlab');
hpb.legend('$\xi_1$').plotFlows(xi1_arc)
hold on                               
hpb.legend('$\eta_1$').plotFlows(eta1_arc)                           
grid on

%% Simulink Model
% The following diagram shows the Simulink model of the bouncing ball. The
% contents of the blocks *flow map* |f|, *flow set* |C|, etc., are shown below. 
% When the Simulink model is open, the blocks can be viewed and modified by
% double clicking on them.

% Open subsystem "HS" in Example1_6.slx. A screenshot of the subsystem will be
% automatically included in the published document.
open_system('Example1_6')

%% 
% The Simulink blocks for system 1 are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_6/f1.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_6/g1.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_6/C1.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_6/D1.m</include>
%% 
% The Simulink blocks for system 2 are included below.
%
% *flow map* |f| *block*
% 
% <include>src/Matlab2tex_1_6/f2.m</include>
%
% *flow set* |C| *block*
% 
% <include>src/Matlab2tex_1_6/g2.m</include>
%
% *jump map* |g| *block*
% 
% <include>src/Matlab2tex_1_6/C2.m</include>
%
% *jump set* |D| *block*
% 
% <include>src/Matlab2tex_1_6/D2.m</include>

%% Example Output
% 

clf
plotFlows(sol_1)

%%
% The following plot depicts the hybrid arc for the height of the ball in hybrid time. 
clf
plotHybrid(sol_1.slice(1))     
grid on
view(37.5, 30) 

%% 

% Clean up. It's important to include an empty line before this comment so it's
% not included in the HTML. 

% Close the Simulink file.
close_system 

% Restore previous working directory.
cd(wd_before) 


%%
% FROM TEX %%%


% 
% \begin{figure}[ht!]
%   \begin{center}
%   \psfrag{flows [t]}[c]{flows [$t$]}
%   \psfrag{jumps [j]}[c]{jumps [$j$]}
%   \psfrag{xi1, eta1}[c]{$\xi_1, \eta_1$}
%   \psfrag{xi2, eta2}[c]{$\xi_2, \eta_2$}
%     {\includegraphics[width=.8\textwidth]{figures/Examples/InterconnectionH1H2.eps}}
%    \caption{Solution of Example~\mathbf{R}f{ex:interconnection1}: height and velocity}
% \label{fig:interconnection-2}
%   \end{center}
% \end{figure}
% 
% %\begin{figure}[ht]
% %  \begin{center}
% %  \psfrag{flows [t]}[c]{flows [$t$]}
% %  \psfrag{jumps [j]}[c]{jumps [$j$]}
% %  \psfrag{xi1}[c]{$\xi_1$}
% %    {\includegraphics[width=.8\textwidth]{figures/Examples/InterconnectionH1.eps}}
% %   \caption{Solution of Example~\mathbf{R}f{ex:interconnection1} for system $\mathcal{H}_1$: height}
% %\label{fig:interconnection-3}
% %  \end{center}
% %\end{figure}
% %
% %\begin{figure}[ht]
% %  \begin{center}
% %  \psfrag{flows [t]}[c]{flows [$t$]}
% %  \psfrag{jumps [j]}[c]{jumps [$j$]}
% %  \psfrag{xi2}[c]{$\xi_2$}
% %    {\includegraphics[width=.8\textwidth]{figures/Examples/InterconnectionH1velocity.eps}}
% %   \caption{Solution of Example~\mathbf{R}f{ex:interconnection1} for system $\mathcal{H}_1$: velocity}
% %\label{fig:interconnection-4}
% %  \end{center}
% %\end{figure}
% 
% \begin{figure}[ht]
%   \centering
%   \psfrag{flows [t]}[c]{flows [$t$]}
%   \psfrag{jumps [j]}[c]{jumps [$j$]}
%   \psfrag{xi1}[c]{$\xi_1$}
%   \psfrag{xi2}[c]{$\xi_2$}
% \subfigure[Height]{
%     \includegraphics[width=.45\textwidth]{figures/Examples/InterconnectionH1.eps}
% \label{fig:interconnection-3}}
% \qquad
% \subfigure[Velocity]{
%     \includegraphics[width=.45\textwidth]{figures/Examples/InterconnectionH1velocity.eps}
% \label{fig:interconnection-4}}
% \caption{Solution of Example \mathbf{R}f{ex:interconnection1} for system $\mathcal{H}_1$}
% \end{figure}
% 
% %\begin{figure}[ht]
% %  \begin{center}
% %  \psfrag{flows [t]}[c]{flows [$t$]}
% %  \psfrag{jumps [j]}[c]{jumps [$j$]}
% %  \psfrag{eta1}[c]{$\eta_1$}
% %    {\includegraphics[width=.8\textwidth]{figures/Examples/InterconnectionH2.eps}}
% %   \caption{Solution of Example~\mathbf{R}f{ex:interconnection1} for system $\mathcal{H}_2$: height}
% %\label{fig:interconnection-5}
% %  \end{center}
% %\end{figure}
% %
% %\begin{figure}[ht]
% %  \begin{center}
% %  \psfrag{flows [t]}[c]{flows [$t$]}
% %  \psfrag{jumps [j]}[c]{jumps [$j$]}
% %  \psfrag{eta2}[c]{$\eta_2$}
% %    {\includegraphics[width=.8\textwidth]{figures/Examples/InterconnectionH2velocity.eps}}
% %   \caption{Solution of Example~\mathbf{R}f{ex:interconnection1} for system $\mathcal{H}_2$: velocity}
% %\label{fig:interconnection-6}
% %  \end{center}
% %\end{figure}
% 
% \begin{figure}[ht]
%   \centering
%   \psfrag{flows [t]}[c]{flows [$t$]}
%   \psfrag{jumps [j]}[c]{jumps [$j$]}
%   \psfrag{eta1}[c]{$\eta_1$}
%   \psfrag{eta2}[c]{$\eta_2$}
% \subfigure[Height]{
%     \includegraphics[width=.45\textwidth]{figures/Examples/InterconnectionH2.eps}
% \label{fig:interconnection-5}}
% \qquad
% \subfigure[Velocity]{
%     \includegraphics[width=.45\textwidth]{figures/Examples/InterconnectionH2velocity.eps}
% \label{fig:interconnection-6}}
% \caption{Solution of Example~\mathbf{R}f{ex:interconnection1} for system $\mathcal{H}_2$}
% \end{figure}
% 
% A solution to the interconnection of hybrid systems $\mathcal{H}_1$ and
% $\mathcal{H}_2$ with $T=18, J=20$, $rule =1$, is depicted in Figure~\mathbf{R}f{fig:interconnection-2}.
% Both the projection onto $t$ and $j$ are shown. A solution to the hybrid system $\mathcal{H}_1$ is
% depicted in Figure~\mathbf{R}f{fig:interconnection-3} (height) and Figure~\mathbf{R}f{fig:interconnection-4}
% (velocity). A solution to the hybrid system $\mathcal{H}_2$ is depicted in
% Figure~\mathbf{R}f{fig:interconnection-5} (height) and Figure~\mathbf{R}f{fig:interconnection-6} (velocity).
% 
% These simulations reflect the expected behavior of the interconnected hybrid systems. 
% Note that in order to implement these systems without premature stopping of
% the simulation, $\xi_1$ in $g_1$ and $\eta_1$ in $g_2$ can be changed to $u_1$
% and $u_2$, respectively so that $\xi_1^+=u_1$ and $\eta_1^+=u_2$.  
% 
% For MATLAB/Simulink files of this example, see \IfSAE{Examples/Example\_\mathbf{R}f{ex:interconnection1}}{Examples/Example\_1.6}.
% example}

