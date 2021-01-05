
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/datacenter/maintenance/inputreport/InputReportHrmInclude.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.TestWorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/js/jquery/jquery_dialog_wev8.js"></script>
  <style>
           .listbox2 ul {
	            margin: 0 0 0 0;
	            padding: 0px;
	            list-style: none;
            }

            .listbox2 {
	            width:99%;
				margin-bottom: 32px;
				margin-right:0px;
             }

            .listbox2 .titleitem{
				height: 26px;
	            line-height: 26px;
	            font-weight: bold;
				border-bottom: 2px solid #e4e4e4;
			}
         
		    .listbox2 ul li a{
			    color: black;
			 	margin-left:8px;
				margin-right:12px;
		    }

          	.listbox2 ul li {
	            height: 30px;
	            line-height: 30px;
				border-bottom:1px dashed #f0f0f0;
			 	padding-left: 0px;
            }
          

			.titlecontent{
				float:left;
				color:#232323;
			}
			.commian{
				float:left;
				color:#232323;
				border-bottom:2px solid #9e17b6;
			}

		    .middlehelper {
					display: inline-block;
					height: 100%;
					vertical-align: middle;
				}

			.chosen{
			   background:#3399ff;
			   color:white;
			   cursor:pointer;
			}

			.agentitem a:hover{
			color:#ffffff !important;
			}

           .menuitem{

		    margin-bottom:5px;
		   
		   }
		
		</style>
		<link href="/css/ecology8/request/requestTypeShow_wev8.css" type="text/css" rel="STYLESHEET">
