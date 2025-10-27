clear sysparam sysparam_symbols sysparam_values;

sysparam = struct;
sysparam.timeLimits = [0 2];

sysparam.init_cond = struct;
sysparam.init_cond.theta_1_0     = struct('sym', sym('theta_1_0'),    'expr', deg2rad(-(90+30)));
sysparam.init_cond.theta_dot_1_0 = struct('sym', sym('theta_dot_1_0'),'expr', 0);
sysparam.init_cond.theta_2_0     = struct('sym', sym('theta_2_0'),    'expr', deg2rad(-(90+40)));
sysparam.init_cond.theta_dot_2_0 = struct('sym', sym('theta_dot_2_0'),'expr', 0);

sysparam.constants = struct;
sysparam.constants.I_1   = struct('sym', I_1,   'expr', 0.39);
sysparam.constants.g     = struct('sym', g,     'expr', 9.81);
sysparam.constants.l_1   = struct('sym', l_1,   'expr', 1);
sysparam.constants.l_1cg = struct('sym', l_1cg, 'expr', .37);
sysparam.constants.l_2   = struct('sym', l_2,   'expr', .8);
sysparam.constants.m_1   = struct('sym', m_1,   'expr', 5);
sysparam.constants.m_2   = struct('sym', m_2,   'expr', 0.51);
sysparam.constants.k     = struct('sym', k,     'expr', 5900);
sysparam.constants.l_3   = struct('sym', l_3,   'expr', .1);
sysparam.constants.x_3_0     = struct('sym', x_3_0, 'expr', .13);
sysparam.constants.theta_1_0 = struct('sym', sym('theta_1_0'), 'expr', sysparam.init_cond.theta_1_0.expr);
sysparam.constants.phi_rel   = struct('sym', sym('phi_rel'),   'expr', deg2rad(135));


% build symbols and values arrays from sysparam.constants
fieldNames = fieldnames(sysparam.constants);
sysparam_symbols = sym.empty;
sysparam_values = double.empty;
for i=1:numel(fieldNames)
    fieldName = fieldNames{i};
    sysvar_i = sysparam.constants.(fieldName);
    sysparam_symbols(i) = sysvar_i.sym;
    sysparam_values(i) = double(sysvar_i.expr);
end