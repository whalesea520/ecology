
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.* "%>
<%@ page import="java.util.* "%>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/>
<%
boolean isoracle=false;
if(RecordSet.getDBType().equals("oracle")) isoracle=true;
boolean isdb2=RecordSet.getDBType().equals("db2");
int userid = user.getUID();
	
String src=Util.fromScreen(request.getParameter("src"),user.getLanguage());
String iscreate=Util.fromScreen(request.getParameter("iscreate"),user.getLanguage());
int workflowid=Util.getIntValue(request.getParameter("workflowid"),-1);
int nodeid=Util.getIntValue(request.getParameter("nodeid"),-1);
String nodetype=Util.fromScreen(request.getParameter("nodetype"),user.getLanguage());
int formid = Util.getIntValue(request.getParameter("formid"),-1);
int billid = Util.getIntValue(request.getParameter("billid"),0);
String signdocids = Util.null2String(request.getParameter("signdocids"));
String signworkflowids = Util.null2String(request.getParameter("signworkflowids"));

int lastnodeid = Util.getIntValue(request.getParameter("nodeid"),-1);
String lastnodetype = Util.null2String(request.getParameter("nodetype"));
int requestid=Util.getIntValue(request.getParameter("requestid"),-1);
String requestname=Util.fromScreen(request.getParameter("requestname"),user.getLanguage());
String requestlevel=Util.fromScreen(request.getParameter("requestlevel"),user.getLanguage());
String remark = Util.null2String(request.getParameter("remark"));
String clientip=request.getRemoteAddr();
String logintype = user.getLogintype();
String creatertype = "";
	if(logintype.equals("1"))
	   	creatertype = "0";
	if(logintype.equals("2"))
	   	creatertype = "1";
String linkname="";
int destnodeid=0;
int totalgroups=0;
int passedgroups=0;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

char flag=Util.getSeparator() ;
String Procpara="";
String sql="";

if(src.equals("save")&&iscreate.equals("1")) {//新建request且选择保存
	RecordSet.executeProc("workflow_RequestID_Update","");
        RecordSet.next();
        requestid = RecordSet.getInt(1);
        
        String sqltmp = " insert into LgcStockInOut(instockno) values(0)";
        RecordSet.executeSql(sqltmp);
        sqltmp = " select max(id) from LgcStockInOut";
        RecordSet.executeSql(sqltmp);
        if(RecordSet.next())
        	billid = RecordSet.getInt(1);
            
       int defcurrencyid = Util.getIntValue(request.getParameter("defcurrencyid"),0);
        int currencyid = 0;
        float exchangerate =0;
        	
        //加入字段信息        
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
        		
        	if(fieldname.equals("currencyid"))
        		currencyid = Util.getIntValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("exchangerate"))
        		exchangerate = Util.getFloatValue(request.getParameter("field"+fieldid));
        	
        }             
        
        
        //add to stockindetail
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
	float countprice =0;
	float counttax=0;
	
	for(int i=0;i<rowsum;i++) {		
		int assetid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_assetid")),0);
		String batchmark = Util.null2String(request.getParameter("node_"+i+"_batchmark"));
		float number = Util.getFloatValue(request.getParameter("node_"+i+"_number"));
		float unitprice = Util.getFloatValue(request.getParameter("node_"+i+"_unitprice"));
		int taxrate = Util.getIntValue(request.getParameter("node_"+i+"_taxrate"));
		float defunitprice = unitprice/exchangerate;
		
		String para = ""+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
		RecordSet.executeProc("LgcStockInOutDetail_Insert",para);
		countprice += (number*unitprice)*(1+taxrate/100.0);
		counttax += (number*unitprice)*(taxrate/100.0);
	}	
			
	float defcountprice = countprice/exchangerate;
	float defcounttax = counttax/exchangerate;
	        
        for(int i=1;i<=5;i++)
        	updateclause += "datefield"+i+" = '"+Util.null2String(request.getParameter("dff0"+i))+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "numberfield"+i+" = "+Util.getFloatValue(request.getParameter("nff0"+i),0)+",";
        for(int i=1;i<=5;i++)
        	updateclause += "textfield"+i+" = '"+Util.fromScreen2(request.getParameter("tff0"+i),user.getLanguage())+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "tinyintfield"+i+" = "+Util.getIntValue(request.getParameter("bff0"+i),0)+",";
       
       
       updateclause += "modetype = '0',createrid="+userid+",createdate='"+CurrentDate+"',defcurrencyid="+defcurrencyid+",";
       updateclause += "defcountprice="+defcountprice+",defcounttax="+defcounttax+",countprice="+countprice+",counttax="+counttax+",status='0',";
       
       
        updateclause=updateclause.substring(0,updateclause.length()-1);
        updateclause="update LgcStockInOut "+updateclause+" where id="+billid;
        RecordSet.executeSql(updateclause);
  //      out.print(updateclause);
        RecordSet.executeSql("insert into workflow_form (requestid,billformid,billid) values ("+requestid+",2,"+billid+")");
	
        //加入request总表信息
        Procpara=requestid+""+ flag + workflowid+"" + flag + "" + flag + "" + flag 
        		+ nodeid+"" + flag + nodetype + flag + SystemEnv.getHtmlLabelName(125,user.getLanguage()) + flag
        		+ "" + flag + "" + flag + requestname + flag + userid+"" + flag + CurrentDate + flag
        		+ CurrentTime + flag + "" + flag + "" + flag + "" + flag + "";
        RecordSet.executeProc("workflow_Requestbase_Insert",Procpara);
        
        //加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "1" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
       RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        
        //加入operator信息
        String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
        Procpara=requestid+"" + flag + userid+"" + flag + "" + flag + workflowid+"" + flag + workflowtype;
      RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
}

