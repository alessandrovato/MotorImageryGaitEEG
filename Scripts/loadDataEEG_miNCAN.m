function EEG = loadDataEEG_miNCAN (code)

analysis_opts = repository_miNCAN(code);

[loadFile,loadFolder,numFiles]=loadFilesToProcess(analysis_opts);

EEG = pop_loadset('filename',loadFile,'filepath',loadFolder);

end

