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

% Número de nós (excluindo o nó 0/GND)
num_nos = 2;

% Inicializando a matriz de condutâncias (G) com zeros
G = zeros(num_nos, num_nos);

% Agrupando os resistores em uma matriz para facilitar a iteração
Resistores = [R1; R2; R3];

% Iterando sobre cada resistor para montar a matriz G
for i = 1:size(Resistores, 1)
    valor_R = Resistores(i, 1);
    no_a = Resistores(i, 2);
    no_b = Resistores(i, 3);
    
    g = 1 / valor_R; % Calcula a condutância (1/R)
    
    % Regra 1: Soma nas diagonais principais (para os nós a e b)
    if no_a ~= 0
        G(no_a, no_a) = G(no_a, no_a) + g;
    end
    if no_b ~= 0
        G(no_b, no_b) = G(no_b, no_b) + g;
    end
    
    % Regra 2: Subtrai o valor fora da diagonal se o resistor ligar 2 nós não-GND
    if no_a ~= 0 && no_b ~= 0
        G(no_a, no_b) = G(no_a, no_b) - g;
        G(no_b, no_a) = G(no_b, no_a) - g;
    end
end

% Exibindo a matriz final
disp('Matriz de Condutâncias (G):');
disp(G);

