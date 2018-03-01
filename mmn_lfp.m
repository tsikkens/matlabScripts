% MMN mouse LFP analysis


%% First vs Last ERP



iChan = 21;

cfg.dataset = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);
cfg.channel = ['CSC1'];
cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.lpfiltord = 2;
cfg.bpfilter = 'no';
cfg.detrend = 'yes';
cfg.demean = 'yes';
cfg.baselinewindow = [-0.5 0];
data = ft_preprocessing(cfg);


fst = [];
Lst = [];

for iStim = 1:4
    
    h = figure;
    
    x = find(data.trialinfo == iStim);
    c = diff(x);
    ind_Std = x(c <= 3);
    
    f = find(diff(ind_Std) == 2);
    f2 = f+1;
    
    ind_1st_std = [ind_Std(1); ind_Std(f2)];
    ind_lst_std = [ind_Std(f); ind_Std(end)+1];
    
    fst = [fst; ind_1st_std];
    Lst = [Lst; ind_lst_std];
end
    
    
    cfg = [];
    cfg.trials = ind_1st_std;
    freq_Std = ft_timelockanalysis(cfg,data);
    
    cfg = [];
    cfg.trials = ind_lst_std;
    TL_Std2 = ft_timelockanalysis(cfg,data);
    
    
    plot(freq_Std.time, freq_Std.avg,'b')
    hold on
    plot(TL_Std2.time, TL_Std2.avg,'r')
    title(['ERP Channel '  num2str(iChan) ' Stim ' num2str(iStim)])
    
    saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\PVCre116\15 SDF split\1stvslst_Channel_' num2str(iChan) 'Stim_' num2str(iStim) '.fig'])
end



%% Standard vs Deviant ERP

for iChan =2:64; %[10 15 8 16 12 13 6 14 17 18]
    
    
    cfg.dataset = 'E:\Canon_MMN_passiveAwake\2018-02-20_11-04-13\AV MMN Full Task';
    cfg.trialdef.offset = -0.5;
    cfg = trialdef_mmn_sample(cfg);
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 30;
    cfg.lpfiltord = 2;
    cfg.demean = 'yes';
    cfg.detrend = 'yes';
    cfg.baselinewindow = [-0.5 0];
    cfg.trl(end,:) = [];
    
    trials = mmn_getTrials_STDvsDEV(cfg.trl(:,4)); 
    
    cfg.channel = ['CSC' num2str(iChan)];
    
    data = ft_preprocessing(cfg);
    %
    h = figure;
   
   
    % plot all std
    cfg = [];
%     cfg.trials = trials.std;
    cfg.trials = trials.std;
    freq_Std = ft_timelockanalysis(cfg,data);
    
    subplot(2,1,1)
    hold on
    plot(freq_Std.time, freq_Std.avg, 'b')
    %     title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Standard'])
    %
    
    norm = freq_Std.avg;
    %     plot all auditory mismatch
    
    cfg = [];
    cfg.trials = trials.aud_mm;
    freq_Std = ft_timelockanalysis(cfg,data);
    
    %     subplot(2,2,2)
    plot(freq_Std.time, freq_Std.avg,'m')
    %     title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Aud MM'])
    %
    %     plot all visual mismatch
    
    cfg = [];
    cfg.trials = trials.vis_mm;
    freq_Std = ft_timelockanalysis(cfg,data);
    
    
    plot(freq_Std.time, freq_Std.avg,'k')
    %     title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Vis MM'])
    
    %     plot all full mismatch
    
    cfg = [];
    cfg.trials = [trials.av_mm];
    
    freq_Std = ft_timelockanalysis(cfg,data);
%     
%     %
%     %     subplot(2,2,4)
    plot(freq_Std.time, freq_Std.avg,'r')
%     
    
    subplot(2,1,2)
    plot(freq_Std.time,freq_Std.avg - norm,'g')
%     title(['SDF Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Full MM'])
    
        saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.51\ERP\fig\ERP_STvsFullMM_Channel_' num2str(iChan) '.fig'])
        saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.51\ERP\pdf\ERP_STvsFullMM_Channel_' num2str(iChan) '.pdf'])
        close
end




%% First vs Last TFA

cfg.dataset = 'G:\Passive_MMN\PVCre116\Depth15_Full_MMN';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);
cfg.channel = 'CSC29';
cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.bpfilter = 'no';
cfg.detrend = 'yes';
cfg.demean = 'yes';

