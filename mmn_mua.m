function spike = mmn_mua(cfg)

chan = cfg.chan;
dat = cfg.dataset;
hdr_dat = cfg.hdr_data;

if ~isfield(cfg,'hdr')
    hdr = ft_read_header(hdr_dat);
else
    hdr = cfg.hdr;
end

% load spike file
matobj = matfile([dat '\matlabData.mat'],'Writable',false);

%create empty spike file & find number of clusters on channel
SpikeFile = [];
spikes_clusters = cell2mat(matobj.spikes_clusters(1,chan));
clus = unique(spikes_clusters);
clus(clus == 0) = [];
spikes_ts = cell2mat(matobj.spikes_ts(1,chan));
spikes_waveforms = cell2mat(matobj.spikes_waveforms(1,chan));

if ~isempty(clus)
    
    %create empty fields for each cluster
    SpikeFile.unit = cell(1,length(chan));
    SpikeFile.timestamp = cell(1,length(chan));
    SpikeFile.waveform = cell(1,length(chan));
    SpikeFile.label= cell(1,1);
    
    % fill fields with spike data
    for i = 1:length(clus)
               x = find(spikes_clusters == clus(i));
        SpikeFile.timestamp{1} = [SpikeFile.timestamp{1} spikes_ts(x)]; % spike times in timestamps
        %SpikeFile.timestamp{i} = SpikeFile.timestamp{i}.*hdr.TimeStampPerSample;% convert from samples to timestamps
        %SpikeFile.timestamp{i} = uint64(SpikeFile.timestamp{i})+hdr.FirstTimeStamp;% add first timestamp
        SpikeFile.waveform{1} = [ SpikeFile.waveform{1} spikes_waveforms(x,:)']; %add waveforms
        SpikeFile.unit{1} = [SpikeFile.unit{1} spikes_clusters(x)]; %add unit info
        eval(sprintf('SpikeFile.label{1} =''muaChan%d'';',chan)); %add label
    end
    
    SpikeFile.Fs = hdr.Fs;
    SpikeFile.hdr = hdr;
    
    if ~isfield(cfg,'trl')
        %if empty set offset to default
        if ~isfield(cfg,'trialdef.offset')
            cfg.trialdef.offset = -0.5;
        end
        
        %create trl matrix using trial def.
        cfg.dataset = hdr_dat;
        cfg.hdr = hdr;
        cfg = trialdef_mmn(cfg);
        
        if isempty(cfg.trl)
            fprintf('Could not create spike_file: trial_def error\n')
            spike = 'err';
            return
        end
        
    end
    
    a = cfg;
    
    cfg = [];
    cfg.trl = a.trl;
    %     cfg.hdr = hdr;
    cfg.timestampspersecond =  hdr.TimeStampPerSample * hdr.Fs;
    %create spike file, devided in trials.
    spike = ft_spike_maketrials(cfg,SpikeFile);
else
    spike = 'err';
end

end