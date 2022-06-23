function [t, x] = sde45(mu, tspan, x0, options)
% Compute a solution to dX = mu(t, X) dt + sigma(t, X) dW.
%

% Much of this function was adapted from the code in ode45.

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

a2=1/5;
a3=3/10;
a4=4/5;
a5=8/9;

b11=1/5;
b21=3/40;
b31=44/45;
b41=19372/6561;
b51=9017/3168;
b61=35/384;
b22=9/40;
b32=-56/15;
b42=-25360/2187;
b52=-355/33;
b33=32/9;
b43=64448/6561;
b53=46732/5247;
b63=500/1113;
b44=-212/729;
b54=49/176;
b64=125/192;
b55=-5103/18656;
b65=-2187/6784;
b66=11/84;

e1=71/57600;
e3=-71/16695;
e4=71/1920;
e5=-17253/339200;
e6=22/525;
e7=-1/40;

function [x_next, h_next] = ode45(t, x, h)

    pow = 1/5;
    hmin = 16*eps(t);

    nofailed = true;
    while true
        f1 = mu(t,x);

        x2 = x + h .* (b11.*f1 );
        t2 = t + h .* a2;
        f2 = mu(t2, x2);

        x3 = x + h .* (b21.*f1 + b22.*f2 );
        t3 = t + h .* a3;
        f3 = mu(t3, x3);

        x4 = x + h .* (b31.*f1 + b32.*f2 + b33.*f3 );
        t4 = t + h .* a4;
        f4 = mu(t4, x4);

        x5 = x + h .* (b41.*f1 + b42.*f2 + b43.*f3 + b44.*f4 );
        t5 = t + h .* a5;
        f5 = mu(t5, x5);

        x6 = x + h .* (b51.*f1 + b52.*f2 + b53.*f3 + b54.*f4 + b55.*f5 );
        t6 = t + h;
        f6 = mu(t6, x6);

        ynew = x + h.* ( b61.*f1 + b63.*f3 + b64.*f4 + b65.*f5 + b66.*f6 );
        tnew = t + h;
        f7 = mu(tnew,ynew);

        % Estimate the error.
        fE = f1*e1 + f3*e3 + f4*e4 + f5*e5 + f6*e6 + f7*e7;
        err = h * norm((fE) ./ max(abs(x),abs(ynew)),inf);

        rtol = abs_tol + rel_tol * max(norm(x), norm(ynew));

        % Accept the solution only if the weighted error is no more than the
        % tolerance rtol.  Estimate an h that will yield an error of rtol on
        % the next step or the next try at taking this step, as the case may be,
        % and use 0.8 of this value to avoid failures.
        if err <= rtol
            divisor = 1.25*(err/rtol)^pow;
            if divisor > 0.2
                h_next = h / divisor;
            else
                h_next = 5.0*h;
            end
            x_next = ynew;
            break % Good step.
        end

        if h <= hmin
            warning(message('MATLAB:ode45:IntegrationTolNotMet', sprintf( '%e', t ), sprintf( '%e', hmin )));
            x_next = ynew;
            return;
        end

        if nofailed
            nofailed = false;
            h = max(hmin, h * max(0.1, 0.8*(rtol/err)^pow));
        else
            h = max(hmin, 0.5 * h);
        end
    end


end

k = 1;
while t(k) < tspan(end)
    t_k = t(k);
    x_k = x(k, :)';
    w0 = 0;
    wf = normrnd(0, sqrt(h), size(x_k));
    %     mu_k = mu(t(k), x_k);
    sigma_k = sigma(t(k), x_k);

    [x_det_next, h_next] = ode45(t_k, x_k, h);
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
            y = ode45(t_k, x_k, t_sample) + sigma_k * dw;

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