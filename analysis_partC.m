%%
clc
clear

%%
T = load('PartC.mat').T;
wavelengths = cell2mat(table2array(T(5:65,1)));
conc = [50 40 30 20 15 10 5 1 0];
STD_CURVE = [];

%%
f1 = figure;
f1_labels = ["pH 10 known"; "pH 10 unknown"; "pH 6 known"; "pH 6 unknown";];
title_counter = 1;
tiledlayout(2,2)
for i=2:9:29
    abs_400 = cell2mat(table2array(T(15,i:i+8)));
    %only row 1 and 3 mean anything
    STD_CURVE = [STD_CURVE; abs_400];
    nexttile;
    hold on;
    for j=i:i+8
        well_id1 = cell2mat(table2array(T(1,j)));
        well_id2 = num2str(cell2mat(table2array(T(2,j))));
        well_id = strcat(well_id1, well_id2);
        sample = cell2mat(table2array(T(5:65,j)));
        plot(wavelengths, sample, 'DisplayName', well_id);
    end
    title(f1_labels(title_counter));
    title_counter = title_counter + 1;
    hold off;
    legend;
end
% peak wavelength at 400 nm

h = axes(f1,'visible','off'); 
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h,'Absorbance');
xlabel(h,'Wavelength (nm)');

%%
p1 = polyfit(conc, STD_CURVE(1,:),1);
yfit1 = p1(1)*conc+p1(2);
f2 = figure;
hold on;
plot(conc, STD_CURVE(1,:));
plot(conc, yfit1, 'r-.');
title('pH 10');
xlabel('concentration (uM)');
ylabel('absorbance');
text(30, 0.1, "y = "+p1(1)+"x + "+p1(2));
hold off;

%%
b1_ph10 = STD_CURVE(2,1:3);
b2_ph10 = STD_CURVE(2,4:6);
b3_ph10 = STD_CURVE(2,7:9);

b1_ph10_mean = mean(b1_ph10);
b2_ph10_mean = mean(b2_ph10);
b3_ph10_mean = mean(b3_ph10);

b1_ph10_std = std(b1_ph10);
b2_ph10_std = std(b2_ph10);
b3_ph10_std = std(b3_ph10);

b1_ph10_conc = (b1_ph10_mean - p1(2))/p1(1);
b2_ph10_conc = (b2_ph10_mean - p1(2))/p1(1);
b3_ph10_conc = (b3_ph10_mean - p1(2))/p1(1);

hold on;
errorbar(b1_ph10_conc, b1_ph10_mean, b1_ph10_std, 'horizontal', '-s', 'MarkerSize',10, 'MarkerEdgeColor','red');
errorbar(b2_ph10_conc, b2_ph10_mean, b2_ph10_std, 'horizontal', '-s', 'MarkerSize',10,'MarkerEdgeColor','red');
errorbar(b3_ph10_conc, b3_ph10_mean, b3_ph10_std, 'horizontal', '-s', 'MarkerSize',10, 'MarkerEdgeColor','red');

text(b1_ph10_conc+5, b1_ph10_mean, "B1 = " + string(b1_ph10_conc)+ " +- " + b1_ph10_std/2 + " uM");
text(b2_ph10_conc-25, b2_ph10_mean, "B2 = " + string(b2_ph10_conc)+ " +- " + b2_ph10_std/2 + " uM");
text(b3_ph10_conc-25, b3_ph10_mean, "B3 = " + string(b3_ph10_conc)+ " +- " + b3_ph10_std/2 + " uM");

l1 = legend({"raw data", "linear fit", "B1", "B2", "B3"},'Location','northwest');
hold off;

%%
p2 = polyfit(conc, STD_CURVE(3,:),1);
yfit2 = p2(1)*conc+p2(2);
f3 = figure;
hold on;
plot(conc, STD_CURVE(3,:));
plot(conc, yfit2, 'r-.');
title('pH 6');
xlabel('concentration (uM)');
ylabel('absorbance');
text(30, 0.07, "y = "+p2(1)+"x + "+p2(2));
hold off

%%
b1_ph6 = STD_CURVE(4,1:3);
b2_ph6 = STD_CURVE(4,4:6);
b3_ph6 = STD_CURVE(4,7:9);

b1_ph6_mean = mean(b1_ph6);
b2_ph6_mean = mean(b2_ph6);
b3_ph6_mean = mean(b3_ph6);

b1_ph6_std = std(b1_ph6);
b2_ph6_std = std(b2_ph6);
b3_ph6_std = std(b3_ph6);

b1_ph6_conc = (b1_ph6_mean - p2(2))/p2(1);
b2_ph6_conc = (b2_ph6_mean - p2(2))/p2(1);
b3_ph6_conc = (b3_ph6_mean - p2(2))/p2(1);

hold on;
errorbar(b1_ph6_conc, b1_ph6_mean, b1_ph6_std, 'horizontal', '-s', 'MarkerSize',10, 'MarkerEdgeColor','red');
errorbar(b2_ph6_conc, b2_ph6_mean, b2_ph6_std, 'horizontal', '-s', 'MarkerSize',10, 'MarkerEdgeColor','red');
errorbar(b3_ph6_conc, b3_ph6_mean, b3_ph6_std, 'horizontal', '-s', 'MarkerSize',10, 'MarkerEdgeColor','red');

text(b1_ph6_conc+10, b1_ph6_mean, "B1 = " + string(b1_ph6_conc) + " +- " + b1_ph6_std/2 + " uM");
text(b2_ph6_conc+10, b2_ph6_mean-.01, "B2 = " + string(b2_ph6_conc) + " +- " + b2_ph6_std/2 + " uM");
text(b3_ph6_conc+10, b3_ph6_mean+.01, "B3 = " + string(b3_ph6_conc) + " +- " + b3_ph6_std/2 + " uM");

l2 = legend({"raw data", "linear fit", "B1", "B2", "B3"},'Location','northwest');
hold off;