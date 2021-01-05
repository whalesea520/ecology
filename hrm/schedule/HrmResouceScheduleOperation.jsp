<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page"/>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String opera=Util.fromScreen(request.getParameter("operation"),user.getLanguage());
int id=Util.getIntValue(request.getParameter("id"),0);
String Resouce_id=Util.fromScreen(request.getParameter("Resouce_id"),user.getLanguage());
char separator = Util.getSeparator() ;

if(opera.equals("save")){
	if(!HrmUserVarify.checkUserRight("HrmResouceScheduleEdit:Edit", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	String monstarttime1=Util.fromScreen(request.getParameter("monstarttime1"),user.getLanguage());
	String monendtime1=Util.fromScreen(request.getParameter("monendtime1"),user.getLanguage());
	String monstarttime2=Util.fromScreen(request.getParameter("monstarttime2"),user.getLanguage());
	String monendtime2=Util.fromScreen(request.getParameter("monendtime2"),user.getLanguage());

	String tuestarttime1=Util.fromScreen(request.getParameter("tuestarttime1"),user.getLanguage());
	String tueendtime1=Util.fromScreen(request.getParameter("tueendtime1"),user.getLanguage());
	String tuestarttime2=Util.fromScreen(request.getParameter("tuestarttime2"),user.getLanguage());
	String tueendtime2=Util.fromScreen(request.getParameter("tueendtime2"),user.getLanguage());
	
	String wedstarttime1=Util.fromScreen(request.getParameter("wedstarttime1"),user.getLanguage());
	String wedendtime1=Util.fromScreen(request.getParameter("wedendtime1"),user.getLanguage());
	String wedstarttime2=Util.fromScreen(request.getParameter("wedstarttime2"),user.getLanguage());
	String wedendtime2=Util.fromScreen(request.getParameter("wedendtime2"),user.getLanguage());
	
	String thustarttime1=Util.fromScreen(request.getParameter("thustarttime1"),user.getLanguage());
	String thuendtime1=Util.fromScreen(request.getParameter("thuendtime1"),user.getLanguage());
	String thustarttime2=Util.fromScreen(request.getParameter("thustarttime2"),user.getLanguage());
	String thuendtime2=Util.fromScreen(request.getParameter("thuendtime2"),user.getLanguage());
	
	String fristarttime1=Util.fromScreen(request.getParameter("fristarttime1"),user.getLanguage());
	String friendtime1=Util.fromScreen(request.getParameter("friendtime1"),user.getLanguage());
	String fristarttime2=Util.fromScreen(request.getParameter("fristarttime2"),user.getLanguage());
	String friendtime2=Util.fromScreen(request.getParameter("friendtime2"),user.getLanguage());

	String satstarttime1=Util.fromScreen(request.getParameter("satstarttime1"),user.getLanguage());
	String satendtime1=Util.fromScreen(request.getParameter("satendtime1"),user.getLanguage());
	String satstarttime2=Util.fromScreen(request.getParameter("satstarttime2"),user.getLanguage());
	String satendtime2=Util.fromScreen(request.getParameter("satendtime2"),user.getLanguage());

	String sunstarttime1=Util.fromScreen(request.getParameter("sunstarttime1"),user.getLanguage());
	String sunendtime1=Util.fromScreen(request.getParameter("sunendtime1"),user.getLanguage());
	String sunstarttime2=Util.fromScreen(request.getParameter("sunstarttime2"),user.getLanguage());
	String sunendtime2=Util.fromScreen(request.getParameter("sunendtime2"),user.getLanguage());
	
	String totaltime="";
	totaltime=Util.addTime(Util.subTime(monendtime1,monstarttime1),Util.subTime(monendtime2,monstarttime2));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(tueendtime1,tuestarttime1),Util.subTime(tueendtime2,tuestarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(wedendtime1,wedstarttime1),Util.subTime(wedendtime2,wedstarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(thuendtime1,thustarttime1),Util.subTime(thuendtime2,thustarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(friendtime1,fristarttime1),Util.subTime(friendtime2,fristarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(satendtime1,satstarttime1),Util.subTime(satendtime2,satstarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(sunendtime1,sunstarttime1),Util.subTime(sunendtime2,sunstarttime2)));

	String procedurepara=id+"" + separator + Resouce_id + separator + 
		monstarttime1 + separator+ monendtime1 + separator + monstarttime2 + separator + monendtime2 + separator +
		tuestarttime1 + separator+ tueendtime1 + separator + tuestarttime2 + separator + tueendtime2 + separator +
		wedstarttime1 + separator+ wedendtime1 + separator + wedstarttime2 + separator + wedendtime2 + separator +
		thustarttime1 + separator+ thuendtime1 + separator + thustarttime2 + separator + thuendtime2 + separator +
		fristarttime1 + separator+ friendtime1 + separator + fristarttime2 + separator + friendtime2 + separator +
		satstarttime1 + separator+ satendtime1 + separator + satstarttime2 + separator + satendtime2 + separator +
		sunstarttime1 + separator+ sunendtime1 + separator + sunstarttime2 + separator + sunendtime2 + separator + 
		totaltime + separator+ "2" ;
	RecordSet.executeProc("HrmSchedule_Update",procedurepara);
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName("ResouceSchedule");
      	log.setOperateType("2");
//      log.setOperateDesc("HrmSchedule_Update");
      	log.setOperateItem("15");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	
      	response.sendRedirect("/hrm/schedule/HrmResouceSchedule2.jsp?id="+id);
}
if(opera.equals("delete")){
	if(!HrmUserVarify.checkUserRight("HrmResouceScheduleEdit:Delete", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
	RecordSet.executeProc("HrmSchedule_Delete",id+"");
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName("ResouceSchedule");
      	log.setOperateType("3");
//      log.setOperateDesc("HrmSchedule_Delete");
      	log.setOperateItem("15");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
      	
	response.sendRedirect("/hrm/schedule/HrmResouceScheduleList.jsp");
}

if(opera.equals("insert")){
	if(!HrmUserVarify.checkUserRight("HrmResouceScheduleAdd:Add", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}	
	RecordSet.executeProc("HrmSchedule_Select_CheckExist",Resouce_id+separator+"2");
	if(!RecordSet.next()){
	String monstarttime1=Util.fromScreen(request.getParameter("monstarttime1"),user.getLanguage());
	String monendtime1=Util.fromScreen(request.getParameter("monendtime1"),user.getLanguage());
	String monstarttime2=Util.fromScreen(request.getParameter("monstarttime2"),user.getLanguage());
	String monendtime2=Util.fromScreen(request.getParameter("monendtime2"),user.getLanguage());

	String tuestarttime1=Util.fromScreen(request.getParameter("tuestarttime1"),user.getLanguage());
	String tueendtime1=Util.fromScreen(request.getParameter("tueendtime1"),user.getLanguage());
	String tuestarttime2=Util.fromScreen(request.getParameter("tuestarttime2"),user.getLanguage());
	String tueendtime2=Util.fromScreen(request.getParameter("tueendtime2"),user.getLanguage());
	
	String wedstarttime1=Util.fromScreen(request.getParameter("wedstarttime1"),user.getLanguage());
	String wedendtime1=Util.fromScreen(request.getParameter("wedendtime1"),user.getLanguage());
	String wedstarttime2=Util.fromScreen(request.getParameter("wedstarttime2"),user.getLanguage());
	String wedendtime2=Util.fromScreen(request.getParameter("wedendtime2"),user.getLanguage());
	
	String thustarttime1=Util.fromScreen(request.getParameter("thustarttime1"),user.getLanguage());
	String thuendtime1=Util.fromScreen(request.getParameter("thuendtime1"),user.getLanguage());
	String thustarttime2=Util.fromScreen(request.getParameter("thustarttime2"),user.getLanguage());
	String thuendtime2=Util.fromScreen(request.getParameter("thuendtime2"),user.getLanguage());
	
	String fristarttime1=Util.fromScreen(request.getParameter("fristarttime1"),user.getLanguage());
	String friendtime1=Util.fromScreen(request.getParameter("friendtime1"),user.getLanguage());
	String fristarttime2=Util.fromScreen(request.getParameter("fristarttime2"),user.getLanguage());
	String friendtime2=Util.fromScreen(request.getParameter("friendtime2"),user.getLanguage());

	String satstarttime1=Util.fromScreen(request.getParameter("satstarttime1"),user.getLanguage());
	String satendtime1=Util.fromScreen(request.getParameter("satendtime1"),user.getLanguage());
	String satstarttime2=Util.fromScreen(request.getParameter("satstarttime2"),user.getLanguage());
	String satendtime2=Util.fromScreen(request.getParameter("satendtime2"),user.getLanguage());

	String sunstarttime1=Util.fromScreen(request.getParameter("sunstarttime1"),user.getLanguage());
	String sunendtime1=Util.fromScreen(request.getParameter("sunendtime1"),user.getLanguage());
	String sunstarttime2=Util.fromScreen(request.getParameter("sunstarttime2"),user.getLanguage());
	String sunendtime2=Util.fromScreen(request.getParameter("sunendtime2"),user.getLanguage());
	
	String totaltime="";
	totaltime=Util.addTime(Util.subTime(monendtime1,monstarttime1),Util.subTime(monendtime2,monstarttime2));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(tueendtime1,tuestarttime1),Util.subTime(tueendtime2,tuestarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(wedendtime1,wedstarttime1),Util.subTime(wedendtime2,wedstarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(thuendtime1,thustarttime1),Util.subTime(thuendtime2,thustarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(friendtime1,fristarttime1),Util.subTime(friendtime2,fristarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(satendtime1,satstarttime1),Util.subTime(satendtime2,satstarttime2)));
	totaltime=Util.addTime(totaltime,Util.addTime(Util.subTime(sunendtime1,sunstarttime1),Util.subTime(sunendtime2,sunstarttime2)));
	
	String procedurepara=Resouce_id + separator + 
		monstarttime1 + separator+ monendtime1 + separator + monstarttime2 + separator + monendtime2 + separator +
		tuestarttime1 + separator+ tueendtime1 + separator + tuestarttime2 + separator + tueendtime2 + separator +
		wedstarttime1 + separator+ wedendtime1 + separator + wedstarttime2 + separator + wedendtime2 + separator +
		thustarttime1 + separator+ thuendtime1 + separator + thustarttime2 + separator + thuendtime2 + separator +
		fristarttime1 + separator+ friendtime1 + separator + fristarttime2 + separator + friendtime2 + separator +
		satstarttime1 + separator+ satendtime1 + separator + satstarttime2 + separator + satendtime2 + separator +
		sunstarttime1 + separator+ sunendtime1 + separator + sunstarttime2 + separator + sunendtime2 + separator + 
		totaltime + separator+ "2" ;
	RecordSet.executeProc("HrmSchedule_Insert",procedurepara);
	RecordSet.next();
	id=RecordSet.getInt(1);
	log.resetParameter();
	log.setRelatedId(id);
        log.setRelatedName("ResouceSchedule");
      	log.setOperateType("1");
//      log.setOperateDesc("HrmSchedule_Insert");
      	log.setOperateItem("15");
      	log.setOperateUserid(user.getUID());
      	log.setClientAddress(request.getRemoteAddr());
      	log.setSysLogInfo();
     	response.sendRedirect("/hrm/schedule/HrmResouceSchedule2.jsp?id="+id);
    }
    else{
    	%>
    	<font color=red><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(369,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(423,user.getLanguage())%>...
    	</font><a href="/hrm/schedule/HrmResouceScheduleList.jsp"><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></a>
    	<%
    }
}

String fromResouce_id=Util.null2String(request.getParameter("fromResouce_id"));
String toResouce_id=Util.null2String(request.getParameter("toResouce_id"));
String fromid="";
String toid=""; 
if(opera.equals("copy")){
	String procedurepara="";
	RecordSet.execute("HrmSchedule_Select_CheckExist",fromResouce_id+separator+"2");
	if(RecordSet.next()){
		fromid=RecordSet.getString("id");
		String monstarttime1=RecordSet.getString("monstarttime1");
		String monendtime1=RecordSet.getString("monendtime1");
		String monstarttime2=RecordSet.getString("monstarttime2");
		String monendtime2=RecordSet.getString("monendtime2");
		String tuestarttime1=RecordSet.getString("tuestarttime1");
		String tueendtime1=RecordSet.getString("tueendtime1");
		String tuestarttime2=RecordSet.getString("tuestarttime2");
		String tueendtime2=RecordSet.getString("tueendtime2");
		String wedstarttime1=RecordSet.getString("wedstarttime1");
		String wedendtime1=RecordSet.getString("wedendtime1");
		String wedstarttime2=RecordSet.getString("wedstarttime2");
		String wedendtime2=RecordSet.getString("wedendtime2");
		String thustarttime1=RecordSet.getString("thustarttime1");
		String thuendtime1=RecordSet.getString("thuendtime1");
		String thustarttime2=RecordSet.getString("thustarttime2");
		String thuendtime2=RecordSet.getString("thuendtime2");
		String fristarttime1=RecordSet.getString("fristarttime1");
		String friendtime1=RecordSet.getString("friendtime1");
		String fristarttime2=RecordSet.getString("fristarttime2");
		String friendtime2=RecordSet.getString("friendtime2");
		String satstarttime1=RecordSet.getString("satstarttime1");
		String satendtime1=RecordSet.getString("satendtime1");
		String satstarttime2=RecordSet.getString("satstarttime2");
		String satendtime2=RecordSet.getString("satendtime2");
		String sunstarttime1=RecordSet.getString("sunstarttime1");
		String sunendtime1=RecordSet.getString("sunendtime1");
		String sunstarttime2=RecordSet.getString("sunstarttime2");
		String sunendtime2=RecordSet.getString("sunendtime2");
		String totaltime=RecordSet.getString("totaltime");
			
		procedurepara=toResouce_id + separator + 
		monstarttime1 + separator+ monendtime1 + separator + monstarttime2 + separator + monendtime2 + separator +
		tuestarttime1 + separator+ tueendtime1 + separator + tuestarttime2 + separator + tueendtime2 + separator +
		wedstarttime1 + separator+ wedendtime1 + separator + wedstarttime2 + separator + wedendtime2 + separator +
		thustarttime1 + separator+ thuendtime1 + separator + thustarttime2 + separator + thuendtime2 + separator +
		fristarttime1 + separator+ friendtime1 + separator + fristarttime2 + separator + friendtime2 + separator +
		satstarttime1 + separator+ satendtime1 + separator + satstarttime2 + separator + satendtime2 + separator +
		sunstarttime1 + separator+ sunendtime1 + separator + sunstarttime2 + separator + sunendtime2 + separator + 
		totaltime + separator+ "2" ;
	}
	RecordSet.execute("HrmSchedule_Select_CheckExist",toResouce_id+separator+"2");
	if(RecordSet.next()){
		toid=RecordSet.getString("id");
	}
	if(toid.equals("")){
		RecordSet.executeProc("HrmSchedule_Insert",procedurepara);
		RecordSet.next();
		id=RecordSet.getInt(1);
		log.resetParameter();
		log.setRelatedId(id);
        	log.setRelatedName("ResouceSchedule");
      		log.setOperateType("5");
//      	log.setOperateDesc("HrmSchedule_Copy");
      		log.setOperateItem("15");
      		log.setOperateUserid(user.getUID());
      		log.setClientAddress(request.getRemoteAddr());
      		log.setSysLogInfo();
     		response.sendRedirect("/hrm/schedule/HrmResouceScheduleList.jsp");	
	}
	else{
		procedurepara=toid + separator + procedurepara;
		RecordSet.executeProc("HrmSchedule_Update",procedurepara);
		id=Util.getIntValue(toid,0);
		log.resetParameter();
		log.setRelatedId(id);
        	log.setRelatedName("ResouceSchedule");
      		log.setOperateType("5");
//      	log.setOperateDesc("HrmSchedule_Copy");
      		log.setOperateItem("15");
      		log.setOperateUserid(user.getUID());
      		log.setClientAddress(request.getRemoteAddr());
      		log.setSysLogInfo();
     		response.sendRedirect("/hrm/schedule/HrmResouceScheduleList.jsp");
	}
}
%>