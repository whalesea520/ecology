
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="log" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
String[] value;
String[] value1;
String currentDate = TimeUtil.getCurrentDateString();
String currentTime = (TimeUtil.getCurrentTimeString()).substring(11,19);
boolean flag = true;
String method = Util.null2String(request.getParameter("method"));
if(method.equals("add")){   
    Map map = new HashMap();//存T
    Map wmap = new HashMap();//存W
    boolean flag1 = false;
     for(Enumeration En=request.getParameterNames();En.hasMoreElements();){
    	String paramName = (String) En.nextElement();
	    value1=request.getParameterValues(paramName);
	     for(int i=0;i<value1.length;i++){
	      value1[i]=Util.null2String(value1[i]);
	      if(value1[i].toUpperCase().indexOf("T")!=-1) {
	      	flag1 = true;
	      	//取得所选的所有流程 by cyril 
	      	int typeid = Util.getIntValue(value1[i].substring(1, value1[i].length()),-1);
	      	//System.out.println("value1="+value1[i]+" typeid="+typeid+" sub="+(value1[i].indexOf("T")+1));
			String sql = "select t1.id from workflow_base t1, workflow_createdoc t2 where t2.status='1' AND t2.flowDocField>0 and t1.id=t2.workflowid and t1.isvalid=1 and t1.workflowtype=" + typeid;
			sql += " and t1.id in(select t1.id from workflow_base t1,workflow_fieldLable fieldLable,workflow_formField formField, workflow_formdict formDict"; 
			sql += " where fieldLable.formid = formField.formid ";
			sql += " and fieldLable.fieldid = formField.fieldid "; 
			sql += " and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "; 
			sql += " and formField.formid = t1.formid and fieldLable.langurageid = "+user.getLanguage(); 
			sql += " and formDict.fieldHtmlType = '3' and formDict.type = 9 ";
			sql += " group by t1.id) ";
			sql += " and t1.id not in(select workflowid from DocChangeWorkflow) order by t1.workflowname ";
			rs.executeSql(sql);
			while (rs.next()) {
				map.put("W"+rs.getString("id"), rs.getString("id"));
			}
	      	sql = "";
	      	break;
	      }
	      if(value1[i].toUpperCase().indexOf("W")!=-1){
	    	wmap.put(value1[i], value1[i].substring(1, value1[i].length()));
	    	//System.out.println(value1[i]+"=========---->"+value1[i].substring(1, value1[i].length()));
	        flag1 = true;
	      }
	     }
	  }
    if(!flag1){
    	response.sendRedirect("/docs/change/DocChangeSetting.jsp");
    	return;  //xwj for td3218 20051201
    }
    
    Iterator it = wmap.entrySet().iterator();
    while(it.hasNext()) {
    	Map.Entry entry = (Map.Entry) it.next();
		String mapKey = entry.getKey().toString();
		String mapValue = entry.getValue().toString();
		if(map.get(mapKey)==null) {
			//System.out.println("add mapKey="+mapKey+" mapValue="+mapValue);
			map.put(mapKey, mapValue);
		}
    }
    
    it = map.entrySet().iterator();
    while(it.hasNext()) {
    	Map.Entry entry = (Map.Entry) it.next();
		String mapKey = entry.getKey().toString();
		String mapValue = entry.getValue().toString();
	    int tempwfid = Integer.parseInt(mapValue);
		rs.executeSql("insert into DocChangeWorkflow(id,createdate,createtime,workflowid,creator) values ("+weaver.docs.change.DocChangeManager.getNextChangeId()+",'"+currentDate+"','"+currentTime+"',"+tempwfid+","+user.getUID()+")");
   }
}
else if(method.equals("del")) {
	String ids = Util.null2String(request.getParameter("ids"));
	List idlist = Util.TokenizerString(ids,",");
	if(null!=idlist&&idlist.size()>0)
	{
		for(int i = 0;i<idlist.size();i++)
		{
			String tempid = Util.null2String((String)idlist.get(i));
			if(!"".equals(tempid))
			{
				rs.executeSql("select workflowid from DocChangeWorkflow where id="+tempid);
				String sql = "delete from DocChangeWorkflow where id ="+tempid;
				if(rs.next()){
					log.insSysLogInfo(user, Util.getIntValue(tempid), WorkflowComInfo.getWorkflowname(rs.getString(1)), sql, "347", "3", 0, request.getRemoteAddr());
				}
				rs.executeSql(sql);
			}
		}
	}
}
response.sendRedirect("/docs/change/DocChangeSetting.jsp");
%>