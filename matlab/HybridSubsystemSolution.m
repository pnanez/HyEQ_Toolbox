classdef HybridSubsystemSolution < HybridSolution
% Class of hybrid solutions that include input and output signals.
%
% See also: HybridSolution, HybridSubsystem, hybrid.CompositeHybridSolution.
% 
% Added in HyEQ Toolbox version 3.0.

% Written by Paul K. Wintz, Hybrid Systems Laboratory, UC Santa Cruz (©2022).

    properties(SetAccess = immutable)
        u % Input values (double array)
        y % Output values (double array)
    end
    
    methods
        function this = HybridSubsystemSolution(t, j, x, u, y, varargin)
            this = this@HybridSolution(t, j, x, varargin{:});
            assert(size(u, 1) == length(t), ...
                'length(u)=%d doesn''t match length(t)', ...
                size(u, 1), length(t))
            assert(size(y, 1) == length(t), ...
                'length(y)=%d doesn''t match length(t)', ...
                size(y, 1), length(t))
            this.u = u;
            this.y = y;
        end
        
        function out = evaluateFunctionWithInputs(this, func_hand, time_indices)
            % Evaluate a function handle at each point along the solution.
            % The function handle 'func_hand' is evaluated with the
            % arguments of the state 'x', input 'u' (optional), continuous time
            % 't' (optional), and discrete time 'j' (optional). This function
            % returns an array with length equal to the length of 't' (or
            % 'time_indices', if provided). Each row of the output array
            % contains the vector returned by 'func_hand' at the
            % corresponding entry in this HybridSolution.
            %
            % The argument 'func_hand' must be a function handle
            % with input arguments 
            %   '(x)', 
            %   '(x, u)', 
            %   '(x, u, t)', or 
            %   '(x, u, t, j)'
            % and output argument that is a column vector of fixed length and type 'double'.
            %
            % The argument 'time_indices' is optional. If supplied, the
            % function is evaluated only at the indices specificed and the
            % 'out' vector matches the legnth of 'time_indices.' 
            assert(isa(func_hand, 'function_handle'), ...
                'The ''func_hand'' argument must be a function handle.')
            
            if ~exist('indices', 'var')
                time_indices = 1:length(this.t);
            end
            
            if isempty(time_indices) 
                out = [];
                return
            end
            
            assert(length(time_indices) <= length(this.t), ...
                'The length of time_indices (%d) is greater than the length of this solution (%d).', ...
                length(time_indices), length(this.t))
            
            ndx0 = time_indices(1);
            val0 = evaluate_function(func_hand, this.x(ndx0, :)', this.u(ndx0, :)', this.t(ndx0), this.j(ndx0))';
            assert(isvector(val0), 'Function handle does not return a vector')
            
            out = NaN(length(time_indices), length(val0));
            
            for k=time_indices
                out(k, :) = evaluate_function(func_hand, this.x(k, :)', this.u(k, :)', this.t(k), this.j(k))';
            end
        end
    end

end

%%%% Local functions %%%%

function val_end = evaluate_function(fh, x, u, t, j)
switch nargin(fh)
    case 1
        val_end = fh(x);
    case 2
        val_end = fh(x, u);
    case 3
        val_end = fh(x, u, t);
    case 4
        val_end = fh(x, u, t, j);
    otherwise
        error('Hybrid:InvalidFunctionArguments', 'Function handle must have 1, 2, 3, or 4 arguments. Instead %s had %d',...
            func2str(fh), nargin(fh))
end
end