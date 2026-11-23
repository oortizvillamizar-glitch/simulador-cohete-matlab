function F_empuje = empuje(t,cfg)
%empuje calcula la fuerza de empuje (N) en el instante t (S) usando
%interp1. Si t está fuera de rango de la tabla de empuje, devuelve 0
%Newtons

t_tabla = cfg.tabla_empuje(:,1);
f_tabla = cfg.tabla_empuje(:,2);

%Interpolación lineal, valores fuera de rango definidos devuelven 0

F_empuje = interp1(t_tabla,f_tabla,t,"linear",0.0);

end