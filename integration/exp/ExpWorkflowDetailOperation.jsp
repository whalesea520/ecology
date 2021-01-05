<%@ page buffer="4kb" autoFlush="true" errorPage="/notice/error.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%> 
<%@ page import="weaver.integration.logging.Logger"%>
<%@ page import="weaver.integration.logging.LoggerFactory"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ExpInfoCominfo" class="weaver.expdoc.ExpInfoCominfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
	  response.sendRedirect("/notice/noright.jsp");
	  return;
}

Logger log = LoggerFactory.getLogger();

weaver.workflow.workflow.WorkflowComInfo workflowComInfo=new WorkflowComInfo();
//FileUpload fu = new FileUpload(request);
String isDialog = Util.null2String(request.getParameter("isdialog"));
String backto = Util.null2String(request.getParameter("backto"));//返回类型
String operation = Util.fromScreen(request.getParameter("operation"),user.getLanguage());
String id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String workflowid = Util.fromScreen(request.getParameter("workflowid"),user.getLanguage());
String expid = Util.fromScreen(request.getParameter("expid"),user.getLanguage());

String workflowname =workflowComInfo.getWorkflowname(workflowid) ;
String workflowtype = workflowComInfo.getWorkflowtype(workflowid);

char separator = Util.getSeparator() ;

