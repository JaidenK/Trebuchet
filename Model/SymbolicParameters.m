% Symbolic definition of the parameters of our system
% Jaiden King
% 10/20/2025

%% Cartesian Coordinate System:
%   +x = Right
%   +y = Up
%   +z = Out of Screen 
% Positive angular rates are counter clockwise (right hand rule).
% The projectile will be thrown to the left (-x direction) when angular
% velocity is positive. 

% All units shall be SI units.
% Length: m  meter
% Mass:   kg kilogram
% Force:  N  Newton
% Time:   s  second

% Natural Constants
syms g % Gravity

%% Generalized Coordinates.
% The minimum variables needed to uniquely describe the state of the
% system.

% Angle between Arm and positive x (horizontal) axis. Radians. 
% The arm rotates about the origin, so this is also the angular position of
% the rope attachment point. 
syms theta_1(t) 

% Angle between Rope and positive x (horizontal) axis. Radians
syms theta_2(t) 

% Time derivatives of the generalized coordinates.
ddt_theta_1(t) = diff(theta_1(t), t);
ddt_theta_2(t) = diff(theta_2(t), t);
d2dt2_theta_1(t) = diff(theta_1(t), t, t);
d2dt2_theta_2(t) = diff(theta_2(t), t, t);

% For display purposes only, we define the dot notation version of the
% symbols. Don't use these in expressions. 
syms theta_ddot_1 theta_ddot_2 theta_dot_1 theta_dot_2

% Arrays for use with subs function prior to display
LeibnizNotation = {d2dt2_theta_1, d2dt2_theta_2, ddt_theta_1, ddt_theta_2, theta_1(t),     theta_2(t)};
DotNotation     = {theta_ddot_1,  theta_ddot_2,  theta_dot_1, theta_dot_2, sym("theta_1"), sym("theta_2")};

% Initial Conditions
syms theta_1_initial

%% Arm Parameters

% Constant Properties
syms l_1 % Length. Distance between pivot point and rope attachment point. 
syms l_1cg % Center of mass distance from pivot point. 
syms m_1 % Mass.
syms I_1 % Moment of inertia about the pivot point (z axis).

% Time Dependent Properties
% Position Vector 
r_1 = [l_1 * cos(theta_1); l_1 * sin(theta_1)];
% Velocity Vector
ddt_r_1 = diff(r_1,t);
% Potential Energy - Gravitational potential energy
%V_1 = m_1*g*l_1cg*sin(theta_1); % potential energy at CG height
V_1 = m_1*g*l_1*sin(theta_1); % Potential energy at arm height
% Kinetic Energy - As pure rotation around the pivot 
%T_1 = (1/2)*I_1*ddt_theta_1^2; % rotational
ddt_r_1xy = formula(ddt_r_1);
T_1 = (1/2)*m_1*(ddt_r_1xy(1)^2+ddt_r_1xy(2)^2);

%% Rope Parameters

% Constant Properties
syms l_2 % Length. Specifically, distance between rope attachment point and
% projectile center of mass.

% Time Dependent Properties
% Position Vector (relative to its attachment point) 
r_2 = [l_2 * cos(theta_2); l_2 * sin(theta_2)];
% Velocity Vector (relative to its attachment point)
ddt_r_2 = diff(r_2,t);
% No Energy - Rope is massless

%% Projectile Parameters

% Constant Properties
syms m_2 % Mass

% Time Dependent Properties
% Position 
r_3 = r_1 + r_2;
r_3xy = formula(r_3); % Components of position
% Velocity
ddt_r_3 = ddt_r_1 + ddt_r_2;
ddt_r_3xy = formula(ddt_r_3); % Components of velocity
% Potential Energy
V_2 = m_2*g*r_3xy(2);
% Kinetic Energy
T_2 = (1/2)*m_2*(ddt_r_3xy(1)^2+ddt_r_3xy(2)^2);

%% Power Plant Parameters

% Constant Properties
syms l_pp1 % Crank length
syms l_pp2 % Mounting distance
syms theta_pp0 % Initial crank angle relative to +x direction
syms x_pp0 % Initial spring extension  
%syms theta_pp(t) % Crank angle
%syms l_pp(t) % Hypoteneus Length
%syms x_pp(t) % Spring Extension
syms k % Spring Constant


% Crank angle as function of arm angle
theta_pp = (theta_1-theta_1_initial) + theta_pp0; 
r_pp = [l_pp1*cos(theta_pp); l_pp1*sin(theta_pp)];
r_ppxy = formula(r_pp);
% Power Plant length as function of crank angle
%PowerPlant_Length = l_pp == sqrt((l_pp1*sin(theta_pp))^2 + (l_pp1*cos(theta_pp)+l_pp2)^2);
l_pp = sqrt((l_pp1*sin(theta_pp))^2 + (l_pp1*cos(theta_pp)+l_pp2)^2);
% Spring extension
%PowerPlant_SpringExtension = x_pp == x_pp0 - (l_pp(theta_pp0) - l_pp);
%x_pp = x_pp0 - (l_pp(theta_pp0) - l_pp); % l_pp is a function of time, so
%you can't pass theta_pp0 like this.
x_pp = x_pp0 - (subs(l_pp,theta_pp,theta_pp0) - l_pp);

% Potential Energy
V_3 = (1/2)*k*x_pp^2;

%% Construct the Lagrangian
V = V_1 + V_2 + V_3;
T = T_1 + T_2;
L = T - V;

%% Parameters computed after the Diff Eqn has been solved

d3dt3_r_3 = diff(r_3,t,t,t); % Projectile Acceleration Vector
F_r_3_net = m_2*d3dt3_r_3; % Net force vector on projectile

% Force vector of rope tension acting on projectile.
g_vec = [0; -g];
F_rope = F_r_3_net - m_2*g_vec;










