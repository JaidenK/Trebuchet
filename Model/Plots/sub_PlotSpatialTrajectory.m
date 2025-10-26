% Assumptions:
%   Must already have a figure open and prepared
%   Must already have a solution loaded

hold on;

% Circles as gridlines for range of motion
l_1 = sysparam.constants.l_1.expr;
l_2 = sysparam.constants.l_2.expr;
circColor = .8*ones(1,3);
rectangle('Position',l_1*[-1 -1 2 2],'Curvature',[1 1],'EdgeColor',circColor); % Arm
rectangle('Position',(l_1+l_2)*[-1 -1 2 2],'Curvature',[1 1],'EdgeColor',circColor); % Proj

% Curves through full range of motion
hArmTraj = plot(sysvar.x_1.z,sysvar.y_1.z);
hProjTraj = plot(sysvar.x_2.z(1:i_release),sysvar.y_2.z(1:i_release));
hProjTrajRel = plot(sysvar.x_2.z(i_release:end),sysvar.y_2.z(i_release:end),'--');
hProjTrajRel.SeriesIndex = hProjTraj.SeriesIndex;

% Ghosts to show intermediate positions
linkage_points_x_z = @(z_i) [0, sysvar.x_1.z(z_i), sysvar.x_2.z(z_i)];
linkage_points_y_z = @(z_i) [0, sysvar.y_1.z(z_i), sysvar.y_2.z(z_i)];
ghost_time_step = 0.050; % 50 ms between ghosts
ghostColor = .8*ones(1,3);
for i=1:(ghost_time_step/dt_z):i_release
    z_i = round(i);
    plot(linkage_points_x_z(z_i),linkage_points_y_z(z_i),'Color',ghostColor,'LineWidth',0.5);
end
% Starting Position
plot(linkage_points_x_z(1),linkage_points_y_z(1),'k','LineWidth',1.5);
% Release Position
plot(linkage_points_x_z(i_release),linkage_points_y_z(i_release),'k','LineWidth',1.5);

% Mark Points
scatter([linkage_points_x_z(1) linkage_points_x_z(i_release)], ...
    [linkage_points_y_z(1) linkage_points_y_z(i_release)], ...
    'k','filled','HandleVisibility','off'); 




legend(["$\vec{r}_1$ (Arm)","$\vec{r}_2$ (Projectile)","$\vec{r}_3$ (Projectile)"],Interpreter="latex")
grid on;
xlabel("x (m)"); ylabel("y (m)"); 
xlim padded; ylim padded;
axis equal;
title("Spatial Trajectory");