</head>
<%
if (!HrmUserVarify.checkUserRight("Delete:TestRequest", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

//问题1
twc.reLoginMrg(request, response, null);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(365,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(648,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
//String seclevel = "";
if(logintype.equals("2")){
	usertype = 1;
	//seclevel = ResourceComInfo.getSeclevel(""+user.getUID());
}
//else if (logintype.equals("1")){
//	seclevel = user.getSeclevel();
//}
//if(seclevel.equals("")){
//	seclevel="0";
//}
String seclevel = user.getSeclevel();

String selectedworkflow="";
String isuserdefault="";

/* edited by wdl 2006-05-24 left menu new requirement ?fromadvancedmenu=1&infoId=-140 */
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);
String selectedContent = Util.null2String(request.getParameter("selectedContent"));
int infoId = Util.getIntValue(request.getParameter("infoId"),0);
String needPopupNewPage = Util.null2String(request.getParameter("needPopupNewPage"));//是否需要弹出新页面  true:需要   false或其它：不需要

if(fromAdvancedMenu==1){
	needPopupNewPage="true";
}

boolean navigateTo = false;
int navigateToWfid = 0;
int navigateToIsagent = 0;
int navigateToAgenter = 0;
if(fromAdvancedMenu==1){//目录选择来自高级菜单设置
	LeftMenuInfoHandler infoHandler = new LeftMenuInfoHandler();
	LeftMenuInfo info = infoHandler.getLeftMenuInfo(infoId);
	if(info!=null){
		selectedworkflow = info.getSelectedContent();

		List workflowNum = Util.TokenizerString(selectedworkflow,"|");
		int tnum = 0;
		for(Iterator it = workflowNum.iterator();it.hasNext();){
			if(((String)it.next()).startsWith("W")) tnum++;
		}
		if(tnum==1) navigateTo = true;
	}
} else {
	//ArrayList selectArr=new ArrayList();
//	RecordSet.executeProc("workflow_RUserDefault_Select",""+userid);
//	if(RecordSet.next()){
//	    selectedworkflow=RecordSet.getString("selectedworkflow");
//	    isuserdefault=RecordSet.getString("isuserdefault");
//	}
}

/* edited end */
if(!"".equals(selectedContent))
{
	selectedworkflow = selectedContent;
}
if(!selectedworkflow.equals(""))    selectedworkflow+="|";
String needall=Util.null2String(request.getParameter("needall"));
if(needall.equals("1")) {
	isuserdefault="0";
	fromAdvancedMenu=0;
}

%>
<body style="overflow:auto;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33662,user.getLanguage())%>"/>
</jsp:include>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="subform" name="subform" method="get" action="RequestTypeByTest.jsp">
<%

ArrayList NewWorkflowTypes = new ArrayList();
//获取可创建流程查询sql条件
// String wfcrtSqlWhere = shareManager.getWfShareSqlWhere(user, "t1");

String sql = "select distinct base.workflowtype,ty.dsporder,ty.typename from workflow_base base"
	+" left join workflow_type ty on base.workflowtype=ty.id"
	+" where base.isvalid = '2' and"
	+" exists(select * from workflow_flownode node where node.workflowid = base.id and node.nodetype=0)"
	+" order by ty.dsporder asc, ty.typename asc";

RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflowTypes.add(RecordSet.getString("workflowtype"));
}

//所有可创建流程集合
ArrayList NewWorkflows = new ArrayList();

sql ="select base.id workflowid from workflow_base base"
	+" where base.isvalid = '2' and"
	+" exists(select * from workflow_flownode node where node.workflowid = base.id and node.nodetype=0)"
	+" order by base.dsporder asc,base.workflowname asc";
RecordSet.executeSql(sql);
while(RecordSet.next()){
	NewWorkflows.add(RecordSet.getString("workflowid"));
}

/*modify by mackjoe at 2005-09-14 增加流程代理创建权限*/
ArrayList AgentWorkflows = new ArrayList();
ArrayList Agenterids = new ArrayList();
//TD13554
if (usertype == 0) {
	//获得当前的日期和时间
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
	                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
	                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
	                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
	                     Util.add0(today.get(Calendar.SECOND), 2) ;
	String begindate="";
	String begintime="";
	String enddate="";
	String endtime="";
	int agentworkflowtype=0;
	int agentworkflow=0;
	int beagenterid=0;
	sql = "select distinct t1.workflowtype,t.workflowid,t.bagentuid,t.begindate,t.begintime,t.enddate,t.endtime from workflow_agentConditionSet t,workflow_base t1 where t.workflowid=t1.id and t.agenttype>'0' and t.iscreateagenter=1 and t.agentuid="+userid+" order by t1.workflowtype,t.workflowid";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){
	    boolean isvald=false;
	    begindate=Util.null2String(RecordSet.getString("begindate"));
	    begintime=Util.null2String(RecordSet.getString("begintime"));
	    enddate=Util.null2String(RecordSet.getString("enddate"));
	    endtime=Util.null2String(RecordSet.getString("endtime"));
	    agentworkflowtype=Util.getIntValue(RecordSet.getString("workflowtype"),0);
	    agentworkflow=Util.getIntValue(RecordSet.getString("workflowid"),0);
	    beagenterid=Util.getIntValue(RecordSet.getString("bagentuid"),0);
	    if(!begindate.equals("")){
	        if((begindate+" "+begintime).compareTo(currentdate+" "+currenttime)>0)
	            continue;
	    }
	    if(!enddate.equals("")){
	        if((enddate+" "+endtime).compareTo(currentdate+" "+currenttime)<0)
	            continue;
	    }
	    
	    boolean haswfcreateperm = shareManager.hasWfCreatePermission(beagenterid, agentworkflow);
		if(haswfcreateperm){
	        if(NewWorkflowTypes.indexOf(agentworkflowtype+"")==-1){
	            NewWorkflowTypes.add(agentworkflowtype+"");
	        }
	        int indx=AgentWorkflows.indexOf(""+agentworkflow);
	        if(indx==-1){
	            AgentWorkflows.add(""+agentworkflow);
	            Agenterids.add(""+beagenterid);
	        }else{
	            String tempagenter=(String)Agenterids.get(indx);
	            tempagenter+=","+beagenterid;
	            Agenterids.set(indx,tempagenter);
	        }
	    }
	}
	//end
}

List inputReportFormIdList=new ArrayList();
String tempWorkflowId=null;
String tempFormId=null;
String tempIsBill=null;
for(int i=0;i<NewWorkflows.size();i++){
	tempWorkflowId=(String)NewWorkflows.get(i);
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

for(int i=0;i<AgentWorkflows.size();i++){
	tempWorkflowId=(String)AgentWorkflows.get(i);
	tempFormId=WorkflowComInfo.getFormId(tempWorkflowId);
	tempIsBill=WorkflowComInfo.getIsBill(tempWorkflowId);
	if(Util.getIntValue(tempFormId,0)<0){
		inputReportFormIdList.add(tempFormId);
	}
}

this.rs=RecordSet;

int wftypetotal=NewWorkflowTypes.size();
int wftotal=WorkflowComInfo.getWorkflowNum();
int rownum=(wftypetotal+2)/3;
%>

<%
 	int i=0;
 	int needtd=rownum;
 	int tdNum=0;
 	int colorindex = 0;
 	String[][] color={{"#166ca5","#953735","#01b0f1"},{"#767719","#f99d52","#cf39a4"}};
 	while(WorkTypeComInfo.next()){
 		String wftypename=WorkTypeComInfo.getWorkTypename();
 		String wftypeid = WorkTypeComInfo.getWorkTypeid();
 		if(NewWorkflowTypes.indexOf(wftypeid)==-1)
	 	    continue;
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1&& isuserdefault.equals("1")) continue;
	 	if(selectedworkflow.indexOf("T"+wftypeid+"|")==-1 && fromAdvancedMenu==1) continue;
 		needtd--;
 	%>
 		<div class="listbox2" style="width:30%;float:left;padding: 10px;">
 			<div class='titleitem'>
				<div class="titlecontent main<%=colorindex%>" style="border-bottom:2px solid <%=color[colorindex%2][tdNum]%>;">
					<label><%=Util.toScreen(wftypename,user.getLanguage())%></label>
				</div>
			</div>
			<div class='mainItem'>
			 	<%
			 	int isfirst = 1;
				while(WorkflowComInfo.next()){
					String wfname=WorkflowComInfo.getWorkflowname();
				 	String wfid = WorkflowComInfo.getWorkflowid();
				 	String curtypeid = WorkflowComInfo.getWorkflowtype();
			        int isagent=0;
			        int beagenter=0;
			        String agentname="";
			        ArrayList agenterlist=new ArrayList();
			        //String isvalid=WorkflowComInfo.getIsValid();
				 	if(!curtypeid.equals(wftypeid)) continue;

				 	//check right
				 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& isuserdefault.equals("1")) continue;
				 	if(selectedworkflow.indexOf("W"+wfid+"|")==-1&& fromAdvancedMenu==1) continue;

			        if(NewWorkflows.indexOf(wfid)==-1){
			            if(AgentWorkflows.indexOf(wfid)==-1){
				 		    continue;
			            }else{
			                agenterlist=Util.TokenizerString((String)Agenterids.get(AgentWorkflows.indexOf(wfid)),",");
			                isagent=1;
			                for(int k=0;k<agenterlist.size();k++){
			                    beagenter=Util.getIntValue((String)agenterlist.get(k),0);
			                    agentname="("+ResourceComInfo.getResourcename((String)agenterlist.get(k))+"->"+user.getUsername()+")";
			                    %>
		                      	<div class='centerItem'>
				                   	<div class='fontItem' style="width:320px;white-space: nowrap;text-overflow: ellipsis;overflow:hidden;">
				              			<img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png" style="vertical-align: middle;">

										<a href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);" title="<%=Util.toScreen(wfname,user.getLanguage())%>">
				                        <%=Util.toScreen(wfname,user.getLanguage())%></a><%=agentname%>
									</div>
								</div>

			                    <%
			                }
			            }
			        }else{
					%>
						<div class='centerItem'>
							<div class='fontItem' style="width:320px;white-space: nowrap;text-overflow: ellipsis;overflow:hidden;">
					  			<img name='esymbol' src="\images\ecology8\request\workflowTitle_wev8.png" style="vertical-align: middle;">

								<a href="javascript:onNewRequest(<%=wfid%>,<%=isagent%>,<%=beagenter%>);" title="<%=Util.toScreen(wfname,user.getLanguage())%>">
					            <%=Util.toScreen(wfname,user.getLanguage())%></a><%=agentname%>
							</div>
						</div>
						
					<%
				    }
				   
			        navigateToWfid = Util.getIntValue(wfid);
				 	navigateToIsagent = isagent;
			        navigateToAgenter = beagenter;
				}
				%>
			</div>
		</div>
		<%
			colorindex++;
			WorkflowComInfo.setTofirstRow();
		}
		%>

