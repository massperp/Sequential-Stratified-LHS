function basisIndMatrix = nDimPolynomialArray(numDim,orderPol)

% Generate index matrix for multidimensional basis

% INPUTS
% numDim: number of random dimensions
% orderPol: maximum order of polynomial basis functions

% OUTPUTS
% basisIndMatrix: index matrix of integers where every row corresponds to a
% multidimensional function, and every column a random dimension

% Initialize the basisIndMatrix indices
basisIndMatrix = zeros(factorial(orderPol+numDim)/factorial(orderPol)/factorial(numDim),numDim);


MM = numDim - 1 ; 
n = 1;
t = zeros(1,MM);

for CurrentOrder = 1 : orderPol
    EndGenere = 0;
    FirstThisOrder = 0;
    
    while (EndGenere == 0)
        n = n + 1 ;
        % First list t for order CurrentOrder
        if ( FirstThisOrder == 0)
            for i=1 : MM
                t(i) = i;
            end
            FirstThisOrder =1 ;
        else
            % Regular incrementation
            if (t(MM) < (MM + CurrentOrder))
                t(MM) = t(MM) + 1;
            else  % t(MM) = tmax = MM +CurrentOrder
                j = MM;
                while (t(j) == j + CurrentOrder )
                    j = j - 1 ;
                end
                t(j) = t(j) + 1 ;
                for k =(j + 1) :  MM
                    t(k) = t(j) + k - j ;
                end
            end
        end
        
        % Direct Translating t into basisIndMatrix{n}
        basisIndMatrix(n,1) = t(1) -1;
        for i=2 : MM
            basisIndMatrix(n,i) = t(i) - t(i-1) -1 ;
        end
        basisIndMatrix(n,numDim) = numDim + CurrentOrder - t(MM) -1 ;
        
        % End of generation of order CurrentOrder
        if (t(1) == (CurrentOrder+1))
            EndGenere = EndGenere + 1;
        end
    end
end


for i=1:floor(numDim/2)
    swap = basisIndMatrix(:,i);
    basisIndMatrix(:,i) = basisIndMatrix(:,numDim-i+1);
    basisIndMatrix(:,numDim-i+1) = swap;
end
    
