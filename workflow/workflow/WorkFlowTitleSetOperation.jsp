
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,weaver.system.SyncRequestTitleTimer" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%

if(!HrmUserVarify.checkUserRight("WorkFlowTitleSet:All", user) && !HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

%>
<%
  String isdialog = Util.null2String(request.getParameter("isdialog"));
  int wfid = Util.getIntValue(request.getParameter("wfid"),-1);
  String postvalues = request.getParameter("postvalues");
  
  boolean isupdatetitle = false ;
  ArrayList<String> _values = new ArrayList<String>();
  rs.executeSql("select fieldId from workflow_TitleSet where flowId = " + wfid);
  while(rs.next()){
	  _values.add(rs.getString("fieldid"));
  }
  rs.executeSql("delete workflow_TitleSet where flowId = " + wfid);
  if(postvalues!=null && !postvalues.equals("")){
	  	ArrayList values = Util.TokenizerString(postvalues,",");
	  	if(values.size()!=_values.size()||!_values.containsAll(values)){
	  		isupdatetitle = true ;
	  	}
  		if(values!=null && values.size()>0){
  			for(int i=0;i<values.size();i++){
  				rs.executeSql("insert into workflow_TitleSet (flowId,fieldId,gradation) values ("+wfid+","+values.get(i).toString()+","+i+")");
  			}
  		}
  		if(isupdatetitle){//修改后直接执行... 
  			rs.executeSql("update workflow_base set isupdatetitle=1 where id="+wfid);//增加修改标识
  			new SyncRequestTitleTimer(wfid+"").start() ;
  		}
  }else{
	  //去掉标题字段后直接修改历史数据
	  rs.executeSql("update workflow_requestbase set requestnamenew=requestname where workflowid="+wfid);
  }
  if("1".equals(isdialog))
  	response.sendRedirect("WFTitleSet.jsp?isclose=1&ajax=1&wfid="+wfid);
  else
  	response.sendRedirect("WFTitleSet.jsp?ajax=1&wfid="+wfid);
%>




