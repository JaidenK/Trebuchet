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

clear sysvar;
sysvar = struct(); 

%% Natural Constants
syms g % Gravity
syms t % The passage of time

%% Generalized Coordinates.
% The minimum variables needed to uniquely describe the state of the
% system.

% The dot notation symbols are not defined as functions of time because
% they shall be used to derive properties that are true at any instant.

% Angle between Arm and positive x (horizontal) axis. Radians. 
% The arm rotates about the origin, so this is also the angular position of
% the rope attachment point. 
syms theta_1        % Position
syms theta_dot_1    % Velocity
syms theta_ddot_1   % Acceleration

% Angle between Rope and positive x (horizontal) axis. Radians
syms theta_2        % Position
syms theta_dot_2    % Velocity
syms theta_ddot_2   % Acceleration

% Time derivatives of the generalized coordinates.
% ddt_theta_1(t) = diff(theta_1(t), t);
% ddt_theta_2(t) = diff(theta_2(t), t);
% d2dt2_theta_1(t) = diff(theta_1(t), t, t);
% d2dt2_theta_2(t) = diff(theta_2(t), t, t);


% Arrays for use with subs function prior to display
LeibnizNotation = {diff(str2sym('theta_1(t)'), t, t), diff(str2sym('theta_2(t)'), t, t), ...
                   diff(str2sym('theta_1(t)'), t),    diff(str2sym('theta_2(t)'), t), ...
                        str2sym('theta_1(t)'),             str2sym('theta_2(t)')};
DotNotation     = {theta_ddot_1,  theta_ddot_2,  ...
                    theta_dot_1,   theta_dot_2, ...
                        theta_1,       theta_2};

% Initial Conditions
%syms theta_1_initial


% sysvar.theta_1      = struct('sym', theta_1,      'expr', str2sym('theta_1(t)') );
% sysvar.theta_dot_1  = struct('sym', theta_dot_1,  'expr', str2sym('theta_dot_1(t)') );
% sysvar.theta_ddot_1 = struct('sym', theta_ddot_1, 'expr', str2sym('theta_ddot_1(t)') );
% sysvar.theta_2      = struct('sym', theta_2,      'expr', str2sym('theta_2(t)') );
% sysvar.theta_dot_2  = struct('sym', theta_dot_2,  'expr', str2sym('theta_dot_2(t)') );
% sysvar.theta_ddot_2 = struct('sym', theta_ddot_2, 'expr', str2sym('theta_ddot_2(t)') );

%% Derived System Variables
%% Arm
syms l_1 % Length. Distance between pivot point and rope attachment point. 
syms l_1cg % Center of mass distance from pivot point. 
syms m_1 % Mass.
syms I_1 % Moment of inertia about the pivot point (z axis).
syms x_1 y_1;           % Position
syms x_dot_1 y_dot_1;   % Velocity
syms x_ddot_1 y_ddot_1; % Accel
syms V_1;     % Potential energy
syms T_1;     % Kinetic energy

sysvar.x_1     = struct('sym', x_1,     'expr', l_1 * cos(theta_1));
sysvar.y_1     = struct('sym', y_1,     'expr', l_1 * sin(theta_1));
sysvar.x_dot_1 = struct('sym', x_dot_1, 'expr', -theta_dot_1 * l_1 * sin(theta_1));
sysvar.y_dot_1 = struct('sym', y_dot_1, 'expr',  theta_dot_1 * l_1 * cos(theta_1));
% Acceleration unknown until we solve equations of motion
sysvar.V_1     = struct('sym', V_1,     'expr', m_1*g*y_1                   );
sysvar.T_1     = struct('sym', T_1,     'expr', (1/2)*m_1*(x_dot_1^2+y_dot_1^2)  );

%% Projectile Parameters
syms l_2 % Rope Length. Specifically, distance between rope attachment point and
syms m_2 % Projectile Mass
syms x_2 y_2            % Position
syms x_dot_2 y_dot_2;   % Velocity
syms x_ddot_2 y_ddot_2; % Accel
syms V_2;     % Potential energy
syms T_2;     % Kinetic energy
syms phi_2;   % Velocity vector angle

