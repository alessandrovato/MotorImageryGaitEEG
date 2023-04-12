function main_miNCAN (code, fileToProcess, subjectToProcess)
% main_miNCAN is the main function to anlayze data collected at NCAN 
% from Jan 2022 to June 2022 in a gait motor imagery experiment.
% 
%
%
% input : code
%
%  10 - convert .dat files into .set files and save in subject's folder
%  A  - pre-processing of the data: 1) channel location 2) band-pass filter
%      3) resampling 4) re-referincing (common average referencing)
%  B - add extra event to the data
%  C - extract epoch
%
% repository_miNCAN contains all the analysis parameters
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load analysis parameters

analysis_opts = repository_miNCAN(code);

% load files to process

if ~exist('fileToProcess','var')
    % second parameter does not exist, so default it to select files manually
    [loadFile,loadFolder,numFiles]=loadFilesToProcess(analysis_opts);
else
    loadFolder = analysis_opts.saveFolder;
    
    if ~exist('subjectToProcess','var')
        % third parameter does not exist
        %if strcmp (fileToProcess(end-1:end),'C1')
            listFilesToLoad = [dir([analysis_opts.saveFolder,'\*',fileToProcess,'.set'])];
% MAC %%%%%
            %listFilesToLoad = [dir([analysis_opts.saveFolder,'/*',fileToProcess,'L.set'])];
        %else
            
            %listFilesToLoad = dir([analysis_opts.saveFolder,'\*',fileToProcess,'.set']);
% MAC %%%%%
            %listFilesToLoad = [dir([analysis_opts.saveFolder,'/*',fileToProcess,'.set'])];            
        %end
    else
        %if strcmp (fileToProcess(end-1:end),'C1')
            %listFilesToLoad = dir([analysis_opts.saveFolder,'\',subjectToProcess,'*',fileToProcess,'.set']);
% MAC %%%%%  
            %listFilesToLoad = dir([analysis_opts.saveFolder,'/',subjectToProcess,'*',fileToProcess,'.set']);
        %else
            listFilesToLoad = dir([analysis_opts.saveFolder,'\',subjectToProcess,'*',fileToProcess,'.set']);
% MAC %%%%%             
            %listFilesToLoad = dir([analysis_opts.saveFolder,'/',subjectToProcess,'*',fileToProcess,'.set']);
        %end
        
    end
    
    numFiles = length(listFilesToLoad);
     
     % loadFile = cell(length(listFilesToLoad),1);
         for i = 1 : length(listFilesToLoad)
             loadFile(i) = {listFilesToLoad(i).name};
         end    
 end

% processing data files 
 
switch(code(1))
    
    case 10

        loadBCI2000DataEEG_miNCAN(loadFile,loadFolder,numFiles,analysis_opts);
    
    case 20
        
        loadEEGDataset_miNCAN(loadFile,loadFolder,numFiles,analysis_opts)    
        
    case 'A'

        preProcessing_miNCAN(loadFile,loadFolder,numFiles,analysis_opts);
        
    case 'B'
        
        addEvent_miNCAN(loadFile,loadFolder,numFiles,analysis_opts);
        
    case 'C'
        epoch_miNCAN(loadFile,loadFolder,numFiles,analysis_opts);
    
    case 'D'
        mergeDataset_fcrAnalysis(analysis_opts);
    
    case 'E'
        plotGaitPSD2(loadFile,loadFolder,numFiles,analysis_opts);
        
    case 'F'
        plotTopoDist(loadFile,loadFolder,numFiles,analysis_opts);
        
end

end

