resp_chans = [];

for iChan =1:32;
    cfg.dataset = 'E:\Passive_MMN\PVCre116\Depth15_sort';
    cfg.hdr_data = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN';
    cfg.chan = iChan;
    isresp = mmn_analyse_spike_response(cfg);
    
    if ~isempty(isresp)
        if ~isempty(resp_chans)
            resp_chans = ft_appendspike([],resp_chans,isresp);
        else
            resp_chans = isresp;
        end
    else
        continue
    end
    
end

%%

trials = mmn_getTrials_STDvsDEV(resp_chans.trialinfo);

first_resp = zeros(1,length(resp_chans.label));
std_resp = zeros(1,length(resp_chans.label));
dev_resp = zeros(1,length(resp_chans.label));
first_base = zeros(1,length(resp_chans.label));
std_base = zeros(1,length(resp_chans.label));
dev_base = zeros(1,length(resp_chans.label));

for iUnit = 1:length(resp_chans.label)
    
    for iCond = 1:3
        
        cfg = [];
        cfg.binsize = 0.1;
        cfg.outputunit = 'rate';
        cfg.keeptrials = 'yes';
        cfg.spikechannel = resp_chans.label{iUnit};
        switch iCond
            case 1
                cfg.trials = trials.first;
            case 2
                cfg.trials = trials.std;
            case 3
                cfg.trials = trials.mm;
        end
        
        psth = ft_spike_psth(cfg,resp_chans);
        
        base = squeeze(psth.trial(:,1,1:5));
        resp = squeeze(psth.trial(:,1,6:end));
        
        switch iCond
            case 1
                first_base(1,iUnit) = mean(nanmean(base));
                first_resp(1,iUnit) = max(nanmean(resp));
            case 2
               std_base(1,iUnit) = mean(nanmean(base)); 
                std_resp(1,iUnit) = max(nanmean(resp));
            case 3
                dev_base(1,iUnit) = mean(nanmean(base));
                dev_resp(1,iUnit) = max(nanmean(resp));
        end
        
    end
    
    
    
end

dev_resp = dev_resp-dev_base;
std_resp = std_resp - std_base;
first_resp = first_resp - first_base;

%%
figure
scatter((dev_resp),(first_resp),'k')
hold on
plot([0 40],[0 40],'k--')
xlim([0 40])
xlabel('Deviant')
ylabel('Control')
title('Deviance Detection')

figure
scatter((dev_resp),(std_resp),'k')
hold on
plot([0 40],[0 40],'k--')
xlabel('Deviant')
ylabel('Standard')
title('Mismatch Negativity')
xlim([0 40])

figure
scatter((first_resp),(std_resp),'k')
hold on
plot([0 40],[0 40],'k--')
xlabel('Control')
ylabel('Standard')
title('SSA')
xlim([0 40])

%%
figure
plot([zeros(size(std_resp));ones(size(std_resp))],[std_resp;dev_resp],'ok--')
% hold on
% plot([zeros(size(std_resp(dev_resp>std_resp)));ones(size(std_resp(dev_resp>std_resp)))],[std_resp(dev_resp>std_resp);dev_resp(dev_resp>std_resp)],'og--')
% plot([zeros(size(std_resp(dev_resp<std_resp)));ones(size(std_resp(dev_resp<std_resp)))],[std_resp(dev_resp<std_resp);dev_resp(dev_resp<std_resp)],'or--')
xlim([-0.5 1.5])
%%
figure
cfg= [];
cfg.trials = trials.std;
cfg.plotselection = 'yes';
cfg.spikechannel = resp_chans.label{iUnit};
ft_spike_plot_raster(cfg,resp_chans,psth)