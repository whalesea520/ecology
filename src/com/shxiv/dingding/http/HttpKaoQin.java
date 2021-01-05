package com.shxiv.dingding.http;

/**
 * Created by Administrator on 2020/1/6.
 */

import com.dingtalk.api.DefaultDingTalkClient;
import com.dingtalk.api.DingTalkClient;
import com.dingtalk.api.request.OapiAttendanceListRecordRequest;
import com.dingtalk.api.response.OapiAttendanceListRecordResponse;
import com.shxiv.dingding.api.GetAccessToken;
import com.shxiv.dingding.api.GetList;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.conn.RecordSet;
import weaver.general.StaticObj;
import weaver.interfaces.schedule.BaseCronJob;

import java.sql.CallableStatement;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class HttpKaoQin extends BaseCronJob {
    public void execute() {
        this.addMessage();
    }


    public void addMessage() {
        Log log = LogFactory.getLog(HttpKaoQin.class.getName());
        log.error("获取钉钉考勤开始——————————————————————");
        RecordSet rss = new RecordSet();
        RecordSet rss1 = new RecordSet();
        GetList getList = new GetList();
        String errmsg = "";
        int usersIdList=0;//获取考勤的总条数

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

//        //过去七天
//        c.setTime(today);
//        c.add(Calendar.DATE, - 7);
//        Date d = c.getTime();
//        String pastDay = format.format(d) + " 00:00:00";
//        System.out.println("过去七天："+pastDay);
        //调用数据源生成jdbc链接
        weaver.interfaces.datasource.DataSource ds = (weaver.interfaces.datasource.DataSource) StaticObj.getServiceByFullname(("datasource.OA"), weaver.interfaces.datasource.DataSource.class);
        //local为配置的数据源标识
        java.sql.Connection conn = ds.getConnection();
        try {
            //用户ID集合
            List<String> users = new ArrayList<String>();
            //获取用户ID
            String sqlUsers = "select id as userID  from HrmResource  where  status in (0,1,2,3)  and workcode<>'' ";
            rss.execute(sqlUsers);
            while (rss.next()) {
                String userID = String.valueOf(rss.getInt("userID"));
                users.add(userID);
            }
            List<List<String>> resList = getList.split(users, 50);
            for (int y = 0; y < resList.size(); y++) {
                //新的用户集合ID
                List<String> usersList = resList.get(y);
                //考勤数据获取
                for (int j = 0; j < usersList.size(); j++) {
                    GetAccessToken getAccessToken = new GetAccessToken();
                    String accessToken = getAccessToken.accessToken();
                    DingTalkClient client = new DefaultDingTalkClient("https://oapi.dingtalk.com/attendance/listRecord");
                    OapiAttendanceListRecordRequest request = new OapiAttendanceListRecordRequest();
                    request.setCheckDateFrom(yesterdayDate);
                    request.setCheckDateTo(todayDate1);
                    request.setUserIds(usersList);
                    OapiAttendanceListRecordResponse execute = client.execute(request,accessToken);
                    errmsg = execute.getErrmsg();
                    if ("ok".equals(errmsg)) {
                        List<OapiAttendanceListRecordResponse.Recordresult> list = execute.getRecordresult();
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
                            //考勤日期和时间
                            Date date = list.get(x).getUserCheckTime();
                            String dateTime = format1.format(date);
                            String signDate = format.format(date);
                            String signTime = format2.format(date);

                            //打卡结果：Normal：正常;Early：早退;Late：迟到;SeriousLate：严重迟到；Absenteeism：旷工迟到；NotSigned：未打卡
                            String result = list.get(x).getTimeResult();
                            if (result!=null) {
                                if (!result.equals("NotSigned")) {
                                    //查询出该用户的时间
                                    String sql = "SELECT signDate,signTime FROM HrmScheduleSign WHERE userid=" + userid
                                            + "and signDate in('" + format.format(yesterday) + "','" + format.format(today) + "')";
                                    rss1.execute(sql);
                                    String teDateTime = "";
                                    List<String> listDate = new ArrayList<String>();
                                    while (rss1.next()) {
                                        String teSignDate = rss1.getString("signDate");
                                        String teSignTiem = rss1.getString("signTime");
                                        teDateTime = teSignDate + " " + teSignTiem;
                                        if (!listDate.contains(teDateTime)) {
                                            listDate.add(teDateTime);
                                        }
                                    }
                                    if (!listDate.contains(dateTime)) {
                                        //插入数据
                                        String sql3 = "insert into HrmScheduleSign(userId,userType,signType,signDate,signTime,isInCom) " +
                                                "values(" + userid + "," + 1 + "," + signType + ",'" + signDate + "','" + signTime + "'," + 1 + ")";
                                        rss1.execute(sql3);
                                        usersIdList+=rss1.getCounts();
                                    }

                                }
                            }
                        }
                    }

                }	
            }
            String call = "{call pro_SignAnalysis()}";
            CallableStatement callStatement = conn.prepareCall(call);
            callStatement.execute();
            int a =callStatement.getUpdateCount();
            log.error("存储过程调用,修改记录： " + a);
            callStatement.close();
        } catch (Exception e) {
            log.error("e错误： " + errmsg);
        }finally {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            log.error("获取钉钉考勤导入成功!共导入:"+usersIdList+"条数据————————————————————");
        }

    }

}

