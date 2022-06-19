classdef DiscretizedSDE
% DiscretizedSDE converts an SDE in the form
% 
% dX = mu(X, t) dt + sigma(X, t) dW,
% 
% to a discrete SDE 

    properties
        x0 = 0;
        t0 = 0;
        tf = 1;
        mu; 
        sigma = 1;
        a;
        b;
        x0_old;
        t0_old;
    end

    methods

        function obj = DiscretizedSDE(SDE, t0, x0)
            delta_t = 1;
            sigma = SDE.sigma(t0, x0);
            mu    = SDE.mu(t0, x0);
            s = sigma * sqrt(delta_t);
            obj.x0 = 0;
            obj.t0 = 0;
            obj.tf = 1;
            obj.mu = mu * sqrt(delta_t) / sigma; 
            obj.sigma = 1;
            obj.a = (SDE.a - x0) / s;
            obj.b = (SDE.b - x0) / s;
            obj.x0_old = x0;
            obj.t0_old = t0;
        end

        function X = sample(this, t)
            assert(t <= 1, 'delta_t was greater than 1.')
            X = this.mu * t + sqrt(t) * randn();
        end

        function passage_prob = passageProbability(this, x1)
            % x1 is a sample of X(1). 
            if x1 <= this.a || x1 >= this.b 
                passage_prob = 1;
                return
            end
            passage_prob_a = exp(-2*abs(this.a*(this.a - x1)));
            passage_prob_b = exp(-2*abs(this.b*(this.b - x1)));

            passage_prob = passage_prob_a + passage_prob_b;
        end

        function is_passage = sampleIsPassage(this, x1)
            passage_prob = this.passageProbability(x1);
            is_passage = passage_prob == 1;
            % is_passage = rand() < passage_prob;
        end

        function [t_star, X_star] = sampleForFirstPassage(this, x1)
            is_below_a = false;
            is_above_b = false;
            W = 0;
            K = 12;
            dt = 1 / K;
            W_prev = 0;
            for k=1:K
                tk = k*dt;
                time_remaining = 1 - tk;
                W_t = sqrt(dt) * randn();
                W_end = W_t + sqrt(time_remaining)*randn();
                W = W_t + (x1 - W_end)*tk;
                if W <= this.a 
                    is_below_a = true;
                    break;
                elseif W >= this.b
                    is_above_b = true;
                    break
                end
                W_prev = W;
            end

            % Interpolate between W_prev and W.
            last_slope = (W - W_prev) / dt;
            if is_below_a
                t_star = (this.a - W_prev) / last_slope + k*dt;
                X_star = this.a;
            elseif is_above_b
                t_star = (this.b - W_prev) / last_slope + k*dt;  
                X_star = this.b;              
            else 
                error('No pass detected')
            end
        end
    end

end