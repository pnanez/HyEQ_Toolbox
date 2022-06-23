function [t, x] = sde12(mu, tspan, x0, options)
% Compute a solution to dX = mu(t, X) dt + sigma(t, X) dW. 
%

if isfield(options, 'sigma')
    sigma = options.sigma;
else
    sigma = @(t, x) 0;
end

% TO-DO: Add assertions on input arguments.

% TO-DO: Read error tolerance and timestep from options.
abs_tol = 1e-9;
rel_tol = 1e-7;

event_error_tol = 1e-9;
delta_t = 1e-5; % Initial step size.
event_fnc = options.Events;
x = x0';
t = tspan(1);
h = delta_t;

function [x_next, h_next] = odeEmbeddedHeun(t, x, h)
    k1 = mu(t, x);
    x_next_euler = x + h * k1;
    t_next = t + h;
    k2 = mu(t_next, x_next_euler);
    x_next_huen = x + 0.5*h*(k1 + k2);

    q = 1; % Order of lower-order method.

    % Estimated error.
    error = x_next_euler - x_next_huen;
    
    % User-defined tolerance.
    tol_n = abs_tol + rel_tol * max(norm(x), norm(x_next_huen));

    % Normalized error
    E_n = norm(error / tol_n);

    h_next = h*(1/E_n)^(1/(q+1));
    x_next = x_next_euler;
end

k = 1;
while t(k) < tspan(end)
    t_k = t(k);
    x_k = x(k, :)';
    w0 = 0;
    wf = normrnd(0, sqrt(h), size(x_k)); 
%     mu_k = mu(t(k), x_k);
    sigma_k = sigma(t(k), x_k);

    [x_det_next, h_next] = odeEmbeddedHeun(t_k, x_k, h);
    x_next_candidate = x_det_next + sigma_k * wf;

    if ~event_fnc(t_k, x_next_candidate) % Event has occurred
        i = -1;
        t0 = 0; % Step size lower bound
        tf = h; % Step size upper bound
        while abs(tf - t0) > event_error_tol
            i = i +1;
            % For the next update, use the halfway point 
            % between t0 and tf.
            t_sample = (t0 + tf) / 2;
            dw = sampleWienerMidpoint(t0, tf, w0, wf);
            y = odeEmbeddedHeun(t_k, x_k, t_sample) + sigma_k * dw;

            % Check if the sample would would take X into the 
            % jump set. 
            if ~event_fnc(t_sample, y) % event has occurred
                tf = t_sample;
                wf = dw;
            else % event has not occurred.
                t0 = t_sample;
                w0 = dw;
            end
        end
        t(k+1, 1) = t(k) + t_sample;
        x(k+1, :) = y';
        break
    end
    t(k+1, 1) = t(k) + h;
    x(k+1, :) = x_next_candidate';
    h = h_next;
    k = k+1;
end

end

function w = sampleWienerMidpoint(t0, tf, w0, wf)
    % For t0 < tf and t = (t0 + tf)/2, draw a sample of (W(t) | W(t0) = w0, W(tf) = wf). 
    mean = (w0 + wf)/2;
    sd = sqrt((tf - t0)/4);
    w = normrnd(mean, sd);
end