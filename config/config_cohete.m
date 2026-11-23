function cfg = config_cohete()
%config_cohete define parámetros fisicos, curva de empuje y condiciones
%iniciales

%todas las unidades están en el sistema internacional (S.I)

%1. Parámetros geométricos y de masa
cfg.masa_seca = 1.8;                   %kg
cfg.masa_propelente = 0,7;             %kg masa inicial del combustible
cfg.masa_inicial = cfg.masa_seca + cfg.masa_propelente;    %kg
cfg.diametro = 0.1;                    %metros diametro máximo del fuselaje
cfg.area_frontal = pi * (cfg.diametro/2) ^ 2  %metros cuadrados
cfg.cd = 0.45;                         %coeficiente de arrastre aerodinamico

%2. Tabla de empuje versus tiempo
%Columnas: Tiempo (s) y Empuje (N)
cfg.tabla_empuje = [
    0.0 0.0;
    0.1 95.0;
    0.5 110.0;
    1.5 105.0;
    2.2 85.0;
    2.5 0.0
    ];

cfg.t_quemado = cfg.tabla_empuje(end,1);   %segundos duración del quemado
if cfg.t_quemado > 0
    cfg.flujo_masico = cfg.masa_propelente/cfg.t_quemado;
else
    cfg.flujo_masico = 0.0;
end

%3. Constantes y modelo atmosférico básico (nivel del mar)
cfg.g0 = 9.8;                    %gravedad
cfg.rho0 = 1.225;                %densidad del aire
cfg.escala_altura = 8500;        %altura de escala para densidad exponencial

%4. Condiciones iniciales y tiempo de simulación
cfg.h0 = 0;             %altura inicial
cfg.v0 = 0;             %velocidad vertical
cfg.g_span = [0,15]     %ventana de tiempo


end