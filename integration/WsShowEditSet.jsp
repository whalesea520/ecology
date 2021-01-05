
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="wsActionManager" class="weaver.workflow.action.WSActionManager" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="BrowserXML" class="weaver.servicefiles.BrowserXML" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("intergration:datashowsetting", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String msg = Util.null2String(request.getParameter("msg"));
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String operator = Util.null2String(request.getParameter("operator"));
	int id = Util.getIntValue(request.getParameter("id"),0);
	
	String backto = Util.null2String(request.getParameter("backto"));
	String typename = Util.null2String(request.getParameter("typename"));
	String showname = Util.null2String(request.getParameter("showname"));
	String name = Util.null2String(request.getParameter("name"));
	
	int showclass = Util.getIntValue(Util.null2String(request.getParameter("showclass")),1);
	int datafrom = Util.getIntValue(Util.null2String(request.getParameter("datafrom")),1);
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	String sqltext = Util.null2String(request.getParameter("sqltext"));
	String searchById = Util.null2String(request.getParameter("searchById"));
	
	String wsurl = Util.null2String(request.getParameter("wsurl"));//web service地址
	
	String customhref = Util.null2String(request.getParameter("customhref"));//自定义地址
	String wsoperation = Util.null2String(request.getParameter("wsoperation"));//调用的web service的方法
	String wsworkname = Util.null2String(request.getParameter("wsworkname"));//调用的web service的空间名
	int showtype = Util.getIntValue(Util.null2String(request.getParameter("showtype")));
	int selecttype = Util.getIntValue(Util.null2String(request.getParameter("selecttype")));
	String xmltext = Util.null2String(request.getParameter("xmltext"));
	String inpara = Util.null2String(request.getParameter("inpara"));
	
	String keyfield = Util.null2String(request.getParameter("keyfield"));
	String parentfield = Util.null2String(request.getParameter("parentfield"));
	String showfield = Util.null2String(request.getParameter("showfield"));
	String showpageurl = Util.null2String(request.getParameter("showpageurl"));
	String detailpageurl = Util.null2String(request.getParameter("detailpageurl"));
	String browserfrom = "";
	
	/*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  start*/
	String fieldname1s[] = request.getParameterValues("fieldname1");
	String searchname1s[] = request.getParameterValues("searchname1");
	String fieldtype1s[] = request.getParameterValues("fieldtype");
	String wokflowfieldnames[] = request.getParameterValues("wokflowfieldname");

	String fieldname2s[] = request.getParameterValues("fieldname2");
	String searchname2s[] = request.getParameterValues("searchname2");
	String isshownames[] = request.getParameterValues("isshowname");
	String transqls[] = request.getParameterValues("transql");
	/*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  end*/

	boolean isnew = true;
	if(id>0)
	{
		String sql = "select * from datashowset where id="+id;
		rs.executeSql(sql);
		if(rs.next())
		{
			typename = Util.null2String(rs.getString("typename"));
			showname = Util.null2String(rs.getString("showname"));
			name = Util.null2String(rs.getString("name"));
			showclass = Util.getIntValue(rs.getString("showclass"),0);
			datafrom = Util.getIntValue(rs.getString("datafrom"),0);
			browserfrom = Util.null2String(rs.getString("browserfrom"));
			datasourceid = Util.null2String(rs.getString("datasourceid"));
			sqltext = Util.null2String(rs.getString("sqltext"));
			searchById = Util.null2String(rs.getString("searchById"));
			wsurl = Util.null2String(rs.getString("wsurl"));
			customhref = Util.null2String(rs.getString("customhref"));
			wsoperation = Util.null2String(rs.getString("wsoperation"));
			xmltext = Util.null2String(rs.getString("xmltext"));
			inpara = Util.null2String(rs.getString("inpara"));
			
			showtype = Util.getIntValue(rs.getString("showtype"),0);
			selecttype = Util.getIntValue(rs.getString("selecttype"),0);
			keyfield = Util.null2String(rs.getString("keyfield"));
			parentfield = Util.null2String(rs.getString("parentfield"));
			showfield = Util.null2String(rs.getString("showfield"));
			showpageurl = Util.null2String(rs.getString("showpageurl"));
			detailpageurl = Util.null2String(rs.getString("detailpageurl"));
			wsworkname = Util.null2String(rs.getString("wsworkname"));
			isnew = false;
		}
	}
	ArrayList pointArrayList = BrowserXML.getPointArrayList();
	String pointids = ",";
	for(int i=0;i<pointArrayList.size();i++){
	    String temppointid = (String)pointArrayList.get(i);
	    if(showname.equals(temppointid)) continue;
	    pointids += temppointid+",";
	}
	if(id>0&&!"2".equals(browserfrom))
	{
		response.sendRedirect("/servicesetting/browsersettingnew.jsp?isdialog="+isDialog+"&backto="+typename+"&id="+id+"&browserid="+URLEncoder.encode(showname,"UTF-8") );
		return;
    }
	boolean isused = false;
	if(id>0)
	{
		isused = BrowserXML.isUsed(showname,""+showclass,""+showtype);
	}
	
	String hreftitle = SystemEnv.getHtmlLabelName(82994, user.getLanguage());
	String helptitle = SystemEnv.getHtmlLabelName(82995, user.getLanguage())+
						SystemEnv.getHtmlLabelName(82996, user.getLanguage())+
						SystemEnv.getHtmlLabelName(82997, user.getLanguage())+
						SystemEnv.getHtmlLabelName(82998, user.getLanguage())+
						SystemEnv.getHtmlLabelName(82999, user.getLanguage());
	String helptitle2 = SystemEnv.getHtmlLabelName(131015, user.getLanguage());//QC 288608 [80][90]数据展现集成-显示字段设置中的转换方法提示信息错误
	String helptitle3 = SystemEnv.getHtmlLabelName(132036,user.getLanguage());//QC 294489 [80][90][建议]数据展现集成-查询SQL语句后提示语增加以下内容：若联动主表字段，格式为$主表字段名$；若联动明细表字段，格式为$明细表表名_明细表字段名$

	String urlType = Util.null2String(request.getParameter("urlType"));
	
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
		<STYLE TYPE="text/css">
		table.viewform td.line
		{
			height:1px!important;
		}
		table.ListStyle td.line1
		{
			height:1px!important;
		}
		table.ListStyle tr.line
		{
			height:1px!important;
			padding:0px!important;;
			margin:0px!important;;
		}
		table.ListStyle tr.line td
		{
			height:1px!important;
			padding:0px!important;;
			margin:0px!important;;
		}
		table.setbutton td
		{
			padding-top:10px; 
		}
		table ul#tabs
		{
			width:85%!important;
		}
		</STYLE>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
		<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(32303, user.getLanguage());//"数据展现集成";
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
<%if("1".equals(isDialog)){ %>
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
			if(!isused&&id>0)
			{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/integration/WsShowEditSetList.jsp?typename="+backto+",_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			if(id>0)
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32304, user.getLanguage())+",javascript:viewSearchUrl(),_self} ";//获取查询页面地址
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
					<%
					if(!isused&&id>0)
					{
					%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
					<%
					}
					%>
					<%
					if(id>0)
					{
					%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32304 ,user.getLanguage()) %>" class="e8_btn_top" onclick="viewSearchUrl()"/>
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
		<form name="frmmain" method="post" action="/integration/WsShowEditSetOperation.jsp">
			<input type="hidden" id="operator" name="operator" value="<%=operator%>">
			<input type="hidden" id="id" name="id" value="<%=id%>">
			<input type="hidden" id="backto" name="backto" value="<%=backto %>">
			<input type="hidden" id="typename" name="typename" value="<%=typename %>">
			<%if("1".equals(isDialog)){ %>
			<input type="hidden" name="isdialog" value="<%=isDialog%>">
			<%} %>			
			<input type="hidden" id="fromintegration" name="fromintegration" value="<%=fromintegration %>">
			<wea:layout>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
				  <wea:item><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></wea:item>
				<wea:item><!-- action标识 -->
					<wea:required id="shownamespan" required="true" value='<%=showname %>'>
					<input type="text" size="35" style='font-size:13px;width:280px!important;<%=(id>0?"display:none;":"") %>' class="InputStyle" maxlength="20" temptitle="<%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%>" id="showname" name="showname"  _noMultiLang='true' value="<%=showname%>" onChange="checkinput('showname','shownamespan')" onblur="isExist(this.value)">
					<%if(id>0){%>
					<span style="font-size:13px"><%=showname%></span>
					<%}%>
					</wea:required>
				</wea:item>
				  <wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
				<wea:item><!-- action名称 -->
					<wea:required id="namespan" required="true" value='<%=name %>'>
					<input type="text" size="35" style='width:280px!important;' class="InputStyle" maxlength="20" temptitle="<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>" id="name" name="name" value="<%=name%>" onChange="checkinput('name','namespan')" onblur="checkDataShowName(this.value)">
					</wea:required>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(32305, user.getLanguage())%></wea:item><!-- 展现类型 -->
				<wea:item><!-- action名称 -->
					<!--qc293547  [80][90][缺陷]数据展现集成-新建数据展现集成页面，切换展现类型，不应该清空标识-->
					<SELECT class=InputStyle style='width:120px!important;'  id="showclass" <%if(isused){ %>disabled<%} %>  name="showclass" onchange="changeShowclass(this.value);">   
						<option value="1" <%if(showclass==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32306, user.getLanguage())%></option> <!-- 浏览框 -->
						<option value="2" <%if(showclass==2)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32307, user.getLanguage())%></option><!-- 查询页面 -->
					</SELECT>
					<%if(isused){ %>
					<input type="hidden" id="showclass1" name="showclass1" value="<%=showclass %>">
					<%} %>
				</wea:item>
				<wea:item attributes="{'samePair':'showtype'}"><%=SystemEnv.getHtmlLabelName(23130, user.getLanguage())%></wea:item><!-- 展现方式 -->
				<wea:item attributes="{'samePair':'showtype'}"><!-- 展现方式 -->
					<SELECT class=InputStyle style='width:120px!important;' id="showtype"  name="showtype" onchange="changeShowtype(this.value)">   
						<option value="1" <%if(showtype==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(19525, user.getLanguage())%></option> <!-- 列表式 -->
						<option value="2" <%if(showtype==2)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32308, user.getLanguage())%></option><!-- 树形 -->
						<option value="3" <%if(showtype==3)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(32309, user.getLanguage())%></option><!-- 自定义页面 -->
					</SELECT>
				</wea:item>
				<wea:item attributes="{'samePair':'datafrom'}"><%=SystemEnv.getHtmlLabelName(28006, user.getLanguage())%></wea:item><!-- 数据来源 -->
				<wea:item attributes="{'samePair':'datafrom'}"><!-- action名称 -->
					<SELECT class=InputStyle style='width:160px!important;' id="datafrom"  name="datafrom" onchange="changeIntegration(this.value)">   
						<option value="1" <%if(datafrom==1)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%></option> <!-- 数据库 -->
						<option value="0" <%if(datafrom==0)out.print("selected");%>>WebService</option>
						<option value="2" <%if(datafrom==2)out.print("selected");%>><%=SystemEnv.getHtmlLabelName(82990,user.getLanguage())%></option>
					</SELECT>
				</wea:item>
				<wea:item attributes="{'samePair':'datasource'}"><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'datasource'}">
					<select id="datasourceid" name="datasourceid" style='width:160px!important;'>
						<option></option>
						<%
						    List datasourceList = DataSourceXML.getPointArrayList();
							for (int i = 0; i < datasourceList.size(); i++)
							{
								String pointid = Util.null2String((String) datasourceList.get(i));
						%>
						<option value="datasource.<%=pointid%>" <%if(("datasource."+pointid).equals(datasourceid)){ %>selected<%} %>><%=pointid%></option>
						<%
							}
						%>
					</select>
					
				</wea:item>
				<wea:item attributes="{'samePair':'datasource'}"><%=SystemEnv.getHtmlLabelName(32311, user.getLanguage())%></wea:item><!-- 查询SQL语句 -->
				<wea:item attributes="{'samePair':'datasource'}"><!-- 查询SQL语句 -->
					<wea:required id="sqltextspan" required="true" value='<%=sqltext %>'>
					<textarea class="InputStyle" style='width:480px!important;' temptitle="<%=SystemEnv.getHtmlLabelName(32311, user.getLanguage())%>" id="sqltext" name="sqltext" rows="7" style="width:90%" onChange="checkinput('sqltext','sqltextspan')"><%=sqltext%></textarea>
					</wea:required>
					<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=helptitle %><%=helptitle3 %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				</wea:item>
				<wea:item attributes="{'samePair':'searchById'}"><%=SystemEnv.getHtmlLabelName(128545, user.getLanguage())%></wea:item><!-- 选出值显示SQL语句 -->
				<wea:item attributes="{'samePair':'searchById'}"><!-- 选出值显示SQL语句 -->
					<textarea class="InputStyle" style='width:480px!important;' temptitle="<%=SystemEnv.getHtmlLabelName(128545, user.getLanguage())%>" id="searchById" name="searchById" rows="7" style="width:90%" ><%=searchById%></textarea>
					<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(127946, user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				</wea:item>
				<wea:item attributes="{'samePair':'webservice'}">WebService<%=SystemEnv.getHtmlLabelName(110, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'webservice'}"><!-- WebService地址 -->
					<wea:required id="wsurlimage" required="true" value='<%=wsurl %>'>
					<select id="wsurl" name="wsurl" style='width:160px!important;' onchange="checkinput('wsurl','wsurlimage');ParseWSDL();testWsurl('wsoperation','wsoperationimage');">
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
				  	</wea:required>
				  	
				</wea:item>
				<wea:item attributes="{'samePair':'webservice'}">WebService<%=SystemEnv.getHtmlLabelName(604, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'webservice'}"><!-- WebService方法名 -->
					<wea:required id="wsoperationimage" required="true" value='<%=wsoperation %>'>
					<select id="wsoperation" name="wsoperation" style='width:280px!important;' onchange='checkinput("wsoperation","wsoperationimage");ParseMethod(this,1);'>
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
				  	</wea:required>
				</wea:item>
				<wea:item attributes="{'samePair':'webservice'}">WebService<%=SystemEnv.getHtmlLabelName(32930, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'webservice'}"><!-- WebService空间名 -->
					<wea:required id="wsworknameimage" required="false" value='<%=wsworkname %>'>
					<input type="text" size="500" style='width:280px!important;' class="InputStyle" maxlength="500" temptitle="WebService<%=SystemEnv.getHtmlLabelName(127828, user.getLanguage())%>" id="wsworkname" name="wsworkname" _noMultiLang='true' value="<%=wsworkname%>" >
				  	</wea:required>
				</wea:item>
			  <!--<td><%=SystemEnv.getHtmlLabelName(32229, user.getLanguage())%></td> 同步岗位接口参数 -->
			  <wea:item attributes="{'samePair':'webservice','colspan':'2','isTableList':'true'}">
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
						   <td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%><SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=helptitle %>"><IMG align=absMiddle src="/images/remind_wev8.png"></SPAN></td><!-- 参数值 -->
						</tr>
						<%
					  	if(!"".equals(wsoperation)&&id>0)
					  	{
						  	String sqljob = "SELECT * FROM wsmethodparamvalue where methodid="+wsoperation+" and contenttype=6 and contentid="+id+" order by paramname,id";
						  	rs.executeSql(sqljob);
						  	while(rs.next())
						  	{
						  		String methodid = rs.getString("methodid");
						  		String paramname = rs.getString("paramname");
						  		String paramtype = rs.getString("paramtype");
						  		String isarray = rs.getString("isarray");
						  		String paramsplit = rs.getString("paramsplit");
						  		String paramvalue = rs.getString("paramvalue");
						  		String className = "";
						  		className = className.equals("DataLight")?"DataDark":"DataLight";
						  		String ischeck = "";
						  		if("1".equals(isarray))
						  			ischeck = "checked";
						%>
						<tr class="<%=className %>">
						   <td>&nbsp;</td>
						   <td><INPUT type='hidden' name='methodtype' value='5'><INPUT class='Inputstyle' type='text' name='paramname' value='<%=paramname %>' readonly></td>
						   <td><INPUT class='Inputstyle' type='text' name='paramtype' value='<%=paramtype %>' readonly></td>
						   <td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' <%=ischeck %> onclick="if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}"><INPUT type='hidden' name='isarray' value='<%=isarray %>'></td>
						   <td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value='<%=paramsplit %>'></td>
						   <td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value="<%=StringEscapeUtils.escapeHtml(paramvalue) %>"></td>
					    </tr>
					    <TR style="height:1px;!important;" class=line>
                        	<TD ColSpan=5 style="height:1px;!important;"></TD>
                      	</TR>
						<%
						  	}
					  	}
					  	%>
					</table>
			  	</div>
			  	</wea:item>
			  	<wea:item attributes="{'samePair':'customhref'}"><%=SystemEnv.getHtmlLabelName(82990,user.getLanguage())%></wea:item><!-- 自定义地址 -->
				<wea:item attributes="{'samePair':'customhref'}"><!-- 自定义地址 -->
					<wea:required id="customhrefspan" required="true" value='<%=customhref %>'>
						<textarea class="InputStyle" style='width:480px!important;' temptitle="<%=SystemEnv.getHtmlLabelName(82990,user.getLanguage())%>" id="customhref" name="customhref" rows="7" style="width:90%" onChange="checkinput('customhref','customhrefspan')"><%=customhref%></textarea>
					</wea:required>
					<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=hreftitle%><%=helptitle %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				</wea:item>
				<wea:item attributes="{'samePair':'listparams'}"><%=SystemEnv.getHtmlLabelName(21027, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'listparams'}"><!-- 关键字段 -->
					<wea:required id="keyfieldspan" required="true" value='<%=keyfield %>'>
					<input type="text" size="50" class="InputStyle" style='width:280px!important;' maxlength="100" temptitle="<%=SystemEnv.getHtmlLabelName(21027, user.getLanguage())%>" id="keyfield" name="keyfield" _noMultiLang='true' value="<%=keyfield%>" onChange="checkinput('keyfield','keyfieldspan')">
					</wea:required>
					<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=SystemEnv.getHtmlLabelName(84576,user.getLanguage()) %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(28144, user.getLanguage())%></wea:item><!-- 外部页面地址 -->
				<wea:item><!-- 外部页面地址 -->
					<input type="text" size="55" class="InputStyle" style='width:280px!important;' maxlength="100" temptitle="<%=SystemEnv.getHtmlLabelName(28144, user.getLanguage())%>" id="showpageurl" name="showpageurl" _noMultiLang='true' value="<%=showpageurl%>">
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(124880, user.getLanguage())%></wea:item>
				<wea:item><!-- 链接地址 -->
					<input type="text" size="55" class="InputStyle" style='width:280px!important;' temptitle="<%=SystemEnv.getHtmlLabelName(16208, user.getLanguage())%>" id="detailpageurl" name="detailpageurl" _noMultiLang='true' value="<%=detailpageurl%>">
					<SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=helptitle %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN>
				</wea:item>
			
				<wea:item attributes="{'samePair':'treefield'}"><%=SystemEnv.getHtmlLabelName(32314, user.getLanguage())%></wea:item>
				<wea:item attributes="{'samePair':'treefield'}"><!-- 树形关系字段 -->
					<wea:required id="parentfieldspan" required="true" value='<%=parentfield %>'>
					<%=SystemEnv.getHtmlLabelName(32315, user.getLanguage())%>:<input type="text" style='width:120px!important;' size="20" class="InputStyle" maxlength="100" temptitle="<%=SystemEnv.getHtmlLabelName(32315, user.getLanguage())%>" id="parentfield" name="parentfield" _noMultiLang='true' value="<%=parentfield%>" onChange="checkinput('parentfield','parentfieldspan')">
					</wea:required>
					<wea:required id="showfieldspan" required="true" value='<%=showfield %>'>
					<%=SystemEnv.getHtmlLabelName(19495, user.getLanguage())%>:<input type="text" style='width:120px!important;' size="20" class="InputStyle" maxlength="100" temptitle="<%=SystemEnv.getHtmlLabelName(19495, user.getLanguage())%>" id="showfield" name="showfield" _noMultiLang='true' value="<%=showfield%>" onChange="checkinput('showfield','showfieldspan')">
					</wea:required>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(21903,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
			    <wea:item attributes="{'samePair':'listparams','colspan':'2'}">
			    <div class="listparams listparamstop e8_box demo2" id="tabbox" style='height:42px;'>
	    			<ul class="tab_menu" id="tabs" style="width:85%!important;">
				        <li style='padding-left:0px!important;'><a href="#"><%=SystemEnv.getHtmlLabelName(32316, user.getLanguage())%></a></li><!-- 查询字段设置 -->
				        <li><a href="#"><%=SystemEnv.getHtmlLabelName(32317, user.getLanguage())%></a></li><!-- 显示字段设置 -->
				    </ul>
				   <div id="" class="" style="width:15%;float:right;">
				    	<TABLE width=100% class="setbutton" id='button1' style="display:'';">
	           				<TR>
	           					<TD align=right colSpan=2 style="background: #fff;">
	           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow1()" class="addbtn"/>
	           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(1)" class="delbtn"/>
	           					</TD>
	           				</TR>
	         			</TABLE>
					    <TABLE width=100% class="setbutton" id='button2' style="display:none;">
	           				<TR>
	           					<TD align=right colSpan=2 style="background: #fff;">
	           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow2()" class="addbtn"/>
	           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(2)" class="delbtn"/>
	           					</TD>
	           				</TR>
	         			</TABLE>
				    </div>
				    <div class="tab_box" style="display:none;width:0px;">
				    </div>
				 </div>
			  </wea:item>
			  <wea:item attributes="{'samePair':'listparams listparams1 listparam','colspan':'2','isTableList':'true'}">
                   <TABLE class="ListStyle" id="oTable1" name="oTable1">
                     	<COLGROUP>
                       <COL width="6%">
                       <COL width="20%">
                       <COL width="20%">
                       <COL width="20%">
                       <COL width="20%">
                       <TR class="header">
                           <TD><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this,1)"></TD>
                           <TD><%=SystemEnv.getHtmlLabelName(32318, user.getLanguage())%></TD><!-- 查询显示名 -->
                           <TD><%=SystemEnv.getHtmlLabelName(32319, user.getLanguage())%></TD><!-- 查询字段/XML路径 -->
						   <TD><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></TD><!-- 字段类型 -->
						   <TD><%=SystemEnv.getHtmlLabelName(82991,user.getLanguage())%></TD><!-- 流程联动字段名称 -->
                       </TR>
                       <TR style="height:1px;" class=line>
                        	<TD ColSpan=5 style="height:1px;"></TD>
                      	</TR>   		
                     </TABLE>
                 </wea:item>
			  <wea:item attributes="{'samePair':'listparams listparams2 listparam','colspan':'2','isTableList':'true'}">
                   <TABLE class="ListStyle" id="oTable2" name="oTable2">
                     	<COLGROUP>
                       <COL width="6%">
                       <COL width="20%">
                       <COL width="17%">
                       <COL width="6%">
                       <COL width="17%">
                       <TR class="header">
                           <TD><INPUT type="checkbox" name="chkAll" onClick="chkAllClick(this,2)"></TD>
                           <TD><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></TD><!-- 字段显示名 -->
                           <TD><%=SystemEnv.getHtmlLabelName(32320, user.getLanguage())%></TD><!-- 显示字段/XML路径 -->
                           <TD><%=SystemEnv.getHtmlLabelName(22965, user.getLanguage())%></TD><!-- 标题栏 -->
						<TD><%=SystemEnv.getHtmlLabelName(32321, user.getLanguage())%><SPAN class="e8tips" style="CURSOR: hand" id=remind title="<%=helptitle2 %>"><IMG src="/images/tooltip_wev8.png" align="absMiddle"/></SPAN></TD><!-- 转换方法 -->
                       </TR>
                       <TR style="height:1px;" class=line>
                        	<TD ColSpan=5 style="height:1px;"></TD>
                      	</TR>   		
                   </TABLE>
			  </wea:item>
		   </wea:group>
		 </wea:layout>
		</form>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onClose();"></input>
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
function onClose()
{
	parentWin.closeDialog();
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
	jQuery(".e8tips").wTooltip({html:true});
});
var needcheck = "";
function submitData(){
	enableAllmenu();

    //验证是否有主键显示字段是否有主键
    //1.获取主键值
//	alert($("#datafrom").val())
	if ($("#datafrom").val() == "0") {
        var keyfieldValue = jQuery("#keyfield").val()
//        alert(keyfieldValue)
        var searchNames2 = jQuery("input[name='searchname2']");
        var hasKeyfield = false;
        jQuery.each(searchNames2, function() {
            //QC272885   [80][90]数据展现集成-解决浏览框和查询页面中设置显示字段,输入空格能进行保存的问题  去除前后空格
            if ($.trim($(this).val()) == keyfieldValue) {
                hasKeyfield = true;
            }
        });
        if (!hasKeyfield) {
            <%--top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130565,user.getLanguage())%>!");--%>
//			top.Dialog.alert("请在显示字段设置中添加上主键")
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(382141, user.getLanguage())%>")
            displayAllmenu();
            return;
        }
	}



    var fieldNames2 = jQuery("input[name='fieldname2']");
    var hasNullFieldNames2 = false;
    jQuery.each(fieldNames2, function() {
    	//QC272885   [80][90]数据展现集成-解决浏览框和查询页面中设置显示字段,输入空格能进行保存的问题  去除前后空格
        if ($.trim($(this).val()) == "") {
            hasNullFieldNames2 = true;
        }
    });
    var searchNames2 = jQuery("input[name='searchname2']");
    var hasNullSearchNames2 = false;
    jQuery.each(searchNames2, function() {
    	//QC272885   [80][90]数据展现集成-解决浏览框和查询页面中设置显示字段,输入空格能进行保存的问题  去除前后空格
        if ($.trim($(this).val()) == "") {
            hasNullSearchNames2 = true;
        }
    });
    if(hasNullFieldNames2 || hasNullSearchNames2){
    	//QC273083  [80][90]数据展现集成-新增显示字段设置,若未填写,修改系统提示为[必要信息不完整，红色叹号为必填项！]
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130565,user.getLanguage())%>!");
		displayAllmenu();
		return;
    }


	if((document.frmmain.showclass.value=="1"&&document.frmmain.showtype.value=="1")||document.frmmain.showclass.value=="2")
	{
		var oRow = document.getElementById("oTable2");
		var oRowIndex = oRow.rows.length;
		//alert("oRowIndex : "+oRowIndex);
		if(oRowIndex<3)
		{
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82992,user.getLanguage())%>!");
			displayAllmenu();
			return;
		}
		var hasshowname = false;
	    var isshownames = jQuery("input[name='isshowname']");
		jQuery.each(isshownames, function(j, n){
	      //alert( "Item #" + i + ": " + n );
	      //alert("i : "+i+"    " +$(this).attr("checked"));
	      if($(this).val()=="1")
	      {
	        hasshowname = true;
	      }
	    });
	    if(!hasshowname)
	    {
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82993,user.getLanguage())%>!");//请设置标题栏字段
	    	displayAllmenu();
	      	return;
	    }
	    
	    var haveId = false;
	   $("#oTable2  input[name='searchname2']").each(function(){
	    		if($(this).val().toLowerCase()=="id"){
	    			haveId = true;
	    		}
	    });
	    if(haveId){
	    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83298,83297,31835",user.getLanguage())%> ID!");//不支持显示ID
	    	displayAllmenu();
	      	return;
	    }
    }
	needcheck = "showname,name";
	document.getElementById("operator").value = "save";
	if(document.frmmain.showclass.value=="1"&&document.frmmain.showtype.value=="2")
		needcheck+=",parentfield,showfield";
	else if(document.frmmain.showclass.value=="1"&&document.frmmain.showtype.value=="3")
		needcheck+=",customhref";//QC 273089 [80][90]数据展现集成-解决展现类型为浏览框,展现方式为自定义页面,必填项判断错误的问题

	if(document.frmmain.showclass.value=="2"){//QC 294555 [80][90][建议]数据展现集成-查询页面的展现方式应该默认是列表式
		jQuery("#showtype").val("1");
	}

	if(document.frmmain.datafrom.value=="1"&&document.frmmain.showtype.value!="3")
		needcheck += ",sqltext,keyfield";
	if(document.frmmain.datafrom.value=="0"&&document.frmmain.showtype.value!="3")
		needcheck += ",wsurl,wsoperation,xmltext";
	if(document.frmmain.datafrom.value=="2"&&document.frmmain.showtype.value!="3")
		needcheck += ",customhref";
	
	if(isExist(document.getElementById("showname").value))
	{
    if(check_form(frmmain,needcheck)){
        document.frmmain.submit();
    }
	}
    displayAllmenu();
}
function deleteData(){
    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		document.getElementById("operator").value = "delete";
        document.frmmain.submit();
    }, function () {}, 320, 90);
}
	function addRow1()
    {
    	var order = "1";
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
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(0);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='paramids_"+order+"' value='-1'><INPUT type='hidden' name='type' value='"+order+"'>";
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        oCell = oRow.insertCell(1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='text' name='fieldname1' id='fieldname1' onblur=\"checkFieldShowName(this, 0)\" value='' maxlength=50><SPAN></SPAN> ";
        oCell.appendChild(oDiv);
        
		
		
        oCell = oRow.insertCell(2);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='text' name='searchname1' _noMultiLang='true' value='' maxlength=200><SPAN></SPAN>";                     
        oCell.appendChild(oDiv);
        
       
        oCell = oRow.insertCell(3);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<SELECT class=InputStyle id=\"fieldtype\"  name=\"fieldtype\">"+
						"	<option value=\"1\"><%=SystemEnv.getHtmlLabelName(607, user.getLanguage())%></option> "+
						"	<option value=\"2\" selected><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></option>"+
						"</SELECT>";
        oCell.appendChild(oDiv);
        jQuery(oCell).find("select").selectbox("detach");
        jQuery(oCell).find("select").selectbox();
        
        oCell = oRow.insertCell(4);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='text' name='wokflowfieldname' _noMultiLang='true' value='' maxlength=50><SPAN></SPAN>";                     
        oCell.appendChild(oDiv);
    }
    function addRow2()
    {
    	var order = "2";
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
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(0);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='paramids_"+order+"' value='-1'><INPUT type='hidden' name='type' value='"+order+"'>";
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        oCell = oRow.insertCell(1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='fielnameSearchId_" + oRowIndex + "' name='fieldname2' onblur=\"checkinput('fielnameSearchId_" + oRowIndex + "','fieldnamespan" + oRowIndex + "',this.getAttribute('viewtype'));checkFieldShowName(this, 2)\" style='width:80%' value='' maxlength=50><span id='fieldnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
        oCell.appendChild(oDiv);
        
		
		
        oCell = oRow.insertCell(2);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='searchnameSearchId_" + oRowIndex + "' name='searchname2' _noMultiLang='true' value='' maxlength=200 onblur=\"checkinput('searchnameSearchId_" + oRowIndex + "','searchnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%'><span id='searchnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
        oCell.appendChild(oDiv);
        
        oCell = oRow.insertCell(3);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='' onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='0'>";                     
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        oCell = oRow.insertCell(4);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<textarea class=\"InputStyle\" temptitle=\"<%=SystemEnv.getHtmlLabelName(32322, user.getLanguage())%>\" id=\"transql\" name=\"transql\" rows=\"3\" style=\"width:90%\"></textarea>";
        oCell.appendChild(oDiv);
        
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
		var count = 0;//删除数据选中个数
		jQuery("input[name='paramid_"+order+"']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
		});
		//alert(v+":"+count);
		if(count==0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		}else{
    	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
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
/*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  start*/
function init0_1(){
   <%if(fieldname1s != null){
          for(int i=0;i<fieldname1s.length;i++){%>

            var rownum = document.getElementById("oTable1").rows.length;
			var oRow = document.getElementById("oTable1").insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;

	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "DataLight";
	        }
	        else
	        {
	            oRow.className = "DataDark";
	        }

			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type=checkbox name='paramid_1'><INPUT type='hidden' name='paramids_1' value='-1'><INPUT type='hidden' name='type' value='1'><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();

	        oCell = oRow.insertCell(1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='text' name='fieldname1' value='<%=fieldname1s[i]%>' onblur=\"checkFieldShowName(this.value, this)\" maxlength=50><SPAN></SPAN>";
	        oCell.appendChild(oDiv);



	        oCell = oRow.insertCell(2);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='text' name='searchname1'  _noMultiLang='true' value='<%=searchname1s[i]%>' maxlength=200><SPAN></SPAN>";
	        oCell.appendChild(oDiv);

	        oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<SELECT class=InputStyle id=\"fieldtype\"  name=\"fieldtype\">"+
							"	<option value=\"1\" <%if("1".equals(fieldtype1s[i])){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(607, user.getLanguage())%></option> "+
							"	<option value=\"2\" <%if("2".equals(fieldtype1s[i])){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></option>"+
							"</SELECT>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).find("select").selectbox("detach");
        	jQuery(oCell).find("select").selectbox();

        	oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='text' name='wokflowfieldname' value='<%=wokflowfieldnames[i]%>' maxlength=50><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
   <%  }
    }%>

}
function init0_2(){
   <%if(fieldname2s != null){
       for(int i=0;i<fieldname2s.length;i++){%>
         var rownum = document.getElementById("oTable2").rows.length;
			var oRow = document.getElementById("oTable2").insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;

	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "DataLight";
	        }
	        else
	        {
	            oRow.className = "DataDark";
	        }

			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type=checkbox name='paramid_2'><INPUT type='hidden' name='paramids_2' value='-1'><INPUT type='hidden' name='type' value='2'><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();

			oCell = oRow.insertCell(1);
			oDiv = document.createElement("div");
			oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='fielnameSearchId_" + oRowIndex + "' name='fieldname2' value='<%=fieldname2s[i]%>' onblur=\"checkinput('fielnameSearchId_" + oRowIndex + "','fieldnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%' value='' maxlength=50><span id='fieldnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'></span>";
			oCell.appendChild(oDiv);



			oCell = oRow.insertCell(2);
			oDiv = document.createElement("div");
			oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='searchnameSearchId_" + oRowIndex + "' name='searchname2' _noMultiLang='true' value='<%=searchname2s[i]%>' maxlength=200 onblur=\"checkinput('searchnameSearchId_" + oRowIndex + "','searchnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%'><span id='searchnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'></span>";
			oCell.appendChild(oDiv);

			oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        //alert('<%=isshownames[i]%>');
	        oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='' <%if("1".equals(isshownames[i])){%>checked<%}%> onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='<%=isshownames[i]%>'>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();

	        oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<textarea class=\"InputStyle\" temptitle=\"<%=SystemEnv.getHtmlLabelName(32322, user.getLanguage())%>\" id=\"transql\" name=\"transql\" rows=\"3\" style=\"width:90%\"><%=transqls[i]%></textarea>";
	        oCell.appendChild(oDiv);
   <%  }
   }%>
}
/*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  end*/
function init1()
{
	
<%
	if(id>0)
	{
		rs.executeSql("SELECT * FROM datasearchparam where mainid="+id+" order by id");
		String type = "1";
		while (rs.next()) 
		{
	        String fieldname = Util.null2String(rs.getString("fieldname"));
	        String searchname = Util.null2String(rs.getString("searchname"));
	        String fieldtype = Util.null2String(rs.getString("fieldtype"));
	        String wokflowfieldname = Util.null2String(rs.getString("wokflowfieldname"));
%>
			var rownum = document.getElementById("oTable<%=type%>").rows.length;
			var oRow = document.getElementById("oTable<%=type%>").insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;
	
	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "DataLight";
	        }
	        else
	        {
	            oRow.className = "DataDark";
	        }
		
			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type=checkbox name='paramid_<%=type %>'><INPUT type='hidden' name='paramids_<%=type %>' value='-1'><INPUT type='hidden' name='type' value='<%=type%>'><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        oCell = oRow.insertCell(1);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='text' name='fieldname1'  value='<%=fieldname%>' onblur=\"checkFieldShowName(this, 1)\" maxlength=50 ><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
	        
			
			
	        oCell = oRow.insertCell(2);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='text' name='searchname1'  _noMultiLang='true' value='<%=searchname%>' maxlength=200><SPAN></SPAN>";                     
	        oCell.appendChild(oDiv);
	        
	        oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<SELECT class=InputStyle id=\"fieldtype\"  name=\"fieldtype\">"+
							"	<option value=\"1\" <%if("1".equals(fieldtype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(607, user.getLanguage())%></option> "+
							"	<option value=\"2\" <%if("2".equals(fieldtype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></option>"+
							"</SELECT>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).find("select").selectbox("detach");
        	jQuery(oCell).find("select").selectbox();
        	
        	oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='text' name='wokflowfieldname' value='<%=wokflowfieldname%>' maxlength=50><SPAN></SPAN>";                     
	        oCell.appendChild(oDiv);
<%
		}
	}
%>
}
function init2()
{
	
<%
	if(id>0)
	{
		rs.executeSql("SELECT * FROM datashowparam where mainid="+id+" order by id");
		String type = "2";
		while (rs.next()) 
		{
	        String fieldname = Util.null2String(rs.getString("fieldname"));
	        String searchname = Util.null2String(rs.getString("searchname"));
	        String isshowname = Util.null2String(rs.getString("isshowname"));
	        String transql = Util.null2String(rs.getString("transql")).replaceAll("[\\n\\r\\t]"," ");
%>
			var rownum = document.getElementById("oTable<%=type%>").rows.length;
			var oRow = document.getElementById("oTable<%=type%>").insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;
	
	        if (0 == oRowIndex % 2)
	        {
	            oRow.className = "DataLight";
	        }
	        else
	        {
	            oRow.className = "DataDark";
	        }
		
			/*============ 选择 ============*/
	        var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type=checkbox name='paramid_<%=type %>'><INPUT type='hidden' name='paramids_<%=type %>' value='-1'><INPUT type='hidden' name='type' value='<%=type%>'><SPAN></SPAN>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();

			oCell = oRow.insertCell(1);
			oDiv = document.createElement("div");
			oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='fielnameSearchId_" + oRowIndex + "' name='fieldname2' value='<%=fieldname%>' onblur=\"checkFieldShowName(this, 2);checkinput('fielnameSearchId_" + oRowIndex + "','fieldnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%' value='' maxlength=50><span id='fieldnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'></span>";
			oCell.appendChild(oDiv);



			oCell = oRow.insertCell(2);
			oDiv = document.createElement("div");
			oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='searchnameSearchId_" + oRowIndex + "' name='searchname2' _noMultiLang='true' value='<%=searchname%>' maxlength=200 onblur=\"checkinput('searchnameSearchId_" + oRowIndex + "','searchnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%'><span id='searchnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'></span>";
			oCell.appendChild(oDiv);

			oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        //alert('<%=isshowname%>');
	        oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='' <%if("1".equals(isshowname)){%>checked<%}%> onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='<%=isshowname%>'>";                     
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
		        
	        oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<textarea class=\"InputStyle\" temptitle=\"<%=SystemEnv.getHtmlLabelName(32322, user.getLanguage())%>\" id=\"transql\" name=\"transql\" rows=\"3\" style=\"width:90%\"><%=transql%></textarea>";
	        oCell.appendChild(oDiv);
<%
		}
	}
%>
}
function changeShowname(obj)
{
	//alert(obj);
	changeCheckboxStatus(jQuery(".tempisshowname"),false);
	//jQuery(".tempisshowname").attr("checked",false);
    jQuery(".isshowname").val("0");
	changeCheckboxStatus(jQuery(obj),true);
	if(obj.checked)
	{
		obj.parentElement.nextSibling.value=1;
		jQuery(obj.nextSibling).addClass("jNiceChecked");
	}
	else
	{
		obj.parentElement.nextSibling.value=0;
	}
}
function changeIntegration(objvalue)
{
	var type = objvalue;
	//alert(type);
	if(type=="1")
	{
		showEle("datasource");
		if(jQuery("#showclass").val() == '1')
			showEle("searchById");
		hideEle("webservice");
		hideEle("customhref");
	}
	else if(type=="0")
	{
		hideEle("datasource");
		hideEle("searchById");
		showEle("webservice");
		hideEle("customhref");
	}
	else if(type=="2")
	{
		hideEle("datasource");
		hideEle("searchById");
		hideEle("webservice");
		showEle("customhref");
	}
}
function showListTab()
{
    try
	{
		jQuery('#tabbox').Tabs({
	    	getLine:0,
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
				hideEle("listparams1");
				hideEle("listparams2");
				showEle("listparams"+activeindex);
				$("#button"+activeindex).show();
			}
			catch(e)
			{
			}
			return false;
		});
	
	};
	/*调用方法如下：*/
	$.jqtab("#tabs","listparam1","click");
	$("#tabs").find("li:first").click();
}
function changeShowclass(objvalue)
{
	var type = objvalue;
	if(type=="1")
	{
		//showEle("browsertype");
		showEle("showtype");
		showEle("searchById");
		changeShowtype(document.frmmain.showtype.value);
	}
	else
	{
		hideEle("showtype");
		hideEle("searchById");
		//hideEle("browsertype");
		showGroup("SetInfo");
		hideEle("treefield");
		showEle("datafrom");
		showEle("webservice");
		showEle("customhref");
		showEle("listparams");
		hideEle("listparams2");
		showListTab();
		changeIntegration(document.frmmain.datafrom.value);
	}
	
}
function changeShowtype(objvalue)
{
	var type = objvalue;
	if(type=="2")
	{
		showEle("treefield");
		hideGroup("SetInfo");
		showEle("datafrom");
		hideEle("webservice");
		hideEle("customhref");
		showEle("listparams");
		hideEle("listparams1");
		hideEle("listparams2");
		hideEle("listparamstop");
		showEle("datasource");
		showEle("searchById");
		changeIntegration(document.frmmain.datafrom.value);
	}
	else if(type=="1")
	{
		showListTab();
		hideEle("treefield");
		showGroup("SetInfo");
		showEle("datafrom");
		showEle("webservice");
		showEle("customhref");
		showEle("listparams");
		hideEle("listparams2");
		showEle("datasource");
		if(jQuery("#showclass").val() == '1')
			showEle("searchById");
		changeIntegration(document.frmmain.datafrom.value);
	}
	else if(type=="3")
	{
		hideEle("treefield");
		hideGroup("SetInfo");
		hideEle("datafrom");
		hideEle("webservice");
		hideEle("customhref");
		showEle("customhref");
		hideEle("listparams");
		hideEle("datasource");
		hideEle("searchById");
	}
	
}

