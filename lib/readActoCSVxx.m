
function app = readActoCSV(app)
    % read file
    fid = fopen(app.fm);
    app.ActoCSV = textscan(fid, '%d%f64', 'delimiter', ',');
    fclose(fid);
    % end of read file
end