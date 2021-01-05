<%@page language="java" contentType="text/html; charset=UTF-8" %>
    <%@page import="net.sf.json.*"%>
        <%@page import="weaver.hrm.*" %>
            <%@page import="weaver.systeminfo.*" %>
                <%@page import="weaver.general.*" %>
                    <%@page import="java.util.*"%>
                        <%@page import="weaver.mobile.plugin.ecology.service.HrmResourceService"%>
                            <%@page import="weaver.hrm.settings.ChgPasswdReminder,weaver.hrm.settings.RemindSettings" %>
                            <%@page import="weaver.social.im.SocialImLogin"%>
                            <%@ page import="weaver.file.*" %>
                            <%@page import="weaver.general.BaseBean"%>
                                <jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

                                <%  
                                
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json;charset=UTF-8");
    BaseBean log = new BaseBean();
    FileUpload fu = new FileUpload(request); 
    String loginId = Util.null2String(fu.getParameter("loginid"));
    String sessionKey = Util.null2String(fu.getParameter("sessionKey"));
    
    JSONObject result1 = new JSONObject();
    result1.put("canremind","0");
    result1.put("canpass","0");
    result1.put("passwdelse","0");
    result1.put("isUpPswd","0");
    result1.put("isAdmin","0");
    result1.put("isAdaccount","0");
    out.println(result1);
    
    HrmResourceService hrs = new HrmResourceService();
    //loginId=hrs.getOaloginid();
    User user = hrs.getUserById(hrs.getUserId(loginId));
    //int id = user.getUID();
    int id = hrs.getUserId(loginId);
    String userid = "" + id;
    JSONObject result = new JSONObject();
    ChgPasswdReminder reminder=new ChgPasswdReminder();
    RemindSettings settings=reminder.getRemindSettings();
    
    String loginMustUpPswd = Util.null2String(settings.getLoginMustUpPswd());
    String PasswordChangeReminderstr = Util.null2String(settings.getPasswordChangeReminder());
    //log.writeLog("===========================loginMustUpPswd===="+loginMustUpPswd);
    //log.writeLog("===========================PasswordChangeReminderstr===="+PasswordChangeReminderstr);
    boolean PasswordChangeReminder = false;
    if("1".equals(PasswordChangeReminderstr)){
        PasswordChangeReminder = true;
    }
    int passwdReminder = 0;
    if(PasswordChangeReminder){
        passwdReminder = 1;
    }
    result.put("passwdReminder",passwdReminder+"");
    String ChangePasswordDays = settings.getChangePasswordDays();
    String DaysToRemind = settings.getDaysToRemind();
    //User user= new User(id);
    //设置session
    //request.getSession(true).setAttribute("weaver_user@bean",user);
    //设置sessionKey
    //SocialImLogin.recordSocialIMSessionkey(id,sessionKey,1);
    String passwdchgdate = "";
    int passwdchgeddate = 0;
    int passwdreminddatenum = 0;
    int passwdelse = 0;
    String passwdreminddate = "";
    String canpass = "0";
    String canremind = "0";
    
    boolean isUpPswd = false;
    //判断是否开启强制修改密码
    if("1".equals(loginMustUpPswd)){
        String loginSql="select COUNT(id) from HrmSysMaintenanceLog where relatedid = "+id+" and operatetype = 6 and operateitem = 60 and exists (select 1 from HrmResource where id = "+id+") and CAST(operatedesc as varchar"+(RecordSet.getDBType().equals("oracle")?"2":"")+"(100)) = 'y'";
        log.writeLog("===========================loginSql===="+loginSql);
        RecordSet.executeSql(loginSql);
        if(RecordSet.next()) isUpPswd = RecordSet.getInt(1) <= 0;
    }
    
    if(isUpPswd){
        result.put("isUpPswd","1"); 
    }else
    {
        result.put("isUpPswd","0");
    }

    if(user.isAdmin()){
        result.put("isAdmin","1");
    }else{
        result.put("isAdmin","0");  
    }
    
    String isadaccount="";
    RecordSet.executeSql("select isadaccount from HrmResource where id = "+id);
    if(RecordSet.next()){
        isadaccount=Util.null2String(RecordSet.getString("isadaccount"));
    }
    if(isadaccount.equals("1")){  //ad用户 不用提醒
        result.put("isAdaccount","1");
    }else{
        result.put("isAdaccount","0");
    }
    
    if(!isUpPswd){
        if(PasswordChangeReminder){
            RecordSet.executeSql("select passwdchgdate from hrmresource where id = "+id);
            if(RecordSet.next()){
                passwdchgdate = RecordSet.getString(1);
                passwdchgeddate = TimeUtil.dateInterval(passwdchgdate,TimeUtil.getCurrentDateString());
                
                if(passwdchgeddate < Integer.parseInt(ChangePasswordDays)){
                    canpass = "1";
                    result.put("canpass","1");
                }
                passwdreminddate = TimeUtil.dateAdd(passwdchgdate,Integer.parseInt(ChangePasswordDays)-Integer.parseInt(DaysToRemind));
                try {
                    passwdreminddatenum = TimeUtil.dateInterval(passwdreminddate,TimeUtil.getCurrentDateString());
                } catch(Exception ex) {
                    passwdreminddatenum = 0;
                }
                passwdelse = Integer.parseInt(DaysToRemind) - passwdreminddatenum;
                result.put("passwdelse",passwdelse);
                if(passwdreminddatenum >= 0){
                    canremind = "1";
                    result.put("canremind","1");                
                }
            }else{
                result.put("canremind","0");
                result.put("canpass","0");
                result.put("passwdelse","0");
            }
        }else{
            result.put("canremind","0");
            result.put("canpass","0");
            result.put("passwdelse","0");
        }
    }
    //out.println(result);
%>