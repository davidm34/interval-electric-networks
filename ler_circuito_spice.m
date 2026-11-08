function [Resistores, Fontes_I, Fontes_V, num_nos] = ler_circuito_spice(filename)
    % LER_CIRCUITO_SPICE Lê o arquivo .cir e extrai resistores, fontes de corrente,
    % fontes de tensão e a quantidade de nós independentes.
    %
    % Formatos aceitos:
    %   R<nome> <no_+> <no_-> <valor_ohms>
    %   I<nome> <no_+> <no_-> <valor_A>
    %   V<nome> <no_+> <no_-> <valor_V>
    %
    % Formas de chamada:
    %   [Resistores, Fontes_I, Fontes_V, num_nos] = ler_circuito_spice(filename)
    %   [Resistores, Fontes_I, num_nos] = ler_circuito_spice(filename) (retrocompatível)

    fid = fopen(filename, 'r');
    
    if fid == -1
        error('Não foi possível abrir o arquivo %s', filename);
    end
    
    Resistores = [];
    Fontes_I = [];
    Fontes_V = [];
    num_nos = 0;
    
    % Lê linha por linha
    while ~feof(fid)
        linha = fgetl(fid);
        if ~ischar(linha)
            break;
        end
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
            elseif tipo == 'V'
                % Adiciona na matriz de fontes de tensão [Valor, nó_+, nó_-]
                Fontes_V = [Fontes_V; valor, no_a, no_b];
            end
            
            % Atualiza o número de nós encontrados
            num_nos = max([num_nos, no_a, no_b]);
        end
    end
    fclose(fid);

    % Suporte retrocompatível caso a função seja chamada com apenas 3 saídas
    if nargout == 3
        Fontes_V = num_nos;
    end
end
