figure();
subplot(2,1,1);
plot(sysvar.x_3.z);
hold on
plot(heaviside(sysvar.x_3.z));
subplot(2,1,2);
plot(sysvar.V_3.z);