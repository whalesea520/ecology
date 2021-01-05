
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="CheckItemComInfo" class="weaver.hrm.check.CheckItemComInfo" scope="page" />
<%

String operation = request.getParameter("operation");
char separator = Util.getSeparator();

/**************************/
int userid = user.getUID();
Calendar todaycal = Calendar.getInstance ();

    Date newdate = new Date();
    long datetime = newdate.getTime();
    Timestamp timestamp = new Timestamp(datetime);
    String CurrentDate = (timestamp.toString()).substring(0, 4) + "-" + (timestamp.toString()).substring(5, 7) + "-" + (timestamp.toString()).substring(8, 10);
    String CurrentTime = (timestamp.toString()).substring(11, 13) + ":" + (timestamp.toString()).substring(14, 16) + ":" + (timestamp.toString()).substring(17, 19);

String userpara = ""+userid+separator+CurrentDate+separator+CurrentTime;
/**************************/
String id = Util.null2String(request.getParameter("id"));
String inceptipaddressA = Util.null2String(request.getParameter("inceptipaddressA"));
String inceptipaddressB = Util.null2String(request.getParameter("inceptipaddressB"));
String inceptipaddressC = Util.null2String(request.getParameter("inceptipaddressC"));
String inceptipaddressD = Util.null2String(request.getParameter("inceptipaddressD"));

String endipaddressA = Util.null2String(request.getParameter("endipaddressA"));
String endipaddressB = Util.null2String(request.getParameter("endipaddressB"));
String endipaddressC = Util.null2String(request.getParameter("endipaddressC"));
String endipaddressD = Util.null2String(request.getParameter("endipaddressD"));



String strbegin=new StringBuffer().append(inceptipaddressA).append(".").append(inceptipaddressB).append(".").append(inceptipaddressC).append(".").append(inceptipaddressD).toString();

String strend=new StringBuffer().append(endipaddressA).append(".").append(endipaddressB).append(".").append(endipaddressC).append(".").append(endipaddressD).toString();

String segmentdesc = Util.null2String(request.getParameter("segmentdesc"));//备注
String para="";
	if(operation.equals("add")){
    if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
	para = strbegin+separator+strend+separator+userpara+separator+segmentdesc;

	 rs.executeProc("HrmnetworkSegStr_Insert",para);

	 rs.execute("select max(id) from HrmnetworkSegStr ");
	 if(rs.next())id = rs.getString(1);
				CheckItemComInfo.removeCheckCache() ;
                SysMaintenanceLog.resetParameter();
                SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
                SysMaintenanceLog.setRelatedName(strbegin+"--"+strend);
                SysMaintenanceLog.setOperateType("1");
                SysMaintenanceLog.setOperateDesc("HrmnetworkSegStr_Insert,"+para);
                SysMaintenanceLog.setOperateItem("101");
                SysMaintenanceLog.setOperateUserid(user.getUID());
                SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
                SysMaintenanceLog.setSysLogInfo();
        response.sendRedirect("NetworkSegmentStrategyAdd.jsp?isclose=1");
	}

	if(operation.equals("edit")){
    if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
		para = id+separator+strbegin+separator+strend+separator+segmentdesc;
		rs.executeProc("HrmnetworkSegStr_Update",para);
		
		CheckItemComInfo.removeCheckCache() ;
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		SysMaintenanceLog.setRelatedName(strbegin+"--"+strend);
		SysMaintenanceLog.setOperateType("2");
		SysMaintenanceLog.setOperateDesc("HrmnetworkSegStr_Update,"+para);
		SysMaintenanceLog.setOperateItem("101");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("NetworkSegmentStrategyEdit.jsp?isclose=1");
	}
	
	if(operation.equals("delete")){
    if(!HrmUserVarify.checkUserRight("NetworkSegmentStrategy:All",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
        String sqldelete = "select * from HrmnetworkSegStr where id ="+id;
		RecordSet.executeSql(sqldelete);
		RecordSet.next();
		String inceptipaddress = RecordSet.getString("inceptipaddress");
		String endipaddress = RecordSet.getString("endipaddress");
		rs.execute("HrmnetworkSegStr_Delete",id);

		CheckItemComInfo.removeCheckCache() ;
		SysMaintenanceLog.resetParameter();
		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		SysMaintenanceLog.setRelatedName(inceptipaddress+"--"+endipaddress);
		SysMaintenanceLog.setOperateType("3");
		SysMaintenanceLog.setOperateDesc("HrmnetworkSegStr_Delete,"+id);
		SysMaintenanceLog.setOperateItem("101");
		SysMaintenanceLog.setOperateUserid(user.getUID());
		SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		SysMaintenanceLog.setSysLogInfo();
		response.sendRedirect("NetworkSegmentStrategy.jsp?isclose=1");
		
	}

%>