sysvar.x_2     = struct('sym', x_2,     'expr', x_1 + l_2 * cos(theta_2));
sysvar.y_2     = struct('sym', y_2,     'expr', y_1 + l_2 * sin(theta_2));
sysvar.x_dot_2 = struct('sym', x_dot_2, 'expr', x_dot_1 - theta_dot_2 * l_2 * sin(theta_2));
sysvar.y_dot_2 = struct('sym', y_dot_2, 'expr', y_dot_1 + theta_dot_2 * l_2 * cos(theta_2));
sysvar.x_ddot_2 = struct('sym', x_ddot_2, 'expr', str2sym('x_dot_2_dotted')); % Will be dotted below
sysvar.y_ddot_2 = struct('sym', y_ddot_2, 'expr', str2sym('y_dot_2_dotted')); % Will be dotted below
% Acceleration unknown until we solve equations of motion
sysvar.V_2     = struct('sym', V_2,     'expr', m_2*g*y_2);
sysvar.T_2     = struct('sym', T_2,     'expr', (1/2)*m_2*(x_dot_2^2+y_dot_2^2)  );

sysvar.phi_2 = struct('sym', phi_2, 'expr', atan2(y_dot_2, x_dot_2));




%% Power Plant Parameters

syms l_3
syms x_3
syms k % Spring Constant
syms V_3 % Potential Energy

syms x_3_0 
syms theta_1_0

sysvar.x_3 = struct('sym', x_3, 'expr', -l_3*(theta_1-theta_1_0)+x_3_0);
sysvar.V_3 = struct('sym', V_3, 'expr', (1/2)*k*(x_3*heaviside(x_3))^2);

%% Construct the Lagrangian
syms V T L

sysvar.V = struct('sym', V, 'expr',  V_1 + V_2 + V_3);
sysvar.T = struct('sym', T, 'expr',  T_1 + T_2);
sysvar.L = struct('sym', L, 'expr',  T - V);

%% Forces that require equations of motion to be solved

% Force on the projectile exerted by the rope
syms F_x2_rope F_y2_rope
sysvar.F_x2_rope = struct('sym', F_x2_rope, 'expr', m_2*x_ddot_2);
sysvar.F_y2_rope = struct('sym', F_y2_rope, 'expr', m_2*(y_ddot_2+g));



%% Substitute expressions to basic system parameters
fieldNames = fieldnames(sysvar);
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar_i = sysvar.(fieldName);
    sym_i  = sysvar_i.sym;
    expr_i = sysvar_i.expr;
    for j=i-1:-1:1
        expr_i = subs(expr_i,sysvar.(fieldNames{j}).sym,sysvar.(fieldNames{j}).subsexpr);
    end
    sysvar.(fieldName).subsexpr = expr_i;    
    % Needed for deriving equations of motion
    sysvar.(fieldName).f_of_t = symfun(subs(expr_i,DotNotation,LeibnizNotation),t);
end

% Get accelerations 
[sysvar.x_ddot_2.subsexpr,sysvar.x_ddot_2.f_of_t] = SysVarDotDiff(sysvar.x_dot_2,LeibnizNotation,DotNotation);
[sysvar.y_ddot_2.subsexpr,sysvar.y_ddot_2.f_of_t] = SysVarDotDiff(sysvar.y_dot_2,LeibnizNotation,DotNotation);

dottedsysvars = [sysvar.x_ddot_2, sysvar.y_ddot_2];

% Second pass at substitution to account for items requiring Dot Diff
% Not exact copy of above loop.
fieldNames = fieldnames(sysvar);
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar_i = sysvar.(fieldName);
    sym_i  = sysvar_i.sym;
    expr_i = sysvar_i.subsexpr; % different
    for j=1:numel(dottedsysvars) % different
        expr_i = subs(expr_i, dottedsysvars(j).expr ,dottedsysvars(j).subsexpr);
    end
    sysvar.(fieldName).subsexpr = expr_i;    
    % Needed for deriving equations of motion
    sysvar.(fieldName).f_of_t = symfun(subs(expr_i,DotNotation,LeibnizNotation),t);
end



disp("Lagrangian Symvars:")
disp(symvar(sysvar.L.subsexpr));
%disp(symvar(sysvar.L.f_of_t));


