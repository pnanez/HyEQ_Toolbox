function checkHybridSolution(sol, f_vals, g_vals, C_vals, D_vals, priority)

    % Flow error tolerance (We allow a large tolerance because we use a
    % first-order approximation of dxdt).
    f_tol = 1e-1; 
    % Jump error tolerace
    g_tol = 1e-8; 
    delta_t = diff(sol.t);
    verifyHybridSolutionDomain(sol.t, sol.j, C_vals, D_vals, priority)
    
    if size(sol.x, 1) ~= length(sol.t)
        error("HybridSolution:SizesDoNotMatch", ...
            "length(x)=%d does not match length(t)=%d", ...
            size(sol.x, 1), length(sol.t))
    end 
    if ~(all(size(sol.x) == size(f_vals)))
        error("HybridSolution:SizesDoNotMatch", ...
            "size(x)=%s does not match size(f_vals)=%s", ...
            mat2str(size(sol.x)), mat2str(size(f_vals)))
    end 
    if ~(all(size(sol.x) == size(g_vals)))
        error("HybridSolution:SizesDoNotMatch",  ...
            "size(x)=%s does not match size(g_vals)=%s", ...
            mat2str(size(sol.x)), mat2str(size(g_vals)))
    end
    
    [~, ~, ~, is_jump] = hybrid.internal.jumpTimes(sol.t, sol.j);
    for i = 1:(length(sol.t)-1)
        x = sol.x(i, :)';
        x_next = sol.x(i+1, :)';
        if is_jump(i)
           g_of_x = g_vals(i,:)';
           g_error = norm(x_next - g_of_x);
           if g_error > g_tol
                error("HybridSolution:IncorrectJump", ...
                    "At a jump,\nx(k+1)=%s\nis not close to\ng(x(k))=%s\nError=%.3f",...
                    mat2str(x_next,4), mat2str(g_of_x,4), g_error)
           end
        else % is flow
            f_of_x = f_vals(i,:)';
            dxdt = (x_next - x) / delta_t(i);
            f_error = norm(dxdt - f_of_x);
            if f_error > f_tol
                error("HybridSolution:IncorrectFlow", ...
                "During an interval of flow, \ndx/dt=%s\nnot close to\n f(x)=%s\nError=%.3f", ...
                mat2str(dxdt,4), mat2str(f_of_x,4), f_error)
            end
        end
    end
end