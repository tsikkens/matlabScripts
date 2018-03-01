boxplot([stim1_dev(MMN_ind_stim4 > 0.5); stim4_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5)]')
%%
bar(mean([stim1_dev(MMN_ind_stim4 > 0.5); stim4_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5)]'))
%%
figure
boxplot([stim1_std(MMN_ind_stim4 > 0.5); stim4_std(MMN_ind_stim4 > 0.5);stim4_std(MMN_ind_stim4 > 0.5);stim4_std(MMN_ind_stim4 > 0.5)]')

%%
figure
boxplot([stim1_first(MMN_ind_stim4 > 0.5); stim4_first(MMN_ind_stim4 > 0.5);stim4_first(MMN_ind_stim4 > 0.5);stim4_first(MMN_ind_stim4 > 0.5)]')

%%
std_dev = std([stim1_dev(MMN_ind_stim4 > 0.5); stim2_dev(MMN_ind_stim4 > 0.5);stim3_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5)],[],2);
m_dev = mean([stim1_dev(MMN_ind_stim4 > 0.5); stim4_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5);stim4_dev(MMN_ind_stim4 > 0.5)],2);

std_std = std([stim1_std(MMN_ind_stim4 > 0.5); stim4_std(MMN_ind_stim4 > 0.5);stim4_std(MMN_ind_stim4 > 0.5);stim4_std(MMN_ind_stim4 > 0.5)],[],2);
m_std = mean(([stim1_std(MMN_ind_stim4 > 0.5); stim4_std(MMN_ind_stim4 > 0.5);stim4_std(MMN_ind_stim4 > 0.5);stim4_std(MMN_ind_stim4 > 0.5)]),2);

std_first = std([stim1_first(MMN_ind_stim4 > 0.5); stim4_first(MMN_ind_stim4 > 0.5);stim4_first(MMN_ind_stim4 > 0.5);stim4_first(MMN_ind_stim4 > 0.5)],[],2);
m_first = mean([stim1_first(MMN_ind_stim4 > 0.5); stim4_first(MMN_ind_stim4 > 0.5);stim4_first(MMN_ind_stim4 > 0.5);stim4_first(MMN_ind_stim4 > 0.5)],2);

%%
figure
scatter((stim4_dev),(stim4_first),'k')
hold on
plot([0 40],[0 40],'k--')
xlim([0 40])
ylim([0 40])
xlabel('Deviant')
ylabel('Control')
title('Deviance Detection')

figure
scatter((stim4_dev),(stim4_std),'k')
hold on
plot([0 40],[0 40],'k--')
xlabel('Deviant')
ylabel('Standard')
title('Mismatch Negativity')
xlim([0 40])
ylim([0 40])

figure
scatter((stim4_first),(stim4_std),'k')
hold on
plot([0 40],[0 40],'k--')
xlabel('Control')
ylabel('Standard')
title('SSA')
xlim([0 40])
ylim([0 40])

%%
hold on
scatter((stim4_dev(MMN_ind > 0.5)),(stim4_std(MMN_ind > 0.5)),'g')
%%
hold on
scatter((stim4_dev(MMN_ind > 0.5)),(stim4_first(MMN_ind > 0.5)),'g')
%%
hold on
scatter((stim4_first(MMN_ind > 0.5)),(stim4_std(MMN_ind)),'g')
%%
hold on
scatter((stim4_dev(MMN_ind_stim4 > 0.5 & MMN_ind_stim3 > 0.5 )),stim4_std(MMN_ind_stim4 > 0.5 & MMN_ind_stim3 > 0.5 ),'r')
%%
hold on
scatter((stim4_dev(MMN_ind_stim4 > 0.5 & MMN_ind_stim3 > 0.5 )),(stim4_first(MMN_ind_stim4 > 0.5 & MMN_ind_stim3 > 0.5 )),'r')
%%
hold on

scatter((stim4_first(MMN_ind_stim4 > 0.5 & MMN_ind_stim3 > 0.5 )),(stim4_std(MMN_ind_stim4 > 0.5 & MMN_ind_stim1 > 0.5 )),'r')

%%

figure