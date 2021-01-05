
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="workflowActionManager" class="weaver.workflow.action.WorkflowActionManager" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="ActionXML" class="weaver.servicefiles.ActionXML" scope="page" />
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String operate = Util.null2String(request.getParameter("operate"));
	//<!--QC  281277  [80][90]流程流转集成-建议新建/编辑流程接口部署页面中加上关闭按钮，以保持统一-->
	String isdialog = Util.null2String(request.getParameter("isdialog"));
	String triggermothod = Util.null2String(request.getParameter("triggermothod"));
	if("".equals(triggermothod))
		triggermothod = "1";
	
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	//是否节点后附加操作
	int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
	
	String workFlowName = "";
	int isbill = 0;
	int formid = 0;
	if(Util.getIntValue(workflowid)>-1){
		workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname("" + workflowid));
		isbill = Util.getIntValue(WorkflowComInfo.getIsBill("" + workflowid), 0);
		formid = Util.getIntValue(WorkflowComInfo.getFormId("" + workflowid), 0);
	}
	String nodename = "";
	if(nodeid>0){
		RecordSet.executeSql("select nodename from workflow_nodebase b where b.id = "+nodeid);
		if(RecordSet.next()){
			nodename = RecordSet.getString("nodename");
		}
	}
	String linkname = "";
	if(nodelinkid>0){
		RecordSet.executeSql("select linkname from workflow_nodelink n where n.id = "+nodelinkid);
		if(RecordSet.next()){
			linkname = RecordSet.getString("linkname");
		}
	}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<STYLE TYPE="text/css">
		table.viewform td.line
		{
			height:1px!important;
		}
		table.ListStyle td.line1
		{
			height:1px!important;
		}
		table.ListStyle tr.Line th
		{
			height:1px!important;
		}
		table ul#tabs
		{
			width:85%!important;
		}
		</STYLE>
		<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
		<%@ taglib uri="/browserTag" prefix="brow"%>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		
		<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(23662, user.getLanguage())+"(WebService)"; //配置接口动作(数据库DML)23662
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
	<!--QC  281277  [80][90]流程流转集成-建议新建/编辑流程接口部署页面中加上关闭按钮，以保持统一   start -->
	<%if("1".equals(isdialog)){ %>
	<div class="zDialog_div_content">
	<script language=javascript >
	var parentWin = parent.parent.getParentWindow(parent);
	</script>
	<%} %>
	<!--end-->
	
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			if(!"addws".equals(operate)){
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			}
			//if("1".equals(fromintegration))
			//{
			//	RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/integration/dmllist.jsp,_self} ";
			//	RCMenuHeight += RCMenuHeightStep;
			//}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
					<% if(!"addws".equals(operate)){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
					<%} %>
					<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
		   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
		</div>
		<div class="cornerMenuDiv"></div>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
		</div>
		<form name="frmmain" method="post" action="/workflow/action/WorkflowActionEditOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="<%=operate%>">
			<input type="hidden" id="actionids" name="actionids" value="">
			
			
			<input type="hidden" id="fromintegration" name="fromintegration" value="<%=fromintegration %>">
			<!--QC  281277  [80][90]流程流转集成-建议新建/编辑流程接口部署页面中加上关闭按钮，以保持统一   start-->
			<%if("1".equals(isdialog)){ %>
			<input type="hidden" name="isdialog" value="<%=isdialog%>">
			<%} %>
			<!--end-->
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
				  
						<wea:item><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></wea:item>
						<wea:item><!-- 流程名称，显示 -->
						<%if("1".equals(fromintegration)){ %>
							<brow:browser viewType="0" name="workflowid" browserValue='<%= ""+workflowid %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkflowBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0" linkUrl=""
								browserSpanValue='<%=workFlowName %>' width='200px' _callback="onShowWorkFlowSerach"></brow:browser>
						<%}else{ %>
							<%=workFlowName%>
							<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
						<%} %>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(83002,user.getLanguage())%>" onClick="setInterface();" class="e8_btn_submit"/>
						</wea:item>							
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(83003,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
					    <wea:item attributes="{'samePair':'listparams','colspan':'2'}">
					    <div class="listparams listparamstop e8_box demo2" id="tabbox" style='height:42px;'>
			    			<ul class="tab_menu" id="tabs" style="width:85%!important;">
			    			<!--QC  282506  [80][90]流程流转集成-流程接口部署新建/编辑窗口，节点操作出口操作切换横条显示问题  少了<a href="#">-->
						        <li style='padding-left:0px!important;'><a href="#"><%=SystemEnv.getHtmlLabelName(83004,user.getLanguage())%></a></li><!-- 查询字段设置 -->
						        <li><a href="#"><%=SystemEnv.getHtmlLabelName(83005,user.getLanguage())%></a></li><!-- 显示字段设置 -->
						    </ul>
						   <div id="" class="" style="width:15%;float:right;">
						    	<TABLE width=100% class="setbutton" id='button1' style="display:'';">
			           				<TR>
			           					<TD align=right colSpan=2 style="background: #fff;">
			           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow(1)" class="addbtn"/>
			           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(1)" class="delbtn"/>
			           					</TD>
			           				</TR>
			         			</TABLE>
							    <TABLE width=100% class="setbutton" id='button2' style="display:none;">
			           				<TR>
			           					<TD align=right colSpan=2 style="background: #fff;">
			           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow(2)" class="addbtn"/>
			           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(2)" class="delbtn"/>
			           					</TD>
			           				</TR>
			         			</TABLE>
						    </div>
						    <div class="tab_box" style="display:none;width:0px;">
						    </div>
						 </div>
					  </wea:item>
						<wea:item attributes="{'samePair':'datalist1','colspan':'2','isTableList':'true',display:'none'}">
						  	<div id="datalists">
						  		<table class="ListStyle" id="oTable1" name="oTable1">
						  			<COLGROUP>
						  			<COL width='3%'>
						  			<COL width='15%'>
						  			<COL width='10%'>
						  			<COL width='10%'>
						  			<COL width='30%'>
						  			<COL width='20%'>
						  			
						  			<tr class="header">
									   <th><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this,1)"></th>
									   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(83001, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></th><!-- 接口名称 -->
									   <th><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></th><!-- 是否启用 -->
									   <th><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></th><!-- 执行顺序 -->
									   <th><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></th><!-- 节点/出口 -->
									   <th><%=SystemEnv.getHtmlLabelName(32362, user.getLanguage())%></th><!-- 接口来源 -->
									</tr>
								</table>
						  	</div>
						  </wea:item>
						  <wea:item attributes="{'samePair':'datalist2','colspan':'2','isTableList':'true',display:'none'}">
						  	<div id="datalists">
						  		<table class="ListStyle" id="oTable2" name="oTable2">
						  			<COLGROUP>
						  			<COL width='3%'>
						  			<COL width='15%'>
						  			<COL width='10%'>
						  			<COL width='10%'>
						  			<COL width='30%'>
						  			<COL width='20%'>
						  			<tr class="header">
									   <th><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this,2)"></th>
									   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(83001, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></th><!-- 接口名称 -->
									   <th><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></th><!-- 是否启用 -->
									   <th><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></th><!-- 执行顺序 -->
									   <th><%=SystemEnv.getHtmlLabelName(15587, user.getLanguage())%></th><!-- 节点/出口 -->
									   <th><%=SystemEnv.getHtmlLabelName(32362, user.getLanguage())%></th><!-- 接口来源 -->
									   
									</tr>
								</table>
						  	</div>
						  </wea:item>
					</wea:group>
			</wea:layout>
		</form>
		
		<!--QC  281277  [80][90]流程流转集成-建议新建/编辑流程接口部署页面中加上关闭按钮，以保持统一   start-->
		<%if("1".equals(isdialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onClose();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>	
<!--end-->
	</body>
</html>
<script language="javascript">
function addRow(order)
{
 	 var rownum = document.getElementById("oTable"+order).rows.length;
     var oRow = document.getElementById("oTable"+order).insertRow(rownum);
     var oRowIndex = oRow.rowIndex;

     if (0 == oRowIndex % 2)
     {
         oRow.className = "DataLight";
     }
     else
     {
         oRow.className = "DataDark";
     }

     var oCell = oRow.insertCell(0);
     var oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='actionid' value=''><INPUT type='hidden' name='type' value='"+order+"'>";
     oCell.appendChild(oDiv);
     jQuery(oCell).jNice();
     
     oCell = oRow.insertCell(1);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='text' name='actionname' value='' maxlength=50 onChange=\"checkinpute8(this,'actionnamespan')\"><SPAN id=actionnamespan><img src=\"/images/BacoError_wev8.gif\" align=absmiddle></SPAN>";
     oCell.appendChild(oDiv);

     oCell = oRow.insertCell(2);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input class=\"inputstyle\" tzCheckbox=\"true\" type=checkbox id=\"tempisused\" name=\"tempisused\" value=\"1\" checked onclick=\"setIsUsedVal(this);\"><input type=hidden id=\"isused\" name=\"isused\" value=1>";
     oCell.appendChild(oDiv);
     reshowCheckBox();
     
     oCell = oRow.insertCell(3);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input type=\"text\" size=\"35\" style='width:50px!important;' class=\"InputStyle\" id=\"actionorder\" temptitle=\"<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>\" name=\"actionorder\" maxlength=\"10\"  value=\"\" onChange=\"checkinpute8(this,'actionorderspan')\"  onKeyPress=\"ItemCount_KeyPress()\" onBlur=\"checknumber1(this);\"><SPAN id=actionorderspan><img src=\"/images/BacoError_wev8.gif\" align=absmiddle></SPAN>";
     oCell.appendChild(oDiv);
     
     oCell = oRow.insertCell(4);
     oDiv = document.createElement("div");
     var triggermothod1 = "";
     var triggermothod2 = "";
     if(order=="1")
     {
     	triggermothod1 = "selected";
     }
     else
     {
     	triggermothod2 = "selected";
     }
     var otherhtml = "<SELECT class=InputStyle id=\"triggermothod\" name=\"triggermothod\" style='width:40px!important;' onchange=\"javascript:changeTriggerMothod(this);\" title=\"<%=SystemEnv.getHtmlLabelName(22252, user.getLanguage())%>\">";//选择类型
		 otherhtml +="	<option value=''></option> ";
		 otherhtml +="	<option value=\"1\" "+triggermothod1+"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></option> ";//节点
		 otherhtml +="	<option value=\"0\" "+triggermothod2+"><%=SystemEnv.getHtmlLabelName(15587, user.getLanguage())%></option> ";//出口
		 otherhtml +="</SELECT>  ";
		  /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 start*/
		 otherhtml +="		<span id=\"operatoridspan\" style=\"display:none\"> ";
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 otherhtml +="		</span>";
		 /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 end*/
		 otherhtml +="<SELECT class=InputStyle id=\"actionnodeid\" name=\"actionnodeid\" style='width:100px!important;' title=\"<%=SystemEnv.getHtmlLabelName(32206, user.getLanguage())%>\" onchange=\"checkinpute8(this,'nodeidspan')\">";//选择节点
		 otherhtml +="	<option></option> ";
							<%
							if(!"".equals(workflowid))
							{
								RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+workflowid+"  order by a.nodeorder,a.nodeType,a.nodeId  ");
								while(RecordSet.next()) {
									int temptriggerNodeId = RecordSet.getInt("triggerNodeId");
									String triggerNodeName = Util.null2String(RecordSet.getString("triggerNodeName"));
							%>
		 otherhtml +="	<option value=\"<%=temptriggerNodeId%>\"><%=triggerNodeName%></option> ";
							<%
								}
							}
							%>
		 otherhtml +="</SELECT> ";
		 otherhtml +="<span id=\"nodeidspan\"> ";
		 otherhtml +="	<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 otherhtml +="</span> ";
		 otherhtml +="		<SELECT class=InputStyle  id=\"actionispreoperator\" style='width:50px!important;' name=\"actionispreoperator\" title=\"<%=SystemEnv.getHtmlLabelName(32361, user.getLanguage())%>\">";//选择节点前/后
		 otherhtml +="			<option value=\"1\"><%=SystemEnv.getHtmlLabelName(31706, user.getLanguage())%></option>";//节点前
		 otherhtml +="			<option value=\"0\"><%=SystemEnv.getHtmlLabelName(31705, user.getLanguage())%></option>";//节点后
		 otherhtml +="		</SELECT> ";
		 otherhtml +="		<SELECT class=InputStyle id=\"actionnodelinkid\" style='width:80px!important;' name=\"actionnodelinkid\" title=\"<%=SystemEnv.getHtmlLabelName(32365, user.getLanguage())%>\" onchange=\"checkinpute8(this,'nodelinkidspan')\">";//选择出口
		 otherhtml +="			<option></option> ";
							<%
							if(!"".equals(workflowid))
							{
								String sqltest = "select id,nodeid,isreject,condition,conditioncn,linkname,destnodeid,nodepasstime,nodepasshour,nodepassminute,isBulidCode,ismustpass,tipsinfo,directionfrom,directionto from workflow_nodelink where wfrequestid is null and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.nodeid=b.id and b.IsFreeNode='1') and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and b.IsFreeNode='1') and workflowid="+workflowid+" order by linkorder,nodeid,id";
								RecordSet.executeSql(sqltest);
								while(RecordSet.next()) {
									int temptriggerlinkId = RecordSet.getInt("id");
									String templinkname = Util.null2String(RecordSet.getString("linkname"));
							%>
		 otherhtml +="				<option value=\"<%=temptriggerlinkId%>\"><%=templinkname%></option> ";
							<%
								}
							}
							%>
		 otherhtml +="		</SELECT> ";
		 otherhtml +="		<span id=\"nodelinkidspan\"> ";
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 otherhtml +="		</span>";
	 oDiv.innerHTML=otherhtml;
	 oCell.appendChild(oDiv);
	 jQuery(oCell).jNice();
     jQuery(oCell).find("select").selectbox("detach");
     jQuery(oCell).find("select").selectbox();
     
     changeTriggerMothod($(oCell).find("#triggermothod")[0]);
     
	 oCell = oRow.insertCell(5);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value=''>";
     
     jQuery(oDiv).find(".e8Browser").e8Browser({
		   name:"interfaceid",
		   viewType:"0",
		   browserValue:"",
		   isMustInput:"2",
		   browserSpanValue:"",
		   getBrowserUrlFn:'onShowTableField',
		   getBrowserUrlFnParams:"{order:'"+order+"'}",
		   hasInput:false,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"",
		   hasAdd:false,
		   width:'90%',
		   _callback:"onSetInterface"
	 });
	 oCell.appendChild(oDiv);
}
//<!--QC  281277  [80][90]流程流转集成-建议新建/编辑流程接口部署页面中加上关闭按钮，以保持统一-->
function onClose()
{
	parent.parent.getDialog(parent).close();
}

function init1()
{
	var order = "1";
	<%
	if(!"".equals(workflowid))
  	{
  		int countindex = 0;
	  	String sqljob = "SELECT w.*, r.* "+
						"  	  FROM workflowactionset w, "+
						"       (select a.workflowid, "+
						"               b.id as triggerNodeId, "+
						"               a.nodeType as triggerNodeType, "+
						"               a.nodeorder as triggerNodeorder, "+
						"               b.nodeName as triggerNodeName "+
						"          from workflow_flownode a, workflow_nodebase b "+
						"         where (b.IsFreeNode is null or b.IsFreeNode != '1') "+
						"           and a.nodeId = b.id "+
						"           and a.workFlowId = "+workflowid+") r "+
						" where w.workflowid = "+workflowid+
						"   and w.workflowid = r.workflowid "+
						"   and w.nodeid=r.triggerNodeId "+
						" order by r.triggerNodeorder,r.triggerNodeType, r.triggerNodeId, w.actionorder, w.id";
	  	rs.executeSql(sqljob);
	  	while(rs.next())
	  	{
	  		//actionname=?, workflowid=?, nodeid=?, nodelinkid=?, ispreoperator=?, actionorder=?, interfaceid=?, interfacetype
	  		String tempactionid = rs.getString("id");
	  		String actionname = rs.getString("actionname");
	  		String tempisused = rs.getString("isused");
	  		String tempnodeid = rs.getString("nodeid");
	  		String tempnodelinkid = rs.getString("nodelinkid");
	  		int tempispreoperator = Util.getIntValue(rs.getString("ispreoperator"),-2);
	  		String tempinterfaceid = rs.getString("interfaceid");
	  		String tempinterfacetype = rs.getString("interfacetype");
	  		String temptriggerNodeName = rs.getString("triggerNodeName");
	  		String tempactionorder = rs.getString("actionorder");
	  		String tempinterfacename = "";
	  		String tempactionname = "";
	  		countindex++;
	  		String className = "";
	  		if (0 == countindex % 2)
	        {
	            className = "DataLight";
	        }
	        else
	        {
	            className = "DataDark";
	        }
	  		if("1".equals(tempinterfacetype)||"2".equals(tempinterfacetype))
	  		{
		  		String tempsql = "select * from (select d.id,"+
								 "      d.dmlactionname as actionname,"+
								 "      d.formid,"+
								 "      d.isbill,"+
								 "      d.datasourceid,"+
								 "      '1' as fromtype,"+
								 "      'DML接口' as fromtypename"+
								 " from formactionset d "+
						         " union all select s.id,"+
								 "       s.actionname,"+
								 "       s.formid,"+
								 "       s.isbill,"+
								 "       '' as datasourceid,"+
								 "       '2' as fromtype,"+
								 "      case when webservicefrom=1 then 'WebService接口' else '自定义接口' end as fromtypename"+
								 "  from wsformactionset s) r where r.formid="+formid+" and r.id="+tempinterfaceid+" and r.fromtype="+tempinterfacetype+" order by fromtype,id";
		  		RecordSet.executeSql(tempsql);
		  		while(RecordSet.next())
		  		{
		  			tempinterfacename = RecordSet.getString("actionname");
		  		}
		  		
		  		if("1".equals(tempinterfacetype)){
		  			tempactionname = "<a href='/workflow/dmlaction/FormActionSettingEdit.jsp?fromintegration="+fromintegration+"&actionid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
			    }else if("2".equals(tempinterfacetype)){
			    	tempactionname = "<a href='/workflow/action/WsFormActionEditSet.jsp?operate=editws&fromintegration="+fromintegration+"&actionid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
			    }
	  		}
	  		else if("3".equals(tempinterfacetype))
	  		{
	  			String tempsql = "select id,actionshowname,actionname from actionsetting where actionname='"+tempinterfaceid+"'";
				RecordSet.executeSql(tempsql);
				if(RecordSet.next())
				{
					tempinterfacename = RecordSet.getString("actionshowname");
				}
				if("".equals(tempinterfacename))
				{
					tempinterfacename = tempinterfaceid;
				}
	  			tempactionname = "<a href='/servicesetting/actionsettingnew.jsp?fromintegration="+fromintegration+"&pointid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
	  		}
	%>
	 var rownum = document.getElementById("oTable"+order).rows.length;
     var oRow = document.getElementById("oTable"+order).insertRow(rownum);
     var oRowIndex = oRow.rowIndex;

     if (0 == oRowIndex % 2)
     {
         oRow.className = "DataLight";
     }
     else
     {
         oRow.className = "DataDark";
     }

     var oCell = oRow.insertCell(0);
     var oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"' value=<%=tempactionid %>><INPUT type='hidden' name='actionid' value='<%=tempactionid %>'><INPUT type='hidden' name='type' value='"+order+"'>";
     oCell.appendChild(oDiv);
     jQuery(oCell).jNice();
     
     oCell = oRow.insertCell(1);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='text' name='actionname' value='<%=actionname %>' maxlength=50 onChange=\"checkinpute8(this,'actionnamespan')\"><SPAN id=actionnamespan> <%if(actionname.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);

     oCell = oRow.insertCell(2);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input class=\"inputstyle\" tzCheckbox=\"true\" type=checkbox id=\"tempisused\" name=\"tempisused\" value=\"1\"  <%if(tempisused.equals("1")){ %>checked<%} %> onclick=\"setIsUsedVal(this);\"><input type=hidden id=\"isused\" name=\"isused\" value=\"<%=tempisused%>\">";
     oCell.appendChild(oDiv);
     reshowCheckBox();
     
     oCell = oRow.insertCell(3);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input type=\"text\" size=\"35\" style='width:50px!important;' class=\"InputStyle\" id=\"actionorder\" temptitle=\"<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>\" name=\"actionorder\" maxlength=\"10\"  value=\"<%=tempactionorder %>\" onChange=\"checkinpute8(this,'actionorderspan')\"  onKeyPress=\"ItemCount_KeyPress()\" onBlur=\"checknumber1(this);\"><SPAN id=actionorderspan> <%if(tempactionorder.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);
    
     oCell = oRow.insertCell(4);
     oDiv = document.createElement("div");
     var triggermothod1 = "";
     var triggermothod2 = "";
     if(order=="1")
     {
     	triggermothod1 = "selected";
     }
     else
     {
     	triggermothod2 = "selected";
     }
     var otherhtml = "<SELECT class=InputStyle id=\"triggermothod\" name=\"triggermothod\" style='width:40px!important;' onchange=\"javascript:changeTriggerMothod(this);\" title=\"<%=SystemEnv.getHtmlLabelName(22252, user.getLanguage())%>\">";//选择类型
		 otherhtml +="	<option value=''></option> ";
		 otherhtml +="	<option value=\"1\" "+triggermothod1+"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></option> ";//节点
		 otherhtml +="	<option value=\"0\" "+triggermothod2+"><%=SystemEnv.getHtmlLabelName(15587, user.getLanguage())%></option> ";//出口
		 otherhtml +="</SELECT>  ";
		  /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 start*/
		 otherhtml +="		<span id=\"operatoridspan\" style=\"display:none\"> ";
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 otherhtml +="		</span>";
		 /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 end*/
		 otherhtml +="<SELECT class=InputStyle id=\"actionnodeid\" name=\"actionnodeid\" style='width:100px!important;' title=\"<%=SystemEnv.getHtmlLabelName(32206, user.getLanguage())%>\" onchange=\"checkinpute8(this,'nodeidspan')\">";//选择节点
		 otherhtml +="	<option></option> ";
							<%
							if(!"".equals(workflowid))
							{
								RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+workflowid+"  order by a.nodeorder,a.nodeType,a.nodeId  ");
								while(RecordSet.next()) {
									int temptriggerNodeId = RecordSet.getInt("triggerNodeId");
									String triggerNodeName = Util.null2String(RecordSet.getString("triggerNodeName"));
									boolean selected = (temptriggerNodeId==Util.getIntValue(tempnodeid));
									String selectedstr = "";
									if(selected){
										selectedstr = "selected";
									}
							%>
		 otherhtml +="	<option value=\"<%=temptriggerNodeId%>\" <%=selectedstr%>><%=triggerNodeName%></option> ";
							<%
								}
							}
							%>
		 otherhtml +="</SELECT> ";
		 otherhtml +="<span id=\"nodeidspan\"> ";
		 <%if(tempnodeid.equals("")){%>
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 <%}%>
		 otherhtml +="</span> ";
		 otherhtml +="		<SELECT class=InputStyle  id=\"actionispreoperator\" style='width:50px!important;' name=\"actionispreoperator\" title=\"<%=SystemEnv.getHtmlLabelName(32361, user.getLanguage())%>\">";//选择节点前/后
		 otherhtml +="			<option value=\"1\" <%if(tempispreoperator==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(31706, user.getLanguage())%></option>";//节点前
		 otherhtml +="			<option value=\"0\" <%if(tempispreoperator==0)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(31705, user.getLanguage())%></option>";//节点后
		 otherhtml +="		</SELECT> ";
		 otherhtml +="		<SELECT class=InputStyle id=\"actionnodelinkid\" style='width:80px!important;' name=\"actionnodelinkid\" title=\"<%=SystemEnv.getHtmlLabelName(32365, user.getLanguage())%>\" onchange=\"checkinpute8(this,'nodelinkidspan')\">";//选择出口
		 otherhtml +="			<option></option> ";
							<%
							if(!"".equals(workflowid))
							{
								String sqltest = "select id,nodeid,isreject,condition,conditioncn,linkname,destnodeid,nodepasstime,nodepasshour,nodepassminute,isBulidCode,ismustpass,tipsinfo,directionfrom,directionto from workflow_nodelink where wfrequestid is null and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.nodeid=b.id and b.IsFreeNode='1') and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and b.IsFreeNode='1') and workflowid="+workflowid+" order by linkorder,nodeid,id";
								RecordSet.executeSql(sqltest);
								while(RecordSet.next()) {
									int temptriggerlinkId = RecordSet.getInt("id");
									String templinkname = Util.null2String(RecordSet.getString("linkname"));
									boolean selected = (temptriggerlinkId==Util.getIntValue(tempnodelinkid));
									String selectedstr = "";
									if(selected){
										selectedstr = "selected";
									}
							%>
		 otherhtml +="				<option value=\"<%=temptriggerlinkId%>\" <%=selectedstr%>><%=templinkname%></option> ";
							<%
								}
							}
							%>
		 otherhtml +="		</SELECT> ";
		 otherhtml +="		<span id=\"nodelinkidspan\"> ";
		 <%if(tempnodelinkid.equals("")){%>
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 <%}%>
		 otherhtml +="		</span>";
	 oDiv.innerHTML=otherhtml;
	 oCell.appendChild(oDiv);
	 jQuery(oCell).jNice();
     jQuery(oCell).find("select").selectbox("detach");
     jQuery(oCell).find("select").selectbox();
     
     changeTriggerMothod($(oCell).find("#triggermothod")[0]);
     
	 oCell = oRow.insertCell(5);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";
        
     jQuery(oDiv).find(".e8Browser").e8Browser({
		   name:"interfaceid",
		   viewType:"0",
		   browserValue:"<%=tempinterfaceid%>",
		   isMustInput:"2",
		   browserSpanValue:"<%=tempactionname%>",
		   getBrowserUrlFn:'onShowTableField',
		   getBrowserUrlFnParams:"{order:'"+order+"'}",
		   hasInput:false,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"",
		   hasAdd:false,
		   width:'90%',
		   _callback:"onSetInterface"
	 });
	 oCell.appendChild(oDiv);
	<%
	  	}
  	}
  	%>
}
function init2()
{
	var order = "2";
	<%
	if(!"".equals(workflowid))
  	{
  		int countindex = 0;
  		String sqljob = "SELECT w.*, r.* "+
					  	"  FROM workflowactionset w, "+
					    "   (select id, "+
					    "           nodeid, "+
					    "           isreject, "+
					    "           condition, "+
					    "           conditioncn,linkorder, "+
					    "           linkname, "+
						"		    workflowid "+
					    "      from workflow_nodelink "+
					    "     where wfrequestid is null "+
					    "       and not EXISTS (select 1 "+
					    "              from workflow_nodebase b "+
					    "             where workflow_nodelink.nodeid = b.id "+
					    "               and b.IsFreeNode = '1') "+
					    "       and not EXISTS (select 1 "+
					    "              from workflow_nodebase b "+
					    "             where workflow_nodelink.destnodeid = b.id "+
					    "               and b.IsFreeNode = '1') "+
					    "       and workflowid = "+workflowid+") r "+
					 	" where w.workflowid = "+workflowid+
					    "   and w.workflowid = r.workflowid and w.nodelinkid=r.id "+
					    " order by r.linkorder,r.nodeid,r.id, w.actionorder, w.id";
	  	rs.executeSql(sqljob);
	  	while(rs.next())
	  	{
	  		//actionname=?, workflowid=?, nodeid=?, nodelinkid=?, ispreoperator=?, actionorder=?, interfaceid=?, interfacetype
	  		String tempactionid = rs.getString("id");
	  		String actionname = rs.getString("actionname");
	  		String tempisused = rs.getString("isused");
	  		String tempnodeid = rs.getString("nodeid");
	  		String tempnodelinkid = rs.getString("nodelinkid");
	  		int tempispreoperator = Util.getIntValue(rs.getString("ispreoperator"),-2);
	  		String tempinterfaceid = rs.getString("interfaceid");
	  		String tempinterfacetype = rs.getString("interfacetype");
	  		String temptriggerNodeName = rs.getString("triggerNodeName");
	  		String tempactionorder = rs.getString("actionorder");
	  		String tempactionname = "";
	  		String tempinterfacename = "";
	  		countindex++;
	  		String className = "";
	  		if (0 == countindex % 2)
	        {
	            className = "DataLight";
	        }
	        else
	        {
	            className = "DataDark";
	        }
	  		if("1".equals(tempinterfacetype)||"2".equals(tempinterfacetype))
	  		{
	  			String tempsql = "select * from (select d.id,"+
								 "      d.dmlactionname as actionname,"+
								 "      d.formid,"+
								 "      d.isbill,"+
								 "      d.datasourceid,"+
								 "      '1' as fromtype,"+
								 "      'DML接口' as fromtypename"+
								 " from formactionset d "+
						         " union all select s.id,"+
								 "       s.actionname,"+
								 "       s.formid,"+
								 "       s.isbill,"+
								 "       '' as datasourceid,"+
								 "       '2' as fromtype,"+
								 "      case when webservicefrom=1 then 'WebService接口' else '自定义接口' end as fromtypename"+
								 "  from wsformactionset s) r where r.formid="+formid+" and r.id="+tempinterfaceid+" and r.fromtype="+tempinterfacetype+" order by fromtype,id";
		  		RecordSet.executeSql(tempsql);
		  		while(RecordSet.next())
		  		{
		  			tempinterfacename = RecordSet.getString("actionname");
		  		}
		  		
		  		if("1".equals(tempinterfacetype)){
		  			tempactionname = "<a href='/workflow/dmlaction/FormActionSettingEdit.jsp?fromintegration="+fromintegration+"&actionid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
			    }else if("2".equals(tempinterfacetype)){
			    	tempactionname = "<a href='/workflow/action/WsFormActionEditSet.jsp?operate=editws&fromintegration="+fromintegration+"&actionid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
			    }
	  		}
	  		else if("3".equals(tempinterfacetype))
	  		{
	  			String tempsql = "select id,actionshowname,actionname from actionsetting where actionname='"+tempinterfaceid+"'";
				RecordSet.executeSql(tempsql);
				if(RecordSet.next())
				{
					tempinterfacename = RecordSet.getString("actionshowname");
				}
				if("".equals(tempinterfacename))
				{
					tempinterfacename = tempinterfaceid;
				}
	  			tempactionname = "<a href='/servicesetting/actionsettingnew.jsp?fromintegration="+fromintegration+"&pointid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
	  		}
	%>
	 var rownum = document.getElementById("oTable"+order).rows.length;
     var oRow = document.getElementById("oTable"+order).insertRow(rownum);
     var oRowIndex = oRow.rowIndex;

     if (0 == oRowIndex % 2)
     {
         oRow.className = "DataLight";
     }
     else
     {
         oRow.className = "DataDark";
     }

     var oCell = oRow.insertCell(0);
     var oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"' value=<%=tempactionid %>><INPUT type='hidden' name='actionid' value='<%=tempactionid %>'><INPUT type='hidden' name='type' value='"+order+"'>";
     oCell.appendChild(oDiv);
     jQuery(oCell).jNice();
     
     oCell = oRow.insertCell(1);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='text' name='actionname' value='<%=actionname %>' maxlength=50 onChange=\"checkinpute8(this,'actionnamespan')\"><SPAN id=actionnamespan> <%if(actionname.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);

     oCell = oRow.insertCell(2);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input class=\"inputstyle\" tzCheckbox=\"true\" type=checkbox id=\"isused\" name=\"isused\" value=\"1\"  <%if(tempisused.equals("1")){ %>checked<%} %> onclick=\"setIsUsedVal(this);\"><input type=hidden id=\"isused\" name=\"isused\" value=\"<%=tempisused%>\">";
     oCell.appendChild(oDiv);
     reshowCheckBox();
     
     oCell = oRow.insertCell(3);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input type=\"text\" size=\"35\" style='width:50px!important;' class=\"InputStyle\" id=\"actionorder\" temptitle=\"<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>\" name=\"actionorder\" maxlength=\"10\"  value=\"<%=tempactionorder %>\" onChange=\"checkinpute8(this,'actionorderspan')\"  onKeyPress=\"ItemCount_KeyPress()\" onBlur=\"checknumber1(this);\"><SPAN id=actionorderspan> <%if(tempactionorder.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);
    
     oCell = oRow.insertCell(4);
     oDiv = document.createElement("div");
     var triggermothod1 = "";
     var triggermothod2 = "";
     if(order=="1")
     {
     	triggermothod1 = "selected";
     }
     else
     {
     	triggermothod2 = "selected";
     }
     var otherhtml = "<SELECT class=InputStyle id=\"triggermothod\" name=\"triggermothod\" style='width:40px!important;' onchange=\"javascript:changeTriggerMothod(this);\" title=\"<%=SystemEnv.getHtmlLabelName(22252, user.getLanguage())%>\">";//选择类型
		 otherhtml +="	<option value=''></option> ";
		 otherhtml +="	<option value=\"1\" "+triggermothod1+"><%=SystemEnv.getHtmlLabelName(15586, user.getLanguage())%></option> ";//节点
		 otherhtml +="	<option value=\"0\" "+triggermothod2+"><%=SystemEnv.getHtmlLabelName(15587, user.getLanguage())%></option> ";//出口
		 otherhtml +="</SELECT>  ";
		  /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 start*/
		 otherhtml +="		<span id=\"operatoridspan\" style=\"display:none\"> ";
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 otherhtml +="		</span>";
		 /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 end*/
		 otherhtml +="<SELECT class=InputStyle id=\"actionnodeid\" name=\"actionnodeid\" style='width:100px!important;' title=\"<%=SystemEnv.getHtmlLabelName(32206, user.getLanguage())%>\" onchange=\"checkinpute8(this,'nodeidspan')\">";//选择节点
		 otherhtml +="	<option></option> ";
							<%
							if(!"".equals(workflowid))
							{
								RecordSet.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and  a.workFlowId= "+workflowid+"  order by a.nodeorder,a.nodeType,a.nodeId  ");
								while(RecordSet.next()) {
									int temptriggerNodeId = RecordSet.getInt("triggerNodeId");
									String triggerNodeName = Util.null2String(RecordSet.getString("triggerNodeName"));
									boolean selected = (temptriggerNodeId==Util.getIntValue(tempnodeid));
									String selectedstr = "";
									if(selected){
										selectedstr = "selected";
									}
							%>
		 otherhtml +="	<option value=\"<%=temptriggerNodeId%>\" <%=selectedstr%>><%=triggerNodeName%></option> ";
							<%
								}
							}
							%>
		 otherhtml +="</SELECT> ";
		 otherhtml +="<span id=\"nodeidspan\"> ";
		 <%if(tempnodeid.equals("")){%>
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 <%}%>
		 otherhtml +="</span> ";
		 otherhtml +="		<SELECT class=InputStyle  id=\"actionispreoperator\" style='width:50px!important;' name=\"actionispreoperator\" title=\"<%=SystemEnv.getHtmlLabelName(32361, user.getLanguage())%>\">";//选择节点前/后
		 otherhtml +="			<option value=\"1\" <%if(tempispreoperator==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(31706, user.getLanguage())%></option>";//节点前
		 otherhtml +="			<option value=\"0\" <%if(tempispreoperator==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(31705, user.getLanguage())%></option>";//节点后
		 otherhtml +="		</SELECT> ";
		 otherhtml +="		<SELECT class=InputStyle id=\"actionnodelinkid\" style='width:80px!important;' name=\"actionnodelinkid\" title=\"<%=SystemEnv.getHtmlLabelName(32365, user.getLanguage())%>\" onchange=\"checkinpute8(this,'nodelinkidspan')\">";//选择出口
		 otherhtml +="			<option></option> ";
							<%
							if(!"".equals(workflowid))
							{
								String sqltest = "select id,nodeid,isreject,condition,conditioncn,linkname,destnodeid,nodepasstime,nodepasshour,nodepassminute,isBulidCode,ismustpass,tipsinfo,directionfrom,directionto from workflow_nodelink where wfrequestid is null and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.nodeid=b.id and b.IsFreeNode='1') and not EXISTS(select 1 from workflow_nodebase b where workflow_nodelink.destnodeid=b.id and b.IsFreeNode='1') and workflowid="+workflowid+" order by linkorder,nodeid,id";
								RecordSet.executeSql(sqltest);
								while(RecordSet.next()) {
									int temptriggerlinkId = RecordSet.getInt("id");
									String templinkname = Util.null2String(RecordSet.getString("linkname"));
									boolean selected = (temptriggerlinkId==Util.getIntValue(tempnodelinkid));
									String selectedstr = "";
									if(selected){
										selectedstr = "selected";
									}
							%>
		 otherhtml +="				<option value=\"<%=temptriggerlinkId%>\" <%=selectedstr%>><%=templinkname%></option> ";
							<%
								}
							}
							%>
		 otherhtml +="		</SELECT> ";
		 otherhtml +="		<span id=\"nodelinkidspan\"> ";
		 <%if(tempnodelinkid.equals("")){%>
		 otherhtml +="			<img src=\"/images/BacoError_wev8.gif\" align=absmiddle> ";
		 <%}%>
		 otherhtml +="		</span>";
	 oDiv.innerHTML=otherhtml;
	 oCell.appendChild(oDiv);
	 jQuery(oCell).jNice();
     jQuery(oCell).find("select").selectbox("detach");
     jQuery(oCell).find("select").selectbox();
     
     changeTriggerMothod($(oCell).find("#triggermothod")[0]);
     
	 oCell = oRow.insertCell(5);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";

     jQuery(oDiv).find(".e8Browser").e8Browser({
		   name:"interfaceid",
		   viewType:"0",
		   browserValue:"<%=tempinterfaceid%>",
		   isMustInput:"2",
		   browserSpanValue:"<%=tempactionname%>",
		   getBrowserUrlFn:'onShowTableField',
		   getBrowserUrlFnParams:"{order:'"+order+"'}",
		   hasInput:false,
		   linkUrl:"#",
		   isSingle:true,
		   completeUrl:"/data.jsp",
		   browserUrl:"",
		   hasAdd:false,
		   width:'90%',
		   _callback:"onSetInterface"
	 });
	 oCell.appendChild(oDiv);
	<%
	  	}
  	}
  	%>
}
function setIsUsedVal(obj)
{
	if(obj.checked)
	{
		jQuery(obj).nextAll('input[name=isused]').val("1")
	}
	else
	{
		jQuery(obj).nextAll('input[name=isused]').val("0")
	}
}
function reshowCheckBox()
{
	jQuery("input[type=checkbox]").each(function(){
		if(jQuery(this).attr("tzCheckbox")=="true"){
			jQuery(this).tzCheckbox({labels:['','']});
		}
	});
}
function onShowTableField(parames){
	//tablename,type,order
	var jsonarrs = eval(parames);
	var order = jsonarrs.order;
	<%
	String tempactionurl = "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/SingleActionBrowser.jsp?formid="+formid;
	%>
	var urls = "<%=tempactionurl%>";
	return urls;
}
function changeTriggerMothod(obj)
{
	//alert(type);
	//alert($(obj).siblings("#nodeid").html());
	var type = obj.value;
	if(type=="1")
	{
		$(obj).siblings("#actionnodeid").selectbox("show");
		$(obj).siblings("#actionnodeid").selectbox("detach");
        $(obj).siblings("#actionnodeid").selectbox();
        
		$(obj).siblings("#actionispreoperator").selectbox("show");
		$(obj).siblings("#actionispreoperator").selectbox("detach");
        $(obj).siblings("#actionispreoperator").selectbox();
        
		$(obj).siblings("#nodeidspan").show();
        
		$(obj).siblings("#ispreoperatorspan").show();
        
		$(obj).siblings("#actionnodelinkid").selectbox("hide");
		//$("#nodelinkid").selectbox("detach");
        //$("#nodelinkid").selectbox();
        
		$(obj).siblings("#nodelinkidspan").hide();
        
		$(obj).siblings("#actionnodelinkid").val("");
		//$("#nodelinkid").selectbox("detach");
        //$("#nodelinkid").selectbox();
        /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 start*/
        $(obj).siblings("#operatoridspan").hide();
        if($(obj).siblings("#actionnodeid").val() == ""){
           $(obj).siblings("#nodeidspan").html("<img src=\"/images/BacoError_wev8.gif\" align=absmiddle>");
        }
        
        /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 end*/
	}
	else if(type=="0")
	{
		$(obj).siblings("#actionnodeid").selectbox("hide");
		//$("#nodeid").selectbox("detach");
        //$("#nodeid").selectbox();
        
		$(obj).siblings("#nodeidspan").hide();
		$(obj).siblings("#actionispreoperator").selectbox("hide");
		//$("#ispreoperator").selectbox("detach");
        //$("#ispreoperator").selectbox();
        
		$(obj).siblings("#ispreoperatorspan").hide();
		$(obj).siblings("#actionnodelinkid").selectbox("show");
		$(obj).siblings("#actionnodelinkid").selectbox("detach");
        $(obj).siblings("#actionnodelinkid").selectbox();
        
        
		$(obj).siblings("#nodelinkidspan").show();
		$(obj).siblings("#actionnodeid").val("");
		//$("#nodeid").selectbox("detach");
        //$("#nodeid").selectbox();
        
		$(obj).siblings("#actionispreoperator").val("");
		//$("#ispreoperator").selectbox("detach");
        //$("#ispreoperator").selectbox();
        /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 start*/
        $(obj).siblings("#operatoridspan").hide();
        if($(obj).siblings("#actionnodeid").val() == ""){
           $(obj).siblings("#nodeidspan").html("<img src=\"/images/BacoError_wev8.gif\" align=absmiddle>");
        }
        if($(obj).siblings("#actionnodelinkid").val() == ""){
           $(obj).siblings("#nodelinkidspan").html("<img src=\"/images/BacoError_wev8.gif\" align=absmiddle>");
        }
        /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 end*/
	}
	else
	{
		$(obj).siblings("#actionnodeid").selectbox("hide");
		$(obj).siblings("#nodeidspan").hide();
		
		$(obj).siblings("#actionispreoperator").selectbox("hide");
		$(obj).siblings("#ispreoperatorspan").hide();
		
		$(obj).siblings("#actionnodelinkid").selectbox("hide");
		$(obj).siblings("#nodelinkidspan").hide();
		
		$(obj).siblings("#actionnodelinkid").val("");
		$(obj).siblings("#actionnodeid").val("");
		$(obj).siblings("#actionispreoperator").val("");
		/*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 start*/
        $(obj).siblings("#operatoridspan").show();
        /*QC295997 [80][90]流程流转集成-解决流程接口部署页面缺少必填项提示的问题 end*/
	}
}
$(document).ready(function(){
	//changeTriggerMothod(<%=triggermothod%>);
	showListTab();
	init1();
	init2();
});
function showListTab()
{
    try
	{
		jQuery('#tabbox').Tabs({
	    	getLine:1,
        	staticOnLoad:false,
        	needInitBoxHeight:false,
	    	container:"#tabbox"
	    });
    }
    catch(e)
    {
    }
	jQuery.jqtab = function(tabtit,tab_conbox,shijian) 
	{
		try
		{
			showEle(tab_conbox);
			$(tabtit).find("li:first").addClass("current").show();
		}
		catch(e)
		{
		}
		
		$(tabtit).find("li").bind(shijian,function(){
			try
			{
			    $(this).addClass("current").siblings("li").removeClass("current"); 
				var activeindex = $(tabtit).find("li").index(this)+1;
				//hideEle("listparam");
				$(".setbutton").hide();
				hideEle("datalist1");
				hideEle("datalist2");
				showEle("datalist"+activeindex);
				$("#button"+activeindex).show();
			}
			catch(e)
			{
			}
			return false;
		});
	
	};
	/*调用方法如下：*/
	$.jqtab("#tabs","datalist1","click");
	$("#tabs").find("li:first").click();
}
function submitData(){
	enableAllmenu();
	document.getElementById("operate").value = "save";
	if(!checkActionSet())
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32364, user.getLanguage())%>");//请选择节点或者出口!
		displayAllmenu();
		return;
	}
	needcheck = "actionname,workflowid,interfaceid,actionorder";
    if(check_form(frmmain,needcheck)){
        document.frmmain.submit();
    }
    displayAllmenu();
}
function checkActionSet()
{
	var triggermothods = document.getElementsByName("triggermothod");
	//alert("triggermothods : "+triggermothods);
	if(triggermothods)
	{
		for(var i = 0;i<triggermothods.length;i++)
		{
			var triggermothod = triggermothods[i];
			//alert("triggermothod : "+triggermothod+" triggermothod : "+triggermothod.value);
			if(triggermothod.value=="")
			{
				return false;
			}
			if(triggermothod.value=="1")
			{
		        var actionnodeid = $(triggermothod).siblings("#actionnodeid").val();
		        var actionispreoperator = $(triggermothod).siblings("#actionispreoperator").val();
		        if(actionnodeid==""||actionispreoperator=="")
				{
					return false;
				}
			}
			else if(triggermothod.value=="0")
			{
				var actionnodelinkid = $(triggermothod).siblings("#actionnodelinkid").val();
				if(actionnodelinkid=="")
				{
					return false;
				}
			}
		}
	}
	return true;
}
function deleteData(){
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83006,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.getElementById("operate").value = "delete";
		document.getElementById("actionids").value = "";
        document.frmmain.submit();
	}, function () {}, 320, 90);	
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "","dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
			document.frmMain.action="/workflow/action/WsActionEditSet.jsp"
   			document.frmMain.submit()
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
function chkAllClick(obj,order)
{
    var chks = document.getElementsByName("paramid_"+order);
    
    for (var i = 0; i < chks.length; i++)
    {
        var chk = chks[i];
        
        if(false == chk.disabled)
        {
        	chk.checked = obj.checked;
        	try
        	{
        		if(chk.checked)
        			jQuery(chk.nextSibling).addClass("jNiceChecked");
        		else
        			jQuery(chk.nextSibling).removeClass("jNiceChecked");
        	}
        	catch(e)
        	{
        	}
        }
    }
}
function removeRow(order)
{
	 var chks = document.getElementsByName("paramid_"+order);
     var ids = "";
     for (var i = 0; i < chks.length; i++)
     {
         var chk = chks[i];
         
         //alert(chk.parentElement.parentElement.parentElement.rowIndex);
         if (chk.checked)
         {
         	 ids += (ids=="")?chk.value:(","+chk.value);
         }
     }
     //alert("ids : "+ids);
     if(""==ids)
     {
     	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		return ;
     }
     else
     {
		 top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function ()
		 {
	        var chks = document.getElementsByName("paramid_"+order);
	        for (var i = chks.length - 1; i >= 0; i--)
	        {
	            var chk = chks[i];
	            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
	            if (chk.checked)
	            {
	                document.getElementById("oTable"+order).deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex)
	            }
	        }
	     }, function () {}, 320, 90);
 	 }
}
function onSetInterface(event,data,name,paras,tg){
	//Dialog.alert("event : "+event);
	var obj = null;
	//alert(typeof(tg)+"  event : "+event);
	if(typeof(tg)=='undefined'){
		obj= event.target || event.srcElement;
	}
	else
	{
		obj = tg;
	}
	try
	{
		$(obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement).find("#interfacetype").val(data.type)
	}
	catch(e)
	{
	}
	//alert(event+"  "+name);
	
}
function onShowWorkFlowSerach() {
	document.frmmain.action="/workflow/action/WorkflowActionEditSet.jsp";
	document.frmmain.submit()
}
function onBackUrl(url)
{
	document.location.href=url;
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function setInterface()
{
	
	var url = "/integration/icontent.jsp?showtype=10";
	var title = "<%=SystemEnv.getHtmlLabelName(32338 ,user.getLanguage())%>";
	openDialog(url,title);
}


function setOrigin(url)
{

	openDialog(url,"<%=SystemEnv.getHtmlLabelName(93, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(32362, user.getLanguage())%>");
}

function openDialog(url,title,width,height){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = url;
	dialog.Title = title;
	dialog.Width = width||750;
	dialog.Height = height||596;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.maxiumnable=true;//允许最大化
	dialog.show();
}
</script>
