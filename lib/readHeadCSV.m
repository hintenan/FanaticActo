function HeadDate = readHeadCSV(app, fm)
    % read file
    fid = fopen(fm);
    HeadDate = textscan(fid, '%s%{yyyy/MM/dd}D%{yyyy/MM/dd}D', 'delimiter', ',');
    fclose(fid);
    % end of read file
end