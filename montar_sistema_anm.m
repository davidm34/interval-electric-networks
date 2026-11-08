function [A, b] = montar_sistema_anm(G, I, Fontes_V, num_nos)
    % MONTAR_SISTEMA_ANM Monta o sistema da Análise Nodal Modificada (ANM)
    %
    % Sistema matricial expandido:
    %   [ G   B ] [  V  ] = [ I ]
    %   [ C   D ] [ I_V ]   [ E ]
    %
    % Onde:
    %   - G: Matriz de condutâncias dos resistores (num_nos x num_nos)
    %   - B: Incidência das fontes de tensão nas LKCs dos nós (num_nos x M)
    %   - C: Transposta de B (C = B'') garantindo simetria (M x num_nos)
    %   - D: Matriz nula (M x M) para fontes de tensão ideais
    %   - I: Vetor de correntes injetadas por fontes de corrente (num_nos x 1)
    %   - E: Vetor de tensões das fontes ideais (M x 1)
    %
    % Entradas:
    %   G        - Matriz de condutâncias (num_nos x num_nos)
    %   I        - Vetor de correntes nodais (num_nos x 1)
    %   Fontes_V - Matriz de fontes de tensão [valor, no_+, no_-] (M x 3)
    %   num_nos  - Número de nós independentes (excluindo a referência 0)
    %
    % Saídas:
    %   A - Matriz expandida do sistema ANM (dimensão: num_nos + M)
    %   b - Vetor de excitação expandido (dimensão: num_nos + M)

    if nargin < 3 || isempty(Fontes_V)
        num_fontes_v = 0;
    else
        num_fontes_v = size(Fontes_V, 1);
    end

    if num_fontes_v == 0
        % Sem fontes de tensão: sistema nodal clássico G * V = I
        A = G;
        b = I;
        return;
    end

    dim = num_nos + num_fontes_v;
    A = zeros(dim, dim);
    b = zeros(dim, 1);

    % Bloco dos nós (condutâncias G e correntes injetadas I)
    A(1:num_nos, 1:num_nos) = G;
    b(1:num_nos) = I;

    % Bloco das fontes de tensão
    for k = 1:num_fontes_v
        valor_V = Fontes_V(k, 1);
        no_a    = Fontes_V(k, 2); % terminal positivo (+)
        no_b    = Fontes_V(k, 3); % terminal negativo (-)
        
        idx_v = num_nos + k; % índice da incógnita de corrente I_Vk
        
        % Convenção: I_Vk é a corrente que flui do terminal (+) para o (-) através da fonte
        % No nó_a (+): a corrente I_Vk sai do nó através da fonte -> termo +1 * I_Vk na LKC
        if no_a ~= 0
            A(no_a, idx_v) = A(no_a, idx_v) + 1;
            A(idx_v, no_a) = A(idx_v, no_a) + 1; % Termo +1 * V(no_a) na equação da fonte
        end
        
        % No nó_b (-): a corrente I_Vk entra no nó através da fonte -> termo -1 * I_Vk na LKC
        if no_b ~= 0
            A(no_b, idx_v) = A(no_b, idx_v) - 1;
            A(idx_v, no_b) = A(idx_v, no_b) - 1; % Termo -1 * V(no_b) na equação da fonte
        end
        
        % Equação constitutiva da fonte de tensão: V(no_a) - V(no_b) = valor_V
        b(idx_v) = valor_V;
    end
end

