<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>


<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>

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
//是否需要加载树
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"),-1);
String loadtree = Util.null2String(request.getParameter("loadtree"));
int date2during = Util.getIntValue(request.getParameter("date2during"),0);
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =  SystemEnv.getHtmlLabelName(1210,user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
String needfav ="1";
String needhelp ="";
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();     
String resourceid=""+user.getUID();
session.removeAttribute("RequestViewResource");
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
		response.sendRedirect("/workflow/search/WFSearchCustom.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&offical="+offical+"&officalType="+officalType+"&fromadvancedmenu=1&infoId="+infoId+"&selectedContent="+selectedContent+"&menuType="+menuType);
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

if(logintype.equals("2"))
	usertype= 1;
char flag = Util.getSeparator();

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
		location.href="/workflow/request/MyRequestView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&date2during=<%=olddate2during%>";
	}
	else
	{
		location.href="/workflow/request/MyRequestView.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&date2during=0";
	}
}
</script>
</head>

<body>



<% //  if(HrmUserVarify.checkUserRight("requestview:Add", user)){ %>


<% //  }%>

<%
	ArrayList wftypes=new ArrayList();
	ArrayList wftypecounts=new ArrayList();
	ArrayList workflows=new ArrayList();
	ArrayList wftypecountsy=new ArrayList();
	ArrayList workflowcounts=new ArrayList();//未归档的
	ArrayList workflowcountsy=new ArrayList();//归档
	ArrayList newcountslist = new ArrayList();//未读
	ArrayList supedcountslist = new ArrayList();//反馈
	ArrayList overcountslist = new ArrayList();//超时
	
	
	Map workflowcountsMap=new Hashtable();//未归档的数量
	Map workflowcountsyMap=new Hashtable();//归档数量
	Map newcountsMap=new Hashtable();     //未读
	Map supedcountsMap=new Hashtable();//反馈数量
	Map overcountsMap = new Hashtable();	//超时数量
	
	String _viewtype = "";	//
	int totalcount=0;
	int totalcounty=0;
	String currworkflowtype="";
	
	String currworkflowid="";
	String currentnodetype="";
	String _wftypes = "";
	String demoLeftMenus = "";
    if(loadtree.equals("true")){
		StringBuffer sqlsb = new StringBuffer();
		sqlsb.append("select count(distinct t1.requestid) typecount, ");
		sqlsb.append("      t2.workflowtype, ");
		sqlsb.append("      t1.workflowid, ");
		sqlsb.append("      t1.currentnodetype ");
		sqlsb.append(" from workflow_requestbase t1, workflow_base t2,workflow_currentoperator t3 ");
		sqlsb.append(" where t1.creater = ").append(resourceid);
		sqlsb.append("  and t1.creatertype = ").append(usertype);
		sqlsb.append("  and t1.workflowid = t2.id ");
		sqlsb.append("  and t1.requestid = t3.requestid ");
		sqlsb.append("  and t3.islasttimes=1 ");
		sqlsb.append("  and (t2.isvalid='1' or t2.isvalid='3') ");
		if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater="+user.getUID()+")) ");
		}
		sqlsb.append("  and exists ");
		sqlsb.append("		(select 1 ");
		sqlsb.append("         from workflow_currentoperator ");
		sqlsb.append("        where workflow_currentoperator.islasttimes='1' ");
		sqlsb.append("          and workflow_currentoperator.userid = " + resourceid + WorkflowComInfo.getDateDuringSql(date2during) +") ");
		if(offical.equals("1")){//发文/收文/签报
			if(officalType==1){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and isvalid=1)");
			}else if(officalType==2){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and isvalid=1)");
			}
		}
		sqlsb.append("group by t2.workflowtype, t1.workflowid, t1.currentnodetype");
		RecordSet.executeSql(sqlsb.toString());
		//System.out.println("sqlsb.toString():"+sqlsb.toString());
	    //RecordSet.executeProc("workflow_requestbase_MyRequest",resourceid+flag+usertype);
		while (RecordSet.next())
		{
			currworkflowtype = RecordSet.getString("workflowtype");
			currworkflowid = RecordSet.getString("workflowid");
			 
			currworkflowid = WorkflowVersion.getActiveVersionWFID(currworkflowid);
			 
			currentnodetype=RecordSet.getString("currentnodetype");
			_viewtype = RecordSet.getString("viewtype");
			int theworkflowcount=RecordSet.getInt("typecount");
			if(selectedworkflow.indexOf("T"+currworkflowtype+"|")==-1 && fromAdvancedMenu==1) continue;
			if(selectedworkflow.indexOf("W"+currworkflowid+"|")==-1 && fromAdvancedMenu==1) continue;
			int temps=wftypes.indexOf(currworkflowtype);
			if (temps!=-1)
			{
			 	if (currentnodetype.equals("3"))
			 		wftypecountsy.set(temps,""+(Util.getIntValue((String)wftypecountsy.get(temps),0)+theworkflowcount));
			 	else
			  		wftypecounts.set(temps,""+(Util.getIntValue((String)wftypecounts.get(temps),0)+theworkflowcount));
			}
			else
			{
			 	wftypes.add(currworkflowtype);
			 	if (currentnodetype.equals("3"))
			 	{
			 		wftypecountsy.add(""+RecordSet.getString("typecount"));
			 		wftypecounts.add(""+0);
			 	}
			 	else
			 	{
			 		wftypecounts.add(""+RecordSet.getString("typecount"));
			 		wftypecountsy.add(""+0);
			 	}
			}
			temps=workflows.indexOf(currworkflowid);
			if (temps!=-1)
			{
				if (currentnodetype.equals("3"))
			 		workflowcountsy.set(temps,""+(Util.getIntValue((String)workflowcountsy.get(temps),0)+theworkflowcount));	
			 	else
			 		workflowcounts.set(temps,""+(Util.getIntValue((String)workflowcounts.get(temps),0)+theworkflowcount));
			}
			else
			{
			 	workflows.add(currworkflowid);
			 	if (currentnodetype.equals("3"))
			 	{
			 		workflowcountsy.add(""+RecordSet.getString("typecount"));
			 		workflowcounts.add(""+0);
			 	}
			 	else
			 	{
			 		workflowcounts.add(""+RecordSet.getString("typecount"));
			 		workflowcountsy.add(""+0);
			 	}
			}
			 
			if (currentnodetype.equals("3"))
			 	totalcounty+=theworkflowcount;
			else
			 	totalcount+=theworkflowcount;
		}
		
		//左侧树 json 数据生成逻辑
		demoLeftMenus+="[";
		String typeid="";
		String typecount="";	//未归档的type数量
		String typecounty = "";	//已归档的type数量
		String typename="";
		String workflowid="";
		String workflowcount="";	//未归档的数量
		String workflowcounty = "";	//归档的数量
		String wfnewcount = ""; //未读
		String wfrescount = ""; //反馈
		String wfoutcount = ""; //超时
		String workflowname="";
		       				
		       				//System.out.println("wftypes.size():流程类型总数==>"+wftypes.size());	//流程类型总数
		for(int i=0;i<wftypes.size();i++){
			typeid=(String)wftypes.get(i);
			//typecount=(String)wftypecounts.get(i);
			//typecounty = (String)wftypecountsy.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
		
			demoLeftMenus+="{";
			demoLeftMenus+="\"name\":\""+Util.toScreen(typename,user.getLanguage())+"\",";
			demoLeftMenus+="\"__domid__\":\"__type_"+typeid+"\",";
			demoLeftMenus+="\"isOpen\":\"true\",";
			demoLeftMenus+="\"attr\":{";
			demoLeftMenus+="\"typeid\":"+typeid+",";
			demoLeftMenus+="\"fromAdvancedMenu\":"+fromAdvancedMenu+",";
			demoLeftMenus+="\"infoId\":"+infoId+",";
			demoLeftMenus+="\"selectedContent\":\""+selectedContent+"\",";
			demoLeftMenus+="\"menuType\":\""+menuType+"\",";
			demoLeftMenus+="\"date2during\":\""+date2during+"\"";
			demoLeftMenus+="},";
			demoLeftMenus+="\"submenus\":[";
			List<Map> maps=new ArrayList(0);
			for(int j=0;j<workflows.size();j++){
				workflowid=(String)workflows.get(j);
				String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
				if(!curtypeid.equals(typeid)){
					continue;
				}
				
				workflowcount=(String)workflowcounts.get(j);
				workflowcounty = (String)workflowcountsy.get(j);
				//wfnewcount = (String)newcountslist.get(j);
				//wfrescount = (String)supedcountslist.get(j);
				//wfoutcount = (String)overcountslist.get(j);
				
				Object tempovtimenumObj = newcountsMap.get(workflowid);
				if (tempovtimenumObj != null) {
				    wfnewcount = tempovtimenumObj.toString();
				} else {
				    wfnewcount = "0";
				}
				
				Object tempovtimenumObj2 = supedcountsMap.get(workflowid);
				if (tempovtimenumObj2 != null) {
				    wfrescount = tempovtimenumObj2.toString();
				} else {
				    wfrescount = "0";
				}
				
				Object tempovtimenumObj3 = overcountsMap.get(workflowid);
				if (tempovtimenumObj3 != null) {
				    wfoutcount = tempovtimenumObj3.toString();
				} else {
				    wfoutcount = "0";
				}
				
				
				//把未归档的和已归档的合并起来  modifier Dracula 2014-7-7
				String wfallcount = (Util.getIntValue(workflowcount) + Util.getIntValue(workflowcounty))+"";
				//System.out.println("未归档："+workflowcount+"   已归档："+workflowcounty);
				workflowname=WorkflowComInfo.getWorkflowname(workflowid);
				//System.out.println(workflowname+"   未读流程："+wfnewcount+"反馈流程："+wfrescount);
					Map map=new HashMap();
					map.put("name",Util.toScreen(workflowname,user.getLanguage()));
					map.put("workflowid",workflowid);
					map.put("flowAll",Util.toScreen("0",user.getLanguage()));
					map.put("flowNew",Util.toScreen("0",user.getLanguage()));
					map.put("flowResponse",Util.toScreen("0",user.getLanguage()));
					map.put("flowOut",Util.toScreen("0",user.getLanguage()));
					if(workflowcount.equals("")) workflowcount = "0";
					if(workflowcounty.equals("0")) workflowcounty = "0";
					//把未归档的和已归档的合并起来 modifier Dracula 2014-7-7
					if(workflowcount.equals("0") && workflowcounty.equals("0"));
					else{
						maps.add(map);
					}
			}
			int flowAll=0;
			int flowNew=0;
			int flowResponse=0;
			int flowOut=0;
			for(int x=0;x<maps.size();x++){
				Map map=maps.get(x);
				flowAll+=Integer.valueOf(map.get("flowAll")+"");
				flowNew+=Integer.valueOf(map.get("flowNew")+"");
				flowResponse+=Integer.valueOf(map.get("flowResponse")+"");
				flowOut+=Integer.valueOf(map.get("flowOut")+"");
		       							
				demoLeftMenus+="{";	
				demoLeftMenus+="\"name\":\""+map.get("name")+"\",";
				demoLeftMenus+="\"__domid__\":\"__wf_"+map.get("workflowid")+"\",";
				demoLeftMenus+="\"isOpen\":\"true\",";
				demoLeftMenus+="\"attr\":{";
				demoLeftMenus+="\"workflowid\":"+map.get("workflowid")+",";
				demoLeftMenus+="\"date2during\":\""+date2during+"\"";
				demoLeftMenus+="},";
				demoLeftMenus+="\"numbers\":{";
				demoLeftMenus+="\"flowAll\":"+map.get("flowAll")+",";
				demoLeftMenus+="\"flowNew\":"+map.get("flowNew")+",";
				demoLeftMenus+="\"flowResponse\":"+map.get("flowResponse")+",";
				demoLeftMenus+="\"flowOut\":"+map.get("flowOut");
				demoLeftMenus+="}";
				demoLeftMenus+="}";
				demoLeftMenus += (x==maps.size()-1)?"":",";
			}
			demoLeftMenus+="],";
			demoLeftMenus+="\"numbers\":{";
			demoLeftMenus+="\"flowAll\":"+flowAll+",";
			demoLeftMenus+="\"flowNew\":"+flowNew+",";
			demoLeftMenus+="\"flowResponse\":"+flowResponse+",";
			demoLeftMenus+="\"flowOut\":"+flowOut;
			demoLeftMenus+="}";
			demoLeftMenus+="}";
			demoLeftMenus += (i==wftypes.size()-1)?"":",";
			_wftypes += typeid+",";
		}
		demoLeftMenus += "]";
		out.clear();
		out.print(demoLeftMenus);
		//System.out.println(demoLeftMenus);
		return;
    }
	
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	if(!isUseOldWfMode){
		String typeid="";
		String typecount="";
		String typename="";
		String workflowid="";
		String workflowcount="";
		String workflowname="";
		int typerowcounts=wftypes.size();
		
		JSONArray jsonFinishedWfTypeArray = new JSONArray();
		JSONArray jsonUnFinishedWfTypeArray = new JSONArray();
		 
	    for(int i=0;i<typerowcounts;i++){
	    	             
		   	JSONObject jsonWfType = new JSONObject();
		    jsonWfType.put("draggable",false);
			jsonWfType.put("leaf",false);
			
			typeid=(String)wftypes.get(i);
			typecount=(String)wftypecounts.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
			if (!typecount.equals("0"))
			{
				if(fromAdvancedMenu==1){
					jsonWfType.put("paras","offical="+offical+"&officalType="+officalType+"&method=myreqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=0&selectedContent="+selectedContent+"&menuType="+menuType);
				}
				else{
					jsonWfType.put("paras","offical="+offical+"&officalType="+officalType+"&method=myreqeustbywftype&wftype="+typeid+"&complete=0");
				}
				jsonWfType.put("text","<a href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true) >"+typename+"&nbsp;</a>("+typecount+")");
				jsonWfType.put("cls","wfTreeFolderNode");	
							                      			
				//if(typeid.equals("24")) continue;
				
		        JSONArray jsonWfTypeChildrenArray = new JSONArray();
		        for(int j=0;j<workflows.size();j++){
		        	String wfText = "";
		        	workflowid=(String)workflows.get(j);
					String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
					if(!curtypeid.equals(typeid))	continue;
		        	
					JSONObject jsonWfTypeChild = new JSONObject();
		        	jsonWfTypeChild.put("draggable",false);
		        	jsonWfTypeChild.put("leaf",true);
		        	
		        	workflowcount=(String)workflowcounts.get(j);
					workflowname=WorkflowComInfo.getWorkflowname(workflowid);
					if (!workflowcount.equals("0")){
						
						jsonWfTypeChild.put("paras","offical="+offical+"&officalType="+officalType+"&method=myreqeustbywfid&workflowid="+workflowid+"&complete=0");
						wfText +="<a  href=# onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
						
						wfText+=Util.toScreen(workflowcount,user.getLanguage())+")";						
						
						jsonWfTypeChild.put("text",wfText);
						jsonWfTypeChild.put("iconCls","btn_dot");
						jsonWfTypeChild.put("cls","wfTreeLeafNode");
						jsonWfTypeChildrenArray.put(jsonWfTypeChild);
					}
				}	
		                                                
		        jsonWfType.put("children",jsonWfTypeChildrenArray);
		        jsonUnFinishedWfTypeArray.put(jsonWfType);
			}
	    }
	     
	    for(int i=0;i<typerowcounts;i++){
            
		   	JSONObject jsonWfType = new JSONObject();
		    jsonWfType.put("draggable",false);
			jsonWfType.put("leaf",false);
			
			typeid=(String)wftypes.get(i);
			typecount=(String)wftypecountsy.get(i);
			typename=WorkTypeComInfo.getWorkTypename(typeid);
			if (!typecount.equals("0"))
			{
				if(fromAdvancedMenu==1){
					jsonWfType.put("paras","offical="+offical+"&officalType="+officalType+"&method=myreqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=1&selectedContent="+selectedContent+"&menuType="+menuType);
				}
				else{
					jsonWfType.put("paras","offical="+offical+"&officalType="+officalType+"&method=myreqeustbywftype&wftype="+typeid+"&complete=1");
				}
				jsonWfType.put("text","<a href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true) >"+typename+"&nbsp;</a>("+typecount+")");
				jsonWfType.put("cls","wfTreeFolderNode");		
							                      			
				//if(typeid.equals("24")) continue;
				
		        JSONArray jsonWfTypeChildrenArray = new JSONArray();
		        for(int j=0;j<workflows.size();j++){
		        	String wfText = "";
		        	workflowid=(String)workflows.get(j);
					String curtypeid=WorkflowComInfo.getWorkflowtype(workflowid);
					if(!curtypeid.equals(typeid))	continue;
		        	
					JSONObject jsonWfTypeChild = new JSONObject();
		        	jsonWfTypeChild.put("draggable",false);
		        	jsonWfTypeChild.put("leaf",true);
		        	
		        	workflowcount=(String)workflowcountsy.get(j);
					workflowname=WorkflowComInfo.getWorkflowname(workflowid);
					if (!workflowcount.equals("0")){
						
						jsonWfTypeChild.put("paras","offical="+offical+"&officalType="+officalType+"&method=myreqeustbywfid&workflowid="+workflowid+"&complete=1");
						wfText +="<a href = # onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
						
						wfText+=Util.toScreen(workflowcount,user.getLanguage())+")";						
						
						jsonWfTypeChild.put("text",wfText);
						jsonWfTypeChild.put("iconCls","btn_dot");
						jsonWfTypeChild.put("cls","wfTreeLeafNode");
						jsonWfTypeChildrenArray.put(jsonWfTypeChild);
					}
				}	
		                                                
		        jsonWfType.put("children",jsonWfTypeChildrenArray);
		        jsonFinishedWfTypeArray.put(jsonWfType);
			}
	    }
	   
	    session.setAttribute("finished",jsonFinishedWfTypeArray);
	    session.setAttribute("unfinished",jsonUnFinishedWfTypeArray);
	    session.setAttribute("finishedCount",""+totalcounty);
	    session.setAttribute("unfinishedCount",""+totalcount);
		
	    response.sendRedirect("/workflow/request/ext/Request.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&offical="+offical+"&officalType="+officalType+"&type=myrequest");  //type: view,表待办 handled表已办
		
		return;	
	}
	
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(16342,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&offical="+offical+"&officalType="+officalType+"&method=myall&complete=0&viewType=4,_self} " ;
	RCMenuHeight += RCMenuHeightStep;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(16343,user.getLanguage())+",/workflow/search/WFSearchTemp.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&offical="+offical+"&officalType="+officalType+"&method=myall&complete=1&viewType=4,_self} " ;
	RCMenuHeight += RCMenuHeightStep;

}
/* edited end */    
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

		<script type="text/javascript">
			function showloading()
			{
				if(jQuery(".leftTypeSearch").css("display") === "none");
				else
					e8_before2();
			}
			var demoLeftMenus = [];
			function onloadtree()
			{
				var ajax=ajaxinit();
       			ajax.open("POST", "/workflow/request/MyRequestViewForWS.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>", true);
       			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
       			ajax.send("loadtree=true");
       			
        		ajax.onreadystatechange = function() {
        		//如果执行状态成功，那么就把返回信息写到指定的层里
        			if (ajax.readyState==4&&ajax.status == 200) {
        				try{
        					var restr = ajax.responseText;
        					$("#overFlowDiv").attr("loadtree","true");
							demoLeftMenus = jQuery.parseJSON(restr);
							var needflowOut=true;
							var needflowResponse=true;
							
							var	numberTypes={
									flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(84379,user.getLanguage())%>"}
							};
							if(needflowOut==true || needflowOut=="true"){
								numberTypes.flowOut={hoverColor:"#CB9CF4",color:"#CB9CF4",title:"<%=SystemEnv.getHtmlLabelName(84505,user.getLanguage())%>"};
							}
							if(needflowResponse==true || needflowResponse=="true"){
								numberTypes.flowResponse={hoverColor:"#FFC600",color:"#FFC600",title:"<%=SystemEnv.getHtmlLabelName(84506,user.getLanguage())%>"};
							}
							numberTypes.flowAll={hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84382,user.getLanguage())%>",display:false};
							if(demoLeftMenus != null)
							{
								$(".ulDiv").leftNumMenu(demoLeftMenus,{
									numberTypes:numberTypes,
									showZero:false,
									_callback:onloadtreeCount,
									menuStyles:["menu_lv1",""],
									clickFunction:function(attr,level,numberType){
										leftMenuClickFn(attr,level,numberType);
									}
								});
							}
							var sumCount=0;
							$(".e8_level_2").each(function(){
								sumCount+=parseInt($(this).find(".e8_block:last").html());
							});
							e8_after2();	
        				}catch(e){e8_after2();}
       				}
       			}
        	}
			
			function onloadtreeCount(obj,menus,options,level,customparams){
				jQuery(obj).leftNumMenu("/workflow/request/MyRequestViewAjaxCount.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>","update");
			}
			
			function leftMenuClickFn(attr,level,numberType){
				var doingTypes={
					"flowAll":{complete:0},			//全部
					"flowNew":{complete:4},			//未读
					"flowResponse":{complete:3},	//反馈
					"flowOut":{complete:5}
				};
				if(numberType==null){
					numberType="flowAll";
				}
				var url;
				var typeid=attr.typeid;
				var fromAdvancedMenu=attr.fromAdvancedMenu;
				var infoId=attr.infoId;
				var selectedContent=attr.selectedContent;
				var menuType=attr.menuType;
				var date2during=attr.date2during;
				var workflowid=attr.workflowid;
				var viewcondition=doingTypes[numberType].complete;
				if(level==1){
					window.typeid=typeid;
					window.workflowid=null;
					window.nodeids=null;
					if(fromAdvancedMenu=="1"){
						url="/workflow/search/wfTabNewFrameForWS.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&method=myreqeustbywftype&fromadvancedmenu="+fromAdvancedMenu+"&infoId="+infoId+"&wftype="+typeid+"&complete=2&viewcondition="+viewcondition+"&selectedContent="+selectedContent +"&menuType="+menuType +"&date2during="+date2during +"&viewType=4&wftypes=<%=_wftypes %>";
					}else{
						url="/workflow/search/wfTabNewFrameForWS.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&method=myreqeustbywftype&wftype="+typeid+"&complete=2&viewcondition="+viewcondition+"&date2during="+date2during +"&viewType=4&wftypes=<%=_wftypes %>";
					}
				}else{
					if(numberType==null){
						numberType="flowAll";
					}
					window.typeid=null;
					window.workflowid=workflowid;
					window.nodeids=nodeids;
					url="/workflow/search/wfTabNewFrameForWS.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&method=myreqeustbywfid&workflowid="+workflowid+"&complete=2&viewcondition="+viewcondition+"&date2during="+date2during+"&viewType=4&wftypes=<%=_wftypes %>";
				}
				url+="&viewScope=mine&numberType="+numberType;
				$(".flowFrame").attr("src",url);
			}
			
			function WfSearchAll(){
				/*清除已选项样式*/
				jQuery(".leftSearchInput").val("");
				if(window.e8_search && window.oldtree!=false){
					if(jQuery(".webfx-tree-item").length>0){
						jQuery(".webfx-tree-item_selected").find("img[src*='w_']").each(function(){
							var lastSrc = jQuery(this).attr("src");
							jQuery(this).attr("src",lastSrc.replace("w_",""));
						});
						jQuery(".webfx-tree-item_selected").removeClass("webfx-tree-item_selected");
					}else{
						jQuery(".curSelectedNode").removeClass("curSelectedNode");
					}
					format("",true);
				}else{
					jQuery(".e8_li_selected").find(".e8menu_icon_close_select").removeClass("e8menu_icon_close_select").addClass("e8menu_icon_close");
					jQuery(".e8_li_selected").find(".e8menu_icon_open_select").removeClass("e8menu_icon_open_select").addClass("e8menu_icon_open");
					jQuery(".e8_li_selected").removeClass("e8_li_selected");
					format2("",true);
				}
				/*清除右侧查询条件并重新查询*/
				document.getElementById("myFrame").src ="/workflow/search/wfTabNewFrameForWS.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&method=myall&viewType=4&viewScope=mine&wftypes=<%=_wftypes %>&complete=2";
			}
		</script>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<script type="text/javascript" src="/js/ecology8/request/requestView_wev8.js"></script>
		
		<table cellspacing="0" cellpadding="0" class="flowsTable"  >
			<tr>
				<td class="leftTypeSearch">
					<span class="leftType" onclick="WfSearchAll()">
						<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
					<span><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage()) %></span>
					</span>
					<span class="leftSearchSpan">
						&nbsp;<input type="text" class="leftSearchInput" />
					</span>
				</td>
				<td rowspan="2">
					<iframe id="myFrame" name="myFrame" src="/workflow/search/wfTabNewFrameForWS.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&offical=<%=offical%>&officalType=<%=officalType%>&method=myall&viewType=4&viewScope=mine&wftypes=<%=_wftypes %>&complete=2" class="flowFrame" style='height:100%;' frameborder="0" ></iframe>
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

