function resp_chans = mmn_analyse_spike_response(cfg)

spike = mmn_spike(cfg);
resp_chans = [];

if strcmp(spike,'err')
    fprintf('Channel %i was skipped\n', cfg.chan)
    
    return
end

log = cfg;

clearvars -except log spike resp_chans

for iUnit = 1:length(spike.label)
    for iStim = unique(spike.trialinfo)'
        %skip excluded spikes
        
        
        cfg = [];
        cfg.binsize = 0.1;
        cfg.outputunit = 'rate';
        cfg.keeptrials = 'yes';
        cfg.spikechannel = spike.label{iUnit};
        cfg.trials = find(spike.trialinfo == iStim);
        
        psth = ft_spike_psth(cfg,spike);
        
        base = squeeze(psth.trial(:,1,1:5));
        resp = squeeze(psth.trial(:,1,6:end));
        
        [p,~,stats] = kruskalwallis([base,resp],[],'off');
        
        
        
        if p <= 0.05
            comp = multcompare(stats,'display','off');
            
            f = comp(:,5) < 0.005;
            basediff = intersect(unique(comp(f,1)),1:5);
            if numel(basediff) <5
                bins{iUnit,iStim} = 0;
            else
                bins{iUnit,iStim} = unique(comp(f,2));
            end
        else
            bins{iUnit,iStim} = [];
        end
        
        if ~isempty(bins{iUnit,iStim})
            vis_responsive(iUnit,iStim) = 1;
        else
            vis_responsive(iUnit,iStim) = 0;
        end
        
        
        
    end
    
    if any(vis_responsive(iUnit))
        cfg = [];
        cfg.spikechannel = spike.label(iUnit);
        tmp = ft_spike_select(cfg,spike);
        tmp.label = {['Chan' num2str(log.chan) tmp.label{1}]};
        
        if ~isempty(resp_chans)
            resp_chans = ft_appendspike([],resp_chans,tmp);
            clear tmp
        else
            resp_chans = tmp;
            clear tmp
        end
        
    end
end
%Save outputs to file
save(sprintf('%s\\CSC%i_file.mat',log.dataset,log.chan),'spike','vis_responsive','bins')
%
