
<%@ page language="java" contentType="application/x-json;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="org.json.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />

<%
	User user = HrmUserVarify.getUser (request , response) ;
	String inprepId=null;
	String inprepName=null;
	int navigateToWfid = 0;
	int navigateToIsagent = 0;	
	String selectedworkflow="";
	String isuserdefault="";
	int fromAdvancedMenu = 0;
	String dataCenterWorkflowTypeId = Util.null2String((String)session.getAttribute("dataCenterWorkflowTypeId"));
	ArrayList NewWorkflowTypes = new ArrayList();	
	NewWorkflowTypes = (ArrayList) session.getAttribute("NewWorkflowTypes");
	selectedworkflow = Util.null2String((String)session.getAttribute("selectedworkflow"));
	isuserdefault = Util.null2String((String)session.getAttribute("isuserdefault"));
	fromAdvancedMenu = Util.getIntValue((String)session.getAttribute("fromAdvancedMenu"),0);
	ArrayList NewInputReports = new ArrayList();
	NewInputReports = (ArrayList) session.getAttribute("NewInputReports");
	ArrayList NewWorkflows = new ArrayList();
	NewWorkflows = (ArrayList) session.getAttribute("NewWorkflows");
	ArrayList AgentWorkflows = new ArrayList();
	ArrayList Agenterids = new ArrayList();
	AgentWorkflows = (ArrayList) session.getAttribute("AgentWorkflows");
	Agenterids = (ArrayList) session.getAttribute("Agenterids");
	int remainder = Util.getIntValue(request.getParameter("remainder"),0);
	String type = Util.null2String(request.getParameter("type"));
	int i = 0;

	JSONObject oJson= new JSONObject();	
	JSONArray children=new JSONArray();
	
 	while(WorkTypeComInfo.next()){	
		i++;
		if((i-1)%3 != remainder)	continue;

 		String wftypename=WorkTypeComInfo.getWorkTypename();
 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
 		if(NewWorkflowTypes.indexOf(wftypeid)==-1) continue;            
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1) continue;

 		int isfirst = 1;

		JSONObject child=new JSONObject();	
		
		child.put("draggable",false);
		child.put("leaf",false);		
		//child.put("text","流程文件夹");	
		child.put("paras","type=1,xyz=2");
		child.put("iconCls","btn_floder_main");
		child.put("expanded",true);
		
		JSONArray childrenSub=new JSONArray();
						
		if(dataCenterWorkflowTypeId.equals(wftypeid)){
			while(InputReportComInfo.next()){		
			 	inprepId = InputReportComInfo.getinprepid();
				inprepName=InputReportComInfo.getinprepname();
			 	if(NewInputReports.indexOf(inprepId)==-1) continue;		        		
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& isuserdefault.equals("1")) continue;
			 	if(selectedworkflow.indexOf("R"+inprepId+"|")==-1&& fromAdvancedMenu==1) continue;
				 	
			 	if(isfirst ==1){
			 		isfirst = 0;
					child.put("text",Util.toScreen(wftypename,user.getLanguage()));
				}		
			}

			JSONObject childSub=new JSONObject();	
			childSub.put("draggable",false);
			childSub.put("leaf",true);
			childSub.put("text","<a onclick=\"NewWindow('/datacenter/input/InputReportDate.jsp?inprepid="+inprepId+")\">"+inprepName+"</a>");
			childSub.put("paras","type=1,xyz=2");			
			childSub.put("iconCls","btn_floder_sec");	
						
			childrenSub.put(childSub);

			InputReportComInfo.setTofirstRow();
		}

		while(WorkflowComInfo.next()){

			String wfname=WorkflowComInfo.getWorkflowname();
		 	String wfid = WorkflowComInfo.getWorkflowid();
		 	String curtypeid = WorkflowComInfo.getWorkflowtype();
	        int isagent=0;
	        String agentname="";
		 	if(!curtypeid.equals(wftypeid)) continue;
		 	if(NewWorkflows.indexOf(wfid)==-1){
	            if(AgentWorkflows.indexOf(wfid)==-1){
		 		    continue;
	            }else{
	                agentname="("+ResourceComInfo.getResourcename(""+Agenterids.get(AgentWorkflows.indexOf(wfid)))+"->"+user.getUsername()+")";
	                isagent=1;
	            }
	        }
		 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
		 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& fromAdvancedMenu==1) continue;
		 	
		 	if(isfirst ==1){
		 		isfirst = 0;	
				child.put("text",Util.toScreen(wftypename,user.getLanguage()));
			}
 		 	
		 	navigateToWfid = Util.getIntValue(wfid);
		 	navigateToIsagent = isagent;
			
			JSONObject childSub=new JSONObject();	
			childSub.put("draggable",false);
			childSub.put("leaf",true);
			childSub.put("text","<a href=\"#\" onclick=\"NewRequest("+wfid+","+isagent+")\">"+wfname+"</a>"+agentname);
			childSub.put("paras","type=1,xyz=2");			
			childSub.put("iconCls","btn_floder_sec");	
						
			childrenSub.put(childSub);
			
			}
	
			child.put("children",childrenSub);	
			children.put(child);

			WorkflowComInfo.setTofirstRow();
		
	}

    out.print(children.toString());
%>
