
function app = readActoCSVapp(app, cageNum)
    cc = 1;
    while 1
        % read file
        fid = fopen([fm '_' num2str(cc) '.csv']);
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
        fid = fopen([fm '.csv']);
        tmp = textscan(fid, '%d%f64', 'delimiter', ',');
        app.ActoCSV{1} = [app.ActoCSV{1}; tmp{1}];
        app.ActoCSV{2} = [app.ActoCSV{2}; tmp{2}];
        
        fclose(fid);
    else
        fid = fopen([fm '.csv']);
        app.ActoCSV = textscan(fid, '%d%f64', 'delimiter', ',');
        fclose(fid);
    end
    app.ActoCSV
end