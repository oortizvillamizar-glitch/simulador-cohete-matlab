function [F_arrastre,rho] = arrastre(h,v,cfg)
%arrastre calcula la fuerza de arrastre aerodinámico (N) y la densidad del
%aire (KG)

%Entradas
%h es la altura sobre el nivel del mar en metros
%v es la velocidad en metros sobre segundos
%cfg es la estructura de configuración generada por config cohete

%Para evitar densidades negativas si ode45 prueba alturas negativas
%temporalmente

h_segura = max(h,0.0);

%Modelo atmósferico exponencial simplificado
rho = cfg.rho0 * exp(-h_segura/cfg.escala_altura);

%Magnitud de la fuerza de arrastre
F_arrastre = 0.5 * rho * (v ^ 2) * cfg.cd * cfg.area_frontal;

end