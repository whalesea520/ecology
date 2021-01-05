<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/leftNumMenu_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/leftNumMenu_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/requestView_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />


<link rel="stylesheet" type="text/css" href="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.css" />
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>

</head>
<script language="javascript">
try{
	window.opener.btnWfCenterReload.onclick();
}catch(e){}
try{
   	parent.window.taskCallBack(2); 
}catch(e){}
</script>
<%
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();

    
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
		response.sendRedirect("/notice/noright.jsp") ;
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
	//System.out.println("selectedworkflow = " + selectedworkflow);
    /* edited end */    
    
    String userID = String.valueOf(user.getUID());
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
	String workflowname="";

    ArrayList wftypeList=new ArrayList();
	ArrayList wftypecountList=new ArrayList();
	ArrayList workflowList=new ArrayList();
	ArrayList workflowcountList=new ArrayList();
    ArrayList newremarkwfcount0List=new ArrayList();
    ArrayList newremarkwfcount1List=new ArrayList();
    ArrayList wftypeworkflowList=new ArrayList();
    ArrayList wfovertimecountList=new ArrayList();
	Hashtable wfNodeHahstable = new Hashtable();
    int totalcount=0;

    //String SQL = "";
    //SQL = "select workflowtype, workflowid from workflow_currentoperator where (isremark='0' or isremark='1' or isremark='5' or isremark='8' or isremark='9' or isremark='7')  and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +"  and exists (select 1 from workflow_requestbase c where c.workflowid=workflow_currentoperator.workflowid and c.requestid=workflow_currentoperator.requestid)";
    StringBuffer sqlsb = new StringBuffer();
    sqlsb.append("select workflowtype, workflowid ");
    sqlsb.append("  from workflow_currentoperator ");
    sqlsb.append("	  where (isremark = '0' or isremark = '1' or isremark = '5' or ");
    sqlsb.append("        isremark = '8' or isremark = '9' or isremark = '7') ");
    sqlsb.append("   and islasttimes = 1 ");
    sqlsb.append("   and userid = ").append(resourceid);
    sqlsb.append("   and usertype = ").append(usertype);
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
		sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE workflow_currentoperator.workflowid = b.workflowid AND workflow_currentoperator.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ");
	}
	//SQL += " group by workflowtype, workflowid order by workflowtype, workflowid";
	sqlsb.append(" group by workflowtype, workflowid order by workflowtype, workflowid ");

    RecordSet.executeSql(sqlsb.toString());
    
    while(RecordSet.next()){
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
        theworkflowid = workflow
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
    for(int i=0;i<wftypeworkflowList.size();i++){
        ArrayList templist=Util.TokenizerString((String)wftypeworkflowList.get(i),",");
        String tworkflowtype=(String)templist.get(0);
        String tworkflowid=(String)templist.get(1);
        int newcount=0;
        int newcount1=0;
		tworkflowNodeIDs = Util.null2String((String)wfNodeHahstable.get(tworkflowid));
		//System.out.println("tworkflowNodeIDs = " + tworkflowNodeIDs);
		sqlsb = new StringBuffer();
		sqlsb.append("select a.viewtype, count(distinct a.requestid) workflowcount ");
		sqlsb.append("	  from workflow_currentoperator a ");
		sqlsb.append("	  where ((isremark = '0' and (isprocessed is null or ");
		sqlsb.append("	        (isprocessed <> '2' and isprocessed <> '3'))) or isremark = '1' or ");
		sqlsb.append("	        isremark = '8' or isremark = '9' or isremark = '7') ");
		sqlsb.append("	    and islasttimes = 1 ");
		sqlsb.append("	    and userid = ").append(resourceid);
		sqlsb.append("	    and usertype = ").append(usertype);
		sqlsb.append("	    and a.workflowtype = ").append(tworkflowtype);
		sqlsb.append("	    and a.workflowid = ").append(tworkflowid);
		sqlsb.append("	    and exists (select c.requestid ");
		sqlsb.append("	           from workflow_requestbase c ");
		sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.requestid = a.requestid");
		if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		sqlsb.append(")");
        //SQL = "select a.viewtype, count(distinct a.requestid) workflowcount from workflow_currentoperator a  where   ((isremark='0' and (isprocessed is null or (isprocessed<>'2' and isprocessed<>'3'))) or isremark='1' or isremark='8' or isremark='9' or isremark='7') and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" and a.workflowtype="+tworkflowtype+" and a.workflowid="+tworkflowid+" and exists (select c.requestid from workflow_requestbase c where c.requestid=a.requestid) ";
		if(!"".equals(tworkflowNodeIDs)){
			sqlsb.append(" and a.nodeid in (" + tworkflowNodeIDs + ") ");
		}
        if(!superior)
    	{
        	sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ");
    	}
        
        sqlsb.append(" group by a.viewtype");
       
        rs.executeSql(sqlsb.toString()) ;
       
        while(rs.next()){
            int theworkflowcount = Util.getIntValue(rs.getString("workflowcount"),0) ;
            int viewtype = Util.getIntValue(rs.getString("viewtype"),2) ;
                int wfindex = workflowList.indexOf(tworkflowid) ;
                if(wfindex != -1) {
                    workflowcountList.set(wfindex,""+(Util.getIntValue((String)workflowcountList.get(wfindex),0)+theworkflowcount)) ;
                    if(viewtype==0){
                        newcount+=theworkflowcount;
                    }
                    if(viewtype==-1){
                         newcount1+=theworkflowcount;
                    }
                }

                int wftindex = wftypeList.indexOf(tworkflowtype) ;
                if(wftindex != -1) {
                    wftypecountList.set(wftindex,""+(Util.getIntValue((String)wftypecountList.get(wftindex),0)+theworkflowcount)) ;
                }
                totalcount += theworkflowcount;
        }
        newremarkwfcount0List.add(""+newcount);
        newremarkwfcount1List.add(""+newcount1);

        int overtimecount=0;
        if(templist.size()==2){
			sqlsb = new StringBuffer();
			sqlsb.append("select count(distinct a.requestid) overcount ");
			sqlsb.append("  from workflow_currentoperator a ");
			sqlsb.append("  where ((isremark = '0' and (isprocessed = '2' or isprocessed = '3')) or ");
			sqlsb.append("        isremark = '5') ");
			sqlsb.append("    and islasttimes = 1 ");
			sqlsb.append("    and userid = ").append(resourceid);
			sqlsb.append("    and usertype = ").append(usertype);
			sqlsb.append("    and a.workflowtype = ").append(tworkflowtype);
			sqlsb.append("    and a.workflowid = ").append(tworkflowid);
			sqlsb.append("    and exists (select 1 ");
			sqlsb.append("          from workflow_requestbase c ");
			sqlsb.append("         where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = a.workflowid ");
			if(RecordSet.getDBType().equals("oracle"))
			{
				sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
			}
			else
			{
				sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
			}
			sqlsb.append("           and c.requestid = a.requestid)");
        	//SQL = "select count(distinct a.requestid) overcount from workflow_currentoperator a  where   ((isremark='0' and (isprocessed='2' or isprocessed='3'))  or isremark='5') and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" and a.workflowtype="+tworkflowtype+" and  a.workflowid ="+tworkflowid+" and exists (select 1 from workflow_requestbase c where c.workflowid=a.workflowid and c.requestid=a.requestid)" ;

			if(!"".equals(tworkflowNodeIDs)){
				sqlsb.append(" and a.nodeid in (" + tworkflowNodeIDs + ") ");
			}
        	if(!superior)
        	{
        		sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype + ") ");
        	}
        	
            RecordSet.executeSql(sqlsb.toString()) ;
           
            if(RecordSet.next()){
                overtimecount=RecordSet.getInt("overcount");
            }
        }
        wfovertimecountList.add(""+overtimecount);
        int wfindex = workflowList.indexOf(tworkflowid) ;
        if(wfindex != -1) {
            workflowcountList.set(wfindex,""+(Util.getIntValue((String)workflowcountList.get(wfindex),0)+overtimecount)) ;
        }
        int wftindex = wftypeList.indexOf(tworkflowtype) ;
        if(wftindex != -1) {
            wftypecountList.set(wftindex,""+(Util.getIntValue((String)wftypecountList.get(wftindex),0)+overtimecount)) ;
        }
        totalcount += overtimecount;
    }
