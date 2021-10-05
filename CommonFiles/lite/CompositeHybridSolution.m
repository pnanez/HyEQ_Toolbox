classdef CompositeHybridSolution < HybridSolution

    properties(SetAccess = immutable, Hidden)
        subsystem_solutions 
    end
    
    properties(GetAccess=private, SetAccess=immutable)
        subsystems
    end
    
    methods
        function this = CompositeHybridSolution(composite_solution, ...
                subsystem_solutions, tspan, jspan, subsystems)
            % Constructor for CompositeHybridSolution.
            cs = composite_solution;
            this = this@HybridSolution(cs.t, cs.j, cs.x, cs.C_end, cs.D_end, tspan, jspan, cs.solver_config);
            this.subsystem_solutions = subsystem_solutions;
            this.subsystems = subsystems;
        end
        
        function sref = subsref(this,s)
            % Redefine the behavior of parentheses (such as 'sol(1)') to reference subsystem solutions.
            switch s(1).type
                case '()'
                    if length(s) == 1
                        if isscalar(this)
                            ndx = this.subsystems.getIndex(s.subs{1});
                            sref = this.subsystem_solutions{ndx};
                        else
                            % Handle the case where 'this' is an array.
                            sref = builtin('subsref',this,s);
                        end
                    else
                        % Call subsref recursively using only the first entry
                        % of 's' to get the subsystem solution.
                        subsol = subsref(this, s(1));
                        try
                        % Reference properties on the subsystem solution.
                        sref = builtin('subsref',subsol,s(2:end));
                        catch e
                            throwAsCaller(e);
                        end
                    end
                case '.'
                    sref = builtin('subsref',this,s);
                case '{}'
                    % This does not prevent accessing elements of a cell array
                    % that contains CompositeHybridSolutions.
                    error('CompositeHybridSolution:subsref',...
                        'Brace indexing is not supported on CompositeHybridSolution objects.')
            end
        end
        
        function len = length(this)
           % Define per this Stackoverflow answer: https://stackoverflow.com/a/29378151/6651650
           
           if isscalar(this)
               len = length(this.subsystem_solutions);
           else
               % Handle the case where 'this' is an array.
               len = builtin('length',this);
           end
        end
        
        function ndx = end(this,k,n)
           % Define per this Stackoverflow answer: https://stackoverflow.com/a/29378151/6651650
           % k is the index in the expression using the end syntax
           % n is the total number of indices in the expression

           if isscalar(this)
               assert(n == 1, 'Using multiple indexes (i.e., ''sol(end, 1)'') is not supported on CompositeHybridSolution objects.');
               ndx = length(this.subsystem_solutions);
           else
               % Handle the case where 'this' is an array.
               ndx = builtin('end',this,k,n);
           end
        end
    end
end

