function app = fastTick(app, hpt)
    %fastTick(hptvalue, {app.acto.BINPERHR, app.acto.BWPix, app.acto.BWSpace, app.acto.BHPix, app.acto.BHSpace, app.acto.dayLen});
    % fast tick

    maxcc = (app.HRPERDAY*2/hpt);
    app.xt = zeros(1, maxcc);
    cc = 1;
    for i = 0:hpt:app.HRPERDAY*2
        
        if i < app.HRPERDAY
            app.xt(cc) = app.BINPERHR * app.BWPix * i + 2 * app.BWSpace * i;
        else
            app.xt(cc) = app.BINPERHR * app.BWPix * i + 2 * app.BWSpace * i - 1;
        end
            
        cc = cc + 1;
    end

    app.xt(end) = app.xt(end) - 1;
    app.xtl = cellstr(string(0:hpt:app.HRPERDAY*2));
    y = 1:app.lenDay;
    app.ytl = cellstr(string(y));
    %app.ytl = cellstr(string(app.dayNum(:, 5:end)));
    for i = 1:app.lenDay
        app.yt(i) = app.BHPix / 2 + (i - 1) * app.BHPix + (i - 1) * app.BHSpace;
    end
    
end