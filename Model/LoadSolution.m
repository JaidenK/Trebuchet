% Specify input data
filename = ""; % Set filename to empty string to use latest solution

% look for most recent data
if(strlength(filename)==0)
    d            = dir('solutions/*mat');
    [~, index]   = max([d.datenum]);
    filename = fullfile(d(index).folder, d(index).name);
    disp(filename)
else
    filename = fullfile("solutions",filename);
end

% Load the model
SymbolicParameters

% Load the solution
load(filename);

%%

% Time samples for evaluating the solution
t_z = linspace(min(sol.x),max(sol.x),200);
[Y,Yp] = deval(sol,t_z);
theta_1_z       = Y(3,:);
ddt_theta_1_z   = Y(4,:);
d2dt2_theta_1_z = Yp(4,:);
theta_2_z       = Y(1,:);
ddt_theta_2_z   = Y(2,:);
d2dt2_theta_2_z = Yp(2,:);

Func_args_symbols = {[sym('t') cell2sym(DotNotation)]};
%Func_args_symbols {[t     theta_ddot_1     theta_ddot_2     theta_dot_1    theta_dot_2    theta_1    theta_2]}
Func_args =         [t_z; d2dt2_theta_1_z; d2dt2_theta_2_z;  ddt_theta_1_z; ddt_theta_2_z; theta_1_z; theta_2_z]';

