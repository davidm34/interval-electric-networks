function [L, U, y, x] = decomposicao_lu(A, b)
    if nargin < 2
        A = [ 2, -6, -1; -3, -1, 7; -8, 1, -2];
        b = [-38; -34; -20];
    end

    [L, U] = lu(A); % Fatoração LU nativa
    y = L \ b(:);    % Substituição progressiva (L*y = b)
    x = U \ y;       % Substituição regressiva (U*x = y)
end
