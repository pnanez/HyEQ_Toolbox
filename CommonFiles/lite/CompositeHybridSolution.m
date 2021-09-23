classdef CompositeHybridSolution < HybridSolution

    properties(GetAccess=private, SetAccess=immutable)
        subsys_sols
        subsystems
    end
    
    methods
        function this = CompositeHybridSolution(composite_solution, subsys_sols, tspan, jspan, subsystems)
            cs = composite_solution;
            this = this@HybridSolution(cs.t, cs.j, cs.x, cs.C_end, cs.D_end, tspan, jspan);
            this.subsys_sols = subsys_sols;
            this.subsystems = subsystems;
        end
        
        function sref = subsref(this,s)
            % Redefine the behavior of parentheses to reference subsystem
            % solutions.
            switch s(1).type
                case '()'
                    if length(s) == 1
                        if isscalar(this)
                            ndx = this.subsystems.getIndex(s.subs{1});
                            sref = this.subsys_sols{ndx};
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
                    if strcmp(s(1).subs, 'subsys_sols')
                        msg = {'Property ''subsys_sols'' is private.'
                            'Reference subsolutions with parentheses and one of the following:'
                            '1. index number, (e.g., sol(1))'
                            '2. subsystem object, (e.g., sol(subsys1)) or '
                            '3. subsystem name (e.g., sol(''plant'')). Requires names be passed to CompositeHybridSolution constructor.'};
                        error('%s\n',msg{:})
                    end
                    sref = builtin('subsref',this,s);
                case '{}'
                    error('CompositeHybridSolution:subsref',...
                        'Brace indexing is not supported on CompositeHybridSolution objects.')
            end
        end
        
        function len = length(this)
           % Define per this Stackoverflow answer: https://stackoverflow.com/a/29378151/6651650
           
           if isscalar(this)
               len = length(this.subsys_sols);
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
               ndx = length(this.subsys_sols);
           else
               % Handle the case where 'this' is an array.
               ndx = builtin('end',this,k,n);
           end
        end
    end
end