trials = mmn_getTrials_STDvsDEV(cfg.trl(:,4)); 
data = ft_preprocessing(cfg);


for iStim = 1:4
    
    h = figure;
    
    x = find(data.trialinfo == iStim);
    c = diff(x);
    ind_Std = x(c <= 3);
    
    f = find(diff(ind_Std) == 2);
    f2 = f+1;
    
    ind_1st_std = [ind_Std(1); ind_Std(f2)];
    ind_lst_std = [ind_Std(f); ind_Std(end)+1];
    
    
    cfg = [];
    cfg.method = 'mtmconvol';
    cfg.output = 'fourier';
    cfg.foi = [0:5:200];
    cfg.taper = 'dpss';
    cfg.tapsmofrq = 10;
    cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
    cfg.toi = [-0.5:0.005:1];
    %cfg.keeptapers = 'yes';
    cfg.keeptrials = 'yes';
    cfg.trials = ind_1st_std;
    freq_Std = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    freq_Std= ft_freqdescriptives(cfg,freq_Std);
    
    
    cfg = [];
    cfg.baseline = [-0.5 -0.1];
    cfg.baselinetype = 'relchange';
    
    freq_Std = ft_freqbaseline(cfg ,freq_Std);
    
    subplot(2,1,1)
    imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
    axis xy
    
    
    cfg = [];
    cfg.method = 'mtmconvol';
    cfg.output = 'fourier';
    cfg.foi = [0:5:200];
    cfg.taper = 'dpss';
    cfg.tapsmofrq = 10;
    cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
    cfg.toi = [-0.5:0.005:1];
    %cfg.keeptapers = 'yes';
    cfg.keeptrials = 'yes';
    cfg.trials = ind_lst_std;
    freq_Std = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    freq_Std= ft_freqdescriptives(cfg,freq_Std);
    
    
    cfg = [];
    cfg.baseline = [-0.5 -0.1];
    cfg.baselinetype = 'relchange';
    
    freq_Std = ft_freqbaseline(cfg ,freq_Std);
    
    
    subplot(2,1,2)
    imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
    axis xy
    % title(['ERP Channel '  num2str(iChan) 'clus ' num2str(iClus) 'Stim ' num2str(iStim)])
    
    
end

% saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\15 SDF split\1stvslst_Channel_' num2str(iChan) 'clus_' num2str(iClus) '.fig'])

%% Standard vs Deviant TFA

