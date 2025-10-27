clear all; 
close all; 
clc;

LoadSolution;

%% Plot General Solution
% hGenSolution = figure(1);
% clf;
% 
% subplot(3,1,1);
% plot(t_z,rad2deg(theta_1_z));
% hold on;
% plot(t_z,rad2deg(theta_2_z));
% grid on;
% yline(-90);
% ylabel("$\theta_i$ (degrees)",Interpreter="latex");
% 
% subplot(3,1,2);
% plot(t_z,rad2deg(ddt_theta_1_z));
% hold on
% plot(t_z,rad2deg(ddt_theta_2_z));
% grid on;
% ylabel("$\dot\theta_i$ (degrees/s)",Interpreter="latex");
% 
% subplot(3,1,3);
% plot(t_z,rad2deg(d2dt2_theta_1_z));
% hold on
% plot(t_z,rad2deg(d2dt2_theta_2_z));
% grid on;
% ylabel("$\ddot\theta_i$ (degrees/s$^2$)",Interpreter="latex");
% xlabel("t (s)");
% sgtitle("Solution for Generalized Coordinates");
% legend({'Arm','Rope'});

%% Plot Energy
hEnergy = figure(2);
clf;
sub_PlotSystemEnergy;

%% Plot Trajectory
hTrajectory = figure(3);
clf;
sub_PlotSpatialTrajectory;


%% Rope Tension
hRope = figure(4);
clf;
sub_PlotForces;

%%

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



