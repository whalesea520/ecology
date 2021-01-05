
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="MenuShareCominfo" class="weaver.page.menu.MenuShareCominfo" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />

<%
String ProcPara = "";

String resourceid =   Util.null2String(request.getParameter("resourceId"));
String resourcetype = Util.null2String(request.getParameter("resourceType"));
String infoid = Util.null2String(request.getParameter("infoid"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String type = Util.null2String(request.getParameter("type"));
String method = Util.null2String(request.getParameter("method"));
 

if(method.equals("addShare")){
	boolean flag = false;
	
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String sharevalues = Util.null2String(request.getParameter("sharevalue"));
	String rolelevel = Util.null2String(request.getParameter("formrolelevel"));
	String seclevel = Util.null2String(request.getParameter("formseclevel"));
	String menutype = Util.null2String(request.getParameter("menutype"));
	String customid = Util.null2String(request.getParameter("customid"));
	String jobtitlelevel = Util.null2String(request.getParameter("formjobtitlelevel"));
	String jobtitlesharevalue = Util.null2String(request.getParameter("formjobtitlesharevalue"));
	String sql = "";
       
        
      String shareValueList[]  = Util.TokenizerString2(sharevalues,",");
      if(shareValueList.length>0){
          for(String value : shareValueList){
             sql = " insert into menushareinfo (resourceid,resourcetype,infoid,menutype,sharetype,sharevalue,seclevel,rolelevel,customid,jobtitlelevel,jobtitlesharevalue) values "+ 
             				" ("+resourceid+","+resourcetype+",'"+infoid+"','"+menutype+"','"+sharetype+"','"+value+"','"+seclevel+"','"+rolelevel+"','"+customid+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"')"   ;
             flag = RecordSet.executeSql(sql);
         
     	 	}
      }else{
    	   sql = " insert into menushareinfo (resourceid,resourcetype,infoid,menutype,sharetype,sharevalue,seclevel,rolelevel,customid,jobtitlelevel,jobtitlesharevalue) values "+ 
			" ("+resourceid+","+resourcetype+",'"+infoid+"','"+menutype+"','"+sharetype+"','"+sharevalues+"','"+seclevel+"','"+rolelevel+"','"+customid+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"')"   ;
			flag = RecordSet.executeSql(sql);

      }
    MenuShareCominfo.reloadCache();
    log.setItem("PortalMenu");
  	log.setType("insert");
  	log.setSql("添加菜单使用限制"+infoid);
  	log.setDesc("添加菜单使用限制"+infoid);
  	log.setUserid(user.getUID()+"");
  	log.setIp(request.getRemoteAddr());
  	log.setOpdate(TimeUtil.getCurrentDateString());
  	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
  	log.savePortalOperationLog();
    response.sendRedirect("/systeminfo/menuconfig/MenuMaintenanceShareAdd.jsp?isclose=1&resourceId="+resourceid+"&resourceType="+resourcetype+"&id="+infoid+"&subCompanyId="+subCompanyId+"&type="+type);
	return;

}

if(method.equals("delShare")){
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	String sql="";
	if(!"".equals(ids)){
		sql = "delete from menushareinfo where id in ("+ids+")";
		RecordSet.execute(sql);
	}
	MenuShareCominfo.reloadCache();
	log.setItem("PortalMenu");
  	log.setType("delete");
  	log.setSql(sql);
  	log.setDesc("删除菜单使用限制");
  	log.setUserid(user.getUID()+"");
  	log.setIp(request.getRemoteAddr());
  	log.setOpdate(TimeUtil.getCurrentDateString());
  	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
  	log.savePortalOperationLog();
	response.sendRedirect("/systeminfo/menuconfig/MenuMaintenanceShareAdd.jsp?isclose=1&resourceId="+resourceid+"&resourceType="+resourcetype+"&id="+infoid+"&subCompanyId="+subCompanyId+"&type="+type);
	return;
}



%>
