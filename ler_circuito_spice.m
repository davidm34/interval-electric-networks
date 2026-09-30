function [Resistores, num_nos] = ler_circuito_spice(filename)
    % Função para ler o arquivo .cir e extrair resistores e quantidade de nós
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
end
