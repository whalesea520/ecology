
<%@ page language="java" contentType="text/html; charset=utf-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="log" class="weaver.admincenter.homepage.PortalMaintenanceLog" scope="page" />

<%
String ProcPara = "";

String hpid =   Util.null2String(request.getParameter("hpid"));
String method = Util.null2String(request.getParameter("method"));
 

if(method.equals("addShare")){
	boolean flag = false;
	
	String sharetype = Util.null2String(request.getParameter("sharetype"));
	String sharevalues = Util.null2String(request.getParameter("sharevalue"));
	String rolelevel = Util.null2String(request.getParameter("formrolelevel"));
	String seclevel = Util.null2String(request.getParameter("formseclevel"));
	String includeSub = Util.null2String(request.getParameter("includeSub"), "0");
	String jobtitlelevel = Util.null2String(request.getParameter("formjobtitlelevel"));
	String jobtitlesharevalue = Util.null2String(request.getParameter("formjobtitlesharevalue"));
	String sql = "";
	StringBuffer _seclevel = new StringBuffer(Util.null2String(seclevel));
	int index = _seclevel.indexOf("-", 1);
	if (index != -1) {
		_seclevel = _seclevel.replace(index, index+1, ",");
	}
    String[] secList =  Util.TokenizerString2(_seclevel.toString(),",");  
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
             sql = " insert into shareinnerhp (hpid,type,content,seclevel,seclevelmax,sharelevel,includeSub,jobtitlelevel,jobtitlesharevalue) values "+ 
             				" ("+hpid+",'"+sharetype+"','"+value+"','"+minsec+"','"+maxsec+"','"+rolelevel+"','"+includeSub+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"')"   ;
             flag = RecordSet.executeSql(sql);
         
     	 	}
      }else{
    	  sql = " insert into shareinnerhp (hpid,type,content,seclevel,seclevelmax,sharelevel,includeSub,jobtitlelevel,jobtitlesharevalue) values "+ 
   	   			" ("+hpid+",'"+sharetype+"','"+sharevalues+"','"+minsec+"','"+maxsec+"','"+rolelevel+"','"+includeSub+"','"+jobtitlelevel+"','"+jobtitlesharevalue+"')"   ;
		  flag = RecordSet.executeSql(sql);

      }
    log.setItem("PortalPage");
  	log.setType("insert");
  	log.setSql("添加门户共享范围"+hpid);
  	log.setDesc("添加门户共享范围"+hpid);
  	log.setUserid(user.getUID()+"");
  	log.setIp(request.getRemoteAddr());
  	log.setOpdate(TimeUtil.getCurrentDateString());
  	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
  	log.savePortalOperationLog();
    response.sendRedirect("/homepage/maint/HomepageShareAddBrowser.jsp?isclose=1&hpid="+hpid);
	return;

}

if(method.equals("delShare")){
	String ids = Util.null2String(request.getParameter("ids"));
	ids = ids.substring(0, ids.length() - 1);
	String sql="";
	if(!"".equals(ids)){
		sql = "delete from shareinnerhp where id in ("+ids+")";
		RecordSet.execute(sql);
	}
	log.setItem("PortalPage");
  	log.setType("delete");
  	log.setSql(sql);
  	log.setDesc("删除门户共享范围");
  	log.setUserid(user.getUID()+"");
  	log.setIp(request.getRemoteAddr());
  	log.setOpdate(TimeUtil.getCurrentDateString());
  	log.setOptime(TimeUtil.getOnlyCurrentTimeString());
  	log.savePortalOperationLog();
	response.sendRedirect("/homepage/maint/HomepageShare.jsp?&hpid="+hpid);
	return;
}



%>