$(document).ready(function(){
	<%if("1".equals(msg)){%>
	    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32323, user.getLanguage())%>!");//名称已存在，请重新填写
		ParseMethod($("#wsoperation"),1);/*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  */
	<%}%>
	init1();
	init2();
	/*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  start*/
	<%if(fieldname1s != null){%>
         var size1 = "<%=fieldname1s.length%>";
		 if(size1 != 0){
		     init0_1();
		 }
   <% }%>
   <%if(fieldname2s != null){%>
		 var size2 = "<%=fieldname2s.length%>";
		 if(size2 != 0){
		     init0_2();
		 }
   <% }%>
    /*QC304650 [80][90]数据展现集成-解决新建时设置数据来源为Webservice且标识重复，点击保存，参数和显示字段没有回显的问题  end*/
	changeIntegration('<%=datafrom%>');
	//changeShowtype('<%=showtype%>');
	changeShowclass('<%=showclass%>');
	
});
function viewSearchUrl()
{
	if(document.frmmain.showclass.value==2)
    	prompt("","/integration/integrationTab.jsp?urlType=5&showtypeid=<%=id%>");
    else
    {
    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32324, user.getLanguage())%>!");//当前展现集成不是查询页面，请重新操作
    	return;
    }

}
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
                    var htmlstr = "<table class='ListStyle'><COLGROUP><COL width='1%' align='left'><COL width='15%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'><COL width='15%' align='left'><COL width='30%' align='left'>";
                    htmlstr += "<tr class='header'>"+
                        "<td>&nbsp;</td>"+
                        "<td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td>"+
                        "<td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td>"+
                        "<td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td>"+
                        "<td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td>"+
                        "<td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=helptitle %>'><IMG align=absMiddle src='/images/remind_wev8.png'></SPAN></td>"+
                        "</tr>";
                    methoddiv.innerHTML = htmlstr + "</table>";
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
       // alert("1");
        var selectel = document.getElementById("wsoperation");
        selectel.innerHTML = "";
        selectel.options.add(new Option("",""));

		var eo = new Option("","");
		eo.title = "";
		selectel.options.add(eo);
        checkinput("wsoperation","wsoperationimage");


        var methoddiv = document.getElementById("mothodparams");
        var htmlstr = "<table class='ListStyle'><COLGROUP><COL width='1%' align='left'><COL width='15%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'><COL width='15%' align='left'><COL width='30%' align='left'>";
        htmlstr += "<tr class='header'>"+
            "<td>&nbsp;</td>"+
            "<td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td>"+
            "<td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td>"+
            "<td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td>"+
            "<td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td>"+
            "<td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=helptitle %>'><IMG align=absMiddle src='/images/remind_wev8.png'></SPAN></td>"+
            "</tr>";
        methoddiv.innerHTML = htmlstr + "</table>";
        jQuery(methoddiv).jNice();
        jQuery(".e8tips").wTooltip({html:true});
        jQuery(selectel).selectbox("detach");
        jQuery(selectel).selectbox();
	}
}
function ParseMethod(obj,type)
{
    var tempobj = document.getElementById("mothodparams");
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
	        success: function(msg) {
	        	var result = jQuery.trim(msg);
	        	var jsonarrs = eval(result);
            	changemethodname(type,tempobj,jsonarrs);
	        }
	    });
    } else {
    	changemethodname(type,tempobj,"");
    }
}
function changemethodname(type,obj,paramlist)
{
	var methoddiv = obj;
	methoddiv.innerHTML = "";
	var htmlstr = "<table class='ListStyle'><COLGROUP><COL width='1%' align='left'><COL width='15%' align='left'><COL width='15%' align='left'><COL width='25%' align='left'><COL width='15%' align='left'><COL width='30%' align='left'>";
	htmlstr += "<tr class='header'>"+
				   "<td>&nbsp;</td>"+
				   "<td><%=SystemEnv.getHtmlLabelName(20968, user.getLanguage())%></td>"+
				   "<td><%=SystemEnv.getHtmlLabelName(561, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td>"+
				   "<td><%=SystemEnv.getHtmlLabelName(32392, user.getLanguage())%></td>"+
				   "<td><%=SystemEnv.getHtmlLabelName(32393, user.getLanguage())%></td>"+
				   "<td><%=SystemEnv.getHtmlLabelName(17637, user.getLanguage())%><SPAN class='e8tips' style='CURSOR: hand' id=remind title='<%=helptitle %>'><IMG align=absMiddle src='/images/remind_wev8.png'></SPAN></td>"+
				   "</tr>";
	
	if(paramlist != "") {
		for(var i = 0;i<paramlist.length;i++)
		{
			var params = paramlist[i];
			var id = params.id;
			var name = params.paramname;
			var kind = params.paramtype;
			var isarray = params.isarray;
			var ischeck = (isarray=="1")?"checked":"";
			var oRowIndex = i;
			var className = "";
	        if (0 == oRowIndex % 2)
	        {
	            className = "DataLight";
	        }
	        else
	        {
	            className = "DataDark";
	        }
			htmlstr += "<tr class='"+className+"'>"+
					   "<td>&nbsp;</td>"+
					   "<td><INPUT type='hidden' name='methodtype' value='5'><INPUT class='Inputstyle' type='text' name='paramname' value='"+name+"' readonly></td>"+
					   "<td><INPUT class='Inputstyle' type='text' name='paramtype' value='"+kind+"' readonly></td>"+
					   "<td><INPUT class='Inputstyle' type='checkbox' name='tempisarray' "+ischeck+" onclick=\"if(this.checked){this.parentElement.nextSibling.value=1;}else{this.parentElement.nextSibling.value=0;}\"><INPUT type='hidden' name='isarray' value='"+isarray+"'></td>"+
					   "<td><INPUT class='Inputstyle' type='text' maxLength=10 name='paramsplit' value=''></td>"+
					   "<td><INPUT class='Inputstyle' type='text' maxLength=1000 name='paramvalue' value=''></td>"+
					   "</tr>";
		}
	}
	htmlstr += "</table>";
	methoddiv.innerHTML = htmlstr;
	jQuery(methoddiv).jNice();
	jQuery(".e8tips").wTooltip({html:true});
}
function onBackUrl(url)
{
	document.location.href=url;
}
function setDataSource()
{
	parent.document.location.href="/integration/integrationTab.jsp?urlType=3"
}
function setWebservice()
{
	parent.document.location.href="/integration/integrationTab.jsp?urlType=1"
}
//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}
//
function partSpecialChar(str) {
    var reg = /["<>]/;
    return reg.test(str);
}

//是否含有中文（也包含日文和韩文）
function isChineseChar(str){   
   var reg = /[\u4E00-\u9FA5\uF900-\uFA2D]/;
   return reg.test(str);
}
//是否含有全角符号的函数
function isFullwidthChar(str){
   var reg = /[\uFF00-\uFFEF]/;
   return reg.test(str);
}
function checkDataShowName(dataShowName) {
    if(isSpecialChar(dataShowName)){
        //标识包含特殊字符，请重新输入！
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
        document.getElementById("name").value = "";
        document.getElementById("namespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";

        return false;
    }
    return true;
}

//QC295440 [80][90]数据展现集成-解决显示字段的字段显示名中含有特殊字符导致自定义浏览按钮出错的问题 -start
//输入"" 和<>时会提示错误
//校验显示字段
//position=0代表第一个tab页，2代表第二个tab页
function checkFieldShowName(element, position) {
    if(isSpecialChar(element.value)) {
        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
		element.value = "";
		if (position == 2)
        	document.getElementById("fieldnamespan"+element.id.charAt(element.id.length-1)).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
    }
}
//QC295440 [80][90]数据展现集成-解决显示字段的字段显示名中含有特殊字符导致自定义浏览按钮出错的问题 -end
function isExist(newvalue){
	newvalue = $.trim(newvalue);//qc282816  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格
	if(<%=isnew%>){
	if(isSpecialChar(newvalue)){
		//标识包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128458,user.getLanguage())%>");
        document.getElementById("showname").value = "";
        document.getElementById("shownamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isChineseChar(newvalue)){
		//标识包含中文，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128459,user.getLanguage())%>");
        document.getElementById("showname").value = "";
        document.getElementById("shownamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	if(isFullwidthChar(newvalue)){
		//标识包含全角符号，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128460,user.getLanguage())%>");
        document.getElementById("showname").value = "";
        document.getElementById("shownamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
        
        return false;
	}
	}
	document.getElementById("showname").value = newvalue;//qc282816  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格
	return true;
}
//QC 286718  [80][90]数据展现集成-新建/编辑页面数据来源为Webservice时，切换WebService 地址导致WebService方法红色感叹号丢失问题
//只要wsurl改变会自动将下面的值清空，所以无论怎么样都会出现!号
function testWsurl(elementname,spanid){
	$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
}
</script>
<script language="vbs">
Sub onShowWorkFlowSerach(inputname, spanname)
    retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp")
    temp=document.all(inputname).value
    If (Not IsEmpty(retValue)) Then
        If retValue(0) <> "0" Then
            document.all(spanname).innerHtml = retValue(1)
            document.all(inputname).value = retValue(0)
			
        end if
    Else 
        document.all(inputname).value = ""
        document.all(spanname).innerHtml = ""			
    End If
    document.frmmain.action="/workflow/action/WsActionEditSet.jsp"
    document.frmmain.submit()
End Sub
</script>