if(src.equals("submit")&&iscreate.equals("1")) {//新建request且选择提交
	RecordSet.executeProc("workflow_RequestID_Update","");
        RecordSet.next();
        requestid = RecordSet.getInt(1);
        
       String sqltmp = " insert into LgcStockInOut(instockno) values(0)";
        RecordSet.executeSql(sqltmp);
        sqltmp = " select max(id) from LgcStockInOut";
        RecordSet.executeSql(sqltmp);
        if(RecordSet.next())
        	billid = RecordSet.getInt(1);
        	
        	
      int defcurrencyid = Util.getIntValue(request.getParameter("defcurrencyid"),0);
        int currencyid = 0;
        float exchangerate =0;
        	
        //加入字段信息        
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
        		
        	if(fieldname.equals("currencyid"))
        		currencyid = Util.getIntValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("exchangerate"))
        		exchangerate = Util.getFloatValue(request.getParameter("field"+fieldid));
        	
        }             
        
        
        //add to stockindetail
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
	float countprice =0;
	float counttax=0;
	
	for(int i=0;i<rowsum;i++) {		
		int assetid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_assetid")),0);
		String batchmark = Util.null2String(request.getParameter("node_"+i+"_batchmark"));
		float number = Util.getFloatValue(request.getParameter("node_"+i+"_number"));
		float unitprice = Util.getFloatValue(request.getParameter("node_"+i+"_unitprice"));
		int taxrate = Util.getIntValue(request.getParameter("node_"+i+"_taxrate"));
		float defunitprice = unitprice/exchangerate;
		
		String para = ""+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
		RecordSet.executeProc("LgcStockInOutDetail_Insert",para);
		countprice += (number*unitprice)*(1+taxrate/100.0);
		counttax += (number*unitprice)*(taxrate/100.0);
	}	
			
	float defcountprice = countprice/exchangerate;
	float defcounttax = counttax/exchangerate;
        
        for(int i=1;i<=5;i++)
        	updateclause += "datefield"+i+" = '"+Util.null2String(request.getParameter("dff0"+i))+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "numberfield"+i+" = "+Util.getFloatValue(request.getParameter("nff0"+i),0)+",";
        for(int i=1;i<=5;i++)
        	updateclause += "textfield"+i+" = '"+Util.fromScreen2(request.getParameter("tff0"+i),user.getLanguage())+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "tinyintfield"+i+" = "+Util.getIntValue(request.getParameter("bff0"+i),0)+",";
       
       
       updateclause += "modetype = '0',createrid="+userid+",createdate='"+CurrentDate+"',defcurrencyid="+defcurrencyid+",";
       updateclause += "defcountprice="+defcountprice+",defcounttax="+defcounttax+",countprice="+countprice+",counttax="+counttax+",status='0',";
       
       
        updateclause=updateclause.substring(0,updateclause.length()-1);
        updateclause="update LgcStockInOut "+updateclause+" where id="+billid;
        RecordSet.executeSql(updateclause);
        out.print(updateclause);
        RecordSet.executeSql("insert into workflow_form (requestid,billformid,billid) values ("+requestid+",2,"+billid+")");
	
	
   //查询下一节点
	RecordSet.executeProc("workflow_NodeLink_Select",nodeid+""+flag+"0"+flag+""+requestid);
	ArrayList whereclauses=new ArrayList();
	ArrayList linknames=new ArrayList();
	ArrayList destnodeids=new ArrayList();
	while(RecordSet.next()){
		//whereclauses.add(RecordSet.getString("condition"));
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
			sql="select * from LgcStockInOut where id="+billid+" and "+where;
			RecordSet.executeSql(sql);
			if(RecordSet.next())	break;
		}
	}
	linkname=(String) linknames.get(i);
	destnodeid=Util.getIntValue((String)destnodeids.get(i),0);
        
        //加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "2" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        
        //加入operator信息
        String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
        ArrayList groupids=new ArrayList();
        ArrayList userparameters=new ArrayList();
        RecordSet.executeProc("workflow_NodeGroup_Select",destnodeid+"");
        while(RecordSet.next()){
        	groupids.add(RecordSet.getString("id"));
        	userparameters.add(RecordSet.getString("userparameter"));
        }
        totalgroups=groupids.size();
        for(i=0;i<groupids.size();i++){
        	String groupid=(String)groupids.get(i);
        	String userparameter=(String)userparameters.get(i);
        	RequestCheckUser.setSqlwhere(userparameter);
        	RequestCheckUser.selectUser();
        	while(RequestCheckUser.next()){
	        	int tempuserid=RequestCheckUser.getUserid();
	        	Procpara=requestid+"" + flag + tempuserid+"" + flag + groupid + flag + workflowid+"" + flag + workflowtype;
	        	out.print(Procpara);
	        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
        	}
        	RequestCheckUser.closeStatement();
        }
        if(totalgroups==0){
        	String user_fieldid="";
        	RecordSet.executeProc("workflow_Nodebase_SelectByID",destnodeid+"");
        	if(RecordSet.next())	user_fieldid=RecordSet.getString("userids");
		if(!user_fieldid.equals("")){
			String[] user_fieldids=Util.TokenizerString2(user_fieldid,",");
			for(int a=0;a<user_fieldids.length;a++){
				String tempstring =Util.null2String(user_fieldids[a]);
				if(tempstring.substring(0,1).equalsIgnoreCase("m")){
					int tempfieldid=Util.getIntValue(tempstring.substring(1),0);
					RecordSet.executeProc("workflow_billfield_SelectByID",""+tempfieldid);
					RecordSet.next();
					String tempfieldname=RecordSet.getString("fieldname");
					RecordSet.executeProc("workflow_BillValue_Select",requestid+"");
					RecordSet.next();
					String tempuserid=RecordSet.getString(tempfieldname);
					String managerid=ResourceComInfo.getManagerID(tempuserid);
					if(managerid.equals("0"))	managerid=tempuserid;
			        	Procpara=requestid+"" + flag + managerid+"" + flag + "0" + flag + workflowid+"" + flag + workflowtype;
			        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
				}
				else{
					int tempfieldid=Util.getIntValue(user_fieldids[a],0);
					RecordSet.executeProc("workflow_billfield_SelectByID",""+tempfieldid);
					RecordSet.next();
					String tempfieldname=RecordSet.getString("fieldname");
					RecordSet.executeProc("workflow_BillValue_Select",requestid+"");
					RecordSet.next();
					String tempuserid=RecordSet.getString(tempfieldname);
			        	Procpara=requestid+"" + flag + tempuserid+"" + flag + "0" + flag + workflowid+"" + flag + workflowtype;
			        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
		        	}
		        }
		}
        }

	//加入request总表信息        
        RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
        RecordSet.next();
        String destnodetype=RecordSet.getString(1);
        
        Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
        		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
        		+ "0" + flag + totalgroups+"" + flag + requestname + flag + userid+"" + flag + CurrentDate + flag
        		+ CurrentTime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "";
        RecordSet.executeProc("workflow_Requestbase_Insert",Procpara);
}
//更新request level信息
if(iscreate.equals("1")){
    RecordSet.executeProc("workflow_Rbase_UpdateLevel",""+requestid+flag+requestlevel);
}

