classdef GradientUpdaterUsingMomentumAndWeightDecay < GradientUpdaterInterface
    properties
    end
    
    properties (Access = 'private')
        learningRate
        mu
        weightDecay
        
        weightsV
    end
    
    methods (Access = 'public')
        function obj = GradientUpdaterUsingMomentumAndWeightDecay(learningRate, mu, weightDecay)
            obj.learningRate = learningRate;
            obj.mu = mu; % momentum
            obj.weightDecay = weightDecay;
        end
        
        function [weights] = update(obj, weights, dw)
            if(isempty(obj.weightsV))
                obj.weightsV = zeros(size(dw'));
            end
            
            obj.weightsV =  obj.mu * obj.weightsV - dw' * obj.learningRate - obj.weightDecay * obj.learningRate * weights;
            weights = weights + obj.weightsV;
        end
        
        
    end    
end

