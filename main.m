clear; clc; close all;

% Configurações
filename = 'circuito.cir';

% 1. Leitura do arquivo SPICE
[Resistores, Fontes_I, num_nos] = ler_circuito_spice(filename);

% 2. Modelagem da matriz de condutância e do vetor de correntes
G = montar_matriz_G(Resistores, num_nos);
I = montar_vetor_I(Fontes_I, num_nos);

% 3. Exibição dos resultados
fprintf('--- Resumo do Circuito ---\n');
fprintf('Número de nós independentes identificados: %d\n', num_nos);
fprintf('Total de resistores processados: %d\n', size(Resistores, 1));
fprintf('Total de fontes de corrente processadas: %d\n', size(Fontes_I, 1));
fprintf('Dimensão da Matriz G: %dx%d\n', size(G, 1), size(G, 2));
fprintf('Dimensão do Vetor I: %dx1\n\n', num_nos);

disp('Matriz de Condutâncias (G):');
disp(G);

disp('Vetor de Correntes Nodais (I):');
disp(I);

