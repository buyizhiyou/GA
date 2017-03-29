  load clown
  subplot(2,2,1)
  X=imread('2.jpg');
%   X = ind2rgb(X,map);
  imshow(X)
  title('Original')
  for n = 2:4
    IDX = otsu(X,n);
    subplot(2,2,n)
    imagesc(IDX)
    axis image off
    title(['n = ' int2str(n)])
  end
%   colormap(gray)
  
