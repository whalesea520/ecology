<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@ page import="weaver.hrm.*" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion,weaver.workflow.request.todo.RequestUtil"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WrokflowOverTimeTimer" class="weaver.system.WrokflowOverTimeTimer" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="HrmListValidate" class="weaver.hrm.resource.HrmListValidate" scope="page" />
<jsp:useBean id="SystemEnv" class="weaver.systeminfo.SystemEnv" scope="page"/>
<%
	User user = HrmUserVarify.getUser (request , response) ;
    boolean isopenos = RequestUtil.isOpenOtherSystemToDo();//是否开启统一待办
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
	String loadtree = Util.null2String(request.getParameter("loadtree"));
    //System.out.println("loadtree:"+loadtree);
		boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
		int requestid = Util.getIntValue((String)session.getAttribute("requestidForAllBill"),0);
		String topage_ForAllBill = Util.null2String((String)session.getAttribute("topage_ForAllBill"));
		
		if(!"".equals(topage_ForAllBill)){
		if(topage_ForAllBill.indexOf("/proj/process/ViewTask.jsp") == 0 || topage_ForAllBill.indexOf("/proj/plan/ViewTask.jsp") == 0){
			response.sendRedirect(topage_ForAllBill+"&requestid="+requestid);
			session.setAttribute("topage_ForAllBill","");
			return;
		}else if(topage_ForAllBill.indexOf("RequestOperation.jsp") > 0){
			int tempInt = topage_ForAllBill.lastIndexOf("3D");
			String tempString = topage_ForAllBill.substring(tempInt+2);
			response.sendRedirect("/proj/process/ViewTask.jsp?taskrecordid="+tempString+"&requestid="+requestid);
			session.setAttribute("topage_ForAllBill","");
			return;
		}
		}
		
    String resourceid= Util.null2String(request.getParameter("resourceid"));
    AllManagers.getAll(resourceid);
    if("".equals(resourceid)){
    	resourceid = ""+user.getUID();
    }

    boolean isSelf		=	false;
	boolean isManager	=	false;
	RecordSet.executeProc("HrmResource_SelectByID",resourceid);
	RecordSet.next();
	String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*所属部门*/
	if (resourceid.equals(""+user.getUID()) ){
			isSelf = true;
		}
	while(AllManagers.next()){
		String tempmanagerid = AllManagers.getManagerID();
		if (tempmanagerid.equals(""+user.getUID())) {
			isManager = true;
		}
	}
	if(!(((isSelf || isManager || HrmUserVarify.checkUserRight("HrmResource:Workflow",user,departmentid))))){
		//response.sendRedirect("/notice/noright.jsp") ;
	}
    
    String logintype = ""+user.getLogintype();
    int usertype = 0;
    if(logintype.equals("2")) usertype= 1;

    /* edited by wdl 2006-06-14 left menu advanced menu */
    int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
    String selectedContent = Util.null2String(request.getParameter("selectedContent"));
    String menuType = Util.null2String(request.getParameter("menuType"));
    int infoId = Util.getIntValue(request.getParameter("infoId"),0);
	  if(selectedContent!=null && selectedContent.startsWith("key_")){
			String menuid = selectedContent.substring(4);
			RecordSet.executeSql("select * from menuResourceNode where contentindex = '"+menuid+"'");
			selectedContent = "";
			while(RecordSet.next()){
				String keyVal = RecordSet.getString(2);
				selectedContent += keyVal +"|";
			}
			if(selectedContent.indexOf("|")!=-1)
				selectedContent = selectedContent.substring(0,selectedContent.length()-1);
		 }
	if(fromAdvancedMenu == 1){
		response.sendRedirect("/workflow/search/WFSearchCustom.jsp?fromadvancedmenu=1&infoId="+infoId+"&selectedContent="+selectedContent+"&menuType="+menuType);
		return;
	}
    String selectedworkflow = "";
    LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
    LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
    if(info!=null){
    	selectedworkflow = info.getSelectedContent();
    }
    if(!"".equals(selectedContent))
    {
    	selectedworkflow = selectedContent;
    }
    selectedworkflow+="|";
    /* edited end */    
    
 	/*------------------------------主次账号判断----------------------*/
