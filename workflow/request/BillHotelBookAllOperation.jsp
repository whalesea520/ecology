
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.* "%>
<%@ page import="java.util.* "%>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<jsp:useBean id="RequestTransactionManager" class="weaver.workflow.request.RequestTransactionManager" scope="page"/>
<jsp:useBean id="RequestCheckAddinRules" class="weaver.workflow.request.RequestCheckAddinRules" scope="page"/>
<%
int userid = user.getUID();
String logintype = user.getLogintype();

String creatertype = "";
if(logintype.equals("1"))     	creatertype = "0";
if(logintype.equals("2"))      	creatertype = "1";	

String operatortype = "";
if(logintype.equals("1"))      	operatortype = "0";
if(logintype.equals("2"))      	operatortype = "1";

String src=Util.fromScreen(request.getParameter("src"),user.getLanguage());
String iscreate=Util.fromScreen(request.getParameter("iscreate"),user.getLanguage());
int workflowid=Util.getIntValue(request.getParameter("workflowid"),-1);

int formid=0;
int billid=0;

String remark = Util.null2String(request.getParameter("remark"));
String clientip=request.getRemoteAddr();
String signdocids = Util.null2String(request.getParameter("signdocids"));
String signworkflowids = Util.null2String(request.getParameter("signworkflowids"));
int linkid = 0;
String linkname="";
int destnodeid=0;
int totalgroups=0;
int passedgroups=0;
float nodepasstime=-1;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag=Util.getSeparator() ;
String Procpara="";
String sql="";
String docids = "";
String crmids = "";
String hrmids = "";
String prjids = "";
String cptids = "";

String requestids[] =request.getParameterValues("requestids");

