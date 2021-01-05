package com.shxiv.test;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiAttendanceListRecordRequest;
import com.dingtalk.api.response.OapiAttendanceListRecordResponse;
import com.shxiv.dingding.api.GetAccessToken;
import com.taobao.api.ApiException;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class DBUtils {
    static String driverClassName="com.microsoft.sqlserver.jdbc.SQLServerDriver";
    static String url="jdbc:sqlserver://10.26.235.231:1433;DatabaseName=ecology";
    static String userName="sa";
    static String password="Weaver2016";
    static Connection conn = null;
    public static Connection getConnection(){
        //1.加载驱动
        try {
            Class.forName(driverClassName);
            System.out.println("加载驱动成功！");
            conn = DriverManager.getConnection(url,userName,password);
            System.out.println("连接数据库成功！");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("加载驱动失败！");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("连接数据库失败！");
        }
        return conn;
    }


        public static void main(String[] args) throws SQLException, ApiException {
            List<String> users = new ArrayList<String>();
            int usersIdList=0;//插入考勤的总条数

            //设置日期格式
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            SimpleDateFormat format2 = new SimpleDateFormat("HH:mm:ss");
            java.util.Date today = new java.util.Date();//获取今天的日期
            String todayDate1 = format1.format(today);
            Calendar c = Calendar.getInstance();
            c.setTime(today);
            c.add(Calendar.DAY_OF_MONTH, -1);
            Date yesterday = c.getTime();//这是昨天
            String yesterdayDate = format.format(yesterday) + " 00:00:00";
//            Connection dbConn = DBUtils.getConnection();
//            String sql="select id as userID  from HrmResource  where  status in (0,1,2,3)  and workcode<>''  and lastname='乔纯' ";
//            PreparedStatement statement=null;
//            statement=dbConn.prepareStatement(sql);
//            ResultSet res=null;
//            res=statement.executeQuery();
//            while (res.next()) {
//                String userID = String.valueOf(res.getInt("userID"));
//                users.add(userID);
//            }
            users.add("1303");
            System.out.println("users:"+users.toString());
            String errmsg;
            //考勤数据获取
            GetAccessToken getAccessToken = new GetAccessToken();
            String accessToken = getAccessToken.accessToken();
            DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/attendance/listRecord");
            OapiAttendanceListRecordRequest request = new OapiAttendanceListRecordRequest();
            request.setCheckDateFrom(yesterdayDate);
            request.setCheckDateTo(todayDate1);
            request.setUserIds(users);
            OapiAttendanceListRecordResponse execute = client.execute(request,accessToken);
            errmsg = execute.getErrmsg();
            if ("ok".equals(errmsg)) {
                List<OapiAttendanceListRecordResponse.Recordresult> list = execute.getRecordresult();
                System.out.println("list:"+list.toString());
                for (int x = 0; x < list.size(); x++) {
                    //用户ID
                    String userid = list.get(x).getUserId();
                    //考勤类型:1签到2签退
                    int signType = 0;
                    String sign = list.get(x).getCheckType();
                    if(sign!=null) {
                        if (sign.equals("OnDuty")) {
                            signType = 1;
                        } else if (sign.equals("OffDuty")) {
                            signType = 2;
                        }
                    }
                    System.out.println("signType:"+signType);
                    //考勤日期和时间
                    Date date = list.get(x).getUserCheckTime();
                    String dateTime = format1.format(date);
                    System.out.println("dateTime："+dateTime);

                    //打卡结果：Normal：正常;Early：早退;Late：迟到;SeriousLate：严重迟到；Absenteeism：旷工迟到；NotSigned：未打卡
                    String result = list.get(x).getTimeResult();
                    System.out.println("result:"+result);
                }
            }
        }




    }





