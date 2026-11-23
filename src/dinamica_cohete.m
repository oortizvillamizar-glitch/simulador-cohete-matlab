function [dydt] = dinamica_cohete(t,y,cfg)
%Dinamica_cohete define el sistema de ecuaciones diferenciales para ode45

%Entradas
%t (tiempo actual)
%y (vector de estado)
%cfg (estructura de configuración)

%Salidas
%dydt (derivada de la velocidad y la aceleración)
h = y(1);
v = y(2);

%1. Fuerzas y masas en el instante t
F_empuje = empuje(t,cfg);
[masa,F_gravedad] = gravedad_masa(t,cfg);
[F_arrastre,~] = arrastre(h,v,cfg);

%2. El arrastre siempre se opone al sentido de la velocidad
if abs(v) > 1e-6
    dir_arrastre = sign(v);
else
    dir_arrastre = 0;
end

%3. Aceleración neta vertical
F_neta = F_empuje - F_gravedad - dir_arrastre * F_arrastre;
a = F_neta / masa;

%4. Vector derivadas para ode45
dydt = [v;a];

end