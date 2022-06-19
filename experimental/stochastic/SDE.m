classdef SDE

    properties
        mu function_handle 
        sigma function_handle
%         a
%         b
    end

    methods

        function obj = SDE(mu, sigma)%, interval)
            obj.mu = mu;
            obj.sigma = sigma;
%             obj.a = interval(1);
%             obj.b = interval(2);
        end
    end


end