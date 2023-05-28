%% Example 4.0: 
% <html>
%   <!-- This meta block sets metadata that is used to generate the front matter 
%          for the Jekyll website.-->
%   <!-- The presence of the hide_from_website attribute hides this page. The actual value is not used.-->
%   <meta 
%     id="github_pages"
%     hide_from_website="true" 
%   />
% </html>
% 
% Following the model of a physical component 
% 
% $$\begin{array}{ll}
% \dot{x} = f(x,u), 
%       & C := \{ x \mid x \in \mathbf{R}^{n}\}, \\
% x^+ = g(x) = \emptyset, \quad 
%       & D := \emptyset, \\
% y = h(x,u), 
% \end{array}$$
%  
% a linear time-invariant model of the physical component is defined by
% 
% $$
% \begin{array}{l}
% f(x,u) = f_P(x,u)= A_P x + B_P u, \\ h(x,u) = h(x,u) = M_P x + N_P u
% \end{array}
% $$
% 
% where $A_P$, $B_P$, $M_P$, and $N_P$ are matrices of appropriate dimensions. 
% State and input constraints can directly be embedded into the set $C_P$. 
% For example, the constraint that $x$ has all of its components 
% nonnegative and that $u$ has its components with norm
% less or equal than one is captured by 
% 
% $$\begin{array}{ll}
% C_P = \{(x,u)\in\mathbf{R}^{n_P}\times \mathbf{R}^{m_P}\mid x_i \geq 0 \ \forall i \in \{1,2,\ldots,n_P\}\} 
% \\ \quad\qquad {} \cap \{(x,u)\in\mathbf{R}^{n_P}\times \mathbf{R}^{m_P} \mid |u_i| \leq 1 \  \forall i \in \{1,2,\ldots,m_P\}\}
% \end{array}
% $$
% 
% For example, the evolution of the temperature of a room with a heater
% can be modeled by a linear-time invariant system  
% with state $x$ denoting the temperature of the room
% and with input $u = (u_1,u_2)$, where 
% $u_1$ denotes whether the heater is turned on ($u_1 = 1$) or
% turned off ($u_1 = 0$) while $u_2$ denotes the temperature
% outside the room.
% The evolution of the temperature is given by
% 
% $$
% \begin{array}{l}
%  \dot{x} = -x + [z_\Delta \quad 1] \left[\begin{array}{c} u_1 \\ 
%   u_2\end{array}\right] \textrm{ when } (x,u)\in C_P = \{(x,u) \in \mathbf{R} \times\mathbf{R}^2 \mid u_1 \in \{0,1\}\}
% \end{array}
% $$
% 
% where $z_\Delta$ is a constant representing the heater capacity.