if(src.equals("delete")&&iscreate.equals("0")){//处理request且选择删除logtype=5
	//基本信息
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
	//设置base表中的deleted字段为1
	Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype+"" + flag 
        		+ nodeid+"" + flag + nodetype + flag + status + flag
        		+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "1";
        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
	
	//加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "5" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
}

if(src.equals("save")&&iscreate.equals("0")){//处理request且选择保存logtype=1
        //基本信息
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
        
        	
        int defcurrencyid = Util.getIntValue(request.getParameter("defcurrencyid"),0);
        int currencyid = 0;
        float exchangerate =0;
        	
        //加入字段信息        
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
        		
        	if(fieldname.equals("currencyid"))
        		currencyid = Util.getIntValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("exchangerate"))
        		exchangerate = Util.getFloatValue(request.getParameter("field"+fieldid));
        	
        }             
        
        
        //add to stockindetail
        String delids = Util.null2String(request.getParameter("delids"));
  	if(!delids.equals("")){
  		delids = delids.substring(1);
	  	String sqltmp1 = " delete from LgcStockInOutDetail where id in ("+delids+")";
	  	RecordSet.executeSql(sqltmp1);
	}	
	
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
	float countprice =0;
	float counttax=0;
	
	
	for(int i=0;i<rowsum;i++) {		
		int assetid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_assetid")),0);
		int tmpid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_id")),0);
		String batchmark = Util.null2String(request.getParameter("node_"+i+"_batchmark"));
		float number = Util.getFloatValue(request.getParameter("node_"+i+"_number"));
		float unitprice = Util.getFloatValue(request.getParameter("node_"+i+"_unitprice"));
		int taxrate = Util.getIntValue(request.getParameter("node_"+i+"_taxrate"));
		float defunitprice = unitprice/exchangerate;
		
		if(tmpid==0 && assetid!=0){
			String para = ""+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Insert",para);
		}
		else if(tmpid!=0 && assetid !=0){
			String para = ""+tmpid+flag+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Update",para);
		}
	}	
	RecordSet.executeProc("LgcStockInOutDetail_Select",""+billid);
	while(RecordSet.next()){
		float number = RecordSet.getFloat("number_n");
		float unitprice = RecordSet.getFloat("unitprice");
		int taxrate = RecordSet.getInt("taxrate");
		countprice += (number*unitprice)*(1+taxrate/100.0);
		counttax += (number*unitprice)*(taxrate/100.0);
	}
			
	float defcountprice = countprice/exchangerate;
	float defcounttax = counttax/exchangerate;
        
        for(int i=1;i<=5;i++)
        	updateclause += "datefield"+i+" = '"+Util.null2String(request.getParameter("dff0"+i))+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "numberfield"+i+" = "+Util.getFloatValue(request.getParameter("nff0"+i),0)+",";
        for(int i=1;i<=5;i++)
        	updateclause += "textfield"+i+" = '"+Util.fromScreen2(request.getParameter("tff0"+i),user.getLanguage())+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "tinyintfield"+i+" = "+Util.getIntValue(request.getParameter("bff0"+i),0)+",";
       
       updateclause += "defcountprice="+defcountprice+",defcounttax="+defcounttax+",countprice="+countprice+",counttax="+counttax+",status='0',";
       
       
        updateclause=updateclause.substring(0,updateclause.length()-1);
        updateclause="update LgcStockInOut "+updateclause+" where id="+billid;
        RecordSet.executeSql(updateclause);
               
       
        //加入request总表信息
        Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype + flag 
        		+ nodeid+"" + flag + nodetype + flag + status + flag
        		+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        		+ createdate + flag + createtime + flag + lastoperator+"" + flag 
        		+ lastoperatedate + flag + lastoperatetime + flag + "";
        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
        
        //加入LOG表信息
        int isremark=Util.getIntValue(request.getParameter("isremark"),0);

        String logtype  = "1" ;
        if(isremark==1) logtype = "9" ;
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + logtype + flag 
            + CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);  
        //删除remark操作者记录
        if(isremark==1){
        	RecordSet.executeSql("delete from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and isremark='1'");
        }
}

