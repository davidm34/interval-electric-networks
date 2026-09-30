function [Resistores, Fontes_I, num_nos] = ler_circuito_spice(filename)
    % Função para ler o arquivo .cir e extrair resistores, fontes de corrente e quantidade de nós
    fid = fopen(filename, 'r');
    
    if fid == -1
        error('Não foi possível abrir o arquivo %s', filename);
    end
    
    Resistores = [];
    Fontes_I = [];
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
        tokens = strsplit(linha);
        
        if length(tokens) >= 4
            tipo = upper(tokens{1}(1));
            no_a = str2double(tokens{2});
            no_b = str2double(tokens{3});
            valor = str2double(tokens{4});
            
            if tipo == 'R'
                % Adiciona na matriz de resistores [Valor, nó_a, nó_b]
                Resistores = [Resistores; valor, no_a, no_b];
            elseif tipo == 'I'
                % Adiciona na matriz de fontes de corrente [Valor, nó_a, nó_b]
                Fontes_I = [Fontes_I; valor, no_a, no_b];
            end
            
            % Atualiza o número de nós encontrados
            num_nos = max([num_nos, no_a, no_b]);
        end
    end
    fclose(fid);
end
