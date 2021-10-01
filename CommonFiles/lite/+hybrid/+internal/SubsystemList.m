classdef SubsystemList
    
    properties(SetAccess = immutable)
        entries cell = {};
        names cell = {};
    end
    
    properties(Dependent)
       has_names 
    end
    
    methods
        function obj = SubsystemList(varargin) % no names given1
            if isa(varargin{1}, 'HybridSubsystem')
                subsystems = varargin;
                names = {};
            elseif isa(varargin{1}, 'string') || ischar(varargin{1}) % if names given
                is_even = rem(length(varargin),2) == 0;
                if ~is_even
                    error('CompoundArgument:InvalidConstructorArgs', ...
                        'When subsystem names are given, there must be an even number of arguments.')
                end
                n_subsystems = length(varargin)/2;
                subsystems = cell(n_subsystems, 1);
                for i=2:2:length(varargin)
                    names{i/2} = varargin{i-1}; %#ok<AGROW>
                    subsystems{i/2} = varargin{i};
                end
                names = cellstr(names);
                if length(unique(names)) < length(names)
                    error('CompositeHybridSystem:DuplicateName', ...
                        'One of the names of the subsystems was not  unique');
                end
            else
                error('CompositeHybridSystem:UnexpectedType', ...
                    'Expected first argument to be a HybridSubsystem or a string. Instead it was a %s.',...
                    class(varargin{1}));
            end
            for i = 1:length(subsystems)
                if ~isa(subsystems{i}, 'HybridSubsystem')
                    e = MException('CompositeHybridSystem:UnexpectedType', ...
                        'subsystem{%d} was a %s instead of a HybridSubsystem', ...
                        i, class(subsystems{i}));
                    throw(e);
                end
                if ~isscalar(subsystems{i})
                    e = MException('CompoundArgument:InvalidConstructorArgs', ...
                        'Each constructor argument must be a scalar. Instead argument %d had size %s.', i, mat2str(size(subsystems{i})));
                    throw(e);
                end
            end
            obj.entries = subsystems;
            obj.names = names;
        end
        
        function n = length(this)
            n = length(this.entries);
        end
        
        function subsys = get(this, subsys_id)
            ndx = getIndex(this, subsys_id);
            subsys = this.entries{ndx};
        end
        
        function name = getName(this, subsys_id)
            if this.has_names
                ndx = getIndex(this, subsys_id);
                name = this.names{ndx};
            else
                name = '';
            end
        end
        
        function ndx = getIndex(this, subsys_id)
            % subsys_id can be a HybridSubsystem or an integer index.
            if isa(subsys_id, 'HybridSubsystem')
                ndx = find(cellfun(@(x)x == subsys_id, this.entries));
            elseif ~isscalar(subsys_id) && ~ischar(subsys_id)
                % Check that an array of indices were not prvided, unless the
                % array is a char array (which represents a single subsystem). 
                e = MException('CompositeHybridSystem:MultipleIndices',...
                    'Cannot reference multiple subsystems at once. Please provide a single id.');
                throwAsCaller(e);
            elseif isnumeric(subsys_id) 
                % Don't use 'isinteger' here because Matlab interprets
                % number literals (such as '2') as doubles.
                ndx = uint32(subsys_id);
                if ndx ~= floor(subsys_id) 
                    e = MException('CompositeHybridSystem:InvalidSubsystemIndex',...
                        'Argument ''%f'' was a number but not an integer.', ndx);
                    throwAsCaller(e);
                end
                if ndx < 1 || ndx > this.length
                    e = MException('CompositeHybridSystem:InvalidSubsystemIndex', ...
                        'Index ''%d'' was out of range: 1, ..., %d.', ...
                        ndx, this.subsys_n);
                    throwAsCaller(e);
                end
            elseif isa(subsys_id, 'string') || ischar(subsys_id)
                if isempty(this.names)
                    error('CompositeHybridSystem:NoNamesProvided',...
                        'Cannot reference subsystems by name because names were not provided at construction.')
                end
                name = subsys_id;
                ndx = find(cellfun(@(x) strcmp(x, name), this.names));
            else
                e = MException('CompositeHybridSystem:InvalidArgument', ...
                    'Argument must be a HybridSubsystem, integer, or string. Instead was ''%s''.',...
                    class(subsys_id));
                throwAsCaller(e);
            end
            
            if isempty(ndx)
                e = MException('CompositeHybridSystem:NotASubsystem', ...
                    'Argument was not a subsystem in this system.');
                throwAsCaller(e);
            elseif length(ndx) > 1
                e = MException('CompositeHybridSystem:AmbiguousArgument', ...
                    'Ambiguous argument: The given subsystem occurs multiple times.');
                throwAsCaller(e);
            end
        end
            
        function val = get.has_names(this)
            val = ~isempty(this.names);
        end
            
    end
    
end