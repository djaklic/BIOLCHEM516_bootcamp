%%
clc
clear

%%
T = load('PartB.mat').T;
wavelengths = cell2mat(table2array(T(5:65,1)));
abs_mean_400 = [];
abs_sd_400 = [];
m_min = 0.0058-.004;
m_max = 0.6244-.004;

labels = ["C1"; "C2"; "C3"; "C4";];
f1 = figure;
legend();
hold on;
title_counter = 1;
for i=2:4:size(T, 2)-3
    BL_S = [];
    baseline = cell2mat(table2array(T(5:65,i)));
    for j=i+1:i+3
       well_id1 = cell2mat(table2array(T(1,j)));
       well_id2 = num2str(cell2mat(table2array(T(2,j))));
       well_id = strcat(well_id1, well_id2);
       %disp(well_id)
       sample = cell2mat(table2array(T(5:65,j)));
       baseline_subtracted = sample - baseline;
       BL_S = [BL_S baseline_subtracted];
    end
    m_mean = mean(BL_S, 2);
    m_sd = std(BL_S, 0, 2);
    abs_mean_400 = [abs_mean_400 m_mean(15)];
    abs_sd_400 = [abs_sd_400 m_sd(15)];
    errorbar(wavelengths, m_mean, m_sd, 'DisplayName', labels(title_counter));
    title_counter = title_counter + 1;
end
h = axes(f1,'visible','off'); 
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h,'Absorbance');
xlabel(h,'Wavelength (nm)');
hold off;

%%
pKa = 7.02;
pHs = [5 6 6.5 7 7.5 8 8.5 9 10];

abs_mean_400_norm = (abs_mean_400-m_min)/(m_max - m_min);
pH_HH = pKa - log((1./abs_mean_400_norm)-1);

%%
% Standard curve: conc. vs. absorbance
abs_400 = [0.00583058305830583,0.0934543454345435,0.158360836083608,...
    0.307975797579758,0.454345434543454,0.566281628162816,...
    0.554400440044005,0.585973597359736,0.624422442244225];

abs_400_norm = [0,0.141650364574071,0.246576560554863,0.488440334341099,...
    0.725057798328293,0.906011026142627,0.886804197047839,0.937844566957139,1];

% normalized concentration, not sure if this is viable
conc_norm = [0.00938590062284397,0.0865480257124741,0.230544577211345,...
    0.486516710328897,0.749762553650719,0.904533060869102,...
    0.967702391368694,0.989555950820326,0.998945684895107];

abs_m = abs_400_norm*(m_max - m_min) + m_min;
conc_m = conc_norm*(m_max - m_min) + m_min;

p = polyfit(conc_m, abs_m,1);
yfit = p(1)*conc_m+p(2);

pH_SC = p(2) 

f2 = figure;
hold on;
plot(conc_m, abs_m);
plot(conc_m, yfit, 'r-.');
xlabel('normalized concentration');
ylabel('normalized absorbance');
hold off;
legend("normalized data", "linear fit");