% MMN mouse analysis split conditions

figfolder = 'C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.25\fig';
pdffolder = 'C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.25\pdf';

for iChan =33:40
    
    cfg.dataset = 'F:\Passive_MMN\1.25\passive_task\Sort';
    cfg.hdr_data = 'F:\Passive_MMN\1.25\passive_task\05. 108844755030 To 113100337030';
    cfg.chan = iChan;
    
    spike = mmn_spike(cfg);
    
    if strcmp(spike,'err')
        continue
    end
    
    %
    nClus = length(spike.label);
    
    for iClus = 1:nClus
        
        h = figure;
        aud_mm = [];
        vis_mm = [];
        av_mm = [];
        std = [];
        
        for iStim = 1:4
            
            
            x = find(spike.trialinfo == iStim);
            c = diff(x);
            ind_Std = x(c <= 3);
            ind_Dev = x(c > 3);
            
            
            
            for iDev = 1:4
                if iDev == iStim
                    continue
                end
                
                a = spike.trialinfo(ind_Dev-1);
                f = find( a == iDev);
                ind = ind_Dev(f);
                
                switch iStim
                    case 1
                        switch iDev
                            case 2
                                aud_mm = [aud_mm; ind];
                            case 3
                                vis_mm = [vis_mm; ind];
                            case 4
                                av_mm = [av_mm; ind];
                        end
                    case 2
                        switch iDev
                            case 1
                                aud_mm = [aud_mm; ind];
                            case 3
                                av_mm = [av_mm; ind];
                            case 4
                                vis_mm = [vis_mm; ind];
                        end
                    case 3
                        switch iDev
                            case 1
                                vis_mm = [vis_mm; ind];
                            case 2
                                av_mm = [av_mm; ind];
                            case 4
                                aud_mm = [aud_mm; ind];
                        end
                    case 4
                        switch iDev
                            case 1
                                av_mm = [av_mm; ind];
                            case 2
                                vis_mm = [vis_mm; ind];
                            case 3
                                aud_mm = [aud_mm; ind];
                        end
                end
                
            end
            
            ind_Std = ind_Std(spike.trialinfo(ind_Std(1:end)+1) ~= iStim);
            std = [std; ind_Std];
            
        end
        % plot all std
        cfg = [];
        cfg.timwin = [-0.025 0.025];
        cfg.outputunit = 'rate';
        cfg.winfunc = 'gauss';
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = std;
        SDF_Std = ft_spikedensity(cfg,spike);
        
        cfg = [];
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = std;
        cfg.plotselection   =  'yes';
        cfg.topplotfunc      = 'line';
        
        subplot(2,2,1)
        ft_spike_plot_raster(cfg, spike, SDF_Std)
        title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Standard'])
        
        % plot all auditory mismatch
        
        cfg = [];
        cfg.timwin = [-0.025 0.025];
        cfg.outputunit = 'rate';
        cfg.winfunc = 'gauss';
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = aud_mm;
        SDF_Std = ft_spikedensity(cfg,spike);
        
        cfg = [];
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = aud_mm;
        cfg.plotselection   =  'yes';
        cfg.topplotfunc      = 'line';
        
        subplot(2,2,2)
        ft_spike_plot_raster(cfg, spike, SDF_Std)
        title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Aud MM'])
        
        % plot all visual mismatch
        
        cfg = [];
        cfg.timwin = [-0.025 0.025];
        cfg.outputunit = 'rate';
        cfg.winfunc = 'gauss';
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = vis_mm;
        SDF_Std = ft_spikedensity(cfg,spike);
        
        cfg = [];
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = vis_mm;
        cfg.plotselection   =  'yes';
        cfg.topplotfunc      = 'line';
        
        subplot(2,2,3)
        ft_spike_plot_raster(cfg, spike, SDF_Std)
        title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Vis MM'])
        
        % plot all full mismatch
        
        cfg = [];
        cfg.timwin = [-0.025 0.025];
        cfg.outputunit = 'rate';
        cfg.winfunc = 'gauss';
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = av_mm;
        SDF_Std = ft_spikedensity(cfg,spike);
        
        cfg = [];
        cfg.spikechannel = spike.label{iClus};
        cfg.trials = av_mm;
        cfg.plotselection   =  'yes';
        cfg.topplotfunc      = 'line';
        
        subplot(2,2,4)
        ft_spike_plot_raster(cfg, spike, SDF_Std)
        title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Full MM'])
        
        saveas(h,[figfolder '\Split_cond_Channel_' num2str(iChan) 'clus_' num2str(iClus) '.fig'])
        saveas(h,[pdffolder '\Split_cond_Channel_' num2str(iChan) 'clus_' num2str(iClus) '.pdf'])
        close
  
        
        
    end
end






