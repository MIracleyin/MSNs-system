%%%%%%%%%%%%%%%% MSN system %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% Plot_MNtrace.m %%%%%%%%%%%%%%%%%%%%
% This script is used to visualize the trace of MNs%

time_line = null_report.report_timing(1:75:end);

%null
null_total_messages = null_report.total_messages(1:75:end);
null_received_messages = null_report.received_messages(1:75:end);
null_buffered_messages = null_report.buffered_messages(1:75:end);
null_received_directly = null_report.received_directly(1:75:end);
null_received_from_buffered = null_report.received_from_buffered(1:75:end);

null_in_buffer = null_report.in_buffer(1:75:end);
null_in_message = null_report.in_message(1:75:end);
null_average_latency = null_report.average_latency(1:75:end);
null_metric_ratio = null_report.metric_ratio(1:75:end);

null_overhead_ratio = null_buffered_messages./null_received_messages;
null_overhead_ratio(null_overhead_ratio == Inf) = 0;

%prophet
prophet_total_messages = prophet_report.total_messages(1:75:end);
prophet_received_messages = prophet_report.received_messages(1:75:end);
prophet_buffered_messages = prophet_report.buffered_messages(1:75:end);
prophet_received_directly = prophet_report.received_directly(1:75:end);
prophet_received_from_buffered = prophet_report.received_from_buffered(1:75:end);

prophet_in_buffer = prophet_report.in_buffer(1:75:end);
prophet_in_message = prophet_report.in_message(1:75:end);
prophet_average_latency = prophet_report.average_latency(1:75:end);
prophet_metric_ratio = prophet_report.metric_ratio(1:75:end);

prophet_overhead_ratio = prophet_buffered_messages./prophet_received_messages;
prophet_overhead_ratio(prophet_overhead_ratio == Inf) = 0;
%scpr
scpr_total_messages = scpr_report.total_messages(1:75:end);
scpr_received_messages = scpr_report.received_messages(1:75:end);
scpr_buffered_messages = scpr_report.buffered_messages(1:75:end);
scpr_received_directly = scpr_report.received_directly(1:75:end);
scpr_received_from_buffered = scpr_report.received_from_buffered(1:75:end);

scpr_in_buffer = scpr_report.in_buffer(1:75:end);
scpr_in_message = scpr_report.in_message(1:75:end);
scpr_average_latency = scpr_report.average_latency(1:75:end);
scpr_metric_ratio = scpr_report.metric_ratio(1:75:end);

scpr_overhead_ratio = scpr_buffered_messages./scpr_received_messages;
scpr_overhead_ratio(scpr_overhead_ratio == Inf) = 0;
%simbet
simbet_total_messages = simbet_report.total_messages(1:75:end);
simbet_received_messages = simbet_report.received_messages(1:75:end);
simbet_buffered_messages = simbet_report.buffered_messages(1:75:end);
simbet_received_directly = simbet_report.received_directly(1:75:end);
simbet_received_from_buffered = simbet_report.received_from_buffered(1:75:end);

simbet_in_buffer = simbet_report.in_buffer(1:75:end);
simbet_in_message = simbet_report.in_message(1:75:end);
simbet_average_latency = simbet_report.average_latency(1:75:end);
simbet_metric_ratio = simbet_report.metric_ratio(1:75:end);

simbet_overhead_ratio = simbet_buffered_messages./simbet_received_messages;
simbet_overhead_ratio(simbet_overhead_ratio == Inf) = 0;

% Plotting specifications
linestyles = cellstr(char('-',':','-.','--','-',':','-.','--','-',':','-',':',...
    '-.','--','-',':','-.','--','-',':','-.'));

Markers=['o','x','+','*','s','d','v','^','<','>','p','h','.',...
    '+','*','o','x','^','<','h','.','>','p','s','d','v',...
    'o','x','+','*','s','d','v','^','<','>','p','h','.'];
    
