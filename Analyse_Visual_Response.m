function Analyse_Visual_Response(cfg)

spike = mmn_spike(cfg);

if strcmp(spike,'err')
    fprintf('Channel %i was skipped\n', cfg.chan)
    return
end

log = cfg;
clear SDF sig base_rate uresp_rate pref SI*

for unit = 1:length(spike.label)
    %skip excluded spikes
    if strcmp(spike.label{unit},'clus0')
        continue
    end
    
    
    
%     
%     for iTrial = 1:length(spike.trialinfo)
%         indx = find(spike.trial{unit} == iTrial);
%         
%         base_i = sum(spike.time{unit}(indx)< 0);
%         uresp_i = sum(spike.time{unit}(indx) <= 0.5 & spike.time{unit}(indx)>= 0);
%         if isempty(base_i)
%             base_rate(unit,iTrial) = 0;
%         else
%             base_rate(unit,iTrial) = (base_i)/0.5;
%         end
%         if isempty(uresp_i)
%             uresp_rate(unit,iTrial) = 0;
%         else
%             uresp_rate(unit,iTrial) = (uresp_i)/0.5;
%         end
%     end
    
cfg = [];
cfg.trials = 
cfg.latency = [-0.5 0];
cfg.keeptrials = yes;
rate_base = ft_spike_rate(cfg,spikes)




    cfg = [];
    cfg.timwin = [-0.1 0.1];
    cfg.outputunit = 'rate';
    cfg.winfunc = 'gauss';
    cfg.spikechannel = spike.label{unit};
    cfg.trials = 'all';
    SDF{unit} = ft_spikedensity(cfg,spike);
    
    %calculate whether mean firing rate during response period is
    %significantly different from firing rates during baseline for all
    %visual responses
    sig = ranksum(base_rate(unit,:),uresp_rate(unit,:));
    x=[];
    y = [];
    if sig <= 0.05
        x = find(SDF{unit}.avg(1,501:1001) > mean(base_rate(unit,:))+(3*std(base_rate(unit,:))));
        y = find(SDF{unit}.avg(1,1001:1500) > mean(base_rate(unit,:))+(3*std(base_rate(unit,:))));
    end
    
    if ~isempty(x)
        vis_responsive(unit) = 1;
    else
        vis_responsive(unit) = 0;
    end
    
    if ~isempty(y)
        off_responsive(unit) = 1;
    else
        off_responsive(unit) = 0;
    end
    
    %Check if Neuron is visually selective (e.g. prefers to respond to one
    %stimulus over others.
    
    stim1 = find(spike.trialinfo == 1);
    stim2 = find(spike.trialinfo == 2);
    stim3 = find(spike.trialinfo == 3);
    stim4 = find(spike.trialinfo == 4);
    
    
    
    SI1(unit) = (mean(uresp_rate(unit,stim1))-mean(uresp_rate(unit,stim3)))/((mean(uresp_rate(unit,stim1)+mean(uresp_rate(unit,stim3)))));
    SI2(unit) = ((mean(uresp_rate(unit,stim2)-mean(uresp_rate(unit,stim4)))))/((mean(uresp_rate(unit,stim2)+mean(uresp_rate(unit,stim4)))));
    SI3(unit) = ((mean(uresp_rate(unit,stim2)-mean(uresp_rate(unit,stim1)))))/((mean(uresp_rate(unit,stim2)+mean(uresp_rate(unit,stim1)))));
    SI4(unit) = ((mean(uresp_rate(unit,stim4)-mean(uresp_rate(unit,stim3)))))/((mean(uresp_rate(unit,stim4)+mean(uresp_rate(unit,stim3)))));
    
    [~, pref(unit)] = max(abs([SI1(unit) SI2(unit) SI3(unit) SI4(unit)]));
    
    SIHorz(unit) = (mean([uresp_rate(unit,stim1),uresp_rate(unit,stim2)])-mean([uresp_rate(unit,stim3),uresp_rate(unit,stim4)]))/(mean([uresp_rate(unit,stim1),uresp_rate(unit,stim2)])+mean([uresp_rate(unit,stim3),uresp_rate(unit,stim4)]));
    
    SIHigh(unit) =(mean([uresp_rate(unit,stim4),uresp_rate(unit,stim2)])-mean([uresp_rate(unit,stim3),uresp_rate(unit,stim1)]))/(mean([uresp_rate(unit,stim4),uresp_rate(unit,stim2)])+mean([uresp_rate(unit,stim3),uresp_rate(unit,stim1)]));
    
    [frst1, lst1] = get_first_last(spike,1);
    [frst2, lst2] = get_first_last(spike,2);
    [frst3, lst3] = get_first_last(spike,3);
    [frst4, lst4] = get_first_last(spike,4);
    
    
    SI1f(unit) = (mean(uresp_rate(unit,frst1))-mean(uresp_rate(unit,frst3)))/((mean(uresp_rate(unit,frst1)+mean(uresp_rate(unit,frst3)))));
    SI2f(unit) = ((mean(uresp_rate(unit,frst2)-mean(uresp_rate(unit,frst4)))))/((mean(uresp_rate(unit,frst2)+mean(uresp_rate(unit,frst4)))));
    SI3f(unit) = ((mean(uresp_rate(unit,frst2)-mean(uresp_rate(unit,frst1)))))/((mean(uresp_rate(unit,frst2)+mean(uresp_rate(unit,frst1)))));
    SI4f(unit) = ((mean(uresp_rate(unit,frst4)-mean(uresp_rate(unit,frst3)))))/((mean(uresp_rate(unit,frst4)+mean(uresp_rate(unit,frst3)))));
    
    SI1l(unit) = (mean(uresp_rate(unit,lst1))-mean(uresp_rate(unit,lst3)))/((mean(uresp_rate(unit,lst1)+mean(uresp_rate(unit,lst3)))));
    SI2l(unit) = ((mean(uresp_rate(unit,lst2)-mean(uresp_rate(unit,lst4)))))/((mean(uresp_rate(unit,lst2)+mean(uresp_rate(unit,lst4)))));
    SI3l(unit) = ((mean(uresp_rate(unit,lst2)-mean(uresp_rate(unit,lst1)))))/((mean(uresp_rate(unit,lst2)+mean(uresp_rate(unit,lst1)))));
    SI4l(unit) = ((mean(uresp_rate(unit,lst4)-mean(uresp_rate(unit,lst3)))))/((mean(uresp_rate(unit,lst4)+mean(uresp_rate(unit,lst3)))));
    
    
    
end



%Save outputs to file
save(sprintf('%s\\CSC%i_file.mat',log.dataset,log.chan),'spike','base_rate','uresp_rate','vis_responsive','SI*','pref','off_responsive')
%