int userid = user.getUID();
String createdate = TimeUtil.getCurrentTimeString();
String tempOperation="";
String maxId="";
if(operation.equals("addAndNext")){
	tempOperation=operation;
}
if(operation.equals("add")){
	//System.out.println("insert into exp_workflowDetail(workflowid,workflowname,workflowtype,expid,createdate,creator) values("+workflowid+",'"+workflowname+"',"+workflowtype+","+expid+",'"+createdate+"',"+userid+")");
	RecordSet.executeSql("insert into exp_workflowDetail(workflowid,workflowname,workflowtype,expid,createdate,creator) values("+workflowid+",'"+workflowname+"','"+workflowtype+"','"+expid+"','"+createdate+"','"+userid+"')");
	
	int maxid=0;
	RecordSet.executeSql("select  max(id) from exp_workflowDetail");
	if(RecordSet.next()){
	maxid = RecordSet.getInt(1);
	}

	String para = workflowid + separator + workflowname + separator + workflowtype + separator + 
	expid+ separator + createdate + separator + userid;
	 SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(maxid);
     SysMaintenanceLog.setRelatedName(workflowname);
     SysMaintenanceLog.setOperateType("1");
     SysMaintenanceLog.setOperateDesc("exp_workflowDetail_Insert,"+para);
     SysMaintenanceLog.setOperateItem("158");
     SysMaintenanceLog.setOperateUserid(user.getUID());
     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
     SysMaintenanceLog.setSysLogInfo();
}
else if(operation.equals("edit")){
	RecordSet.execute("update exp_workflowDetail set workflowid='"+workflowid+"',expid='"+expid+"',createdate = '"+createdate+"',workflowname = '"+workflowname+"',creator = "+userid+" where id= "+id);
	
	String para =""+id + separator+workflowid + separator + workflowname + separator + workflowtype + separator + 
	expid+ separator + createdate + separator + userid;
	SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
     SysMaintenanceLog.setRelatedName(workflowname);
     SysMaintenanceLog.setOperateType("2");
     SysMaintenanceLog.setOperateDesc("exp_workflowDetail_Update,"+para);
     SysMaintenanceLog.setOperateItem("158");
     SysMaintenanceLog.setOperateUserid(user.getUID());
     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
     SysMaintenanceLog.setSysLogInfo();
}
else if(operation.equals("delete")){
  
	List ids = Util.TokenizerString(id,",");
	if(null!=ids&&ids.size()>0)	{
		for(int i = 0;i<ids.size();i++)		{
			String tempid = Util.null2String((String)ids.get(i));
			if(!"".equals(tempid))	
			{
				String tempworkflowname="";
				RecordSet.execute("select *  from exp_workflowDetail where id = "+tempid);
				if(RecordSet.next()){
					tempworkflowname=workflowComInfo.getWorkflowname(RecordSet.getString("workflowid")) ;
				}
				
				RecordSet.execute("delete from exp_workflowDetail where id = "+tempid);
				RecordSet.execute("delete from exp_workflowFieldDBMap where rgworkflowid = "+tempid);  //删除数据库方案流程导出字段转换关系
				RecordSet.execute("delete from exp_workflowFieldXMLMap where rgworkflowid = "+tempid);//删除XML方案流程导出字段转换关系
				
				 String para =""+tempid;
				 SysMaintenanceLog.resetParameter();
			     SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
			     SysMaintenanceLog.setRelatedName(tempworkflowname);
			     SysMaintenanceLog.setOperateType("3");
			     SysMaintenanceLog.setOperateDesc("exp_workflowDetail_delete,"+para);
			     SysMaintenanceLog.setOperateItem("158");
			     SysMaintenanceLog.setOperateUserid(user.getUID());
			     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
			     SysMaintenanceLog.setSysLogInfo();
			}
		}
	}
}else if(operation.equals("addAndNext")){
	RecordSet.executeSql("insert into exp_workflowDetail(workflowid,workflowname,workflowtype,expid,createdate,creator) values("+workflowid+",'"+workflowname+"','"+workflowtype+"','"+expid+"','"+createdate+"','"+userid+"')");
	RecordSet.executeSql("select max(id) from exp_workflowDetail");
	if(RecordSet.next()){
		maxId=RecordSet.getInt(1)+"";
	}
	
	String para = workflowid + separator + workflowname + separator + workflowtype + separator + 
	expid+ separator + createdate + separator + userid;
	SysMaintenanceLog.resetParameter();
     SysMaintenanceLog.setRelatedId(Util.getIntValue(maxId));
     SysMaintenanceLog.setRelatedName(workflowname);
     SysMaintenanceLog.setOperateType("1");
     SysMaintenanceLog.setOperateDesc("exp_workflowDetail_Insert,"+para);
     SysMaintenanceLog.setOperateItem("158");
     SysMaintenanceLog.setOperateUserid(user.getUID());
     SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
     SysMaintenanceLog.setSysLogInfo();
}else if(operation.equals("editxml")){
	String xmltext =request.getParameter("fieldattr");
	ConnStatement statement = null;
	try{
	statement=new ConnStatement();
	
	String sql = "";
	RecordSet.executeSql("select id from exp_workflowXML where rgworkflowid='"+id+"'");
	if(RecordSet.next()){
		sql = "update exp_workflowXML set "+
				"xmltext=?"+
				" where "+
				" rgworkflowid=?";
	}else{
		sql = "insert into exp_workflowXML(xmltext,rgworkflowid) values(?,?)";		
	}
		
		statement.setStatementSql(sql);

		statement.setString(1, xmltext);
		statement.setInt(2, Util.getIntValue(id,-1));
		if(!id.equals("")){
		statement.executeUpdate();
		
		RecordSet.executeSql("delete from exp_workflowFieldXMLMap where rgworkflowid='"+id+"'");
		RecordSet.executeSql("delete from exp_FieldMap_cs where rgworkflowid='"+id+"' and protype='0' ");
		
		String[] mainFieldNames =request.getParameterValues("mainFieldNames");
		String[] mainFieldIds = request.getParameterValues("mainFieldIds");
		String[] fieldhtmltypes =request.getParameterValues("fieldhtmltypes");
		String[] types = request.getParameterValues("types");
		String[] mainfileddbnames = request.getParameterValues("mainfileddbnames");
		if(mainFieldIds!=null){
			for(int i=0;i<mainFieldIds.length;i++){
				String fieldid=mainFieldIds[i];
				String fieldhtmltype=fieldhtmltypes[i];
				String fieldtype=types[i];
				String fieldName=mainFieldNames[i];
				String mainfileddbname = mainfileddbnames[i];
				String valueType = Util.fromScreen(request.getParameter("fieldRules_"+fieldid),user.getLanguage());
				RecordSet.executeSql("insert into exp_workflowFieldXMLMap(rgworkflowid,fieldid,fieldhtmltype,fieldtype,fieldName,valueType,fileddbname) values("+id+",'"+fieldid+"','"+fieldhtmltype+"','"+fieldtype+"','"+fieldName+"','"+valueType+"','"+mainfileddbname+"')");
				
				if(fieldhtmltype.equals("4")&&fieldtype.equals("1"))  //check值
			    {
			    	int maxid=-1;
			    	RecordSet.executeSql("select max(id) from exp_workflowFieldXMLMap");
			    	if(RecordSet.next()){
			    		maxid=RecordSet.getInt(1);
			    	}
			    	String fieldvalue=Util.null2String(request.getParameter("checkedValue_"+fieldid));
			    	String convertvalue=Util.null2String(request.getParameter("checkedValueTo_"+fieldid));
			    	String fieldvalue1=Util.null2String(request.getParameter("uncheckedValue_"+fieldid));
			    	String convertvalue1=Util.null2String(request.getParameter("uncheckedValueTo_"+fieldid));
			    	//System.out.println("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue+"','"+convertvalue+"','0')");
			    	RecordSet.executeSql("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue+"','"+convertvalue+"','0')");
			    	//System.out.println("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue+"','"+convertvalue+"','0')");
			    	RecordSet.executeSql("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue1+"','"+convertvalue1+"','0')");
			    }else if(fieldhtmltype.equals("5")&&fieldtype.equals("1")){//选择框
			    	int maxid=-1;
			    	RecordSet.executeSql("select max(id) from exp_workflowFieldXMLMap");
			    	if(RecordSet.next()){
			    		maxid=RecordSet.getInt(1);
			    	}
			    	String[] fieldvalues =request.getParameterValues("selectValue_"+fieldid);
					String[] convertvalues = request.getParameterValues("selectValueTo_"+fieldid);
					if(fieldvalues!=null&&fieldvalues.length>0)
					{
						for(int ii=0;ii<fieldvalues.length;ii++){
						String fieldvalue=Util.null2String(fieldvalues[ii]);
				    	String convertvalue=Util.null2String(convertvalues[ii]);
			    	    RecordSet.executeSql("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue+"','"+convertvalue+"','0')");
					
						}
					}
			    }
				
			}
		}
		
		}
		
	}catch(Exception e){
	    log.error(e);
		
	}finally{
		try{
			statement.close();
		}catch(Exception e){
		    log.error(e);
		}
	}
}else if(operation.equals("editDB")){
	String sql = "";
	//删除原来的数据
	RecordSet.executeSql("delete exp_workflowFieldDBMap where rgworkflowid='"+id+"'");
	RecordSet.executeSql("delete from exp_FieldMap_cs where rgworkflowid='"+id+"' and protype='1' ");
	String[] mainFieldNames =request.getParameterValues("mainFieldNames");
	String[] mainFieldIds = request.getParameterValues("mainFieldIds");
	String[] fieldhtmltypes =request.getParameterValues("fieldhtmltypes");
	String[] types = request.getParameterValues("types");
	String[] expfieldNames = request.getParameterValues("expfieldName");
	String[] expfieldtypes = request.getParameterValues("expfieldtype");
	String[] mainfileddbnames = request.getParameterValues("mainfileddbnames");
   if(mainFieldIds!=null && expfieldNames!=null){
	   for(int i=0;i<mainFieldIds.length;i++){
		   String fieldid=mainFieldIds[i];
			String fieldhtmltype=fieldhtmltypes[i];
			String fieldtype=types[i];
			String fieldName=mainFieldNames[i];
			String valueType = Util.fromScreen(request.getParameter("fieldRules_"+fieldid),user.getLanguage());
			String expfieldname =expfieldNames[i] ;
			String expfieldtype = expfieldtypes[i];
			String mainfileddbname = mainfileddbnames[i];
	sql = "insert into exp_workflowFieldDBMap("+
			"rgworkflowid,"+
			"fieldid,"+
			"fieldhtmltype,"+
			"fieldtype,"+
			"fieldName,"+
			"valueType,"+
			"expfieldname,"+
			"expfieldtype,"+
			"fileddbname"+
			
			")values("+
	    	 "'"+id+"',"+
	    	 "'"+fieldid+"',"+
	    	 "'"+fieldhtmltype+"',"+
	    	 "'"+fieldtype+"',"+
	    	 "'"+fieldName+"',"+
	    	 "'"+valueType+"',"+
	    	 "'"+expfieldname+"',"+
	    	 "'"+expfieldtype+"',"+
	    	 "'"+mainfileddbname+"'"+
	        
	    	 ")";
		RecordSet.executeSql(sql);
		
		if(fieldhtmltype.equals("4")&&fieldtype.equals("1"))  //check值
	    {
	    	int maxid=-1;
	    	RecordSet.executeSql("select max(id) from exp_workflowFieldDBMap");
	    	if(RecordSet.next()){
	    		maxid=RecordSet.getInt(1);
	    	}
	    	String fieldvalue=Util.null2String(request.getParameter("checkedValue_"+fieldid));
	    	String convertvalue=Util.null2String(request.getParameter("checkedValueTo_"+fieldid));
	    	String fieldvalue1=Util.null2String(request.getParameter("uncheckedValue_"+fieldid));
	    	String convertvalue1=Util.null2String(request.getParameter("uncheckedValueTo_"+fieldid));
	    	RecordSet.executeSql("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue+"','"+convertvalue+"','1')");
	    	RecordSet.executeSql("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue1+"','"+convertvalue1+"','1')");
	    }else if(fieldhtmltype.equals("5")&&fieldtype.equals("1")){//选择框
	    	int maxid=-1;
	    	RecordSet.executeSql("select max(id) from exp_workflowFieldDBMap");
	    	if(RecordSet.next()){
	    		maxid=RecordSet.getInt(1);
	    	}
	    	String[] fieldvalues =request.getParameterValues("selectValue_"+fieldid);
			String[] convertvalues = request.getParameterValues("selectValueTo_"+fieldid);
			if(fieldvalues!=null&&fieldvalues.length>0)
			{
				for(int ii=0;ii<fieldvalues.length;ii++){
				String fieldvalue=Util.null2String(fieldvalues[ii]);
		    	String convertvalue=Util.null2String(convertvalues[ii]);
	    	    RecordSet.executeSql("insert into exp_FieldMap_cs(rgworkflowid,fieldMapid,fieldvalue,convertvalue,protype) values("+id+",'"+maxid+"','"+fieldvalue+"','"+convertvalue+"','1')");
			
				}
			}
	    }
		
	   }
   }
		//
		RecordSet.executeSql("delete from exp_wfDBMainFixField where rgworkflowid='"+id+"'");
		
		String[] mFixFieldNames =request.getParameterValues("mfixfieldName");
		String[] mFixFieldTypes = request.getParameterValues("mfixfieldtype");
		String[] mainFixValues =request.getParameterValues("mainfixValue");
	
		if(mFixFieldNames!=null){
			   for(int i=0;i<mFixFieldNames.length;i++){
				   String expfieldname=mFixFieldNames[i];
					String expfieldtype=mFixFieldTypes[i];
					String value=mainFixValues[i];
					String talbetype="0";

					if(!"".equals(expfieldname) && !"".equals(value)){
						sql = "insert into exp_wfDBMainFixField("+
						"rgworkflowid,"+
						"expfieldname,"+
						"expfieldtype,"+
						"value,"+
						"talbetype"+
						
						")values("+
				    	 "'"+id+"',"+
				    	 "'"+expfieldname+"',"+
				    	 "'"+expfieldtype+"',"+
				    	 "'"+value+"',"+
				    	 "'"+talbetype+"'"+
				    	 ")";
						RecordSet.executeSql(sql);
					}
			   }
		}
		String[] dtFixFieldNames =request.getParameterValues("dtfixfieldName");
		
		String[] dtFixFieldTypes = request.getParameterValues("dtfixfieldtype");
		String[] dtFixValues =request.getParameterValues("dtfixValue");
		
		if(dtFixFieldNames!=null){
			   for(int i=0;i<dtFixFieldNames.length;i++){
				   String expfieldname=dtFixFieldNames[i];
					String expfieldtype=dtFixFieldTypes[i];
					String value=dtFixValues[i];
					String talbetype="1";
					if(!"".equals(expfieldname) && !"".equals(value)){
						sql = "insert into exp_wfDBMainFixField("+
						"rgworkflowid,"+
						"expfieldname,"+
						"expfieldtype,"+
						"value,"+
						"talbetype"+
						
						")values("+
				    	 "'"+id+"',"+
				    	 "'"+expfieldname+"',"+
				    	 "'"+expfieldtype+"',"+
				    	 "'"+value+"',"+
				    	 "'"+talbetype+"'"+
				    	 ")";
						RecordSet.executeSql(sql);
					}
			   }
		}

	
}
ExpInfoCominfo.removeExpCache();
if("1".equals(isDialog)){
%>
<script language=javascript >
try{
	//var parentWin = parent.getParentWindow(window);
	var parentWin = parent.parent.getParentWindow(parent);
	parentWin.location.href="/integration/exp/ExpWorkflowList.jsp?backto=<%=backto%>&operation=<%=tempOperation%>&id=<%=maxId%>";
	parentWin.closeDialog();
}
catch(e){
}
</script>
<%
}
else
response.sendRedirect("/integration/exp/ExpWorkflowList.jsp?backto="+backto+"&operation="+tempOperation+"&id="+maxId);
%>