function h = mmn_plotERP_FirstVsLast(data,trials)

%% General figure settings
h = figure;
set(h,'Position',[493 214 807 709])

%% Create First/Last ERPs
cfg = [];
cfg.trials = trials.first;
ERP_Fst = ft_timelockanalysis(cfg,data);

cfg = [];
cfg.trials = trials.std;
ERP_Lst = ft_timelockanalysis(cfg,data);

%% Plot EERps
subplot(2,1,2)
plot(ERP_Fst.time, ERP_Fst.avg,'r')
hold on
plot(ERP_Lst.time, ERP_Lst.avg,'b')


end