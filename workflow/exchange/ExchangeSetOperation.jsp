<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.conn.RecordSet" %>
<%@ page import="java.util.*,weaver.workflow.action.*,org.apache.commons.lang3.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<%
String OperateItem = "200";
String typename = "";
String operation = Util.null2String(request.getParameter("operation"));
String dialog = Util.null2String(request.getParameter("dialog"));
char separator = Util.getSeparator() ;
String otype = Util.null2String(request.getParameter("otype"));
String tosetting = Util.null2String(request.getParameter("tosetting"));
String type = Util.null2String(request.getParameter("type"));
String changetype = Util.null2String(request.getParameter("changetype"));

String wfid = Util.null2String(request.getParameter("wfid"));
String wftypeid = Util.null2String(request.getParameter("wftypeid"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));

String tempparams = "&wfid="+wfid+"&wftypeid="+wftypeid+"&subcompanyid="+subcompanyid;

String outdatatablename = "wfec_outdatawfset";
String intdataablename = "wfec_indatawfset";

String tablename = "";
if(type.equals("0")){
	tablename = outdatatablename ;
	typename = "数据接受";
}else{
	tablename = intdataablename ;
	typename = "数据发送";
}
//System.out.println("operation = "+operation+"  type = "+type);
if(operation.equals("add"))
{
   String title = Util.null2String(request.getParameter("title"));
   String workflowid = Util.null2String(request.getParameter("workflowid"));
   String subcomid = Util.null2String(request.getParameter("subcompanyid"));

   String sql = "insert into "+tablename+" (name,workflowid,subcompanyid,status)"+ 
   				" values ('"+title+"',"+Util.getIntValue(workflowid)+","+Util.getIntValue(subcomid,0)+",'0')";	
   rs.executeSql(sql);
   int maxid = 0 ;
   rs.executeSql("select max(id) from "+tablename);
   if(rs.next()){
	   maxid = Util.getIntValue(rs.getString(1));
   }
   if(type.equals("0")){
	   rs.executeSql("update "+tablename+" set periodvalue=1 where id="+maxid);
   }
   try{
	   SysMaintenanceLog.resetParameter();
	   SysMaintenanceLog.setRelatedId(maxid);
	   SysMaintenanceLog.setRelatedName(title);
	   SysMaintenanceLog.setOperateType("1");//1 new  2:eidt 3:del
	   SysMaintenanceLog.setOperateDesc("新建"+typename+"设置："+title);
	   SysMaintenanceLog.setOperateItem(OperateItem);
	   SysMaintenanceLog.setOperateUserid(user.getUID());
	   SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	   SysMaintenanceLog.setSysLogInfo();
   }catch(Exception e){
	   
   }
   if("1".equals(dialog)){
	   if(tosetting.equals("1")){
		   response.sendRedirect("ExchangeSetEdit.jsp?id="+maxid+"&changetype="+type+"&tosetting=1"+tempparams);
	   }else{
          response.sendRedirect("ExchangeSetAdd.jsp?isclose=1"+tempparams);
	   }
   }	
}
else if(operation.equals("edit")){//保存对表单中流程的修改

	String title = Util.null2String(request.getParameter("title"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String subcomid = Util.null2String(request.getParameter("subcompanyid"));

	int id = Util.getIntValue(request.getParameter("id"));
	String sql = "update "+tablename+" set name='"+title+"',workflowid="+Util.getIntValue(workflowid)+",subcompanyid="+Util.getIntValue(subcomid,0)+" where id="+id;	
	rs.executeSql(sql);
	//System.out.println(sql);
	try{
		   SysMaintenanceLog.resetParameter();
		   SysMaintenanceLog.setRelatedId(id);
		   SysMaintenanceLog.setRelatedName(title);
		   SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
		   SysMaintenanceLog.setOperateDesc("修改"+title+"("+typename+")基本设置");
		   SysMaintenanceLog.setOperateItem(OperateItem);
		   SysMaintenanceLog.setOperateUserid(user.getUID());
		   SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		   SysMaintenanceLog.setSysLogInfo();
   }catch(Exception e){
	   
   }
	if(tosetting.equals("1")){
		response.sendRedirect("ExchangeSetEdit.jsp?id="+id+"&changetype="+changetype+"&tosetting=1");
	}else{
		response.sendRedirect("ExchangeSetEdit.jsp?id="+id+"&changetype="+changetype+"&isclose=1");
	}
}
else if(operation.equals("delete"))
{
  	int id = Util.getIntValue(request.getParameter("id"));
  	RecordSet.executeSql("select id,type,name,workflowid from wfex_view where id="+id+" and type="+type);
	RecordSet.next();
	type = RecordSet.getString("type");
	String title = RecordSet.getString("name");
	String workflowid = Util.null2String(RecordSet.getString("workflowid"));
	if(type.equals("0")){
		tablename = outdatatablename ;
	}else{
		tablename = intdataablename ;
	}
    RecordSet.execute("delete from "+tablename+" where id="+id+"");
    if(type.equals("0")){
    	RecordSet.executeSql("delete from wfec_outdatasetdetail where mainid="+id);
    	RecordSet.executeSql("delete from wfec_outdatawfdetail where mainid="+id);
    }else{
    	RecordSet.executeSql("delete from wfec_indatadetail where mainid="+id);
    	RecordSet.executeSql("delete from wfec_indatasetdetail where mainid="+id);
    }
	DeleteAction(workflowid,type);
    try{
 	   SysMaintenanceLog.resetParameter();
 	   SysMaintenanceLog.setRelatedId(id);
 	   SysMaintenanceLog.setRelatedName(title);
 	   SysMaintenanceLog.setOperateType("3");//1 new  2:eidt 3:del
 	   SysMaintenanceLog.setOperateDesc("删除"+typename+"设置："+title);
 	   SysMaintenanceLog.setOperateItem(OperateItem);
 	   SysMaintenanceLog.setOperateUserid(user.getUID());
 	   SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
 	   SysMaintenanceLog.setSysLogInfo();
    }catch(Exception e){
 	   
    }
    response.sendRedirect("managelist.jsp?reflush=1"+tempparams+"");
    
}
else if(operation.equals("deletes"))
{
  	String ids = Util.null2String(request.getParameter("typeids"));
  	ArrayList<String> idsarray = Util.TokenizerString(ids,",");
  	//System.out.println("ids = "+ids +" idsarray.size = "+idsarray.size());
  	try{
	  	for(String _id : idsarray){
	  		String[] tp = Util.TokenizerString2(_id,".");
	  		String tpid = tp[0];
	  		type = tp[1] ;//RecordSet.getString("type");
	    	RecordSet.executeSql("select name,workflowid from wfex_view where id="+tpid+" and type="+type);
	    	RecordSet.next();
	    	String title = RecordSet.getString("name");
			String workflowid = Util.null2String(RecordSet.getString("workflowid"));
	    	if(type.equals("0")){
	    		tablename = outdatatablename ;
	    	}else{
	    		tablename = intdataablename ;
	    	}

	  		RecordSet.executeSql("delete from "+tablename+" where id="+tpid);
	    	//System.out.println("delete from "+tablename+" where id="+tpid);
	    	if(type.equals("0")){
	        	RecordSet.executeSql("delete from wfec_outdatasetdetail where mainid="+tpid);
	        	RecordSet.executeSql("delete from wfec_outdatawfdetail where mainid="+tpid);
	        	//System.out.println("wfec_outdatawfdetail");
	        	typename = "数据接受";
	        }else{
	        	RecordSet.executeSql("delete from wfec_indatadetail where mainid="+tpid);
	        	RecordSet.executeSql("delete from wfec_indatasetdetail where mainid="+tpid);
	        	//System.out.println("wfec_indatadetail");
	        	typename = "数据发送";
	        }
			DeleteAction(workflowid,type);
	    	try{
	    	 	   SysMaintenanceLog.resetParameter();
	    	 	   SysMaintenanceLog.setRelatedId(Util.getIntValue(tpid));
	    	 	   SysMaintenanceLog.setRelatedName(title);
	    	 	   SysMaintenanceLog.setOperateType("3");//1 new  2:eidt 3:del
	    	 	   SysMaintenanceLog.setOperateDesc("删除"+typename+"设置："+title);
	    	 	   SysMaintenanceLog.setOperateItem(OperateItem);
	    	 	   SysMaintenanceLog.setOperateUserid(user.getUID());
	    	 	   SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	    	 	   SysMaintenanceLog.setSysLogInfo();
	    	    }catch(Exception e){
	    	 	   
	    	    }
	  	}
  	}catch(Exception e){
  		//System.out.println(e.getMessage());
  	}
    response.sendRedirect("managelist.jsp?reflush=1"+tempparams);
    
}else if(operation.equals("changestatus")){
	int id = Util.getIntValue(request.getParameter("id"));
	int status = Util.getIntValue(request.getParameter("status"),0);
	RecordSet.execute("update "+tablename+" set status='"+status+"' where id="+id);
	try{
			RecordSet.executeSql("select name from wfex_view where id="+id+" and type="+type);
	    	RecordSet.next();
	    	String title = RecordSet.getString("name");	
	 	   SysMaintenanceLog.resetParameter();
	 	   SysMaintenanceLog.setRelatedId(id);
	 	   SysMaintenanceLog.setRelatedName(title);
	 	   SysMaintenanceLog.setOperateType("2");//1 new  2:eidt 3:del
	 	   SysMaintenanceLog.setOperateDesc("修改"+title+"("+typename+")状态："+(status==1?"启用":"禁用"));
	 	   SysMaintenanceLog.setOperateItem(OperateItem);
	 	   SysMaintenanceLog.setOperateUserid(user.getUID());
	 	   SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	 	   SysMaintenanceLog.setSysLogInfo();
	    }catch(Exception e){
	 	   
	    }
	response.sendRedirect("managelist.jsp?1=1&"+tempparams);
}
%>
<%!
public void DeleteAction(String workflowid,String type){
	RecordSet rs = new RecordSet();
	RecordSet rs1 = new RecordSet();
	ArrayList wfids = new ArrayList();
	String sql = "";
	int count = 0 ;
	sql = "select count(*) from wfex_view where workflowid="+workflowid+" and type="+type;
	rs.executeSql(sql);
	if(rs.next()){
		count = Util.getIntValue(rs.getString(1),0);
	}
	if(count>0){
		//do nothing
	}else{
		wfids.add(workflowid);
		String interfacename = "";
		if(type.equals("0")){//接受
			interfacename = " interfacetype=3 and interfaceid in ('ExchangeApprovalAgree','ExchangeApprovalDisagree') ";
		}else if(type.equals("1")){//发送
			interfacename = " interfacetype=3 and interfaceid='ExchangeSetValueAction' ";
		}
		String activeVersionID = "";
		rs.executeSql("SELECT id ,workflowname , version , activeVersionID FROM workflow_base WHERE version IS NOT NULL and id="+workflowid);
		if(rs.next()){
			activeVersionID = Util.null2String(rs.getString("activeVersionID"));
		}
		if(!activeVersionID.equals("")){
			rs.executeSql("SELECT id ,workflowname , version , activeVersionID FROM workflow_base WHERE activeVersionID="+activeVersionID);
	        while(rs.next()){
	            String wfid = Util.null2String(rs.getString("id"));
	            sql = "select * from wfex_view where workflowid="+wfid+" and type="+type;
	            rs1.executeSql(sql);
	            if(rs1.getCounts()==0){
	            	wfids.add(wfid);
	            }
	            
	        }
		}
		WorkflowActionManager wam = new WorkflowActionManager();
		rs.executeSql("select * from workflowactionset where workflowid in ("+StringUtils.join(wfids,",")+") and "+interfacename );
		while(rs.next()){
			wam.setWorkflowid(Util.getIntValue(workflowid));
			wam.setNodeid(Util.getIntValue(rs.getString("nodeid"),0));
			wam.setNodelinkid(Util.getIntValue(rs.getString("nodelinkid"),0));
			wam.setIspreoperator(Util.getIntValue(rs.getString("ispreoperator"),0));
			wam.doDeleteWsAction(Util.getIntValue(rs.getString(1),0));
		}
	}
}
%>