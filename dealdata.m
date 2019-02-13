% This file is for dealing with the data
%% 模板
clear
load('HDdata.mat')
data=HDdata.data4days;% data4days-102;data1month-844
j=1;
for i=1:102
    data1(j:j+data(i,2),1)=data(i,1);
    j=j+data(i,2);
end
% Pall=data1(:,3);
% Agc=data1(:,1);
PowerGrid=data1(:,1);
load('HDAgcdata.mat')
PowerAgc=HDAgcdata.data6hours;
PowerAgc=[PowerAgc;PowerAgc;PowerAgc;PowerAgc];
PowerPbat=PowerAgc(:,1)-PowerAgc(:,2);
PowerPbat=[PowerPbat;PowerPbat;PowerPbat;PowerPbat];
% %% 统计坑凸比
% Count=1;
% LineMax=length(PowerGrid);
% Result=zeros(10,3);
% state=1;
% keng=1;
% tu=1;
% Long_keng=0;
% E_keng=0;
% Long_tu=0;
% for i=1:LineMax
%     if PowerGrid(i)<1735 && state==1
%         state=0;
%         keng=i-1;
%         Long_tu=keng-tu;
%         Result(Count,1)=Long_keng;% 坑时长
%         Result(Count,2)=E_keng;% 坑能量
%         Result(Count,3)=Long_tu;% 凸时长
%         Count=Count+1;
%     end
%     if Count==13
%         ha=1;
%     end
%     if PowerGrid(i)>1735 && state==0
%         state=1;
%         tu=i;
%         Long_keng=tu-keng;
%         E_keng=sum(1748-PowerGrid(keng:tu))*1/3600;% MWh
%     end
% end
% Result(:,4)=Result(:,1)./Result(:,3)*100;
% figure(1)
% plot(PowerGrid)
% figure(2)
% m=Result(:,4);
% m([1,8,13,24])=[];
% plot(m)
% figure(3)
% m=Result(:,2);
% m([1,8,13,24])=[];
% plot(m)
% %%%======以上数据有3个比较大的能量，需要去掉