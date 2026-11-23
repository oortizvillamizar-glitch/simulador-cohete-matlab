# Notas del Modelo Físico — Simulador de Trayectoria de Cohete

# 1. Sistema de unidades
Todas las variables del modelo trabajan en el **Sistema Internacional (SI)**:
- Tiempo ($t$): segundos $[\text{s}]$
- Altura ($h$): metros $[\text{m}]$
- Velocidad vertical ($v$): metros por segundo $[\text{m/s}]$
- Aceleracion vertical ($a$): metros por segundo al cuadrado $[\text{m/s}^2]$
- Masa ($m$): kilogramos $[\text{kg}]$
- Fuerzas (empuje $F_e$, peso $W$, arrastre $F_d$): newtons $[\text{N}]$

# 2. Ecuaciones base
Estado del sistema: $\mathbf{y} = [h,\; v]^T$.

$$\frac{dh}{dt} = v$$

$$\frac{dv}{dt} = \frac{F_e(t) - W(t) - \operatorname{sign}(v)\,F_d(h, v)}{m(t)}$$

Donde:
- $F_e(t)$ se interpola desde `cfg.tabla_empuje` con `interp1`.
- $m(t)$ disminuye linealmente durante el quemado hasta `cfg.masa_seca`, y $W(t) = m(t)\,g_0$.
- $F_d(h, v) = \frac{1}{2}\rho(h)\,v^2\,C_d\,A$, con densidad atmosferica exponencial $\rho(h) = \rho_0 e^{-h / H_s}$.

# 3. Supuestos y simplificaciones
- Movimiento restringido a una dimension vertical (1D); no se modela angulo de ataque, deriva ni rotacion.
- El consumo de propelente ocurre a tasa constante durante el intervalo de empuje definido en la tabla.
- La simulacio se detiene automacamente al detectar el regreso al suelo ($h = 0$ bajando) mediante `odeset('Events', ...)`.

# 4. Registro de pruebas y cambios
- **Versio inicial:** Paraetros base definidos en `config/config_cohete.m` y simulacio con `ode45` en `scripts/main_trayectoria.m`.