%{
plot(time_line,scpr_total_messages,...
     [linestyles{1} ]','Color','k','linewidth',0.5);
hold on;     

plot(time_line,scpr_received_messages,...
     [linestyles{1} Markers(13)]','Color','g','linewidth',0.6);
hold on; 
%plot(time_line,scpr_buffered_messages,...
%     [linestyles{1} Markers(6)]','Color','b');
%hold on; 

plot(time_line, scpr_in_buffer ,...
    [linestyles{1} Markers(13)],'Color','m','linewidth',0.6);
plot(time_line, scpr_in_message ,...
    [linestyles{1} Markers(13)],'Color','r','linewidth',0.6);

plot(time_line,scpr_received_directly,...
     [linestyles{1} Markers(13)]','Color','c','linewidth',0.6);
hold on; 
plot(time_line,scpr_received_from_buffered,...
     [linestyles{1} Markers(13)]','Color','b','linewidth',0.6);
hold on; 
legend('Generated Messages','Received Messages','Messages Under Buffering operation',...
    'Unforwarded Messages','Received In Direct Contact','Received Through Relay Contact',...
    'Location','NorthWest');

max_y = max([max(scpr_total_messages),max(scpr_received_messages),max(scpr_buffered_messages),...
             max(scpr_received_directly),max(scpr_received_from_buffered)]);
grid on;
title([' Performance of SCPR Protocol ']);
xlim([0,1300000]);
xlabel(' Time (sec)');
ylim([0,max_y+10000]);
ylabel('Messages (messages)');
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
plot(time_line, scpr_received_messages./scpr_total_messages,...
     [linestyles{1} ]','Color','b','linewidth',0.5);
hold on;     

plot(time_line,scpr_received_messages./scpr_total_messages(end),...
     [linestyles{1} Markers(13)]','Color','g','linewidth',0.6);
hold on; 

plot(time_line,scpr_total_messages./scpr_total_messages(end),...
     [linestyles{1} Markers(13)]','Color','k','linewidth',0.6);
hold on; 
legend('Instantaneous Effeceincy','Effeceincy vs. Total Messages',' Maximum Effeceincy vs. Total Messages','Location','SouthEast');
grid on;
title(['Message Delivery Ratio of SCPR Routing Protocol']);

xlabel(' Time (sec)');
ylabel('Delivery Ratio');
xlim([0,1300000]);
xlabel(' Time (sec)');
ylim([0,1.05]);
ylabel('Messages (messages)');
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
plot(time_line, scpr_average_latency ,...
    [linestyles{1} Markers(13)],'Color','k','linewidth',0.6);
hold on; 
plot(time_line, null_average_latency ,...
    [linestyles{1} Markers(13)],'Color','g','linewidth',0.6);
hold on; 
plot(time_line, prophet_average_latency ,...
    [linestyles{1} Markers(13)],'Color','b','linewidth',0.6);
hold on; 
plot(time_line, simbet_average_latency ,...
    [linestyles{1} Markers(13)],'Color','c','linewidth',0.6);
grid on;
legend('SCPR','NULL','Prophet','SimBet');
xlabel(' Time (sec)');
xlim([0,1300000]);
ylabel('Average Latency');
ylim([0,max(scpr_average_latency)]);
title(['Average Latency of SCPR Routing Protocol']);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
plot(time_line, scpr_metric_ratio,...
    [linestyles{1} Markers(13)],'Color','k','linewidth',0.6);
hold on; 
plot(time_line, null_metric_ratio ,...
    [linestyles{1} Markers(13)],'Color','g','linewidth',0.6);
hold on; 
plot(time_line, prophet_metric_ratio ,...
    [linestyles{1} Markers(13)],'Color','b','linewidth',0.6);
hold on; 
plot(time_line, simbet_metric_ratio ,...
    [linestyles{1} Markers(13)],'Color','c','linewidth',0.6);
grid on;
legend('SCPR','NULL','Prophet','SimBet');
xlim([0,1300000]);
xlabel(' Time (sec)');
ylim([0,max(scpr_metric_ratio)+max(scpr_metric_ratio)/10]);
ylabel('Average Number of Hops per Received Messagge');
title(['Average Number of Hops per Received Messagge per Node of SCPR Protocol']);
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(time_line, scpr_overhead_ratio,...
    [linestyles{1} Markers(13)],'Color','k','linewidth',0.6);
hold on; 
plot(time_line, null_overhead_ratio ,...
    [linestyles{1} Markers(13)],'Color','g','linewidth',0.6);
hold on; 
plot(time_line, prophet_overhead_ratio ,...
    [linestyles{1} Markers(13)],'Color','b','linewidth',0.6);
hold on; 
plot(time_line, simbet_overhead_ratio ,...
    [linestyles{1} Markers(13)],'Color','c','linewidth',0.6);
grid on;
legend('SCPR','NULL','Prophet','SimBet');
xlabel('Time (sec)');
xlim([0,1300000]);
ylabel('Overhead ratio');
ylim([0,max(scpr_overhead_ratio)+max(scpr_overhead_ratio)/10]);
title(['Overhead ratio of SCPR routing protocol']);
%}

