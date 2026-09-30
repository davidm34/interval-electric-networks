function I = montar_vetor_I(Fontes_I, num_nos)
    % Função para montar o vetor de correntes nodais (I)
    % Inicializando o vetor I com zeros
    I = zeros(num_nos, 1);
    
    % Iterando sobre cada fonte de corrente
    for k = 1:size(Fontes_I, 1)
        valor_I = Fontes_I(k, 1);
        no_a = Fontes_I(k, 2); % nó de onde a corrente sai (+)
        no_b = Fontes_I(k, 3); % nó para onde a corrente entra (-)
        
        % Convenção Nodal: 
        % Corrente injetada (entra no nó) = positivo do lado direito da equação
        % Corrente extraída (sai do nó) = negativo do lado direito da equação
        
        % A fonte I<nome> <no_a> <no_b> significa que a corrente sai de 'no_a' e entra em 'no_b'.
        
        if no_a ~= 0
            I(no_a) = I(no_a) - valor_I;
        end
        if no_b ~= 0
            I(no_b) = I(no_b) + valor_I;
        end
    end
end
