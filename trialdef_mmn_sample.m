function cfg = trialdef_mmn_sample(cfg)



if ~isfield(cfg.trialdef, 'offset' )
    error('Please define trial offset')
elseif ~isfield(cfg,'hdr')
    cfg.hdr = ft_read_header([cfg.dataset '\\CSC1.ncs']);
end

hdr      = cfg.hdr;
timestampspersecond = hdr.Fs*hdr.TimeStampPerSample;
offset   = cfg.trialdef.offset*hdr.Fs;
event    = ft_read_event([cfg.dataset '\\Events.nev']);
samp = ([event.timestamp] - hdr.FirstTimeStamp)./hdr.TimeStampPerSample;
val = [event.value];

if any(val > 1234)
    val = val - 65280;
end


indx = find(val == 1 | val == 2 | val == 3 | val == 4 | val == 5 | val == 6 | val == 7 | val == 8);
% indx = sort(indx);

begtrial = samp(indx)+offset;

[endtrial] = begtrial + 1.5*hdr.Fs - offset;

trialinfo = val(indx);

trl = zeros(length(indx),4);
trl(:,1) = begtrial;
trl(:,2) = endtrial;
trl(:,3) = offset;
trl(:,4) = trialinfo;

cfg.trl = trl;
cfg.timestampspersecond = timestampspersecond;

end