if(src.equals("submit")&&iscreate.equals("0")){//处理request且选择提交logtype=2
	//基本信息
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
        
        String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
        
        	
        int defcurrencyid = Util.getIntValue(request.getParameter("defcurrencyid"),0);
        int currencyid = 0;
        float exchangerate =0;
        int warehouseid = 0;
        	
        //加入字段信息        
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
        		
        	if(fieldname.equals("currencyid"))
        		currencyid = Util.getIntValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("exchangerate"))
        		exchangerate = Util.getFloatValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("warehouseid"))
        		warehouseid = Util.getIntValue(request.getParameter("field"+fieldid));
        	
        }             
        
        
        //add to stockindetail
        String delids = Util.null2String(request.getParameter("delids"));
  	if(!delids.equals("")){
  		delids = delids.substring(1);
	  	String sqltmp1 = " delete from LgcStockInOutDetail where id in ("+delids+")";
	  	RecordSet.executeSql(sqltmp1);
	}	
	
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
	float countprice =0;
	float counttax=0;
	
	
	for(int i=0;i<rowsum;i++) {		
		int assetid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_assetid")),0);
		int tmpid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_id")),0);
		String batchmark = Util.null2String(request.getParameter("node_"+i+"_batchmark"));
		float number = Util.getFloatValue(request.getParameter("node_"+i+"_number"));
		float unitprice = Util.getFloatValue(request.getParameter("node_"+i+"_unitprice"));
		int taxrate = Util.getIntValue(request.getParameter("node_"+i+"_taxrate"));
		float defunitprice = unitprice/exchangerate;
		
		if(tmpid==0 && assetid!=0){
			String para = ""+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Insert",para);
		}
		else if(tmpid!=0 && assetid !=0){
			String para = ""+tmpid+flag+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Update",para);
		}
	}	
	RecordSet.executeProc("LgcStockInOutDetail_Select",""+billid);
	while(RecordSet.next()){
		float number = RecordSet.getFloat("number_n");
		float unitprice = RecordSet.getFloat("unitprice");
		int taxrate = RecordSet.getInt("taxrate");
		countprice += (number*unitprice)*(1+taxrate/100.0);
		counttax += (number*unitprice)*(taxrate/100.0);
	}
			
	float defcountprice = countprice/exchangerate;
	float defcounttax = counttax/exchangerate;
        
        for(int i=1;i<=5;i++)
        	updateclause += "datefield"+i+" = '"+Util.null2String(request.getParameter("dff0"+i))+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "numberfield"+i+" = "+Util.getFloatValue(request.getParameter("nff0"+i),0)+",";
        for(int i=1;i<=5;i++)
        	updateclause += "textfield"+i+" = '"+Util.fromScreen2(request.getParameter("tff0"+i),user.getLanguage())+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "tinyintfield"+i+" = "+Util.getIntValue(request.getParameter("bff0"+i),0)+",";
        	
       updateclause += "defcountprice="+defcountprice+",defcounttax="+defcounttax+",countprice="+countprice+",counttax="+counttax+",";
       if(nodetype.equals("2")){
       		updateclause +="status='1',";
       		RecordSet.executeProc("LgcStockInOutDetail_Select",""+billid);
		while(RecordSet.next()){
			int tmpaccetid = RecordSet.getInt("assetid");
			float tmpnumber = RecordSet.getFloat("number_n");
			float tmpunitprice = RecordSet.getFloat("unitprice");
			String sqlcheck = "select * from LgcAssetStock where warehouseid="+warehouseid+" and assetid="+tmpaccetid;
			RecordSet1.executeSql(sqlcheck);
			if(RecordSet1.next()){
				int tmpid = RecordSet1.getInt("id");
				float oldnumber = RecordSet1.getFloat("stocknum");
				float oldunitprice = RecordSet1.getFloat("unitprice");
				tmpunitprice = (tmpnumber*tmpunitprice +oldnumber*oldunitprice )/(tmpnumber+oldnumber);
				tmpnumber += oldnumber;
				String sqlup = "update LgcAssetStock set stocknum="+tmpnumber+",unitprice="+tmpunitprice+" where id="+tmpid;
				RecordSet1.executeSql(sqlup);
			}
			else{
				String sqlin = " insert into LgcAssetStock(warehouseid,assetid,stocknum,unitprice) values("+warehouseid+","+tmpaccetid+","+tmpnumber+","+tmpunitprice+")";
				RecordSet1.executeSql(sqlin);
			}			
		}  
       }
       
        updateclause=updateclause.substring(0,updateclause.length()-1);
        updateclause="update LgcStockInOut "+updateclause+" where id="+billid;
        RecordSet.executeSql(updateclause);
          
	//加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "2" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
        
        //先检查passedgroups个数
        sql="select count(distinct groupid) from workflow_currentoperator where requestid="+requestid+" and userid="+userid;
        RecordSet.executeSql(sql);
        if(RecordSet.next())	passedgroups+=RecordSet.getInt(1);
        out.print(passedgroups+"---");
        if(passedgroups<totalgroups){//当前节点没有完全审批通过，继续停留在当前节点
        	//更新operator表
        	sql="delete from workflow_currentoperator where requestid="+requestid+
        	" and groupid in( select distinct groupid from workflow_currentoperator where requestid="+requestid+
        	" and userid="+userid+")";
        	RecordSet.executeSql(sql);
        	//更新request总表信息        
	        Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype+"" + flag 
	        		+ nodeid+"" + flag + nodetype + flag + status + flag
	        		+ passedgroups + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
	        		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "";
	        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
        }
        else{//当前节点完全审批通过，流向下一节点
        	//删除原有operator记录
        	sql="delete from workflow_currentoperator where requestid="+requestid;
        	RecordSet.executeSql(sql);
        	//查询下一节点
		RecordSet.executeProc("workflow_NodeLink_Select",nodeid+""+flag+"0"+flag+""+requestid);
		ArrayList whereclauses=new ArrayList();
		ArrayList linknames=new ArrayList();
		ArrayList destnodeids=new ArrayList();
		while(RecordSet.next()){
			//whereclauses.add(RecordSet.getString("condition"));
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
				sql="select * from LgcStockInOut where id="+billid+" and "+where;
				RecordSet.executeSql(sql);
				if(RecordSet.next())	break;
			}
		}
		linkname=(String) linknames.get(i);
		destnodeid=Util.getIntValue((String)destnodeids.get(i),0);
		out.print(destnodeid+";1-");
		
		//加入operator信息
		ArrayList groupids=new ArrayList();
	        ArrayList userparameters=new ArrayList();
	        RecordSet.executeProc("workflow_NodeGroup_Select",destnodeid+"");
	        while(RecordSet.next()){
	        	groupids.add(RecordSet.getString("id"));
	        	userparameters.add(RecordSet.getString("userparameter"));
	        }
	        totalgroups=groupids.size();
	        out.print(totalgroups+";2-");
	        for(i=0;i<groupids.size();i++){
	        	String groupid=(String)groupids.get(i);
	        	String userparameter=(String)userparameters.get(i);
	        	RequestCheckUser.setSqlwhere(userparameter);
	        	RequestCheckUser.selectUser();
	        	while(RequestCheckUser.next()){
		        	int tempuserid=RequestCheckUser.getUserid();
		        	Procpara=requestid+"" + flag + tempuserid+"" + flag + groupid + flag + workflowid+"" + flag + workflowtype;
		        	out.print(Procpara+";3-");
		        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
	        	}
	        	RequestCheckUser.closeStatement();
	        }
	        if(totalgroups==0){
	        	String user_fieldid="";
	        	RecordSet.executeProc("workflow_Nodebase_SelectByID",destnodeid+"");
	        	if(RecordSet.next())	user_fieldid=RecordSet.getString("userids");
			if(!user_fieldid.equals("")){
				String[] user_fieldids=Util.TokenizerString2(user_fieldid,",");
				for(int a=0;a<user_fieldids.length;a++){
					String tempstring =Util.null2String(user_fieldids[a]);
					if(tempstring.substring(0,1).equalsIgnoreCase("m")){
						int tempfieldid=Util.getIntValue(tempstring.substring(1),0);
						RecordSet.executeProc("workflow_billfield_SelectByID",""+tempfieldid);
					RecordSet.next();
					String tempfieldname=RecordSet.getString("fieldname");
						RecordSet.executeProc("workflow_BillValue_Select",requestid+"");
						RecordSet.next();
						String tempuserid=RecordSet.getString(tempfieldname);
						String managerid=ResourceComInfo.getManagerID(tempuserid);
						if(managerid.equals("0"))	managerid=tempuserid;
				        	Procpara=requestid+"" + flag + managerid+"" + flag + "0" + flag + workflowid+"" + flag + workflowtype;
				        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
					}
					else{
						int tempfieldid=Util.getIntValue(user_fieldids[a],0);
						RecordSet.executeProc("workflow_billfield_SelectByID",""+tempfieldid);
					RecordSet.next();
					String tempfieldname=RecordSet.getString("fieldname");
						RecordSet.executeProc("workflow_BillValue_Select",requestid+"");
						RecordSet.next();
						String tempuserid=RecordSet.getString(tempfieldname);
				        	Procpara=requestid+"" + flag + tempuserid+"" + flag + "0" + flag + workflowid+"" + flag + workflowtype;
				        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
			        	}
			        }
			}
	        }
	        //更新request总表信息        
	        RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
	        RecordSet.next();
	        String destnodetype=RecordSet.getString(1);
	        
	        Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
	        		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
	        		+ "0" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
	        		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "";
	        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);	
       
        }
}

