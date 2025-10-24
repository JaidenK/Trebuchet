% Assuming LoadSolution.m has already been run.
clc;

theta_1_min   = min(theta_1_z);
theta_1_max   = max(theta_1_z);
theta_1_range = range(theta_1_z);


ddt_theta_1_max = max(ddt_theta_1_z);
ddt_r_1_max = max(vecnorm(ddt_r_1_z,2,2));

ddt_r_3_max = max(vecnorm(ddt_r_3_z,2,2));

V_1_range = range(V_1_z);
T_1_range = range(T_1_z);
V_2_range = range(V_2_z);
T_2_range = range(T_2_z);

Energy_tot_range = range(T_z+V_z);


