for iChan =16:64;
    cfg.dataset = 'E:\Canon_MMN_passiveAwake\2018-02-20_11-04-13\Sort\2018-02-20_11-04-13';
    cfg.hdr_data = 'E:\Canon_MMN_passiveAwake\2018-02-20_11-04-13\AV MMN Full Task';
    cfg.chan = iChan;
    
    spike = mmn_spikes_unsorted(cfg);
    
    if strcmp(spike,'err')
        continue
    end
    
    trials = mmn_getTrials_STDvsDEV(spike.trialinfo);
    % First Last All Mismatch
    
    nClus = length(spike.label);
    
    for iClus =1:nClus
        
        
        
        h = figure;
        
        set(h,'Position', [5 553 1807 420])
        
        ind_1st_std = trials.first;
        ind_lst_std = trials.std;
        ind_mm = trials.mm;
        
        for iPlot = 1:3
            cfg = [];
            cfg.timwin = [-0.025 0.025];
            cfg.outputunit = 'rate';
            cfg.winfunc = 'gauss';
            cfg.spikechannel = spike.label{iClus};
            switch iPlot
                case 1
                    cfg.trials = ind_1st_std;
                case 2
                    cfg.trials = ind_lst_std;
                case 3
                    cfg.trials = ind_mm;
            end
            
            
            
            SDF = ft_spikedensity(cfg,spike);
            
            cfg2 = [];
            cfg2.spikechannel = spike.label{iClus};
            cfg2.trials = cfg.trials;
            cfg2.plotselection   =  'yes';
            cfg2.topplotfunc      = 'line';
            
            subplot(1,3,iPlot)
            
            ft_spike_plot_raster(cfg2, spike, SDF)
        end
        
        
        
    end
    saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.51\ERP\fig\spikes_Channel_' num2str(iChan) '.fig'])
%     saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.51\ERP\pdf\spikes_Channel_' num2str(iChan) '.pdf'])
    close
end
%% Audio Only, Visual Only and AV Mismatch

nClus = length(spike.label);

for iClus =1
    
    for iStim = 1:4
        
        h = figure;
        
        set(h,'Position', [5 553 1807 420])
        
        
        ind_av = trials.av_mm(spike.trialinfo(trials.av_mm) == iStim);
        ind_vo = trials.vis_mm(spike.trialinfo(trials.vis_mm) == iStim);
        ind_ao = trials.aud_mm(spike.trialinfo(trials.aud_mm) == iStim);
        
        for iPlot = 1:3
            cfg = [];
            cfg.timwin = [-0.025 0.025];
            cfg.outputunit = 'rate';
            cfg.winfunc = 'gauss';
            cfg.spikechannel = spike.label{iClus};
            
            switch iPlot
                case 1
                    cfg.trials = ind_ao;
                case 2
                    cfg.trials = ind_vo;
                case 3
                    cfg.trials = ind_av;
            end
            
            
            
            SDF = ft_spikedensity(cfg,spike);
            
            cfg2 = [];
            cfg2.spikechannel = spike.label{iClus};
            cfg2.trials = cfg.trials;
            cfg2.plotselection   =  'yes';
            cfg2.topplotfunc      = 'line';
            
            subplot(1,3,iPlot)
            
            ft_spike_plot_raster(cfg2, spike, SDF)
        end
        
    end
    
end

%% PPC

nClus = length(spike.label);

for iClus =1:nClus
    
    for iStim = 1:4
        
        h = figure;
        hold on
        
        ind_1st = trials.first(spike.trialinfo(trials.first) == iStim);
        ind_std = trials.std(spike.trialinfo(trials.std) == iStim);
        ind_av = trials.av_mm(spike.trialinfo(trials.av_mm) == iStim);
        ind_vo = trials.vis_mm(spike.trialinfo(trials.vis_mm) == iStim);
        ind_ao = trials.aud_mm(spike.trialinfo(trials.aud_mm) == iStim);
        
        for iPlot = 1:5
            
            cfg = [] ;
            switch iPlot
                case 1
                    cfg.trials = ind_1st;
                case 2
                    cfg.trials = ind_std;
                case 3
                    cfg.trials = ind_ao;
                case 4
                    cfg.trials = ind_vo;
                case 5
                    cfg.trials = ind_av;
            end
            
            
            sel_data = ft_selectdata(cfg,data);
            
            cfg.channel = {['clus' num2str(iClus)]};
            sel_spike = ft_selectdata(cfg,spike);
            
            sel_data.cfg.previous.trl = sel_data.cfg.previous.trl(cfg.trials,:);
            
            dat = ft_appendspike(cfg,sel_data,sel_spike);
            
            cfg = [];
            cfg.method = 'linear';
            cfg.timwin = [-0.005 0.005];
            cfg.interptoi = 0.05;
            cfg.spikechannel = sel_spike.label(1);
            cfg.channel = sel_data.label(1);
            
            dat = ft_spiketriggeredinterpolation(cfg,dat);
            
            cfg = load_cfg('sts_ppc');
            cfg.channel = sel_data.label(1);
            cfg.spikechannel = sel_spike.label(1);
            sts     = ft_spiketriggeredspectrum(cfg, dat);
            
            cfg = [];
            cfg.method = 'ppc1';
            cfg.spikechannel = 'clus2';
            cfg.avgoverchan = 'no';
            statSts = ft_spiketriggeredspectrum_stat(cfg, sts);
            
            switch iPlot
                case 1
                    plot_color = 'g';
                case 2
                    plot_color = 'b';
                case 3
                    plot_color = 'm';
                case 4
                    plot_color = 'k';
                case 5
                    plot_color = 'r';
            end
            plot(statSts.freq,statSts.ppc1,plot_color)
        end
        
    end
    
end
