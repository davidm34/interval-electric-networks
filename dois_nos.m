clear; clc; close all;

% Varíaves do Resistor (Valor, nó inicial e nó final)
% Inicialmente esse circuito
% Nó 1 ───── R1 ───── Nó 2
%│                    │
% R2                   R3
% │                    │
% GND                  GND
R1 = [200, 1, 2];
R2 = [100, 1, 0];
R3 = [200, 2, 0];

% Simulação de impressão de R1
for i = 1:3
    fprintf('Imprimindo matriz: %d\n', R1(i));
end


