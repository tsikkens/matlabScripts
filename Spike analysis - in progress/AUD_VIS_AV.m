%%
selection = MMN_ind_stim1 > 0.5 &  MMN_ind_stim3 < 0.5 &  MMN_ind_stim4 < 0.5 &  MMN_ind_stim2 < 0.5 



std_dev = std([stim1_dev(selection); stim2_dev(selection);stim3_dev(selection);stim4_dev(selection)],[],2);
m_dev = mean([stim1_dev(selection); stim2_dev(selection);stim3_dev(selection);stim4_dev(selection)],2);

std_std = std([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)],[],2);
m_std = mean(([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)]),2);

std_first = std([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],[],2);
m_first = mean([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],2);

%%

selection =  MMN_ind_stim4_vis < 0.5 &  MMN_ind_stim4_aud < 0.5 

std_dev_av = std([stim1_dev_av(selection); stim2_dev_av(selection);stim3_dev_av(selection);stim4_dev_av(selection)],[],2);
m_dev_av = mean([stim1_dev_av(selection); stim2_dev_av(selection);stim3_dev_av(selection);stim4_dev_av(selection)],2);

std_std_av = std([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)],[],2);
m_std_av = mean(([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)]),2);

std_first_av = std([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],[],2);
m_first_av = mean([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],2);

%
%

std_dev_vis = std([stim1_dev_vis(selection); stim2_dev_vis(selection);stim3_dev_vis(selection);stim4_dev_vis(selection)],[],2);
m_dev_vis = mean([stim1_dev_vis(selection); stim2_dev_vis(selection);stim3_dev_vis(selection);stim4_dev_vis(selection)],2);

std_std_vis = std([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)],[],2);
m_std_vis = mean(([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)]),2);

std_first_vis = std([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],[],2);
m_first_vis = mean([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],2);

%

std_dev_aud = std([stim1_dev_aud(selection); stim2_dev_aud(selection);stim3_dev_aud(selection);stim4_dev_aud(selection)],[],2);
m_dev_aud = mean([stim1_dev_aud(selection); stim2_dev_aud(selection);stim3_dev_aud(selection);stim4_dev_aud(selection)],2);

std_std_aud = std([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)],[],2);
m_std_aud = mean(([stim1_std(selection); stim2_std(selection);stim3_std(selection);stim4_std(selection)]),2);

std_first_aud = std([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],[],2);
m_first_aud = mean([stim1_first(selection); stim2_first(selection);stim3_first(selection);stim4_first(selection)],2);

%%
aud_sel = sum(MMN_ind_stim4_vis < 0.5 &  MMN_ind_stim4_aud > 0.5);
vis_sel = sum(MMN_ind_stim4_vis > 0.5 &  MMN_ind_stim4_aud < 0.5);
av_sel = sum(MMN_ind_stim4_vis > 0.5 &  MMN_ind_stim4_aud > 0.5);

%%