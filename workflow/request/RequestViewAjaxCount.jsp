<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
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
<jsp:useBean id="requestutil" class="weaver.workflow.request.todo.RequestUtil" scope="page" />

<%
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
if(user==null) {
    return;
}
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	String cursltwftypeid = Util.null2String(request.getParameter("wftype"));
	String cursltwfid = Util.null2String(request.getParameter("workflowid"));
	
	String curoptwfid = Util.null2String(request.getParameter("optkeys"));
	if(Util.getIntValue(cursltwftypeid)<0){
		cursltwftypeid = "" ;
	}
	if(Util.getIntValue(cursltwfid)<0){
		cursltwfid = "" ;
	}
	if(!"".equals(cursltwfid) && "".equals(cursltwftypeid)){
		cursltwftypeid = WorkflowComInfo.getWorkflowtype(cursltwfid);
    } else if (!"".equals(curoptwfid)) {
		String optwfid = "";        
        String optkeysql = "select distinct workflowid from workflow_requestbase where requestid in (" + curoptwfid + ")";
        RecordSet rs9 = new RecordSet();
        rs9.executeSql(optkeysql);
        while (rs9.next()) {
            cursltwftypeid += "," + WorkflowComInfo.getWorkflowtype(WorkflowVersion.getActiveVersionWFID(rs9.getString(1)));
        }
        
		if (cursltwftypeid.length() > 1) {
		    cursltwftypeid = cursltwftypeid.substring(1, cursltwftypeid.length());
		}
    }
	String offical = Util.null2String(request.getParameter("offical"));
	int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
	String loadtree = Util.null2String(request.getParameter("loadtree"));
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

    StringBuffer sqlsb = new StringBuffer();
    sqlsb.append("select workflowtype, workflowid ");
    sqlsb.append("  from workflow_currentoperator ");
    sqlsb.append("	  where ( (isremark = '0' and (takisremark is null or takisremark=0)) or ");
    sqlsb.append("        isremark = '1' or isremark = '5' or isremark = '8' or isremark = '9' or isremark = '7') ");
    sqlsb.append("   and islasttimes = 1 ");
    if(!"".equals(cursltwftypeid)){
	    sqlsb.append("   and workflowtype in ( ").append(cursltwftypeid).append(")");
    }
    //if(!"".equals(cursltwfid)){
	//    sqlsb.append("   and workflowid = ").append(cursltwfid);
    //}
    	if("1".equals(belongtoshow)){
		sqlsb.append("	    and userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and userid in (").append(resourceid);
		}
    sqlsb.append("  ) and usertype = ").append(usertype);
	sqlsb.append(" and  workflowid in (select id from workflow_base where (isvalid=1 or isvalid=3) )  ");
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
			if("1".equals(belongtoshow)){
		sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE workflow_currentoperator.workflowid = b.workflowid AND workflow_currentoperator.requestid = b.requestid AND b.userid in (" + userIDAll + ") and b.usertype= " + usertype +") ");
			}else{
			sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE workflow_currentoperator.workflowid = b.workflowid AND workflow_currentoperator.requestid = b.requestid AND b.userid in (" + user.getUID() + ") and b.usertype= " + usertype +") ");
			}
	}
	if(offical.equals("1")){//发文/收文/签报
		if(officalType==1){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
		}else if(officalType==2){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
		}
	}
	//SQL += " group by workflowtype, workflowid order by workflowtype, workflowid";
	sqlsb.append(" group by workflowtype, workflowid order by workflowtype, workflowid ");
    RecordSet.executeSql(sqlsb.toString());
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
				wfNodeHahstable.put(theworkflowid, tmp);
			}
        }
    }
	    
   	    
   	 StringBuffer wftypesb = new StringBuffer();
   	 StringBuffer wfsb = new StringBuffer();
   	 StringBuffer wfnodesb = new StringBuffer();
   	 
   	 for(int i=0;i<wftypeworkflowList.size();i++){
         ArrayList templist=Util.TokenizerString((String)wftypeworkflowList.get(i),",");
         String tworkflowtype=(String)templist.get(0);
         String tworkflowid=(String)templist.get(1);
         int newcount=0;
         int newcount1=0;
	     tworkflowNodeIDs = Util.null2String((String)wfNodeHahstable.get(tworkflowid));
		
		 wftypesb.append(",").append(tworkflowtype);
		 wfsb.append(",").append(WorkflowVersion.getAllVersionStringByWFIDs(tworkflowid));
		 String tempnodeid = WorkflowVersion.getAllRelationNodeStringByNodeIDs(tworkflowNodeIDs);
		 if (tempnodeid != null && !"".equals(tempnodeid)) {
		 	wfnodesb.append(",").append(tempnodeid);
		 }
		 
   	 }
   	    
   	 if (wftypesb.length() > 0) {
   	  	wftypesb = wftypesb.delete(0, 1);
   		wfsb = wfsb.delete(0, 1);
   	 }
   	 if (wfnodesb.indexOf(",") == 0) {
   		wfnodesb = wfnodesb.delete(0, 1);
   	 }
   	 
    int newcount=0;
    int newcount1=0;
	
	sqlsb = new StringBuffer();
	if("1".equals(belongtoshow)){
	sqlsb.append("select a.workflowtype, a.workflowid, a.viewtype, count(a.requestid) workflowcount ");
	}else{
	sqlsb.append("select a.workflowtype, a.workflowid, a.viewtype, count(distinct a.requestid) workflowcount ");
	}
	sqlsb.append("	  from workflow_currentoperator a ");
	sqlsb.append("	  where (((isremark='0' and (takisremark is null or takisremark=0 )) and isprocessed is null) ");
	sqlsb.append("	         or isremark = '1' or ");
	sqlsb.append("	        isremark = '8' or isremark = '9' or isremark = '7') ");
	sqlsb.append("	    and islasttimes = 1 ");
    if(!"".equals(cursltwftypeid)){
	    sqlsb.append("   and workflowtype in (").append(cursltwftypeid).append(")");
    }
    //if(!"".equals(cursltwfid)){
	//    sqlsb.append("   and workflowid = ").append(cursltwfid);
    //}
		if("1".equals(belongtoshow)){
		sqlsb.append("	    and userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and userid in (").append(resourceid);
		}
	sqlsb.append("	)    and usertype = ").append(usertype);
	if(!"".equals(wftypesb.toString())){
		sqlsb.append("	    and a.workflowtype in ( ").append(wftypesb).append(") ");
	}
	if(!"".equals(wfsb.toString())){
		sqlsb.append("	    and a.workflowid in (").append(wfsb).append(")");
	}
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
		sqlsb.append(" and a.nodeid in (" + WorkflowVersion.getAllRelationNodeStringByNodeIDs(tworkflowNodeIDs) + ") ");
	}
    if(!superior)
	{
		if("1".equals(belongtoshow)){
    	sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid in (" + userIDAll + ") and b.usertype= " + usertype +") ");
		}else{
		sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid in (" + user.getUID() + ") and b.usertype= " + usertype +") ");
		}
	}
	
	if(offical.equals("1")){//发文/收文/签报
		if(officalType==1){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
		}else if(officalType==2){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
		}
	}
    
    sqlsb.append(" group by a.viewtype, a.workflowtype, a.workflowid");
    rs.executeSql(sqlsb.toString()) ;
    while(rs.next()){
        String tworkflowtype = Util.null2String(rs.getString("workflowtype"));
        String tworkflowid = WorkflowVersion.getActiveVersionWFID(Util.null2String(rs.getString("workflowid")));
        
        int theworkflowcount = Util.getIntValue(rs.getString("workflowcount"),0) ;
        
        int viewtype = Util.getIntValue(rs.getString("viewtype"),2) ;
        int wfindex = workflowList.indexOf(tworkflowid) ;
        if(wfindex != -1) {
            workflowcountList.set(wfindex,""+(Util.getIntValue((String)workflowcountList.get(wfindex),0)+theworkflowcount)) ;
            if(viewtype==0){
            	newcount=theworkflowcount;
                //newremarkwfcount0Map.put(tworkflowid, newcount);
                Object tempobj = newremarkwfcount0Map.get(tworkflowid);
                if (tempobj != null) {
                	int wf0countindex = (Integer)tempobj ;
                	newremarkwfcount0Map.put(tworkflowid, wf0countindex + newcount);
                } else {
                    newremarkwfcount0Map.put(tworkflowid, newcount);  
                }
                
                //newremarkwfcount0List.add(""+newcount);
            }
            if(viewtype==-1){
            	newcount1=theworkflowcount;
            	Object tempobj = newremarkwfcount1Map.get(tworkflowid);
                if (tempobj != null) {
                	int wf0countindex = (Integer)tempobj ;
                	newremarkwfcount1Map.put(tworkflowid, wf0countindex + newcount1);
                } else {
                    newremarkwfcount1Map.put(tworkflowid, newcount1);  
                }
                 //newremarkwfcount1List.add(""+newcount1);
                 
            }
        }

            int wftindex = wftypeList.indexOf(tworkflowtype) ;
            if(wftindex != -1) {
                wftypecountList.set(wftindex,""+(Util.getIntValue((String)wftypecountList.get(wftindex), 0)+theworkflowcount)) ;
            }
            totalcount += theworkflowcount;
    }
