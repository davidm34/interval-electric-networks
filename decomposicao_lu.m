function [L, U, y, x] = decomposicao_lu(A, b)
    % DECOMPOSICAO_LU Resolve o sistema Ax = b usando Decomposicao LU
    % Imprime o passo a passo da construcao das matrizes L e U,
    % bem como as etapas de substituicao.

    % Definimos a matriz de coeficientes 'A' do sistema linear (3x3)
    A_orig = [ 2, -6, -1;
              -3, -1,  7;
              -8,  1, -2];

    % Definimos o vetor de termos independentes 'b' (resultados)
    b_orig = [-38;
              -34;
              -20];

    % Criamos cópias de segurança para preservar os dados de entrada originais
    A = A_orig;
    b = b_orig;

    % 1. Verificações iniciais
    [n, m] = size(A);
    if n ~= m
        error('A matriz A deve ser quadrada.');
    end
    if length(b) ~= n
        error('O vetor b deve ter o mesmo tamanho que as linhas de A.');
    end

    b = b(:); % Garante que b é um vetor coluna

    % 2. Inicializando L como matriz identidade e U como a matriz original A
    L = eye(n);
    U = A;

    fprintf('--- INICIO DA DECOMPOSICAO LU ---\n');
    fprintf('Matriz U Inicial (igual a A):\n');
    disp(U);
    fprintf('Matriz L Inicial (Identidade):\n');
    disp(L);

    % --- PASSO 1: FATORAÇÃO (Encontrando L e U) ---
    for k = 1:n-1
        fprintf('\n======================================\n');
        fprintf('Analisando a coluna %d...\n', k);

        pivo = U(k, k);
        if pivo == 0
            error('Pivo igual a zero encontrado. O metodo falhou (necessita pivoteamento).');
        end

        for i = (k+1):n
            % Calcula o multiplicador (fator m_ik)
            multiplicador = U(i, k) / pivo;

            % Guarda o multiplicador na posição correta da matriz L
            L(i, k) = multiplicador;

            % Atualiza a linha da matriz U (Nova Linha = Linha Atual - multiplicador * Linha do Pivô)
            U(i, :) = U(i, :) - multiplicador * U(k, :);

            fprintf('-> Zerando elemento da linha %d usando multiplicador %.4f\n', i, multiplicador);
        end

        fprintf('\nEstado atual de L:\n');
        disp(L);
        fprintf('Estado atual de U:\n');
        disp(U);
    end
    fprintf('\n--- FIM DA DECOMPOSICAO ---\n');

    % --- PASSO 2: SUBSTITUIÇÃO PROGRESSIVA (L*y = b) ---
    fprintf('\n======================================\n');
    fprintf('--- PASSO 2: Substituicao Progressiva (L*y = b) ---\n');
    y = zeros(n, 1);

    % Como a diagonal de L é sempre 1, y(1) é diretamente b(1)
    y(1) = b(1);

    % Resolve de cima para baixo
    for i = 2:n
        soma = 0;
        for j = 1:(i-1)
            soma = soma + L(i, j) * y(j);
        end
        y(i) = b(i) - soma;
    end
    fprintf('Vetor intermediario y:\n');
    disp(y);

    % --- PASSO 3: SUBSTITUIÇÃO REGRESSIVA (U*x = y) ---
    fprintf('\n======================================\n');
    fprintf('--- PASSO 3: Substituicao Regressiva (U*x = y) ---\n');
    x = zeros(n, 1);

    % Resolve o último termo primeiro (de baixo para cima)
    x(n) = y(n) / U(n, n);

    for i = n-1:-1:1
        soma = 0;
        for j = (i+1):n
            soma = soma + U(i, j) * x(j);
        end
        x(i) = (y(i) - soma) / U(i, i);
    end

    fprintf('Vetor solucao final x:\n');
    disp(x);
end