</form>
</body>
<script language="javascript">

	function onNewRequest(workflowid,agent,beagenter){
		
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/request/ChooseCreator.jsp?workflowid=" + workflowid;
		
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(84516,user.getLanguage())%>";
		dialog.Width = 650;
		dialog.Height = 420;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.callbackfun = function(param, result){
			if( !result ) return;

			var creatertype = result.creatertype;
			var createrid = result.createrid;

			if(!creatertype || !createrid) return;

			var redirectUrl = "/workflow/request/AddRequestMiddleHandler.jsp"
					+ "?workflowid=" + workflowid
					+ "&createrid=" + createrid
					+ "&creatertype=" + creatertype
					+ "&agent=" + agent
					+ "&beagenter=" + beagenter;

			var width = parent.document.body.clientWidth ;
			var height = parent.document.body.clientHeight ;
			JqueryDialog.Open1("<%=SystemEnv.getHtmlLabelName(25497,user.getLanguage())%>",
								redirectUrl,width,height,false,false,false);
		};

		dialog.show();
	}

	jQuery(document).ready(function($) {
		 jQuery(".centerItem").mouseover(function (){
			jQuery(this).css("background-color","#fbfbfb");
			//代理流程div
			var agent=jQuery(this).find(".agentlistdata").css("display");
			var imports=jQuery(this).find(".importwf").css("display");
			jQuery(".agentlistdata").css("display","none");
			jQuery(this).find(".agentlistdata").css("display",agent);
			
			jQuery(".importwf").css("display","none");
			jQuery(this).find(".importwf").css("display",imports);

			jQuery(".autocomplete-suggestions").css("display","none");

			jQuery(".imageItem").css("display","none");
			jQuery(".imgdiv").removeClass("imgdiv");
			
			if(agent!="none"&&jQuery(this).find(".agentlistdata").length>0){
				jQuery(this).find(".agent").addClass("imgdiv");
			}else{
				jQuery(this).find(".agent img").attr("src","/images/ecology8/agentwf_wev8.png");
			}
			if(imports!="none"&&jQuery(this).find(".importwf").length>0){
				jQuery(this).find(".import").addClass("imgdiv");
				if(jQuery(this).find(".importwf").find(".labelText").length>0){
				  jQuery(this).find(".importwf").css("height",76);
				}else{
				  jQuery(this).find(".importwf").css("height",(56+jQuery(".autocomplete-suggestions").height()));
				}
				jQuery(".autocomplete-suggestions").css("display","block");
			}else
                jQuery(this).find(".import img").attr("src","/images/ecology8/importwf_wev8.png");


			jQuery(this).find(".imageItem").css("display","block");
		 });
				
		 jQuery(".centerItem").mouseleave(function (){
			jQuery(this).css("background-color","#ffffff");
			if(jQuery(this).find(".agentlistdata").length>0){
				//代理流程div
				var agent=jQuery(this).find(".agentlistdata").css("display");
				if(agent=="none"){
					jQuery(this).find(".imageItem").css("display","none");
				}
			}else if(jQuery(this).find(".importwf").length>0){
				//导入流程div
				var imports=jQuery(this).find(".importwf").css("display");
				if(imports=="none"){
					jQuery(this).find(".imageItem").css("display","none");
					jQuery(".autocomplete-suggestions").css("display","none");
				}
			}else{
				jQuery(this).find(".imageItem").css("display","none");
				//更改背景色

				jQuery(".imgdiv").removeClass("imgdiv");
				
			}	
		 });
	});

</script>

</html>


