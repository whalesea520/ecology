
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
boolean isoracle=false;
if(RecordSet.getDBType().equals("oracle")) isoracle=true;
boolean isdb2=RecordSet.getDBType().equals("db2");
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
int nodeid=Util.getIntValue(request.getParameter("nodeid"),-1);
String nodetype=Util.fromScreen(request.getParameter("nodetype"),user.getLanguage());
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),0);

int lastnodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String lastnodetype = Util.null2String(request.getParameter("nodetype"));
int requestid=Util.getIntValue(request.getParameter("requestid"),-1);
String requestname=Util.fromScreen(request.getParameter("requestname"),user.getLanguage());
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(request.getParameter("messageType"),user.getLanguage());
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

//得到名片详细资料
String cname=Util.fromScreen(request.getParameter("cname"),user.getLanguage());
String cjobtitle=Util.fromScreen(request.getParameter("cjobtitle"),user.getLanguage());
String cdepartment=Util.fromScreen(request.getParameter("cdepartment"),user.getLanguage());
String ename=Util.fromScreen(request.getParameter("ename"),user.getLanguage());
String ejobtitle=Util.fromScreen(request.getParameter("ejobtitle"),user.getLanguage());
String edepartment=Util.fromScreen(request.getParameter("edepartment"),user.getLanguage());
String phone=Util.fromScreen(request.getParameter("phone"),user.getLanguage());
String mobile=Util.fromScreen(request.getParameter("mobile"),user.getLanguage());
String email=Util.fromScreen(request.getParameter("email"),user.getLanguage());

