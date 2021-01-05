
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.IsGovProj" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%  
	String type = Util.null2String(request.getParameter("type")); //type: view,表待办 handled表已办
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = "";
	
	if(type.equals("view")){
		titlename =  SystemEnv.getHtmlLabelName(1207,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	}
	if(type.equals("handled")){
		titlename =  SystemEnv.getHtmlLabelName(17991,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	}
	if(type.equals("complete")){
		titlename =  SystemEnv.getHtmlLabelName(17992,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	}
	if(type.equals("supervise")){
		titlename =  SystemEnv.getHtmlLabelName(21218,user.getLanguage()) + ": "+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	}
	if(type.equals("myrequest")){
		titlename = SystemEnv.getHtmlLabelName(1210,user.getLanguage()) +":"+SystemEnv.getHtmlLabelName(367,user.getLanguage());
	}
	String needfav ="1";
	String needhelp ="";
	
	String firstGridPara = "";
	String unfinishedPara = "";
	String finishedPara = "";
	String finishedCount = "";
	String unFinishedCount = "";
	JSONArray jsonWfTypeArray=null;
	if(type.equals("myrequest")){
		//String requestType = Util.null2String(request.getParameter("requsetType"));
		jsonWfTypeArray =(JSONArray)session.getAttribute("unfinished");
		finishedCount = (String)session.getAttribute("finishedCount");
		unFinishedCount = (String)session.getAttribute("unfinishedCount");
		jsonWfTypeArray =(JSONArray)session.getAttribute("unfinished");
		if(jsonWfTypeArray.length()>0){
			JSONObject jsonObject = jsonWfTypeArray.getJSONObject(0);
			unfinishedPara = jsonObject.getString("paras");
		}
		jsonWfTypeArray =(JSONArray)session.getAttribute("finished");
		if(jsonWfTypeArray.length()>0){
			JSONObject jsonObject = jsonWfTypeArray.getJSONObject(0);
			finishedPara = jsonObject.getString("paras");
		}
	}else{
		jsonWfTypeArray =(JSONArray)session.getAttribute(type);
		if(jsonWfTypeArray.length()>0){
			JSONObject jsonObject = jsonWfTypeArray.getJSONObject(0);
			firstGridPara = jsonObject.getString("paras");
		}
	}
	if(type.equals("view")){
		firstGridPara = "method=all&complete=0";
	}
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
	String nodetype = Util.null2String(request.getParameter("nodetype"));
	String fromdate = Util.null2String(request.getParameter("fromdate"));
	String todate = Util.null2String(request.getParameter("todate"));
	String creatertype = Util.null2String(request.getParameter("creatertype"));
	String createrid = Util.null2String(request.getParameter("createrid"));
	String requestlevel = Util.null2String(request.getParameter("requestlevel"));
	String fromdate2 = Util.null2String(request.getParameter("fromdate2"));
	String todate2 = Util.null2String(request.getParameter("todate2"));
	String workcode = Util.null2String(request.getParameter("workcode"));
	String requestname=Util.fromScreen2(request.getParameter("requestname"),user.getLanguage());
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	requestname=requestname.trim();
	
	boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
	
%>

<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>



<%
int fromAdvancedMenu = Util.getIntValue(request.getParameter("fromadvancedmenu"),0);

int perpage=10;
boolean hascreatetime =true;
boolean hascreater =true;
boolean hasworkflowname =true;
boolean hasrequestlevel =true;
boolean hasrequestname =true;
boolean hasreceivetime =true;
boolean hasstatus =true;
boolean hasreceivedpersons =true;
boolean hascurrentnode =true;
RecordSet.executeProc("workflow_RUserDefault_Select",""+user.getUID());
if(RecordSet.next()){
    if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
    if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
    if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
    if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
    if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
    if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
    if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
    if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
    if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
    perpage= RecordSet.getInt("numperpage");
}else{
    RecordSet.executeProc("workflow_RUserDefault_Select","1");
    if(RecordSet.next()){
        if(!Util.null2String(RecordSet.getString("hascreatetime")).equals("1")) hascreatetime=false;
        if(!Util.null2String(RecordSet.getString("hascreater")).equals("1")) hascreater=false;
        if(!Util.null2String(RecordSet.getString("hasworkflowname")).equals("1")) hasworkflowname=false;
        if(!Util.null2String(RecordSet.getString("hasrequestlevel")).equals("1")) hasrequestlevel=false;
        if(!Util.null2String(RecordSet.getString("hasrequestname")).equals("1")) hasrequestname=false;
        if(!Util.null2String(RecordSet.getString("hasreceivetime")).equals("1")) hasreceivetime=false;
        if(!Util.null2String(RecordSet.getString("hasstatus")).equals("1")) hasstatus=false;
        if(!Util.null2String(RecordSet.getString("hasreceivedpersons")).equals("1")) hasreceivedpersons=false;
        if(!Util.null2String(RecordSet.getString("hascurrentnode")).equals("1")) hascurrentnode=false;
        perpage= RecordSet.getInt("numperpage");
    }
}
//boolean hasSubWorkflow =false;

/****
if(workflowid!=null&&!workflowid.equals("")&&workflowid.indexOf(",")==-1){
	RecordSet.executeSql("select id from Workflow_SubWfSet where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}

	RecordSet.executeSql("select id from Workflow_TriDiffWfDiffField where mainWorkflowId="+workflowid);
	if(RecordSet.next()){
		hasSubWorkflow=true;
	}
}

******/
int iswaitdo= Util.getIntValue(request.getParameter("iswaitdo"),0) ;
int isovertime= Util.getIntValue(request.getParameter("isovertime"),0) ;


String colsTableBaseParas = "";
if(hascreatetime)
	//colsTableBaseParas+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"t1.createdate,t1.createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
	colsTableBaseParas+="{'para_1':'column:createdate','para_2':'column:createtime','para_3':'','hideable':true,'sortable':true,'width':0.1,'dataIndex':'createdate','header':'"+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'createdate','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime','href':''},";
if(hascreater)
	//colsTableBaseParas+="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"t1.creater\"  otherpara=\"column:creatertype\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" />";
	colsTableBaseParas+="{'para_1':'column:creater','para_2':'column:creatertype','para_3':'','hideable':true,'sortable':true,'width':0.06,'dataIndex':'creater','header':'"+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'creater','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultName','href':''},";
if(hasworkflowname)
	//colsTableBaseParas+="				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"t1.workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />";
	colsTableBaseParas+="{'para_1':'column:workflowid','para_2':'','para_3':'','hideable':true,'sortable':true,'width':0.1,'dataIndex':'t1$&$workflowid','header':'"+SystemEnv.getHtmlLabelName(259,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'workflowid','target':'','transmethod':'weaver.workflow.workflow.WorkflowComInfo.getWorkflowname','href':''},";
if(hasrequestlevel)
	//colsTableBaseParas+="				<col width=\"8%\"   text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"requestlevel\"  orderkey=\"t1.requestlevel\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree\" otherpara=\""+user.getLanguage()+"\"/>";
	colsTableBaseParas+="{'para_1':'column:requestlevel','para_2':'"+user.getLanguage()+"','para_3':'','hideable':true,'sortable':true,'width':0.08,'dataIndex':'requestlevel','header':'"+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'requestlevel','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultUrgencyDegree','href':''},";
