
function app = readActoCSV(app, CHAMBERKEY, FILEPATH)
    
    if CHAMBERKEY == -1
        app.fileNamePart = FILEPATH;
        app.fileNamePart = app.fileNamePart(1:end-4);
        app.fileMaskNamePart = [FILEPATH '/../mask/' num2str(CHAMBERKEY) '/runner' num2str(CHAMBERKEY) 'mask'];
    
    else
        app.fileNamePart = [FILEPATH '/' num2str(CHAMBERKEY) '/runner' num2str(CHAMBERKEY)];
        app.fileMaskNamePart = [FILEPATH '/../mask/' num2str(CHAMBERKEY) '/runner' num2str(CHAMBERKEY) 'mask'];
    end

    cc = 1;
    while 1
        % read file
        fid = fopen([app.fileNamePart '_' num2str(cc) '.csv']);
        if fid > 0
            if cc > 1
                tmp = textscan(fid, '%d%f64', 'delimiter', ',');
                app.ActoCSV{1} = [app.ActoCSV{1}; tmp{1}];
                app.ActoCSV{2} = [app.ActoCSV{2}; tmp{2}];
                cc = cc + 1;
                fclose(fid);
            else
                
                app.ActoCSV = textscan(fid, '%d%f64', 'delimiter', ',');
                cc = cc + 1;
                fclose(fid);
                % end of read file
            end
        else
            
            break
        end
        
    end

    if cc > 1
        fid = fopen([app.fileNamePart '.csv']);
        tmp = textscan(fid, '%d%f64', 'delimiter', ',');
        app.ActoCSV{1} = [app.ActoCSV{1}; tmp{1}];
        app.ActoCSV{2} = [app.ActoCSV{2}; tmp{2}];
        
        fclose(fid);
    else
        fid = fopen([app.fileNamePart '.csv']);
        app.ActoCSV = textscan(fid, '%d%f64', 'delimiter', ',');
        fclose(fid);
    end
    
    % Mask
    fid = fopen([app.fileMaskNamePart '.csv']);
    
    if fid > 0
        try
            app.existMask = 1;
            tmp = textscan(fid, '%{yyyy/MM/dd}D%{HH:mm:ss}D%{HH:mm:ss}D', 'delimiter', ',');
            app.MaskCSVs = datetime(tmp{1} + timeofday(tmp{2}), 'format', 'yyyy/MM/dd HH:mm:ss');
            app.MaskCSVe = datetime(tmp{1} + timeofday(tmp{3}), 'format', 'yyyy/MM/dd HH:mm:ss');

            fclose(fid);
        catch
            app.existMask = 0;
            disp('Mask file processing error.')
        end
            
    
    else
        app.existMask = 0;
    end
    
end