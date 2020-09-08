function app = ChiP(app)

    rmax = 30;
    rmin = 15;
    tmp = reshape(app.actoHist', 1, []);

    N = length(tmp);
    M = mean(tmp);

    denom = sum((tmp(:) - M).^2);
    figure(2266)
    
    cc = 1;
    
    rangex = app.BINPERHR*rmin:app.BINPERHR*rmax;
    
    Qp = zeros(1, length(rangex));
    chi2m = zeros(1, length(rangex));
    for i = rangex

        P = i;
        %Pp = P*12;
        K = floor(N / P);
        tail = rem(N, P);
        block = reshape(tmp(1 : end - tail), P, []);
        %size(block)
        Mh = mean(block, 2);
        %size(Mh)
        nom = K*N*sum((Mh - M).^2);

        Qp(cc) = nom/denom;
        adjAlpha = 1 - power((1 - 0.05), 1/P);
        chi2m(cc) = icdf('chi2', adjAlpha, P - 1);
        
        cc = cc + 1;
    end

    plot((rangex)', Qp)
    tickl = rmin : rmax;
    rangext = tickl * app.BINPERHR;
    xticks(rangext)

    xticklabels(cellstr(string(tickl)))

    [Y, I] = max(Qp);
    indPos = min(rangex) + I - 1;

    indPos / app.BINPERHR;

    hold on
    plot((rangex)', chi2m);


    %plot(indPos, Y, '*');
    txt = ['\leftarrow ' num2str(indPos / app.BINPERHR)];
    text(indPos, Y, txt)
    hold off


end