function checkMethodArgumentNames(obj, fnc_names, arg_name_validators, error_string_fmts)
% Check that the given methods for the class of a given object have arguments that satisfy given validators.

mc = metaclass(obj);
for i = 1:length(fnc_names) % For each listed function.
    name = fnc_names{i};
    mask = arrayfun(@(x) strcmp(x.Name, name), mc.MethodList);
    method = mc.MethodList(mask);
    
    for j = 1:max(length(method.InputNames), length(arg_name_validators))
        if j <= length(method.InputNames)
            arg_name = method.InputNames{j};
        else 
            arg_name = '';
        end
        if j <= length(error_string_fmts)
            error_fmt = error_string_fmts{j};
        else 
            error_fmt = 'In method ''%s'', invalid argument name ''%s''.';
        end
        if j <= length(arg_name_validators)
            chk = arg_name_validators{j};
            msg = sprintf(error_fmt, name, arg_name);
            assert(chk(arg_name), 'Hybrid:InvalidMethodArgumentName', msg)
        end
    end
end
end