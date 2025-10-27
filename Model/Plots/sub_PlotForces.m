% Assumptions:
%   Must already have a figure open and prepared
%   Must already have a solution loaded
clf;

% Tension in the rope

% Ftot = Fgrav + Frope
% Fgrav const = [0;-m_1*g]
% F=ma (we have accel now)

% Fx = Fropex         = axm
% Fy = Fropey + Fgrav = aym 
%   => Fropey = aym - Fgrav 
%   => Fropey = aym + mg = m(ay+g)

%Fx = sysparam.constants.m_2.expr *  sysvar.x_ddot_2.z;
%Fy = sysparam.constants.m_2.expr * (sysvar.y_ddot_2.z + sysparam.constants.g.expr);

%%
subplot (2,1,1);
plot(t_z,sysvar.x_ddot_2.z);
hold on;
plot(t_z,sysvar.y_ddot_2.z);
plot(t_z,sqrt((sysvar.x_ddot_2.z).^2 + (sysvar.y_ddot_2.z).^2));

legend('ax','ay','magnitude');
grid on;
xlabel('t');
ylabel('m/s^2');
title("Projectile Acceleration");

%%
subplot(2,1,2);
plot(t_z, sysvar.F_x2_rope.z);
hold on;
plot(t_z, sysvar.F_y2_rope.z);
plot(t_z, sqrt((sysvar.F_x2_rope.z).^2+(sysvar.F_y2_rope.z).^2));

legend('Fx','Fy','magnitude');
grid on;
xlabel('t');
ylabel('N');
title({"Rope Force","(Gravity removed)"});
