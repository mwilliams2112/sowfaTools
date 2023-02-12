%{
Script for postprocessing SOWFA-6 results
Author: Matt Williams (2023) 
Contact: mattethanwilliams@outlook.com

This script will plot the results for one case. To compare cases, see
'comparePlots.m'. For this script to work, you must have the following
functions in your working directory:

'readData.m'
'readConst.m'
'removeData.m'
'createArrays.m'

Some plots have already been set up including:
- 4 pack plot (Velocity profile, semilog plot, Reynolds stresses,
turbulence intensity)
- Semilog plot with fitted data to estimate friction velocity using M-O
similarity theory
- Non-dimensionlised mean shear phi
%}

close all
set(gcf,'units','centimeters','position',[2 2 30 20])
set(0,'defaultTextInterpreter','tex');
set(0,'defaultfigurecolor',[1 1 1]);

% Adapt path to where you keep simulation data
path = "C:\Users\mattwilliams\OneDrive - Durham University\L4\L4 Research Project\Simulations\";
% Case variables, enter the name of the case folder 
case1 = "0.1roughness"; 

% Read in constants 
[k, Uhub, zhub, heights, startAvg, endAvg] = readConst();

% Specify the surface roughness you entered into SOWFA
z0 = 0.1;               

% Some variables for the legends 
Z0 = "$$z_{0} = $$" + num2str(z0) + "$$m$$";

% Read in the data 
[U1, UU1, T1] = readData(path + case1 + "/");

% Remove unwanted data
[U1, UU1, T1] = removeData(U1, UU1, T1, startAvg, endAvg);

% Write data to individual arrays ready for plotting 
[u1, v1, w1, uu1, uv1, uw1, vv1, vw1, ww1, t1] = createArrays(U1, UU1, T1, heights);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edit this section depending on the plots you want 

%{

4 Pack plot: Velocity Profile, Semilog plot, Reynold's stresses,
Turbulence intensity 

%}

u_uh_1 = u1/Uhub;            % Normalise velocities with respect to Uhub
norm_heights = heights/zhub; % Normalise heights with respect to zhub


% Plot wind speed
tiledlayout(1,4)
nexttile
plot(u_uh_1, norm_heights, 'ok');
axis([min(u_uh_1) 1.2 0 3.5]);
xlabel('\it \fontname{Times New Roman} \fontsize{14} U_0 / U_h');
ylabel('\it \fontname{Times New Roman} \fontsize{14} z/z_h');
l = legend(Z0, 'Location', 'northwest');
set(l,'Interpreter', 'latex', 'fontsize',14);


% Plot semilog relationship between velocity and height 
nexttile
semilogy(u_uh_1, norm_heights, 'ok')
axis([min(u_uh_1) 1.2 min(log(norm_heights)) 3.5])
xlabel('\it \fontname{Times New Roman} \fontsize{14} U_0 / U_h');

% Plot normalised Reynold's shear stress
nexttile
RSS1 = -uw1/(Uhub^2);

plot(RSS1, norm_heights, '-ok');
axis([0 0.004 0 3.5]);
c = xlabel("$$-\overline{u'w'} / U_{h}^2$$");
set(c,'Interpreter', 'latex', 'fontsize',14);

% Plot turbulence intensity 
nexttile
I1 =  uu1.^0.5/(Uhub);
plot(I1, norm_heights, 'ok')
axis([min(I1) 0.2 0 3.5])
d = xlabel("$$I = \sigma_u / U_{h} = \sqrt{\overline{u'u'}} / U_{h}$$");
set(d,'Interpreter', 'latex', 'fontsize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %{
% Semilog plot with fitted line in order to estimate friction velocity
% %}
% B1 = polyfit(log(heights(2:10)), u1(2:10), 1); % Fits a straight line to cells 2-6
% fitFOE1 = polyval(B1,log(heights));          % Evaluates the straightline at each height
% Slope1 = B1(1);                              % Slope of straight line
% Intercept1 = B1(2);                          % Intercept of straight line
%
% semilogx(heights, u1, 'o',    heights, fitFOE1,'-') % Plot the data with the fitted polynomial 
% 
% xlabel('Height,m');
% ylabel('U, m/s');
% grid on
% 
% % This is a crucial step and estimates friction velocity from the fitted
% % line. We assume that the surface roughness z0 is kept at the specified
% % level throughout the simulation. 
% ustar = (-Intercept1 * k)/log(z0);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % Non-dimensional mean shear phi
% 
% dUdz1 = ([diff(u1) 0]./[diff(heights) 10]);
% H = 750; % Boundary layer height 
% phi1 = k*heights/ustar .* dUdz1;
% 
% plot(phi1,heights/H,'-xk')
% axis([0 2.5 0 0.4])
% xline(1,'--')
% philabel = xlabel("$$\phi = \frac{kz}{u_{*}} \frac{dU}{dz}$$");
% set(philabel,'Interpreter', 'latex', 'fontsize',12);
% zzilabel = ylabel("$$\frac{z}{z_{i}}$$");
% set(zzilabel,'Interpreter', 'latex', 'fontsize',12);







