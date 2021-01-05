
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.conn.ConnStatement"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="InterfaceTransmethod" class="weaver.formmode.interfaces.InterfaceTransmethod" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String sql = "";
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int id = Util.getIntValue(request.getParameter("id"),0);
int wfcreater = Util.getIntValue(request.getParameter("wfcreater"),0);
int wfcreaterfieldid = Util.getIntValue(request.getParameter("wfcreaterfieldid"),0);
int detailno = Util.getIntValue(request.getParameter("detailno"),0);
int tempid = id;
String successwriteback = InterfaceTransmethod.toHtmlForMode(request.getParameter("successwriteback"));
String failwriteback = InterfaceTransmethod.toHtmlForMode(request.getParameter("failwriteback"));

String showcondition = Util.null2String(request.getParameter("showcondition"));
String showconditioncn = Util.null2String(request.getParameter("showconditioncn"));

//先删除数据再重新保存
if (operation.equals("save")) {
    //删除主表数据
	sql = "delete from mode_triggerworkflowset where modeid = " + modeid;
	rs.executeSql(sql);

	//删除明细表数据
	sql = "delete from mode_triggerworkflowsetdetail where mainid = " + id;
	rs.executeSql(sql);
    
    //保存明细数据
    if(modeid>0&&workflowid>0){
    	if(wfcreater!=3){
    		wfcreaterfieldid = 0;
    	}
    	//插入主表数据
        sql = "insert into mode_triggerworkflowset(modeid,workflowid,wfcreater,wfcreaterfieldid,successwriteback,failwriteback,showcondition,showconditioncn) values ("+modeid+","+workflowid+","+wfcreater+","+wfcreaterfieldid+",'"+successwriteback+"','"+failwriteback+"',?,?)";
        
        ConnStatement statement = new ConnStatement();
        try{
        statement.setStatementSql(sql);
	  	statement.setString(1 , showcondition);
	  	statement.setString(2 , showconditioncn);
	  	statement.executeUpdate();
        }catch(Exception e){
        	e.printStackTrace();
        }finally{
        	statement.close();
        }
        //查询id
        sql = "select max(id) id from mode_triggerworkflowset where modeid = " + modeid + " and workflowid = " + workflowid + " and wfcreater = " + wfcreater + " and wfcreaterfieldid = " +wfcreaterfieldid;
        rs.executeSql(sql);
        while(rs.next()){
        	id = rs.getInt("id");	
        }
        
		//新建的时候，如果明细和主表用的为同一个表单，则初始化字段的对应关系
        if(tempid<=0){
        	int modeformid = 0;
        	int wfformid = 0;
        	wfformid = Util.getIntValue(WorkflowComInfo.getFormId(String.valueOf(workflowid)));
       		sql = "select modename,formid from modeinfo where id = " + modeid;
       		rs.executeSql(sql);
       		while(rs.next()){
       			modeformid = rs.getInt("formid");
       		}
       		if(wfformid==modeformid&&wfformid!=0){
            	sql = "insert into mode_triggerworkflowsetdetail (mainid,modefieldid,wffieldid) select " + id + ",id,id from workflow_billfield where billid = " + wfformid;
				rs.executeSql(sql);
       		}
        }else{
	        for(int i=0;i<=detailno;i++){
	        	String wffieldidvalues[] = request.getParameterValues("wffieldid"+i);
	        	String modefieldidvalues[] = request.getParameterValues("modefieldid"+i);
	        	
	        	if(wffieldidvalues!=null && modefieldidvalues!=null){
	        		for(int j=0;j<wffieldidvalues.length;j++){
	        			int wffieldidvalue = Util.getIntValue((String)wffieldidvalues[j],0);
	        			int modefieldidvalue = Util.getIntValue((String)modefieldidvalues[j],0);
	        			
	        			sql = "insert into mode_triggerworkflowsetdetail (mainid,modefieldid,wffieldid) values ("+id+","+modefieldidvalue+","+wffieldidvalue+")";
	        			rs.executeSql(sql);
	        		}
	        	}
	        }
        }
    }
    
	response.sendRedirect("/formmode/interfaces/ModeTriggerWorkflowSet.jsp?modeid="+modeid);
}else{
	if (operation.equals("del")) {
	    //删除主表数据
		sql = "delete from mode_triggerworkflowset where modeid = " + modeid;
		rs.executeSql(sql);

		//删除明细表数据
		sql = "delete from mode_triggerworkflowsetdetail where mainid = " + id;
		rs.executeSql(sql);
	}
	response.sendRedirect("/formmode/interfaces/ModeTriggerWorkflowSet.jsp?modeid="+modeid);
}

%>