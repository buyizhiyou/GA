function mutation()
global popsize lchrom mutation_rate temp  oldpop
sum=lchrom*popsize;    %�ܻ������
mutnum=round(mutation_rate*sum);    %��������Ļ�����Ŀ
for i=1:mutnum
    s=rem((round(rand*(sum-1))),lchrom)+1; %ȷ�����ڻ����λ��
    t=ceil((round(rand*(sum-1)))/lchrom); %ȷ����������ĸ�����
    if t<1
        t=1;
    end
    if t>popsize
        t=popsize;
    end
    if s>lchrom
        s=lchrom;
    end
    if temp(t,s)==1
        temp(t,s)=0;
    else
        temp(t,s)=1;
    end
end
for i=1:popsize
    oldpop(i,:)=temp(i,:);
end