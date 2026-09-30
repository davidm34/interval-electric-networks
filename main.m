clear; clc; close all;

% Configurações
filename = 'circuito.cir';

% 1. Leitura do arquivo SPICE
[Resistores, num_nos] = ler_circuito_spice(filename);

% 2. Modelagem da matriz de condutância
G = montar_matriz_G(Resistores, num_nos);

% 3. Exibição dos resultados
fprintf('--- Resumo do Circuito ---\n');
fprintf('Número de nós independentes identificados: %d\n', num_nos);
fprintf('Total de resistores processados: %d\n', size(Resistores, 1));
fprintf('Dimensão da Matriz de Condutâncias: %dx%d\n\n', size(G, 1), size(G, 2));

disp('Matriz de Condutâncias (G):');
disp(G);
