%%PowerSpectrum baseline vs response window

for iChan = 12
    
    cfg = [];
   cfg.dataset = 'E:\Passive_MMN\1.31\Audio Only Many Standards';
    cfg.trialdef.offset = -0.5;
    cfg = trialdef_mmn_sample(cfg);
    cfg.channel = ['CSC' num2str(iChan)];
    
    
    [trl_base, trl_resp] = mmn_split_trl(cfg.trl, cfg.hdr);
    clear c
    % LFP data
    cfg.dftfilter = 'yes';
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 200;
    cfg.demean = 'yes';
    cfg.standardize = 'yes';

    cfg.trl = trl_base;
    data_base = ft_preprocessing(cfg);
    
    cfg.trl = trl_resp;
    data_resp = ft_preprocessing(cfg);
    
    for iStim = [1:4]
        
        x = find(data_resp.trialinfo == iStim);
        c = 0;
        a = [];
        while c == 0;
            
            x(a) = [];
            cfg = load_cfg('freql');
%             cfg.trials = x;
            freql_base = ft_freqanalysis(cfg,data_base);
            freql_resp = ft_freqanalysis(cfg,data_resp);
            
            [a,~] = find(isnan(freql_base.fourierspctrm));
            [b,~] = find(isnan(freql_resp.fourierspctrm));
            a = unique([a; b]);
            if isempty(a)
                c = 1;
            end
            
        end
        
        
        cfg = [];
        cfg.jackknife = 'yes';
        
        freql_base = ft_freqdescriptives(cfg,freql_base);
        freql_resp = ft_freqdescriptives(cfg,freql_resp);
        
        
        h = figure;
        subplot(2,1,1)
        semilogy(freql_base.freq,freql_base.powspctrm,'k')
        hold on
        ciplot(freql_base.powspctrm - freql_base.powspctrmsem,freql_base.powspctrm + freql_base.powspctrmsem,freql_base.freq,[0.6 0.6 0.6])
        ciplot(freql_resp.powspctrm - freql_resp.powspctrmsem,freql_resp.powspctrm + freql_resp.powspctrmsem,freql_base.freq,[0.8 0.5 0.5])
        semilogy(freql_base.freq,freql_base.powspctrm,'k')
        semilogy(freql_resp.freq,freql_resp.powspctrm,'r')
        
        cfg = [];
        cfg.parameter = 'powspctrm';
        cfg.operation = 'divide';
        
        correction = ft_math(cfg,freql_resp,freql_base);
        
        subplot(2,1,2)
        plot(correction.freq, correction.powspctrm-1)
        
%         saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.25\pdf\freq_chan_' num2str(iChan) '_stim_' num2str(iStim)],'pdf')
%         saveas(h,['C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics\1.25\fig\freq_chan_' num2str(iChan) '_stim_' num2str(iStim)],'fig')
%         close all
    end
end


%% PPC
cfg = [];
cfg.dataset = 'G:\Passive_MMN\PVCre116\Depth15_Full_MMN';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);
cfg.channel = 'CSC29';


[trl_base, trl_resp] = split_trl(cfg.trl, cfg.hdr);

% LFP data
cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.demean = 'yes';
cfg.standardize = 'yes';


cfg.trl = trl_base;
data_base = ft_preprocessing(cfg);

cfg.trl = trl_resp;
data_resp = ft_preprocessing(cfg);
%
cfg = [];

cfg.dataset = 'F:\';
cfg.hdr_data = 'G:\Passive_MMN\PVCre116\Depth15_Full_MMN';
cfg.chan = 29;
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn(cfg);
[trl_base, trl_resp] = split_trl_spike(cfg.trl, cfg.hdr);

cfg.trl = trl_base;
cfg.hdr = data_base.hdr;
spike_base = mmn_spike(cfg);
cfg.trl = trl_resp;
spike_resp = mmn_spike(cfg);

data_base = ft_appendspike([],data_base,spike_base);
data_resp = ft_appendspike([],data_resp,spike_resp);

%Remove spike events from filtered LFP and do linear interpolation
cfg = [];
cfg.method = 'linear';
cfg.timwin = [-0.005 0.005];
cfg.interptoi = 0.05;
cfg.spikechannel = 'clus2';dat
cfg.channel = 'CSC29';

