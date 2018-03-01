% channels = {'CSC9','CSC8','CSC10','CSC7','CSC11','CSC6','CSC12','CSC5','CSC13','CSC4','CSC14','CSC3','CSC15','CSC2','CSC16','CSC1'};
% channel = [11, 6,4 12 9 8 2 10 7 15 1 16 5 13  3 14];% 2nd shank revers
channel = [5 4 6 3 7 2 8 1];
channel = channel + 16;
for iChan = 1:numel(channel)
channels(iChan) = {['CSC' num2str(channel(iChan))]};
end

cfg = [];
cfg.dataset = 'C:\Users\T Sikkens\Documents\MATLAB\MMN Task\FerData\mmn_passive\AV_Full_Task\Fer0906\2017-03-18_15-03-37';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);


cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.demean = 'yes';
cfg.standardize = 'yes';

trials = mmn_getTrials_STDvsDEV(cfg.trl(:,4));

figure, hold on

for iChan = 1:8
    
    
    cfg.channel = channels{iChan};
    data = ft_preprocessing(cfg);
    
    
    
    
    %% Create ERP and plot for all std
    cfgERP = [];
    cfgERP.trials = trials.std;
    ERP = ft_timelockanalysis(cfgERP,data);
    
    % subplot(2,1,1)
    % hold on
    plot(ERP.time, ERP.avg-iChan, 'b')
    
    
    %% Create ERP and plot for all auditory mismatch
    
    cfgERP = [];
    cfgERP.trials = trials.aud_mm;
    ERP = ft_timelockanalysis(cfgERP,data);
    
    
    plot(ERP.time, ERP.avg-iChan,'m')
    
    %% Create ERP and plot for all visual mismatch
    figure
    
    cfgERP = [];
    cfgERP.trials = trials.vis_mm;
    ERP = ft_timelockanalysis(cfgERP,data);
    
    
    plot(ERP.time, ERP.avg-iChan,'k')
    
    %% Create ERP and plot for all full mismatch
    
    cfgERP = [];
    cfgERP.trials = trials.av_mm;
    ERP = ft_timelockanalysis(cfgERP,data);
    
    
    plot(ERP.time, ERP.avg-iChan,'r')
    

end
    %% Add Labels for top-plot
    legend('Standard','Aud. Mismatch','Vis. Mismatch','AV Mismatch')
    xlabel('Time (s)')
    ylabel('ERP (mV)')
%     title(['Channel ' data.label{1}])
    
    
    xlim([-0.5 1])
   
plot([0 0],ylim,'k--')
