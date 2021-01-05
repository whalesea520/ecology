package com.shxiv.dingding.api;

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiAttendanceListRecordRequest;
import com.dingtalk.api.response.OapiAttendanceListRecordResponse;
import com.shxiv.test.DBUtils;
import com.taobao.api.ApiException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * 获取考勤信息
 * Created by Administrator on 2020/1/8.
 */
public class GetKaoQin {
    GetList getList = new GetList();

    public static void KaoQin() {
        List<String> users = new ArrayList<String>();
        GetList getList = new GetList();
        int usersIdList=0;//插入考勤的总条数

        //设置日期格式
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat format2 = new SimpleDateFormat("HH:mm:ss");
        Date today = new Date();//获取今天的日期
        String todayDate1 = format1.format(today);
        Calendar c = Calendar.getInstance();
        c.setTime(today);
        c.add(Calendar.DAY_OF_MONTH, -1);
        Date yesterday = c.getTime();//这是昨天
        String yesterdayDate = format.format(yesterday) + " 00:00:00";

        //数据库连接
        Connection dbConn = DBUtils.getConnection();
        PreparedStatement statement = null;
        ResultSet res = null;
        try {
            //获取用户ID
            String sqlUsers = "select id as userID  from HrmResource \n" +
                    "where  status in (0,1,2,3)  and workcode<>'' and subcompanyid1='80' ";
            statement = dbConn.prepareStatement(sqlUsers);
            res = statement.executeQuery();
            while (res.next()) {
                String userID = String.valueOf(res.getInt("userID"));
                users.add(userID);
            }
            System.out.println("userID集合:" + users.toString());
            List<List<String>> resList = getList.split(users, 50);
            for (int y = 0; y < resList.size(); y++) {
                List<String> usersList = resList.get(y);
                //考勤数据获取
                System.out.println("usersList集合:" + resList.toString());
                for (int j = 0; j < usersList.size(); j++) {
                    GetAccessToken getAccessToken = new GetAccessToken();
                    String accessToken = getAccessToken.accessToken();
                    System.out.println("accessToken:"+accessToken);
                    DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/attendance/listRecord");
                    OapiAttendanceListRecordRequest request = new OapiAttendanceListRecordRequest();
                    request.setCheckDateFrom("2020-01-01 00:00:00");

                    request.setCheckDateTo("2020-01-06 00:00:00");

                    request.setUserIds(usersList);
                    OapiAttendanceListRecordResponse execute = client.execute(request,accessToken);
                    String errmsg = execute.getErrmsg();
                    System.out.println(errmsg);
                    if ("ok".equals(errmsg)) {
                        List<OapiAttendanceListRecordResponse.Recordresult> list = execute.getRecordresult();
                        int listSize=0;
                        listSize+=list.size();
                        System.out.println("listSize:"+listSize);
                                for (int x = 0; x < list.size(); x++) {
                                    //用户ID
                                    String userid = list.get(x).getUserId();
                                    System.out.println("userid:" + userid);
                                    //考勤类型:1签到2签退
                                    int signType = 0;
                                    String sign = list.get(x).getCheckType();
                                    System.out.println("sign:" + sign);
                                    if(sign!=null) {
                                        if (sign.equals("OnDuty")) {
                                            signType = 1;
                                        } else if (sign.equals("OffDuty")) {
                                            signType = 2;
                                        }
                                    }
                                    //考勤日期和时间
                                    Date date = list.get(x).getUserCheckTime();
                                    String dateTime = format1.format(date);
                                    String signDate = format.format(date);
                                    String signTime = format2.format(date);

                                    //打卡结果：Normal：正常;Early：早退;Late：迟到;SeriousLate：严重迟到；Absenteeism：旷工迟到；NotSigned：未打卡
                                    String result = list.get(x).getTimeResult();
//                                  System.out.println("打卡结果:" + result);
                                    if (!result.equals("NotSigned")&& result!=null) {
                                        //查询出该用户的时间
                                        String sql2 = "SELECT signDate,signTime FROM HrmScheduleSign WHERE userid=" + userid;
//                                                + "and signDate in('" + format.format(yesterday) + "','" + format.format(today) + "')";
                                        statement = dbConn.prepareStatement(sql2);
                                        res = statement.executeQuery();
                                        String teDateTime = "";
                                        List<String> listDate = new ArrayList<String>();
                                        while (res.next()) {
                                            String teSignDate = res.getString("signDate");
                                            String teSignTiem = res.getString("signTime");
                                            teDateTime = teSignDate + " " + teSignTiem;
                                            if(!listDate.contains(teDateTime)){
                                                listDate.add(teDateTime);
                                            }
                                        }
//                                        System.out.println("抓取的时间：" + dateTime);
//                                        System.out.println("查询出来的时间集合：" + listDate.toString());
                                        if (!listDate.contains(dateTime)) {
                                            //插入数据
                                            String sql3 = "insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,isInCom) " +
                                                    "values(" + userid + "," + 1 + "," + signType + ",'" + signDate + "','" + signTime + "'," + 1 + ")";
                                            System.out.println("sql1:" + sql3);


                                        }
                                }
                            }
                        }
                    }
                }
            res.close();
            statement.close();
            dbConn.close();
        } catch (ApiException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws ApiException {
        //获取考勤数据
        GetKaoQin.KaoQin();
    }
}


