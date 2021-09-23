pH = 2:.1:13;

plot(pH, HH_function(4, pH), pH, HH_function(7.2, pH),pH, HH_function(9.5, pH))  % plots all lines on the same plot

legend('pKa = 4', 'pKa = 7.2', 'pKa = 9.5', 'location', 'best')

xlabel('pH')
ylabel('fraction deprotonated')