if(requestids!=null){
    for(int j=0; j<requestids.length; j++){
        int requestid=Util.getIntValue(requestids[j],0);
        int nodeid=Util.getIntValue(request.getParameter("nodeid"+requestid),-1);
        String nodetype=Util.fromScreen(request.getParameter("nodetype"+requestid),user.getLanguage());
        //~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
        RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
        RecordSet.next();
        formid=RecordSet.getInt("billformid");
        billid=RecordSet.getInt("billid");
        
        
        //request_base 表 基本信息
        RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
        RecordSet.next();
        int lastnodeid=RecordSet.getInt("lastnodeid");
        String lastnodetype=RecordSet.getString("lastnodetype");
        String status=RecordSet.getString("status");
        String requestname=RecordSet.getString("requestname");
        passedgroups=RecordSet.getInt("passedgroups");
        totalgroups=RecordSet.getInt("totalgroups");
        int creater=RecordSet.getInt("creater");
        String createdate=RecordSet.getString("createdate");
        String createtime=RecordSet.getString("createtime");
        int lastoperator=RecordSet.getInt("lastoperator");
        String lastoperatedate=RecordSet.getString("lastoperatedate");
        String lastoperatetime=RecordSet.getString("lastoperatetime");
        creatertype = RecordSet.getString("creatertype");
        int lastoperatortype = RecordSet.getInt("lastoperatortype");
        nodepasstime = RecordSet.getFloat("nodepasstime");
        float nodelefttime = RecordSet.getFloat("nodelefttime");
        docids = RecordSet.getString("docids");
    	crmids = RecordSet.getString("crmids");
    	hrmids = RecordSet.getString("hrmids");
    	prjids = RecordSet.getString("prjids");
    	cptids = RecordSet.getString("cptids");
    	
    	//hotelbook基本信息
    	String begindate=Util.fromScreen(request.getParameter("begindate_"+requestid),user.getLanguage());
    	String enddate=Util.fromScreen(request.getParameter("enddate_"+requestid),user.getLanguage());
    	String payterm=Util.fromScreen(request.getParameter("payterm_"+requestid),user.getLanguage());
    	String liveperson=Util.fromScreen2(request.getParameter("liveperson_"+requestid),user.getLanguage());
    	String amount=Util.fromScreen(request.getParameter("amount_"+requestid),user.getLanguage());
    	if(amount.equals(""))   amount="0";
    	
        if(src.equals("delete")&&iscreate.equals("0")){//处理request且选择删除logtype=5
        	//设置base表中的deleted字段为1
        	Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype+"" + flag 
        	    		+ nodeid+"" + flag + nodetype + flag + status + flag
        	    		+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        	    		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "1" + flag
        	    		+ creatertype + flag +lastoperatortype+flag+nodepasstime+flag+nodelefttime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ;
        	RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
        	    	
        	//加入LOG表信息
        	Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "5" + flag 
        		+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag+operatortype
        		+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        	RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        	    
        	// 将 bill_HotelBook 表的状态改为 2
        	RecordSet.executeProc("bill_HotelBook_UpdateStatus",""+billid+flag+"2");
        }
        if(src.equals("save")&&iscreate.equals("0")){//处理request且选择保存logtype=1
        	String updateclause="update bill_hotelbook set begindate='"+begindate+"',enddate='"+
        	                    enddate+"',payterm="+payterm+",liveperson='"+liveperson+"',amount="+
        	                    amount+" where id="+billid;
        	RecordSet.executeSql(updateclause);
        	
        	RecordSet.executeProc("bill_HotelBookDetail_Delete",""+billid);
    	    //写bill_HotelBookDetail表信息
        	int nodesnum=Util.getIntValue(request.getParameter("nodesnum"+requestid),0);
        	for(int i=0 ; i<nodesnum ; i++){
        	    String curhotelid=Util.fromScreen(request.getParameter("hotelid_"+i+"_"+requestid),user.getLanguage());
        	    if(curhotelid.equals(""))   continue;
        	    String curroomstyle=Util.fromScreen(request.getParameter("roomstyle_"+i+"_"+requestid),user.getLanguage());
        	    String curroomsum=Util.fromScreen(request.getParameter("roomsum_"+i+"_"+requestid),user.getLanguage());
            	Procpara=""+billid+flag+curhotelid+flag+curroomstyle+flag+curroomsum;
            	RecordSet.executeProc("bill_HotelBookDetail_Insert",Procpara);
        	}
        	
        	//节点自动赋值操作
            RequestCheckAddinRules.resetParameter();
            RequestCheckAddinRules.setRequestid(requestid);
            RequestCheckAddinRules.setObjid(nodeid);
            RequestCheckAddinRules.setObjtype(1);
            RequestCheckAddinRules.setIsbill(1);
            RequestCheckAddinRules.setFormid(formid);
            RequestCheckAddinRules.checkAddinRules();
        	//加入request总表信息
        	Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype + flag 
        			+ nodeid+"" + flag + nodetype + flag + status + flag
        			+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        			+ createdate + flag + createtime + flag + lastoperator+"" + flag 
        			+ lastoperatedate + flag + lastoperatetime + flag + "" + flag
        			+ creatertype + flag +lastoperatortype +flag+nodepasstime+flag+nodelefttime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ;
        	RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
        	
        	//加入LOG表信息
        	Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "1" + flag 
        		+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag+operatortype
        		+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        	RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);  
        }
        
        if(src.equals("submit")&&iscreate.equals("0")){//处理request且选择提交logtype=2
        	String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
        	//更新字段信息
        	String updateclause="update bill_hotelbook set begindate='"+begindate+"',enddate='"+
        	                    enddate+"',payterm="+payterm+",liveperson='"+liveperson+"',amount="+
        	                    amount+" where id="+billid;
        	RecordSet.executeSql(updateclause);
        	
        	//写bill_HotelBookDetail表信息
        	int nodesnum=Util.getIntValue(request.getParameter("nodesnum"+requestid),0);
        	for(int i=0 ; i<nodesnum ; i++){
        	    String curhotelid=Util.fromScreen(request.getParameter("hotelid_"+i+"_"+requestid),user.getLanguage());
        	    if(curhotelid.equals(""))   continue;
        	    String curroomstyle=Util.fromScreen(request.getParameter("roomstyle_"+i+"_"+requestid),user.getLanguage());
        	    String curroomsum=Util.fromScreen(request.getParameter("roomsum_"+i+"_"+requestid),user.getLanguage());
            	Procpara=""+billid+flag+curhotelid+flag+curroomstyle+flag+curroomsum;
            	RecordSet.executeProc("bill_HotelBookDetail_Insert",Procpara);
        	}
        	
        	 //节点自动赋值操作
            RequestCheckAddinRules.resetParameter();
            RequestCheckAddinRules.setRequestid(requestid);
            RequestCheckAddinRules.setObjid(nodeid);
            RequestCheckAddinRules.setObjtype(1);
            RequestCheckAddinRules.setIsbill(1);
            RequestCheckAddinRules.setFormid(formid);
            RequestCheckAddinRules.checkAddinRules();
        	
        	//先检查passedgroups个数
        	sql="select count(distinct groupid) from workflow_currentoperator where isremark = '0' and requestid="+requestid+" and userid="+userid+" and usertype="+operatortype;
        	RecordSet.executeSql(sql);
        	if(RecordSet.next())	passedgroups+=RecordSet.getInt(1);
        	//更新operator表
        	sql = "select distinct groupid from workflow_currentoperator where isremark = '0' and requestid="+requestid+" and userid="+userid+" and usertype="+operatortype;
        	RecordSet.executeSql(sql);
        	while(RecordSet.next()){
        		int tmpgroupid = RecordSet.getInt(1);
        		rs.executeProc("workflow_NodeGroup_SelectByid",""+tmpgroupid);
        		int tmpcanview = 0;
        		if(rs.next())
        			tmpcanview = rs.getInt("canview");
        		if(tmpcanview==1 || lastnodetype.equals("0") || lastnodetype.equals("") ){
        			sql = " update workflow_currentoperator set isremark = '2' where requestid="+requestid+" and groupid ="+tmpgroupid;
        			rs.executeSql(sql);
        		}else if(tmpcanview==0){
        			sql = " delete workflow_currentoperator where requestid="+requestid+" and groupid ="+tmpgroupid+",and isremark='0'";
        			rs.executeSql(sql);
        		}
        	}
        	if(passedgroups<totalgroups){//当前节点没有完全审批通过，继续停留在当前节点
        		//更新request总表信息        
        	    Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype+"" + flag 
        	    		+ nodeid+"" + flag + nodetype + flag + status + flag
        	    		+ passedgroups + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        	    		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "" + flag
        	    		+ creatertype + flag + lastoperatortype+flag+nodepasstime+flag+nodelefttime
        	        	+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ;
        	    RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
        	    //加入LOG表信息
        	    Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "2" + flag 
        		+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag+operatortype
        		+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        		RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        	}
        	else{//当前节点完全审批通过，流向下一节点
        		//删除原有remark的人
                sql="delete from workflow_currentoperator where isremark ='1' and requestid="+requestid;
        		RecordSet.executeSql(sql);
        		//查询下一节点
        		RecordSet.executeProc("workflow_NodeLink_Select",nodeid+""+flag+"0"+flag+""+requestid);
        		ArrayList whereclauses=new ArrayList();
        		ArrayList linkids=new ArrayList();
        		ArrayList linknames=new ArrayList();
        		ArrayList destnodeids=new ArrayList();
        		while(RecordSet.next()){
        			//whereclauses.add(RecordSet.getString("condition"));
        			linkids.add(RecordSet.getString("id"));
        			linknames.add(RecordSet.getString("linkname"));
        			destnodeids.add(RecordSet.getString("destnodeid"));
        			
        			weaver.workflow.node.NodeInfo nodeInfo = new weaver.workflow.node.NodeInfo();
        			if(RecordSet.getDBType().equals("oracle"))
        				whereclauses.add(nodeInfo.getConditionStr(RecordSet.getString("id")));
        			else
        				whereclauses.add(RecordSet.getString("condition"));
        		}
        	
        		int i=0;
        		for(i=0;i<destnodeids.size();i++){
        			String where=(String)whereclauses.get(i);
        			if(where.trim().equals(""))	break;
        			else{
        				sql="select * from bill_HotelBook where id="+billid+" and "+where;
        				RecordSet.executeSql(sql);
        				if(RecordSet.next())	break;
        			}
        		}
        		linkid=Util.getIntValue(""+linkids.get(i),0);
        		linkname=(String) linknames.get(i);
        		destnodeid=Util.getIntValue((String)destnodeids.get(i),0);
        		
        		RecordSet.executeProc("workflow_NodeLink_SPasstime",""+nodeid+flag+"-1");
        		if(RecordSet.next())
        			nodepasstime=Util.getFloatValue(RecordSet.getString("nodepasstime"),-1);
        		else
        			nodepasstime = -1;
        				
        		RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
        		RecordSet.next();
        		String destnodetype=RecordSet.getString(1);
        		
        		sql="select count(id) from workflow_nodegroup where nodeid = "+destnodeid;
        		RecordSet.executeSql(sql);
        		if(RecordSet.next())
        		   	totalgroups = RecordSet.getInt(1);
        	    //更新request总表信息   
        	    Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
        	    		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
        	    		+ "0" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        	    		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + ""+flag
        	    		+ creatertype + flag + operatortype+flag+nodepasstime+flag+nodepasstime
        	        	+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ;
        	    RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
        	    //加入LOG表信息
        	    Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "2" + flag 
        		+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag+operatortype
        		+ flag + ""+destnodeid+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        		RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        	    //加入operator信息
        	    if(!destnodetype.equals("0")){       
        		    RequestCheckUser.setUserid(userid);
        			RequestCheckUser.setNodeid(destnodeid);
        			RequestCheckUser.setLogintype(logintype);
        			RequestCheckUser.setIsbill(1);
        			RequestCheckUser.setRequestid(requestid);
        			RequestCheckUser.setWorkflowid(workflowid);
        			RequestCheckUser.setWorkflowtype(workflowtype);
        	        totalgroups = RequestCheckUser.addCurrentoperator();
        	 	}
        	 	else{
        		 	totalgroups = 1;
        		 	Procpara=requestid+"" + flag + creater+"" + flag + "" + flag + workflowid+"" + flag + workflowtype+flag+creatertype+flag+"0";
        	    	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
        	    	RecordSet.executeProc("SysRemindInfo_InserHasnewwf",""+creater+flag+creatertype+flag+""+requestid);
        		}
                // 如果为结束节点,将 bill_HotelBook 表的状态改为 1
            	if(destnodetype.equals("3"))
            		RecordSet.executeProc("bill_HotelBook_UpdateStatus",""+billid+flag+"1");
            	//出口自动赋值操作
                RequestCheckAddinRules.resetParameter();
                RequestCheckAddinRules.setRequestid(requestid);
                RequestCheckAddinRules.setObjid(linkid);
                RequestCheckAddinRules.setObjtype(0);
                RequestCheckAddinRules.setIsbill(1);
                RequestCheckAddinRules.setFormid(formid);
                RequestCheckAddinRules.checkAddinRules();
            }
        }
    }
}
//response.sendRedirect("/workflow/request/RequestView.jsp");
out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>