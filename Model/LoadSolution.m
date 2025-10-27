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

% Clear values we expect to load so that we don't accidentally get stuck 
% with old data if the load fails.
clear sol sysparam;
% Load the solution
load(filename);

SubsSystemParameters;

%% Compute exact discrete events
clear sysparam.discrete;
sysparam.discrete = struct;

% Compute exact time of release
%desired_release_angle = deg2rad(135);
%vAngle = @(t) atan2(sysvar.y_dot_2.func(devalToArgs(sol,t)),sysvar.x_dot_2.func(devalToArgs(sol,t)));
%tReleaseFunc = @(t) vAngle(t)-desired_release_angle;
%if(tReleaseFunc(min(sol.x))*tReleaseFunc(max(sol.x)) > 0)
    %warning("Projectile release does not occur!");
    %t_release = max(sol.x);
%else
    %t_release = fzero(tReleaseFunc,.8);
%end
t_release = sol.x(end); % We are now using the event function to only solve up to release 

syms t_rel T_2_rel;
%syms phi_rel;
% sysparam.discrete.phi_release = struct( ...
%     'sym', phi_rel, ...
%     'expr', desired_release_angle, ...
%     'subsexpr', desired_release_angle);
sysparam.discrete.t_release   = struct( ...
    'sym', t_rel, ...
    'expr', sym('phi_2')-sym('phi_rel')==0, ...
    'subsexpr', t_release);
sysparam.discrete.T_2_release = struct( ...
    'sym', T_2_rel, ...
    'expr', str2sym('T_2(t_rel)'), ...
    'subsexpr', sysvar.T_2.func(devalToArgs(sol,t_release)));


%% Evaluate discrete samples for plotting.
% Time samples for evaluating the solution up to the point of release
nSamples = 100;
t_z = linspace(min(sol.x),t_release,nSamples); 
Func_args_z = devalToArgs(sol,t_z);
fieldNames = fieldnames(sysvar);
for i=1:numel(fieldNames)
    sysvar.(fieldNames{i}).z = sysvar.(fieldNames{i}).func(Func_args_z); % Evaluate discrete samples
end    

% Discrete time step
dt_z = t_z(2)-t_z(1);

i_release = length(t_z);

fprintf("Quick Stats:\n");
fprintf("  %.2f = t_release : time of release\n",sysparam.discrete.t_release.subsexpr);
fprintf("  %.2f = T_2_release : Proj. Kinetic Energy at release\n",sysparam.discrete.T_2_release.subsexpr);

function FuncArgs = devalToArgs(sol,t)
    [Y,Yp] = deval(sol,t);    
    FuncArgs = [t; Yp(4,:); Yp(2,:);  Y(4,:); Y(2,:); Y(3,:); Y(1,:)]';
end
