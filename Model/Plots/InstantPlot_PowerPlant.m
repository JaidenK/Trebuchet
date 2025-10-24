clear all;
%close all;
clc;

%% Load Expressions
% Load the model as symbolic expressions 
SymbolicParameters;

%% Define Symbols
% Power plant constants:
l_pp1 = .1; % Crank length
l_pp2 = .3; % Mounting distance
theta_pp0 = deg2rad(20); % Initial crank angle relative to +x direction
x_pp0 = l_pp1*2.1; % Initial spring extension  
k = 1000; % Spring constant
% System constants:
theta_1_initial = 0;
theta_1(t) = t; % Linear function to visualize 

%% Substitute in system values
theta_pp = subs(theta_pp);
r_pp = subs(r_pp);
l_pp = subs(l_pp);
x_pp = subs(x_pp);
V_3 = subs(V_3);

%% Plot
% Spring stats over full range of motion (180deg of arm travel)
hSpringStats = figure(2);
clf

m = 4;
n = 1;

% Powerplant Angle
subplot(m,n,1)
fplot(theta_pp,[0 pi]); 
yline(0);
yline(pi);
xline(pi-theta_pp0);
grid on;
ylabel({"Crank Angle","\theta_{pp}(\theta_1)"}); 

subplot(m,n,2)
% x_pp is a function of _time_ not powerplant angle
fplot(l_pp,[0 pi]); 
grid on;
ylabel({"Hypoteneuse Length","l_{pp}(\theta_1)"}); 

subplot(m,n,3)
% x_pp is a function of _time_ not powerplant angle
fplot(x_pp,[0 pi]); % x_pp should be = x_pp0 at t=0
yline(0);
xline(pi-theta_pp0);
grid on;
xlabel("\theta_1"); ylabel({"Spring Extension","x_{pp}(\theta_1)"}); 

subplot(m,n,4)
fplot(V_3,[0 pi]);
yline(0);
xline(pi-theta_pp0);
grid on;
ylim(sort(double([V_3(0) V_3(pi-theta_pp0)])));
xlabel("\theta_1"); ylabel({"Potential Energy","V_{3}(\theta_1)"}); 


sgtitle("Spring Stats");


hGeometery = figure(1);
clf
for i=1:1
    t = deg2rad((i-1)*30);
    r = double(r_pp(t));
    x_pp_t = double(x_pp(t));
    x = [0, r(1), -l_pp2, -(l_pp2+(x_pp0-x_pp_t))];
    y = [0 r(2) 0 0];
    plot(x,y);
    hold on
end
xlim([-l_pp2 l_pp1]*1.2);
axis equal
grid on


