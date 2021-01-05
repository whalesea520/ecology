
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String workflowid = Util.null2String(request.getParameter("workflowid"));
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(Util.getIntValue(workflowid, 0), 0, user, WfRightManager.OPERATION_CREATEDIR);
if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String operate = Util.null2String(request.getParameter("operate"));

	String triggermothod = Util.null2String(request.getParameter("triggermothod"));
	if("".equals(triggermothod))
		triggermothod = "1";

	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	//是否节点后附加操作

	int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
	
	String workFlowName = "";
	int isbill = 0;
	int formid = 0;
	if(Util.getIntValue(workflowid)>-1){
		RecordSet.executeSql("select * from workflow_base where id="+workflowid);
		if(RecordSet.next())
		{
			workFlowName = RecordSet.getString("workflowname");
			isbill = Util.getIntValue(RecordSet.getString("isbill"), 0);
			formid = Util.getIntValue(RecordSet.getString("formid"), 0);
		}
	}
	String order = "1";
	String nodename = "";
	if(nodeid>0){
		RecordSet.executeSql("select nodename from workflow_nodebase b where b.id = "+nodeid);
		if(RecordSet.next()){
			nodename = RecordSet.getString("nodename");
		}
		order = "1";
	}
	String linkname = "";
	if(nodelinkid>0){
		RecordSet.executeSql("select linkname from workflow_nodelink n where n.id = "+nodelinkid);
		if(RecordSet.next()){
			linkname = RecordSet.getString("linkname");
		}
		order = "2";
	}
	boolean isDmlAction = GCONST.isDMLAction();
	boolean isWsAction = GCONST.isWsAction();
	boolean isSapAction = GCONST.isSapAction();
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
	<body>
			<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid%>">
			<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20977,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
					    <wea:item><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></wea:item>
						<wea:item attributes="{'colspan':'2'}">
							<select id="actionlist" name="actionlist">
								<option value="3"><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
								<%if(isDmlAction){%>
								<option value="1">DML<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
								<%}%>
								<%if(isWsAction){%>
								<option value="2">WebService<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
								<%}%>
								<%if(isSapAction){%>
								<option value="4">SAP<%=SystemEnv.getHtmlLabelName(20978,user.getLanguage())%></option>
								<%}%>
							</select>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(83002,user.getLanguage())%>" onClick="setInterface();" class="e8_btn_submit"/>		
						</wea:item>
						<wea:item>
							<div align=right>
								<button type='button' class=addbtn onclick=addRowNew(<%=order %>); title="<%=SystemEnv.getHtmlLabelName(456,user.getLanguage())%>" onFocus="this.blur()"></button><!-- 增加 -->
								<button type='button' class=delbtn onclick=removeRowNew(<%=order %>); title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onFocus="this.blur()"></button><!-- 删除 -->
							</div>
						</wea:item>
						<%if(nodeid>0){%>
						<wea:item attributes="{'samePair':'datalist1','colspan':'4','isTableList':'true'}">
						  	<div id="datalists">
						  		<table class="ListStyle" id="oTable1" name="oTable1">
						  			<COLGROUP>
						  			<COL width='3%'>
						  			<COL width='15%'>
						  			<COL width='10%'>
						  			<COL width='10%'>
						  			<COL width='20%'>
						  			<tr class="header">
									   <th><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this,1)"></th>
									   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(83001, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></th><!-- 接口名称 -->
									   <th><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></th><!-- 是否启用 -->
									   <th><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></th><!-- 执行顺序 -->
									   <th><%=SystemEnv.getHtmlLabelName(32362, user.getLanguage())%></th><!-- 接口来源 -->
									</tr>
								</table>
						  	</div>
						  </wea:item>
						  <%} %>
						  <%if(nodelinkid>0){ %>
						  <wea:item attributes="{'samePair':'datalist2','colspan':'4','isTableList':'true'}">
						  	<div id="datalists">
						  		<table class="ListStyle" id="oTable2" name="oTable2">
						  			<COLGROUP>
						  			<COL width='3%'>
						  			<COL width='15%'>
						  			<COL width='10%'>
						  			<COL width='10%'>
						  			<COL width='20%'>
						  			<tr class="header">
									   <th><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this,2)"></th>
									   <th style='padding-left:0px!important;'><%=SystemEnv.getHtmlLabelName(83001, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></th><!-- 接口名称 -->
									   <th><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></th><!-- 是否启用 -->
									   <th><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></th><!-- 执行顺序 -->
									   <th><%=SystemEnv.getHtmlLabelName(32362, user.getLanguage())%></th><!-- 接口来源 -->
									</tr>
								</table>
						  	</div>
						  </wea:item>
						  <%} %>
					</wea:group>
			</wea:layout>
		</form>
	</body>
