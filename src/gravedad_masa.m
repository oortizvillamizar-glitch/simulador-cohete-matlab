function [masa,F_gravedad] = gravedad_masa(t,cfg)
%Gravedad_masa calcula la masa actual (KG) y el peso (N) en el instante t
%(S)

%Entradas
%t(S)
%cfg (Estructura de configuración)
t_efectivo = max(0,min(t,cfg.t_quemado));
masa = max(cfg.masa_seca,cfg.masa_inicial - cfg.flujo_masico * t_efectivo);
F_gravedad = masa * cfg.g0;


end