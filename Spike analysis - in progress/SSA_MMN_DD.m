trials = mmn_getTrials_STDvsDEV(resp_chans.trialinfo);

first_resp = zeros(1,length(resp_chans.label));
std_resp = zeros(1,length(resp_chans.label));
dev_resp = zeros(1,length(resp_chans.label));
first_base = zeros(1,length(resp_chans.label));
std_base = zeros(1,length(resp_chans.label));
dev_base = zeros(1,length(resp_chans.label));

for iStim = 1:4
    
    for iUnit = 1:length(resp_chans.label)
        
        for iCond = 1:3
            
            cfg = [];
            cfg.binsize = 0.1;
            cfg.outputunit = 'rate';
            cfg.keeptrials = 'yes';
            cfg.spikechannel = resp_chans.label{iUnit};
            switch iCond
                case 1
                    cfg.trials = trials.first(resp_chans.trialinfo(trials.first)==iStim);
                case 2
                    cfg.trials = trials.std(resp_chans.trialinfo(trials.std)==iStim);
                case 3
                    cfg.trials = trials.av_mm(resp_chans.trialinfo(trials.av_mm)==iStim);
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
    
    switch iStim
        case 1
            stim1_dev = dev_resp;
            stim1_std = std_resp;
            stim1_first = first_resp;
            MMN_ind_stim1 = (dev_resp-std_resp)./(std_resp+dev_resp);
            
        case 2
            stim2_dev = dev_resp;
            stim2_std = std_resp;
            stim2_first = first_resp;
            MMN_ind_stim2 = (dev_resp-std_resp)./(std_resp+dev_resp);
            
        case 3
            stim3_dev = dev_resp;
            stim3_std = std_resp;
            stim3_first = first_resp;
            MMN_ind_stim3 = (dev_resp-std_resp)./(std_resp+dev_resp);
        case 4
            stim4_dev = dev_resp;
            stim4_std = std_resp;
            stim4_first = first_resp;
            MMN_ind_stim4 = (dev_resp-std_resp)./(std_resp+dev_resp);
    end
    
end


%%
figure
scatter((dev_resp),(first_resp),'b')
hold on
plot([0 40],[0 40],'k--')
xlim([0 40])
ylim([0 40])
xlabel('Deviant')
ylabel('Control')
title('Deviance Detection')

figure
scatter((dev_resp),(std_resp),'b')
hold on
plot([0 40],[0 40],'k--')
xlabel('Deviant')
ylabel('Standard')
title('Mismatch Negativity')
xlim([0 40])
ylim([0 40])

figure
scatter((first_resp),(std_resp),'b')
hold on
plot([0 40],[0 40],'k--')
xlabel('Control')
ylabel('Standard')
title('SSA')
xlim([0 40])
ylim([0 40])

%%


scatter((dev_resp(MMN_ind_stim1 > 0.5)),(std_resp(MMN_ind_stim1 > 0.5)),'r')

scatter((dev_resp(MMN_ind_stim4 > 0.5 )),(std_resp(MMN_ind_stim4 > 0.5 )),'g')

scatter((dev_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),(std_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),'m')

%%

scatter((dev_resp(MMN_ind_stim1 > 0.5)),(first_resp(MMN_ind_stim1 > 0.5)),'r')

scatter((dev_resp(MMN_ind_stim4 > 0.5 )),(first_resp(MMN_ind_stim4 > 0.5 )),'g')

scatter((dev_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),(first_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),'m')
%%

scatter((first_resp(MMN_ind_stim1 > 0.5)),(std_resp(MMN_ind_stim1 > 0.5)),'r')

scatter((first_resp(MMN_ind_stim4 > 0.5 )),(std_resp(MMN_ind_stim4 > 0.5 )),'g')

scatter((first_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),(std_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),'m')

%%

plot([zeros(size(dev_resp(MMN_ind_stim1 > 0.5))),std_resp(MMN_ind_stim1 > 0.5)],[dev_resp(MMN_ind_stim1 > 0.5),std_resp(MMN_ind_stim1 > 0.5)],'ro--')

scatter((dev_resp(MMN_ind_stim4 > 0.5 )),(std_resp(MMN_ind_stim4 > 0.5 )),'g')

scatter((dev_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),(std_resp(MMN_ind_stim1 > 0.5 & MMN_ind_stim4 > 0.5 )),'m')
