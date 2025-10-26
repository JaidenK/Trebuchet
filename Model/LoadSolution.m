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
Func_args_z =         [t_z; d2dt2_theta_1_z; d2dt2_theta_2_z;  ddt_theta_1_z; ddt_theta_2_z; theta_1_z; theta_2_z]';

%% Substitute solution parameters into the model's time-depenent functions.
% We want to remove dependence on all symbols except time and theta
fieldNames = fieldnames(sysvar);
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar.(fieldName).f_of_t = subs(sysvar.(fieldName).f_of_t,sysparam_symbols,sysparam_values);
    sysvar.(fieldName).func = matlabFunction(subs(sysvar.(fieldName).f_of_t,LeibnizNotation,DotNotation),'vars',Func_args_symbols);    
    sysvar.(fieldName).z = sysvar.(fieldName).func(Func_args_z); % Evaluate discrete samples
end
disp("Lagrangian f_of_t Symvars:")
disp(symvar(sysvar.L.f_of_t));

%% Compute discrete events

% Time of Release
r_dot_2_theta_z = atan2(sysvar.y_dot_2.z,sysvar.x_dot_2.z); % Projectile polar coordinate argument
desired_release_angle = deg2rad(135);
[r,c,i] = zerocrossrate(r_dot_2_theta_z - desired_release_angle,"InitialState",-1);
i_release = find(i,1);
if(isempty(i_release))
    warning("No valid release timing found.");
    i_release = length(t_z);
end
t_z_release = t_z(i_release);
% Use t_z_release instead of t_release to indicate that this value came
% from discrete samples with no interpolation.
