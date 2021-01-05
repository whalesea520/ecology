
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.sql.Timestamp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.ArrayList,java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="java.lang.reflect.Method" %>
<%@ page import="weaver.login.LicenseCheckLogin" %>
<%@page import="weaver.hrm.settings.ChgPasswdReminder"%>
<%@page import="weaver.hrm.settings.RemindSettings"%>
<%@page import="weaver.file.Prop"%>
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<%


String result = "";


User user = HrmUserVarify.getUser (request , response) ;
String userOffline = Util.null2String((String)session.getAttribute("userOffline"));	
if(userOffline.equals("1")){
	//强制下线
	String loginfile = Util.getCookie(request , "loginfileweaver") ;
	Map userSessions = (Map) application.getAttribute("userSessions");
	if (userSessions != null) {
		Map logmessages = (Map) application.getAttribute("logmessages");
		if (logmessages != null)logmessages.remove("" + user.getUID());
		session.removeValue("moniter");
		session.removeValue("WeaverMailSet");
		userSessions.remove(user.getUID());
		session.invalidate();
	}%>
	<script language="javascript">
		window.top.Dialog.alert("<%=SystemEnv.getErrorMsgName(175,user.getLanguage())%>",function(){
			window.top.location="<%="/Refresh.jsp?loginfile="+loginfile+"&message=175"%>";
		});		
	</script>
	<%
  return;
}

//更新人员在线统计时间戳

LicenseCheckLogin onlineu = new LicenseCheckLogin();
onlineu.setOutLineDate(user.getUID());

result = getRemindMenu(user);
 
out.clearBuffer();
out.print(result);
%>


<%!
private String getRemindMenu(User user) {
    if(user == null) {
        return null;
    }
    String s = "";

    int bgcnt = 4;
    int bgindex = 4;

    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    RecordSet rs = new RecordSet();
    
    String sql="";
    int userid=user.getUID();
    int usertype= Util.getIntValue(user.getLogintype(),1)-1;   
	String userID = String.valueOf(user.getUID());
		//int userid=user.getUID();
		String belongtoshow = "";				
		rs.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(rs.next()){
			belongtoshow = rs.getString("belongtoshow");
		}
		String userIDAll = String.valueOf(user.getUID());	
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}
    //Remind
    //sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" group by a.type";
		if("1".equals(belongtoshow)){
    if(rs.getDBType().equals("oracle")){
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid in ("+userIDAll+") and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid in ("+userIDAll+") AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1))or (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid in("+userIDAll+")))  or type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
    } else {
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid in ("+userIDAll+") and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid in ("+userIDAll+") AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1)) or (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid in("+userIDAll+"))) or type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
    }
		}else{
		  if(rs.getDBType().equals("oracle")){
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid="+userid+" AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1)) or  (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid ="+userid+")) or  type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
    } else {
        sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid="+userid+" AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1)) or (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid ="+userid+")) or type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
    }
		}
    rs.executeSql(sql);
    
    ChgPasswdReminder reminder = new ChgPasswdReminder();
    RemindSettings settings = reminder.getRemindSettings();
    //int index=0;
    while(rs.next()){
    	if("2".equals(rs.getString("type"))){//生日
    		
            String birth_valid = settings.getBirthvalid();
            String birth_remindmode = settings.getBirthremindmode();
            
            if (birth_valid != null && birth_valid.equals("1")) {
                if (birth_remindmode != null && birth_remindmode.equals("1")){
                }else{
                	continue;
                }
            }else{
                	continue;
            }
    	}
    	bgindex++;
        if(rs.getString("statistic").equals("y")) {   
           int count=rs.getInt("count");
           StringBuffer sfcm = new StringBuffer();
           //sfcm.append("<li><div   style='width:100%;'>");
           sfcm.append("<li url='"+rs.getString("link")+"'>");
          // sfcm.append("<a class='lfMenuItem' href='");
          // sfcm.append(rs.getString("link"));
           //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
		   sfcm.append(SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage()));
		   sfcm.append("<span>"+count+"</span>");
           //sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
          // sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
           sfcm.append("</li>");
           s += sfcm.toString();
        } else {
            StringBuffer sfcm = new StringBuffer();
             //sfcm.append("<li><div   style='width:100%;'>");
             sfcm.append("<li url='"+rs.getString("link")+"'>");
            //sfcm.append("<a class='lfMenuItem' href='");
           // sfcm.append(rs.getString("link"));
            //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
            //sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
            //sfcm.append(" target=\"" + "mainFrame" + "\" >");
            //sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
            //sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
			sfcm.append(SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage()));
			// sfcm.append("</div>");
          //  sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
           // sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
            sfcm.append("</li>");
            s += sfcm.toString();
            //s += "<tree text=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"\" icon=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\" action=\""+rs.getString("link")+"\" />";
        }
    }
    if(s.equals("")){
    	s="<span class='nodata'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</span>";
    }
    //s +="</ul>";
    return s;
}
%>
