%社交参数的计算
wait_bar = waitbar(0, 'Mobile Node Parameter Calculate');
set(wait_bar,'name', 'Mobile Node Parameter Calculate' );
wb = 50/input_settings.MN_N;
for MN_INDEX_1 = 1 : input_settings.MN_N
    for MN_INDEX_2 =  1 : input_settings.MN_N
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_PROBABILITY = ...
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES/...
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).MEET_ALLTIMES;
        %使用公式2
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES / 1440 * s_data_day;%MEET_TINES/1440

        %计算公式4,5 需要修正
        %如果相遇次数小于2，那么
        if(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES < 2)
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY = 0;
        else
            %4 
            SUM_T = 0;
            for M_counter =  2 : MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES
                SUM_T = SUM_T + ...
                ( MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter) - ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter - 1) );
            end
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T = ...
            1/(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES - 1) * SUM_T;
            
            %5
            SUM_T_diff = 0;
            for M_counter =  2 : MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES
                SUM_T_diff = SUM_T_diff + ...
                ( MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter) - ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEETING_TIME(M_counter - 1) - ...
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T )^2;
            end
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T = ...
            sqrt( 1/(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).MEET_TIMES - 2) * SUM_T_diff);
            if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T)
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T = 0;
            end

            %3
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY = ...
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T / ...
            (MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DELTA_T + ...
            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).S_DELTA_T);

            if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY)
                MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY = 0;
            end
        end

        %6
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_REGULARITY * ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).ENCOUNTER_PROBABILITY;

        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY * ageing;%ageing
        %直接概率存入路由表
        %ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY = ...
        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
        %结合仿真时长，可以结合8修正ageing效应
    end
    str_bar = ['NO.' num2str(wb) ' Mobile Node'];
    waitbar(wb/input_settings.MN_N, wait_bar, str_bar);
    wb = wb + 50/input_settings.MN_N;
end
close(wait_bar);

%记录间接概率，使用DIRECT_PROBABILITY_AVE计算
%MN_DATA_SOCIA_temp(2) = MN_DATA_SOCIA_temp %保存路由表

%HOP
wait_bar = waitbar(0 , 'Mobile Node HOP calculate');
set(wait_bar, 'name', 'Mobile Node HOP calculating...');
wb = 50/length(1:input_settings.MN_N);
for MN_INDEX_1 = 1 : input_settings.MN_N%源节点MN1
    for MN_INDEX_2 = 1 : input_settings.MN_N%目标节点MN2
        %for MN_INDEX_X = 1 : input_settings.MN_N
        %    if (MN_INDEX_X ~= MN_INDEX_1) && (MN_INDEX_X ~= MN_INDEX_2)
        %        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP = ...
        %        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X).DIRECT_PROBABILITY * ...
        %        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
        %        if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP)
        %            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = 0;
        %        end
        %    end
        
        %正式仿真
        for MN_INDEX_X1 = 1 : input_settings.MN_N%任取一中间节点1
            for MN_INDEX_X2 = 1 : input_settings.MN_N%任取一中间节点2
                for MN_INDEX_X3 = 1 : input_settings.MN_N%任取一中间节点3
                    if (MN_INDEX_X1 ~= MN_INDEX_1) && (MN_INDEX_X1 ~= MN_INDEX_2) && (MN_INDEX_X2 ~= MN_INDEX_X1) && (MN_INDEX_X2 ~= MN_INDEX_2) && (MN_INDEX_X3 ~= MN_INDEX_1) && (MN_INDEX_X3 ~=MN_INDEX_2)
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP4 = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X1).DIRECT_PROBABILITY * ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X1).SOCIAL_CONTACT(MN_INDEX_X2).DIRECT_PROBABILITY * ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X2).SOCIAL_CONTACT(MN_INDEX_X3).DIRECT_PROBABILITY * ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X3).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                        if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP4)
                            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP4 = 0;
                        end
                        %ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP4 = ...
                        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP4;
                    elseif (MN_INDEX_X1 ~= MN_INDEX_1) && (MN_INDEX_X1 ~= MN_INDEX_2) && (MN_INDEX_X2 ~= MN_INDEX_X1) && (MN_INDEX_X2 ~= MN_INDEX_2)
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X1).DIRECT_PROBABILITY * ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X1).SOCIAL_CONTACT(MN_INDEX_X2).DIRECT_PROBABILITY * ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X2).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                        if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3)
                            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = 0;
                        end
                        %ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3 = ...
                        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP3;
                    elseif (MN_INDEX_X1 ~= MN_INDEX_1) && (MN_INDEX_X1 ~= MN_INDEX_2)
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_X1).DIRECT_PROBABILITY * ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_X1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                        if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2)
                            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = 0;
                        end
                        %ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2 = ...
                        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP2;
                    else
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = ...
                        MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).DIRECT_PROBABILITY;
                        if isnan(MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1)
                            MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = 0;
                        end
                        %ROUTING_TABLE_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1 = ...
                        %MN_DATA_SOCIA_temp.VS_NODE(MN_INDEX_1).SOCIAL_CONTACT(MN_INDEX_2).TRANS_PROBABILITY_HOP1;
                    end
                end
            end
        end
        
    end
    str_bar = ['NO.' num2str(wb) ' Mobile Node HOP calculating...'];
    waitbar(wb/50, wait_bar, str_bar);
    wb = wb + 50/length(1:input_settings.MN_N);
end
close(wait_bar);