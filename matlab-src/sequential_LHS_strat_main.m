
% This script runs the sequential stratified LHS method described in
% Krumscheid and Pettersson (2023) and can be used to reproduce the results
% and figures in that paper. Note that due to the difference in
% pseudo-random numbers, the results will not coincide exactly.

clearvars
close all
clc

testCases = [1, 0.001; 2, 2; 3, 10];
numTestCases = size(testCases,1);

% Number of repetitions of the evaluation of the method
numRep = 100;
% Number of (LHS) samples per stratum
numSampStratum = 50;

% Determine whether results/figures should be saved/plotted ('Y') or not
% ('N').
save_res = 'N';
plot_fig = 'Y';

% Set number of estimators in every sequence
numSeqEst = [6, 20];

        
for indSeqEst=1:length(numSeqEst)
    numEstimators = numSeqEst(indSeqEst);
    numSampTotal = sum([1:numEstimators])*numSampStratum;
    
    for indTestCase=1:numTestCases
        caseId = ['P',int2str(testCases(indTestCase,1))];
        caseParam = testCases(indTestCase,2);
        switch caseId
            case 'P1' 
                numDim = 2;
                for indDim = 1:numDim
                    pdf{indDim} = @(y) y.^0;
                end
                delta = caseParam;
                a = 0.3;
                f = @(y) 1./(abs(a-y(:,1).^2-y(:,2).^2) + delta);
            case 'P2'
                numDim = caseParam;
                for indDim = 1:numDim
                    pdf{indDim} = @(y) y.^0;
                end
                r = 0.4;
                c = 10;
                f = @(y) c*(y(:,1).^2 + y(:,2).^2 <= r^2);
            case 'P3'
                numDim = caseParam;
                for indDim = 1:numDim
                    pdf{indDim} = @(y) y.^0;
                end
                r1 = 0.4;
                r2 = 0.4;
                c = 10;
                f = @(y) c*(y(:,1).^2 + y(:,2).^2 <= r1^2) + c*(y(:,3).^2 + y(:,4).^2 <= r2^2);                 
        end
        
        % Polynomial order for the local gPC approximations, should be
        % problem-dependent!
        maxPolynOrder = 1; 
        % Introduce a total-order basis
        basisIndMatrix = nDimPolynomialArray(numDim, maxPolynOrder);
        numBasisFun = size(basisIndMatrix,1); % Total number of basis functions

        % Evaluate the variance weighted sequential stratified LHS
        % estimator, and standard LHS estimator.
        stand_LHS_est = zeros(numRep, 1);
        seqStrat_LHS_est = zeros(numRep, 1);
        for indRep=1:numRep
            [seqStrat_LHS_est(indRep), stand_LHS_est(indRep), stratumSeq] = compute_sequential_strat_LHS(f, pdf, numDim, numEstimators, numSampStratum, basisIndMatrix, maxPolynOrder);
        end

        % Save results
        if save_res == 'Y'
            fbase = 'results_emp_var/';
            fname = [fbase,'testcaseP',int2str(test_cases(tc)),'_Nseq_',int2str(numEstimators) ,'_Ntotal',int2str(numSampTotal),'_Nrep',int2str(numRep),'.txt'];
            fid = fopen(fname,'w');
            for j_rep=1:numRep
                fprintf(fid,'%d\t%1.3e\t%1.3e\n',seqStrat_LHS_est(j_rep), stand_LHS_est(j_rep));
            end
            fclose(fid);
        end
        % Plot results
        if plot_fig == 'Y' && numDim <= 3
            plot_stratification(numDim, stratumSeq{end}, f);
        end
    end
end

