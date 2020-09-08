function app = actoRegression(app, st, en, first)
    %UNTITLED2 Summary of this function goes here
    %   Detailed explanation goes here
    repLine = length(st);
    for i = 1:repLine
        xBin = app.onsetGuess(first + st(i) - 1 : first + en(i) - 1);
        yDay = st(i) : en(i);

        % bin reg
        [~, app.M(i), app.B(i)] = regression(yDay, xBin);

        pred_x = yDay * app.M(i) + app.B(i);

        % pix reg
        app = hist2pix(app, xBin, 0);
        %app.pixhisto
        [~, app.M(i), app.B(i)] = regression(app.yt(yDay), app.pixhisto);
        tmpy = app.yt(yDay);
        app.y(:, i) = [tmpy(1); tmpy(end)];
        app.pred_x(:, i) = app.y(:, i) .* app.M(i) + app.B(i);
        
    end
    

end

