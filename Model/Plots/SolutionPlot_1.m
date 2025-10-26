clear all; 
close all; 
clc;

LoadSolution;

%% Plot General Solution
hGenSolution = figure(1);
clf;

subplot(3,1,1);
plot(t_z,rad2deg(theta_1_z));
hold on;
plot(t_z,rad2deg(theta_2_z));
grid on;
yline(-90);
ylabel("$\theta_i$ (degrees)",Interpreter="latex");

subplot(3,1,2);
plot(t_z,rad2deg(ddt_theta_1_z));
hold on
plot(t_z,rad2deg(ddt_theta_2_z));
grid on;
ylabel("$\dot\theta_i$ (degrees/s)",Interpreter="latex");

subplot(3,1,3);
plot(t_z,rad2deg(d2dt2_theta_1_z));
hold on
plot(t_z,rad2deg(d2dt2_theta_2_z));
grid on;
ylabel("$\ddot\theta_i$ (degrees/s$^2$)",Interpreter="latex");
xlabel("t (s)");
sgtitle("Solution for Generalized Coordinates");
legend({'Arm','Rope'});

%% Plot Energy
hEnergy = figure(2);
clf;

subplot(3,1,1);
plot(t_z,sysvar.V_1.z-min(sysvar.V_1.z));
hold on;
plot(t_z,sysvar.V_2.z-min(sysvar.V_2.z));
%plot(t_z,V_3_z_tare);
%plot(t_z,V_1_z_tare + V_2_z_tare + V_3_z_tare);
plot(t_z,sysvar.V.z-min(sysvar.V.z),'--');
xline(t_z_release);
grid on;
xlabel("t (s)"); ylabel("Potential Energy (J)");
%legend(["V_1 (Arm)", "V_2 (Projectile)", "V_3 (Power Plant)", "Sum","V"])
legend(["V_1 (Arm)", "V_2 (Projectile)", "V"])

subplot(3,1,2);
plot(t_z,sysvar.T_1.z);
hold on;
plot(t_z,sysvar.T_2.z);
%plot(t_z,T_1_z+T_2_z);
plot(t_z,sysvar.T.z,'--');
xline(t_z_release);
grid on;
xlabel("t (s)"); ylabel("Kinetic Energy (J)");
%legend(["T_1 (Arm)", "T_2 (Projectile)","Sum","T"])
legend(["T_1 (Arm)", "T_2 (Projectile)","T"])

subplot(3,1,3);
tot_e = (sysvar.T.z+sysvar.V.z);
plot(t_z,tot_e-tot_e(1));
% hold on
% plot(t_z,EnergySum2_z_tare,'--');
xline(t_z_release);
grid on
xlabel("t (s)"); ylabel("Total System Energy (J) Tare");

sgtitle("System Energy");


%% Plot Trajectory
hTrajectory = figure(3);
clf;

hp3 = plot(sysvar.x_1.z,sysvar.y_1.z);
hold on;
hp1 = plot(sysvar.x_2.z(1:i_release),sysvar.y_2.z(1:i_release));
hp2 = plot(sysvar.x_2.z(i_release:end),sysvar.y_2.z(i_release:end),'--');
hp2.SeriesIndex = hp1.SeriesIndex;
scatter(0,0,'filled','HandleVisibility','off'); % Mark origin=
legend(["$\vec{r}_1$ (Arm)","$\vec{r}_2$ (Projectile)","$\vec{r}_3$ (Projectile)"],Interpreter="latex")
grid on;
xlabel("x (m)"); ylabel("y (m)"); 
axis equal;
title("Spatial Trajectory");


%% Rope Tension
% hRope = figure(4);
% clf;
% hp1 = plot(t_z,vecnorm(F_rope_z,2,2));
% xline(t_z_release);
% grid on
% xlabel("t (s)"); ylabel("$\|F_{rope}\|$ (N)",Interpreter="latex");
% title("Rope Tension");


%hLagrangian = figure(3);
%plot(t_z,Func_V(Func_args));
%hold on
%plot(t_z,Func_T(Func_args));
%plot(t_z,Func_L(Func_args));
%hold on
%xlabel("t (s)"); ylabel("L");
%plot(t_z,Func_V(Func_args)+Func_T(Func_args));
%legend({"Lagrangian","Total Energy"});

% Total energy does not appear to be constant like I was expecting.
% Is it because my signs are incorrect? No idea right now.
% > It was partly due to getting the parameter order wrong with the
% EoM_VecField



