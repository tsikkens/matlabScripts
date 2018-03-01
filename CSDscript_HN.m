cfg = [];
cfg.dataset = 'E:\Canon_MMN_passiveAwake\2018-02-20_11-04-13\AV MMN Full Task';
cfg.trialdef.offset = -0.5;
cfg = trialdef_mmn_sample(cfg);

trials = mmn_getTrials_STDvsDEV(cfg.trl(:,4));
trl = cfg.trl;
% 
% % cfg.trl = cfg.trl(trials.first,:);
cfg.trl = cfg.trl(trials.std,:);
% 
cfg.dftfilter = 'yes';
cfg.lpfilter = 'yes';
cfg.lpfreq = 200;
cfg.demean = 'yes';
cfg.baselinewindow = [-0.5 0];
% % cfg.standardize = 'yes';

% cfg.channel = {'CSC9','CSC8','CSC10','CSC7','CSC11','CSC6','CSC12','CSC5','CSC13','CSC4','CSC14','CSC3','CSC15','CSC2','CSC16','CSC1'};
% cfg.channel = channels;
% cfg.channel = {'CSC41','CSC40','CSC42','CSC39','CSC43','CSC38','CSC44','CSC37','CSC45','CSC36','CSC46','CSC35','CSC47','CSC34','CSC48','CSC33'};
 cfg.channel = {'CSC11', 'CSC6', 'CSC4', 'CSC12', 'CSC9', 'CSC8', 'CSC2', 'CSC10', 'CSC7', 'CSC15', 'CSC1', 'CSC16', 'CSC5', 'CSC13', 'CSC3', 'CSC14'};% 2nd shank revers
data = ft_preprocessing(cfg);

cfg2            = [];
cfg2.resamplefs = 1024;
data     = ft_resampledata(cfg2,data);

cfgtl=[];
% cfgtl.trials = find(datm.trialinfo == 2);
% cfgtl.trials= find(data.trialinfo == 2);
dat_CSD=ft_timelockanalysis(cfgtl,data);


%% % filter spatially: this is key
% 
lfptmp = [];
for iChan = 1:length(data.label)
   chan = find(strcmp(dat_CSD.label,cfg.channel{iChan}));
   lfptmp(iChan,:) = dat_CSD.avg(chan,:);
   
end

spat_filter = fspecial('gaussian',[3 5],1.1);

% filter spatially: is key to this
lfptmp = [lfptmp(1,:);lfptmp;lfptmp(end,:)];
lfp = conv2(lfptmp,spat_filter,'same');

% compute the CSD map
lfp_vaknin = [lfp(1,:);lfp;lfp(end,:)]; % vaknin transform
csd = -diff(lfp_vaknin,2,1);

% replace first and last channels of csd map with 0 to ensure same size as lfp
csd = [zeros(1,size(csd,2));csd(3:end-2,:);zeros(1,size(csd,2))]; 
lfp = lfp(2:end-1,:);


%% Interpolate values
%Interpolate values
chan_or=1:16;
chan_new = linspace(1,16,600);
Ma_or = csd;%dat_CSD.avg;
Ma_new = tointerpol2(Ma_or,chan_or,chan_new);

figure
imagesc(dat_CSD.time,chan_new,Ma_new)
xlabel('time (s)')
ylabel('depth of CSD channels')
title('CSD First Shank')

count = -10;
h = figure;
hold on
set(h,'position',[357 93 184 900])

for iChan = 1:16
    
%     index =  find(strcmp(dat_CSD.label, channels{iChan}));
    plot(dat_CSD.time,csd(iChan,:)+ count,'k');
    count = count -10;
end
