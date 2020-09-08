
function app = readActoCSV(app, CHAMBERKEY, FILEPATH)
    
    if CHAMBERKEY == -1
        app.fileNamePart = FILEPATH;
        app.fileNamePart = app.fileNamePart(1:end-4);
    else
        app.fileNamePart = ['./mask/' num2str(CHAMBERKEY) '/runner' num2str(CHAMBERKEY) 'mask'];
    end

    
    fid = fopen([app.fileNamePart '.csv']);
    if fid > 0
        try
            tmp = textscan(fid, '%{yyyy/MM/dd}D%{HH:mm:ss}D%{HH:mm:ss}D', 'delimiter', ',');
            app.MaskCSVs = datetime(tmp{1} + timeofday(tmp{2}), 'format', 'yyyy/MM/dd HH:mm:ss');
            app.MaskCSVe = datetime(tmp{1} + timeofday(tmp{3}), 'format', 'yyyy/MM/dd HH:mm:ss');
            fclose(fid);
            app.exsitMask = 1;
        catch
            fprintf('An error occurred while parsing custom mask file.\n')
            app.exsitMask = 0;
        end
    
    else
        app.exsitMask = 0;
        fprintf('Custom mask file dose not exist.\n')
    end
    
end