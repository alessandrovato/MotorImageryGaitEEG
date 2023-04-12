Ifunction loadBCI2000DataEEG_miNCAN (loadFile,loadFolder,numFiles,option)
% Load BCI2000 EEG files into  EEGlab
% This function change a BCI2000 file '.dat' into a EEGLab file '.set'
% the files are saved as 'M01S01R01.set' in the dir
% 'miNCAN_results\1-rawData'

%opts = repository_miNCAN(option);

for i = 1 : numFiles
    
cd(loadFolder);

if iscell(loadFile)
    fileName = loadFile(i);
else
    fileName = {loadFile};
end

nameSubject = ['M' fileName{1,1}(15:16)];

EEG = pop_loadBCI2000(fileName, option.event); 
EEG = eeg_checkset( EEG );

saveFileName = [nameSubject,'S',fileName{1,1}(end-8:end-7),fileName{1,1}(end-6:end-4) 'EEG']; % i need to remove one zero from S001

newDir = ['D:\0-MATLAB\1_Data\0_miNCAN_Data\miNCAN_results\1-rawData\' nameSubject];

if not(isfolder(newDir))
    mkdir(newDir)
end

saveFilePath = newDir;

EEG = pop_saveset( EEG, 'filename',saveFileName,'filepath',saveFilePath);

end