if(src.equals("reject")&&iscreate.equals("0")){//处理request且选择退回logtype=3
	//基本信息
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
        
        String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
        
         	
        int defcurrencyid = Util.getIntValue(request.getParameter("defcurrencyid"),0);
        int currencyid = 0;
        float exchangerate =0;
        	
        //加入字段信息        
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
        	if(fieldname.equals("currencyid"))
        		currencyid = Util.getIntValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("exchangerate"))
        		exchangerate = Util.getFloatValue(request.getParameter("field"+fieldid));
        	
        }             
        
        
        //add to stockindetail
        String delids = Util.null2String(request.getParameter("delids"));
  	if(!delids.equals("")){
  		delids = delids.substring(1);
	  	String sqltmp1 = " delete from LgcStockInOutDetail where id in ("+delids+")";
	  	RecordSet.executeSql(sqltmp1);
	}	
	
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
	float countprice =0;
	float counttax=0;
	
	
	for(int i=0;i<rowsum;i++) {		
		int assetid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_assetid")),0);
		int tmpid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_id")),0);
		String batchmark = Util.null2String(request.getParameter("node_"+i+"_batchmark"));
		float number = Util.getFloatValue(request.getParameter("node_"+i+"_number"));
		float unitprice = Util.getFloatValue(request.getParameter("node_"+i+"_unitprice"));
		int taxrate = Util.getIntValue(request.getParameter("node_"+i+"_taxrate"));
		float defunitprice = unitprice/exchangerate;
		
		if(tmpid==0 && assetid!=0){
			String para = ""+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Insert",para);
		}
		else if(tmpid!=0 && assetid !=0){
			String para = ""+tmpid+flag+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Update",para);
		}
	}	
	RecordSet.executeProc("LgcStockInOutDetail_Select",""+billid);
	while(RecordSet.next()){
		float number = RecordSet.getFloat("number_n");
		float unitprice = RecordSet.getFloat("unitprice");
		int taxrate = RecordSet.getInt("taxrate");
		countprice += (number*unitprice)*(1+taxrate/100.0);
		counttax += (number*unitprice)*(taxrate/100.0);
	}
			
	float defcountprice = countprice/exchangerate;
	float defcounttax = counttax/exchangerate;
        
        for(int i=1;i<=5;i++)
        	updateclause += "datefield"+i+" = '"+Util.null2String(request.getParameter("dff0"+i))+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "numberfield"+i+" = "+Util.getFloatValue(request.getParameter("nff0"+i),0)+",";
        for(int i=1;i<=5;i++)
        	updateclause += "textfield"+i+" = '"+Util.fromScreen2(request.getParameter("tff0"+i),user.getLanguage())+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "tinyintfield"+i+" = "+Util.getIntValue(request.getParameter("bff0"+i),0)+",";
       
       updateclause += "defcountprice="+defcountprice+",defcounttax="+defcounttax+",countprice="+countprice+",counttax="+counttax+",status='0',";
       
       
        updateclause=updateclause.substring(0,updateclause.length()-1);
        updateclause="update LgcStockInOut "+updateclause+" where id="+billid;
        RecordSet.executeSql(updateclause);
           
	//加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "3" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
	//查询下一节点
	RecordSet.executeProc("workflow_NodeLink_Select",nodeid+""+flag+"1"+flag+""+requestid);
	ArrayList whereclauses=new ArrayList();
	ArrayList linknames=new ArrayList();
	ArrayList destnodeids=new ArrayList();
	while(RecordSet.next()){
		//whereclauses.add(RecordSet.getString("condition"));
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
			sql="select * from LgcStockInOut where id="+billid+" and "+where;
			RecordSet.executeSql(sql);
			if(RecordSet.next())	break;
		}
	}
	linkname=(String) linknames.get(i);
	destnodeid=Util.getIntValue((String)destnodeids.get(i),0);
	 RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
        RecordSet.next();
        String destnodetype=RecordSet.getString(1);
        
	//加入operator信息,先删除operator表中的相关记录，再插入新的记录
