clear; clc; close all;

% Abre o arquivo .cir (netlist no formato SPICE)
filename = 'circuito.cir'; % Você pode alterar para o caminho do seu arquivo .cir
fid = fopen(filename, 'r');

if fid == -1
    error('Não foi possível abrir o arquivo %s', filename);
end

Resistores = [];
num_nos = 0;

% Lê linha por linha
while ~feof(fid)
    linha = fgetl(fid);
    linha = strtrim(linha); % Remove espaços em branco
    
    % Ignora comentários (linhas começando com * ou vazias)
    if isempty(linha) || linha(1) == '*'
        continue;
    end
    
    % Lê os componentes
    % Formato esperado: R<nome> <nó_a> <nó_b> <valor>
    tokens = strsplit(linha);
    
    if length(tokens) >= 4 && upper(tokens{1}(1)) == 'R'
        no_a = str2double(tokens{2});
        no_b = str2double(tokens{3});
        valor_R = str2double(tokens{4});
        
        % Adiciona na matriz de resistores [Valor, nó_a, nó_b]
        Resistores = [Resistores; valor_R, no_a, no_b];
        
        % Atualiza o número de nós encontrados
        num_nos = max([num_nos, no_a, no_b]);
    end
end
fclose(fid);

% Inicializando a matriz de condutâncias (G) com zeros
G = zeros(num_nos, num_nos);

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

% Exibindo informações e a matriz final
fprintf('--- Resumo do Circuito ---\n');
fprintf('Número de nós independentes identificados: %d\n', num_nos);
fprintf('Total de resistores processados: %d\n', size(Resistores, 1));
fprintf('Dimensão da Matriz de Condutâncias: %dx%d\n\n', size(G, 1), size(G, 2));

disp('Matriz de Condutâncias (G):');
disp(G);

