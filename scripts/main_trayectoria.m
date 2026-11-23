% MAIN_TRAYECTORIA - Simulacion de trayectoria vertical de cohete con ode45


% 1. Asegurar que config/, src/ y scripts/ esten en el path de MATLAB
raiz_proyecto = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(raiz_proyecto));

% 2. Cargar configuracion y condiciones iniciales
cfg = config_cohete();
y0 = [cfg.h0; cfg.v0]; % [altura_inicial [m]; velocidad_inicial [m/s]]

% 3. Resolver el sistema de ecuaciones diferenciales con ode45
% Detenemos la integracion si el cohete regresa al suelo (h <= 0) tras despegar
opts = odeset('Events', @(t, y) evento_suelo(t, y), 'RelTol', 1e-6, 'AbsTol', 1e-8);
[t, y] = ode45(@(t, y) dinamica_cohete(t, y, cfg), cfg.g_span, y0, opts);

h = y(:, 1); % Altura [m]
v = y(:, 2); % Velocidad vertical [m/s]

% Reconstruir aceleracion, fuerzas y masa a lo largo del tiempo
n = numel(t);
a = zeros(n, 1);
F_emp = zeros(n, 1);
F_arr = zeros(n, 1);
masa_t = zeros(n, 1);

for i = 1:n
    F_emp(i) = empuje(t(i), cfg);
    [masa_t(i), F_grav_i] = gravedad_masa(t(i), cfg);
    [F_arr_i, ~] = arrastre(h(i), v(i), cfg);

    if abs(v(i)) > 1e-6
        dir_arr = sign(v(i));
    else
        dir_arr = 0.0;
    end

    F_arr(i) = dir_arr * F_arr_i;
    a(i) = (F_emp(i) - F_grav_i - F_arr(i)) / masa_t(i);
end

% 4. Resumen de resultados en consola
[h_max, idx_hmax] = max(h);
[v_max, idx_vmax] = max(v);

fprintf('--- Resumen de simulacion ---\n');
fprintf('Tiempo total simulado : %.2f s\n', t(end));
fprintf('Altura maxima (apogeo): %.2f m (en t = %.2f s)\n', h_max, t(idx_hmax));
fprintf('Velocidad maxima      : %.2f m/s (en t = %.2f s)\n', v_max, t(idx_vmax));
fprintf('Masa final            : %.2f kg\n', masa_t(end));

% 5. Graficas con subplot
figure('Name', 'Simulacion de Trayectoria del Cohete', 'Color', 'w');

subplot(3, 1, 1);
plot(t, h, 'b', 'LineWidth', 1.8);
grid on;
ylabel('Altura [m]');
title('Trayectoria Vertical del Cohete');

subplot(3, 1, 2);
plot(t, v, 'r', 'LineWidth', 1.8);
grid on;
ylabel('Velocidad [m/s]');

subplot(3, 1, 3);
plot(t, a, 'k', 'LineWidth', 1.8);
grid on;
xlabel('Tiempo [s]');
ylabel('Aceleracion [m/s^2]');

% Funcion local para detener la simulacion al tocar el suelo (h = 0)
function [value, isterminal, direction] = evento_suelo(t, y)
    value = y(1);        % Altura h [m]
    isterminal = 1;      % Detiene ode45 cuando se cumple el evento
    direction = -1;      % Solo al ir bajando (h cruzando hacia valores menores)
end