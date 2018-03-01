% MMN mouse analysis

for iChan = 29
    
    cfg.dataset = 'F:\';
    cfg.hdr_data = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN';
    cfg.chan = iChan;
    
    spike = mmn_spike(cfg);
    
    if strcmp(spike,'err')
        continue
    end
    
    %%
    nClus = length(spike.label);
    
    for iClus = 1
        
               
        for iStim = 4
            
             h = figure;
            
            x = find(spike.trialinfo == iStim);
            c = diff(x);
            ind_Std = x(c <= 3);
            ind_Dev = x(c > 3);
            
            
            for iDev = 1
                if iDev == iStim
                    continue
                end
                
                
                a = spike.trialinfo(ind_Dev-1);
                f = find( a == iDev);
                ind = ind_Dev(f);
                
                cfg = [];
                cfg.timwin = [-0.025 0.025];
                cfg.outputunit = 'rate';
                cfg.winfunc = 'gauss';
                cfg.spikechannel = spike.label{iClus};
                cfg.trials = ind;
                SDF_Dev = ft_spikedensity(cfg,spike);
                
                cfg = [];
                cfg.spikechannel = spike.label{iClus};
                cfg.trials = ind;
                cfg.plotselection   =  'yes';
                cfg.topplotfunc      = 'line';
                
                subplot(2,2,iDev)
                ft_spike_plot_raster(cfg, spike, SDF_Dev)
                title(['Stim is' num2str(iStim) 'Standard is ' num2str(iDev)])
                
            end
            
            ind_Std = ind_Std(spike.trialinfo(ind_Std(1:end)+1) ~= iStim);
            
            cfg = [];
            cfg.timwin = [-0.025 0.025];
            cfg.outputunit = 'rate';
            cfg.winfunc = 'gauss';
            cfg.spikechannel = spike.label{iClus};
            cfg.trials = ind_Std;
            SDF_Std = ft_spikedensity(cfg,spike);
            
            cfg = [];
            cfg.spikechannel = spike.label{iClus};
            cfg.trials = ind_Std;
            cfg.plotselection   =  'yes';
            cfg.topplotfunc      = 'line';
            
            subplot(2,2,iStim)
            ft_spike_plot_raster(cfg, spike, SDF_Std)
            title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Stim ' num2str(iStim)])
            
%             saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\15 SDF split\SDF_Channel_' num2str(iChan) 'clus_' num2str(iClus) 'Stim_' num2str(iStim)  '.pdf'])
%             close
            
        end
        
    end
end
