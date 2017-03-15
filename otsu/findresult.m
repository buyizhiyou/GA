function findresult()
global maxgen yuzhi m n C  A 
result=floor(yuzhi(1,maxgen)) %result为最佳阈值
%C=imresize(A,0.3);
% % imshow(A);
% title('原始图像')
% figure;
subplot(1,2,1)
imshow(C);
title('原始图像的灰度图')
[m,n]=size(C);
%用所找到的阈值分割图象
for i=1:m
    for j=1:n
        if C(i,j)<=result
            C(i,j)=0;
        else
            C(i,j)=255;
        end
    end
end
subplot(1,2,2)
imshow(C);
title('阈值分割后的图像');