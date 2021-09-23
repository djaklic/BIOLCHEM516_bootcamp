%% generate some fake data into array
clear all; close all;
pH = [5 6 6.5 7 7.5 8 8.5 9 10];
% 400 nm

fraction_deprotonated_raw = ...
    [0.00583058305830583,0.0934543454345435,0.158360836083608,...
    0.307975797579758,0.454345434543454,0.566281628162816,...
    0.554400440044005,0.585973597359736,0.624422442244225];

% 500 nm
%{
fraction_deprotonated_raw = ...
    [-0.00115511551155116,0.0178767876787679,0.00797579757975798...
    ,0.00533553355335534,-0.0221122112211221,0.0171067106710671,...
    -0.0256875687568757,0.0143564356435644,-0.0341034103410341];
%}

% normalize again - can I do this?
m_min = min(fraction_deprotonated_raw);
m_max = max(fraction_deprotonated_raw);
fraction_deprotonated = (fraction_deprotonated_raw - m_min)/(m_max - m_min);


%% fit equation

[p1,resnorm,residual,exitflag,output,lambda,jacobian] = ...
    lsqcurvefit('HH_function',[8], pH, fraction_deprotonated); % X = lsqcurvefit(FUN,X0,XDATA,YDATA), for a non-linear least squares fit, with initial parameter X0
ci = nlparci(p1, residual, 'jacobian', jacobian, 'alpha', .32); % returns 68% confidence intervals CI for the nonlinear least squares parameter estimates p1. 
% Jacobian is computed by lsqcurvefit; CI returns 100*(1-alpha) percent confidence intervals; if
% no alpha, the default is 95% CI

dp1 = (ci(:, 2)-ci(:, 1))/2; % error estimate


%% plot data

plot(pH, fraction_deprotonated, 'k.');
hold on

fit = HH_function(p1, pH);
plot(pH, fit, 'r');
hold off
legend('data1', 'fit to data1', ...
    'location', 'best')
xlabel('pH')
ylabel('normalized concentration')
p1_s = num2str(p1);
text(8, 0.5, "Estimated pKA: " + p1_s(1:4));

