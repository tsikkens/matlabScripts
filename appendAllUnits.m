resp_chans = [];
dataset = {'E:\Passive_MMN\PVCre116\Depth15_sort',...
    'F:\Passive_MMN\1.3\Sort',...
    'F:\Passive_MMN\1.4\Sort',...
    'F:\Passive_MMN\1.15\Sort',...
    'F:\Passive_MMN\1.16',...
    'F:\Passive_MMN\1.17\Sort'};
hdr_data = {'E:\Passive_MMN\PVCre116\Depth15_Full_MMN',...
    'F:\Passive_MMN\1.3\AV MMN Full Task',...
    'F:\Passive_MMN\1.4\AV MMN Full Task',...
    'F:\Passive_MMN\1.15\AV MMN Full Task',...
    'F:\Passive_MMN\1.16\AV MMN Full Task',...
    'F:\Passive_MMN\1.17\AV MMN Full Task'};

for iData = 1:length(dataset)
    
    for iChan =1:32;
        cfg.dataset = 'E:\Passive_MMN\PVCre116\Depth15_sort';
        cfg.hdr_data = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN';
        cfg.chan = iChan;
        log = cfg;
        
        spike = mmn_spike(cfg);
        
        
        if strcmp(spike,'err')
            fprintf('Channel %i was skipped\n', cfg.chan)
            continue
        end
        
        for iUnit = 1:length(spike.label)
            %skip excluded spikes
            if strcmp(spike.label{iUnit},'clus0')
                continue
            end
            
            cfg = [];
            cfg.spikechannel = spike.label(iUnit);
            tmp = ft_spike_select(cfg,spike);
            tmp.label = {['Animal' num2str(iData)  'Chan' num2str(log.chan) tmp.label{1}]};
            
            if ~isempty(spike.trial)
                if ~isempty(resp_chans)
                    resp_chans = ft_appendspike([],resp_chans,tmp);
                    clear tmp
                else
                    resp_chans = tmp;
                    clear tmp
                end
            end
        end
        clear log
    end
end

save 'C:\Users\T Sikkens\Documents\MATLAB\MMN Task\Spike analysis - in progress\AllUnits.mat' resp_chans -v7.3