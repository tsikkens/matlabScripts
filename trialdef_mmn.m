function cfg = trialdef_mmn(cfg)


if ~isfield(cfg.trialdef, 'offset' )
    error('Please define trial offset')
end

hdr_dat = cfg.hdr_data;

if ~isfield(cfg,'hdr')
    hdr = ft_read_header(hdr_dat);
else
    hdr = cfg.hdr;
end

timestampspersecond = hdr.Fs*hdr.TimeStampPerSample;
offset   = cfg.trialdef.offset*timestampspersecond;
event    = ft_read_event([hdr_dat '\\Events.nev']);
ts = [event.timestamp];
val = [event.value];


indx = find(val == 1);
indx = [indx find(val == 2)];
indx = [indx find(val == 3)];
indx = [indx find(val == 4)];
indx = [indx find(val == 5)];
indx = [indx find(val == 6)];
indx = [indx find(val == 7)];
indx = [indx find(val == 8)];
indx = sort(indx);

begtrial = ts(indx)+offset;

[endtrial] = begtrial + timestampspersecond - offset;

trialinfo = val(indx);

trl = zeros(length(indx),4);
trl(:,1) = begtrial;
trl(:,2) = endtrial;
trl(:,3) = offset;
trl(:,4) = trialinfo;

cfg.trl = trl;
cfg.hdr = hdr;
cfg.timestampspersecond = timestampspersecond;

end