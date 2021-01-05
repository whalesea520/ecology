<%@page import="weaver.file.FileUpload"%><%@page import="weaver.general.BaseBean"%><%@page import="weaver.conn.RecordSet"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%
if(true){
	FileUpload fu = new FileUpload(request);
	String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
	String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
	User user= HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype);
	
	boolean isSystemer=false;
	if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
	
	if(isSystemer){
		String eid=Util.null2String(request.getParameter("eid"));	
		String ebaseid=Util.null2String(request.getParameter("ebaseid"));
		String hpid=Util.null2String(request.getParameter("hpid"));

		RecordSet rs_Setting = new RecordSet();
		String sql = "";

		int grjk = Util.getIntValue(request.getParameter("grjk"), 0);	
		int bxxx = Util.getIntValue(request.getParameter("bxxx"), 0);	
		int bxtb = Util.getIntValue(request.getParameter("bxtb"), 0);
		String eTitleValue = Util.null2String(request.getParameter("_eTitel_"+eid));
		
		//sql = "update hpElement set title='"+StringEscapeUtils.escapeSql(eTitleValue)+"' where id="+eid;
		//new BaseBean().writeLog(sql);
		//rs_Setting.executeSql(sql);
		
		sql = "select * from fnaBudgetAssistant where ebaseid = '"+StringEscapeUtils.escapeSql(ebaseid)+"' and eid = "+eid;
		//new BaseBean().writeLog(sql);
		rs_Setting.executeSql(sql);
		String updateSql1 = "";
		if(rs_Setting.next()){
			updateSql1 = "update fnaBudgetAssistant "+
					" set hpid="+hpid+", "+
					" grjk="+grjk+", "+
					" bxxx="+bxxx+", "+
					" bxtb="+bxtb+" "+
					" where ebaseid = '"+StringEscapeUtils.escapeSql(ebaseid)+"' and eid = "+eid;
			
		}else{
			updateSql1 = "insert into fnaBudgetAssistant (eid, hpid, ebaseid, grjk, "+
				" bxxx, bxtb) "+
			" values ("+eid+","+hpid+", '"+StringEscapeUtils.escapeSql(ebaseid)+"', "+grjk+", "+
				" "+bxxx+", "+bxtb+")";
			
		}
		//new BaseBean().writeLog(updateSql1);
		rs_Setting.executeSql(updateSql1);
	}
}
%>
<%@ include file="/page/element/operationCommon.jsp"%>
<%

































%>