String para3=user.getLanguage()+"+"+user.getUID();
if(hasrequestname){
	//colsTableBaseParas+="				<col width=\"19%\"  text=\""+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"\" column=\"requestname\" orderkey=\"t1.requestname\"  linkkey=\"requestid\" linkvaluecolumn=\"requestid\" target=\"_fullwindow\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\"  otherpara=\""+para2+"\"/>";
	
	if(!type.equals("supervise")){
		String para2="column:requestid+column:workflowid+column:viewtype+"+isovertime+"+"+user.getLanguage()+"+column:nodeid+column:isremark+"+String.valueOf(user.getUID());
		String paraAgent="column:requestid+column:agentorbyagentid+column:agenttype";
		colsTableBaseParas+="{'para_1':'column:requestname','para_2':'"+para2+"','para_3':'','hideable':true,'sortable':true,'width':0.14,'dataIndex':'requestname','header':'"+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"','linkkey':'requestid','linkvaluecolumn':'requestid','column':'requestname','target':'requestid','transmethod':'weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitleExt','href':''},";
		colsTableBaseParas+="{'para_1':'column:viewtype','para_2':'"+paraAgent+"','para_3':'','hideable':true,'sortable':true,'width':0.06,'resizable':false,'dataIndex':'viewtype','header':'"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'viewtype','target':'requestid','transmethod':'weaver.general.WorkFlowTransMethod.getWfViewTypeExtIncludeAgent','href':''},";
	}else{
		int logintype = Util.getIntValue(user.getLogintype(),1);
	 	String para2 = "column:requestid+column:workflowid+"+user.getUID()+"+"+(logintype-1)+"+"+ user.getLanguage();
		colsTableBaseParas+="{'para_1':'column:requestname','para_2':'"+para2+"','para_3':'','hideable':true,'sortable':true,'width':0.14,'dataIndex':'requestname','header':'"+SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"','linkkey':'requestid','linkvaluecolumn':'requestid','column':'requestname','target':'requestid','transmethod':'weaver.general.WorkFlowTransMethod.getWfNewLinkByUrgerExt','href':''},";
		colsTableBaseParas+="{'para_1':'column:requestid','para_2':'"+user.getUID()+"','para_3':'','hideable':true,'sortable':false,'width':0.06,'resizable':false,'dataIndex':'viewtype','header':'"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'viewtype','target':'requestid','transmethod':'weaver.general.WorkFlowTransMethod.getWfNewLinkImageExt','href':''},";

	}
}
if(hascurrentnode)
	//colsTableBaseParas+="				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"\" column=\"currentnodeid\" transmethod=\"weaver.general.WorkFlowTransMethod.getCurrentNode\"/>";
	colsTableBaseParas+="{'para_1':'column:currentnodeid','para_2':'','para_3':'','hideable':true,'sortable':true,'width':0.08,'dataIndex':'currentnodeid','header':'"+SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'currentnodeid','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getCurrentNode','href':''},";
