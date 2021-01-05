<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>
<jsp:useBean id="OtherInfotypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator();
String procedurepara="";

int id=Util.getIntValue(request.getParameter("id"),0);
String typename=Util.fromScreen(request.getParameter("typename"),user.getLanguage());
String typeremark=Util.fromScreen(request.getParameter("typeremark"),user.getLanguage());

if(opera.equals("insert")){
	if(!HrmUserVarify.checkUserRight("HrmOtherInfoTypeAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara=typename + separator + typeremark ;
	RecordSet.executeProc("HrmOtherInfoType_Insert",procedurepara);
	RecordSet.next();
	id=RecordSet.getInt(1);
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName("typename");
      	log.setOperateType("1");
//      log.setOperateDesc("");
      	log.setOperateItem("34");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	OtherInfotypeComInfo.removeTypeCache();
	response.sendRedirect("/hrm/tools/HrmOtherInfoType.jsp");
}

if(opera.equals("save")){
	if(!HrmUserVarify.checkUserRight("HrmOtherInfoTypeEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara=id+"" + separator + typename + separator + typeremark ;
	RecordSet.executeProc("HrmOtherInfoType_Update",procedurepara);
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName("typename");
      	log.setOperateType("2");
//      log.setOperateDesc("");
      	log.setOperateItem("34");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	OtherInfotypeComInfo.removeTypeCache();
	response.sendRedirect("/hrm/tools/HrmOtherInfoType.jsp");
}

if(opera.equals("delete")){
	if(!HrmUserVarify.checkUserRight("HrmOtherInfoTypeEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	procedurepara=id+"";
	RecordSet.executeProc("HrmOtherInfoType_Delete",procedurepara);
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName("typename");
      	log.setOperateType("3");
//      log.setOperateDesc("");
      	log.setOperateItem("34");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	OtherInfotypeComInfo.removeTypeCache();
	response.sendRedirect("/hrm/tools/HrmOtherInfoType.jsp");
}
%>