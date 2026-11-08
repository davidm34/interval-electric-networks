function [G_C, I_C_hist, i_C_t] = modelo_capacitor_trapezio(C, dt, v_k_ant, v_m_ant, i_ant, v_k_t, v_m_t)
    % MODELO_CAPACITOR_TRAPEZIO Equações diretas da discretização trapezoidal do capacitor
    % Ramo k-m com capacitância C e passo de tempo dt
    %
    % Condutância equivalente:
    %   G_C = (2 * C) / dt
    %
    % Equação (7) - Corrente de Histórico:
    %   I_km(t - dt) = -i_km(t - dt) - (2*C / dt) * (v_k(t - dt) - v_m(t - dt))
    %
    % Equação (6) - Corrente Instantânea no tempo t:
    %   i_km(t) = I_km(t - dt) + (2*C / dt) * (v_k(t) - v_m(t))

    % Condutância equivalente (entra na matriz G)
    G_C = (2 * C) / dt;

    % Equação (7) - Fonte de corrente de histórico (entra no vetor I)
    v_km_ant = v_k_ant - v_m_ant;
    I_C_hist = -i_ant - G_C * v_km_ant;

    % Equação (6) - Corrente instantânea no tempo t (calculada após obter as tensões)
    if nargin >= 7
        v_km_t = v_k_t - v_m_t;
        i_C_t  = I_C_hist + G_C * v_km_t;
    else
        i_C_t = [];
    end
end

