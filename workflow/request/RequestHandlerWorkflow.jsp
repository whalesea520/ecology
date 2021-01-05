<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />

<%
int userid=user.getUID();
String worktypeid=request.getParameter("worktypeid");
String workflowid=request.getParameter("workflowid");
String url=request.getParameter("url");
String needall=request.getParameter("needall");//1：添加自定义；0：删除自定义
String style="insert";
//获取自定义流程信息
String sql="select selectedworkflow , isuserdefault from workflow_RequestUserDefault where userid="+userid;
//System.out.println(sql);
String selectedworkflow="";
String isuserdefault="0";//自定义流程是否启动
RecordSet.executeSql(sql);
while(RecordSet.next()){
	style="update";
	selectedworkflow=RecordSet.getString("selectedworkflow");
	isuserdefault=RecordSet.getString("isuserdefault");
}
if(needall.equals("1")){
	
	String[] swfs=selectedworkflow.split("\\|");
	boolean b=true;
	for(String swf:swfs){
		if(swf.equalsIgnoreCase(worktypeid)){
			b=false;
			break;
		}
	}
	if(b){
		selectedworkflow=selectedworkflow+"|"+worktypeid;
	}

	//添加自定义
//	if(selectedworkflow.indexOf(worktypeid)==-1){
//		selectedworkflow=selectedworkflow+"|"+worktypeid;
//	}
	b=true;
	for(String swf:swfs){
		if(swf.equalsIgnoreCase(workflowid)){
			b=false;
			break;
		}
	}
	if(b){
		selectedworkflow=selectedworkflow+"|"+workflowid;
	}
	//if(selectedworkflow.indexOf(workflowid)==-1){
	//	selectedworkflow=selectedworkflow+"|"+workflowid;
	//}
	if(isuserdefault.equals("0")){
		isuserdefault="1";
	}
	if(style.equals("insert")){
		sql="insert into workflow_RequestUserDefault(userid,selectedworkflow,isuserdefault) values(?,?,1)";
		RecordSet.executeUpdate(sql,userid,worktypeid+"|"+workflowid);
	}else if(style.equals("update")){
		sql="update workflow_RequestUserDefault set isuserdefault=1,selectedworkflow=? where userid=?";
		RecordSet.executeUpdate(sql,selectedworkflow,userid);
	}
}else if(needall.equals("0")){
	//删除自定义
	if(selectedworkflow.indexOf(workflowid)!=-1){
		//工作流程删除
		//selectedworkflow=selectedworkflow.replace("|"+workflowid,"");
		//selectedworkflow=selectedworkflow.replace(workflowid+"|","");
		
		String[] workflowids=selectedworkflow.split("\\|");
		selectedworkflow="";
		for(String wfid:workflowids){
			//System.out.println(wfid);
			if(!wfid.equalsIgnoreCase(workflowid)){
				selectedworkflow=selectedworkflow+wfid+"|";
			}
		}
		if(selectedworkflow.length()>0){
			selectedworkflow=selectedworkflow.substring(0,(selectedworkflow.length()-1));
		}
		
	}
	if(selectedworkflow.indexOf(worktypeid)!=-1){
		//工作流程类型删除
		String tid=worktypeid.substring(worktypeid.indexOf("T")+1);
	//	System.out.println(tid);
		sql="select id from workflow_base where workflowtype="+tid;
		RecordSet.executeSql(sql);
		boolean b=true;
		String[] swfs=selectedworkflow.split("\\|");
		while(RecordSet.next()){
		//	if(selectedworkflow.indexOf("W"+RecordSet.getString("id"))!=-1){
		//		b=false;
		//		break;
		//	}
			for(String swf:swfs){
				if(swf.equalsIgnoreCase("W"+RecordSet.getString("id"))){
					b=false;
					break;
				}
			}
			if(!b){
				break;
			}
		}
		if(b){
			//selectedworkflow=selectedworkflow.replace("|"+worktypeid,"");
			//selectedworkflow=selectedworkflow.replace(worktypeid+"|","");
			selectedworkflow="";
			for(String swf:swfs){
				if(!swf.equalsIgnoreCase(worktypeid)){
					selectedworkflow=selectedworkflow+swf+"|";
				}
			}
			if(selectedworkflow.length()>0){
				selectedworkflow=selectedworkflow.substring(0,(selectedworkflow.length()-1));
			}
			
		}
	}
//	System.out.println(selectedworkflow);
	if(selectedworkflow.length()==0){
		sql="delete from workflow_RequestUserDefault where userid="+userid;
		RecordSet.execute(sql);
	}else{
		sql="update workflow_RequestUserDefault set isuserdefault=1,selectedworkflow=? where userid=?";
		RecordSet.executeUpdate(sql,selectedworkflow,userid);
	}
}


//System.out.println(url);
if(!"".equals(Util.null2String(url))){
	response.sendRedirect(url);
}
%>
