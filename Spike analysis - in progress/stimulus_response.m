for istim = 1:4
cfg = [];
cfg.binsize = 0.1;
cfg.outputunit = 'rate';
cfg.keeptrials = 'yes';
cfg.trials = find(resp_chans.trialinfo == istim);
cfg.spikechannel = resp_chans.label{5}

psth = ft_spike_psth(cfg,resp_chans);
 base = squeeze(psth.trial(:,1,1:5));
    resp = squeeze(psth.trial(:,1,6:end));
    
    [p,~,stats] = kruskalwallis([base,resp],[],'off');
    
    
    
    if p <= 0.05
        comp = multcompare(stats,'display','off');
        
        f = comp(:,5) < 0.005;
        basediff = intersect(unique(comp(f,1)),1:5);
        if numel(basediff) <5
            bins{istim} = [];
        else
            bins{istim} = unique(comp(f,2));
        end
    else
        bins{istim} = [];
    end
    
    if ~isempty(bins{istim})
        vis_responsive(istim) = 1;
    else
        vis_responsive(unit) = 0;
    end
    
    

figure
cfg= [];
cfg.trials = find(resp_chans.trialinfo == istim);
cfg.spikechannel = resp_chans.label{5};
cfg.plotselection = 'yes';
ft_spike_plot_raster(cfg,resp_chans,psth)
end