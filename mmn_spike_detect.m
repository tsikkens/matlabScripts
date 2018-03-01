%% options

%TS Last edit 23-01-2018

datafolder = 'F:\Passive_MMN\'; %data source
% outputfolder = 'E:\Passive_MMN\';%folder to save matlabData.mat file to (creates new subfolder per session)
% 
sessions = hasmatlabData(datafolder,true);
sessions = isclustered(sessions,false);

channels = {'CSC1', 'CSC2' , 'CSC3', 'CSC4',  ...
    'CSC5', 'CSC6', 'CSC7', 'CSC8',    ...
    'CSC9', 'CSC10', 'CSC11', 'CSC12', ...
    'CSC13', 'CSC14', 'CSC15', 'CSC16',...
    'CSC17','CSC18','CSC19','CSC20',  ...
    'CSC21','CSC22','CSC23','CSC24',   ...
    'CSC25','CSC26','CSC27','CSC28',  ...
    'CSC29','CSC30','CSC31','CSC32'};  % probe 1
%     'CSC33', 'CSC34', 'CSC35', 'CSC36', ...
%     'CSC37', 'CSC38', 'CSC39', 'CSC40', ...
%     'CSC41', 'CSC42', 'CSC43', 'CSC44', ...
%     'CSC45', 'CSC46', 'CSC47', 'CSC48', ...
%     'CSC49', 'CSC50', 'CSC51', 'CSC52', ...
%     'CSC53', 'CSC54', 'CSC55', 'CSC56', ...
%     'CSC57', 'CSC58', 'CSC59', 'CSC60', ...
%     'CSC61', 'CSC62', 'CSC63', 'CSC64'}; % probe 2

nChunkSamp = 1024000; %Divide data into chunks of 'nChunkSamp' samples to avoid memory issues. Should be a multiple of 512 to avoid problems

chooseThresholds = 1;
doReref = 1;
doFiltering = 1;
freqLow = 300; %frequency for high-pass filtering
freqHigh = 6000; %frequency for low-pass filtering
filtOrd = 4; %order of butterworth filter used

nump=64; %Number of samples per waveform
prePoints = 22; %number of samples before spike peak



%% Threshold selection
tic
runtime = zeros(1,length(sessions));
nChannels = size(channels,2);
%Select all thresholds
if chooseThresholds
    for iSess = 1:length(sessions)
        thresholds = zeros(1,nChannels);
        outputf = sessions{iSess};
        cd(outputf)
        fullfilename = [outputf,'\matlabData.mat'];
        
        %Read in timestamps and Fs for entire session
        dataset = fullfile(sessions{iSess}, [channels{1,1} '.ncs']);
        [timeStamps, Fs] = Nlx2MatCSC(dataset,[1 0 1 0 0],0,1);
        
        Fs=Fs(1);
        
        app=(0:1E6/Fs:511E6/Fs)';
        app=repmat(app,1,length(timeStamps));
        timeStamps=repmat(timeStamps,512,1);
        timeStamps=timeStamps+app;
        timeStamps=reshape(timeStamps,1,size(timeStamps,1)*size(timeStamps,2));
        
        nSamples = size(timeStamps,2);
        
        
        %Divide session data into chunks of 'nChunkSamp' samples to avoid memory issues
        chunks = [1:nChunkSamp:nSamples,nSamples+1];
        
        %Preallocate all variables to be stored in matlabData.mat to avoid
        %extreme file sizes
        
        spikes_ts=cell(1,nChannels);
        spikes_waveforms=cell(1,nChannels);
        
        iChunk = 1;
        
        csc_ts = timeStamps(chunks(iChunk):chunks(iChunk+1)-1);
        csc_data = zeros(nChannels,size(csc_ts,2));
        
        for iChan = 1:nChannels;
            %Read in samples from current chunk
            datafile = fullfile(sessions{iSess}, [channels{1,iChan} '.ncs']);
            data=Nlx2MatCSC(datafile,[0 0 0 0 1],0,4,[timeStamps(chunks(iChunk)), timeStamps(chunks(iChunk+1)-1)]);
            data=reshape(data,1,size(data,1)*size(data,2));
            
            if doFiltering
                [B,A]=butter(filtOrd,[freqLow freqHigh]/(Fs/2));
                csc_data(iChan,:)=filtfilt(B,A,data);
            else
                csc_data(iChan,:) = data;
            end
            
        end
        
        if doReref
            data_mean = repmat(mean(csc_data),nChannels,1);
            csc_data = csc_data-data_mean;
        end
        
        
        for i=1:nChannels
            
            
            plot(csc_ts,csc_data(i,:));
            
            grid on;
            stringa=sprintf('Select threshold for channel %d',i);
            title(stringa,'FontSize',30);
            stringa=sprintf('Insert threshold for channel %d: ',i);
            options.Resize='on';
            options.WindowStyle='normal';
            thresholds(i)=str2double(cell2mat(inputdlg(stringa,'Threshold selection',1,{'600'},options)));
            close;
            
        end
        
        
        %Save data
        save(fullfilename,'thresholds','-v7.3')
    end
end

%% Main

