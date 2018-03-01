for iStim = 1:4

%% Figure Settings
h = figure;
set(h,'Position',[493 214 807 709])

f = find(data.trialinfo == iStim);

%% Create ERP and plot for all std
cfgERP = [];
cfgERP.trials = intersect(trials.std,f);
try
ERP = ft_timelockanalysis(cfgERP,data);


subplot(2,1,1)
hold on
plot(ERP.time, ERP.avg, 'b')

norm = ERP.avg;
catch
end

%% Create ERP and plot for all auditory mismatch

cfgERP = [];
cfgERP.trials = intersect(trials.aud_mm,f);
try
ERP = ft_timelockanalysis(cfgERP,data);
catch
end


plot(ERP.time, ERP.avg,'m')

%% Create ERP and plot for all visual mismatch

cfgERP = [];
cfgERP.trials = intersect(trials.vis_mm,f);
try
ERP = ft_timelockanalysis(cfgERP,data);


plot(ERP.time, ERP.avg,'k')
catch
end


%% Create ERP and plot for all full mismatch

cfgERP = [];
cfgERP.trials = intersect(trials.av_mm,f);
try
ERP = ft_timelockanalysis(cfgERP,data);


plot(ERP.time, ERP.avg,'r')
catch
end


%% Add Labels for top-plot
legend('Standard','Aud. Mismatch','Vis. Mismatch','AV Mismatch')
xlabel('Time (s)')
ylabel('ERP (mV)')
title(['Channel ' data.label{1}])

plot([0 0],ylim,'k--')
xlim([-0.5 1])

%% Plot MMN

subplot(2,1,2)
hold on
try
plot(ERP.time,ERP.avg - norm,'g')
catch
end


%% Add Labels for bottom-plot
legend('Mismatch Negativity')
xlabel('Time (s)')
ylabel('dERP (mV)')

plot([0 0],ylim,'k--')
xlim([-0.5 1])

end