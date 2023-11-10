function [coeLSQ, coeMC] = estimate_local_gPC(stratum, numSampStratum, basisIndMatrix, maxPolynOrder, pdf)

% Compute local gPC coefficients for a stratum with test function samples

% INPUTS
% stratum: structure for the stratum
% numSampStratum: number of samples on the stratum
% basisIndMatrix: index matrix for multidimensional gPC basis
% maxPolynOrder: maximum polynomial order of basis functions 
% pdf: cell array with function handles to independent continous pdfs of
% the random variables

% OUTPUTS
% coeLSQ: gPC coefficents computed with standard least squares 
% coeMC: gPC coefficents computed with standard Monte Carlo

% Compute basis functions for all dimensions
numBasisFun = size(basisIndMatrix, 1);
numDim = size(stratum.samples,2);
basisFun = multi_dim_basis(pdf, stratum, numDim, maxPolynOrder);

% Currently we estimate the coefficients with two methods: MC
% integration is less accurate but robust to small sample sets.
% LSQ is more accurate but sensitive to small sample sets (underdetermined/rank deficient problem)
A = ones(numSampStratum, numBasisFun);
B = repmat(stratum.f_samples, 1, numBasisFun);
for indBF = 1:numBasisFun
    for indDim = 1:numDim
        A(:,indBF) = A(:,indBF).*basisFun{indDim}{basisIndMatrix(indBF, indDim)+1}(stratum.samples(:, indDim));

        B(:,indBF) = B(:,indBF).*basisFun{indDim}{basisIndMatrix(indBF, indDim)+1}(stratum.samples(:, indDim));
    end
end
coeLSQ = A\stratum.f_samples;
coeMC = mean(B);
                 