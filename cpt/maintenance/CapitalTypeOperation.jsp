<%@page import="net.sf.json.JSONObject"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %> 
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}

JSONObject jsonObject=new JSONObject();

int id = Util.getIntValue(request.getParameter("id"),-1);
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage()).trim();
String description = Util.fromScreen(request.getParameter("description"),user.getLanguage());
String typecode = Util.fromScreen(request.getParameter("typecode"),user.getLanguage());
if(operation.equals("add")||operation.equals("edit")){
	
	RecordSet.executeSql("select * from CptCapitalType where name='"+name+"' and id!="+id);

	if(RecordSet.next()){
		//out.println("<script>alert('资产类型："+name+"已存在！');history.back();</script>");
		//return;
		jsonObject.put("msgid", 11);
		out.print(jsonObject.toString());
	}else{
		
		if(operation.equals("add")){
			if(!HrmUserVarify.checkUserRight("CptCapitalTypeAdd:Add", user)){
		    		//response.sendRedirect("/notice/noright.jsp");
		    		//return;
		    		jsonObject.put("msgid", 12);
		    		out.print(jsonObject.toString());
			}else{
				char separator = Util.getSeparator() ;

				String para = name + separator + description;
				RecordSet.executeProc("CptCapitalType_Insert",para);
				id=0;

				RecordSet.executeSql("select max(id) from CptCapitalType");
				if(RecordSet.next()){
					id = RecordSet.getInt(1);
				}

				RecordSet.executeSql("update CptCapitalType set typecode = '" + typecode + "' where id = " + id);

			    // uncommented and modified the "operate item" to 44 by lupeng 2004-07-21 for TD546.
			      SysMaintenanceLog.resetParameter();
			      SysMaintenanceLog.setRelatedId(id);
			      SysMaintenanceLog.setRelatedName(name);
			      SysMaintenanceLog.setOperateType("1");
			      SysMaintenanceLog.setOperateDesc("CptCapitalType_Insert,"+para);
			      SysMaintenanceLog.setOperateItem("44");
			      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalTypeAdd:Add"));
			      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			      SysMaintenanceLog.setSysLogInfo();
			    // end.

				CapitalTypeComInfo.removeCapitalTypeCache();
				out.print(jsonObject.toString());
			}
		     
		 }else if(operation.equals("edit")){
			if(!HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Edit", user)){
		    		//response.sendRedirect("/notice/noright.jsp");
		    		//return;
		    		jsonObject.put("msgid", 12);
		    		out.print(jsonObject.toString());
			}else{
				char separator = Util.getSeparator() ;
				String para = ""+id + separator + name + separator + description;
				RecordSet.executeProc("CptCapitalType_Update",para);

				RecordSet.executeSql("update CptCapitalType set typecode = '" + typecode + "' where id = " + id);

			    // uncommented and modified the "operate item" to 44 by lupeng 2004-07-21 for TD546.
			      SysMaintenanceLog.resetParameter();
			      SysMaintenanceLog.setRelatedId(id);
			      SysMaintenanceLog.setRelatedName(name);
			      SysMaintenanceLog.setOperateType("2");
			      SysMaintenanceLog.setOperateDesc("CptCapitalType_Update,"+para);
			      SysMaintenanceLog.setOperateItem("44");
			      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalTypeEdit:Edit"));
			      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			      SysMaintenanceLog.setSysLogInfo();
			    // end.

					CapitalTypeComInfo.removeCapitalTypeCache();
			 	//response.sendRedirect("CptCapitalType.jsp");
					out.print(jsonObject.toString());
			}
		     
		 }
		
	}
}else if(operation.equals("delete")){
 	if(!HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Delete", user)){
    		//response.sendRedirect("/notice/noright.jsp");
    		//return;
    		jsonObject.put("msgid", 12);
    		out.print(jsonObject.toString());
	}else{
		 char separator = Util.getSeparator() ;
			String para = ""+id;
			RecordSet.executeProc("CptCapitalType_Delete",para);

			//added by lupeng for TD547.
			if (RecordSet.next() && (Util.null2String(RecordSet.getString(1))).equals("-1")) {
				//response.sendRedirect("CptCapitalTypeEdit.jsp?id="+para+"&msgid=20");
		    	//return;
		    	jsonObject.put("msgid", 20);
				out.print(jsonObject.toString());
			}else{
				// uncommented and modified the "operate item" to 44 by lupeng 2004-07-21 for TD546.
			      SysMaintenanceLog.resetParameter();
			      SysMaintenanceLog.setRelatedId(id);
			      SysMaintenanceLog.setRelatedName(name);
			      SysMaintenanceLog.setOperateType("3");
			      SysMaintenanceLog.setOperateDesc("CptCapitalType_Delete,"+para);
			      SysMaintenanceLog.setOperateItem("44");
			      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalTypeEdit:Delete"));
			      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			      SysMaintenanceLog.setSysLogInfo();
			     // end.

				CapitalTypeComInfo.removeCapitalTypeCache();
			 	//response.sendRedirect("CptCapitalType.jsp");
				out.print(jsonObject.toString());
			}
			//end
	}
     
 }else if(operation.equals("batchdelete")){
	 	if(!HrmUserVarify.checkUserRight("CptCapitalTypeEdit:Delete", user)){
	    		//response.sendRedirect("/notice/noright.jsp");
	    		//return;
	    		jsonObject.put("msgid", 12);
	    		out.print(jsonObject.toString());
		}else{
			String ids = Util.null2String(request.getParameter("id"));
		 	String[] arr= Util.TokenizerString2(ids, ",");
			for(int i=0;i<arr.length;i++){
				id = Util.getIntValue( arr[i]);
				String para = ""+id;
				RecordSet.executeProc("CptCapitalType_Delete",para);

				
			  SysMaintenanceLog.resetParameter();
		      SysMaintenanceLog.setRelatedId(id);
		      SysMaintenanceLog.setRelatedName(name);
		      SysMaintenanceLog.setOperateType("3");
		      SysMaintenanceLog.setOperateDesc("CptCapitalType_Delete,"+para);
		      SysMaintenanceLog.setOperateItem("44");
		      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalTypeEdit:Delete"));
		      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		      SysMaintenanceLog.setSysLogInfo();
				
			}

			CapitalTypeComInfo.removeCapitalTypeCache();
		 	//response.sendRedirect("CptCapitalType.jsp");
		 	out.print(jsonObject.toString());
		}
}

%>
