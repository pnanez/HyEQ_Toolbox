%% Introduction to Hybrid Systems
% This document gives a brief introduction to the mathematical modeling of
% hybrid systems and their solutions.
% A hybrid system $\mathcal{H}$ with state $x\in \mathbf{R}^n$ 
% is modeled as follows:
% 
% $$ 
% \mathcal{H}: \left\{\begin{array}{rl}
%     \dot x = f(x) & x \in C  
%       \\
%     x^+ = g(x) &x \in D
% \end{array} \right.
% $$ 
% 
% Throughout the HyEQ documentation, $\mathbf{R}$ denotes the set of real numbers
% and $\mathbf{N} := \{0, 1, \dots\}$ denotes the set of natural numbers. We
% define $\mathbf{R}_{\geq 0} := [0, \infty).$
% 
% The representation of $\mathcal{H}$, above, indicates that the state $x$ can evolve or
% _flow_ according to the differential equation $\dot x = f(x)$ while $x \in C,$
% and can _jump_ according to the difference equation $x^+ = g(x)$ while $x \in D.$
% The function $f : C \to \mathbf{R}^n$ is called the _flow map_, the
% set $C \subset \mathbf{R}^n$ is called the _flow set_, the function $g :
% D \to \mathbf{R}^n$ is called the _jump map_, and the set $D
% \subset \mathbf{R}^n$ is called the _jump set_.
% 
% Roughly speaking, a function $\phi : E \to \mathbf{R}^n$ is a _solution_ 
% to $\mathcal{H}$ if the following conditions are satisfied:
%  
% # $\phi(0, 0) \in \overline{C} \cup D.$
% # The domain $E \subset \mathbf{R} \times \mathbf{N}$ is a 
% _hybrid time domain_ where for each $(t, j) \in E$, the $t$ 
% component is the amount of ordinary time that has elapsed and the $j$ component
% is the number $j$ of discrete jumps that have occured.
% # For all $j\in \mathbf{N}$ such that $I^j := \{t \mid (t, j) \in E\}$ has
% nonempty interior, we have that $\phi(t, j) \in C$ for all 
% $t \in \mathrm{int}\: I^j$ and 
% $\frac{d\phi}{dt} = f(\phi(t, j))$ for almost all $t
% \in I^j$. We call $I^j$ an _interval of flow_.
% # At each $(t, j) \in E$ such that $(t, j+1) \in E$, then
% $\phi(t, j) \in D$ and $\phi(t, j+1) = g(\phi(t, j))$. We call such a $(t, j)$
% a _jump time_.
% 
% For a rigorous definition of hybrid solutions, see Chapter 2 of _Hybrid
% Dynamical Systems_ by Goebel, Sanfelice, and Teel [1]. See also _Hybrid
% Feedback Control_ by Sanfelice [2].

%% 
% <html><h2>References</h2></html>
% 
% [1] R. Goebel, R. G. Sanfelice, and A. R. Teel, _Hybrid dynamical systems:
% modeling, stability, and robustness_. Princeton University Press, 2012.  
% 
% [2] R. G. Sanfelice, _Hybrid Feedback Control_. Princeton University Press, 2021.