for iSess = 1:length(sessions)
    tic
    %     outputf =fullfile(outputfolder, sessions{iSess});
    outputf = sessions{iSess};
    %     mkdir(outputf)
    cd(outputf)
    fullfilename = [outputf,'\matlabData.mat'];
    MatObj = matfile(fullfilename,'Writable',true);
    
    for iShank = 1%:size(channels,1)
        
        %Read in timestamps and Fs for entire session
        dataset = fullfile(sessions{iSess}, [channels{iShank,1} '.ncs']);
        [timeStamps, Fs] = Nlx2MatCSC(dataset,[1 0 1 0 0],0,1);
        
        Fs=Fs(1);
        
        app=(0:1E6/Fs:511E6/Fs)';
        app=repmat(app,1,length(timeStamps));
        timeStamps=repmat(timeStamps,512,1);
        timeStamps=timeStamps+app;
        timeStamps=reshape(timeStamps,1,size(timeStamps,1)*size(timeStamps,2));
        
        nSamples = size(timeStamps,2);
        nChannels = size(channels,2);
        
        %Divide session data into chunks of 'nChunkSamp' samples to avoid memory issues
        chunks = [1:nChunkSamp:nSamples,nSamples+1];
        
        %Preallocate all variables to be stored in matlabData.mat to avoid
        %extreme file sizes
        
        spikes_ts=cell(1,nChannels);
        spikes_waveforms=cell(1,nChannels);
        
        h = waitbar(0,'Running Spike Detection...');
        for iChunk = 1:length(chunks)-1
            
            
            waitbar(iChunk/(length(chunks)-1),h);
            
            csc_ts = timeStamps(chunks(iChunk):chunks(iChunk+1)-1);
            csc_data = zeros(nChannels,size(csc_ts,2));
            
            for iChan = 1:nChannels
                
                %Read in samples from current chunk
                datafile = fullfile(sessions{iSess}, [channels{iShank,iChan} '.ncs']);
                data=Nlx2MatCSC(datafile,[0 0 0 0 1],0,4,[timeStamps(chunks(iChunk)), timeStamps(chunks(iChunk+1)-1)]);
                data=reshape(data,1,size(data,1)*size(data,2));
                
                if doFiltering
                    [B,A]=butter(filtOrd,[freqLow freqHigh]/(Fs/2));
                    csc_data(iChan,:)=filtfilt(B,A,data);
                else
                    csc_data(iChan,:) = data;
                end
                
            end
            
            if doReref
                data_mean = repmat(mean(csc_data),nChannels,1);
                csc_data = csc_data-data_mean;
            end
            
            clear data data_mean
            
            
            %% Threshold selection
            
            if iChunk == 1
                try
                    load(fullfilename,'thresholds')
                catch
                    for iChan = 1:nChannels
                        thresholds(iChan) = mean(csc_data(iChan,:))+4*std(csc_data(iChan,:)) ;
                        save(fullfilename,'thresholds','-v7.3')
                    end
                end
            end
            
            
            %% Spike extraction
            
            
            for i=1:nChannels
                th=thresholds(i);
                if th>0
                    app=find(csc_data(i,:)>th);
                    app1=SplitVec(app,'consecutive');
                    %                     app=[];
                    app = nan(1,length(app1));
                    for j=1:length(app1)
                        [maxvalue, maxind]=max(csc_data(i,app1{j}));
                        app(j)=app1{j}(maxind);
                    end
                elseif th<0
                    app=find(csc_data(i,:)<th);
                    app1=SplitVec(app,'consecutive');
                    %                     app=[];
                    app = nan(1,length(app1));
                    for j=1:length(app1)
                        [minvalue, minind]=min(csc_data(i,app1{j}));
                        app(j)=app1{j}(minind);
                    end
                end
                %Check for spikes too close to the beginning or end of
                %chunk
                if ~isempty(app)
                    while app(1)<nump
                        app(1)=[];
                        if isempty(app)
                            break;
                        end
                    end
                    if ~isempty(app)
                        while (length(csc_ts)-app(end))<nump
                            app(end)=[];
                            if isempty(app)
                                break;
                            end
                        end
                    end
                end
                
                %                 for i=1:nChannels
                spikes_ts=csc_ts(app);
                appSpikes=zeros(length(app),nump);
                for j=1:length(app)
                    appSpikes(ej,:)=csc_data(i,app(j)-prePoints:app(j)+nump-prePoints-1);
                end
                spikes_waveforms=appSpikes;
                
                if iChunk == 1
                    MatObj.spikes_waveforms(1,i) = {appSpikes};
                    MatObj.spikes_ts(1,i) = {spikes_ts};
                else
                    tmp = cell2mat(MatObj.spikes_waveforms(1,i));
                    MatObj.spikes_waveforms(1,i) = {[tmp; appSpikes]};
                    tmp = cell2mat(MatObj.spikes_ts(1,i));
                    MatObj.spikes_ts(1,i) = {[tmp, spikes_ts]};
                    clear tmp
                end
                %                 end
                %
                
                %                                 for i=1:nChannels
                %                                     figure(i);
                %                                     app=spikes_waveforms{i};
                %                                     plot(mean(app));
                %                                     grid on;
                %                                     stringa=sprintf('Channel %d',i);
                %                                     title(stringa);
                %                                 end
                %                                 pause;
            end
            
        end
    end
    close(h)
    
    runtime(iSess) = toc;
    sprintf('Runtime for session: %s was %d seconds',sessions{iSess},runtime(iSess))
end

