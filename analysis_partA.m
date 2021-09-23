%%
clc
clear

%%
T = load('PartA.mat').T;
wavelengths = cell2mat(table2array(T(5:65,1)));
pHs = [5 6 6.5 7 7.5 8 8.5 9 10];
abs_mean_400 = [];
abs_sd_400 = [];
abs_mean_500 = [];
abs_sd_500 = [];
min_WholeDataSet = min(cell2mat(table2array(T(5:65,2:37))),[],'all');
max_WholeDataSet = max(cell2mat(table2array(T(5:65,2:37))),[],'all');

%%
pH_labels = ["pH 5"; "pH 6"; "pH 6.5"; "pH 7"; "pH 7.5"; "pH 8"; "pH 8.5"; "pH 9"; "pH 10"];
f1 = figure;
legend()
%f4 = figure;
hold on;
title_counter = 1;
%tiledlayout(3,3)
for i=2:4:size(T, 2)-3
    baseline = cell2mat(table2array(T(5:65,i)));
    %nexttile;
    %hold on;
    BL_S = [];
    for j=i+1:i+3
        well_id1 = cell2mat(table2array(T(1,j)));
        well_id2 = num2str(cell2mat(table2array(T(2,j))));
        well_id = strcat(well_id1, well_id2);
        sample = cell2mat(table2array(T(5:65,j)));
        baseline_subtracted = sample - baseline;
        normalized = (baseline_subtracted)/(max_WholeDataSet);
        BL_S = [BL_S normalized];
        %plot(wavelengths, normalized, 'DisplayName', well_id);
    end
    %title(pH_labels(title_counter));
    %hold off;
    %legend;
    m_mean = mean(BL_S, 2);
    m_sd = std(BL_S, 0, 2);
    errorbar(wavelengths, m_mean, m_sd, 'DisplayName', pH_labels(title_counter));
    %400 nm = row 15
    abs_mean_400 = [abs_mean_400 m_mean(15)];
    abs_sd_400 = [abs_sd_400 m_sd(15)];
    %500 nm = row 35
    abs_mean_500 = [abs_mean_500 m_mean(35)];
    abs_sd_500 = [abs_sd_500 m_sd(35)];
    title_counter = title_counter + 1;
end

h = axes(f1,'visible','off'); 
h.XLabel.Visible = 'on';
h.YLabel.Visible = 'on';
ylabel(h,'Absorbance');
xlabel(h,'Wavelength (nm)');
hold off;

%%
f2 = figure;
errorbar(pHs, abs_mean_400, abs_sd_400);
title('pH vs Absorbance at 400 nm');
xlabel('pH');
ylabel('Absorbance');

%%
f3 = figure;
errorbar(pHs, abs_mean_500, abs_sd_500);
title('pH vs Absorbance at 500 nm');
xlabel('pH');
ylabel('Absorbance');