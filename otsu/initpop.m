function initpop()
global lchrom oldpop popsize chrom C
for i=1:popsize
    chrom=rand(1,lchrom);   % x=rand(m,n)����m��n�е�λ�ڣ�0��1������������
    for j=1:lchrom
        if chrom(1,j)<0.5
            chrom(1,j)=0;
       else
           chrom(1,j)=1;
        end
    end
    oldpop(i,1:lchrom)=chrom;    
end