//    newremarkwfcount0List.add(""+newcount);
    //newremarkwfcount1List.add(""+newcount1);

    int overtimecount=0;
//    if(templist.size()==2){

	sqlsb = new StringBuffer();
	if("1".equals(belongtoshow)){
	sqlsb.append("select a.workflowtype,a.workflowid, count(distinct a.requestid) overcount ");
	}else{
	sqlsb.append("select a.workflowtype,a.workflowid, count(a.requestid) overcount ");
	}
	sqlsb.append("  from workflow_currentoperator a ");
	sqlsb.append("  where (((isremark='0' and (takisremark is null or takisremark=0 )) and (isprocessed = '2' or isprocessed = '3')) or ");
	sqlsb.append("        isremark = '5') ");
	sqlsb.append("    and islasttimes = 1 ");
    if(!"".equals(cursltwftypeid)){
	    sqlsb.append("   and workflowtype in (").append(cursltwftypeid).append(")");
    }
    //if(!"".equals(cursltwfid)){
	//    sqlsb.append("   and workflowid = ").append(cursltwfid);
    //}
		if("1".equals(belongtoshow)){
		sqlsb.append("	    and userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and userid in (").append(resourceid);
		}
	sqlsb.append("   ) and usertype = ").append(usertype);
	if(!"".equals(wftypesb.toString())){
		sqlsb.append("    and a.workflowtype in (").append(wftypesb).append(")");
	}
	if(!"".equals(wfsb.toString())){
		sqlsb.append("    and a.workflowid in (").append(wfsb).append(")");
	}
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
		sqlsb.append(" and a.nodeid in (" + WorkflowVersion.getAllRelationNodeStringByNodeIDs(tworkflowNodeIDs) + ") ");
	}
   	if(!superior)
   	{
//   		sqlsb.append(" AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator b WHERE b.islasttimes='1' AND b.userid=" + user.getUID() + " and b.usertype= " + usertype + ") ");
   		sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ");
   	}
   	
   	if(offical.equals("1")){//发文/收文/签报
		if(officalType==1){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
		}else if(officalType==2){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
		}
	}
   	sqlsb.append(" GROUP BY a.workflowtype, a.workflowid ");
    RecordSet.executeSql(sqlsb.toString()) ;
    while (RecordSet.next()) {
       String tworkflowtype = Util.null2String(RecordSet.getString("workflowtype"));
       String tworkflowid = WorkflowVersion.getActiveVersionWFID(Util.null2String(RecordSet.getString("workflowid")));
       
       overtimecount=RecordSet.getInt("overcount");
       
       int wfindex = workflowList.indexOf(tworkflowid) ;
       if(wfindex != -1) {
           workflowcountList.set(wfindex,""+(Util.getIntValue((String)workflowcountList.get(wfindex),0) + overtimecount)) ;
       }
       int wftindex = wftypeList.indexOf(tworkflowtype) ;
       if(wftindex != -1) {
           wftypecountList.set(wftindex,""+(Util.getIntValue((String)wftypecountList.get(wftindex),0)+overtimecount)) ;
       }
       Object tempobj = wfovertimecountMap.get(tworkflowid);
       if (tempobj != null) {
       	int wf0countindex = (Integer)tempobj ;
       	wfovertimecountMap.put(tworkflowid, wf0countindex + overtimecount);
       } else {
           wfovertimecountMap.put(tworkflowid, overtimecount);  
       }
       totalcount += overtimecount;
    }
    
    //求被督办的流程，和其他查询不冲突
    sqlsb = new StringBuffer();
    sqlsb.append("select a.workflowtype, a.workflowid, count(0) workflowcount ");
	sqlsb.append("	  from workflow_currentoperator a ");
	sqlsb.append("	  where ((isremark = '0' and (isprocessed is null or ");
	sqlsb.append("	        (isprocessed <> '2' and isprocessed <> '3'))) or isremark = '1' or ");
	sqlsb.append("	        isremark = '8' or isremark = '9' or isremark = '7') ");
	sqlsb.append("	    and islasttimes = 1 ");
    if(!"".equals(cursltwftypeid)){
	    sqlsb.append("   and workflowtype in (").append(cursltwftypeid).append(")");
    }
    
		if("1".equals(belongtoshow)){
		sqlsb.append("	    and userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and userid in (").append(resourceid);
		}
	sqlsb.append("	)    and usertype = ").append(usertype);
	if(!"".equals(wftypesb.toString())){
		sqlsb.append("	    and a.workflowtype in (").append(wftypesb).append(")");
	}
	if(!"".equals(wfsb.toString())){
		sqlsb.append("	    and a.workflowid in (").append(wfsb).append(")");
	}
	sqlsb.append("	    and exists (select c.requestid ");
	sqlsb.append("	           from workflow_requestbase c ");
	sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.requestid = a.requestid");
	sqlsb.append("		and ( select count(0) from workflow_requestlog where requestid = a.requestid and logtype='s') > 0");
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
		sqlsb.append(" and a.nodeid in (" + WorkflowVersion.getAllRelationNodeStringByNodeIDs(tworkflowNodeIDs) + ") ");
	}
    if(!superior)
	{
//    	sqlsb.append(" AND EXISTS (SELECT 1 FROM workFlow_CurrentOperator b WHERE b.islasttimes='1' AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ");
    	sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype + ") ");
	}
	
	if(offical.equals("1")){//发文/收文/签报
		if(officalType==1){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
		}else if(officalType==2){
			sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
		}
	}
	sqlsb.append(" GROUP BY a.workflowtype, a.workflowid");

    RecordSet.executeSql(sqlsb.toString());
    while (RecordSet.next()) {
        String tworkflowtype = Util.null2String(RecordSet.getString("workflowtype"));
        String tworkflowid = WorkflowVersion.getActiveVersionWFID(Util.null2String(RecordSet.getString("workflowid")));
        overtimecount=RecordSet.getInt(3);
        Object tempobj = wfsupedcountMap.get(tworkflowid);
        if (tempobj != null) {
        	int wf0countindex = (Integer)tempobj ;
        	wfsupedcountMap.put(tworkflowid, wf0countindex + overtimecount);
        } else {
            wfsupedcountMap.put(tworkflowid, overtimecount);  
        }
    }
   	  
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
		    
		    String tempworkflowid = (String)workflowList.get(i);
		    
			workflowcountList.remove(i);
			workflowList.remove(i);
			newremarkwfcount0Map.remove(tempworkflowid);
			newremarkwfcount1Map.remove(tempworkflowid);
			
			//newremarkwfcount0List.remove(i);
			//newremarkwfcount1List.remove(i);
			wftypeworkflowList.remove(i);
			i--;
		}
	}
		
		/*******************************/
		
    if (!"".equals(cursltwftypeid)) {
        
    	if (wftypeList.size() == 0) {
    	    
    	    String[] curoptwfarrary = cursltwftypeid.split(",");
    		for (int i=0; i<curoptwfarrary.length; i++) {
    		    wftypeList.add(curoptwfarrary[i]);
            	wftypecountList.add("0");
    		}
    	}
    	
    	String _tempwfsql = "SELECT id FROM workflow_base WHERE workflowtype in (" + cursltwftypeid + ")";
    	RecordSet _temprs = new RecordSet();
    	_temprs.executeSql(_tempwfsql);
    	while (_temprs.next()) {
    	    
    		String _tempwfid = Util.null2String(_temprs.getString("id"));
    	    if (!workflowList.contains(_tempwfid)) {
    	        workflowList.add(_tempwfid);
    	        workflowcountList.add("0");
    	    }
    	}
    }
		//左侧树拼接 json
	demoLeftMenus = "[";
	
	for (int i = 0; i < wftypeList.size(); i++) {
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
		demoLeftMenus+="\"__domid__\":\"__type_"+typeid+"\",";
		
		int flowNew=0;
		int flowResponse=0;
		int flowOut=0;
		int flowAll=0;
		int flowSup=0;
			
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
			map.put("flowSup",Util.toScreen(wfsupedcount, user.getLanguage()));
			flowNew+=Integer.valueOf(map.get("flowNew")+"");
			flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
			flowOut+=Integer.valueOf(map.get("flowOut")+"");
			flowAll+=Integer.valueOf(map.get("flowAll")+"");
			flowSup+=Integer.valueOf(map.get("flowSup")+"");
			maps.add(map);
		}
				
				demoLeftMenus += "\"numbers\":{";
				demoLeftMenus += "\"flowNew\":"+flowNew+",";
				demoLeftMenus += "\"flowResponse\":"+flowResponse+",";
				demoLeftMenus += "\"flowOut\":"+flowOut+",";
				demoLeftMenus += "\"flowAll\":"+flowAll+",";
				demoLeftMenus += "\"flowSup\":"+flowSup;
				demoLeftMenus += "},";
				
				demoLeftMenus += "\"attr\":{";
				demoLeftMenus += "\"typeid\":"+typeid+",";
				demoLeftMenus += "\"flowNew\":"+flowNew+",";
				demoLeftMenus += "\"flowResponse\":"+flowResponse+",";
				demoLeftMenus += "\"flowOut\":"+flowOut+",";
				demoLeftMenus += "\"flowAll\":"+flowAll+",";
				demoLeftMenus += "\"flowSup\":"+flowSup;
				demoLeftMenus += "}";
				demoLeftMenus += "}";
				
			if (maps.size() > 0) {
				demoLeftMenus += ",";
			}
				
				for(int x=0;x<maps.size();x++){
					Map map=maps.get(x);

					demoLeftMenus += "{";
					demoLeftMenus+="\"__domid__\":\"__wf_"+map.get("workflowid")+"\",";
						demoLeftMenus += "\"numbers\":{";
							demoLeftMenus += "\"flowNew\":"+map.get("flowNew")+",";
							demoLeftMenus += "\"flowResponse\":"+map.get("flowResponse")+",";
							demoLeftMenus += "\"flowOut\":"+map.get("flowOut")+",";
						 	demoLeftMenus += "\"flowAll\":"+map.get("flowAll")+",";
							demoLeftMenus += "\"flowSup\":"+map.get("flowSup");
							demoLeftMenus += "},";
							
							demoLeftMenus += "\"attr\":{";
							demoLeftMenus += "\"workflowid\":"+map.get("workflowid")+",";
							demoLeftMenus += "\"flowNew\":"+map.get("flowNew")+",";
							demoLeftMenus += "\"flowResponse\":"+map.get("flowResponse")+",";
							demoLeftMenus += "\"flowOut\":"+map.get("flowOut")+",";
							demoLeftMenus += "\"flowAll\":"+map.get("flowAll")+",";
							demoLeftMenus += "\"flowSup\":"+map.get("flowSup");
							demoLeftMenus += "}";
							
							demoLeftMenus += "}";
							demoLeftMenus += (x==maps.size()-1)?"":",";
				}
				if (i < wftypeList.size() - 1) {
					demoLeftMenus += ",";
				}
				
		}
		
		
		if(requestutil.getOfsSetting().getIsuse()==1) {
            RecordSet rs1 = new RecordSet();
            int wftype_count = 0;
            rs.executeSql("select sysid,sysshortname from ofs_sysinfo order by sysid desc");
            wftype_count = rs.getCounts();
            while (rs.next()) {
                String _typeid = rs.getString(1);
                String _typename = rs.getString(2);
                if (demoLeftMenus.length() > 10) {
                    demoLeftMenus += ",";
                }
                int wf_count = 0;
                ArrayList wfids = new ArrayList();
                ArrayList wfcounts = new ArrayList();
                ArrayList wfnewcounts = new ArrayList();
                RecordSet.executeSql("select workflowid,workflowname from ofs_workflow where sysid="+_typeid+" and Cancel=0 order by workflowid desc");
                wf_count = RecordSet.getCounts();
                int wfcountall = 0;
                int wfnewcountall = 0 ;
                while (RecordSet.next()) {
                    String _wfid = RecordSet.getString(1);
                    String _wfname = RecordSet.getString(2);
                    String sqlos = "select COUNT(requestid) from ofs_todo_data where workflowid="+_wfid+" and userid="+user.getUID()+" and isremark='0' and islasttimes=1" ;
                    rs1.executeSql(sqlos);
                    int wfcount = 0;
                    if (rs1.next()) {
                        wfcount = Util.getIntValue(rs1.getString(1), 0);
                    }
                    wfcountall += wfcount;
					sqlos = "select COUNT(requestid) from ofs_todo_data where workflowid="+_wfid+" and userid="+user.getUID()+" and isremark='0' and islasttimes=1 and viewtype=0 " ;
                    rs1.executeSql(sqlos);
                    int wfnewcount = 0;
                    if (rs1.next()) {
                        wfnewcount = Util.getIntValue(rs1.getString(1), 0);
                    }
                    wfnewcountall += wfnewcount;
                    wfids.add(_wfid);
                    wfcounts.add(wfcount+"");
                    wfnewcounts.add(wfnewcount+"");
                }
                demoLeftMenus += "{";
                demoLeftMenus += " \"__domid__\":\"__type_" + _typeid + "\",";
                demoLeftMenus += "\"attr\":{";
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

                for(int i = 0 ; i < wfids.size() ; i++){
	                demoLeftMenus += ",{";
                    demoLeftMenus += "\"__domid__\":\"__wf_" + Util.null2String(wfids.get(i)) + "\",";
                    demoLeftMenus += "\"attr\":{";
                    demoLeftMenus += "\"flowNew\":"+Util.null2String(wfnewcounts.get(i))+",";
                    demoLeftMenus += "\"flowResponse\":0,";
                    demoLeftMenus += "\"flowOut\":0,";
                    demoLeftMenus += "\"flowAll\":" + Util.null2String(wfcounts.get(i)) + ",";
                    demoLeftMenus += "\"flowSup\":0";
                    demoLeftMenus += "},";
                    demoLeftMenus += "\"numbers\":{";
                    demoLeftMenus += "\"flowNew\":"+Util.null2String(wfnewcounts.get(i))+",";
                    demoLeftMenus += "\"flowResponse\":0,";
                    demoLeftMenus += "\"flowOut\":0,";
                    demoLeftMenus += "\"flowAll\":" + Util.null2String(wfcounts.get(i)) + ",";
                    demoLeftMenus += "\"flowSup\":0";
                    demoLeftMenus += "}";
                    demoLeftMenus += "}";
                    //demoLeftMenus += ",";
                }
            }
        }
		
		demoLeftMenus += "]";
		out.print(demoLeftMenus);
	%>