String userID = String.valueOf(user.getUID());
String userIDAll = String.valueOf(user.getUID());
int userid=user.getUID();
String belongtoshow = "";				
		RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
		if(RecordSet.next()){
			belongtoshow = RecordSet.getString("belongtoshow");
		}
		//QC235172,如果不是查看自己的代办，主从账号统一显示不需要判断

		if(!isSelf) belongtoshow = "";
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}

    if(resourceid.equals("")) {
        session.removeAttribute("RequestViewResource") ;
    }
    else {
        session.setAttribute("RequestViewResource",resourceid) ;
    }
    boolean superior = false;  //是否为被查看者上级或者本身


	if("".equals(resourceid) || userID.equals(resourceid))
	{
        resourceid = userID;
		superior = true;
	}
	else
	{
		rs.executeSql("SELECT * FROM HrmResource WHERE ID = " + resourceid + " AND managerStr LIKE '%," + userID + ",%'");
		
		if(rs.next())
		{
			superior = true;	
		}
	}

    char flag = Util.getSeparator();

    String username = Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage());

    if(logintype.equals("2")) username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage()) ;

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename =  SystemEnv.getHtmlLabelName(1207,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
	String tworkflowNodeIDs = "";
%>

<%
	
	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
    String wfsupedcount="";
	String workflowname="";

    ArrayList wftypeList=new ArrayList();
	ArrayList wftypecountList=new ArrayList();
	ArrayList workflowList=new ArrayList();
	ArrayList workflowcountList=new ArrayList();
    ArrayList newremarkwfcount0List=new ArrayList();//待办数量
    ArrayList newremarkwfcount1List=new ArrayList();//反馈数量
    ArrayList wftypeworkflowList=new ArrayList();
    ArrayList wfovertimecountList=new ArrayList();//超时数量
    ArrayList wfsupedcountList = new ArrayList();	//被督办数量


	Hashtable wfNodeHahstable = new Hashtable();
    
    
	Map newremarkwfcount0Map=new Hashtable();//待办数量
	Map newremarkwfcount1Map=new Hashtable();//反馈数量
	Map wftypeworkflowMap=new Hashtable();
	Map wfovertimecountMap=new Hashtable();//超时数量
	Map wfsupedcountMap = new Hashtable();	//被督办数量


    
    int totalcount=0;
    String wftypes = "";
    String demoLeftMenus = "";
    //String SQL = "";
    //SQL = "select workflowtype, workflowid from workflow_currentoperator where (isremark='0' or isremark='1' or isremark='5' or isremark='8' or isremark='9' or isremark='7')  and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +"  and exists (select 1 from workflow_requestbase c where c.workflowid=workflow_currentoperator.workflowid and c.requestid=workflow_currentoperator.requestid)";
   	if(loadtree.equals("true")){
	    StringBuffer sqlsb = new StringBuffer();
	    sqlsb.append("SELECT wt.id workflowtype,wb.id workflowid FROM workflow_type wt,workflow_base wb,( ");
	    sqlsb.append("select workflowtype, workflowid ");
	    sqlsb.append("  from workflow_currentoperator ");
	    sqlsb.append("	  where ((isremark = '0' and (takisremark is null or takisremark=0)) or isremark = '1' or isremark = '5' or ");
	    sqlsb.append("        isremark = '8' or isremark = '9' or isremark = '7')  ");
	    sqlsb.append("   and islasttimes = 1 ");
	    if("1".equals(belongtoshow)){
		sqlsb.append("	    and userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and userid in (").append(resourceid);
		}
	    sqlsb.append(" )  and usertype = ").append(usertype);
		//sqlsb.append(" and  workflowid in (select id from workflow_base where (isvalid=1 or isvalid=3) )  ");
	    sqlsb.append("   and exists (select 1 ");
	    sqlsb.append("          from workflow_requestbase c ");
	    sqlsb.append("         where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = workflow_currentoperator.workflowid ");
	    if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
	    sqlsb.append("           and c.requestid = workflow_currentoperator.requestid)");
	    
		//RecordSet.executeSql("select workflowtype, workflowid, viewtype, count(distinct requestid) workflowcount from workflow_currentoperator where (isremark='0' or isremark='1' or isremark='5') and islasttimes=1 and (isprocessed is null or (isprocessed<>'2' and isprocessed<>'3')) and userid=" +  resourceid  + " and usertype= " + usertype +" group by workflowtype, workflowid, viewtype order by workflowtype, workflowid " ) ;
	    //System.out.print("select workflowtype, workflowid from workflow_currentoperator where (isremark='0' or isremark='1' or isremark='5')  and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +"  and exists (select 1 from workflow_requestbase c where c.requestid=workflow_currentoperator.requestid) group by workflowtype, workflowid order by workflowtype, workflowid "  ) ;
	    //RecordSet.executeSql("select distinct a.workflowtype, a.workflowid from workflow_currentoperator a ,workflow_requestbase b  where a.requestid=b.requestid and (b.currentnodetype <> '3' or  (a.isremark ='1' and b.currentnodetype = '3')) and (a.isremark='0' or a.isremark='1' or a.isremark='5')  and a.userid=" +  resourceid  + " and a.usertype= " + usertype +" group by a.workflowtype, a.workflowid order by a.workflowtype, a.workflowid " ) ;
		if(!superior)
		{
			//SQL += " AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE workflow_currentoperator.workflowid = b.workflowid AND workflow_currentoperator.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ";
			sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE workflow_currentoperator.workflowid = b.workflowid AND workflow_currentoperator.requestid = b.requestid AND b.userid in(" + user.getUID() + ") and b.usertype= " + usertype +") ");
		}
		if(offical.equals("1")){//发文/收文/签报
			if(officalType==1){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
			}else if(officalType==2){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
			}
		}
		//SQL += " group by workflowtype, workflowid order by workflowtype, workflowid";
		//sqlsb.append(" group by workflowtype, workflowid order by workflowtype, workflowid ");
		sqlsb.append(" group by workflowtype, workflowid ) wo WHERE wb.id=wo.workflowid AND wt.id=wb.workflowtype ");
		sqlsb.append(" order BY wt.dsporder asc,wt.id ASC ,wb.dsporder asc, wb.workflowname   ");
	    RecordSet.executeSql(sqlsb.toString());
	    //System.out.println(sqlsb.toString());
	    while(RecordSet.next()){
	        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
	        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
	        
	        theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
	        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1"))
	        {
	        	
	            /* added by wdl 2006-06-14 left menu advanced menu */
	    	 	if(selectedworkflow.indexOf("T"+theworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
	    	 	if(selectedworkflow.indexOf("W"+theworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
	    	 	/* added end */
	
	    	 	if(wftypeworkflowList.indexOf(theworkflowtype+","+theworkflowid)<0){
	        	 	wftypeworkflowList.add(theworkflowtype+","+theworkflowid);
	            }
	            int wftindex = wftypeList.indexOf(theworkflowtype) ;
	            if(wftindex == -1) {
	                wftypeList.add(theworkflowtype) ;
	                wftypecountList.add("0") ;
	            }
	            wftindex = workflowList.indexOf(theworkflowid) ;
	            if(wftindex == -1) {
	                workflowList.add(theworkflowid) ;
	                workflowcountList.add("0") ;
	            }
				if(selectedworkflow.indexOf("PW"+theworkflowid+"N")!=-1 && fromAdvancedMenu==1){
					int bx = selectedworkflow.indexOf("PW"+theworkflowid+"N");
					String tmp = selectedworkflow.substring(bx+("PW"+theworkflowid+"N").length());
					bx = tmp.indexOf("SP^AN");
					tmp = tmp.substring(0, bx);
					//System.out.println("theworkflowid = " + theworkflowid + " tmp = " + tmp);
					wfNodeHahstable.put(theworkflowid, tmp);
				}
	        }
	    }
		
		//左侧树拼接 json
		demoLeftMenus = "[";
		if(wftypeList.size()>0){
		for (int i = 0,typerowcounts=wftypeList.size(); i < typerowcounts; i++) {
			typeid = (String) wftypeList.get(i);
			typecount = (String) wftypecountList.get(i);
			typename = WorkTypeComInfo.getWorkTypename(typeid);
			String workFlowIDsRequest = "";
			String workFlowNodeIDsRequest = "";
			for (int j = 0; j < workflowList.size(); j++) {
				workflowid = (String) workflowList.get(j);
				String curtypeid = WorkflowComInfo.getWorkflowtype(workflowid);
				if (!curtypeid.equals(typeid)) {
					continue;
				}
				workFlowIDsRequest += workflowid + ",";
				String t_workFlowNodeIDRequest = Util.null2String((String) wfNodeHahstable.get(workflowid));
				if (!"".equals(t_workFlowNodeIDRequest)) {
					workFlowNodeIDsRequest += t_workFlowNodeIDRequest + ",";
				}
			}
			if (!"".equals(workFlowIDsRequest)) {
				workFlowIDsRequest = workFlowIDsRequest.substring(0, workFlowIDsRequest.length());
			}
			if (!"".equals(workFlowNodeIDsRequest)) {
				workFlowNodeIDsRequest = workFlowNodeIDsRequest.substring(0, workFlowNodeIDsRequest.length());
			}
			
			demoLeftMenus +="{";	
			demoLeftMenus += "\"name\":\""+Util.toScreenForJs(Util.toScreen(typename, user.getLanguage()))+"\",";
			demoLeftMenus+="\"__domid__\":\"__type_"+typeid+"\",";
			demoLeftMenus += "\"hasChildren\":"+true+",";
			demoLeftMenus += "\"isOpen\":"+true+",";
			demoLeftMenus += "\"submenus\":[";
			List<Map> maps=new ArrayList(0);
				for (int j = 0; j < workflowList.size(); j++) {
					workflowid = (String) workflowList.get(j);
					String curtypeid = WorkflowComInfo.getWorkflowtype(workflowid);
					if (!curtypeid.equals(typeid))
						continue;
					
					workflowcount = (String) workflowcountList.get(j);
					workflowname = WorkflowComInfo.getWorkflowname(workflowid);
					workflowname = Util.processBody(workflowname,user.getLanguage()+"");
					int tempind = wftypeworkflowList.indexOf(typeid + "," + workflowid);
					int ovtimenum = 0;
					newremarkwfcount1 = "0";
					newremarkwfcount0 = "0";
					wfsupedcount = "0";
					
					if (tempind > -1) {
						Object tempovtimenumObj = wfovertimecountMap.get(workflowid);
						if (tempovtimenumObj != null) {
						    ovtimenum = (Integer)tempovtimenumObj;
						} else {
						    ovtimenum = 0;
						}
						
						Object tempnewremarkwfcount0Obj = newremarkwfcount0Map.get(workflowid);
						if (tempnewremarkwfcount0Obj != null) {
						    newremarkwfcount0 = (Integer)tempnewremarkwfcount0Obj + "";
						} else {
							newremarkwfcount0 = "0";
						}
						
						Object tempnewremarkwfcount1Obj = newremarkwfcount1Map.get(workflowid);
						if (tempnewremarkwfcount1Obj != null) {
						    newremarkwfcount1 = (Integer)tempnewremarkwfcount1Obj + "";
						} else {
							newremarkwfcount1 = "0";
						}
						
						Object tempwfsupedcountObj = wfsupedcountMap.get(workflowid);
						if (tempwfsupedcountObj != null) {
						    wfsupedcount = (Integer)tempwfsupedcountObj + "";
						} else {
						    wfsupedcount = "0";
						}
						
						//newremarkwfcount1 = Util.getIntValue(Util.null2String((String) newremarkwfcount1Map.get(workflowid)), 0) + "";
						//(String) newremarkwfcount1Map.get(workflowid);
						//wfsupedcount = Util.getIntValue(Util.null2String((String) wfsupedcountMap.get(workflowid)), 0) + "";
						//(String) wfsupedcountMap.get(workflowid);
						
					}
//					System.out.println("====================================************=newremarkwfcount1=" + newremarkwfcount1+ ", " + Util.toScreen(newremarkwfcount1, user.getLanguage()));
					String t_nodeids = Util.null2String((String) wfNodeHahstable.get(workflowid));
					Map map=new HashMap();
					map.put("name", Util.toScreenForJs(Util.toScreen(workflowname, user.getLanguage())));
					map.put("workflowid",workflowid);
					map.put("nodeids",t_nodeids);
					//map.put("flowNew",Util.toScreen(newremarkwfcount0, user.getLanguage()));
					//map.put("flowResponse",Util.toScreen(newremarkwfcount1, user.getLanguage()));
					map.put("flowNew","0");
					map.put("flowResponse","0");
					map.put("flowOut",ovtimenum);
					//map.put("flowAll",Util.toScreen(workflowcount,user.getLanguage()));
					//map.put("flowSup",Util.toScreen(wfsupedcount, user.getLanguage()));
					map.put("flowAll","0");
					map.put("flowSup","0");
					maps.add(map);
				}
				int flowNew=0;
				int flowResponse=0;
				int flowOut=0;
				int flowAll=0;
				int flowSup=0;
				
				for(int x=0;x<maps.size();x++){
					Map map=maps.get(x);
					flowNew+=Integer.valueOf(map.get("flowNew")+"");
					flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
					flowOut+=Integer.valueOf(map.get("flowOut")+"");
					flowAll+=Integer.valueOf(map.get("flowAll")+"");
					flowSup+=Integer.valueOf(map.get("flowSup")+"");
					demoLeftMenus += "{";
					demoLeftMenus += "\"name\":\""+map.get("name")+"\",";
					demoLeftMenus+="\"__domid__\":\"__wf_"+map.get("workflowid")+"\",";
					demoLeftMenus += "\"hasChildren\":false,";
						demoLeftMenus += "\"attr\":{";
						demoLeftMenus += "\"workflowid\":"+map.get("workflowid")+",";
						demoLeftMenus += "\"nodeids\":\""+map.get("nodeids")+"\",";
							demoLeftMenus += "\"flowNew\":"+map.get("flowNew")+",";
							demoLeftMenus += "\"flowResponse\":"+map.get("flowResponse")+",";
							demoLeftMenus += "\"flowOut\":"+map.get("flowOut")+",";
							demoLeftMenus += "\"flowAll\":"+map.get("flowAll")+",";
							demoLeftMenus += "\"flowSup\":"+map.get("flowSup");
						demoLeftMenus += "},";
						demoLeftMenus += "\"numbers\":{";
							demoLeftMenus += "\"flowNew\":"+map.get("flowNew")+",";
							demoLeftMenus += "\"flowResponse\":"+map.get("flowResponse")+",";
							demoLeftMenus += "\"flowOut\":"+map.get("flowOut")+",";
						 	demoLeftMenus += "\"flowAll\":"+map.get("flowAll")+",";
							demoLeftMenus += "\"flowSup\":"+map.get("flowSup");
							demoLeftMenus += "}";
							demoLeftMenus += "}";
							demoLeftMenus += (x==maps.size()-1)?"":",";
				}
				demoLeftMenus += "],";
				demoLeftMenus += "\"attr\":{";
				demoLeftMenus += "\"typeid\":"+typeid+",";
				demoLeftMenus += "\"flowNew\":"+flowNew+",";
				demoLeftMenus += "\"flowResponse\":"+flowResponse+",";
				demoLeftMenus += "\"flowOut\":"+flowOut+",";
				demoLeftMenus += "\"flowAll\":"+flowAll+",";
				demoLeftMenus += "\"flowSup\":"+flowSup;
				demoLeftMenus += "},";
				demoLeftMenus += "\"numbers\":{";
				demoLeftMenus += "\"flowNew\":"+flowNew+",";
				demoLeftMenus += "\"flowResponse\":"+flowResponse+",";
				demoLeftMenus += "\"flowOut\":"+flowOut+",";
				demoLeftMenus += "\"flowAll\":"+flowAll+",";
				demoLeftMenus += "\"flowSup\":"+flowSup;
			demoLeftMenus += "}";
			demoLeftMenus += "}";
			demoLeftMenus += (i==typerowcounts-1)?"":",";
			wftypes += typeid+",";
		}}
		
		
		//查询异构系统数据
        if(isopenos) {
            RecordSet rs1 = new RecordSet();
            int wftype_count = 0;
            rs.executeSql("select sysid,sysshortname,sysfullname,(select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" AND workflowid in (select workflowid from ofs_workflow where ofs_workflow.sysid=ofs_sysinfo.sysid and cancel=0) and isremark='0') as dbs from ofs_sysinfo where cancel=0 order by sysid desc");
            wftype_count = rs.getCounts();
            if (wftype_count > 0) {
                //demoLeftMenus+=",";
            }
            while (rs.next()) {
                String _typeid = rs.getString(1);
                String _typename = rs.getString(2);
                int dbs = rs.getInt("dbs");
                if(dbs==0){
	                wftype_count--;
	                continue ;
                }
                if(new RequestUtil().getOfsSetting().getShowsysname().equals("2")){
                    _typename = rs.getString(3);
                }
                if (demoLeftMenus.length() > 10) {
                    demoLeftMenus += ",{";
                } else {
                    demoLeftMenus += "{";
                }
                demoLeftMenus += "\"name\":\"" + _typename + "\",";
                demoLeftMenus += "\"__domid__\":\"__type_" + _typeid + "\",";
                demoLeftMenus += "\"hasChildren\":" + true + ",";
                demoLeftMenus += "\"isOpen\":" + true + ",";
                demoLeftMenus += "\"submenus\":[";
                int wf_count = 0;
                RecordSet.executeSql("select workflowid,workflowname from ofs_workflow where sysid=" + _typeid + " and cancel=0 order by workflowname asc, workflowid desc");//查询OS流程
                wf_count = RecordSet.getCounts();
                int wfcountall = 0;
                int wfnewcountall = 0;
                while (RecordSet.next()) {
                    String _wfid = RecordSet.getString(1);
                    String _wfname = RecordSet.getString(2);
                    rs1.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" AND islasttimes=1 AND workflowid=" + _wfid + " and isremark='0' ");
                    int wfcount = 0;
                    if (rs1.next()) {
                        wfcount = Util.getIntValue(rs1.getString(1), 0);
                    }

                    rs1.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" AND islasttimes=1 AND workflowid=" + _wfid + " and isremark='0' and viewtype=0 ");
                    int wfnewcount = 0;
                    if (rs1.next()) {
                        wfnewcount = Util.getIntValue(rs1.getString(1), 0);
                    }

                    if(wfcount==0&&wfnewcount==0){
	                    wf_count-- ;
	                    continue;
                    }

                    wfcountall += wfcount;
                    wfnewcountall += wfnewcount ;
                    demoLeftMenus += "{";
                    demoLeftMenus += "\"name\":\"" + _wfname + "\",";
                    demoLeftMenus += "\"__domid__\":\"__wf_" + _wfid + "\",";
                    demoLeftMenus += "\"hasChildren\":false,";
                    demoLeftMenus += "\"attr\":{";
                    demoLeftMenus += "\"workflowid\":" + _wfid + ",";
                    demoLeftMenus += "\"nodeids\":\"\",";
                    demoLeftMenus += "\"flowNew\":"+wfnewcount+",";
                    demoLeftMenus += "\"flowResponse\":0,";
                    demoLeftMenus += "\"flowOut\":0,";
                    demoLeftMenus += "\"flowAll\":" + wfcount + ",";
                    demoLeftMenus += "\"flowSup\":0";
                    demoLeftMenus += "},";
                    demoLeftMenus += "\"numbers\":{";
                    demoLeftMenus += "\"flowNew\":"+wfnewcount+",";
                    demoLeftMenus += "\"flowResponse\":0,";
                    demoLeftMenus += "\"flowOut\":0,";
                    demoLeftMenus += "\"flowAll\":" + wfcount + ",";
                    demoLeftMenus += "\"flowSup\":0";
                    demoLeftMenus += "}";
                    demoLeftMenus += "}";
                    demoLeftMenus += ",";
                }
                if (wf_count > 0) {
                    demoLeftMenus = demoLeftMenus.substring(0, demoLeftMenus.length() - 1);
                }
                demoLeftMenus += "],";
                demoLeftMenus += "\"attr\":{";
                demoLeftMenus += "\"typeid\":" + _typeid + ",";
                demoLeftMenus += "\"flowNew\":"+wfnewcountall+",";
                demoLeftMenus += "\"flowResponse\":0,";
                demoLeftMenus += "\"flowOut\":0,";
                demoLeftMenus += "\"flowAll\":" + wfcountall + ",";
                demoLeftMenus += "\"flowSup\":0";
                demoLeftMenus += "},";
                demoLeftMenus += "\"numbers\":{";
                demoLeftMenus += "\"flowNew\":"+wfnewcountall+",";
                demoLeftMenus += "\"flowResponse\":0,";
                demoLeftMenus += "\"flowOut\":0,";
                demoLeftMenus += "\"flowAll\":" + wfcountall + ",";
                demoLeftMenus += "\"flowSup\":0";
                demoLeftMenus += "}";
                demoLeftMenus += "}";
            }
        }
		
		demoLeftMenus += "]";
		out.clear();
		out.print(demoLeftMenus);
		///System.out.println(demoLeftMenus);
		return;
		
   	}
%>