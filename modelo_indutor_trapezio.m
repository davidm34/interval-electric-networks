function [G_L, I_L_hist, i_L_t] = modelo_indutor_trapezio(L, dt, v_k_ant, v_m_ant, i_ant, v_k_t, v_m_t)
    % MODELO_INDUTOR_TRAPEZIO Equações diretas da discretização trapezoidal do indutor
    % Ramo k-m com indutância L e passo de tempo dt
    %
    % Condutância equivalente:
    %   G_L = dt / (2 * L)
    %
    % Equação (5) - Corrente de Histórico:
    %   I_km(t - dt) = i_km(t - dt) + (dt / (2*L)) * (v_k(t - dt) - v_m(t - dt))
    %
    % Equação (4) - Corrente Instantânea no tempo t:
    %   i_km(t) = I_km(t - dt) + (dt / (2*L)) * (v_k(t) - v_m(t))

    % Condutância equivalente (entra na matriz G)
    G_L = dt / (2 * L);

    % Equação (5) - Fonte de corrente de histórico (entra no vetor I)
    v_km_ant = v_k_ant - v_m_ant;
    I_L_hist = i_ant + G_L * v_km_ant;

    % Equação (4) - Corrente instantânea no tempo t (calculada após obter as tensões)
    if nargin >= 7
        v_km_t = v_k_t - v_m_t;
        i_L_t  = I_L_hist + G_L * v_km_t;
    else
        i_L_t = [];
    end
end

