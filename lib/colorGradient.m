function [grad] = colorGradientDiag(app, tmpcolor, gpara)
    grad = zeros(app.BHPix, app.BWPix);

    if tmpcolor == 1
        colorheavy = '2193b0';
        colorlight = '6dd5ed';
    elseif tmpcolor == 2
        colorheavy = '00b09b';
        colorlight = '96c93d';
    elseif tmpcolor == 3
        colorheavy = 'f05053';
        colorlight = 'e1eec3';
    elseif tmpcolor == 4
        colorheavy = 'FF8008';
        colorlight = 'FFC837';
    
    elseif tmpcolor == 5
        colorheavy = '000000';
        colorlight = '909090';
  
    else
        colorheavy = '000000';
        colorlight = '000000';
    end
        
    tilt = 5;
    crh = hex2dec(colorheavy(1:2));
    cgh = hex2dec(colorheavy(3:4));
    cbh = hex2dec(colorheavy(5:6));
    crl = hex2dec(colorlight(1:2));
    cgl = hex2dec(colorlight(3:4));
    cbl = hex2dec(colorlight(5:6));
    crg = linspace(crl, crh, app.BHPix+app.BWPix*tilt)/255;
    cgg = linspace(cgl, cgh, app.BHPix+app.BWPix*tilt)/255;
    cbg = linspace(cbl, cbh, app.BHPix+app.BWPix*tilt)/255;
    for i = 1:app.BWPix
        grad(:, i, 1) = crg(1 + tilt*(i-1):app.BHPix+tilt*(i-1))';
        grad(:, i, 2) = cgg(1 + tilt*(i-1):app.BHPix+tilt*(i-1))';
        grad(:, i, 3) = cbg(1 + tilt*(i-1):app.BHPix+tilt*(i-1))';
    end
    %figure(3)
    %imshow(grad)
    
end

