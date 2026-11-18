function plotar_resultados_transitorio(tempo, V_hist, i_C_hist, i_L_hist, num_nos)
    % PLOTAR_RESULTADOS_TRANSITORIO Exibe os gráficos das tensões e correntes no tempo
    %
    % Entradas:
    %   tempo    - Vetor temporal (1 x num_passos)
    %   V_hist   - Matriz de tensões nodais (num_nos x num_passos)
    %   i_C_hist - Matriz de correntes nos capacitores (num_cap x num_passos)
    %   i_L_hist - Matriz de correntes nos indutores (num_ind x num_passos)
    %   num_nos  - Quantidade de nós independentes

    try
        figure('Name', 'Simulação Transitória (Método Trapezoidal)', 'NumberTitle', 'off');

        num_cap = size(i_C_hist, 1);
        num_ind = size(i_L_hist, 1);

        % Subplot 1: Tensões Nodais no Tempo
        subplot(2, 1, 1);
        hold on; grid on;
        for k = 1:num_nos
            plot(tempo, V_hist(k, :), 'LineWidth', 1.5, 'DisplayName', sprintf('V%d(t)', k));
        end
        xlabel('Tempo (s)');
        ylabel('Tensão (V)');
        title('Tensões Nodais ao Longo do Tempo');
        legend('Location', 'northeast');

        % Subplot 2: Correntes nos Capacitores e Indutores
        subplot(2, 1, 2);
        hold on; grid on;
        for c = 1:num_cap
            plot(tempo, i_C_hist(c, :), 'LineWidth', 1.5, 'DisplayName', sprintf('i_{C%d}(t)', c));
        end
        for l = 1:num_ind
            plot(tempo, i_L_hist(l, :), '--', 'LineWidth', 1.5, 'DisplayName', sprintf('i_{L%d}(t)', l));
        end
        xlabel('Tempo (s)');
        ylabel('Corrente (A)');
        title('Correntes nos Elementos Reativos');
        legend('Location', 'northeast');
    catch
        % Ignora erro gráfico se executado sem display
    end
end
