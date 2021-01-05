<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<script type="text/javascript">
location.href="/workflow/request/RequestHandled.jsp";
</script>
<%
	Enumeration em = request.getParameterNames();
	boolean isinit = true;
	while(em.hasMoreElements())
	{
		String paramName = (String)em.nextElement();
		if(!paramName.equals(""))
			isinit = false;
		break;
	}
	int date2during = Util.getIntValue(request.getParameter("date2during"),0);
    String resourceid= Util.null2String(request.getParameter("resourceid"));
    String logintype = ""+user.getLogintype();
    int usertype = 0;

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
    
    if(resourceid.equals("")) {
        resourceid = ""+user.getUID();
        if(logintype.equals("2")) usertype= 1;
        session.removeAttribute("RequestViewResource") ;
    }
    else {
        session.setAttribute("RequestViewResource",resourceid) ;
    }

    char flag = Util.getSeparator();

    String username = Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage());

    if(logintype.equals("2")) username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage()) ;

    String imagefilename = "/images/hdReport_wev8.gif";
    String titlename =  SystemEnv.getHtmlLabelName(17992,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    
	int olddate2during = 0;
    BaseBean baseBean = new BaseBean();
	String date2durings = "";
	try
	{
		date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
	}
	catch(Exception e)
	{}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
	if(date2duringTokens.length>0)
	{
		olddate2during = Util.getIntValue(date2duringTokens[0],0);
	}
	if(olddate2during<0||olddate2during>36)
	{
		olddate2during = 0;
	}
	if(isinit)
	{
		date2during = olddate2during;
	}
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
var date2during = '<%=date2during %>';
function changeShowType()
{
	if(date2during=='0')
	{
		location.href="/workflow/request/RequestComplete.jsp?date2during=<%=olddate2during%>";
	}
	else
	{
		location.href="/workflow/request/RequestComplete.jsp?date2during=0";
	}
}
</script>
</head>



<body>




<%
	String typeid="";
	String typecount="";
	String typename="";
	String workflowid="";
	String workflowcount="";
    String newremarkwfcount0="";
    String newremarkwfcount1="";
	String workflowname="";

    ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList workflowcounts=new ArrayList();
    ArrayList newremarkwfcounts0=new ArrayList();
    ArrayList newremarkwfcounts1=new ArrayList();
    int totalcount=0;
	StringBuffer sqlsb = new StringBuffer();
	sqlsb.append("select workflowtype, ");
	sqlsb.append("     workflowid, ");
	sqlsb.append("      viewtype, ");
	sqlsb.append("      count(distinct requestid) workflowcount ");
	sqlsb.append("  from workflow_currentoperator ");
	sqlsb.append(" where isremark in('2','4') and iscomplete = 1 ");
	sqlsb.append("   and islasttimes = 1 ");
	sqlsb.append("   and userid = ").append(resourceid);
	sqlsb.append("   and usertype = ").append(usertype).append(WorkflowComInfo.getDateDuringSql(date2during));
	sqlsb.append("	 and exists ");
	sqlsb.append("	  (select 1 ");
	sqlsb.append("	           from workflow_requestbase c ");
	sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.workflowid = workflow_currentoperator.workflowid ");
	sqlsb.append("	            and c.currentnodetype = '3' ");
	sqlsb.append("	            and c.requestid = workflow_currentoperator.requestid ");
	if(RecordSet.getDBType().equals("oracle"))
	{
		sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
	}
	else
	{
		sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
	}
	sqlsb.append(")");
	sqlsb.append(" group by workflowtype, workflowid, viewtype ");
	sqlsb.append(" order by workflowtype, workflowid ");
	RecordSet.executeSql(sqlsb.toString()) ;
	while(RecordSet.next()){       
        String theworkflowid = Util.null2String(RecordSet.getString("workflowid")) ;        
        String theworkflowtype = Util.null2String(RecordSet.getString("workflowtype")) ;
		int theworkflowcount = Util.getIntValue(RecordSet.getString("workflowcount"),0) ;
		int viewtype = Util.getIntValue(RecordSet.getString("viewtype"),2) ;       
		theworkflowid = WorkflowVersion.getActiveVersionWFID(theworkflowid);
        if(WorkflowComInfo.getIsValid(theworkflowid).equals("1")){
        	
            /* added by wdl 2006-06-14 left menu advanced menu */
    	 	if(selectedworkflow.indexOf("T"+theworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
    	 	if(selectedworkflow.indexOf("W"+theworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
    	 	/* added end */
        	
            int wfindex = workflows.indexOf(theworkflowid) ;
            if(wfindex != -1) {
                workflowcounts.set(wfindex,""+(Util.getIntValue((String)workflowcounts.get(wfindex),0)+theworkflowcount)) ;
                if(viewtype==0){
                    newremarkwfcounts0.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts0.get(wfindex),0)+theworkflowcount)) ;
                }
                if(viewtype==-1){
                    newremarkwfcounts1.set(wfindex,""+(Util.getIntValue((String)newremarkwfcounts1.get(wfindex),0)+theworkflowcount)) ;
                }
            }else{
                workflows.add(theworkflowid) ;
                workflowcounts.add(""+theworkflowcount) ;	
                if(viewtype==0){
                    newremarkwfcounts0.add(""+theworkflowcount);
                    newremarkwfcounts1.add(""+0);
                }else if(viewtype==-1){
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+theworkflowcount);
                }else{
                    newremarkwfcounts0.add(""+0);
                    newremarkwfcounts1.add(""+0);
                }
            }

            int wftindex = wftypes.indexOf(theworkflowtype) ;
            if(wftindex != -1) {
                wftypecounts.set(wftindex,""+(Util.getIntValue((String)wftypecounts.get(wftindex),0)+theworkflowcount)) ;
            }
            else {
                wftypes.add(theworkflowtype) ;
                wftypecounts.add(""+theworkflowcount) ;
            }
            totalcount += theworkflowcount;
        }
	}
	
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	if(!isUseOldWfMode){
		int typerowcounts=wftypes.size();
		//typerowcounts=(wftypes.size()+1)/2;
		JSONArray jsonWfTypeArray = new JSONArray();
	    for(int i=0;i<typerowcounts;i++){
	    	             
		   	JSONObject jsonWfType = new JSONObject();
		    jsonWfType.put("draggable",false);
			jsonWfType.put("leaf",false);
			jsonWfType.put("cls","wfTreeFolderNode");
			typeid=(String)wftypes.get(i);              
		 	typecount=(String)wftypecounts.get(i);
            typename=WorkTypeComInfo.getWorkTypename(typeid);			
            
            if(fromAdvancedMenu==1){
				jsonWfType.put("paras","method=reqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=1&selectedContent="+selectedContent+"&menuType="+menuType);
			}
			else{
				jsonWfType.put("paras","method=reqeustbywftype&wftype="+typeid+"&complete=1");
			}
	        JSONArray jsonWfTypeChildrenArray = new JSONArray();
	        int newremarkCount0 = 0;
	        int newremarkCount1 = 0;
	        for(int j=0;j<workflows.size();j++){
	        	String wfText = "";
	        	workflowid=(String)workflows.get(j);
                String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
	        	if(!curtypeid.equals(typeid))	continue;
	        	workflowcount=(String)workflowcounts.get(j);
                newremarkwfcount0=(String)newremarkwfcounts0.get(j);
                newremarkwfcount1=(String)newremarkwfcounts1.get(j);
                workflowname=WorkflowComInfo.getWorkflowname(workflowid);
                
                JSONObject jsonWfTypeChild = new JSONObject();
	        	jsonWfTypeChild.put("draggable",false);
	        	jsonWfTypeChild.put("leaf",true);
	        	jsonWfTypeChild.put("iconCls","btn_dot");
				jsonWfTypeChild.put("cls","wfTreeLeafNode");
				
				jsonWfTypeChild.put("paras","method=reqeustbywfid&workflowid="+workflowid+"&complete=1");
				wfText +="<a href=#  onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
				
				if(!newremarkwfcount0.equals("0")){
					String paras = "method=reqeustbywfid&workflowid="+workflowid+"&complete=6";
					wfText+="<a href=# onClick=javaScript:loadGrid('"+paras+"',true)  >"+Util.toScreen(newremarkwfcount0,user.getLanguage())+"</a><IMG src='/images/BDNew_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
					newremarkCount0 =newremarkCount0+Util.getIntValue(newremarkwfcount0);
				}
				
				if(!newremarkwfcount1.equals("0")){
					String paras = "method=reqeustbywfid&workflowid="+workflowid+"&complete=7";
					wfText+="<a href=# onClick=javaScript:loadGrid('"+paras+"',true)  >"+Util.toScreen(newremarkwfcount1,user.getLanguage())+"</a><IMG src='/images/BDNew2_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
					newremarkCount1 =newremarkCount1+Util.getIntValue(newremarkwfcount1);
				}
				
				wfText+=Util.toScreen(workflowcount,user.getLanguage())+")";
				
				jsonWfTypeChild.put("text",wfText);
				jsonWfTypeChildrenArray.put(jsonWfTypeChild);

			}	
	        String wfText ="";
	        if(newremarkCount0>0){
	        	wfText+=newremarkCount0+"<IMG src='/images/BDNew_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
	        }
	        if(newremarkCount1>0){
	        	wfText+=newremarkCount1+"<IMG src='/images/BDNew2_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
	        } 
	        jsonWfType.put("text","<a href=#  onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true) >"+typename+"&nbsp;</a>("+wfText+typecount+")");

	        jsonWfType.put("children",jsonWfTypeChildrenArray);
	        jsonWfTypeArray.put(jsonWfType);
		}
	    
	    session.setAttribute("complete",jsonWfTypeArray);
	
	    response.sendRedirect("/workflow/request/ext/Request.jsp?type=complete&fromAdvancedMenu="+fromAdvancedMenu+"&selectedContent="+selectedContent+"&menuType="+menuType);  //type: view,表待办 handled表已办
	    
		return;	
	}
	//共项
	titlename+="&nbsp;&nbsp;("+SystemEnv.getHtmlLabelName(18609,user.getLanguage())+""+totalcount+""+SystemEnv.getHtmlLabelName(26302,user.getLanguage())+")";
    if(date2during>0)
    {
    	//最近个月
    	titlename+="("+SystemEnv.getHtmlLabelName(24515,user.getLanguage())+""+date2during+""+SystemEnv.getHtmlLabelName(26301,user.getLanguage())+")";
    }
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<form name=frmmain method=post action="RequestView.jsp">
    <div>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    /* edited by wdl 2006-06-14 left menu advanced menu */
    if(date2during==0)
    {
    	//显示部分
       	RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(15154,user.getLanguage())+",javascript:changeShowType(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
	}
    else
	{
    	//显示全部
       	RCMenu += "{"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(332,user.getLanguage())+",javascript:changeShowType(),_self}" ;
        RCMenuHeight += RCMenuHeightStep ;
	}
    
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
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    </div>
</form>

		<script type="text/javascript">
			var demoLeftMenus=[
		<%
			for(int i=0;i<wftypes.size();i++){
				typeid=(String)wftypes.get(i);
				typecount=(String)wftypecounts.get(i);
				typename=WorkTypeComInfo.getWorkTypename(typeid);
		%>
					{	
						name:"<%=Util.toScreen(typename,user.getLanguage())%>",
						attr:{
							typeid:"<%=typeid%>",
							fromAdvancedMenu:"<%=fromAdvancedMenu%>",
							infoId:"<%=infoId%>",
							selectedContent:"<%=selectedContent%>",
							menuType:"<%=menuType%>",
							date2during:"<%=date2during%>"
						},
						submenus:[
			
		<%
				List<Map> maps=new ArrayList(0);
				for(int j=0;j<workflows.size();j++){
					workflowid=(String)workflows.get(j);
					String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
					if(!curtypeid.equals(typeid))	{
						continue;
					}
					workflowcount=(String)workflowcounts.get(j);
					newremarkwfcount0=(String)newremarkwfcounts0.get(j);
					newremarkwfcount1=(String)newremarkwfcounts1.get(j);
					workflowname=WorkflowComInfo.getWorkflowname(workflowid);
					
	 				Map map=new HashMap();
	 				map.put("name",Util.toScreen(workflowname,user.getLanguage()));
	 				map.put("workflowid",workflowid);
	 				map.put("flowResponse",Util.toScreen(newremarkwfcount1,user.getLanguage()));
	 				map.put("flowNew",Util.toScreen(newremarkwfcount0,user.getLanguage()));//
	 				map.put("flowAll",Util.toScreen(workflowcount,user.getLanguage()));
	 				maps.add(map);
				}
					int flowNew=0;
					int flowResponse=0;
					int flowAll=0;
					
					for(int x=0;x<maps.size();x++){
						Map map=maps.get(x);
						flowNew+=Integer.valueOf(map.get("flowNew")+"");
						flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
						flowAll+=Integer.valueOf(map.get("flowAll")+"");
						%>
						{	
							name:"<%=map.get("name")%>",
							attr:{
									workflowid:"<%=map.get("workflowid")%>",
									date2during:"<%=date2during%>"
							},
							numbers:{
								 flowNew:"<%=map.get("flowNew")%>",
								 flowResponse:"<%=map.get("flowResponse")%>",
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
					 flowAll:"<%=flowAll%>"
				}
			}
		<%=i==wftypes.size()-1?"":","%>
		<%
			}
		%>
		];
	</script>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<script type="text/javascript" src="/js/ecology8/request/requestView_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/wf_search_RequestComplete_wev8.js"></script>
	
	<table cellspacing="0" cellpadding="0" class="flowsTable"  >
		<tr>
			<td class="leftTypeSearch">
				<span class="leftType">
					<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
					<span><%=SystemEnv.getHtmlLabelName(21979, user.getLanguage())%></span>
				</span>
				<span class="leftSearchSpan">
					&nbsp;<input type="text" class="leftSearchInput" />
				</span>
			</td>
			<td rowspan="2">
				<iframe src="/workflow/search/wfTabNewFrame.jsp?method=all&viewType=3&viewScope=complete&complete=1" class="flowFrame" frameborder="0" ></iframe>
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
