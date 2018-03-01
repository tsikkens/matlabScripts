%% Add paths
% 
 addpath 'C:\Users\T Sikkens\Documents\MATLAB\fieldtrip-20160222';
% addpath(genpath('/home/lklaver1/scripts'));
addpath 'C:\Users\T Sikkens\Documents\MATLAB';
ft_defaults
%%

animalIDs = {'\1.31\'};

for iAnimal = 1:length(animalIDs)
    
    %% config

    % General settings for saving plots

    
    animalID = animalIDs{iAnimal};
    output.plotFolder = 'C:\Users\T Sikkens\Documents\MATLAB\MMN Task\pics';
    
    %General settings for loading data
    
    input.dataFolder = 'E:\Passive_MMN';
    input.taskType = 'Visual Only MMN';
    input.F = fullfile(input.dataFolder,animalID,input.taskType);
    
    try
        load([input.dataFolder '\artefact.mat'],'art')
    catch
        warning('No Artefact info available')
        art = [];
    end
    
    % Data Settings
    
    cfg = [];
    cfg.dataset = 'E:\Passive_MMN\PVCre116\Depth15_Full_MMN\';%;input.F;
    cfg.trialdef.offset = -0.5;
    cfg = trialdef_mmn_sample(cfg);
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 30;
    cfg.lpfiltord = 2;
     cfg.demean = 'yes';
%      cfg.detrend = 'yes';
    cfg.baselinewindow = [-0.5 0];
    
    [~,artind] = intersect(cfg.trl(:,1),art(:,1));
    cfg.trl(artind,:) = [];
    
    trials = mmn_getTrials_STDvsDEV(cfg.trl(:,4));
    
    
    
    %% ERP STDvsDEV
    
    %Settings for saving plots
    output.fileName = 'ERP_STvsFullMM_Channel_';
    output.plottype = 'ERP';
    
    output.F = fullfile(output.plotFolder,animalID,output.plottype);
    if ~exist(output.F,'dir')
        mkdir(fullfile(output.plotFolder),fullfile(animalID,output.plottype))
        mkdir(output.F,'pdf')
        mkdir(output.F,'fig')
    end
    
    %Main script
    
    for iChan =1:64;
        
        cfg.channel = ['CSC' num2str(iChan)];
        data = ft_preprocessing(cfg);
        
        h = mmn_plotERP_STDvsDEV(data,trials);
        
        saveas(h,[output.F '\fig\' output.fileName  num2str(iChan) '.fig'])
        saveas(h,[output.F '\pdf\' output.fileName  num2str(iChan) '.pdf'])
        close
        
    end
    
     %% ERP First vs Last
    
    %Settings for saving plots
    output.fileName = 'ERP_FirstVsLast_Channel_';
    output.plottype = 'ERP';
    
    output.F = fullfile(output.plotFolder,animalID,output.plottype);
    if ~exist(output.F,'dir')
        mkdir(fullfile(output.plotFolder),fullfile(animalID,output.plottype))
        mkdir(output.F,'pdf')
        mkdir(output.F,'fig')
    end
    
    %Main script
    
    for iChan =1:64;
        
        cfg.channel = ['CSC' num2str(iChan)];
        data = ft_preprocessing(cfg);
        
        h = mmn_plotERP_FirstVsLast(data,trials);
        
        saveas(h,[output.F '\fig\' output.fileName  num2str(iChan) '.fig'])
        saveas(h,[output.F '\pdf\' output.fileName  num2str(iChan) '.pdf'])
        close
        
    end
    
end