if(src.equals("save")&&iscreate.equals("1")) {//新建request且选择保存	
	RecordSet.executeProc("workflow_RequestID_Update","");
	RecordSet.next();
	requestid = RecordSet.getInt(1);
	
	//更新字段信息     
	String sqltmp = " insert into bill_NameCard (resourceid) values(0)";
    RecordSet.executeSql(sqltmp);
    sqltmp = " select max(id) from bill_NameCard";
    RecordSet.executeSql(sqltmp);
    if(RecordSet.next())
    	billid = RecordSet.getInt(1);
	String updateclause="set ";
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
	while(RecordSet.next()){
		String fieldid=RecordSet.getString("id");
    	String fieldname=RecordSet.getString("fieldname");
    	String fielddbtype=RecordSet.getString("fielddbtype");
		if(isoracle){
			if(fielddbtype.equals("integer"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("number(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else {
                String thetempvalue = Util.fromScreen2(request.getParameter("field"+fieldid),user.getLanguage()) ;
                if( thetempvalue.equals("") ) thetempvalue = " " ;
        		updateclause+=fieldname+" = '"+thetempvalue+"',";
            }
    	}else{
			if(fielddbtype.equals("int"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("decimal(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else
				updateclause+=fieldname+" = '"+Util.fromScreen2(Util.null2String(request.getParameter("field"+fieldid)),user.getLanguage())+"',";
		}
    	String fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
    	String fieldtype=FieldComInfo.getFieldType(fieldid);
    	if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")))
        		hrmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18")))
        		crmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("8"))
        		prjids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("9"))
        		docids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("23"))
        		cptids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
    } 
	updateclause+= "requestid="+requestid+",billid="+formid+",status='0',";			
	updateclause=updateclause.substring(0,updateclause.length()-1);
	updateclause="update bill_NameCard "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);
	
	//写bill_namecardinfo表信息
	boolean isnew=true;
	Procpara=""+userid+flag+cname+flag+cjobtitle+flag+cdepartment+flag+phone+flag+mobile+flag+
	        email+flag+ename+flag+ejobtitle+flag+edepartment;
	RecordSet.executeProc("bill_NameCardinfo_SByResource",""+userid);
    if(RecordSet.next())    isnew=false;
    if(isnew)   RecordSet.executeProc("bill_NameCardinfo_Insert",Procpara);
    else    RecordSet.executeProc("bill_NameCardinfo_Update",Procpara);
	
	//节点自动赋值操作
    RequestCheckAddinRules.resetParameter();
    RequestCheckAddinRules.setRequestid(requestid);
    RequestCheckAddinRules.setObjid(nodeid);
    RequestCheckAddinRules.setObjtype(1);
    RequestCheckAddinRules.setIsbill(1);
    RequestCheckAddinRules.setFormid(formid);
    RequestCheckAddinRules.checkAddinRules();
		
	//加入workflow_form表
	sql="insert into workflow_form (requestid,billformid,billid) values("+requestid+","+formid+","+billid+")";
    RecordSet.executeSql(sql);
	//加入request总表信息
	RecordSet.executeProc("workflow_NodeLink_SPasstime",""+nodeid+flag+"-1");
	if(RecordSet.next())
		nodepasstime=Util.getFloatValue(RecordSet.getString("nodepasstime"),-1);       
	if(!hrmids.equals(""))
    	hrmids = hrmids.substring(1);
    if(!crmids.equals(""))
    	crmids = crmids.substring(1);
    if(!prjids.equals(""))
    	prjids = prjids.substring(1);
    if(!docids.equals(""))
    	docids = docids.substring(1);
        if(!cptids.equals(""))
        	cptids = cptids.substring(1);
	Procpara=requestid+""+ flag + workflowid+"" + flag + "" + flag + "" + flag 
			+ nodeid+"" + flag + nodetype + flag + SystemEnv.getHtmlLabelName(125,user.getLanguage()) + flag
			+ "" + flag + "" + flag + requestname + flag + userid+"" + flag + CurrentDate + flag
			+ CurrentTime + flag + "" + flag + "" + flag + "" + flag + ""+ flag + creatertype+ flag + ""+flag
			+nodepasstime+flag+nodepasstime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids;
	RecordSet.executeProc("workflow_Requestbase_Insert",Procpara);
	//加入LOG表信息
	Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "1" + flag 
		+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip + flag + creatertype
		+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
	RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
	//加入operator信息
	String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
	Procpara=requestid+"" + flag + userid+"" + flag + "" + flag + workflowid+"" + flag + workflowtype+ flag + creatertype + flag +"0";
	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
	
	String topage=URLDecoder.decode(Util.null2String(request.getParameter("topage")));
    if(!topage.equals("")){
    	if(topage.indexOf("?")!=-1){
    		//response.sendRedirect(topage+"&requestid="+requestid);
    		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
    	}else{
			//response.sendRedirect(topage+"?requestid="+requestid);
			out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
		}
	}
}

if(src.equals("submit")&&iscreate.equals("1")) {//新建request且选择提交
	RecordSet.executeProc("workflow_RequestID_Update","");
	RecordSet.next();
	requestid = RecordSet.getInt(1);
	//更新字段信息     
	String sqltmp = " insert into bill_NameCard (resourceid) values(0)";
    RecordSet.executeSql(sqltmp);
    sqltmp = " select max(id) from bill_NameCard";
    RecordSet.executeSql(sqltmp);
    if(RecordSet.next())
    	billid = RecordSet.getInt(1);
	String updateclause="set ";
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
	while(RecordSet.next()){
		String fieldid=RecordSet.getString("id");
    	String fieldname=RecordSet.getString("fieldname");
    	String fielddbtype=RecordSet.getString("fielddbtype");
		if(isoracle){
			if(fielddbtype.equals("integer"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("number(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else {
                String thetempvalue = Util.fromScreen2(request.getParameter("field"+fieldid),user.getLanguage()) ;
                if( thetempvalue.equals("") ) thetempvalue = " " ;
        		updateclause+=fieldname+" = '"+thetempvalue+"',";
            }
    	}else{
			if(fielddbtype.equals("int"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("decimal(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else
				updateclause+=fieldname+" = '"+Util.fromScreen2(Util.null2String(request.getParameter("field"+fieldid)),user.getLanguage())+"',";
		}
    	String fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
    	String fieldtype=FieldComInfo.getFieldType(fieldid);
    	if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")))
        		hrmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18")))
        		crmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("8"))
        		prjids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("9"))
        		docids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("23"))
        		cptids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
    } 
	updateclause+= "requestid="+requestid+",billid="+formid+",status='0',";
	updateclause=updateclause.substring(0,updateclause.length()-1);
	updateclause="update bill_NameCard "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);
	
	//写bill_namecardinfo表信息
	boolean isnew=true;
	Procpara=""+userid+flag+cname+flag+cjobtitle+flag+cdepartment+flag+phone+flag+mobile+flag+
	        email+flag+ename+flag+ejobtitle+flag+edepartment;
	RecordSet.executeProc("bill_NameCardinfo_SByResource",""+userid);
    if(RecordSet.next())    isnew=false;
    if(isnew)   RecordSet.executeProc("bill_NameCardinfo_Insert",Procpara);
    else    RecordSet.executeProc("bill_NameCardinfo_Update",Procpara);
	
	//加入workflow_form表
	sql="insert into workflow_form (requestid,billformid,billid) values("+requestid+","+formid+","+billid+")";
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
			sql="select * from bill_NameCard where requestid="+requestid+" and "+where;
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
	//加入LOG表信息
	Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "2" + flag 
		+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
		+ flag + ""+destnodeid+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
	RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
	//加入request总表信息        
	RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
	RecordSet.next();
	String destnodetype=RecordSet.getString(1);
	
	sql="select count(id) from workflow_nodegroup where nodeid = "+destnodeid;
	RecordSet.executeSql(sql);
	if(RecordSet.next())
		totalgroups = RecordSet.getInt(1);
	if(!hrmids.equals(""))
    	hrmids = hrmids.substring(1);
    if(!crmids.equals(""))
    	crmids = crmids.substring(1);
    if(!prjids.equals(""))
    	prjids = prjids.substring(1);
    if(!docids.equals(""))
    	docids = docids.substring(1);
        if(!cptids.equals(""))
        	cptids = cptids.substring(1);	
	Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
			+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
			+ "0" + flag + totalgroups+"" + flag + requestname + flag + userid+"" + flag + CurrentDate + flag
			+ CurrentTime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + ""+flag+creatertype+ flag+creatertype+flag
			+nodepasstime + flag + nodepasstime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids;
	RecordSet.executeProc("workflow_Requestbase_Insert",Procpara);
	
	//加入operator信息
	String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");	
	RequestCheckUser.setUserid(userid);
	RequestCheckUser.setNodeid(destnodeid);
	RequestCheckUser.setLogintype(logintype);
	RequestCheckUser.setIsbill(1);
	RequestCheckUser.setRequestid(requestid);
	RequestCheckUser.setWorkflowid(workflowid);
	RequestCheckUser.setWorkflowtype(workflowtype);
	totalgroups = RequestCheckUser.addCurrentoperator();
	//节点自动赋值操作
    RequestCheckAddinRules.resetParameter();
    RequestCheckAddinRules.setRequestid(requestid);
    RequestCheckAddinRules.setObjid(nodeid);
    RequestCheckAddinRules.setObjtype(1);
    RequestCheckAddinRules.setIsbill(1);
    RequestCheckAddinRules.setFormid(formid);
    RequestCheckAddinRules.checkAddinRules();
           
    //出口自动赋值操作
    RequestCheckAddinRules.resetParameter();
    RequestCheckAddinRules.setRequestid(requestid);
    RequestCheckAddinRules.setObjid(linkid);
    RequestCheckAddinRules.setObjtype(0);
    RequestCheckAddinRules.setIsbill(1);
    RequestCheckAddinRules.setFormid(formid);
    RequestCheckAddinRules.checkAddinRules();  
    
    //加入查看人员列表
    Procpara=requestid+"" + flag + userid+"" + flag + "" + flag + workflowid+"" + flag + workflowtype+ flag + creatertype +flag+"2";
    RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
    
    String topage=URLDecoder.decode(Util.null2String(request.getParameter("topage")));
    if(!topage.equals("")){
    	if(topage.indexOf("?")!=-1){
    		//response.sendRedirect(topage+"&requestid="+requestid);
    		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"');</script>");
    	}else{
			//response.sendRedirect(topage+"?requestid="+requestid);
			out.print("<script>wfforward('"+topage+"?requestid="+requestid+"');</script>");
		}
	}
}
//更新request level信息
if(iscreate.equals("1")){
    RecordSet.executeProc("workflow_Rbase_UpdateLevel",""+requestid+flag+requestlevel);
}

//request_base 表 基本信息
RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
RecordSet.next();
lastnodeid=RecordSet.getInt("lastnodeid");
lastnodetype=RecordSet.getString("lastnodetype");
String status=RecordSet.getString("status");
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

if(src.equals("delete")&&iscreate.equals("0")){//处理request且选择删除logtype=5
	//继续从request_base表中读下面四个字段信息
	docids = RecordSet.getString("docids");
	crmids = RecordSet.getString("crmids");
	hrmids = RecordSet.getString("hrmids");
	prjids = RecordSet.getString("prjids");
	cptids = RecordSet.getString("cptids");
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
	    
	// 将 bill_NameCard 表的状态改为 2
	RecordSet.executeProc("bill_NameCard_UpdateStatus",""+billid+flag+"2");
}

if(src.equals("save")&&iscreate.equals("0")){//处理request且选择保存logtype=1
	//检查remark的操作者是否还有权限
	    int isremark=Util.getIntValue(request.getParameter("isremark"),0);
	    String usertype="";
	    if(logintype.equals("1"))
        	usertype = "0";
        if(logintype.equals("2"))
        	usertype = "1";
	    if(isremark==1){
	        sql="select * from workflow_currentoperator where isremark='1' and requestid="+requestid+" and userid="+userid+" and usertype="+usertype;
	        RecordSet.executeSql(sql);
	        if(!RecordSet.next()){
				//response.sendRedirect("/workflow/request/RequestView.jsp");
				out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
	            return;
	        }
	    }
	    
	String updateclause="set ";
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
	while(RecordSet.next()){
		String fieldid=RecordSet.getString("id");
    	String fieldname=RecordSet.getString("fieldname");
    	String fielddbtype=RecordSet.getString("fielddbtype");
    	if(fieldname.equals("cptgivetype")){
    		updateclause+=" cptgivetype = '"+Util.fromScreen(Util.null2String(request.getParameter("cptgivetype")),user.getLanguage())+"',";	
    		continue;
    	}
		if(isoracle){
			if(fielddbtype.equals("integer"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("number(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else {
                String thetempvalue = Util.fromScreen2(request.getParameter("field"+fieldid),user.getLanguage()) ;
                if( thetempvalue.equals("") ) thetempvalue = " " ;
        		updateclause+=fieldname+" = '"+thetempvalue+"',";
            }
    	}else{
			if(fielddbtype.equals("int"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("decimal(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else
				updateclause+=fieldname+" = '"+Util.fromScreen2(Util.null2String(request.getParameter("field"+fieldid)),user.getLanguage())+"',";
		}
    	String fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
    	String fieldtype=FieldComInfo.getFieldType(fieldid);
    	if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")))
        		hrmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18")))
        		crmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("8"))
        		prjids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("9"))
        		docids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("23"))
        		cptids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
    }
	updateclause=updateclause.substring(0,updateclause.length()-1);
	updateclause="update bill_NameCard "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);
	
	if(nodetype.equals("0")){
	    //写bill_namecardinfo表信息
    	boolean isnew=true;
    	Procpara=""+userid+flag+cname+flag+cjobtitle+flag+cdepartment+flag+phone+flag+mobile+flag+
    	        email+flag+ename+flag+ejobtitle+flag+edepartment;
    	RecordSet.executeProc("bill_NameCardinfo_SByResource",""+userid);
        if(RecordSet.next())    isnew=false;
        if(isnew)   RecordSet.executeProc("bill_NameCardinfo_Insert",Procpara);
        else    RecordSet.executeProc("bill_NameCardinfo_Update",Procpara);
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
	if(!hrmids.equals(""))
    	hrmids = hrmids.substring(1);
    if(!crmids.equals(""))
    	crmids = crmids.substring(1);
    if(!prjids.equals(""))
    	prjids = prjids.substring(1);
    if(!docids.equals(""))
    	docids = docids.substring(1);
        if(!cptids.equals(""))
        	cptids = cptids.substring(1);
	Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype + flag 
			+ nodeid+"" + flag + nodetype + flag + status + flag
			+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
			+ createdate + flag + createtime + flag + lastoperator+"" + flag 
			+ lastoperatedate + flag + lastoperatetime + flag + "" + flag
			+ creatertype + flag +lastoperatortype +flag+nodepasstime+flag+nodelefttime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ;
	RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
	
	//加入LOG表信息
	String logtype  = "1" ;
    if(isremark==1) logtype = "9" ;
    Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + logtype + flag 
        + CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag+operatortype
        + flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
	RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);  
	//删除remark操作者记录
	if(isremark==1){
		RecordSet.executeSql("delete from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark='1' and usertype="+operatortype);
	}
}

if(src.equals("submit")&&iscreate.equals("0")){//处理request且选择提交logtype=2
	String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
	//更新字段信息
	String updateclause="set ";
    RecordSet.executeProc("workflow_billfield_Select",formid+"");
	while(RecordSet.next()){
		String fieldid=RecordSet.getString("id");
    	String fieldname=RecordSet.getString("fieldname");
    	String fielddbtype=RecordSet.getString("fielddbtype");
    	if(fieldname.equals("cptgivetype")){
    		updateclause+=" cptgivetype = '"+Util.fromScreen(Util.null2String(request.getParameter("cptgivetype")),user.getLanguage())+"',";	
    		continue;
    	}
		if(isoracle){
			if(fielddbtype.equals("integer"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("number(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else {
                String thetempvalue = Util.fromScreen2(request.getParameter("field"+fieldid),user.getLanguage()) ;
                if( thetempvalue.equals("") ) thetempvalue = " " ;
        		updateclause+=fieldname+" = '"+thetempvalue+"',";
            }
    	}else{
			if(fielddbtype.equals("int"))
				updateclause+=fieldname+" = "+Util.getIntValue(request.getParameter("field"+fieldid),0)+",";
			else if(fielddbtype.equals("decimal(10,3)"))
				updateclause+=fieldname+" = "+Util.getFloatValue(request.getParameter("field"+fieldid),0)+",";
			else
				updateclause+=fieldname+" = '"+Util.fromScreen2(Util.null2String(request.getParameter("field"+fieldid)),user.getLanguage())+"',";
		}
    	String fieldhtmltype=FieldComInfo.getFieldhtmltype(fieldid);
    	String fieldtype=FieldComInfo.getFieldType(fieldid);
    	if(fieldhtmltype.equals("3") && (fieldtype.equals("1") ||fieldtype.equals("17")))
        		hrmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18")))
        		crmids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("8"))
        		prjids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("9"))
        		docids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
        	if(fieldhtmltype.equals("3") && fieldtype.equals("23"))
        		cptids +=","+Util.getIntValue(request.getParameter("field"+fieldid),0);
    } 				
	updateclause=updateclause.substring(0,updateclause.length()-1);
	updateclause="update bill_NameCard "+updateclause+" where id = "+billid;
	RecordSet.executeSql(updateclause);
	
	if(nodetype.equals("0")){
	    //写bill_namecardinfo表信息
    	boolean isnew=true;
    	Procpara=""+userid+flag+cname+flag+cjobtitle+flag+cdepartment+flag+phone+flag+mobile+flag+
    	        email+flag+ename+flag+ejobtitle+flag+edepartment;
    	RecordSet.executeProc("bill_NameCardinfo_SByResource",""+userid);
        if(RecordSet.next())    isnew=false;
        if(isnew)   RecordSet.executeProc("bill_NameCardinfo_Insert",Procpara);
        else    RecordSet.executeProc("bill_NameCardinfo_Update",Procpara);
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
		if(tmpcanview==1   || lastnodetype.equals("0") || lastnodetype.equals("") ){
			sql = " update workflow_currentoperator set isremark = '2' where requestid="+requestid+" and groupid ="+tmpgroupid;
			rs.executeSql(sql);
		}else if(tmpcanview==0){
			sql = " delete workflow_currentoperator where requestid="+requestid+" and groupid ="+tmpgroupid+" and isremark='0'";
			rs.executeSql(sql);
		}
	}
	if(!hrmids.equals(""))
    	hrmids = hrmids.substring(1);
    if(!crmids.equals(""))
    	crmids = crmids.substring(1);
    if(!prjids.equals(""))
    	prjids = prjids.substring(1);
    if(!docids.equals(""))
    	docids = docids.substring(1);
        if(!cptids.equals(""))
        	cptids = cptids.substring(1);
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
				sql="select * from bill_NameCard where id="+billid+" and "+where;
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
        // 如果为结束节点,将 bill_NameCard 表的状态改为 1
    	if(destnodetype.equals("3"))
    		RecordSet.executeProc("bill_NameCard_UpdateStatus",""+billid+flag+"1");
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

if(src.equals("reject")&&iscreate.equals("0")){//处理request且选择退回logtype=3
    String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");    
	
	//节点自动赋值操作
    RequestCheckAddinRules.resetParameter();
    RequestCheckAddinRules.setRequestid(requestid);
    RequestCheckAddinRules.setObjid(nodeid);
    RequestCheckAddinRules.setObjtype(1);
    RequestCheckAddinRules.setIsbill(1);
    RequestCheckAddinRules.setFormid(formid);
    RequestCheckAddinRules.checkAddinRules();
	//查询下一节点
	RecordSet.executeProc("workflow_NodeLink_Select",nodeid+""+flag+"1"+flag+""+requestid);
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
			sql="select * from bill_NameCard where id="+billid+" and "+where;
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
        	
	//加入request总表信息       
    sql="select count(id) from workflow_nodegroup where nodeid = "+destnodeid;
	RecordSet.executeSql(sql);
	if(RecordSet.next())
	   	totalgroups = RecordSet.getInt(1);    
	if(!hrmids.equals(""))
    	hrmids = hrmids.substring(1);
    if(!crmids.equals(""))
    	crmids = crmids.substring(1);
    if(!prjids.equals(""))
    	prjids = prjids.substring(1);
    if(!docids.equals(""))
    	docids = docids.substring(1);
        if(!cptids.equals(""))
        	cptids = cptids.substring(1);
    Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
    		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
    		+ "0" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag + createdate + flag
    		+ createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + ""+flag+creatertype+flag +operatortype+flag
    		+ nodepasstime+flag+nodepasstime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ; 
    RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
    
    //加入LOG表信息
    Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "3" + flag 
	    	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag + operatortype
	    	+ flag + ""+destnodeid+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
    RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
            
	//加入operator信息,先删除operator表中的相关记录，再插入新的记录
	//更新operator表
	sql = "select distinct groupid from workflow_currentoperator where isremark = '0' and requestid="+requestid+" and userid="+userid+" and usertype="+operatortype;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		int tmpgroupid = RecordSet.getInt(1);
		rs.executeProc("workflow_NodeGroup_SelectByid",""+tmpgroupid);
		int tmpcanview = 0;
		if(rs.next())
			tmpcanview = rs.getInt("canview");
		if(tmpcanview==1){
			sql = " update workflow_currentoperator set isremark = '2' where requestid="+requestid+" and groupid ="+tmpgroupid;
			rs.executeSql(sql);
		}else if(tmpcanview==0){
			sql = " delete workflow_currentoperator where requestid="+requestid+" and groupid ="+tmpgroupid;
			rs.executeSql(sql);
		}
	}
	sql="delete from workflow_currentoperator where isremark <> '2' and requestid="+requestid;
	RecordSet.executeSql(sql);
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
	else{//next node is create
	    totalgroups = 1;
	    Procpara=requestid+"" + flag + creater+"" + flag + "" + flag + workflowid+"" + flag + workflowtype+flag+creatertype+flag+"0";
	    RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
	    RecordSet.executeProc("SysRemindInfo_InserHasnewwf",""+creater+flag+creatertype+flag+""+requestid);
	}
	//出口自动赋值操作
    RequestCheckAddinRules.resetParameter();
    RequestCheckAddinRules.setRequestid(requestid);
    RequestCheckAddinRules.setObjid(linkid);
    RequestCheckAddinRules.setObjtype(0);
    RequestCheckAddinRules.setIsbill(1);
    RequestCheckAddinRules.setFormid(formid);
    RequestCheckAddinRules.checkAddinRules();
}
if(src.equals("reopen")&&iscreate.equals("0")){//处理request且选择重新打开logtype=4
	String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");    
	
	//查询下一节点即create节点
	RecordSet.executeProc("workflow_CreateNode_Select",workflowid+"");
	RecordSet.next();
	destnodeid=RecordSet.getInt(1);
	RecordSet.executeProc("workflow_NodeLink_SPasstime",""+nodeid+flag+"-1");
	if(RecordSet.next())
		nodepasstime=Util.getFloatValue(RecordSet.getString("nodepasstime"),-1);
	else
		nodepasstime = -1;
			
	linkname="reopen";
	totalgroups=1;
	//加入operator信息,先删除operator表中的相关记录，再插入新的记录
	//更新operator表
	sql = "select distinct groupid from workflow_currentoperator where isremark = '0' and requestid="+requestid+" and userid="+userid+" and usertype="+operatortype;
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
		int tmpgroupid = RecordSet.getInt(1);
		rs.executeProc("workflow_NodeGroup_SelectByid",""+tmpgroupid);
		int tmpcanview = 0;
		if(rs.next())
			tmpcanview = rs.getInt("canview");
		if(tmpcanview==1){
			sql = " update workflow_currentoperator set isremark = '2' where requestid="+requestid+" and groupid ="+tmpgroupid;
			rs.executeSql(sql);
		}else if(tmpcanview==0){
			sql = " delete workflow_currentoperator where requestid="+requestid+" and groupid ="+tmpgroupid;
			rs.executeSql(sql);
		}
	}
	sql="delete from workflow_currentoperator where isremark <> '2' and requestid="+requestid;
	RecordSet.executeSql(sql);
        
    Procpara=requestid+"" + flag + creater+"" + flag + "" + flag + workflowid+"" + flag + workflowtype+flag+creatertype+flag+"0";
    RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
    RecordSet.executeProc("SysRemindInfo_InserHasnewwf",""+creater+flag+creatertype+flag+""+requestid);
    
    //加入request总表信息        
    if(!hrmids.equals(""))
    	hrmids = hrmids.substring(1);
    if(!crmids.equals(""))
    	crmids = crmids.substring(1);
    if(!prjids.equals(""))
    	prjids = prjids.substring(1);
    if(!docids.equals(""))
    	docids = docids.substring(1);
        if(!cptids.equals(""))
        	cptids = cptids.substring(1);
    RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
    RecordSet.next();
    String destnodetype=RecordSet.getString(1);
    Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
       		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
       		+ "0" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag + createdate + flag
       		+ createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "" + flag+creatertype + flag + operatortype+flag
       		+nodepasstime + flag+nodepasstime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids  ;
    RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
    //加入LOG表信息
    Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "4" + flag 
       	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+flag+operatortype
       	+ flag + ""+destnodeid+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
    RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
}

if(src.equals("active")){//激活request logtype=6
	//继续从request_base表中读下面四个字段信息
	docids = RecordSet.getString("docids");
	crmids = RecordSet.getString("crmids");
	hrmids = RecordSet.getString("hrmids");
	prjids = RecordSet.getString("prjids");
	cptids = RecordSet.getString("cptids");
	//设置base表中的deleted字段为0
	Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype+"" + flag 
        		+ nodeid+"" + flag + nodetype + flag + status + flag
        		+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "0"+flag+creatertype+flag+operatortype+flag
        		+nodepasstime+flag+nodelefttime+flag+docids+flag+crmids+flag+hrmids+flag+prjids+flag+cptids ; 
        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
	
	//加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "6" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip + flag +operatortype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        // 如果为结束节点, 将 bill_hrmtime 表的状态改为 1
        if(nodetype.equals("3")) 
            RecordSet.executeProc("bill_NameCard_UpdateStatus",""+billid+flag+"1");
        else
            RecordSet.executeProc("bill_NameCard_UpdateStatus",""+billid+flag+"0");
}

	//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>