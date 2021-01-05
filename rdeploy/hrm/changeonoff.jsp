<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@page import="weaver.common.MessageUtil"%>
<%@page import="weaver.general.Util"%>
<%@page import="java.util.Random"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<%!
/***
 * 随机数密码
 * @param n
 * @return
 */
public static String random(int n) {
  Random ran = new Random();
  if (n == 1) {
      return String.valueOf(ran.nextInt(10));
  }
  int bitField = 0;
  char[] chs = new char[n];
  for (int i = 0; i < n; i++) {
      while(true) {
          int k = ran.nextInt(10);
          if( (bitField & (1 << k)) == 0) {
              bitField |= 1 << k;
              chs[i] = (char)(k + '0');
              break;
          }
      }
  }
  return new String(chs);
}
%>
<%
//校验名称是否存在
String method=request.getParameter("method");
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
int languageid = user.getLanguage();
if("sendToMobile".equals(method)){
    String content = request.getParameter("method");
    String mobile = request.getParameter("method");
    MessageUtil.sendSMS(mobile,content);
    return;
}
String onoff = RdeployHrmSetting.getSettingInfo("onoff");
String value = "1";
String updateStatus = "";
if("1".equals(onoff)){
    value = "2";
    updateStatus =",status = '1'";
    RecordSet.executeSql("select mobile,id,loginid from HrmResource where isnewuser ='1'");
    
    String comname = CompanyComInfo.getCompanyname("1");
	String reUrl = request.getRequestURL().toString();
	String invUrl =reUrl.substring(0,reUrl.indexOf("/rdeploy/hrm/changeonoff.jsp"))+"/rdeploy/hrm/RdMobileLogin.jsp";
    while(RecordSet.next()){
        String password_tmp =random(4);
        String password = Util.getEncrypt(password_tmp);
		String id =RecordSet.getString("id");
        rs.executeSql("  UPDATE HrmResource SET  PASSWORD = '"+password+"' WHERE ID ="+id);
	    String content = SystemEnv.getHtmlLabelName(125167 ,languageid)+""+comname+SystemEnv.getHtmlLabelName(125168 ,languageid)+RecordSet.getString("loginid")+SystemEnv.getHtmlLabelName(125169  ,languageid)
		+password_tmp+SystemEnv.getHtmlLabelName(125170 ,languageid)+invUrl+"?uid="+id;
        String mobile = RecordSet.getString(1);
        MessageUtil.sendSMS(mobile,content);
    }
}else if ("2".equals(onoff)){
    value = "1";
}

if(RecordSet.executeSql(" update HrmResource set isnewuser = null"+updateStatus+" where isnewuser ='1' ")){
    String tempSql = "update rdeployhrmsetting set setvalue = '"+value+"' where setname ='onoff'";
	if(RecordSet.executeSql(tempSql)){
		RdeployHrmSetting.changeSettingInfo();
		out.println("{\"success\":\"1\"}");
	}else{
		out.println("{\"success\":\"0\"}");
	}
	if("1".equals(onoff)){
	    ResourceComInfo.removeResourceCache();
	}
}else{
	out.println("{\"success\":\"0\"}");
}	
%>