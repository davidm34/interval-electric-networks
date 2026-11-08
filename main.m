clear; clc; close all;

% Configurações
filename = 'circuito.cir';

% 1. Leitura do arquivo SPICE
[Resistores, Fontes_I, Fontes_V, num_nos] = ler_circuito_spice(filename);

% 2. Modelagem das matrizes do circuito (Análise Nodal Modificada)
G = montar_matriz_G(Resistores, num_nos);
I = montar_vetor_I(Fontes_I, num_nos);
[A, b] = montar_sistema_anm(G, I, Fontes_V, num_nos);

% 3. Exibição do resumo, matrizes e equações simbólicas do sistema
exibir_sistema_nodal(G, I, A, b, Resistores, Fontes_I, Fontes_V, num_nos);

% 4. Resolução da equação nodal via Decomposição LU
fprintf('\n--- Resolução do Sistema por Decomposição LU ---\n');
[L, U, X] = decomposicao_lu(A, b);

% 5. Exibição das tensões nodais e correntes nas fontes
exibir_resultados(X, num_nos, Fontes_V);