for iChan = 1:64
    
    cfg.dataset = 'E:\Canon_MMN_passiveAwake\2018-02-20_11-04-13\AV MMN Full Task';
    cfg.trialdef.offset = -0.5;
    cfg = trialdef_mmn_sample(cfg);
     cfg.trl(end,:) = [];
    cfg.channel = ['CSC' num2str(iChan)];
    cfg.dftfilter = 'yes';
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 200;
    cfg.bpfilter = 'no';
    cfg.detrend = 'yes';
    cfg.demean = 'yes';
    
    trials = mmn_getTrials_STDvsDEV(cfg.trl(:,4)); 
   
    data = ft_preprocessing(cfg);
    
    h = figure;

    % plot all std
    
    cfg = [];
    cfg.trials = trials.std;
    cfg.method = 'mtmconvol';
    cfg.output = 'fourier';
    cfg.foi = [20:0.5:80];
    cfg.taper = 'hanning';
    %cfg.tapsmofrq = 10;
    cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
    cfg.toi = [-0.5:0.005:1];
    %cfg.keeptapers = 'yes';
    cfg.keeptrials = 'yes';
    freq_Std = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    freq_Std= ft_freqdescriptives(cfg,freq_Std);
    
    
    cfg = [];
    cfg.baseline = [-0.5 -0.1];
    cfg.baselinetype = 'relchange';
    
    freq_Std = ft_freqbaseline(cfg ,freq_Std);
    
    subplot(2,2,1)
    imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
    axis xy
    colorbar
    
    title('Standard')
    
    % plot all auditory mismatch
    
    cfg = [];
    cfg.trials = trials.aud_mm;
    cfg.method = 'mtmconvol';
    cfg.output = 'fourier';
    cfg.foi = [20:0.5:80];
    cfg.taper = 'hanning';
    %cfg.tapsmofrq = 10;
    cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
    cfg.toi = [-0.5:0.005:1];
    %cfg.keeptapers = 'yes';
    cfg.keeptrials = 'yes';freq_Std = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    freq_Std= ft_freqdescriptives(cfg,freq_Std);
    
    
    cfg = [];
    cfg.baseline = [-0.5 -0.1];
    cfg.baselinetype = 'relchange';
    
    freq_Std = ft_freqbaseline(cfg ,freq_Std);
    
    subplot(2,2,2)
    imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
    axis xy
    colorbar
    title('Aud MM')
    
    % plot all visual mismatch
    
    cfg = [];
    cfg.trials = trials.vis_mm;
    cfg.method = 'mtmconvol';
    cfg.output = 'fourier';
    cfg.foi = [20:0.5:80];
    cfg.taper = 'hanning';
    %cfg.tapsmofrq = 10;
    cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
    cfg.toi = [-0.5:0.005:1];
    %cfg.keeptapers = 'yes';
    cfg.keeptrials = 'yes';freq_Std = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    freq_Std= ft_freqdescriptives(cfg,freq_Std);
    
    
    cfg = [];
    cfg.baseline = [-0.5 -0.1];
    cfg.baselinetype = 'relchange';
    
    freq_Std = ft_freqbaseline(cfg ,freq_Std);
    
    subplot(2,2,3)
    imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
    axis xy
    colorbar
    title('Vis MM')
    
    % plot all full mismatch
    
    cfg = [];
    cfg.trials = trials.av_mm;
    cfg.method = 'mtmconvol';
    cfg.output = 'fourier';
    cfg.foi = [20:0.5:80];
    cfg.taper = 'hanning';
    %cfg.tapsmofrq = 10;
    cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
    cfg.toi = [-0.5:0.005:1];
    %cfg.keeptapers = 'yes';
    cfg.keeptrials = 'yes';
    freq_Std = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    freq_Std= ft_freqdescriptives(cfg,freq_Std);
    
    
    cfg = [];
    cfg.baseline = [-0.5 -0.1];
    cfg.baselinetype = 'relchange';
    
    freq_Std = ft_freqbaseline(cfg ,freq_Std);
    
    subplot(2,2,4)
    imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
    axis xy
    colorbar
    title('Full MM')
    
    saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.51\TFA\fig\Split_cond_Channel_' num2str(iChan) '.fig'])
    saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.51\TFA\pdf\Split_cond_Channel_' num2str(iChan) '.pdf'])
    close
    
    
end

%% TFA (gamma-band) per stimulus

for iChan = 1:64
    
    cfg.dataset = 'G:\Passive_MMN\PVCre116\Depth15_Many_Standards';
    cfg.trialdef.offset = -0.5;
    cfg = trialdef_mmn_sample(cfg);
    cfg.channel = ['CSC' num2str(iChan)];
    cfg.dftfilter = 'yes';
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 200;
    cfg.bpfilter = 'no';
    cfg.detrend = 'yes';
    cfg.demean = 'yes';
    data = ft_preprocessing(cfg);
    
    
    for iStim = 1:4
        
        h = figure;
        
        ind = find(data.trialinfo == iStim);
        
        cfg = [];
        cfg.method = 'mtmconvol';
        cfg.output = 'fourier';
        cfg.foi = [20:0.5:80];
        cfg.taper = 'hanning';
        %cfg.tapsmofrq = 10;
        cfg.t_ftimwin = 0.2*ones(1,length(cfg.foi));
        cfg.toi = [-0.5:0.005:1];
        %cfg.keeptapers = 'yes';
        cfg.keeptrials = 'yes';
        cfg.trials = ind;
        freq_Std = ft_freqanalysis(cfg,data);
        
        cfg = [];
        cfg.jackknife = 'yes';
        freq_Std= ft_freqdescriptives(cfg,freq_Std);
        
        
        cfg = [];
        cfg.baseline = [-0.5 -0.1];
        cfg.baselinetype = 'relchange';
        
        freq_Std = ft_freqbaseline(cfg ,freq_Std);
        
        subplot(2,2,iStim)
        imagesc(freq_Std.time, freq_Std.freq, squeeze(freq_Std.powspctrm))
        axis xy
        
        title(['Stim ' num2str(iStim)])
        
    end
    
    saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\PVCre116\TFA split\fig\Per_Stim_Channel_' num2str(iChan) '.fig'])
    saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\PVCre116\TFA split\pdf\Per_stim_Channel_' num2str(iChan) '.pdf'])
    close
    
end