if(hasreceivetime)
	//colsTableBaseParas+="			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"\" column=\"receivedate\" orderkey=\"t2.receivedate,t2.receivetime\" otherpara=\"column:receivetime\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime\" />";
	colsTableBaseParas+="{'para_1':'column:receivedate','para_2':'column:receivetime','para_3':'','hideable':true,'sortable':true,'width':0.1,'dataIndex':'receivedate','header':'"+SystemEnv.getHtmlLabelName(17994,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'receivedate','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultCreateTime','href':''},";
if(hasstatus)
	//colsTableBaseParas+="			    <col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"\" column=\"status\" orderkey=\"t1.status\" />";
	colsTableBaseParas+="{'para_1':'','para_2':'','para_3':'','hideable':true,'sortable':true,'width':0.08,'dataIndex':'status','header':'"+SystemEnv.getHtmlLabelName(1335,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'status','target':'','transmethod':'','href':''},";
if(hasreceivedpersons)
	//colsTableBaseParas+="			    <col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"\" column=\"requestid\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.WorkFlowTransMethod.getUnOperators\"/>";
	colsTableBaseParas+="{'para_1':'column:requestid','para_2':'"+para3+"','para_3':'','hideable':true,'sortable':true,'width':0.15,'dataIndex':'t1$&$requestid','header':'"+SystemEnv.getHtmlLabelName(16354,user.getLanguage())+"','linkkey':'','linkvaluecolumn':'','column':'requestid','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getUnOperatorsExt','href':''},";
//colsTableBaseParas+="{'para_1':'column:workflowid','para_2':'','para_3':'','hideable':true,'sortable':false,'width':0.01,'dataIndex':'multiSubmit','header':'','linkkey':'','linkvaluecolumn':'','column':'multiSubmit','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getWFSearchResultCheckBox','href':''},";
if(colsTableBaseParas.length()>0){
	colsTableBaseParas = colsTableBaseParas.substring(0,colsTableBaseParas.length()-1);
}


String multiSubmit="{'para_1':'column:workflowid','para_2':'column:isremark','para_3':'column:requestid','hideable':true,'sortable':false,'width':0.01,'dataIndex':'multiSubmit','header':'','linkkey':'','linkvaluecolumn':'','column':'multiSubmit','target':'','transmethod':'weaver.general.WorkFlowTransMethod.getCanMultiSubmitExt','href':''}";


