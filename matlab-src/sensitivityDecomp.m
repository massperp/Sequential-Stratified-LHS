
function SobolInd = sensitivityDecomp(funCoeff, basisIndMatrix)

[~, dim] = size(basisIndMatrix);
SobolInd = zeros(dim,1);
for d=1:dim
    % Effect from d and all combinations with other variables
    d_ind = basisIndMatrix(:,d)>0;
    
    % Effect from d only
    %d_ind = find(basis_ind_matrix(:,d)==sum(basis_ind_matrix,2) & basis_ind_matrix(:,d)>0);
    SobolInd(d) = sum(funCoeff(d_ind).^2);
end