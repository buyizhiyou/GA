function select()
global fitness popsize oldpop temp popsize1 oldpop1 gen b b1 fitness1
%ͳ��ǰһ��Ⱥ������Ӧֵ�ȵ�ǰȺ����Ӧֵ��ĸ���
s=popsize1+1;
for j=popsize1:-1:1
    if fitness(1,popsize)<fitness1(1,j)
        s=j;
    end
end
for i=1:popsize
    temp(i,:)=oldpop(i,:);
end
if s~=popsize1+1
    if gen<50  %С��50������һ��������Ӧ��ֵ���ڵ�ǰ���ĸ���������浱ǰ���еĸ���
        for i=s:popsize1
            p=rand;
            j=floor(p*popsize+1);
            temp(j,:)=oldpop1(i,:);
            b(1,j)=b1(1,i);
            fitness(1,j)=fitness1(1,i);
        end
    else
        if gen<100  %50~100������һ��������Ӧ��ֵ���ڵ�ǰ���ĸ�����浱ǰ���е�������
            j=1;
            for i=s:popsize1
                temp(j,:)=oldpop1(i,:);
                b(1,j)=b1(1,i);
                fitness(1,j)=fitness1(1,i);
                j=j+1;
            end
        else %����100������һ���е������һ����浱ǰ���е�����һ�룬�ӿ�Ѱ��
            j=popsize1;
            for i=1:floor(popsize/2)
                temp(i,:)=oldpop1(j,:);
                b(1,i)=b1(1,j);
                fitness(1,i)=fitness1(1,j);
                j=j-1;
            end
        end
    end
end
%����ǰ���ĸ������ݱ���
for i=1:popsize
    b1(1,i)=b(1,i); 
end    
for i=1:popsize
    fitness1(1,i)=fitness(1,i); 
end
for i=1:popsize
    oldpop1(i,:)=temp(i,:);
end
popsize1=popsize;