if(!destnodetype.equals("0")){
	sql="delete from workflow_currentoperator where requestid="+requestid;
	RecordSet.executeSql(sql);
	
        ArrayList groupids=new ArrayList();
        ArrayList userparameters=new ArrayList();
        RecordSet.executeProc("workflow_NodeGroup_Select",destnodeid+"");
        while(RecordSet.next()){
        	groupids.add(RecordSet.getString("id"));
        	userparameters.add(RecordSet.getString("userparameter"));
        }
        totalgroups=groupids.size();
        for(i=0;i<groupids.size();i++){
        	String groupid=(String)groupids.get(i);
        	String userparameter=(String)userparameters.get(i);
        	RequestCheckUser.setSqlwhere(userparameter);
        	RequestCheckUser.selectUser();
        	while(RequestCheckUser.next()){
	        	int tempuserid=RequestCheckUser.getUserid();
	        	Procpara=requestid+"" + flag + tempuserid+"" + flag + groupid + flag + workflowid+"" + flag + workflowtype;
	        	out.print(Procpara);
	        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
        	}
        	RequestCheckUser.closeStatement();
        }
        if(totalgroups==0){
        	String user_fieldid="";
        	RecordSet.executeProc("workflow_Nodebase_SelectByID",destnodeid+"");
        	if(RecordSet.next())	user_fieldid=RecordSet.getString("userids");
		if(!user_fieldid.equals("")){
			String[] user_fieldids=Util.TokenizerString2(user_fieldid,",");
			for(int a=0;a<user_fieldids.length;a++){
				String tempstring =Util.null2String(user_fieldids[a]);
				if(tempstring.substring(0,1).equalsIgnoreCase("m")){
					int tempfieldid=Util.getIntValue(tempstring.substring(1),0);
					RecordSet.executeProc("workflow_billfield_SelectByID",""+tempfieldid);
					RecordSet.next();
					String tempfieldname=RecordSet.getString("fieldname");
					RecordSet.executeProc("workflow_BillValue_Select",requestid+"");
					RecordSet.next();
					String tempuserid=RecordSet.getString(tempfieldname);
					String managerid=ResourceComInfo.getManagerID(tempuserid);
					if(managerid.equals("0"))	managerid=tempuserid;
			        	Procpara=requestid+"" + flag + managerid+"" + flag + "0" + flag + workflowid+"" + flag + workflowtype;
			        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
				}
				else{
					int tempfieldid=Util.getIntValue(user_fieldids[a],0);
					RecordSet.executeProc("workflow_billfield_SelectByID",""+tempfieldid);
					RecordSet.next();
					String tempfieldname=RecordSet.getString("fieldname");
					RecordSet.executeProc("workflow_BillValue_Select",requestid+"");
					RecordSet.next();
					String tempuserid=RecordSet.getString(tempfieldname);
			        	Procpara=requestid+"" + flag + tempuserid+"" + flag + "0" + flag + workflowid+"" + flag + workflowtype;
			        	RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
		        	}
		        }
		}
       }
}
else{//next node is create
	sql="delete from workflow_currentoperator where requestid="+requestid;
	RecordSet.executeSql(sql);
        
        Procpara=requestid+"" + flag + creater+"" + flag + "" + flag + workflowid+"" + flag + workflowtype;
        RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
}
        //加入request总表信息        
       
        Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
        		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
        		+ "0" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag + createdate + flag
        		+ createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "";
        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
}

