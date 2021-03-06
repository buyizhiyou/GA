function [IDX,sep] = otsu(I,n)

error(nargchk(1,2,nargin))
% msgstring = nargchk(minargs, maxargs, numargs)
% 如果输入参数numargs所指定的个数比minargs小,比maxargs大,返回错误;  error函数报错跳出

% Check if is the input is an RGB image
isRGB = isrgb(I);
assert(isRGB | ismatrix(I), 'The input must be a 2-D array or an RGB image.')

%% Checking n (number of classes)
if nargin==1
    n = 2;
elseif n==1;
    IDX = NaN(size(I));
    sep = 0;
    return
elseif n~=abs(round(n)) || n==0
    error('MATLAB:otsu:WrongNValue',...
        'n must be a strictly positive integer!')
elseif n>255
    n = 255;
    warning('MATLAB:otsu:TooHighN',...
        'n is too high. n value has been changed to 255.')
end

I = single(I);%把一个矩阵中所有元素都变为单精度

%% Perform a KLT if isRGB, and keep the component of highest energy
if isRGB
    sizI = size(I);%[300,424,3]
    I = reshape(I,[],3);%127200x3 single
    [V,D] = eig(cov(I));%covv计算协方差,eig函数返回特征向量  特征值
    [tmp,c] = max(diag(D));
    I = reshape(I*V(:,c),sizI(1:2)); % component with the highest energy
end


%% Convert to 256 levels
I = I-min(I(:));
I = round(I/max(I(:))*255);

%% Probability distribution
unI = sort(unique(I));%unique函数     去掉矩阵中重复的元素
nbins = min(length(unI),256);
if nbins==n
    IDX = ones(size(I));
    for i = 1:n, IDX(I==unI(i)) = i; end
    sep = 1;
    return
elseif nbins<n
    IDX = NaN(size(I));
    sep = 0;
    return
elseif nbins<256
    [histo,pixval] = hist(I(:),unI);
else
    [histo,pixval] = hist(I(:),256);%函数格式为 [a,b]=hist(x,n) 其中x是一维向量，
    %函数功能是将x中的最小和最大值之间的区间等分n份，横坐标是x值，纵坐标是该值的个数。
    %返回的a是落在该区间内的个数，b是该区间的中心线位置坐标。
end
P = histo/sum(histo);
clear unI

%% Zeroth- and first-order cumulative moments
w = cumsum(P);
mu = cumsum((1:nbins).*P);
%% 如果A是一个向量， cumsum(A) 返回一个向量，该向量中第m行的元素是A中第1行到第m行的所有元素累加和；
%% 如果A是一个矩阵， cumsum(A) 返回一个和A同行同列的矩阵，矩阵中第m行第n列元素是A中第1行到第m行的所有第n列元素的累加和；

%% Maximal sigmaB^2 and Segmented image
if n==2
    sigma2B =(mu(end)*w(2:end-1)-mu(2:end-1)).^2./w(2:end-1)./(1-w(2:end-1));
    [maxsig,k] = max(sigma2B);
    
    % segmented image
    IDX = ones(size(I));
    IDX(I>pixval(k+1)) = 2;
    
    % separability criterion
    sep = maxsig/sum(((1:nbins)-mu(end)).^2.*P);
    
elseif n==3
    w0 = w;
    w2 = fliplr(cumsum(fliplr(P)));%fliplr 实现矩阵左右翻转
    [w0,w2] = ndgrid(w0,w2);
% [X1,X2,X3,...] = ndgrid(x1,x2,x3,...)
% 这里，x1、x2、x3……分别限定了某一维的绘图区间，结合起来就限定了绘图区域。例如，1<=x<=3,4<=y<=10,-
% 1000<=z<=1000就限定了三维空间中的一个区域。
    
    mu0 = mu./w;
    mu2 = fliplr(cumsum(fliplr((1:nbins).*P))./cumsum(fliplr(P)));
    [mu0,mu2] = ndgrid(mu0,mu2);
    
    w1 = 1-w0-w2;
    w1(w1<=0) = NaN;
    
    sigma2B =...
        w0.*(mu0-mu(end)).^2 + w2.*(mu2-mu(end)).^2 +...
        (w0.*(mu0-mu(end)) + w2.*(mu2-mu(end))).^2./w1;
    sigma2B(isnan(sigma2B)) = 0; % zeroing if k1 >= k2
    
    [maxsig,k] = max(sigma2B(:));
    [k1,k2] = ind2sub([nbins nbins],k);%ind2sub则用于把矩阵中元素单下标标识转换为该元素在矩阵中对应的全下标标识
    
    % segmented image
    IDX = ones(size(I))*3;
    IDX(I<=pixval(k1)) = 1;%pixval命令可以用来查看图像上光标所指位置的像素值。
    IDX(I>pixval(k1) & I<=pixval(k2)) = 2;
    
    % separability criterion
    sep = maxsig/sum(((1:nbins)-mu(end)).^2.*P);
    
else
    k0 = linspace(0,1,n+1); k0 = k0(2:n);
    [k,y] = fminsearch(@sig_func,k0,optimset('TolX',1));
    k = round(k*(nbins-1)+1);
    
    % segmented image
    IDX = ones(size(I))*n;
    IDX(I<=pixval(k(1))) = 1;
    for i = 1:n-2
        IDX(I>pixval(k(i)) & I<=pixval(k(i+1))) = i+1;
    end
    
    % separability criterion
    sep = 1-y;
    
end

IDX(~isfinite(I)) = 0;

%% Function to be minimized if n>=4
    function y = sig_func(k)
        
        muT = sum((1:nbins).*P);
        sigma2T = sum(((1:nbins)-muT).^2.*P);
        
        k = round(k*(nbins-1)+1);
        k = sort(k);
        if any(k<1 | k>nbins), y = 1; return, end
        
        k = [0 k nbins];
        sigma2B = 0;
        for j = 1:n
            wj = sum(P(k(j)+1:k(j+1)));
            if wj==0, y = 1; return, end
            muj = sum((k(j)+1:k(j+1)).*P(k(j)+1:k(j+1)))/wj;
            sigma2B = sigma2B + wj*(muj-muT)^2;
        end
        y = 1-sigma2B/sigma2T; % within the range [0 1]
        
    end

end

function isRGB = isrgb(A)

% RGB images can be only uint8, uint16, single, or double
isRGB = ndims(A)==3 && (isfloat(A) || isa(A,'uint8') || isa(A,'uint16'));
% ---- Adapted from the obsolete function ISRGB ----
if isRGB && isfloat(A)
    % At first, just test a small chunk to get a possible quick negative
    mm = size(A,1);
    nn = size(A,2);
    chunk = A(1:min(mm,10),1:min(nn,10),:);
    isRGB = (min(chunk(:))>=0 && max(chunk(:))<=1);
    % If the chunk is an RGB image, test the whole image
    if isRGB, isRGB = (min(A(:))>=0 && max(A(:))<=1); end
end
end