data_base = ft_spiketriggeredinterpolation(cfg,data_base);
data_resp = ft_spiketriggeredinterpolation(cfg,data_resp);


cfg = load_cfg('sts_ppc');
cfg.channel = data_base.label(1);
cfg.spikechannel = 'clus2';
sts_base     = ft_spiketriggeredspectrum(cfg, data);

sts_resp     = ft_spiketriggeredspectrum(cfg, data_resp);

cfg = [];
cfg.method = 'ppc1';
cfg.spikechannel = 'clus2';
cfg.avgoverchan = 'no';
statSts_base = ft_spiketriggeredspectrum_stat(cfg, sts_base);


statSts_resp = ft_spiketriggeredspectrum_stat(cfg, sts_resp);

%% TA

cfg = [];
cfg.dataset = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);
cfg.channel = 'CSC29';
cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.demean = 'yes';
cfg.standardize = 'yes';

data = ft_preprocessing(cfg);


%%

    
    cfg = load_cfg('tfa_high');
    freq = ft_freqanalysis(cfg,data);
    
    cfg = [];
    cfg.jackknife = 'yes';
    
    freq= ft_freqdescriptives(cfg,freq);
    
    cfg = [];
    cfg.baseline = [-0.5 0];
    cfg.baselinetype = 'relchange';
    
    freq = ft_freqbaseline(cfg, freq);
    
    figure
    imagesc(freq.time, freq.freq, squeeze(freq.powspctrm(1,:,:)))
    axis xy
    
    xlabel('Time (s)')
    ylabel('Freq (Hz)')

    





%% CSD Analysis %%%%
cfg = [];
cfg.dataset = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);
% cfg.channel = {'CSC21', 'CSC20', 'CSC22','CSC19' ,'CSC23','CSC18', 'CSC24', 'CSC17'};
% cfg.channel = {'CSC29', 'CSC28', 'CSC30','CSC27' ,'CSC31','CSC26', 'CSC32', 'CSC25'};
cfg.channel =  {'CSC61', 'CSC60', 'CSC62','CSC59' ,'CSC63','CSC58', 'CSC64', 'CSC57'};
cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.demean = 'yes';
cfg.standardize = 'yes';

data = ft_preprocessing(cfg);


cfg2            = [];
cfg2.resamplefs = 1024;
data     = ft_resampledata(cfg2,data);


Mohmvalues=[1,1,1,1,1,1,1,1]; % values from manufacture probe  calculate mean for all the  values of the shank 1 (NN05, NN04, NN06, NN03, NN07, NN02, NN08, NN01)
Conductivity= 1/(mean(Mohmvalues));   %0.77
N=8;  %number of electrodes
h=0.2;%inter-contact distance 200um
out= D1(N,h);%The matrix form of the standard double derivative formula, called D1 in Freeman and Nicholson (1975).
out_c = -1.*out.*Conductivity;
%montage structure
montage=[];
montage.tra      =  out_c;
montage.labelorg =  {'CSC61', 'CSC60', 'CSC62','CSC59' ,'CSC63','CSC58', 'CSC64', 'CSC57'}; %Nx1 cell-array with channel name in order in probe from most superficial to deepest
montage.labelnew =  {'CSD1', 'CSD2', 'CSD3', 'CSD4', 'CSD5', 'CSD6'} ;   %Mx1 cell-array


cfgm=[];
cfgm.montage = montage;
%cfgm.reref = 'yes'; %error: montage and reref are mutually exclusive
datm = ft_preprocessing(cfgm,data);
%
cfgtl=[];
cfgtl.trials= find(data.trialinfo == 2);
dat_CSD=ft_timelockanalysis(cfgtl,datm);

%Interpolate values
chan_or=1:6 ;
chan_new = linspace(1,6,600);
Ma_or = CSD_corrected.avg;
Ma_new = tointerpol2(Ma_or,chan_or,chan_new);

figure
imagesc(dat_CSD.time,chan_or,Ma_or)
xlabel('time (s)')
ylabel('depth of CSD channels')
title('CSD First Shank')
