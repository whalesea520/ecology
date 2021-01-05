
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.request.WFAgentTreeUtil" %>
<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
 <%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />

<% 
String loadtree = Util.null2String(request.getParameter("loadtree"));
//System.out.println(loadtree);
String jsondata = "";
//转换成指定格式json数据
if(loadtree.equals("true"))
{
int logintype = Util.getIntValue(user.getLogintype());
int userID = user.getUID();
WFUrgerManager.setLogintype(logintype);
WFUrgerManager.setUserid(userID); 
//督办性能优化
//ArrayList wftypes=WFUrgerManager.getWrokflowTree();
ArrayList wftypes = WFUrgerManager.getWorkflowTreeCount();
int totalcount=WFUrgerManager.getTotalcounts();

List leftMenus = new ArrayList();

WorkflowComInfo WorkflowComInfo = new WorkflowComInfo();
 for(int i=0; i<wftypes.size(); i++){
	 WFWorkflowTypes wftype = (WFWorkflowTypes)wftypes.get(i);
	 ArrayList workflows = wftype.getWorkflows();
     int typeid = wftype.getWftypeid();
     String typename = WorkTypeComInfo.getWorkTypename(String.valueOf(typeid));
     int counts = wftype.getCounts();
     
     Map typeAttrs = new HashMap();
     typeAttrs.put("objid", String.valueOf(typeid));
	 typeAttrs.put("method","type");
	 typeAttrs.put("workflowname",typename);
     
     
     Map stairMnKv = new HashMap();
     stairMnKv.put("name", typename);
     stairMnKv.put("isOpen",true);
     stairMnKv.put("attr", typeAttrs);
     
     List submenus = new ArrayList();
     
     int  flowNew=0;
     
     Map<String,String> attiveVersionMap = new HashMap<String,String>();
     for (int j=0; j<workflows.size(); j++) {
    	 WFWorkflows wfworkflow = (WFWorkflows)workflows.get(j);
         ArrayList requests = wfworkflow.getReqeustids();
         ArrayList newrequests = wfworkflow.getNewrequestids();
         String workflowname = wfworkflow.getWorkflowname();
         int workflowid = wfworkflow.getWorkflowid();
         //取得活动版本
         String activeworkflowid = WorkflowVersion.getActiveVersionWFID(workflowid + "");
         //如果没有活动版本
         //if(!WorkflowComInfo.getIsValid(activeworkflowid + "").equals("1")){
         //    continue;
         //}
         //如果该活动版本已经添加
         if(activeworkflowid != null && !activeworkflowid.equals("0") && attiveVersionMap.containsKey(activeworkflowid + "")){
             continue;
         }
         attiveVersionMap.put(activeworkflowid + "","");
         
         Map twfAttrs = new HashMap();
         twfAttrs.put("objid", String.valueOf(workflowid));
         twfAttrs.put("method","workflow");
         twfAttrs.put("workflowname",workflowname);
     
		 Map subMnKv = new HashMap();
         subMnKv.put("name", Util.toScreen(workflowname, user.getLanguage()));
         subMnKv.put("attr", twfAttrs);
         
         
         Map numbers2 = new HashMap();
         int requestCount = 0;
         int newrequestCount = 0;
         if(activeworkflowid != null && !activeworkflowid.equals("0")){
             for (int cnt=0; cnt<workflows.size(); cnt++) {
                 WFWorkflows wfworkflowtemp = (WFWorkflows)workflows.get(cnt);
                 int workflowidtemp = wfworkflowtemp.getWorkflowid();
                 if(activeworkflowid.equals(WorkflowVersion.getActiveVersionWFID(workflowidtemp + ""))){
                     newrequestCount += wfworkflowtemp.getNewrequestCount();
                     requestCount += wfworkflowtemp.getReqeustCount();
                 }
             }
         }else{
             newrequestCount = wfworkflow.getNewrequestCount();
             requestCount = wfworkflow.getReqeustCount();
         }
         numbers2.put("flowNew",newrequestCount);
         numbers2.put("flowAll",requestCount);
         subMnKv.put("numbers", numbers2);
         submenus.add(subMnKv);
         
		 flowNew=flowNew+newrequestCount;
     }
     
     stairMnKv.put("submenus", submenus);
     
     Map numbers1 = new HashMap();
     numbers1.put("flowAll",counts);
     numbers1.put("flowNew",flowNew);
     stairMnKv.put("numbers", numbers1);
     
     
     leftMenus.add(stairMnKv);
 }

net.sf.json.JSONArray jo = net.sf.json.JSONArray.fromObject(leftMenus);

//System.out.println( jo.toString());
jsondata = jo.toString();//.replaceAll("\"", "\\\\\"");
out.clear();
out.print(jsondata);
//System.out.println(demoLeftMenus);
return;
}
String titlename = SystemEnv.getHtmlLabelName(21979,user.getLanguage());
%>

