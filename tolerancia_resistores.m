function [R_min, R_max, G_min, G_max] = tolerancia_resistores(R_nominal, tol)
    % TOLERANCIA_RESISTORES Recebe parâmetros de resistência e tolerância
    % e calcula os limites inferior e superior de resistência e condutância.
    %
    % Entradas:
    %   R_nominal - Valor nominal do resistor (em Ohms)
    %   tol       - Tolerância (ex: 5 para 5% ou 0.05)
    %
    % Saídas:
    %   R_min     - Limite inferior da resistência [Ohms]
    %   R_max     - Limite superior da resistência [Ohms]
    %   G_min     - Limite inferior da condutância [S]
    %   G_max     - Limite superior da condutância [S]

    % Se for executado como script (sem argumentos), usa valores padrão para teste
    if nargin == 0
        R_nominal = 100; % 100 Ohms
        tol = 5;         % 5%
        fprintf('Executando com parâmetros de teste padrão:\n\n');
    end

    % Normaliza a tolerância (aceita tanto 5 quanto 0.05 para 5%)
    if tol > 1
        tol_frac = tol / 100;
        tol_pct  = tol;
    else
        tol_frac = tol;
        tol_pct  = tol * 100;
    end

    % 1. Cálculo dos limites de Resistência (Intervalo [R_min, R_max])
    R_min = R_nominal * (1 - tol_frac);
    R_max = R_nominal * (1 + tol_frac);

    % 2. Cálculo dos limites de Condutância (G = 1 / R)
    G_min = 1 ./ R_max;
    G_max = 1 ./ R_min;

    % 3. Exibição simples dos parâmetros
    fprintf('--- Parâmetros de Tolerância do Resistor ---\n');
    fprintf('Resistência Nominal: %.4f Ohms\n', R_nominal);
    fprintf('Tolerância:          %.2f%% (fração: %.4f)\n', tol_pct, tol_frac);
    fprintf('Intervalo de R:      [%.4f, %.4f] Ohms\n', R_min, R_max);
    fprintf('Intervalo de G:      [%.6f, %.6f] S\n', G_min, G_max);
    fprintf('--------------------------------------------\n');
end