</html>
<script language="javascript">
function addRowNew(order)
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
     oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='actionid' value=''><INPUT type='hidden' name='type' value='"+order+"'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionnodeid\" name=\"actionnodeid\" value='<%=nodeid%>'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionispreoperator\" name=\"actionispreoperator\" value='<%=ispreoperator%>'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionnodelinkid\" name=\"actionnodelinkid\" value='<%=nodelinkid%>'>";
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
function init1()
{
	var order = "1";
	<%
	if(!"".equals(workflowid)&&nodeid>0)
  	{
  		int countindex = 0;
	  	String sqljob = "SELECT w.*, r.* "+
						"  	  FROM workflowactionset w, "+
						"       (select a.workflowid, "+
						"               b.id as triggerNodeId, "+
						"               a.nodeType as triggerNodeType, "+
						"               b.nodeName as triggerNodeName "+
						"          from workflow_flownode a, workflow_nodebase b "+
						"         where (b.IsFreeNode is null or b.IsFreeNode != '1') "+
						"           and a.nodeId = b.id "+
						"           and a.workFlowId = "+workflowid+") r "+
						" where w.workflowid = "+workflowid+
						"   and w.workflowid = r.workflowid "+
						"   and w.nodeid=r.triggerNodeId and w.nodeid="+nodeid+" and w.ispreoperator="+ispreoperator+
						" order by r.triggerNodeType, r.triggerNodeId, w.actionorder, w.id";
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
			    	tempactionname = "<a href='/workflow/action/WsFormActionEditSet.jsp?fromintegration="+fromintegration+"&actionid="+tempinterfaceid+"&operate=editws' target='_blank'>"+tempinterfacename+"</a>";
			    }
	  		}
	  		else if("3".equals(tempinterfacetype))
	  		{
	  			String tempsql = "select s.id,s.actionshowname,s.actionname from actionsetting s where actionname='"+tempinterfaceid+"'";
				RecordSet.executeSql(tempsql);
				if(RecordSet.next())
				{
					tempinterfacename = RecordSet.getString("actionshowname");
				}
				if("".equals(tempinterfacename))
				{
					tempinterfacename = tempinterfaceid;
				}
				tempactionname = "<a title='"+tempinterfacename+"' href='/servicesetting/actionsettingnew.jsp?fromintegration="+fromintegration+"&pointid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
	  			//tempactionname = "<a title='"+tempinterfacename+"' onclick='return false;' href='#"+tempinterfacename+"'>"+tempinterfacename+"</a>";
	  		}else if("4".equals(tempinterfacetype)){
	  			//modify by wshen
	  			String args="?workflowId="+workflowid+"&nodeid="+nodeid+"&nodelinkid="+nodelinkid+"&ispreoperator="+tempispreoperator+"&workflowid="+workflowid+"&w_type=1&mark="+tempinterfaceid+"&actionid="+tempactionid;
	  			String addurl="/integration/browse/integrationBrowerMain.jsp"+args;
				tempinterfacename = tempinterfaceid;
	  			//tempactionname = "<a href='"+addurl+"'>"+tempinterfacename+"</a>";
	  			//alter by wshen
	  			tempactionname = "<span  onclick='showEditInterface(this)' style='cursor: pointer;' onfocus='changeColor(1,this)' onblur='changeColor(2,this)'>"+tempinterfacename+"<input type='hidden' id='url'value='"+addurl+"'><input type='hidden' id='interfaceid' name='interfaceid' value='"+tempinterfacename+"'><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='"+tempinterfacetype+"'></span>";
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
     oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"' value=<%=tempactionid %>><INPUT type='hidden' name='actionid' value='<%=tempactionid %>'><INPUT type='hidden' name='type' value='"+order+"'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionnodeid\" name=\"actionnodeid\" value='<%=tempnodeid%>'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionispreoperator\" name=\"actionispreoperator\" value='<%=tempispreoperator%>'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionnodelinkid\" name=\"actionnodelinkid\" value='<%=tempnodelinkid%>'>";
     oCell.appendChild(oDiv);
     jQuery(oCell).jNice();

	//add by wshen
	<%
	if("4".equals(tempinterfacetype)){%>
	oCell = oRow.insertCell(1);
	oDiv = document.createElement("div");
	oDiv.innerHTML="<INPUT type='text' style='border:0px;' readonly='readonly' name='actionname' value='<%=actionname %>' maxlength=50 onChange=\"checkinpute8(this,'actionnamespan')\"><SPAN id=actionnamespan> <%if(actionname.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
	oCell.appendChild(oDiv);
	<%}else{%>
     oCell = oRow.insertCell(1);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='text' name='actionname' value='<%=actionname %>' maxlength=50 onChange=\"checkinpute8(this,'actionnamespan')\"><SPAN id=actionnamespan> <%if(actionname.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);
	<%}%>


     oCell = oRow.insertCell(2);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input class=\"inputstyle\" tzCheckbox=\"true\" type=checkbox id=\"tempisused\" name=\"tempisused\" value=\"1\" onclick=\"setIsUsedVal(this);\" <%if(tempisused.equals("1")){ %>checked<%} %>><input type=hidden id=\"isused\" name=\"isused\" value=\"<%=tempisused%>\">";
     oCell.appendChild(oDiv);
     reshowCheckBox();
     
     oCell = oRow.insertCell(3);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input type=\"text\" size=\"35\" style='width:50px!important;' class=\"InputStyle\" id=\"actionorder\" temptitle=\"<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>\" name=\"actionorder\" maxlength=\"10\"  value=\"<%=tempactionorder %>\" onChange=\"checkinpute8(this,'actionorderspan')\"  onKeyPress=\"ItemCount_KeyPress()\" onBlur=\"checknumber1(this);\"><SPAN id=actionorderspan> <%if(tempactionorder.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);

	//add by wshen
	<%
	if("4".equals(tempinterfacetype)){%>
	oCell = oRow.insertCell(4);
	oDiv = document.createElement("div");
	//oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";
	oDiv.innerHTML="<%=tempactionname%>";
	<%}else{%>
	 oCell = oRow.insertCell(4);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";
	<%}%>

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
	if(!"".equals(workflowid)&&nodelinkid>0)
  	{
  		int countindex = 0;
  		String sqljob = "SELECT w.*, r.* "+
					  	"  FROM workflowactionset w, "+
					    "   (select id, "+
					    "           nodeid, "+
					    "           isreject, "+
					    "           condition, "+
					    "           conditioncn, "+
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
					 	" where w.workflowid = "+workflowid+" and w.nodelinkid="+nodelinkid+
					    "   and w.workflowid = r.workflowid and w.nodelinkid=r.id "+
					    " order by r.nodeid,r.id, w.actionorder, w.id";
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
			    	tempactionname = "<a href='/workflow/action/WsFormActionEditSet.jsp?fromintegration="+fromintegration+"&actionid="+tempinterfaceid+"&operate=editws' target='_blank'>"+tempinterfacename+"</a>";
			    }
	  		}
	  		else if("3".equals(tempinterfacetype))
	  		{
	  			String tempsql = "select s.id,s.actionshowname,s.actionname from actionsetting s where actionname='"+tempinterfaceid+"'";
				RecordSet.executeSql(tempsql);
				if(RecordSet.next())
				{
					tempinterfacename = RecordSet.getString("actionshowname");
				}
				if("".equals(tempinterfacename))
				{
					tempinterfacename = tempinterfaceid;
				}
				tempactionname = "<a title='"+tempinterfacename+"' href='/servicesetting/actionsettingnew.jsp?fromintegration="+fromintegration+"&pointid="+tempinterfaceid+"' target='_blank'>"+tempinterfacename+"</a>";
	  			//tempactionname = "<a title='"+tempinterfacename+"' onclick='return false;' href='#"+tempinterfacename+"'>"+tempinterfacename+"</a>";
	  		}else if("4".equals(tempinterfacetype)){
	  			String args="?workflowId="+workflowid+"&nodeid="+nodeid+"&nodelinkid="+nodelinkid+"&ispreoperator=0&workflowid="+workflowid+"&w_type=1&mark="+tempinterfaceid+"&actionid="+tempactionid;
	  			String addurl="/integration/browse/integrationBrowerMain.jsp"+args;
				tempinterfacename = tempinterfaceid;
	  			//tempactionname = "<a href='"+addurl+"'>"+tempinterfacename+"</a>";
	  			//alter by wshen
	  			tempactionname = "<span  onclick='showEditInterface(this)' style='cursor: pointer;' onfocus='changeColor(1,this)' onblur='changeColor(2,this)'>"+tempinterfacename+
	  			"<input type='hidden' id='url'value='"+addurl+"'>" +
	  			 "<input type='hidden' id='interfaceid' name='interfaceid' value='"+tempinterfacename+"'>" +
	  			  "<INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='"+tempinterfacetype+"'>" +
	  			 "</span>";
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
     oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"' value=<%=tempactionid %>><INPUT type='hidden' name='actionid' value='<%=tempactionid %>'><INPUT type='hidden' name='type' value='"+order+"'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionnodeid\" name=\"actionnodeid\" value='<%=tempnodeid%>'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionispreoperator\" name=\"actionispreoperator\" value='<%=tempispreoperator%>'>"+
     				"<INPUT class=InputStyle type='hidden' id=\"actionnodelinkid\" name=\"actionnodelinkid\" value='<%=tempnodelinkid%>'>";
     oCell.appendChild(oDiv);
     jQuery(oCell).jNice();
     
     oCell = oRow.insertCell(1);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<INPUT type='text' name='actionname' value='<%=actionname %>' maxlength=50 onChange=\"checkinpute8(this,'actionnamespan')\"><SPAN id=actionnamespan> <%if(actionname.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);

     oCell = oRow.insertCell(2);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input class=\"inputstyle\" tzCheckbox=\"true\" type=checkbox id=\"tempisused\" name=\"tempisused\" value=\"1\" onclick=\"setIsUsedVal(this);\"  <%if(tempisused.equals("1")){ %>checked<%} %>><input type=hidden id=\"isused\" name=\"isused\" value=\"<%=tempisused%>\">";
     oCell.appendChild(oDiv);
     reshowCheckBox();
     
     oCell = oRow.insertCell(3);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<input type=\"text\" size=\"35\" style='width:50px!important;' class=\"InputStyle\" id=\"actionorder\" temptitle=\"<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>\" name=\"actionorder\" maxlength=\"10\"  value=\"<%=tempactionorder %>\" onChange=\"checkinpute8(this,'actionorderspan')\"  onKeyPress=\"ItemCount_KeyPress()\" onBlur=\"checknumber1(this);\"><SPAN id=actionorderspan> <%if(tempactionorder.equals("")){ %><img src=\"/images/BacoError_wev8.gif\" align=absmiddle><%} %></SPAN>";
     oCell.appendChild(oDiv);

	//add by wshen
	<%
	if("4".equals(tempinterfacetype)){%>
	oCell = oRow.insertCell(4);
	oDiv = document.createElement("div");
	//oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";
	oDiv.innerHTML="<%=tempactionname%>";
	<%}else{%>
	oCell = oRow.insertCell(4);
	oDiv = document.createElement("div");
	oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";
	<%}%>


	/*oCell = oRow.insertCell(4);
     oDiv = document.createElement("div");
     oDiv.innerHTML="<div class='e8Browser'></div><INPUT class='Inputstyle' type='hidden' id='interfacetype' name='interfacetype' value='<%=tempinterfacetype%>'>";*/

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

$(document).ready(function(){
	init1();
	init2();
});
function submitData(){
	enableAllmenu();
	document.getElementById("operate").value = "save";
	if((document.frmmainaction.nodeid.value==""||document.frmmainaction.ispreoperator.value=="")&&document.frmmainaction.nodelinkid.value=="")
	{
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32364, user.getLanguage())%>");//请选择节点或者出口!
		displayAllmenu();
		return;
	}
	needcheck = "actionname,workflowid,interfaceid,actionorder";
    if(check_form(frmmainaction,needcheck)){
        document.frmmainaction.submit();
    }
    displayAllmenu();
}
function deleteData(){
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(128933,user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.getElementById("operate").value = "delete";
		document.getElementById("actionids").value = "";
        document.frmmainaction.submit();
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
			document.frmmainaction.action="/workflow/action/WsActionEditSet.jsp"
   			document.frmmainaction.submit()
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
function removeRowNew(order)
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
function onSetInterface(event,data,name,paras,tg)
{
	var obj = null;
	//alert(typeof(tg)+"  event : "+event);
	if(typeof(tg)=='undefined'){
		obj= event.target || event.srcElement;
	}
	else
	{
		obj = tg;
	}
	//alert(obj)
	try
	{
		$(obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement).find("#interfacetype").val(data.type)
	}
	catch(e)
	{
		//alert(e);
	}
	//alert(event+"  "+name);
}
var dialogaction = null;
function setInterface()
{
	var url = "";
	var actionlist = $("#actionlist").val();
	dialogaction = new window.top.Dialog();
	dialogaction.currentWindow = window;
	
	if(actionlist=="1")
	{
		url = "/integration/icontent.jsp?isdialog=1&showtype=13&fromintegration=1&formid=<%=formid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&nodelinkid=<%=nodelinkid%>&ispreoperator=<%=ispreoperator%>";
		dialogaction.Width = 1000 ;
		dialogaction.Height = 800 ;
		dialogaction.maxiumnable = false;
	}
	else if(actionlist=="2")
	{
		url = "/integration/icontent.jsp?isdialog=1&showtype=14&fromintegration=1&operate=addws&webservicefrom=1&formid=<%=formid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&nodelinkid=<%=nodelinkid%>&ispreoperator=<%=ispreoperator%>";
		dialogaction.Width = 1000 ;
		dialogaction.Height = 800 ;
		dialogaction.maxiumnable = false;
	}
	else if(actionlist=="3")
	{
		url = "/integration/icontent.jsp?isdialog=1&showtype=15&fromintegration=1&operate=addws&webservicefrom=0&formid=<%=formid%>&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&nodelinkid=<%=nodelinkid%>&ispreoperator=<%=ispreoperator%>";
		dialogaction.Width = 600 ;
		dialogaction.Height = 500 ;
		dialogaction.maxiumnable = false;
	}else if(actionlist=="4"){
		 <%
		 String type=IntegratedSapUtil.getIsHideOldSapNode();
	    if(type.equals("0")){
	    		//老版本的sap功能
	    %>
	    		addurl = "/systeminfo/BrowserMain.jsp?url="+escape("/workflow/action/SapActionEditSet.jsp?operate=adsap&workflowid=<%=workflowid%>&nodeid=<%=nodeid%>&nodelinkid=<%=nodelinkid%>&ispreoperator=<%=ispreoperator%>");
	  <%
	    	}else{
	    		//新版本的sap功能
	    %>
	    		//zzl
				var args="?workflowId=<%=workflowid%>&nodeid=<%=nodeid%>&nodelinkid=<%=nodelinkid%>&ispreoperator=<%=ispreoperator%>&workflowid=<%=workflowid%>&w_type=1";
				addurl="/integration/browse/integrationBrowerMain.jsp"+args;
		  <%
	    	}
	    %>
	    url = addurl;
	    dialogaction.DefaultMax = true;
	    dialogaction.Width = 600 ;
		dialogaction.Height = 500 ;
		dialogaction.callbackfun=reloadDMLAtion
		dialogaction.maxiumnable = true;
	    
	    
	}
	
	dialogaction.URL = url;
	dialogaction.Title = "<%=SystemEnv.getHtmlLabelName(33670 ,user.getLanguage()) %>";
	dialogaction.Drag = true;
	
	dialogaction.show();
}
//add by wshen
function showEditInterface(obj){
	dialogaction = new window.top.Dialog();
	dialogaction.currentWindow = window;
	dialogaction.DefaultMax = true;
	dialogaction.maxiumnable = true;
	dialogaction.URL = $(obj).find("#url").val();
	dialogaction.Title = "<%=SystemEnv.getHtmlLabelName(33670 ,user.getLanguage()) %>";
	dialogaction.callbackfun=reloadDMLAtion;
	dialogaction.Drag = true;
	dialogaction.show();

}

function changeColor(eve,obj){
	alert(eve=="1");
	if(eve=="1"){
		alert("1111111");
		$(obj).css("color","#efefef");
	}else{
		$(obj).css("color","#000");
	}
}

//end add
function AddSAPInterfaceCallback (){
	
}
function closeDialogAction(){
	//alert("dialogaction : "+dialogaction);
	if(dialogaction)
		dialogaction.close();
}

function closeDialog(){
	if(dialogaction){
		dialogaction.close();
	}
}
</script>
