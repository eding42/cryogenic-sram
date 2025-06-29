templateFile = 'SNM_sram.sp';   % <- the master copy you pasted above
paramName    = 'Tsim';                    % <- which .param to sweep
paramVals    = [  4  5  6 7 8 10   20   77 300];     % <- the values you want to try
outDir         = 'sram_vary_temp';      % <- sub-folder for cleanliness
% ------------------------------------------------------------

% make sure the destination folder exists
if ~exist(outFolder,'dir'),  mkdir(outFolder);  end

% read the whole template into one character vector
origText = fileread(templateFile);

% build a regex that finds “.param  <name> = <something>”
%   – it is case-insensitive, ignores leading spaces, and keeps any
%     other .param assignments on the same line unchanged.
pat = sprintf('(?im)^\\s*\\.param\\s+%s\\s*=\\s*[-+\\d.eE]+', paramName);

for v = paramVals
    % 2️⃣  Create the replacement line
    repl = sprintf('.param %s = %g', paramName, v);

    % 3️⃣  Replace exactly that one line
    newText = regexprep(origText, pat, repl, 'once');

    % 4️⃣  Write a new netlist file whose name carries the value
    outFile = fullfile(outDir, sprintf('%s_%g.sp', paramName, v));
    fid = fopen(outFile,'w');  fwrite(fid, newText);  fclose(fid);

    fprintf('Wrote  %s\n', outFile);
end
