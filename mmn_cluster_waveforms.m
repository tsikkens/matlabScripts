clusCount = 0;

for iChan = 1:32%1:length(clustersToKeep)
    sp_ind = [];
    sp_mean =  [];
    for iClus = clustersToKeep{iChan}
       clusCount = clusCount+1;
       cluster(clusCount,:) = [iChan, iClus];
       sp_ind = find(spikes_clusters{iChan} == iClus);
       sp_mean = mean(spikes_waveforms{iChan}(sp_ind,:));
    end        [iw(clusCount),ahp(clusCount),pr(clusCount),ppd(clusCount),slope(clusCount),had(clusCount)]=waveforms_features(sp_mean,[],32000);

end

%%
K =2;
% X = [iw; ppd;had;ahp;pr;slope]'% ahp pr ppd slope had]
X = [iw; ahp; pr; ppd; slope; had]';
%Extracted features are Initial Width (iw) and AfterHyperPolarization
%(ahp), following [Bruno & Simons 2002] in us
%Also, following [Niell & Stryker 2008], we extract peak ratio (pr), peak-to-peak delay in ms (ppd)
%and slope 500 ms after the first peak (slope)
%Moreover, we extract half-amplitude duration (had), following [Buzsaki 2004]


[IDX] = kmeans(X, K);
 figure

for i=1:K
    app =find(IDX ==i);
   
    colors = 'brg';
  
    subplot(4,4,1)
    hold on
    plot(X(app,1),X(app,2),[colors(i),'.']);
    title('1 vs 2')
    subplot(4,4,2)
    hold on
    plot(X(app,1),X(app,3),[colors(i),'.']);
    title('1 vs 3')
    subplot(4,4,3)
    hold on
    plot(X(app,1),X(app,4),[colors(i),'.']);
    title('1 vs 4')
    subplot(4,4,4)
    hold on
    plot(X(app,1),X(app,5),[colors(i),'.']);
    title('1 vs 5')
    subplot(4,4,5)
    hold on
    plot(X(app,1),X(app,6),[colors(i),'.']);
    title('1 vs 6')
    subplot(4,4,6)
    hold on
    plot(X(app,2),X(app,1),[colors(i),'.']);
    title('2 vs 1')
    subplot(4,4,7)
    hold on
    plot(X(app,2),X(app,3),[colors(i),'.']);
    title('2 vs 3')
    subplot(4,4,8)
    hold on
    plot(X(app,2),X(app,4),[colors(i),'.']);
    title('2 vs 4')
    subplot(4,4,9)
    hold on
    plot(X(app,2),X(app,5),[colors(i),'.']);
    title('2 vs 5')
    subplot(4,4,10)
    hold on
    plot(X(app,2),X(app,6),[colors(i),'.']);
    title('2 vs 6')
    subplot(4,4,11)
    hold on
    plot(X(app,3),X(app,1),[colors(i),'.']);
    title('3 vs 1')
    subplot(4,4,12)
    hold on
    plot(X(app,3),X(app,2),[colors(i),'.']);
    title('3 vs 2')
     subplot(4,4,13)
     hold on
    plot(X(app,3),X(app,4),[colors(i),'.']);
    title('3 vs 4')
     subplot(4,4,14)
     hold on
    plot(X(app,3),X(app,5),[colors(i),'.']);
    title('3 vs 5')
     subplot(4,4,15)
     hold on
    plot(X(app,3),X(app,6),[colors(i),'.']);
       title('3 vs 6')
end

%%

clusCount = 0;
plotcolor = 'brg';
figure, hold on
for iChan = 1:length(clustersToKeep)
    sp_ind = [];
    sp_mean =  [];
    for iClus = clustersToKeep{iChan}
       clusCount = clusCount+1;
       sp_ind = find(spikes_clusters{iChan} == iClus);
       sp_mean = mean(spikes_waveforms{iChan}(sp_ind,:));
       plot(1:64, sp_mean, plotcolor(IDX(clusCount)))
    end
