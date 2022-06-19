classdef StochasticHybridSystem < handle


    methods
        function b = flowMap(this, x)
            % The value of b for dX = b(x)dt + \sigma(x)dW(t)
            b = -x;
        end

        function sigma = flowNoise(this, x)
           sigma = 1;
        end

        function xplus = jumpMap(this, x)
            xplus = -20*x;
        end

        function inC = flowSetIndicator(this, x)
            inC = 1;
        end

        function inD = jumpSetIndicator(this, x)
            inD = abs(x) <= 1;
        end

        function [t, j, x] = solve(x0)
            T = 10;
            N = 100;
            delta_t = T / N;
            X = nan(N, 1);
            t = nan(N, 1);
            X(1) = 10;
            t(1) = 0;
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
        end
    end

end