<html>
   <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
     <head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    </head>
     <body>

<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;"  >
<tr><td class="leftTypeSearch">
	<div class="topMenuTitle" style="border-bottom:none;">
		<span class="leftType">
		<span><img style="vertical-align:middle;" src="/images/ecology8/request/alltype_wev8.png" width="18"/></span>
		<span>
			<div style="width:auto;height:auto;position:relative;">
				<span id="optionSpan"><%=titlename%></span>
			</div>
		</span>
		<span id="totalDoc"></span>
		</span>
		<span class="leftSearchSpan">
			<input type="text" class="leftSearchInput" style="width:110px;"/>
		</span>
	</div>
</td>
</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:100%;position:relative;" id="overFlowDiv">
					<div class="ulDiv" >
					   <div style="width:90%;margin-left:5%" id="e8_loading" class="e8_loading"><%=SystemEnv.getHtmlLabelName(129410, user.getLanguage())%></div>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>

 <script type="text/javascript">
	var treeData=[];
	var	numberTypes={
		flowNew:{hoverColor:"#EE5F5F",color:"#EE5F5F",title:"<%=SystemEnv.getHtmlLabelName(84379,user.getLanguage())%>"},
		flowResponse:{hoverColor:"#FFC600",color:"#FFC600",title:"<%=SystemEnv.getHtmlLabelName(84506,user.getLanguage())%>"},
	    flowAll:{hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84382,user.getLanguage())%>"}
	};
  		

	function ajaxinit(){
		var ajax=false;
		try {
			ajax = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
	        try {
	        	ajax = new ActiveXObject("Microsoft.XMLHTTP");
	        } catch (E) {
	        	ajax = false;
	        }
		}
		if (!ajax && typeof XMLHttpRequest!='undefined') {
			ajax = new XMLHttpRequest();
		}
		return ajax;
	}
        var demoLeftMenus = [];
	
		function onloadtree()
		{
			var ajax=ajaxinit();
      			ajax.open("POST", "/workflow/search/WFSuperviseTreeList.jsp", true);
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
						numberTypes.flowAll={hoverColor:"#A6A6A6",color:"black",title:"<%=SystemEnv.getHtmlLabelName(84382,user.getLanguage())%>"};
						if(demoLeftMenus != null)
						{
							$(".ulDiv").leftNumMenu(demoLeftMenus,{
								numberTypes:numberTypes,
								showZero:false,
								menuStyles:["menu_lv1",""],
								clickFunction:function(attr,level,numberType){
									var doingTypes={
										"flowAll":{complete:0},			//全部
										"flowNew":{complete:3},			//新的
										"flowResponse":{complete:4}	//反馈的
									};
									if(numberType==null)
										numberType="flowAll";
									var complete=doingTypes[numberType].complete;
								   	var frame=$("#contentframe",parent.document);
						           	var method=attr.method;
								   	var objid=attr.objid;
								   	var workflowname = attr.workflowname;
								   	frame.attr("src","/workflow/search/WFSupervise.jsp?menutype="+method+"&menuid="+objid+"&complete="+complete+"&reload=false&workflowname="+workflowname);
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
</script>

	   
	 </body>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</html>