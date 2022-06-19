mu = @(t, x) -1*x;
sigma = @(t, x) 1/x;
D = @(x) x <= 0;

a = -3;
% sde = SDE(mu, sigma);

T = 10;
N = 1000;
X0 = 10;
event_error_tol = 1e-9;
delta_t = T / N;
X = nan(N, 1);
t = nan(N, 1);
X(1) = X0;
t(1) = 0;

% Try non-OOP approach
for k = 1:(N-1)
    w0 = 0;
    wf = normrnd(0, sqrt(delta_t)); % W(t_k+1) - W(t_k)
    mu_k = mu(t(k), X(k));
    sigma_k = sigma(t(k), X(k));
    x_next_candidate = X(k) + delta_t * mu_k + sigma_k * wf;

    figure(1)
    clf
    if D(x_next_candidate)  
        i = -1;
        t0 = 0; % Step size lower bound
        tf = delta_t; % Step size upper bound
        while abs(tf - t0) > event_error_tol
            i = i +1;
            % For the next update, use the halfway point 
            % between t0 and tf.
            t_sample = (t0 + tf) / 2;
            w = sampleWienerMidpoint(t0, tf, w0, wf);
            y = X(k) + mu_k * t_sample + sigma_k * w;

            subplot(3, 1, 1)
            plot(i, tf, 'vb')
            hold on
            plot(i, t0, '^b')
            legend('t_f', 't_0')

            subplot(3, 1, 2)
            plot(i, w0, 'rv')
            hold on
            plot(i, w, 'rx')
            plot(i, wf, 'r^')
            hold on
            legend('w_f', 'w', 'w_0')

            subplot(3, 1, 3)
            if y < 0
                semilogy(i, -y, 'm_')
                hold on
            else
                semilogy(i, y, 'k+')
                hold on
            end
            hold on

            % Check if the sample would would take X into the 
            % jump set. 
            if D(y)
                tf = t_sample;
                wf = w;
            else
                t0 = t_sample;
                w0 = w;
            end
        end
        t(k+1) = t(k) + t_sample;
        X(k+1) = y;
        break
    end
    t(k+1) = t(k) + delta_t;
    X(k+1) = x_next_candidate;
end

figure(2)
clf
plot(t, abs(X))
min(X)
% ylim([0, inf])
xlim([0, T])



%%
for k = 1:N
    discretized_sde = DiscretizedSDE(sde, t(k), X(k));
    x1 = discretized_sde.sample(1);
    is_passage = discretized_sde.sampleIsPassage(x1);
    
    fprintf('is_passage? %d\n', is_passage)
    if is_passage
        [t_star, X_star] = discretized_sde.sampleForFirstPassage(x1);
        t(k+1) = t(k) + t_star * delta_t;
        X(k+1) = X_star;
        break
    end
    t(k+1) = (k+1)*delta_t;
    X(k+1) = x1;
end

figure(1)
clf
plot(t, X)
hold on
plot([0, T], [sde.a, sde.a], '--r')

%%
return
N = 200;
T = 10;
Delta_t = T / N;

x0 = 5000;
w = NaN(N, 1);
t = NaN(N, 1);
w(1) = x0;
t(1) = 0;
for k = 1:(N-1)
    t(k+1) = t(k) + Delta_t;
    dW = sqrt(Delta_t)*randn(1, 1);
    mu_k = mu(t(k), w(k));
    sigma_k = sigma(t(k), w(k));
    euler_forward = @(dt) w(k) + mu_k*dt + sigma_k*dW;
    Delta_t_candidate = Delta_t;
    x_next_candidate = euler_forward(Delta_t_candidate);
    if D(x_next_candidate) && abs(x_next_candidate - 1) > 1e-6
%         Brownian_bridge = @(t) 
        Delta_t_candidate = Delta_t_candidate / 2;
        x_next_candidate = euler_forward(Delta_t_candidate);

        assert(Delta_t_candidate > 0)
    end
    w(k+1) = x_next_candidate;
    t(k+1) = t(k) + x_next_candidate;
end

figure(1)
clf
plot(t, w)

% function discretized_SDE = discretize(SDE, t0, x0)
%     delta_t = 1;
%     sigma = SDE.sigma(t0, x0);
%     mu    = SDE.mu(t0, x0);
%     s = sigma * sqrt(delta_t);
%     discretized_SDE = struct();
%     discretized_SDE.x0 = 0;
%     discretized_SDE.t0 = 0;
%     discretized_SDE.tf = 1;
%     discretized_SDE.mu = mu * sqrt(delta_t) / sigma; 
%     discretized_SDE.sigma = 1;
%     discretized_SDE.a = (SDE.a - x0) / s;
%     discretized_SDE.b = (SDE.b - x0) / s;
%     discretized_SDE.x0_old = x0;
%     discretized_SDE.t0_old = x0;
%     
% end


function x_next = dimensionlessStep(mu, t)
    assert(delta_t <= 1, 'delta_t was greater than 1.')
    x_next = mu * t + sqrt(t) * randn();
end


function w = sampleWienerMidpoint(t0, tf, w0, wf)
    % For t0 < tf and t = (t0 + tf)/2 
    % draw a sample w = W(t) given
    % W(t0) = w0 and W(tf) = wf. 
    mean = (w0 + wf)/2;
    sd = sqrt((tf - t0)/4);
    w = normrnd(mean, sd);
end