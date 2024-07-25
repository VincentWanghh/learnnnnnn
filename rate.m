clc;
clear;
num_of_symbol = 500000;%定义生成16QAM符号序列的数量
M = 16;%定义QAM调制的阶数,M=16表示16QAM
SNR = 0:1:15;%信噪比取值范围
SNR_linear = 10.^(SNR/10);%将信噪比由dB转换为信号功率与噪声功率的实际比值
msg = randi([0,M-1],1,num_of_symbol);%生成500000个等概随机的原始符号
msgmod = qammod(msg,M,'PlotConstellation',true);
%调用qammod函数,输入原始符号和调制阶数,得到调制后符号(为降低误码率，这里采用qammod函数默认的格雷映射)
ber = zeros(1,length(SNR));%初始化存放比特误码率的数组
for i = 1:length(SNR)%遍历计算不同信噪比下的仿真比特误码率
    rxSig = awgn(msgmod,SNR(i),'measured');%为16QAM调制后的信号按信噪比添加高斯白噪声，得到接收端的信号
    decmsg = qamdemod(rxSig,M);%调用qamdemod函数，进行16QAM的解调，输入接收信号和调制阶数，得到解调后的符号
    [err,ber(i)] = biterr(msg,decmsg,log2(M));
    %将发送端符号msg和解调符号decmsg转换为二进制后进行比较，且每个符号携带4bit，得到误比特数err和误比特率ber(i)
end

p = 2*(1-1/sqrt(M))*qfunc(sqrt(3*SNR_linear/(M-1)));%计算sqrt(M)PAM系统的理论误码率
ser_theory = 1-(1-p).^2;%计算16QAM系统的理论误码率
ber_theory = 1/log2(M)*ser_theory;%计算16QAM系统的理论比特误码率


%绘制比特误码率比较图
figure(2);
myfig = semilogy(SNR,ber,'.',SNR, ber_theory, '-');
myfig(1).MarkerSize = 15;%指定点的大小
myfig(2).LineWidth = 1.5;%指定线宽
title("信号在采用16QAM调制的通信系统中经归一化恒参信道并受高斯白噪声影响后的比特误码率比较图")
xlabel("{E_b/N_0}(dB)");
ylabel("比特误码率BER");
legend("仿真比特误码率","理论比特误码率");
grid on;
