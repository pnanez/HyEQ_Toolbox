
flowNoiseSD = @(x, t, j) [0, 0; 0, 0.0];
jumpNoiseSD = @(x, t, j) [0; 0.5*norm(x)^2];

sys = HybridSystemBuilder()...
    .flowMap(@(x) [0, 1; -1, 0]*x)...
    .flowSetIndicator(@(x) 1)...
    .jumpSetIndicator(@(x) 0)...
    .build();

sys = hybrid.examples.BouncingBall();
sys.bounce_coeff = 0.9;
stochastic_sys = StochasticHybridSystem(sys, flowNoiseSD, jumpNoiseSD)

tspan = [0, 10];
jspan = [0, 10];
config = HybridSolverConfig('odeSolver', 'sde45')
sol = stochastic_sys.solve([1; 0], tspan, jspan, config)
plotPhase(sol)

1-norm(sol.x(end, :)')

return
%%

f = @(x, t, j) [x(2); -9.8];
sigma = @(x, t, j) 0.1*[0, 0; 0, 1];%*abs(x(2));
g = @(x, t, j) [x(1); -0.9*x(2)];
C = @(x) x(1) >= 0 || x(2) >= 0;
D = @(x) x(1) <= 0 && x(2) <= 0;

tspan = [0, 30];
jspan = [0, 100];
x0 = [10; 0];

% [t, x] = sdeEulerForward(mu, sigma, tspan, X0, options);
rule = 2;
options = odeset();
options.sigma = sigma;
[t, j, x] = HyEQsolver(f,g,C,D,x0,tspan,jspan, rule, options, 'sdeEulerForward');
sol = HybridArc(t, j, x);

figure(2)
clf
plotPhase(sol);
% hold on
% theta = linspace(0, 2*pi);
% plot(cos(theta), sin(theta), 'r--');

% plot(x(:, 1), x(:, 2))
% min(vecnorm(X'))
% axis equal
% ylim([0, inf])
% xlim([0, T])



return
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