%>
<%
for(int i=0; i<wftypecountList.size(); i++){
	String t_wftypecount = (String)wftypecountList.get(i);
	if("0".equals(t_wftypecount)){
		wftypeList.remove(i);
		wftypecountList.remove(i);
		i--;
	}
}
for(int i=0; i<workflowcountList.size(); i++){
	String t_workflowcount = (String)workflowcountList.get(i);
	if("0".equals(t_workflowcount)){
		workflowcountList.remove(i);
		//System.out.println((String)(workflowList.get(i)));
		workflowList.remove(i);
		newremarkwfcount0List.remove(i);
		newremarkwfcount1List.remove(i);
		wftypeworkflowList.remove(i);
		i--;
	}
}

if(!isUseOldWfMode){
	int typerowcounts=wftypeList.size();
	JSONArray jsonWfTypeArray = new JSONArray();
    for(int i=0;i<typerowcounts;i++){
 		typeid=(String)wftypeList.get(i);                                
	   	JSONObject jsonWfType = new JSONObject();
	    jsonWfType.put("draggable",false);
		jsonWfType.put("leaf",false);
		jsonWfType.put("cls","wfTreeFolderNode");
        typecount=(String)wftypecountList.get(i);
        typename=WorkTypeComInfo.getWorkTypename(typeid);
		String workFlowIDsRequest = "";
		String workFlowNodeIDsRequest = "";
		for(int j=0;j<workflowList.size();j++){
			workflowid=(String)workflowList.get(j);
			String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
			if(!curtypeid.equals(typeid)){
				continue;
			}
			workFlowIDsRequest += workflowid + ",";
			String t_workFlowNodeIDRequest = Util.null2String((String)wfNodeHahstable.get(workflowid));
			if(!"".equals(t_workFlowNodeIDRequest)){
				workFlowNodeIDsRequest += t_workFlowNodeIDRequest + ",";
			}
		}
		if(!"".equals(workFlowIDsRequest)){
			workFlowIDsRequest = workFlowIDsRequest.substring(0, workFlowIDsRequest.length());
		}
		if(!"".equals(workFlowNodeIDsRequest)){
			workFlowNodeIDsRequest = workFlowNodeIDsRequest.substring(0, workFlowNodeIDsRequest.length());
		}
									
		if(fromAdvancedMenu==1){
			jsonWfType.put("paras","method=reqeustbywftypeNode&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=0&workFlowIDsRequest="+workFlowIDsRequest+"&workFlowNodeIDsRequest="+workFlowNodeIDsRequest+"&selectedContent="+selectedContent+"&menuType="+menuType);
		}
		else{
			jsonWfType.put("paras","method=reqeustbywftype&wftype="+typeid+"&complete=0");
		}
		
		int newremark1 = 0;
		int newremark2 = 0;
		int over = 0;
        JSONArray jsonWfTypeChildrenArray = new JSONArray();
        for(int j=0;j<workflowList.size();j++){
        	String wfText = "";
        	workflowid=(String)workflowList.get(j);
        	JSONObject jsonWfTypeChild = new JSONObject();
        	jsonWfTypeChild.put("draggable",false);
        	jsonWfTypeChild.put("leaf",true);
        	
            String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
            if(!curtypeid.equals(typeid))	continue;
            workflowcount=(String)workflowcountList.get(j);
            
            workflowname=WorkflowComInfo.getWorkflowname(workflowid);
            int tempind=wftypeworkflowList.indexOf(typeid+","+workflowid);
            int ovtimenum=0;
            if(tempind>-1){
                ovtimenum=Util.getIntValue((String)wfovertimecountList.get(tempind),0);
                newremarkwfcount0=(String)newremarkwfcount0List.get(tempind);
                newremarkwfcount1=(String)newremarkwfcount1List.get(tempind);
            }
			String t_nodeids = Util.null2String((String)wfNodeHahstable.get(workflowid));
			jsonWfTypeChild.put("iconCls","btn_dot");
			jsonWfTypeChild.put("cls","wfTreeLeafNode");
			jsonWfTypeChild.put("paras","method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+t_nodeids+"&complete=0");
			wfText +="<a  href=# onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
			if(ovtimenum>0){
				String paras = "method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+t_nodeids+"&complete=8";
				wfText+="<a href = # onClick=javaScript:loadGrid('"+paras+"',true)  >"+ovtimenum+"</a><IMG src='/images/BDOut_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
				over=ovtimenum+over;;
			}
			if(!newremarkwfcount0.equals("0")){
				String paras = "method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+t_nodeids+"&complete=3";
				wfText+="<a href =# onClick=javaScript:loadGrid('"+paras+"',true)  >"+Util.toScreen(newremarkwfcount0,user.getLanguage())+"</a><IMG src='/images/BDNew_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
				newremark1=Util.getIntValue(newremarkwfcount0)+newremark1;
			}
			if(!newremarkwfcount1.equals("0")){
				String paras = "method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+t_nodeids+"&complete=4";
				wfText+="<a href=#  onClick=javaScript:loadGrid('"+paras+"',true) >"+Util.toScreen(newremarkwfcount1,user.getLanguage())+"</a><IMG src='/images/BDNew2_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
				newremark2=Util.getIntValue(newremarkwfcount1)+newremark2;
			}
			wfText+=Util.toScreen(workflowcount,user.getLanguage())+")";
			
			jsonWfTypeChild.put("text",wfText);
			jsonWfTypeChildrenArray.put(jsonWfTypeChild);

		}
        
        String wfText ="";
        if(over>0){
        	wfText+=over+"<IMG src='/images/BDOut_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
        }
        if(newremark1>0){
        	wfText+=newremark1+"<IMG src='/images/BDNew_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
        }
        if(newremark2>0){
        	wfText+=newremark2+"<IMG src='/images/BDNew2_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
        }
        //wfText+=")";
        jsonWfType.put("text","<a  href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true)>"+WorkTypeComInfo.getWorkTypename(typeid)+"&nbsp;</a>("+wfText+(String)wftypecountList.get(i)+")");
        //jsonWfType.put("text","");                                        
        jsonWfType.put("children",jsonWfTypeChildrenArray);
        jsonWfTypeArray.put(jsonWfType);
	}
    session.setAttribute("view",jsonWfTypeArray);
    
    response.sendRedirect("/workflow/request/ext/Request.jsp?type=view&isfromtab="+isfromtab);  //type: view,表待办 handled表已办
	return;	
}


if(workflowcountList.size() == 1 && !superior){
	String workflowid1 = (String)workflowList.get(0);
	String nodeids1 = Util.null2String((String)wfNodeHahstable.get(workflowid1));
	String href1 = "/workflow/search/WFSearchTemp.jsp?method=reqeustbywfidNode&workflowid="+workflowid1+"&nodeids="+nodeids1+"&complete=0";
	//System.out.println(href1);
	//response.sendRedirect(href1);
	%>
	<script language=javascript>
	location.href ="<%=href1%>";
	</script>
	<%

}

titlename+="&nbsp;&nbsp;("+SystemEnv.getHtmlLabelName(18609,user.getLanguage())+totalcount+SystemEnv.getHtmlLabelName(26302,user.getLanguage())+")";
%>
<body>
<form name=frmmain method=post action="RequestView.jsp">
    <div>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    /* edited by wdl 2006-06-14 left menu advanced menu */
        if(fromAdvancedMenu!=1){
        	RCMenuWidth = 160;
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(16347,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?method=all&complete=0&viewType=1,_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;

			RCMenu += "{"+SystemEnv.getHtmlLabelName(20271,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?method=all&complete=2&viewType=2,_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;

	        RCMenu += "{"+SystemEnv.getHtmlLabelName(16348,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?method=all&complete=1&viewType=3,_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;
        }
    /* edited end */    
    %>
    </div>
</form>

		<script type="text/javascript">
			var demoLeftMenus=[
			<%
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
			%>
				{	
					name:"<%=Util.toScreen(typename, user.getLanguage())%>",
					attr:{
						typeid:"<%=typeid%>"
					},
					submenus:[
					<%
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
							if (tempind > -1) {
								ovtimenum = Util.getIntValue((String) wfovertimecountList.get(tempind), 0);
								newremarkwfcount0 = (String) newremarkwfcount0List.get(tempind);
								newremarkwfcount1 = (String) newremarkwfcount1List.get(tempind);
							}
							String t_nodeids = Util.null2String((String) wfNodeHahstable.get(workflowid));
							Map map=new HashMap();
							map.put("name",Util.toScreen(workflowname, user.getLanguage()));
							map.put("workflowid",workflowid);
							map.put("nodeids",t_nodeids);
							map.put("flowNew",Util.toScreen(newremarkwfcount0, user.getLanguage()));
							map.put("flowResponse",Util.toScreen(newremarkwfcount1, user.getLanguage()));
							map.put("flowOut",ovtimenum);
							map.put("flowAll",Util.toScreen(workflowcount,user.getLanguage()));
							maps.add(map);
						}
						
						int flowNew=0;
						int flowResponse=0;
						int flowOut=0;
						int flowAll=0;
						
						for(int x=0;x<maps.size();x++){
							Map map=maps.get(x);
							flowNew+=Integer.valueOf(map.get("flowNew")+"");
							flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
							flowOut+=Integer.valueOf(map.get("flowOut")+"");
							flowAll+=Integer.valueOf(map.get("flowAll")+"");
							%>
							{	
								name:"<%=map.get("name")%>",
								attr:{
									workflowid:"<%=map.get("workflowid")%>",
									nodeids:"<%=map.get("nodeids")%>"
								},
								numbers:{
									 flowNew:"<%=map.get("flowNew")%>",
									 flowResponse:"<%=map.get("flowResponse")%>",
									 flowOut:"<%=map.get("flowOut")%>",
									 flowAll:"<%=map.get("flowAll")%>"
								}
							}
							<%=x==maps.size()-1?"":","%>
					<%
						}
					%>
					],
					
					numbers:{
						 flowNew:"<%=flowNew%>",
						 flowResponse:"<%=flowResponse%>",
						 flowOut:"<%=flowOut%>",
						 flowAll:"<%=flowAll%>"
					}
				}
			<%=i==typerowcounts-1?"":","%>
			<%
				}
			%>
			];
		</script>

		<table cellspacing="0" cellpadding="0" class="flowsTable"  >
			<tr>
				<td class="leftTypeSearch">
					<span class="leftType"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></span>
					<span class="leftSearchSpan">
						&nbsp;<input type="text" class="leftSearchInput" />
					</span>
				</td>
				<td rowspan="2">
					<iframe src="" class="flowFrame" frameborder="0" ></iframe>
				</td>
			</tr>
			<tr>
				<td style="width:23%;" class="flowMenusTd">
					<div class="flowMenuDiv"  >
						<!--<div class="flowMenuAll"><span class="allText">全部&nbsp;</span></div>-->
						<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
							<div class="ulDiv" ></div>
						</div>
					</div>
				</td>
			</tr>
		</table>
	</body>
</html>