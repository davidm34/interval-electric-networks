function I = montar_vetor_I(Fontes_I, num_nos, Fontes_Hist)
    % MONTAR_VETOR_I Monta o vetor de correntes nodais injetadas (I)
    % Inclui fontes de corrente independentes e fontes de histórico (trapézio)
    %
    % Entradas:
    %   Fontes_I    - Matriz [valor, no_a, no_b] das fontes de corrente independentes
    %   num_nos     - Número de nós independentes
    %   Fontes_Hist - Matriz [valor, no_a, no_b] das correntes de histórico de C e L (opcional)
    %
    % Convenção:
    %   Corrente que sai de 'no_a' e entra em 'no_b':
    %   - Subtraída em no_a (corrente que sai do nó)
    %   - Somada em no_b (corrente que entra no nó)

    I = zeros(num_nos, 1);

    % 1. Fontes de corrente independentes
    if ~isempty(Fontes_I)
        for k = 1:size(Fontes_I, 1)
            valor_I = Fontes_I(k, 1);
            no_a    = Fontes_I(k, 2); % nó de onde a corrente sai (+)
            no_b    = Fontes_I(k, 3); % nó para onde a corrente entra (-)

            if no_a ~= 0
                I(no_a) = I(no_a) - valor_I;
            end
            if no_b ~= 0
                I(no_b) = I(no_b) + valor_I;
            end
        end
    end

    % 2. Fontes de corrente de histórico (Capacitores e Indutores)
    if nargin >= 3 && ~isempty(Fontes_Hist)
        for k = 1:size(Fontes_Hist, 1)
            valor_hist = Fontes_Hist(k, 1);
            no_a       = Fontes_Hist(k, 2);
            no_b       = Fontes_Hist(k, 3);

            if no_a ~= 0
                I(no_a) = I(no_a) - valor_hist;
            end
            if no_b ~= 0
                I(no_b) = I(no_b) + valor_hist;
            end
        end
    end
end
