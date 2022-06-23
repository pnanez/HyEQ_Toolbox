function [t, x] = sdeEulerForward(mu, tspan, x0, options)
% Compute a solution to dX = mu(t, X) dt + sigma(t, X) dW. 
%

if isfield(options, 'sigma')
    sigma = options.sigma;
else
    sigma = @(t, x) 0;
end

% TO-DO: Add assertions on input arguments.

% TO-DO: Read error tolerance and timestep from options.
event_error_tol = 1e-9;
delta_t = 1e-1;
N = ceil((tspan(2) - tspan(1)) / delta_t);
event_fnc = options.Events;
x = x0';
t = tspan(1);

function x_next = odeEuler(t, x, h)
    x_next = x + h * mu(t, x);
end

for k = 1:(N-1)
    t_k = t(k);
    x_k = x(k, :)';
    w0 = 0;
    wf = normrnd(0, sqrt(delta_t), size(x_k));
    sigma_k = sigma(t(k), x_k);
    x_next_candidate = odeEuler(t_k, x_k, delta_t) + sigma_k * wf;

    if ~event_fnc(t_k, x_next_candidate) % Event has occurred
        i = -1;
        t0 = 0; % Step size lower bound
        tf = delta_t; % Step size upper bound
        while abs(tf - t0) > event_error_tol
            i = i +1;
            % For the next update, use the halfway point 
            % between t0 and tf.
            t_sample = (t0 + tf) / 2;
            dw = sampleWienerMidpoint(t0, tf, w0, wf);
            y = odeEuler(t_k, x_k, t_sample) + sigma_k * dw;

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
    t(k+1, 1) = t(k) + delta_t;
    x(k+1, :) = x_next_candidate';
end

end

function w = sampleWienerMidpoint(t0, tf, w0, wf)
    % For t0 < tf and t = (t0 + tf)/2, draw a sample of (W(t) | W(t0) = w0, W(tf) = wf). 
    mean = (w0 + wf)/2;
    sd = sqrt((tf - t0)/4);
    w = normrnd(mean, sd);
end