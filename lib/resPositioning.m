% 640 x 480 resolution positioning maker
resX = 640;
resY = 480;
% center point
centerX = 640/2;
centerY = 480/2;

spacing = 55;

% title alignment
titleSizeWidth = 240;
titleSizeHeight = 50;
titleCenterY = 480 - spacing - titleSizeHeight/2;
titleCenterX = centerX;
titlePotitionBottom = 480 - spacing - titleSizeHeight;
titlePotitionLeft = titleCenterX - titleSizeWidth/2;

%
% Circadian Botton alignment

circadianButtonWidth = 96;
circadianButtonHeight = 31;
circadianButtonBottom = spacing;
circadianButtonLeft = centerY;

% Graph Botton alignment

graphButtonWidth = 96;
graphButtonHeight = 31;
graphButtonBottom = spacing;
graphButtonLeft = centerX + circadianButtonWidth - 1;

% Color Botton alignment

colorButtonWidth = 96;
colorButtonHeight = 31;
colorButtonBottom = spacing;
colorButtonLeft = centerX + circadianButtonWidth - 1 + graphButtonWidth - 1;

% Prediction Botton alignment

predictionBottonWidth = 96;
predictionButtonHeight = 31;
predictionButtonBottom = spacing - predictionButtonHeight + 1;
predictionButtonLeft = centerX;

bottonName = {'Circadian'; 'Graph'; 'Color'; 'Prediction'};
posLeft = [circadianButtonLeft; graphButtonLeft; colorButtonLeft; predictionButtonLeft];
posBotton = [circadianButtonBottom; graphButtonBottom; colorButtonBottom; predictionButtonLeft];
posWidth = [circadianButtonWidth; graphButtonWidth; colorButtonWidth; predictionButtonLeft];
posHeight = [circadianButtonHeight; graphButtonHeight; colorButtonHeight; predictionButtonLeft];
T = table(bottonName, posLeft, posBotton, posWidth, posHeight)
T1 = table(bottonName, posLeft, posBotton, posWidth, posHeight)
[T1;T2]












