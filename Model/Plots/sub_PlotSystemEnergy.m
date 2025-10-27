% Assumptions:
%   Must already have a figure open and prepared
%   Must already have a solution loaded


subplot(3,1,1);
plot(t_z,sysvar.V_1.z-min(sysvar.V_1.z));
hold on;
plot(t_z,sysvar.V_2.z-min(sysvar.V_2.z));
plot(t_z,sysvar.V_3.z-min(sysvar.V_3.z));
plot(t_z,sysvar.V.z-min(sysvar.V.z),'--');
xline(sysparam.discrete.t_release.subsexpr);
grid on;
xlabel("t (s)"); ylabel("Potential Energy (J)");
legend(["V_1 (Arm)", "V_2 (Projectile)", "V_3 (Power Plant)","V"])

subplot(3,1,2);
plot(t_z,sysvar.T_1.z);
hold on;
plot(t_z,sysvar.T_2.z);
%plot(t_z,T_1_z+T_2_z);
plot(t_z,sysvar.T.z,'--');
xline(sysparam.discrete.t_release.subsexpr);
grid on;
xlabel("t (s)"); ylabel("Kinetic Energy (J)");
%legend(["T_1 (Arm)", "T_2 (Projectile)","Sum","T"])
legend(["T_1 (Arm)", "T_2 (Projectile)","T"])

subplot(3,1,3);
tot_e = (sysvar.T.z+sysvar.V.z);
plot(t_z,tot_e-tot_e(1));
% hold on
% plot(t_z,EnergySum2_z_tare,'--');
xline(sysparam.discrete.t_release.subsexpr);
grid on
xlabel("t (s)"); ylabel("Total System Energy (J)");

sgtitle("System Energy");
