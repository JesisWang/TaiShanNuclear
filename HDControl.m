% This is the file for Nuclear Power plant
% Part of Storage is for AGC, the other is for TOU price
Emax=1400;% 储能容量MWh
Pmax=150;% 储能功率MW
SOCini=0;% 初始SOC
NuclearP=1748;% MW，核电恒功率
AimP=1748;% MW,目标功率
GridP=1735;% 电网指令低于此数值时进入核电的全充电区
LineMax=length(PowerGrid);
a=0;
P=0;
Len=0;
SOC=zeros(LineMax,1);
SOC(1)=SOCini;
Pbat=zeros(LineMax,1);
P4TOU=zeros(LineMax,1);
P4Agc=zeros(LineMax,1);
PowerPbat=PowerPbat/max(abs(PowerPbat));% 归一化
PowerPbat_g=PowerPbat*50;
for i=2:LineMax
    if SOC(i-1)<=0.1
        Pbatmax=0;
        Pbatmin=-150;
    end
    if SOC(i-1)>=99.99
        Pbatmax=150;
        Pbatmin=0;
    end
    if SOC(i-1)>0.1 && SOC(i-1)<99.99
        Pbatmax=150;
        Pbatmin=-150;
    end
    if PowerGrid(i)<=GridP
        State=1;
        a=0;
        Len=0;
        P4TOU(i)=PowerGrid(i)-AimP;
        P4TOU(i)=min(P4TOU(i),Pbatmax);
        P4TOU(i)=max(P4TOU(i),Pbatmin);
        Pbat(i)=P4Agc(i)+P4TOU(i);
        SOC(i)=SOC(i-1)-Pbat(i)*1/3600/Emax*100;
        PowerPbat_g(i)=0;
    else 
        if a==0
%             a=find(PowerGrid(i:LineMax,1)<=GridP,1,'first');
            m=PowerGrid(i:LineMax,1);
            a=find(m<=GridP,1,'first');
            a=a+i;
            if isempty(a)
                a=LineMax;
            end
            Len=a-i;
            Ebat=SOC(i-1)/100*Emax*3600;% MWs,能量
            %             P=solve('sum(x-PowerGrid(i:a,1)=Ebat)','x');
            P=Ebat/Len;
        end
        P4TOU(i)=P;% 用于削峰填谷的功率
        P4Agcmax=max(Pbatmax-P,0);% 用于调频的功率最大出力
        P4Agcmin=Pbatmin;% 用于调频的功率最小出力—可以满充
        %%%修正P4Agc%%%
%         P4Agc(i)=PowerPbat(i)*P4Agcmax;
        P4Agc(i)=PowerPbat_g(i);
        P4Agc(i)=min(P4Agc(i),P4Agcmax);
        P4Agc(i)=max(P4Agc(i),P4Agcmin);
        %%%修正P4Agc%%%
        %%%修正P4TOU%%%
        P4TOU(i)=min(P4TOU(i),Pbatmax);
        P4TOU(i)=max(P4TOU(i),Pbatmin);
        %%%修正P4TOU%%%
        Pbat(i)=P4Agc(i)+P4TOU(i);
        SOC(i)=SOC(i-1)-Pbat(i)*1/3600/Emax*100;
        %         %======每次重新计算一下相应的功率=====%%%
        %         Ebat=SOC(i)/100*Emax*3600;% MWs,能量
        %         P=solve('sum(x-PowerGrid(i:a,1)=Ebat)','x');
        %         %======这是为了全面考虑===============%%%
    end
end