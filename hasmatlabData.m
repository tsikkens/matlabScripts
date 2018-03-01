function seslist = hasmatlabData(datafolder,varargin)
%Use as seslist = hasmatlabData(datafolder) or hasmatlabData(datafolder, do) . Checks wether the
%matlabData.mat file exist for all experimantal folders in 'datafolder'.
%Can be either in the main folder or in a folder called ' Sort'. If do ==
%true (default) returns a list of foldernames that contain the matlabData
%file. If do == false it returns a list of folders that are missing the
%matlabData file

%TS Last edit 23-01-2018

if nargin >1
    do = varargin{1};
else
    do = true;
end

%Find contents of mainfolder
folders = dir(datafolder);
%Initiate counter
sescounter = 0;

% Check contents of main for folders to loop through
foldnums = [-1 find(cellfun(@(x) exist(x,'dir'), {fullfile(datafolder,folders(3:end).name)}))+2];

%If no folders to loop through: look only in mainfolder


%Preallocate seslist for speed
seslist = cell(1,numel(foldnums));

for iFolder = foldnums
    if iFolder == -1 %Check main folder for matlabData file
       subfolder = [];
    else
        subfolder = folders(iFolder).name; %Check subfolders
       
    end
    
    %Check if current (sub)folder has the Sort folder
    sessions = dir(fullfile(datafolder,subfolder));
    sortfolder = find(cellfun(@(x) any(strcmp(x, 'Sort')),{sessions.name}));
    
    if do
        if exist(fullfile(datafolder,subfolder,sessions(sortfolder).name,'matlabData.mat'),'file');
            %increase counter
            sescounter  = sescounter +  1;
            %ad path to seslist
            seslist(sescounter) = {fullfile(datafolder,subfolder,sessions(sortfolder).name)};
            
        end
    else
        if ~exist(fullfile(datafolder,subfolder,sessions(sortfolder).name,'matlabData.mat'),'file');
            %increase counter
            sescounter  = sescounter +  1;
            %ad path to seslist
            seslist(sescounter) = {fullfile(datafolder,subfolder,sessions(sortfolder).name)};
            
        end
    end
    
end

%Remove empty instances of seslist that were previously allocated
seslist(cellfun(@(x) isempty(x),seslist)) = [];
