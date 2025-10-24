clear all; 
close all; 
clc;

LoadSolution;

%% Plot trajectory 
% currentstate_vars = {sym("t1"), sym("t2")};
% currentstate_vals = {pi/4, 0};    
% r1_0 = double(subs(r1,currentstate_vars,currentstate_vals));
% r3_0 = double(subs(r3,currentstate_vars,currentstate_vals));

figure('Position',[500 100 1000 1000]);
%plot([0 r1_0(1) r3_0(1)],[0 r1_0(2) r3_0(2)]);
hold on;
%scatter(0,0);
%scatter(r1_0(1),r1_0(2));
%scatter(r3_0(1),r3_0(2));

xlim(2*[-1 1]); ylim(2*[-1 1]);
xlabel("X"); ylabel("Y");
yline(0);xline(0);
axis equal;
grid on;
title("Spatial Trajectory");

hLinks = plot([0 0 0],[0 0 0]);
hVel = quiver([0],[0],[0],[0]);
hRope = quiver([0],[0],[0],[0]);

for i=1:length(t_z)  

    %r3dot_t = double(subs(r3dot,currentstate_vars,currentstate_vals));

    hLinks.XData = [0 r_1_z(i,1) r_3_z(i,1)];
    hLinks.YData = [0 r_1_z(i,2) r_3_z(i,2)];
    
    hVel.XData = [r_3_z(i,1)];
    hVel.YData = [r_3_z(i,2)];
    vecScale = 0.1;
    hVel.UData = vecScale*[ddt_r_3_z(i,1)];
    hVel.VData = vecScale*[ddt_r_3_z(i,2)];
    
    % f_rope = F_rope_z(i,:)./norm(F_rope_z(i,:));
    % hRope.XData = [r_3_z(i,1)];
    % hRope.YData = [r_3_z(i,2)];
    % vecScale = 0.1;
    % hRope.UData = vecScale*[f_rope(1)];
    % hRope.VData = vecScale*[f_rope(2)];

    pause(0.1);
    
end