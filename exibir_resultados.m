function exibir_resultados(X, num_nos, Fontes_V)
    % EXIBIR_RESULTADOS Exibe as tensões nodais finais e as correntes
    % nas fontes de tensão obtidas na solução do circuito.

    if nargin < 3 || isempty(Fontes_V)
        num_fontes_v = 0;
    else
        num_fontes_v = size(Fontes_V, 1);
    end

    V = X(1:num_nos);

    fprintf('\n======================================\n');
    fprintf('--- Tensões Nodais Finais (V) ---\n');
    for k = 1:num_nos
        fprintf('V%d = %.4f V\n', k, V(k));
    end

    if num_fontes_v > 0
        fprintf('\n--- Correntes nas Fontes de Tensão (I_V) ---\n');
        fprintf('(Convenção: sentido do terminal positivo para o terminal negativo)\n');
        for k = 1:num_fontes_v
            i_v = X(num_nos + k);
            no_a = Fontes_V(k, 2);
            no_b = Fontes_V(k, 3);
            fprintf('I_V%d (do nó %d para o nó %d) = %.4f A\n', k, no_a, no_b, i_v);
        end
    end
end

