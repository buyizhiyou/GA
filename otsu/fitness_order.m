function fitness_order()
global lchrom oldpop fitness popsize chrom fit gen C m n  fitness1 thresholdsum
global lowsum higsum u1 u2 threshold  oldpop1 popsize1 b1 b  
if popsize>=10
    popsize=ceil(popsize-0.03*gen);
end   %Խ����������Խ������Ⱥ��ģ
if gen==100     %��������ĩ�ڵ�ʱ�������Ⱥ��ģ�ͽ��桢�������
    cross_rate=0.35;        %�������
    mutation_rate=0.01;     %�������
end


%������ǵ�һ������һ�����������Ⱥ���ݴ˴�����Ⱥ��ģװ��˴���Ⱥ��
if gen>1   
    t=oldpop;
    j=popsize1;
    for i=1:popsize
        if j>=1
            oldpop(i,:)=t(j,:);
        end
        j=j-1;
    end
end

%�����ʶ�ֵ������
for i=1:popsize
    lowsum=0;
    higsum=0;
    lownum=0;
    hignum=0;
    chrom=oldpop(i,:);
    c=0;
    for j=1:lchrom
         c=c+chrom(1,j)*(2^(lchrom-j));%������תΪʮ����
    end
    b(1,i)=c*255/(2^lchrom-1);  %ת�����Ҷ�ֵ        
    for x=1:m
        for y=1:n
            if C(x,y)<=b(1,i)
                lowsum=lowsum+double(C(x,y));%ͳ�Ƶ�����ֵ�ĻҶ�ֵ���ܺ�
                lownum=lownum+1; %ͳ�Ƶ�����ֵ�ĻҶ�ֵ�����ص��ܸ���?
            else
                higsum=higsum+double(C(x,y));%ͳ�Ƹ�����ֵ�ĻҶ�ֵ���ܺ�
                hignum=hignum+1; %ͳ�Ƹ�����ֵ�ĻҶ�ֵ�����ص��ܸ���
            end
        end
    end
    if lownum~=0
        u1=lowsum/lownum; %u1��u2Ϊ��Ӧ�������ƽ���Ҷ�ֵ
    else
        u1=0;
    end
    if hignum~=0
        u2=higsum/hignum;
    else
        u2=0;
    end   
    fitness(1,i)=lownum*hignum*(u1-u2)^2; %�����ʶ�ֵ?
end


if gen==1 %���Ϊ��һ������С��������
    for i=1:popsize
        j=i+1;
        while j<=popsize
            if fitness(1,i)>fitness(1,j)
                tempf=fitness(1,i);
                tempc=oldpop(i,:);
                tempb=b(1,i);
                b(1,i)=b(1,j);
                b(1,j)=tempb;
                fitness(1,i)=fitness(1,j);
                oldpop(i,:)=oldpop(j,:);
                fitness(1,j)=tempf;
                oldpop(j,:)=tempc;
            end
            j=j+1;
        end
    end
    for i=1:popsize
        fitness1(1,i)=fitness(1,i);
        b1(1,i)=b(1,i);
        oldpop1(i,:)=oldpop(i,:);
    end
    popsize1=popsize;
else %����һ��ʱ�������´�С��������
    for i=1:popsize
        j=i+1;
        while j<=popsize
            if fitness(1,i)>fitness(1,j)
                tempf=fitness(1,i);
                tempc=oldpop(i,:);
                tempb=b(1,i);
                b(1,i)=b(1,j);
                b(1,j)=tempb;
                fitness(1,i)=fitness(1,j);
                oldpop(i,:)=oldpop(j,:);
                fitness(1,j)=tempf;
                oldpop(j,:)=tempc;
            end
            j=j+1;
        end
    end
end 

% %�±߶���һ��Ⱥ���������
% for i=1:popsize1
%     j=i+1;
%     while j<=popsize1
%         if fitness1(1,i)>fitness1(1,j)
%             tempf=fitness1(1,i);
%             tempc=oldpop1(i,:);
%             tempb=b1(1,i);
%             b1(1,i)=b1(1,j);
%             b1(1,j)=tempb;
%             fitness1(1,i)=fitness1(1,j);
%             oldpop1(i,:)=oldpop1(j,:);
%             fitness1(1,j)=tempf;
%             oldpop1(j,:)=tempc;
%         end
%         j=j+1;
%     end
% end

%�±�ͳ��ÿһ���е������ֵ�������Ӧ��ֵ
if gen==1
    fit(1,gen)=fitness(1,popsize);
    threshold(1,gen)=b(1,popsize);
    thresholdsum=0;
else
    if fitness(1,popsize)>fitness1(1,popsize1)
        threshold(1,gen)=b(1,popsize); %ÿһ���е������ֵ?
        fit(1,gen)=fitness(1,popsize);%ÿһ���е������Ӧ��
    else
        threshold(1,gen)=b1(1,popsize1); 
        fit(1,gen)=fitness1(1,popsize1);
    end
end