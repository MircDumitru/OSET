function peaks = PeakDetection6(x,ff,th,varargin)
%
% peaks = PeakDetection6(x,f,th,flag),
% R-peak detector based on max search and level thresholding
%
% inputs:
% x: vector of input data
% f: approximate ECG beat-rate in Hertz, normalized by the sampling frequency
% th: peaks smaller than this (relative) threshold are neglected
% flag: search for positive (flag=1) or negative (flag=0) peaks. By default
% the maximum absolute value of the signal, determines the peak sign.
%
% output:
% peaks: vector of R-peak impulse train
%
% Notes:
% - The R-peaks are found from a peak search in windows of length N; where 
% N corresponds to the R-peak period calculated from the given f. R-peaks 
% with periods smaller than N/2 or greater than N are not detected.
% - The signal baseline wander is recommended to be removed before the
% R-peak detection
%
%
% Open Source ECG Toolbox, version 1.0, November 2006
% Released under the GNU General Public License
% Copyright (C) 2006  Reza Sameni
% Sharif University of Technology, Tehran, Iran -- GIPSA-Lab, INPG, Grenoble, France
% reza.sameni@gmail.com
%
% Updates:
% Nov 2020: Used logical indexing for speed improvement
%
% This program is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the
% Free Software Foundation; either version 2 of the License, or (at your
% option) any later version.
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
% Public License for more details.

N = length(x);
peaks = zeros(1,N);

% % % x(abs(x)<th*max(abs(x))) = 0;

rng = floor(0.5/ff);

if(nargin==4)
    flag = varargin{1};
else
    flag = abs(max(x))>abs(min(x));
end

if(flag)
    for j = 1:N
        %         index = max(j-rng,1):min(j+rng,N);
        if(j>rng && j<N-rng)
            index = j-rng:j+rng;
        elseif(j>rng)
            index = N-2*rng:N;
        else
            index = 1:2*rng;
        end

        if(max(x(index))==x(j))
            peaks(j) = 1;
        end
    end
else
    for j = 1:N
        %         index = max(j-rng,1):min(j+rng,N);
        if(j>rng && j<N-rng)
            index = j-rng:j+rng;
        elseif(j>rng)
            index = N-2*rng:N;
        else
            index = 1:2*rng;
        end

        if(min(x(index))==x(j))
            peaks(j) = 1;
        end
    end
end

% remove fake peaks
I = find(peaks);
mx = max(abs(x(I)));
J = abs(x(I)) < th*mx;
peaks(I(J)) = 0;

% peaks(abs(x(peaks==1))<th*max(abs(x(peaks==1)))) = 0;