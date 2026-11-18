clear; clc; close all;

% Configurações
filename = 'circuito.cir';
dt = 1e-4;       % Passo de integração temporal (s)
t_fim = 0.05;    % Tempo total de simulação (s)

% 1. Leitura do arquivo SPICE
[Resistores, Fontes_I, Fontes_V, Capacitores, Indutores, num_nos] = ler_circuito_spice(filename);

% 2. Identificação do tipo de circuito (Estático ou Dinâmico)
tem_dinamico = (~isempty(Capacitores) && size(Capacitores, 1) > 0) || ...
               (~isempty(Indutores) && size(Indutores, 1) > 0);

if ~tem_dinamico
    % CASO ESTÁTICO (Circuito Puramente Resistivo - Análise DC)
    fprintf('=== Circuito Estático (Análise DC) ===\n\n');

    % Modelagem das matrizes
    G = montar_matriz_G(Resistores, num_nos);
    I = montar_vetor_I(Fontes_I, num_nos);
    [A, b] = montar_sistema_anm(G, I, Fontes_V, num_nos);

    % Exibição do sistema e resolução LU
    exibir_sistema_nodal(G, I, A, b, Resistores, Fontes_I, Fontes_V, num_nos);

    fprintf('\n--- Resolução do Sistema por Decomposição LU ---\n');
    [L, U, X] = decomposicao_lu(A, b);

    % Exibição das tensões nodais e correntes nas fontes
    exibir_resultados(X, num_nos, Fontes_V);

else
    % CASO DINÂMICO (Circuito com Capacitor/Indutor - Simulação no Tempo)
    fprintf('=== Simulação Transitória no Tempo (Método Trapezoidal) ===\n\n');

    % Modelagem das matrizes nodais
    G = montar_matriz_G(Resistores, num_nos, Capacitores, Indutores, dt);
    I_inicial = montar_vetor_I(Fontes_I, num_nos);
    [A, b_inicial] = montar_sistema_anm(G, I_inicial, Fontes_V, num_nos);

    % Exibição inicial do circuito
    exibir_sistema_nodal(G, I_inicial, A, b_inicial, Resistores, Fontes_I, Fontes_V, num_nos);

    % Execução da simulação temporal (Método de Dommel / Trapezoidal)
    [tempo, V_hist, i_C_hist, i_L_hist, X_final] = simular_transitorio_trapezio( ...
        G, Fontes_I, Fontes_V, Capacitores, Indutores, num_nos, dt, t_fim);

    % Exibição dos resultados no instante final
    fprintf('\n--- Tensões Finais no Tempo t = %.4f s ---\n', t_fim);
    exibir_resultados(X_final, num_nos, Fontes_V);

    % Visualização gráfica
    plotar_resultados_transitorio(tempo, V_hist, i_C_hist, i_L_hist, num_nos);
end