if(src.equals("reopen")&&iscreate.equals("0")){//处理request且选择重新打开logtype=4
	//基本信息
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
        
        String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");
        
        	
        int defcurrencyid = Util.getIntValue(request.getParameter("defcurrencyid"),0);
        int currencyid = 0;
        float exchangerate =0;
        	
        //加入字段信息        
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
        	if(fieldname.equals("currencyid"))
        		currencyid = Util.getIntValue(request.getParameter("field"+fieldid));
        	if(fieldname.equals("exchangerate"))
        		exchangerate = Util.getFloatValue(request.getParameter("field"+fieldid));
        	
        }             
        
        
        //add to stockindetail
        String delids = Util.null2String(request.getParameter("delids"));
  	if(!delids.equals("")){
  		delids = delids.substring(1);
	  	String sqltmp1 = " delete from LgcStockInOutDetail where id in ("+delids+")";
	  	RecordSet.executeSql(sqltmp1);
	}	
	
        int rowsum = Util.getIntValue(Util.null2String(request.getParameter("nodesnum")));
	float countprice =0;
	float counttax=0;
	
	
	for(int i=0;i<rowsum;i++) {		
		int assetid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_assetid")),0);
		int tmpid = Util.getIntValue(Util.null2String(request.getParameter("node_"+i+"_id")),0);
		String batchmark = Util.null2String(request.getParameter("node_"+i+"_batchmark"));
		float number = Util.getFloatValue(request.getParameter("node_"+i+"_number"));
		float unitprice = Util.getFloatValue(request.getParameter("node_"+i+"_unitprice"));
		int taxrate = Util.getIntValue(request.getParameter("node_"+i+"_taxrate"));
		float defunitprice = unitprice/exchangerate;
		
		if(tmpid==0 && assetid!=0){
			String para = ""+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Insert",para);
		}
		else if(tmpid!=0 && assetid !=0){
			String para = ""+tmpid+flag+billid+flag+assetid+flag+batchmark+flag + number+flag+currencyid+flag+defcurrencyid+flag+exchangerate +flag+defunitprice+flag+unitprice+flag+taxrate;
			RecordSet.executeProc("LgcStockInOutDetail_Update",para);
		}
	}	
	RecordSet.executeProc("LgcStockInOutDetail_Select",""+billid);
	while(RecordSet.next()){
		float number = RecordSet.getFloat("number_n");
		float unitprice = RecordSet.getFloat("unitprice");
		int taxrate = RecordSet.getInt("taxrate");
		countprice += (number*unitprice)*(1+taxrate/100.0);
		counttax += (number*unitprice)*(taxrate/100.0);
	}
			
	float defcountprice = countprice/exchangerate;
	float defcounttax = counttax/exchangerate;
        
        for(int i=1;i<=5;i++)
        	updateclause += "datefield"+i+" = '"+Util.null2String(request.getParameter("dff0"+i))+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "numberfield"+i+" = "+Util.getFloatValue(request.getParameter("nff0"+i),0)+",";
        for(int i=1;i<=5;i++)
        	updateclause += "textfield"+i+" = '"+Util.fromScreen2(request.getParameter("tff0"+i),user.getLanguage())+"',";
        for(int i=1;i<=5;i++)
        	updateclause += "tinyintfield"+i+" = "+Util.getIntValue(request.getParameter("bff0"+i),0)+",";
       
       updateclause += "defcountprice="+defcountprice+",defcounttax="+defcounttax+",countprice="+countprice+",counttax="+counttax+",status='0',";
       
       
        updateclause=updateclause.substring(0,updateclause.length()-1);
        updateclause="update LgcStockInOut "+updateclause+" where id="+billid;
        RecordSet.executeSql(updateclause);
          
	//加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "4" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
	//查询下一节点即create节点
	RecordSet.executeProc("workflow_CreateNode_Select",workflowid+"");
	RecordSet.next();
	destnodeid=RecordSet.getInt(1);
	linkname="reopen";
	totalgroups=0;
	//加入operator信息,先删除operator表中的相关记录，再插入新的记录
	sql="delete from workflow_currentoperator where requestid="+requestid;
	RecordSet.executeSql(sql);
        
        Procpara=requestid+"" + flag + creater+"" + flag + "" + flag + workflowid+"" + flag + workflowtype;
        RecordSet.executeProc("workflow_CurrentOperator_I",Procpara);
        //加入request总表信息        
        RecordSet.executeProc("workflow_NodeType_Select",workflowid+""+flag+destnodeid+"");
        RecordSet.next();
        String destnodetype=RecordSet.getString(1);
        Procpara=requestid+""+ flag + workflowid+"" + flag + nodeid+"" + flag + nodetype+"" + flag 
        		+ destnodeid+"" + flag + destnodetype + flag + linkname + flag
        		+ "0" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag + createdate + flag
        		+ createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "";
        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
}

if(src.equals("active")){//激活request logtype=6
	//基本信息
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
	//设置base表中的deleted字段为0
	Procpara=requestid+""+ flag + workflowid+"" + flag + lastnodeid+"" + flag + lastnodetype+"" + flag 
        		+ nodeid+"" + flag + nodetype + flag + status + flag
        		+ passedgroups+"" + flag + totalgroups+"" + flag + requestname + flag + creater+"" + flag 
        		+ createdate + flag + createtime + flag + userid+"" + flag + CurrentDate + flag + CurrentTime + flag + "0";
        RecordSet.executeProc("workflow_Requestbase_Update",Procpara);
	
	//加入LOG表信息
        Procpara=requestid+"" + flag + workflowid+"" + flag + nodeid+"" + flag + "6" + flag 
        	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag + clientip+ flag + creatertype
        	+ flag + "0"+ flag + "" + flag + -1+ flag + "0"+ flag + -1+flag+""+flag+"0"+ flag + signdocids+flag+signworkflowids;
        RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);

}

	//response.sendRedirect("/workflow/request/RequestView.jsp");
	out.print("<script>wfforward('/workflow/request/RequestView.jsp');</script>");
%>