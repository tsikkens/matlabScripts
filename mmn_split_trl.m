function varargout = mmn_split_trl(varargin)
% split a trl matrix into baseline [-0.5 0] or response [0.1 0.6] trl's.
% use as [trl_base, trl_resp] = split_trl(trl, hdr)
% Or make trials around spike times [-0.4 0.4]
% use as trl_spike = split_trl(spike,unit) 

switch nargout
    case  2
    
    trl = varargin{1};
    hdr = varargin{2};
    basetrl = trl;
    basetrl(:,2) = (basetrl(:,1) - basetrl(:,3));
    basetrl(:,3) = 0;

    begsample = trl(:,1) - trl(:,3);
    %offset = round(0.1*hdr.Fs);
    offset = 0;
    begsample = begsample + offset ;
    endsample = begsample + round(0.5*hdr.Fs);

    resptrl = [begsample, endsample, zeros(length(begsample),1), trl(:,4)];

    varargout{1} = basetrl;
    varargout{2} = resptrl;

    case 1
   
    spike = varargin{1};
    hdr = spike.hdr;
    unit = varargin{2};
    
    begstmp = round((double(spike.timestamp{unit})'-double(hdr.FirstTimeStamp))/hdr.TimeStampPerSample);
    begstmp = begstmp - round(0.4*hdr.Fs);
    endstmp = floor(begstmp + 0.8*hdr.Fs);
    offset = repmat(-0.4*hdr.Fs,length(begstmp),1);
    trlinfo = spike.trial{unit}';
    btrl = [begstmp endstmp offset trlinfo];
    
    varargout{1} = btrl;
end

