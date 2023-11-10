function [seqStrat_LHS_est, SLHS_est, stratumSeq] = compute_sequential_strat_LHS(f, pdf, numDim, numEstimators, numSampStratum, basisIndMatrix, maxPolynOrder)

% Compute the variance weighted estimator from sequennce of stratified LHS estimators

% INPUTS
% f: function handle to test function
% pdf: cell array with handles to independent probability density functions
% numDim: number of random dimensions
% numEstimators: number of sequential estimators 
% numSampStratum: number of samples in every stratum
% basisIndMatrix: index matrix for multidimensional generalized polynoial chaos 
% maxPolynOrder: maximum order of polynomial basis functions

% OUTPUTS
% seqStrat_LHS_est: variance weighted estimator from sequence of stratified
% LHS estimators
% SLHS_est: standards LHS estimate
% stratumSeq: cell array with stratifications


stratumSeq = cell(numEstimators,1);

% Initialize a single stratum for the first estimator
stratum{1}.a = zeros(numDim,1);
stratum{1}.b = ones(numDim,1);
stratum{1}.p = 1;

for indEstimSeq = 1:numEstimators
    
    numStrat = indEstimSeq;
    
    splitWeight = zeros(numStrat,numDim);
    
    % THE STRAT-LHS (SINGLE SEQ MEMBER) EST STARTS HERE, BUT
    % SPLITTING STRATEGY IS INTEGRATED, NOT A SEPARATE STEP
    for indStrat=1:numStrat
      
        % Allocate LHS samples and compute stratum statistics
        stratum{indStrat} = stratum_LHS_allocation(stratum{indStrat}, numSampStratum, f, numDim);
        
        % Compute stratum-wise gPC coefficients for sensitivity
        % analysis
        [coeLSQ, coeMC] = estimate_local_gPC(stratum{indStrat}, numSampStratum, basisIndMatrix, maxPolynOrder, pdf);
        
        % Compute Sobol sensitivity indicies and stratum splitting
        % criterion for next estimator
        Sobol_sens = sensitivityDecomp(coeLSQ, basisIndMatrix);
        splitWeight(indStrat,:) = Sobol_sens'*stratum{indStrat}.p;
    end
    
    % Save current stratification to the sequence of estimators
    stratumSeq{indEstimSeq} = stratum;
    
    
    % Determine splitting
    [~,ind] = max(splitWeight(:));
    [split_stratum,split_dim] = ind2sub([numStrat,numDim],ind);
    
    % Assign new stratification
    stratum = refine_stratification(stratum, split_stratum, split_dim);
    
    % Compute the mean by assembling stratum means, and
    % estimate variance
    ADSS_LHS_mean = zeros(1, numEstimators);
    ADSS_LHS_var_est = zeros(1, numEstimators);
    for indStrat=1:numStrat
        ADSS_LHS_mean(1, indEstimSeq) = ADSS_LHS_mean(1, indEstimSeq) + stratumSeq{indEstimSeq}{indStrat}.p*stratumSeq{indEstimSeq}{indStrat}.mean;
        % Currently use standard SS estimates from P&K22, i.e.
        % ignoring LHS and just assuming SMC
        ADSS_LHS_var_est(1, indEstimSeq) = ADSS_LHS_var_est(1, indEstimSeq) + 1/numSampStratum*stratumSeq{indEstimSeq}{indStrat}.p^2*stratumSeq{indEstimSeq}{indStrat}.sigma^2;
    end
end
% Compute a standard LHS mean with the same number of samples for
% speedup comparison
numSampTotal = sum([1:numEstimators])*numSampStratum;
SLHS = 1;
if SLHS
    SLHS_est = mean(f(lhsdesign(numSampTotal, numDim)));
end

% Compute the estimator of variance weighted sequence members
seqStrat_LHS_est = var_weighted_estimator(ADSS_LHS_mean, ADSS_LHS_var_est, numEstimators);
end
