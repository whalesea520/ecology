<%@ page import="java.util.*" %>
<%@page import="org.json.JSONObject"%> 
<%@page import="org.json.JSONArray"%>
<%@ page import="weaver.general.*,weaver.workflow.request.WFWorkflows,weaver.workflow.request.WFWorkflowTypes"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>

<body >


<%

boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
if(!isUseOldWfMode){
    int logintype = Util.getIntValue(user.getLogintype());
    int userID = user.getUID();
    WFUrgerManager.setLogintype(logintype);
    WFUrgerManager.setUserid(userID);
    //督办性能优化
    //ArrayList wftypes=WFUrgerManager.getWrokflowTree();
    ArrayList wftypes=WFUrgerManager.getWorkflowTreeUrger();
    int totalcount=WFUrgerManager.getTotalcounts();
	int typerowcounts=wftypes.size();
	//typerowcounts=(wftypes.size()+1)/2;
	JSONArray jsonWfTypeArray = new JSONArray();
    for(int i=0;i<typerowcounts;i++){
    	             
	   	JSONObject jsonWfType = new JSONObject();
	    jsonWfType.put("draggable",false);
		jsonWfType.put("leaf",false);
		
		 WFWorkflowTypes wftype=(WFWorkflowTypes)wftypes.get(i);
         ArrayList workflows=wftype.getWorkflows();
         String typeid=""+wftype.getWftypeid();
         String typename=WorkTypeComInfo.getWorkTypename(typeid);
         int counts=wftype.getCounts();
        
      
		jsonWfType.put("paras","method=type&objid="+typeid);
		jsonWfType.put("cls","wfTreeFolderNode");	
		
		int newrequestsCount = 0;
        JSONArray jsonWfTypeChildrenArray = new JSONArray();
        for(int j=0;j<workflows.size();j++){
        	String wfText = "";
        	 WFWorkflows wfworkflow=(WFWorkflows)workflows.get(j);
             ArrayList requests=wfworkflow.getReqeustids();
             ArrayList newrequests=wfworkflow.getNewrequestids();
             String workflowname=wfworkflow.getWorkflowname();
             int workflowid=wfworkflow.getWorkflowid();
        	        	            
            JSONObject jsonWfTypeChild = new JSONObject();
        	jsonWfTypeChild.put("draggable",false);
        	jsonWfTypeChild.put("leaf",true);
			
			jsonWfTypeChild.put("paras","method=workflow&objid="+workflowid);
			wfText +="<a  href=# onClick=javaScript:loadGrid('"+jsonWfTypeChild.get("paras").toString()+"',true) >"+workflowname+" </a>&nbsp(";
			
			if(newrequests.size()>0){
				String paras = "method=request&objid="+workflowid;
				//wfText+="<span onClick='javaScript:loadGrid(method=reqeustbywfidNode&workflowid="+workflowid+"&nodeids="+t_nodeids+"&complete=3)' >"+Util.toScreen(newremarkwfcount0,user.getLanguage())+"<IMG src='/images/BDNew_wev8.gif' align=center BORDER=0></span> &nbsp;/&nbsp;";
				wfText+="<a  href =# onClick=javaScript:loadGrid('"+paras+"',true)  >"+newrequests.size()+"</a><IMG src='/images/BDNew_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
				newrequestsCount = newrequestsCount+newrequests.size();
			}
			
			wfText+=requests.size()+")";
			jsonWfTypeChild.put("iconCls","btn_dot");
			jsonWfTypeChild.put("cls","wfTreeLeafNode");
			jsonWfTypeChild.put("text",wfText);
			jsonWfTypeChildrenArray.put(jsonWfTypeChild);

		}	
        String wfText ="";
		if(newrequestsCount>0){
			wfText+=newrequestsCount+"<IMG src='/images/BDNew_wev8.gif' align=center BORDER=0> &nbsp;/&nbsp;";
		}
		jsonWfType.put("text","<a href=# onClick=javaScript:loadGrid('"+jsonWfType.get("paras").toString()+"',true)>"+typename+"&nbsp;</a>("+wfText+counts+")");
		
        jsonWfType.put("children",jsonWfTypeChildrenArray);
        jsonWfTypeArray.put(jsonWfType);
	}
    
    session.setAttribute("supervise",jsonWfTypeArray);

    response.sendRedirect("/workflow/request/ext/Request.jsp?type=supervise");  //type: view,表待办 handled表已办
    
	return;	
}

%>
	<table  class=viewform width=100% id=oTable1 height=100% >
		<tr>
			<td  height=100% id="oTd1" name="oTd1" width="250px" style="background-color:#F8F8F8;padding-left:0px;display:none"> 
				<iframe src="/workflow/search/WFSuperviseTreeList.jsp?loadtree=false" name=leftframe id=leftframe  width="100%" height="100%" frameborder=no scrolling=no >
				<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
				</iframe>
			</td>
			<td height=100% id=oTd2 name=oTd2 width="*" id="tdcontent" style="padding-left:0px;">
				<iframe src="/workflow/search/WFSupervise.jsp?reload=false" name=contentframe id=contentframe width="100%" height="100%" frameborder=no scrolling=no >
				<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
				</iframe>
			</td>
		</tr>
	</table>
</body>
</html>
