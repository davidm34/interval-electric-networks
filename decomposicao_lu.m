function [L, U, x] = decomposicao_lu(A, b)

    [L, U] = lu(A); % Fatoração LU nativa
    y = L \ b(:);    % Substituição progressiva (L*y = b)
    x = U \ y;       % Substituição regressiva (U*x = y)
    
end
