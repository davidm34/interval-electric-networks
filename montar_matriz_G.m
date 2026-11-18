function G = montar_matriz_G(Resistores, num_nos, Capacitores, Indutores, dt)
    % MONTAR_MATRIZ_G Monta a matriz de condutâncias (G)
    % Inclui resistores e as condutâncias equivalentes de capacitores e indutores.
    %
    % Entradas:
    %   Resistores  - Matriz [valor, no_a, no_b]
    %   num_nos     - Número total de nós independentes
    %   Capacitores - Matriz [valor, no_a, no_b] (opcional)
    %   Indutores   - Matriz [valor, no_a, no_b] (opcional)
    %   dt          - Passo de integração trapezoidal (opcional)

    G = zeros(num_nos, num_nos);
    
    % 1. Condutâncias dos Resistores (g = 1 / R)
    if ~isempty(Resistores)
        for i = 1:size(Resistores, 1)
            valor_R = Resistores(i, 1);
            no_a = Resistores(i, 2);
            no_b = Resistores(i, 3);
            
            g = 1 / valor_R;
            
            if no_a ~= 0
                G(no_a, no_a) = G(no_a, no_a) + g;
            end
            if no_b ~= 0
                G(no_b, no_b) = G(no_b, no_b) + g;
            end
            if no_a ~= 0 && no_b ~= 0
                G(no_a, no_b) = G(no_a, no_b) - g;
                G(no_b, no_a) = G(no_b, no_a) - g;
            end
        end
    end

    % 2. Condutâncias equivalentes dos Capacitores (G_C = 2*C / dt)
    if nargin >= 3 && ~isempty(Capacitores) && nargin >= 5 && ~isempty(dt)
        for i = 1:size(Capacitores, 1)
            C    = Capacitores(i, 1);
            no_a = Capacitores(i, 2);
            no_b = Capacitores(i, 3);
            
            % Obtém G_C através da função modelo
            [G_C, ~, ~] = modelo_capacitor_trapezio(C, dt);
            
            if no_a ~= 0
                G(no_a, no_a) = G(no_a, no_a) + G_C;
            end
            if no_b ~= 0
                G(no_b, no_b) = G(no_b, no_b) + G_C;
            end
            if no_a ~= 0 && no_b ~= 0
                G(no_a, no_b) = G(no_a, no_b) - G_C;
                G(no_b, no_a) = G(no_b, no_a) - G_C;
            end
        end
    end

    % 3. Condutâncias equivalentes dos Indutores (G_L = dt / (2*L))
    if nargin >= 4 && ~isempty(Indutores) && nargin >= 5 && ~isempty(dt)
        for i = 1:size(Indutores, 1)
            L    = Indutores(i, 1);
            no_a = Indutores(i, 2);
            no_b = Indutores(i, 3);
            
            % Obtém G_L através da função modelo
            [G_L, ~, ~] = modelo_indutor_trapezio(L, dt);
            
            if no_a ~= 0
                G(no_a, no_a) = G(no_a, no_a) + G_L;
            end
            if no_b ~= 0
                G(no_b, no_b) = G(no_b, no_b) + G_L;
            end
            if no_a ~= 0 && no_b ~= 0
                G(no_a, no_b) = G(no_a, no_b) - G_L;
                G(no_b, no_a) = G(no_b, no_a) - G_L;
            end
        end
    end
end
