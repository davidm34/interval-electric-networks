function exibir_sistema_nodal(G, I, A, b, Resistores, Fontes_I, Fontes_V, num_nos)
    % EXIBIR_SISTEMA_NODAL Exibe o resumo do circuito, as matrizes nodais
    % e a representação simbólica do sistema de equações lineares.

    if nargin < 7 || isempty(Fontes_V)
        num_fontes_v = 0;
    else
        num_fontes_v = size(Fontes_V, 1);
    end

    num_resistores = size(Resistores, 1);
    num_fontes_i   = size(Fontes_I, 1);

    % Resumo do Circuito
    fprintf('--- Resumo do Circuito ---\n');
    fprintf('Número de nós independentes identificados: %d\n', num_nos);
    fprintf('Total de resistores processados: %d\n', num_resistores);
    fprintf('Total de fontes de corrente processadas: %d\n', num_fontes_i);
    fprintf('Total de fontes de tensão processadas: %d\n', num_fontes_v);
    fprintf('Dimensão da Matriz de Condutâncias (G): %dx%d\n', size(G, 1), size(G, 2));
    fprintf('Dimensão do Vetor de Correntes Nodais (I): %dx1\n', size(I, 1));
    fprintf('Dimensão do Sistema Expandido (A): %dx%d\n', size(A, 1), size(A, 2));
    fprintf('Dimensão do Vetor de Excitação (b): %dx1\n\n', size(b, 1));

    disp('Matriz de Condutâncias (G):');
    disp(G);

    disp('Vetor de Correntes Nodais (I):');
    disp(I);

    if num_fontes_v > 0
        disp('Matriz Expandida da Análise Nodal Modificada (A):');
        disp(A);

        disp('Vetor de Excitação Expandido (b):');
        disp(b);
    end

    % Exibe o sistema simbolicamente
    if num_fontes_v > 0
        fprintf('--- Sistema Nodal Modificado (A * X = b) ---\n');
        total_incognitas = num_nos + num_fontes_v;
        nomes_vars = cell(total_incognitas, 1);
        for k = 1:num_nos
            nomes_vars{k} = sprintf('V%d', k);
        end
        for k = 1:num_fontes_v
            nomes_vars{num_nos + k} = sprintf('I_V%d', k);
        end

        for k = 1:total_incognitas
            if k <= num_nos
                fprintf('Nó %d: ', k);
            else
                fprintf('Fonte V%d: ', k - num_nos);
            end

            primeiro_termo = true;
            for j = 1:total_incognitas
                coef = A(k, j);
                if coef ~= 0
                    if primeiro_termo
                        fprintf('%.4f*%s ', coef, nomes_vars{j});
                        primeiro_termo = false;
                    else
                        if coef >= 0
                            fprintf('+ %.4f*%s ', coef, nomes_vars{j});
                        else
                            fprintf('- %.4f*%s ', abs(coef), nomes_vars{j});
                        end
                    end
                end
            end
            if primeiro_termo
                fprintf('0.0000 ');
            end
            fprintf('= %.4f\n', b(k));
        end
    else
        fprintf('--- Sistema Nodal (G * V = I) ---\n');
        for k = 1:num_nos
            fprintf('Nó %d: ', k);
            for j = 1:num_nos
                if j == 1
                    fprintf('%.4f*V%d ', G(k,j), j);
                else
                    if G(k,j) >= 0
                        fprintf('+ %.4f*V%d ', G(k,j), j);
                    else
                        fprintf('- %.4f*V%d ', abs(G(k,j)), j);
                    end
                end
            end
            fprintf('= %.4f\n', I(k));
        end
    end
end