end
 
%% PART 2
clusCount = 0;

for iChan = 1:32
    try
    load(['CSC' num2str(iChan) '_file.mat'],'spike','vis_responsive') 
    catch
        try
          load(['CSC' num2str(iChan) '_file2.mat'],'spike','vis_responsive')   
        catch 
            continue
        end
    end
    for iClus = 1:length(spike.label)
       clusCount = clusCount+1;
       cluster(clusCount,:) = [iChan, iClus];
       resp(clusCount) = vis_responsive(iClus);
       sp_mean(clusCount,1:64) = mean(squeeze(spike.waveform{iClus}),2);
        [iw(clusCount),ahp(clusCount),pr(clusCount),ppd(clusCount),slope(clusCount),had(clusCount)]=waveforms_features(sp_mean(clusCount,:),[],32000);
    end
end

%%
K =2;
% X = [iw; ppd;had;ahp;pr;slope]'% ahp pr ppd slope had]
X = [iw; ahp; pr; ppd; slope; had]';
%Extracted features are Initial Width (iw) and AfterHyperPolarization
%(ahp), following [Bruno & Simons 2002] in us
%Also, following [Niell & Stryker 2008], we extract peak ratio (pr), peak-to-peak delay in ms (ppd)
%and slope 500 ms after the first peak (slope)
%Moreover, we extract half-amplitude duration (had), following [Buzsaki 2004]


[IDX] = kmeans(X, K);
 figure

for i=1:K
    app =find(IDX ==i);
   
    colors = 'brg';
  
    subplot(4,4,1)
    hold on
    plot(X(app,1),X(app,2),[colors(i),'.']);
    title('1 vs 2')
    subplot(4,4,2)
    hold on
    plot(X(app,1),X(app,3),[colors(i),'.']);
    title('1 vs 3')
    subplot(4,4,3)
    hold on
    plot(X(app,1),X(app,4),[colors(i),'.']);
    title('1 vs 4')
    subplot(4,4,4)
    hold on
    plot(X(app,1),X(app,5),[colors(i),'.']);
    title('1 vs 5')
    subplot(4,4,5)
    hold on
    plot(X(app,1),X(app,6),[colors(i),'.']);
    title('1 vs 6')
    subplot(4,4,6)
    hold on
    plot(X(app,2),X(app,1),[colors(i),'.']);
    title('2 vs 1')
    subplot(4,4,7)
    hold on
    plot(X(app,2),X(app,3),[colors(i),'.']);
    title('2 vs 3')
    subplot(4,4,8)
    hold on
    plot(X(app,2),X(app,4),[colors(i),'.']);
    title('2 vs 4')
    subplot(4,4,9)
    hold on
    plot(X(app,2),X(app,5),[colors(i),'.']);
    title('2 vs 5')
    subplot(4,4,10)
    hold on
    plot(X(app,2),X(app,6),[colors(i),'.']);
    title('2 vs 6')
    subplot(4,4,11)
    hold on
    plot(X(app,3),X(app,1),[colors(i),'.']);
    title('3 vs 1')
    subplot(4,4,12)
    hold on
    plot(X(app,3),X(app,2),[colors(i),'.']);
    title('3 vs 2')
     subplot(4,4,13)
     hold on
    plot(X(app,3),X(app,4),[colors(i),'.']);
    title('3 vs 4')
     subplot(4,4,14)
     hold on
    plot(X(app,3),X(app,5),[colors(i),'.']);
    title('3 vs 5')
     subplot(4,4,15)
     hold on
    plot(X(app,3),X(app,6),[colors(i),'.']);
       title('3 vs 6')
end

%%
plotcolor = 'brg';
figure
hold on
    for iClus = 1:2
        ind = find(IDX == iClus);
       plot(1:64, mean(sp_mean(ind,:)), plotcolor(iClus))
    end

 