%% Substitute solution parameters into the model's time-depenent functions.
% We want to remove dependence on all symbols except time and theta
fieldNames = fieldnames(sysvar);
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar.(fieldName).f_of_t = subs(sysvar.(fieldName).f_of_t,sysparam_symbols,sysparam_values);
    sysvar.(fieldName).func = matlabFunction(subs(sysvar.(fieldName).f_of_t,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
    
    % Actually evaluate it:
    sysvar.(fieldName).z = sysvar.(fieldName).func(Func_args);
end
disp("Lagrangian f_of_t Symvars:")
disp(symvar(sysvar.L.f_of_t));



% This still leaves them symbolic in terms of the generalized coordinates
% I need to figure out a better way to automate this.
% For now it matches the order they occur in SymbolicParameters.m

%g = subs(g,sysparam_symbols,sysparam_values);
%subs(ddt_theta_1,sysparam_symbols,sysparam_values);
%subs(ddt_theta_2,sysparam_symbols,sysparam_values);
%subs(d2dt2_theta_1,sysparam_symbols,sysparam_values);
%subs(d2dt2_theta_2,sysparam_symbols,sysparam_values);
%theta_1_initial = sol.y(3,1);%sol.y(1,1);
% 
% l_1   = subs(l_1,  sysparam_symbols,sysparam_values);
% l_1cg = subs(l_1cg,sysparam_symbols,sysparam_values);
% m_1   = subs(m_1,  sysparam_symbols,sysparam_values);
% I_1   = subs(I_1,  sysparam_symbols,sysparam_values);
% r_1   = subs(r_1,sysparam_symbols,sysparam_values);
% ddt_r_1 = subs(ddt_r_1,sysparam_symbols,sysparam_values);
% V_1 = subs(V_1,sysparam_symbols,sysparam_values);
% T_1 = subs(T_1,sysparam_symbols,sysparam_values);
% 
% l_2 = subs(l_2,sysparam_symbols,sysparam_values);
% r_2 = subs(r_2,sysparam_symbols,sysparam_values);
% ddt_r_2 = subs(ddt_r_2,sysparam_symbols,sysparam_values);
% 
% m_2 = subs(m_2,sysparam_symbols,sysparam_values);
% r_3 = subs(r_3,sysparam_symbols,sysparam_values);
% r_3xy = subs(r_3xy,sysparam_symbols,sysparam_values);
% ddt_r_3 = subs(ddt_r_3,sysparam_symbols,sysparam_values);
% ddt_r_3xy = subs(ddt_r_3xy,sysparam_symbols,sysparam_values);
% V_2 = subs(V_2,sysparam_symbols,sysparam_values);
% T_2 = subs(T_2,sysparam_symbols,sysparam_values);
% 
% l_pp1 = subs(l_pp1,sysparam_symbols,sysparam_values);
% l_pp2 = subs(l_pp2,sysparam_symbols,sysparam_values);
% theta_pp0 = subs(theta_pp0,sysparam_symbols,sysparam_values);
% x_pp0 = subs(x_pp0,sysparam_symbols,sysparam_values);
% k = subs(k,sysparam_symbols,sysparam_values);
% theta_pp = subs(theta_pp,sysparam_symbols,sysparam_values);
% r_pp = subs(r_pp,sysparam_symbols,sysparam_values);
% r_ppxy = subs(r_ppxy,sysparam_symbols,sysparam_values);
% l_pp = subs(l_pp,sysparam_symbols,sysparam_values);
% x_pp = subs(x_pp,sysparam_symbols,sysparam_values);
% V_3 = subs(V_3,sysparam_symbols,sysparam_values);
% 
% V = subs(V,sysparam_symbols,sysparam_values);
% T = subs(T,sysparam_symbols,sysparam_values);
% L = subs(L,sysparam_symbols,sysparam_values);
% 
% F_rope = subs(F_rope,sysparam_symbols,sysparam_values);

%% Convert symbolic functions to Matlab Functions


% Func_r_1 = matlabFunction(subs(r_1.',LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_r_3 = matlabFunction(subs(r_3.',LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_ddt_r_1 = matlabFunction(subs(ddt_r_1.',LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_ddt_r_3 = matlabFunction(subs(ddt_r_3.',LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% 
% Func_V_1 = matlabFunction(subs(V_1,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_V_2 = matlabFunction(subs(V_2,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_V_3 = matlabFunction(subs(V_3,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% 
% Func_T_1 = matlabFunction(subs(T_1,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_T_2 = matlabFunction(subs(T_2,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% 
% Func_V = matlabFunction(subs(V,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_T = matlabFunction(subs(T,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% Func_L = matlabFunction(subs(L,LeibnizNotation,DotNotation),'vars',Func_args_symbols);
% 
% Func_F_rope = matlabFunction(subs(F_rope.',LeibnizNotation,DotNotation),'vars',Func_args_symbols);



%% Evaluate Time-Dependent Parameters

% r_1_z = Func_r_1(Func_args);
% r_3_z = Func_r_3(Func_args);
% ddt_r_1_z = Func_ddt_r_1(Func_args);
% ddt_r_3_z = Func_ddt_r_3(Func_args);
% ddt_r_3_theta_z = atan2(ddt_r_3_z(:,2),ddt_r_3_z(:,1));
% 
% V_1_z = Func_V_1(Func_args);
% V_2_z = Func_V_2(Func_args);
% V_3_z = Func_V_3(Func_args);
% V_1_z_tare = V_1_z - min(V_1_z);
% V_2_z_tare = V_2_z - min(V_2_z);
% V_3_z_tare = V_3_z - min(V_3_z);
% V_z = Func_V(Func_args);
% 
% T_1_z = Func_T_1(Func_args);
% T_2_z = Func_T_2(Func_args);
% T_z = Func_T(Func_args);

% EnergySum1_z = V_1_z + V_2_z + V_3_z + T_1_z + T_2_z;
% EnergySum1_z_tare = EnergySum1_z - min(EnergySum1_z);
% EnergySum2_z = T_z + V_z;
% EnergySum2_z_tare = EnergySum2_z - min(EnergySum2_z);

% F_rope_z = Func_F_rope(Func_args);

%% Compute discrete events

% release_angle = deg2rad(135);
% [r,c,i] = zerocrossrate(ddt_r_3_theta_z - release_angle,"InitialState",-1);
% i_release = find(i,1);
% t_z_release = t_z(i_release);
