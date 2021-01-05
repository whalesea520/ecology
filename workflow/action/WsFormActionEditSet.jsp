
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wsFormActionManager" class="weaver.workflow.action.WSFormActionManager" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>
<%@ page import="weaver.interfaces.workflow.action.Action" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String isdialog = Util.null2String(request.getParameter("isdialog"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	//是否节点后附加操作
	int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
	
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	String operate = Util.null2String(request.getParameter("operate"));
	int actionid = Util.getIntValue(request.getParameter("actionid"),0);
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	if(actionid <= 0){
		operate = "addws";
	}

	String triggermothod = Util.null2String(request.getParameter("triggermothod"));
	if("".equals(triggermothod))
		triggermothod = "1";
	String formid = Util.null2String(request.getParameter("formid"));
	if(formid.equals("")){
		formid="0";
	}
	int isbill = Util.getIntValue(request.getParameter("isbill"),0);
	
	if(actionid>0 && formid.equals("0")){
		RecordSet.executeSql("select formid, isbill from wsformactionset where id="+actionid);
		if(RecordSet.next()){
			formid = Util.null2String(RecordSet.getString("formid"));
			isbill = Util.getIntValue(RecordSet.getString("isbill"),0);
		}
	}
	
	String actionname = Util.null2String(request.getParameter("actionname"));
	String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
	String wsnamespace = Util.null2String(request.getParameter("wsnamespace"));//web service命名空间
	String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
	String xmltext = Util.null2String(request.getParameter("xmltext"));
	String retstr = Util.null2String(request.getParameter("retstr"));
	int rettype = Util.getIntValue(request.getParameter("rettype"));
	String inpara = Util.null2String(request.getParameter("inpara"));
	int webservicefrom = Util.getIntValue(request.getParameter("webservicefrom"), 1);
	String custominterface = Util.null2String(request.getParameter("custominterface"));
	if("editws".equals(operate)){
		//如果是编辑，根据actionid去取基本配置信息
		wsFormActionManager.setActionid(actionid);
		ArrayList wsActionList = wsFormActionManager.doSelectWsAction(Util.getIntValue(formid),isbill);
		if(wsActionList.size() > 0){
			ArrayList wsAction = (ArrayList)wsActionList.get(0);
			actionid = Util.getIntValue((String)wsAction.get(0));
			actionname = Util.null2String((String)wsAction.get(1));
			wsurl = Util.null2String((String)wsAction.get(2));
			wsoperation = Util.null2String((String)wsAction.get(3));
			xmltext = Util.null2String((String)wsAction.get(4));
			rettype = Util.getIntValue((String)wsAction.get(5), 0);
			retstr = Util.null2String((String)wsAction.get(6));
			inpara = Util.null2String((String)wsAction.get(7));
			webservicefrom = Util.getIntValue((String)wsAction.get(8),1);
			custominterface = Util.null2String((String)wsAction.get(9));
			wsnamespace = Util.null2String((String)wsAction.get(10));
		}
	}
	//System.out.println("11 actionid : "+actionid+" , formid : "+formid+" , isbill : "+isbill);
	RecordSet.executeSql(" select * from workflow_base where id = "+workflowid);
	if(RecordSet.next()){
		isbill=RecordSet.getInt("isbill");
	}
	
	String formname = "";
	if(!"".equals(""+formid))
	{
		String sql = "";
		if("0".equals(""+isbill))
			sql = "select formname from workflow_formbase where id = "+formid;
		else
			sql = "select h.labelname from workflow_bill b ,htmllabelinfo h where b.namelabel=h.indexid and h.languageid="+user.getLanguage()+" and b.id="+formid;
		RecordSet.executeSql(sql);
		if(RecordSet.next())
		{
			formname = RecordSet.getString(1);
		}
	}
	String needcheck = "actionname,formid,wsurl,wsoperation,xmltext";
	//其实这里只要ArrayList放表单数据库的字段列表，Hashtable放字段对应的XML标签名字，一个放该字段是否要传值过去
	
	int cx = 0;
	boolean isused = BaseAction.checkFromActionUsed(""+actionid,"2");
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
		</STYLE>
		<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
		<%@ taglib uri="/browserTag" prefix="brow"%>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
		<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="checkActionName_busi.js"></script>
		<script type="text/javascript" src="/integration/banBackSpace.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(23662, user.getLanguage())+"(WebService)"; //配置接口动作(数据库DML)23662
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
		<%if("1".equals(isdialog)){ %>
		<div class="zDialog_div_content">
		<script language=javascript >
		var parentWin = parent.parent.getParentWindow(parent);
		</script>
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			if(!isused&&actionid>0)
			{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
			if("1".equals(fromintegration))
			{
				//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/integration/formactionlist.jsp?typename="+typename+",_self} ";
				//RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
					<%
					if(!isused&&actionid>0)
					{
					%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
					<%
					}
					%>
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
		<form name="frmmain" method="post" action="/workflow/action/WsFormActionEditOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="<%=operate%>">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid%>">
			<input type="hidden" id="typename" name="typename" value="<%=typename%>">
			<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid %>">
			<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>">
			<input type="hidden" id="ispreoperator" name="ispreoperator" value="<%=ispreoperator %>">
			<input type="hidden" id="nodelinkid" name="nodelinkid" value="<%=nodelinkid %>">
			<%if("1".equals(isdialog)){ %>
			<input type="hidden" name="isdialog" value="<%=isdialog%>">
			<%} %>
			
			<input type="hidden" id="fromintegration" name="fromintegration" value="<%=fromintegration %>">
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
				  <wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
				  <wea:item><!-- action名称 -->
				   <!--282798  [80][90]流程流转集成-注册Webservice接口新建/编辑页面【名称】前后空格问题 增加onblur事件-->
					<input type="text" size="35" style='width:200px!important;' class="InputStyle" autofocus="autofocus" maxlength="20" temptitle="<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>" id="actionname" name="actionname" value="<%=actionname%>" onblur="trimActionName(this.value)" onChange="checkinput('actionname','actionnamespan')">
					<span id="actionnamespan">
						<%
							if (actionname.equals("")){
						%>
						<img src="/images/BacoError_wev8.gif" align=absmiddle>
						<%
							}
						%>
					</span>
				  </wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></wea:item>
						<wea:item>
<%
if(formname.equals("")){
%>
							<brow:browser name="formid" viewType="0" hasBrowser="true" hasAdd="false" 
				                  browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp" 
				                  _callback="showFlowDiv" isMustInput="2" isSingle="true" hasInput="true"
				                  completeUrl="/data.jsp?type=wfFormBrowser&isbill=0" width='280px' browserValue='<%= ""+formid %>' browserSpanValue='<%=formname %>' />
<%
}else{
%>
							<%=formname %>
							<input type="hidden" id="formid" name="formid" value="<%= ""+formid %>">
<%
}
%>
				    		<input type="hidden" id="isbill" name="isbill" value="<%= ""+isbill %>">
						</wea:item>
						<wea:item attributes="{'samePair':'webservicefrom'}"><%=SystemEnv.getHtmlLabelName(32362, user.getLanguage())%></wea:item><!-- 接口来源 -->
						<wea:item attributes="{'samePair':'webservicefrom'}"><!-- 出口名称，显示 -->
							<SELECT class=InputStyle  id="webservicefrom" style='width:80px!important;' name="webservicefrom" onchange="javascript:changeIntegration(this.value);">   
								<option value="1" <%if(webservicefrom==1)out.print("selected");%>>webservice<%=SystemEnv.getHtmlLabelName(32363, user.getLanguage())%></option> <!-- 接口 -->
								<option value="0" <%if(webservicefrom==0)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(23685, user.getLanguage())%></option><!-- 自定义接口 -->
							</SELECT>
						</wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}">WebService <%=SystemEnv.getHtmlLabelName(110, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- WebService地址 -->
							<select id="wsurl" name="wsurl" style='width:120px!important;' onchange="checkinput('wsurl','wsurlimage');ParseWSDL();">
							  	<option></option>
							  	<%
							  	String sqlweb = "select * from wsregiste order by id";
							  	rs.executeSql(sqlweb);
							  	while(rs.next())
							  	{
							  		String webid = rs.getString("id");
							  		String customname = rs.getString("customname");
							  		String tempwsurl = rs.getString("webserviceurl");
							  		String selectstr = "";
							  		if(wsurl.equals(webid))
							  			selectstr = "selected";
							  		out.print("<option value='"+webid+"' "+selectstr+" title='"+tempwsurl+"'>"+customname+"</option>");
							  	}
							  	%>
						  	</select>
						  	<SPAN id=wsurlimage><%if(wsurl.equals("")){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
						</wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}">WebService <%=SystemEnv.getHtmlLabelName(604, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- WebService方法名 -->
							<select id="wsoperation" name="wsoperation" style='width:180px!important;' onchange='checkinput("wsoperation","wsoperationimage");ParseMethod(this,1);'>
						  	<option></option>
						  	<%
						  	if(!"".equals(wsurl))
						  	{
							  	String sqljob = "SELECT * FROM wsregistemethod where mainid="+wsurl+" order by methodname,id";
							  	rs.executeSql(sqljob);
							  	while(rs.next())
							  	{
							  		String methodid = rs.getString("id");
							  		String methodname = rs.getString("methodname");
							  		String methoddesc = rs.getString("methoddesc");
							  		String selectstr = "";
							  		if(wsoperation.equals(methodid))
							  			selectstr = "selected";
							  		out.print("<option value='"+methodid+"' "+selectstr+" title='"+methoddesc+"'>"+methodname+"</option>");
							  	}
						  	}
						  	%>
						  	</select>
						  	<SPAN id=wsoperationimage><%if(wsoperation.equals("")){ %><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%} %></SPAN>
						</wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}">WebService <%=SystemEnv.getHtmlLabelName(32930, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- WebService命名空间 -->
							<input type="text" size="35" style='width:400px!important;' class="InputStyle" maxlength="200" temptitle="WebService<%=SystemEnv.getHtmlLabelName(32930, user.getLanguage())%>" id="wsnamespace" name="wsnamespace" value="<%=wsnamespace%>">
						</wea:item>
					  <!--<td><%=SystemEnv.getHtmlLabelName(32229, user.getLanguage())%></td> 同步岗位接口参数 -->
					 <wea:item attributes="{'samePair':'webserviceout','colspan':'2','isTableList':'true'}">
					  	<div id="mothodparams">
					  		<table class="ListStyle">
					  			<COLGROUP>
					  			<COL width="1%">
					  			<COL width='15%' align='left'>
					  			<COL width='15%' align='left'>
					  			<COL width='25%' align='left'>
					  			<COL width='15%' align='left'>
					  			<COL width='30%' align='left'>
					  			<tr class="header">
					  			   <td>&nbsp;</td>
								   <td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td><!-- 参数名 -->
								   <td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 参数类型 -->
								   <td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td><!-- 是否数组 -->
								   <td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td><!-- 分隔符 -->
								   <td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%>&nbsp;&nbsp;<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(84659, user.getLanguage())%>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN></td><!-- 参数值 -->
								</tr>
								<%
							  	if(!"".equals(wsoperation)&&actionid>0)
							  	{
								  	String sqljob = "SELECT * FROM wsmethodparamvalue where methodid="+wsoperation+" and contenttype=5 and contentid="+actionid+" order by paramname,id";
								  	rs.executeSql(sqljob);
								  	while(rs.next())
								  	{
								  		String methodid = rs.getString("methodid");
								  		String paramname = rs.getString("paramname");
								  		String paramtype = rs.getString("paramtype");
								  		String isarray = rs.getString("isarray");
								  		String paramsplit = rs.getString("paramsplit");
								  		String paramvalue = rs.getString("paramvalue");
								  		String ischeck = "";
								  		if("1".equals(isarray))
								  			ischeck = "checked";
								%>
								<tr>
								   <td>&nbsp;</td>
								   <td><INPUT type='hidden' name='methodtype' value='5'><INPUT class='Inputstyle' type='text' name='paramname' value='<%=paramname %>' readonly></td>
								   <td><INPUT class='Inputstyle' type='text' name='paramtype' value='<%=paramtype %>' readonly></td>
								   <td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' <%=ischeck %> onclick="if(this.checked){this.nextSibling.value=1;}else{this.nextSibling.value=0;}"><INPUT type='hidden' name='isarray' value='<%=isarray %>'></td>
								   <td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value='<%=paramsplit %>'></td>
								   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value="<%=StringEscapeUtils.escapeHtml(paramvalue) %>" onblur='deletebitian()'></td>
							    </tr>
								<%
								  	}
							  	}
							  	%>
							</table>
					  	</div>
					  </wea:item>
					  <wea:item attributes="{'samePair':'webservicein'}"><%=SystemEnv.getHtmlLabelName(32203, user.getLanguage())%></wea:item><!-- 自定义接口名 -->
					  <wea:item attributes="{'samePair':'webservicein'}"><!-- 自定义接口名 -->
							<%
							List l=StaticObj.getServiceIds(Action.class);
							if(!custominterface.equals("")||l.size()>0)
							{
							%>
							<select name="custominterface">
							<%
								for(int i=0;i<l.size();i++)
								{
									String tempcustominterface = (String)l.get(i);
							%>
							<option value='<%=l.get(i)%>' <%if(custominterface.equals(tempcustominterface))out.print("selected");%>><%=l.get(i)%></option>
							<%
								}
							%>
							</select>
							<%
							}
							 %>
						</wea:item>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%>' attributes="{'samePair':'OtherInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
						<wea:item attributes="{'samePair':'webserviceout'}"><%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- 返回值类型 -->
							<select id="rettype" name="rettype" onchange="dochangetitle(this)" style="margin-top:5px!important;">
								<option value='0' <%if(rettype==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(27903,user.getLanguage())%></option>
								<option value='1' <%if(rettype==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(1338,user.getLanguage())%>SQL</option>
							</select>
							<br/>
							<div id="rtdiv0" style="display:<%if(rettype!=0&&rettype!=-1){out.print("none");}%>;margin-top:5px;margin-bottom:5px;"><%=SystemEnv.getHtmlLabelName(27922, user.getLanguage())%></div>
							<div id="rtdiv1" style="display:<%if(rettype!=1){out.print("none");}%>;margin-top:5px;margin-bottom:5px;"><%=SystemEnv.getHtmlLabelName(27923, user.getLanguage())%></div>
						</wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- 返回值 -->
							<textarea style="margin-top:5px;" class="InputStyle" temptitle="<%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%>" id="retstr" name="retstr" rows="4" style="width:90%" onfocus="dosetfocus('retstr')"><%=retstr%></textarea>
							<br>
							<div id="rtdiv2" style="display:<%if(rettype!=1){out.print("none");}%>;margin-top:5px;margin-bottom:5px;">SQL<%=SystemEnv.getHtmlLabelName(27924,user.getLanguage())%>：
							<br>
							update formtable_main_100 set field001='$retstr$' where requestid=$requestid$
							<br>
							<font color="#ff0000"><b><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(27925,user.getLanguage())%></font>
							</div>
						</wea:item>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(17632,user.getLanguage())%>' attributes="{'samePair':'OtherInfo2','groupOperDisplay':'none','itemAreaDisplay':'block'}">
						<wea:item attributes="{'samePair':'webserviceout'}"><%=SystemEnv.getHtmlLabelName(27909, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- 传入参数名称 -->
							<input type="text" size="35" style="margin-top:5px;" class="InputStyle" maxlength="20" temptitle="<%=SystemEnv.getHtmlLabelName(27909, user.getLanguage())%>" id="inpara" name="inpara" value="<%=inpara%>" >
							<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(83673,user.getLanguage())%>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
							<br>
							<div style='margin-top:5px;margin-bottom:5px;'><%=SystemEnv.getHtmlLabelName(27921, user.getLanguage())%></div>
						</wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}">XML<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'webserviceout'}"><!-- XML模板 -->
							<textarea class="InputStyle" temptitle="XML<%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%>" id="xmltext" name="xmltext" rows="7" style="width:90%" onfocus="dosetfocus('xmltext')" onChange="checkinput('xmltext','xmltextspan')"><%=xmltext%></textarea>
							<span id="xmltextspan">
								<%
									if (xmltext.equals("")){
								%>
								<img src="/images/BacoError_wev8.gif" align=absmiddle>
								<%
									}
								%>
							</span>
							<br>
							<a href="/workflow/action/wsxmlmode.xml" target="_blank">XML<%=SystemEnv.getHtmlLabelName(19971,user.getLanguage())%></a>
							<br>
							<font color="#ff0000"><b><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%></b>：<%=SystemEnv.getHtmlLabelName(27926,user.getLanguage())%></font>
						</wea:item>
					</wea:group>
					<%if(Util.getIntValue(formid)!=0){
						String sql = "";
						%>
						<wea:group context='<%=SystemEnv.getHtmlLabelName(18020,user.getLanguage())%>' attributes="{'samePair':'OtherInfo3','groupOperDisplay':'none'}">
						<wea:item attributes="{'samePair':'webserviceout','colspan':'2','isTableList':'true'}">
							<table width="100%" class="ListStyle">
								<colgroup>
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
								<tbody>
									<tr class="header"><td colspan="5"><%=SystemEnv.getHtmlLabelName(26421, user.getLanguage())%></td></tr>
									<tr style="height:1px!important;" class="Line"><th style="height:1px!important;" colspan="5"></th></tr>
									<tr>
										<td><a href="#" onclick="insertIntoTextarea('$requestname$')"><%=SystemEnv.getHtmlLabelName(26876, user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$requestid$')"><%=SystemEnv.getHtmlLabelName(18376, user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$creater$')"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$createdate$')"><%=SystemEnv.getHtmlLabelName(772,user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$createtime$')"><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></a></td>
									</tr>
									<tr style="height:1px!important;">
										<td class="line" style="height:1px!important;" colspan="5"></td>
									</tr>
									<tr>
										<td><a href="#" onclick="insertIntoTextarea('$workflowname$')"><%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$currentuse$')"><%=SystemEnv.getHtmlLabelName(20558,user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$currentnode$')"><%=SystemEnv.getHtmlLabelName(18564,user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('$retstr$')"><%=SystemEnv.getHtmlLabelName(27907,user.getLanguage())%></a></td>
										<td><a href="#" onclick="insertIntoTextarea('\t')"><%=SystemEnv.getHtmlLabelName(27908,user.getLanguage())%></a></td>
									</tr>
									<tr style="height:1px!important;">
										<td class="line" style="height:1px!important;" colspan="5"></td>
									</tr>
								<%
								
								if(isbill == 0){
									sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdict fd left join workflow_formfield ff on ff.fieldid=fd.id left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
								}else{
									sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where (viewtype=0 or viewtype is null) and billid="+formid+" order by bf.dsporder";
								}
								rs.execute(sql);
								cx = 0;
								while(rs.next()){
									int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
									String fieldlabel_t = Util.null2String(rs.getString("fieldlabel"));
									//从那个Hashtable里面去取xml的标签名
									String xmlmark_t = "";
									if(cx%5 == 0){
								%>
									<tr>
								<%}%>
									<td><a href="#" onclick="insertIntoTextarea('$field<%=fieldid_t%>$')"><%=fieldlabel_t%></a></td>
								<%
									cx++;
									if(cx%5 == 0){
								%>
									</tr>
									<tr style="height:1px!important;">
										<td class="line" style="height:1px!important;" colspan="5"></td>
									</tr>
								<%
									}
								}
								while(cx%5 != 0){
								%>
									<td></td>
								<%
									cx++;
									if(cx%5 == 0){
								%>
									</tr>
									<tr style="height:1px!important;">
										<td class="line" style="height:1px!important;" colspan="5"></td>
									</tr>
								<%
									}
								}
								%>
								</tbody>
							</table>

						</wea:item>
					</wea:group>
					<%
					//明细表循环
					if(isbill == 0){
						sql = "select distinct groupid from workflow_formfield where formid="+formid+" and isdetail='1' order by groupid";
					}else{
						sql = "select tablename as groupid, title from Workflow_billdetailtable where billid="+formid+" order by orderid";
					}
					RecordSet.execute(sql);
					int groupCount = 0;
					while(RecordSet.next()){//明细表循环开始
						groupCount++;
						String groupid_tmp = "";
						if(isbill == 0){
							groupid_tmp = ""+Util.getIntValue(RecordSet.getString("groupid"), 0);
						}else{
							groupid_tmp = Util.null2String(RecordSet.getString("groupid"));
						}
					%>
					<wea:group context='<%=SystemEnv.getHtmlLabelName(18021,user.getLanguage())%>' attributes="{'samePair':'OtherInfo4','groupOperDisplay':'none','itemAreaDisplay':'block'}">
						<wea:item attributes="{'samePair':'webserviceout','colspan':'2','isTableList':'true'}">
							<table width="100%" class="ListStyle">
								<colgroup>
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
									<col width="20%">
								<tbody>
									<tr class="header">
										<td colspan="2"><%=SystemEnv.getHtmlLabelName(19325, user.getLanguage())%><%=groupCount%><%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%></td>
										<td colspan="3" align="right"><a href="#" onclick="insertIntoTextarea('$grouphead<%=groupCount%>$')"><%=SystemEnv.getHtmlLabelName(19572,user.getLanguage())%></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onclick="insertIntoTextarea('$grouptail<%=groupCount%>$')"><%=SystemEnv.getHtmlLabelName(19573,user.getLanguage())%></a></td>
									</tr>
									<tr style="height:1px!important;" class="Line"><th style="height:1px!important;" colspan="5"></th></tr>
								<%
								if(isbill == 0){
									sql = "select fd.id, fd.fieldname, fl.fieldlable as fieldlabel from workflow_formdictdetail fd left join workflow_formfield ff on ff.fieldid=fd.id and ff.isdetail='1' and ff.groupid="+groupid_tmp+" left join workflow_fieldlable fl on fl.fieldid=fd.id and fl.langurageid="+user.getLanguage()+" and fl.formid="+formid+" where ff.formid="+formid+" order by fd.id";
								}else{
									sql = "select bf.id, bf.fieldname, hl.labelname as fieldlabel from workflow_billfield bf left join htmllabelinfo hl on hl.indexid=bf.fieldlabel and hl.languageid="+user.getLanguage()+" where bf.detailtable='"+groupid_tmp+"' and bf.viewtype=1 and bf.billid="+formid+" order by bf.dsporder";
								}
								rs.execute(sql);
								cx = 0;
								while(rs.next()){
									int fieldid_t = Util.getIntValue(rs.getString("id"), 0);
									String fieldlabel_t = Util.null2String(rs.getString("fieldlabel"));
									//从那个Hashtable里面去取xml的标签名
									String xmlmark_t = "";
									if(cx%5 == 0){
								%>
									<tr>
								<%}%>
										<td><a href="#" onclick="insertIntoTextarea('$field<%=fieldid_t%>$')"><%=fieldlabel_t%></a></td>
								<%
									cx++;
									if(cx%5 == 0){
								%>
									</tr>
									<tr style="height:1px!important;">
										<td class="line" style="height:1px!important;" colspan="5"></td>
									</tr>
								<%
									}
								}
								while(cx%5 != 0){
								%>
									<td></td>
								<%
									cx++;
									if(cx%5 == 0){
								%>
									</tr>
									<tr style="height:1px!important;">
										<td class="line" style="height:1px!important;" colspan="5"></td>
									</tr>
								<%
									}
								}%>
								</tbody>
							</table>

						</wea:item>
					</wea:group>
					<%}//明细表循环结束%>
					<%} %>
			</wea:layout>
		</form>
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
	</body>
</html>
<script language="javascript">
var textfocus = document.getElementById("xmltext");
function dosetfocus(ename){
	textfocus = document.getElementById(ename);
}
function onClose()
{
	parent.parent.getDialog(parent).close();
}
function changeTriggerMothod(objvalue)
{
	var type = objvalue;
	if(type=="1")
	{
		$("#nodeid").selectbox("show");
		$("#nodeid").selectbox("detach");
        $("#nodeid").selectbox();
        
		$("#ispreoperator").selectbox("show");
		$("#ispreoperator").selectbox("detach");
        $("#ispreoperator").selectbox();
        
		$("#nodeidspan").show();
        
		$("#ispreoperatorspan").show();
        
		$("#nodelinkid").selectbox("hide");
		//$("#nodelinkid").selectbox("detach");
        //$("#nodelinkid").selectbox();
        
		$("#nodelinkidspan").hide();
        
		$("#nodelinkid").val("");
		//$("#nodelinkid").selectbox("detach");
        //$("#nodelinkid").selectbox();
	}
	else if(type=="0")
	{
		$("#nodeid").selectbox("hide");
		//$("#nodeid").selectbox("detach");
        //$("#nodeid").selectbox();
        
		$("#nodeidspan").hide();
		$("#ispreoperator").selectbox("hide");
		//$("#ispreoperator").selectbox("detach");
        //$("#ispreoperator").selectbox();
        
		$("#ispreoperatorspan").hide();
		$("#nodelinkid").selectbox("show");
		$("#nodelinkid").selectbox("detach");
        $("#nodelinkid").selectbox();
        
        
		$("#nodelinkidspan").show();
		$("#nodeid").val("");
		//$("#nodeid").selectbox("detach");
        //$("#nodeid").selectbox();
        
		$("#ispreoperator").val("");
		//$("#ispreoperator").selectbox("detach");
        //$("#ispreoperator").selectbox();
	}
}

function deletebitian() {
	var flag = true;
	$("input[name='paramvalue']").each(
		function() {
			if($(this).val() == "") {
				flag = false;
			}
		}
	)
	
	if(flag) {
		$("#xmltextspan").hide();
	} else {
		$("#xmltextspan").show();
	}
}

function submitData(){
	if(!checkActionName("ws",$("#actionname").val(),$("#actionid").val())) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129932,user.getLanguage())%>！");
		return;
	}
	enableAllmenu();
	
	var needcheck = "<%=needcheck %>";
	if(document.frmmain.webservicefrom.value=="0")
		needcheck = "actionname,formid";
	
	var flag = true;
	$("input[name='paramvalue']").each(
		function() {
			if($(this).val() == "") {
				flag = false;
			}
		}
	)
	
	if(flag) {
		needcheck = needcheck.replace(",xmltext","");
	}
	
    if(check_form(frmmain,needcheck)) {
    	frmmain.operate.value = "save";
        frmmain.submit();
    }
    displayAllmenu();
}

function deleteData(){
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.getElementById("operate").value = "delete";
        document.frmmain.submit();
	}, function () {}, 320, 90,true);
}
function insertIntoTextarea(textvalue){
	var obj = textfocus;
	if(obj){
		obj.focus();
		if(document.selection){
			document.selection.createRange().text = textvalue;
		}else{
			obj.value = obj.value.substr(0, obj.selectionStart) + textvalue + obj.value.substr(obj.selectionEnd);
		}
		checkinput("xmltext","xmltextspan");
	}
}
function dochangetitle(obj){
	var rettype_t = obj.value;
	document.getElementById("rtdiv0").style.display = "none";
	document.getElementById("rtdiv1").style.display = "none";
	document.getElementById("rtdiv2").style.display = "none";
	document.getElementById("rtdiv"+rettype_t).style.display = "";
	if(rettype_t == "1"){
		document.getElementById("rtdiv2").style.display = "";
	}
}
function showFlowDiv(event,datas,name,paras,tg){
	//alert("datas.isBill : "+datas.isbill);
	var isbill = "";
	if(typeof(datas.isbill) == "undefined")
	{
		isbill = datas.isBill;
	}
	else
	{
		isbill = datas.isbill;
	}
	$("#isbill").val(isbill);
	onShowFormSerach();
}
function changeIntegration(objvalue)
{
	var type = objvalue;
	if(type=="1")
	{
		showEle("webserviceout");
		showGroup("OtherInfo");
		showGroup("OtherInfo2");
		showGroup("OtherInfo3");
		showGroup("OtherInfo4");
		hideEle("webservicein");
	}
	else if(type=="0")
	{
		hideEle("webserviceout");
		hideGroup("OtherInfo");
		hideGroup("OtherInfo2");
		hideGroup("OtherInfo3");
		hideGroup("OtherInfo4");
		showEle("webservicein");
	}
	hideEle("webservicefrom");
}
$(document).ready(function(){
	changeIntegration('<%=webservicefrom%>');
	<%if("1".equals(fromintegration)&&actionid<1){ %>
	//changeTriggerMothod(<%=triggermothod%>);
	<%}%>
	deletebitian();
	jQuery(".e8tips").wTooltip({html:true});
});

var METHOD_PARAMS_TABLE_HTML = "<table class='ListStyle'><COLGROUP><COL width='1%' align='left'><COL width='15%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'>"+
	"<tr class='header'>"+
    "<td>&nbsp;</td>"+
    "<td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td>"+
    "<td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%>&nbsp;&nbsp;<SPAN class=\"e8tips\" style=\"CURSOR: hand\" id=remind title=\"<%=SystemEnv.getHtmlLabelName(84659, user.getLanguage())%>\"><IMG src=\"/images/tooltip_wev8.png\" align=\"absMiddle\"/></SPAN></td>"+
    "</tr>";

function ParseWSDL()
{
    //alert("test : "+idx);
    var webserviceurl = jQuery("#wsurl").val();
    if(""!=webserviceurl)
    {
	    var timestamp = (new Date()).valueOf();
	    var params = "operator=getregisteinfo&id="+webserviceurl+"&ts="+timestamp;
	    //alert(params);
	    jQuery.ajax({
	        type: "POST",
	        url: "/integration/WSsettingOperation.jsp",
	        data: params,
	        success: function(msg){
	        	var result = jQuery.trim(msg);
	            if(result!="")
	            {
	            	var jsonarrs = eval(result);
	            	//alert(result);
	            	var selectel = document.getElementById("wsoperation");
	            	selectel.innerHTML = "";
   					selectel.options.add(new Option("",""));
	            	for(var i = 0;i<jsonarrs.length;i++)
	            	{
	            		var methodid = jsonarrs[i].id;
	            		var methodname = jsonarrs[i].methodname;
	            		var methoddesc = jsonarrs[i].methoddesc;
						var eo = new Option(methodname,methodid);
						eo.title = methoddesc;
				   		selectel.options.add(eo);
	            	}
                    checkinput("wsoperation","wsoperationimage");


                    var methoddiv = document.getElementById("mothodparams");
                    methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
                    jQuery(methoddiv).jNice();
                    jQuery(".e8tips").wTooltip({html:true});

	            	jQuery(selectel).selectbox("detach");
        			jQuery(selectel).selectbox();
	            }
	            else
	            {
	            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32394,user.getLanguage()) %>");//获取wsdl描述存在问题，请检查webservice url是否正确!
	            }
	        }
	    });
    }else{
        var selectel = document.getElementById("wsoperation");
        selectel.innerHTML = "";
        selectel.options.add(new Option("",""));

        var eo = new Option("","");
        eo.title = "";
        selectel.options.add(eo);

		checkinput("wsoperation","wsoperationimage");


         var methoddiv = document.getElementById("mothodparams");
         methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";
         jQuery(methoddiv).jNice();
         jQuery(".e8tips").wTooltip({html:true});

        jQuery(selectel).selectbox("detach");
        jQuery(selectel).selectbox();
    }
}
function ParseMethod(obj,type)
{
    //alert("test : "+idx);
    var methodid = jQuery(obj).val();
    if(""!=methodid)
    {
	    var timestamp = (new Date()).valueOf();
	    var params = "operator=getmethodinfo&methodid="+methodid+"&ts="+timestamp;
	    //alert(params);
	    jQuery.ajax({
	        type: "POST",
	        url: "/integration/WSsettingOperation.jsp",
	        data: params,
	        success: function(msg){
	        	var result = jQuery.trim(msg);
	            if(result!="")
	            {
	            	//alert(result)
	            	var jsonarrs = eval(result);
	            	var tempobj;
	            	tempobj = document.getElementById("mothodparams");
	            	changemethodname(type,tempobj,jsonarrs)
	            }
	            else
	            {
	            	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32394,user.getLanguage()) %>");//获取wsdl描述存在问题，请检查webservice url是否正确!
	            }
	        }
	    });
    }else{
        var methoddiv = document.getElementById("mothodparams");
        methoddiv.innerHTML = METHOD_PARAMS_TABLE_HTML + "</table>";;
        jQuery(methoddiv).jNice();
        jQuery(".e8tips").wTooltip({html:true});

	}
}
function changemethodname(type,obj,paramlist)
{
	//alert(paramlist.length);
	if(null!=paramlist&&paramlist.length>0)
	{
		var methoddiv = obj;
		//alert(methoddiv.innerHTML);
		var htmlstr = METHOD_PARAMS_TABLE_HTML;
		for(var i = 0;i<paramlist.length;i++)
		{
			var params = paramlist[i];
			var id = params.id;
			var name = params.paramname;
			var kind = params.paramtype;
			var isarray = params.isarray;
			var ischeck = (isarray=="1")?"checked":"";
			htmlstr += "<tr>"+
			           "<td>&nbsp;</td>"+
					   "<td><INPUT type='hidden' name='methodtype' value='5'><INPUT class='Inputstyle' type='text' name='paramname' value='"+name+"' readonly></td>"+
					   "<td><INPUT class='Inputstyle' type='text' name='paramtype' value='"+kind+"' readonly></td>"+
					   "<td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' "+ischeck+" onclick=\"if(this.checked){this.nextSibling.value=1;}else{this.nextSibling.value=0;}\"><INPUT type='hidden' name='isarray' value='"+isarray+"'></td>"+
					   "<td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value=''></td>"+
					   "<td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value='' onblur='deletebitian()'></td>"+
					   "</tr>";
			//alert(params.name)
		}
		htmlstr += "</table>";
		methoddiv.innerHTML = htmlstr;
		jQuery(methoddiv).jNice();
		jQuery(".e8tips").wTooltip({html:true});
		
		deletebitian();
	}
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
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
});
function onShowFormSerach() {
	document.frmmain.action="/workflow/action/WsFormActionEditSet.jsp";
	document.frmmain.submit()
}
function onBackUrl(url)
{
	document.location.href=url;
}

//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}


//QC 282798  [80][90]流程流转集成-注册Webservice接口新建/编辑页面【名称】前后空格问题 Start
function trimActionName(value){
    value =  $.trim(value);
    document.getElementById("actionname").value = value;
    
     if(isSpecialChar(value)){
		//标识包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
		document.getElementById("actionname").value = "";
		document.getElementById("actionnamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		
		return false;
	}
}
//QC 282798  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格 End
</script>
