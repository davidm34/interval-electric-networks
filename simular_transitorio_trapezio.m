function [tempo, V_hist, i_C_hist, i_L_hist, X_final] = simular_transitorio_trapezio(G, Fontes_I, Fontes_V, Capacitores, Indutores, num_nos, dt, t_fim)
    % SIMULAR_TRANSITORIO_TRAPEZIO Executa a simulação temporal pelo Método Trapezoidal (Dommel / EMTP)
    %
    % Entradas:
    %   G           - Matriz de condutâncias total com condutâncias equivalentes G_C e G_L
    %   Fontes_I    - Matriz de fontes de corrente independentes
    %   Fontes_V    - Matriz de fontes de tensão independentes
    %   Capacitores - Matriz de capacitores [valor, no_a, no_b]
    %   Indutores   - Matriz de indutores [valor, no_a, no_b]
    %   num_nos     - Número de nós independentes
    %   dt          - Passo de tempo de integração
    %   t_fim       - Tempo final de simulação
    %
    % Saídas:
    %   tempo       - Vetor de tempo (1 x num_passos)
    %   V_hist      - Histórico de tensões nodais (num_nos x num_passos)
    %   i_C_hist    - Histórico de correntes nos capacitores (num_cap x num_passos)
    %   i_L_hist    - Histórico de correntes nos indutores (num_ind x num_passos)
    %   X_final     - Vetor solução no instante final t_fim

    tempo = 0:dt:t_fim;
    num_passos = length(tempo);

    fprintf('Passo de tempo (dt): %.2e s\n', dt);
    fprintf('Tempo total (t_fim):  %.2e s\n', t_fim);
    fprintf('Total de iterações:  %d passos\n\n', num_passos);

    % 1. Matriz A expandida da ANM (constante no tempo para dt fixo)
    I_dummy = zeros(num_nos, 1);
    [A, ~] = montar_sistema_anm(G, I_dummy, Fontes_V, num_nos);

    % Fatoração LU estática (feita uma única vez antes do loop)
    [L, U] = lu(A);

    % 2. Inicialização dos estados e matrizes de histórico
    num_cap = size(Capacitores, 1);
    num_ind = size(Indutores, 1);

    V_hist   = zeros(num_nos, num_passos);
    i_C_hist = zeros(num_cap, num_passos);
    i_L_hist = zeros(num_ind, num_passos);

    % Estados anteriores (iniciam em repouso t = 0)
    V_ant   = zeros(num_nos, 1);
    i_C_ant = zeros(num_cap, 1);
    i_L_ant = zeros(num_ind, 1);

    X_final = zeros(size(A, 1), 1);

    % 3. Loop de Integração Temporal
    fprintf('--- Executando Simulação no Tempo ---\n');
    for step = 2:num_passos
        Fontes_Hist = [];

        % a) Correntes de histórico dos Capacitores
        for c = 1:num_cap
            C    = Capacitores(c, 1);
            no_a = Capacitores(c, 2);
            no_b = Capacitores(c, 3);

            v_a_ant = 0; if no_a ~= 0, v_a_ant = V_ant(no_a); end
            v_b_ant = 0; if no_b ~= 0, v_b_ant = V_ant(no_b); end

            [~, I_C_hist] = modelo_capacitor_trapezio(C, dt, v_a_ant, v_b_ant, i_C_ant(c));
            Fontes_Hist = [Fontes_Hist; I_C_hist, no_a, no_b];
        end

        % b) Correntes de histórico dos Indutores
        for l = 1:num_ind
            L    = Indutores(l, 1);
            no_a = Indutores(l, 2);
            no_b = Indutores(l, 3);

            v_a_ant = 0; if no_a ~= 0, v_a_ant = V_ant(no_a); end
            v_b_ant = 0; if no_b ~= 0, v_b_ant = V_ant(no_b); end

            [~, I_L_hist] = modelo_indutor_trapezio(L, dt, v_a_ant, v_b_ant, i_L_ant(l));
            Fontes_Hist = [Fontes_Hist; I_L_hist, no_a, no_b];
        end

        % c) Montagem do vetor de correntes nodais injetadas I(t) e vetor b(t)
        I_t = montar_vetor_I(Fontes_I, num_nos, Fontes_Hist);
        [~, b_t] = montar_sistema_anm(G, I_t, Fontes_V, num_nos);

        % d) Resolução direta rápida via substituição (L e U pré-fatoradas)
        y = L \ b_t;
        X = U \ y;

        V_atual = X(1:num_nos);
        V_hist(:, step) = V_atual;

        % e) Atualização das correntes instantâneas nos capacitores
        for c = 1:num_cap
            C    = Capacitores(c, 1);
            no_a = Capacitores(c, 2);
            no_b = Capacitores(c, 3);

            v_a_ant = 0; if no_a ~= 0, v_a_ant = V_ant(no_a); end
            v_b_ant = 0; if no_b ~= 0, v_b_ant = V_ant(no_b); end
            v_a_t   = 0; if no_a ~= 0, v_a_t   = V_atual(no_a); end
            v_b_t   = 0; if no_b ~= 0, v_b_t   = V_atual(no_b); end

            [~, ~, i_C_t] = modelo_capacitor_trapezio(C, dt, v_a_ant, v_b_ant, i_C_ant(c), v_a_t, v_b_t);
            i_C_ant(c) = i_C_t;
            i_C_hist(c, step) = i_C_t;
        end

        % f) Atualização das correntes instantâneas nos indutores
        for l = 1:num_ind
            L    = Indutores(l, 1);
            no_a = Indutores(l, 2);
            no_b = Indutores(l, 3);

            v_a_ant = 0; if no_a ~= 0, v_a_ant = V_ant(no_a); end
            v_b_ant = 0; if no_b ~= 0, v_b_ant = V_ant(no_b); end
            v_a_t   = 0; if no_a ~= 0, v_a_t   = V_atual(no_a); end
            v_b_t   = 0; if no_b ~= 0, v_b_t   = V_atual(no_b); end

            [~, ~, i_L_t] = modelo_indutor_trapezio(L, dt, v_a_ant, v_b_ant, i_L_ant(l), v_a_t, v_b_t);
            i_L_ant(l) = i_L_t;
            i_L_hist(l, step) = i_L_t;
        end

        % Atualiza tensões anteriores para o próximo passo
        V_ant = V_atual;
        X_final = X;
    end

    fprintf('Simulação concluída com sucesso!\n');
end
