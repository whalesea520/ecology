
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rsSelect" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExcute" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MessagerSettingCominfo" class="weaver.messager.MessagerSettingCominfo" scope="page" />
<%
Enumeration  e = request.getParameterNames();
while (e.hasMoreElements()) {
    String paramName = (String)e.nextElement();
    String paramValue = Util.null2String((String)request.getParameter(paramName));
    
    if("accSaveDir".equals(paramName)&&(paramValue==null||"".equals(paramValue)))
    	paramValue = " ";

    if("PingInterval".equals(paramName)){
    	int pingInterval = Util.getIntValue(Util.null2String(paramValue),15);
    	paramValue = ((pingInterval>0?pingInterval:15)*1000)+"";
    }
    
    rsSelect.executeSql("select count(id) from HrmMessagerSetting where name='"+paramName+"'");
    rsSelect.next();
   	if(rsSelect.getInt(1)>0) {
   		if(paramValue!=null&&!"".equals(paramValue)&&paramName!=null&&!"".equals(paramName))
   			rsExcute.executeSql("update  HrmMessagerSetting set value='"+paramValue+"' where name='"+paramName+"'");	
   	} else {
   		if(paramValue!=null&&!"".equals(paramValue)&&paramName!=null&&!"".equals(paramName))
   			rsExcute.executeSql("insert into HrmMessagerSetting (name,value) values ('"+paramName+"','"+paramValue+"')");	
   	}
   	if("msgServerAddr".equals(paramName)){ //当得到msgServerAddr后，将去修改msgServer中部分信息
   		String strSql="";
   		if(paramValue!=null&&!"".equals(paramValue)){
   	   		strSql="update ofproperty set propValue='"+paramValue+"' where name='xmpp.domain'";
	   		rsExcute.executeSql(strSql);
   		}
   		
   		if(paramValue!=null&&!"".equals(paramValue)){
   			strSql="update ofproperty set propValue='sysadmin@"+paramValue+"' where name='admin.authorizedJIDs'";
   			rsExcute.executeSql(strSql);
   		}
   		
   		String poolname=GCONST.getServerName();
   		
   		String conStr=Prop.getPropValue("weaver",poolname+".url");
   		String conUser=Prop.getPropValue("weaver",poolname+".user");
   		String conPsw=Prop.getPropValue("weaver",poolname+".password"); 
   		
   		String dbconfig = "";
   		if(rsExcute.getDBType().equals("oracle")){
   			//jdbc:oracle:thin:ecology/ecology@192.168.0.246:1521:ecology
   			int pos = conStr.indexOf("@");
   	   		int pos2=conStr.lastIndexOf(":");
   	   		String dataUrl=conStr.substring(pos+1,pos2);
   	   		
   	   		int pos3=conStr.lastIndexOf(":");
   	   		String strDatabase=conStr.substring(pos3+1);
   	   		
   			dbconfig = "jdbc:oracle:thin:"+conUser+"/"+conPsw+"@"+dataUrl+":"+strDatabase+"";
   		} else {
   			//jdbc:sqlserver://192.168.0.246:1433;DatabaseName=ecology;user=sa;password=test
   			int pos = conStr.indexOf("://");
   	   		int pos2=conStr.indexOf(";",pos);
   	   		String dataUrl=conStr.substring(pos+3,pos2);
   	   		
   	   		int pos3=conStr.toLowerCase().indexOf("databasename=")+13;
   	   		String strDatabase=conStr.substring(pos3);
   	   		
   			dbconfig = "jdbc:jtds:sqlserver://"+dataUrl+"/"+strDatabase+";user="+conUser+";password="+conPsw+"";
   		}
   		
   		strSql="update ofproperty set propValue='"+dbconfig+"' where name='jdbcProvider.connectionString'";
   	
   		rsExcute.executeSql(strSql);
   	}
    out.println(paramName+":"+paramValue+"<br>");
}
MessagerSettingCominfo.updateCache();
response.sendRedirect("BaseSetting.jsp");

%>