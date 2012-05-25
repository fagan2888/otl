function [ psogp ] = initPSOGP( params, kernFunc, kernParams, ... 
    deletionCriteria)
%TRAIN_PSOGP Summary of this function goes here
%   Detailed explanation goes here
    psogp = struct();
    
    psogp.capacity = params(1);
    psogp.noise = params(2);
    psogp.epsilon = params(3);
    psogp.covf = kernFunc;
    psogp.covf_params = kernParams;
    
    psogp.alpha = 0;
    psogp.C = 0;
   
    
    %deletion criteria is 'n' (norm) or 'm' (minimax)
    psogp.deletion_criteria = deletionCriteria;
    
end

