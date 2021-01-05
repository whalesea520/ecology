
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("intergration:outtersyssetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}
String ProcPara = "";

String sysid =   Util.null2String(request.getParameter("sysid"));
String method = Util.null2String(request.getParameter("method"));
 

if(method.equals("addShare")){
	boolean flag = false;
	
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String sharevalues = Util.null2String(request.getParameter("sharevalue"));
	String rolelevel = Util.null2String(request.getParameter("formrolelevel"));
	String seclevel = Util.null2String(request.getParameter("formseclevel"));
	String jobtitlelevel = Util.null2String(request.getParameter("formjobtitlelevel"));
	String jobtitlesharevalue = Util.null2String(request.getParameter("formjobtitlesharevalue"));
	String sql = "";
    String[] secList =  Util.TokenizerString2(seclevel,"-");  
    String  minsec = "";
    String  maxsec = "";
    
    if("".equals(rolelevel) || rolelevel == null) rolelevel = "-1";
    if("".equals(minsec) || minsec == null) minsec = "0";
    if("".equals(maxsec) || maxsec == null) maxsec = "0";
    if("".equals(sharevalues) || sharevalues == null) sharevalues = "-1";
    
    
    if(secList.length>1){
    	minsec = secList[0];
    	maxsec = secList[1];
    }
      String shareValueList[]  = Util.TokenizerString2(sharevalues,",");
      if(shareValueList.length>0){
          for(String value : shareValueList){
             sql = " insert into shareoutter (sysid,type,content,seclevel,seclevelmax,sharelevel,jobtitlelevel,jobtitlesharevalue) values "+ 
             				" ('"+sysid+"','"+sharetype+"','"+value+"','"+minsec+"','"+maxsec+"','"+rolelevel+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"')"   ;
             flag = RecordSet.executeSql(sql);
         
     	 	}
      }else{
    	  sql = " insert into shareoutter (sysid,type,content,seclevel,seclevelmax,sharelevel,jobtitlelevel,jobtitlesharevalue) values "+ 
   	   			" ('"+sysid+"','"+sharetype+"','"+sharevalues+"','"+minsec+"','"+maxsec+"','"+rolelevel+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"')"   ;
		  flag = RecordSet.executeSql(sql);

      }
  
    response.sendRedirect("/interface/outter/OutterSysShareAddBrowser.jsp?isclose=1&id="+sysid);
	return;

}

if(method.equals("delShare")){
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	String sql="";
	if(!"".equals(ids)){
		sql = "delete from shareoutter where id in ("+ids+")";
		RecordSet.execute(sql);
	}
	
	response.sendRedirect("/interface/outter/OutterSysShare.jsp?&id="+sysid);
	return;
}



%>