String allColumns =  colsTableBaseParas+","+multiSubmit;
allColumns = "["+allColumns+"]";
colsTableBaseParas = "["+colsTableBaseParas+"]";

%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
        <link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" /> 
    </head>
    <style>
    </style>
    <body>
    
    <form name=frmmain method=post action="RequestView.jsp">
    <div>
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
    /* edited by wdl 2006-06-14 left menu advanced menu */
        if(fromAdvancedMenu!=1 && !type.equals("supervise")&& false){
        	
	    	RCMenuWidth = 120;
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(16347,user.getLanguage())+",javascript:toBeDealed(),_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;

			RCMenu += "{"+SystemEnv.getHtmlLabelName(20271,user.getLanguage())+",javascript:dealed(),_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;
			
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(16348,user.getLanguage())+",javascript:finished(),_self}" ;
	        RCMenuHeight += RCMenuHeightStep ;
        }
   	if(type.equals("view")){
   		RCMenu += "{<span id='displayWfType'>"+SystemEnv.getHtmlLabelName(89,user.getLanguage())+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"</span>,javascript:mainPanel.displayOrHideWfType(),_self}" ;
   	    RCMenuHeight += RCMenuHeightStep ;
   	 	RCMenu += "{<span id='submitRightMenu'>"+SystemEnv.getHtmlLabelName(17598,user.getLanguage())+"</span>,javascript:mainPanel.getMultiSubmit(),_self}" ;
	    RCMenuHeight += RCMenuHeightStep ;
   	}else{
   		RCMenu += "{<span id='displayWfType'>"+SystemEnv.getHtmlLabelName(16636,user.getLanguage())+SystemEnv.getHtmlLabelName(16579,user.getLanguage())+"</span>,javascript:mainPanel.displayOrHideWfType(),_self}" ;
   	    RCMenuHeight += RCMenuHeightStep ;
   	}
   	RCMenu += "{<span id='openwf'>"+SystemEnv.getHtmlLabelName(21986,user.getLanguage())+"</span>,javascript:mainPanel.openSelecteds(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:search(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:firstPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:prePage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript: nextPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:lastPage(),_self}" ;
    RCMenuHeight += RCMenuHeightStep ;
	
    /* edited end */    
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    </div>
  </form>
    
   <FORM id=weaver1 name=frmmain1 method=post action="/workflow/request/RequestListOperation.jsp">
	<input type=hidden name=multiSubIds value="">
   </form>
   
     <div id="divSearch" style="display:none">
   <form id=wfSearch method=post action="/workflow/search/WFSearchTemp.jsp">
      
            <TABLE class=ViewForm  valign="top">
                    <TR valign="top">		
						<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
                         <TD CLASS="Field">
                         
							<input type=text value="<%=requestname%>" name="requestname" style="width:60%"> 
							<SPAN id=remind style='cursor:hand'>
								<IMG src='/images/remind_wev8.png' align=absMiddle>
							</SPAN>
                         </TD>
				
                        <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></TD>
                         <TD CLASS="Field">
                            
						  <select class=inputstyle  name=creatertype>
					<%if(!user.getLogintype().equals("2")){%>
						<%if(isgoveproj==0){%>
						  <option value="0" <%if (creatertype.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
						 <%}else{%>
						 <option value="0"><%=SystemEnv.getHtmlLabelName(20098,user.getLanguage())%></option>
						 <%}%>
					<%}%>
						<%if(isgoveproj==0){%>
						  <option value="1" <%if (creatertype.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
						  <%}%>
						  </select>
						  &nbsp
						  <button type='button' class=browser onClick="onShowResource()"></button>
						<span id=resourcespan>
						<%=ResourceComInfo.getResourcename(createrid)%>
						</span>
						<input name=createrid type=hidden value="<%=createrid%>">
	                         </TD>
					</TR>
					<TR><td colspan=4 class="line"></td></TR>
  					<TR valign="top">	
                         <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></TD>
                         <TD  WIDTH="20%" CLASS="Field">
                         <select class=inputstyle  name=requestlevel style=width:60% size=1>
						    <option value=""> </option>
							  <option value="0" <% if(requestlevel.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
							  <option value="1" <% if(requestlevel.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
							  <option value="2" <% if(requestlevel.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
							</select>
						           
                         </TD>
                         <TD WIDTH="10%"><%=SystemEnv.getHtmlLabelName(17994,user.getLanguage())%></TD>
                         <TD width ="20%" CLASS="Field"> 
                            <BUTTON type='button' class=calendar id=SelectDate3  onclick="gettheDate(fromdate2,fromdatespan2)"></BUTTON>
						      <SPAN id=fromdatespan2 ><%=fromdate2%></SPAN>
						      -&nbsp;&nbsp;<BUTTON type='button' class=calendar id=SelectDate4 onclick="gettheDate(todate2,todatespan2)"></BUTTON>
						      <SPAN id=todatespan2 ><%=todate2%></SPAN>
							  <input type="hidden" name="fromdate2" value="<%=fromdate2%>"><input type="hidden" name="todate2" value="<%=todate2%>">
                         </TD>
                    </TR>
					
                    
                </TABLE>             
                
                </form>
                </div>
                
                
                <div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
				</div>
				
				
            </body>
            </html>
            <%@ include file="/docs/docs/DocCommExt.jsp"%>
			<script type="text/javascript">
				
				var basePara = '';
			    var type='<%=type%>';
			    var firstGridPara='<%=firstGridPara%>';
			    var alltobedealed = '<%=SystemEnv.getHtmlLabelName(16347,user.getLanguage())%>';
			    var alldealed = '<%=SystemEnv.getHtmlLabelName(20271,user.getLanguage())%>';
			    var allfinished = '<%=SystemEnv.getHtmlLabelName(16348,user.getLanguage())%>';
			    var imagefilename = '<%=imagefilename%>';
			    var titlename = '<%=titlename%>'
			    var unfinishedPara = '<%=unfinishedPara%>'
				var finishedPara = '<%=finishedPara%>'
	    		var colsTableBaseParas = <%=colsTableBaseParas%>;
	    		var isFirst =true;
			    var TableBaseParas={
			    				"multiSubmit":false,
			    				"gridId":'<%=type%>',
								"sqlwhere":"",
								"sort":"receivedate,receivetime",
								"operates":[],
								"excerpt":"",
								"sqlisprintsql":"",
								"backfields":"",
								"columns":colsTableBaseParas,
								"pageSize":<%=perpage%>,					
								"poolname":"","sqlgroupby":"",
								"dir":"desc",
								"sqlisdistinct":"",
								"sqlprimarykey":"",
								"sqlform":"",
								"popedom":{"otherpara":"","otherpara2":"","transmethod":""}
				};
				var multiSubmit = <%=multiSubmit%>;
				var allColumns = <%=allColumns%>;
				 
			    var finishedCount = '<%=finishedCount%>';
				var unFinishedCount = '<%=unFinishedCount%>';
			    
			    var gridUrl=' /weaver/weaver.common.util.taglib.SplitPageXmlServletNew';			   
			    var treeUrl='/workflow/request/ext/TreeJsonGet.jsp?type='+type;
			    	
				var showTableDiv  = document.getElementById('divshowreceivied');
				var oIframe = document.createElement('iframe');
				function showreceiviedPopup(content){
				    showTableDiv.style.display='';
				    var message_Div = document.createElement("<div>");
				     message_Div.id="message_Div";
				     message_Div.className="xTable_message";
				     showTableDiv.appendChild(message_Div);
				     var message_Div1  = document.getElementById("message_Div");
				     message_Div1.style.display="inline";
				     message_Div1.innerHTML=content;
				     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
				     var pLeft= document.body.offsetWidth/2-50;
				     message_Div1.style.position="absolute"
				     message_Div1.style.posTop=pTop;
				     message_Div1.style.posLeft=pLeft;
				
				     message_Div1.style.zIndex=1002;
				
				     oIframe.id = 'HelpFrame';
				     showTableDiv.appendChild(oIframe);
				     oIframe.frameborder = 0;
				     oIframe.style.position = 'absolute';
				     oIframe.style.top = pTop;
				     oIframe.style.left = pLeft;
				     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
				     oIframe.style.width = parseInt(message_Div1.offsetWidth);
				     oIframe.style.height = parseInt(message_Div1.offsetHeight);
				     oIframe.style.display = 'block';
				}    		
				
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
				function showallreceived(requestid,returntdid,obj){
				    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
				    var ajax=ajaxinit();
					
				    ajax.open("POST", "/workflow/search/WorkflowUnoperatorPersons.jsp", true);
				    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
				    ajax.send("requestid="+requestid+"&returntdid="+returntdid);
				    //获取执行状态
				    //alert(ajax.readyState);
					//alert(ajax.status);
				    ajax.onreadystatechange = function() {
				        //如果执行状态成功，那么就把返回信息写到指定的层里
				        if (ajax.readyState==4&&ajax.status == 200) {
				            try{
					            obj.parentNode.innerHTML =jQuery.trim(ajax.responseText);
					            obj.parentNode.title = jQuery.trim(ajax.responseText);
				            }catch(e){}
				            showTableDiv.style.display='none';
				            oIframe.style.display='none';
				        } 
				    } 
				}
				function toBeDealed(){
					
					loadGrid('method=all&complete=0');
					
				}
				function dealed(){
					
					loadGrid('method=all&complete=2');
					
				}
				function finished(){
					
					loadGrid('method=all&complete=1');
					
				}
			
				function URLencode(sStr) 
				{
				    return myescapecode(sStr);
				}
				
						
			</script>
            
			
			<script type="text/javascript" src="/js/TabCloseMenu_wev8.js"></script>
			
			<%@ include file="/systeminfo/TopTitleExt.jsp"%>
			
			
			<script  language="javascript">	
				var isfromtab = '<%=isfromtab%>';
				_isViewPort=true;
				_pageId="ExtRequest";  
				//_divSearchDiv='divSearch'; 
				//_defaultSearchStatus='close';  //close //show //more			
				//_divSearchDivHeight=115;	
				function onBtnSearchClick(){  //确认搜索提交按钮
					
					var wfSearchForm = document.getElementById('wfSearch');
					var searchPara ='';
					for(i=0;i<wfSearchForm.elements.length;i++)
					{
						if(wfSearchForm.elements[i].name!= ''){
							
							if(wfSearchForm.elements[i].value!=''){
								if(wfSearchForm.elements[i].name=='requestname'){
									searchPara+='&'+wfSearchForm.elements[i].name+'='+URLencode(wfSearchForm.elements[i].value);
								}else{
									searchPara+='&'+wfSearchForm.elements[i].name+'='+wfSearchForm.elements[i].value;
								}
							}
						}
					}
													
					
					
					if(searchPara!='' && searchPara!='&creatertype=0')
					{
						searchPara+='&fromself=1&isfirst=1$isovertime=0';
						loadGrid(basePara+searchPara,false);	
						
					}else{
						loadGrid(basePara,false);
					}
				}	
				
				function search(){
					var divSearch = document.getElementById('divSearch');
					if(divSearch.style.display=='none'){
						mainPanel.onSearch();
						return;
					}else{
						onBtnSearchClick();
					}
				}
				
			
			 new Ext.ToolTip({
		        target: 'remind',
		        title: wmsg.wf.searchRemind,
		        width:350,
		        html: wmsg.wf.searchRemindMsg,
		        trackMouse:false,
		        autoHide: true,
		        closable: false,
		        dismissDelay: 20000
		    });
				
			</script>
			
			<script language=vbs>
			sub onShowResource()
			tmpval = document.all("creatertype").value
			if tmpval = "0" then
			id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
			else
			id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
			end if
			if NOT isempty(id) then
	        if id(0)<> "" then
				resourcespan.innerHtml = id(1)
				wfSearch.createrid.value=id(0)
				else
				resourcespan.innerHtml = ""
				wfSearch.createrid.value=""
				end if
			end if

			end sub
			</script>	
			<script type='text/javascript' src='/js/WeaverTablePlugins_wev8.js'></script>
			<script type="text/javascript" src="/js/wflist_wev8.js"></script>
			<script language=vbs src="/js/browser/WorkFlowBrowser.vbs"></script>
			<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
			<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>