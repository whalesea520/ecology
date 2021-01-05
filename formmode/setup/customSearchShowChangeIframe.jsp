<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.formmode.service.SelectItemPageService"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.formmode.service.FormInfoService"%>
<%@ page import="com.weaver.formmodel.util.*"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>

<%
	int fieldid = Util.getIntValue(request.getParameter("fieldid"), 0);
	int selectitem = 0;
	int linkfield = 0;
	int customid = Util.getIntValue(request.getParameter("id"), 0);
	String value = Util.null2String(request.getParameter("value"),"");
	String htmltype = "";
	String type="";
	String fieldname = "";
	//初始化数据
	RecordSet rs = new RecordSet();
	rs.execute("select * from workflow_billfield  where id="+fieldid);
	if(rs.next()){
		htmltype = rs.getString("fieldhtmltype");
		type = rs.getString("type");
		fieldname = rs.getString("fieldname");
		selectitem = Util.getIntValue(rs.getString("selectitem"),0);
		linkfield = Util.getIntValue(rs.getString("linkfield"),0);
	}
	List<Map<String, Object>> initvalue = new ArrayList();
	//查询customfieldshowchange中数据
	if(!StringHelper.isEmpty(value)){
		StringBuffer sql = new StringBuffer();
		String isnull = "isnull";
		if(rs.getDBType().equalsIgnoreCase("oracle")) {
			isnull = "nvl";
		}
		if("5".equals(htmltype)) {
			sql.append("    select b.customid,a.fieldid,b.fieldopt,a.selectvalue fieldoptvalue,   ");
			sql.append("  ").append(isnull).append("(b.fieldshowvalue, '$").append(fieldname).append("$') fieldshowvalue,b.fieldbackvalue,       ");
			sql.append("           b.fieldfontvalue,b.fieldoptvalue2, b.fieldopt2, b.singlevalue, ");
			sql.append("           b.morevalue                                                    ");
			sql.append("      from workflow_SelectItem a                                          ");
			sql.append(" left join customfieldshowchange b                                        ");
			sql.append("        on a.fieldid = b.fieldid                                          ");
			sql.append("       and a.selectvalue = b.fieldoptvalue                                ");
			sql.append("       and b.customid = ?                                                 ");
			sql.append("     where a.fieldid = ?                                                  ");
			sql.append("       and a.isbill = 1  order by  a.listorder, a.id                      ");
		} else {
			sql.append("select * from customfieldshowchange where customid=? and fieldid=? order by id");
		}
		rs.executeQuery(sql.toString(),customid,fieldid);
		while(rs.next()){
			Map<String,Object> m = new HashMap();
			m.put("customid", rs.getInt("customid"));
			m.put("fieldid", rs.getInt("fieldid"));
			m.put("fieldopt", rs.getInt("fieldopt"));
			m.put("fieldopt2", rs.getInt("fieldopt2"));
			m.put("fieldoptvalue", rs.getString("fieldoptvalue"));
			m.put("fieldoptvalue2", rs.getString("fieldoptvalue2"));
			m.put("fieldshowvalue", rs.getString("fieldshowvalue"));
			m.put("fieldbackvalue", rs.getString("fieldbackvalue"));
			m.put("fieldfontvalue", rs.getString("fieldfontvalue"));
			initvalue.add(m);
		}
	}
	int selectitemid = 0;
	int level = 1;
	if(selectitem>0){
		selectitemid = selectitem;
	}else{
		if(htmltype.equals("8")){
			SelectItemPageService selectItemPageService = new SelectItemPageService();
			Map<String,Integer> map = selectItemPageService.getTopSelectItemIdByField(fieldid,level);
			if(map.size()>0){
				selectitemid = map.get("selectitemid");
				level = map.get("level");
			}
		}
	}
%>

<html>
<head>
	<title></title>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/resources/css/ext-all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/ext/adapter/ext/ext-base_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ext-all_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/miframe_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/selectitemeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/attachpiceditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/specialeditfield_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/ext/ux/columnLock_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="/formmode/js/ext/ux/css/columnLock_wev8.css"/>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	
	<link type="text/css" rel="stylesheet" href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery.ui.all_wev8.css" />
	<script type="text/javascript" src="/formmode/js/jquery/jquery-ui-1.10.3/ui/minified/jquery-ui.min_wev8.js"></script>
	<!-- 
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET> -->
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
	<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET> <!-- 为选择项编辑表格移植的css -->
	
	
	<link href="/page/maint/style/common_wev8.css" type="text/css" rel=stylesheet>
	<!--For Color-->
	<link rel="stylesheet" href="/js/jquery/plugins/farbtastic/farbtastic_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/jquery/plugins/farbtastic/farbtastic_wev8.js"></script>	

	<!--For Spin Button-->
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>	
	<link rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>	
	<style type="text/css">
		* {font:12px Microsoft YaHei}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px;
		}
		.e8_formfield_tabs{
			height: 100%;
			margin: 0px;
			padding: 0px;
			border: none;
			position: relative;
		}
		.e8_formfield_tabs .ui-tabs-nav {
			background:none;
			border:none;
			padding-left: 0px;
		}
		.e8_formfield_tabs .ui-tabs-nav li{
			margin-right: 0px;
			border:0;
		}
		.e8_formfield_tabs .ui-tabs-nav li.ui-state-default{
			background: none;
		}
		.e8_formfield_tabs .ui-tabs-nav li a{
			font-size: 12px;
			padding-left: 0px;
			padding-right: 10px;
			color: #a3a3a3;
			
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover{

		}
		.e8_formfield_tabs .ui-tabs-nav li a:active{
			background: none;
		}
		.e8_formfield_tabs .ui-tabs-nav li.ui-state-active a{
			color: #0072C6;
			font-weight: bold;
		}
		.e8_formfield_tabs .ui-tabs-nav li a span.ui-icon-close{
			position: absolute;
			top:0px;
			right: 0px;
			display: none;
			cursor: pointer;
		}
		.e8_formfield_tabs .ui-tabs-nav li a:hover span.ui-icon-close{
			display: block;
		}
		
		.e8_formfield_tabs .ui-tabs-panel{
			padding: 0px;
			overflow: hidden;
		}
		/*Ext 表格对应的样式(框架)*/
		.e8_formfield_tabs .ui-tabs-panel .x-border-layout-ct{
			background-color: #fff;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-body-noheader{
			border: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-tl{
			border-bottom-width: 0px;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-ml{
			padding-left: 0px;
			background-image: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-mc{
			padding-top: 0px;
			background-color: #fff;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-mr{
			padding-right: 0px;
			background-image: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-panel-nofooter .x-panel-bc{
			height: 0px;
			overflow:hidden;
		}
		
		.x-combo-list-small .x-combo-list-item, .x-combo-list-item{
			font-size: 11px;
			font-family: Microsoft YaHei;
		}
		.x-small-editor .x-form-field{
			font-size: 11px;
			font-family: Microsoft YaHei;
		}
		
		/*Ext 表格对应的样式(表格)*/
		.e8_formfield_tabs .ui-tabs-panel .x-grid-panel .x-panel-mc .x-panel-body{
			border: none; 
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-header{
			background: none;
			padding-left: 3px;
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-row td{
			background-color: #E5E5E5;
			border-left: none;
			border-right-color: #d0d0d0;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-row td .x-grid3-hd-inner{
			color: #333;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-row-table td{
			
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-header-inner{
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel td.x-grid3-hd-over .x-grid3-hd-inner{
			background-image: none;
			background-color: #E5E5E5;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-hd-over .x-grid3-hd-btn{
			display: none;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-scroller{
		
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-locked .x-grid3-scroller{
			border-right-color: #d0d0d0;
		}
		.e8_formfield_tabs .ui-tabs-panel .x-grid3-body .x-grid3-td-checker{
			padding-left: 3px;
			background: none;
		}
		.e8_formfield_tabs .x-grid3-cell-inner{
			padding: 1px 3px 1px 5px;
		}
		.e8_formfield_tabs .x-grid3-row{
			border-left-width: 0px;
		}
		
		.e8_formfield_addTab{
			position: absolute;
			width: 10px;
			height: 10px;
			top: 11px;
			left: -10px;
			cursor: pointer;
			background: url("/formmode/images/add_wev8.png") no-repeat;
			z-index: 1000;
			margin-left: 2px;
		}
		
		table.liststyle td{
			color: #929393;
			border-bottom: 1px solid #DADADA;
			padding: 5px 0px;
		}
		
		.x-form-editor-trigger{
		/*
			background:transparent url("/formmode/js/ext/resources/images/default/editor/tb-sprite_wev8.gif") no-repeat !important;
			background-position:-192px 0px !important;*/
			background:transparent url("/formmode/images/list_edit_wev8.png") no-repeat !important;
			background-position:1px 1px !important;
			border-bottom: none !important;
		}
		.x-form-textarea{
			margin-bottom: 0px !important;
		}
		button.calendar {
			BORDER-RIGHT: medium none; BORDER-TOP: medium none; BACKGROUND-IMAGE: url("/wui/theme/ecology8/skins/default/general/calendar_wev8.png"); OVERFLOW: hidden; BORDER-LEFT: medium none; WIDTH: 16px; CURSOR: pointer; BORDER-BOTTOM: medium none; BACKGROUND-REPEAT: no-repeat; HEIGHT: 16px; BACKGROUND-COLOR: transparent
		}
		
		.colorimg{
			vertical-align: middle;
			margin-left:3px;
			cursor: pointer;
		}
	</style>
	
	
</head>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:onSave(),_self} " ;//确定
	    RCMenuHeight += RCMenuHeightStep ;
	    RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;//清除
		RCMenuHeight += RCMenuHeightStep ;
	%>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
    <table id="topTitle" cellpadding="0" cellspacing="0" style="display:none;">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(83446, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onSave()">
				<span title="<%=SystemEnv.getHtmlLabelName(81804, user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
    </table>
	<div id="SeleteItem">
					<%if(!"5".equals(htmltype)&&!"8".equals(htmltype)&&!"4".equals(htmltype)) {%>
					<div id="div5" style="vertical-align: middle; height:30px; line-height: 30px;text-align: right;padding-right: 5px;">
						<button type="button" class="addbtn" id="btnaddRow" name="btnaddRow" onclick='addoTableRow()' title="<%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%>" style="margin-top:5px;"></BUTTON><!-- 添加内容 -->
						<button type="button" class="delbtn" id="btnsubmitClear" name="btnsubmitClear" onclick='submitClear()' title="<%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%>" style="margin-top:5px;"></BUTTON><!-- 删除内容 -->
					</div>
					<%}%>
					<div id="div5_5">
					  	<table class='liststyle' id='choiceTable' cols='6' border=0 style="width: 100%;" cellspacing="collapse">
					  		<%if(!"5".equals(htmltype)&&!"8".equals(htmltype)&&!"4".equals(htmltype)){%>
					  			<COL width="5%">
								<COL width="28%">
								<COL width="28%">
								<COL width="15%">
								<COL width="12%">
								<COL width="12%">
					  			<%}else{%>
					  			<COL width="5%">
								<COL width="15%">
								<COL width="20%">
								<COL width="40%">
								<COL width="10%">
								<COL width="10%">
					  			<%}%>
							
					  		<tr>
					  			<td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td><!-- 选中 -->
					  			<%if(!"5".equals(htmltype)&&!"8".equals(htmltype)&&!"4".equals(htmltype)){%>
					  			<td><%=SystemEnv.getHtmlLabelName(82066,user.getLanguage())%>1</td><!--字段条件1-->
					  			<td><%=SystemEnv.getHtmlLabelName(82066,user.getLanguage())%>2</td><!--字段条件2-->
					  			<%}else{%>
					  			<td><%=SystemEnv.getHtmlLabelName(82066,user.getLanguage())%></td><!--字段条件-->
					  			<td><%=SystemEnv.getHtmlLabelName(22217,user.getLanguage())%></td><!--字段值-->
					  			<%}%>
					  			<td><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></td><!--显示值-->
					  			<td ><%=SystemEnv.getHtmlLabelName(2077,user.getLanguage())%></td><!--背景颜色-->
								<td ><%=SystemEnv.getHtmlLabelName(2076,user.getLanguage())%></td><!--字体颜色-->
							</tr>
					  		<%
					  		char flag = Util.getSeparator();
					  		if(initvalue.size()>0){
						  			int index = 0;
							  		for(int i=0;i<initvalue.size();i++){
							  			index+=1;
							  			Map<String,Object> m = initvalue.get(i);
								  		//check框
								  		int tmpopt = Util.getIntValue(StringHelper.null2String(m.get("fieldopt"),"0"));
								  		int tmpopt2 = Util.getIntValue(StringHelper.null2String(m.get("fieldopt2"),"0"));
								  		String value1 = StringHelper.null2String(m.get("fieldoptvalue"));
								  		String value2 = StringHelper.null2String(m.get("fieldoptvalue2"));
								  		String valuedes =StringHelper.null2String(m.get("fieldoptvalue"));
								  		String fieldshowvalue = StringHelper.null2String(m.get("fieldshowvalue"));
								  		fieldshowvalue= fieldshowvalue.replaceAll("\"", "&quot;");
								  		String fieldbackvalue = StringHelper.null2String(m.get("fieldbackvalue"));
								  		fieldbackvalue= fieldbackvalue.replaceAll("\"", "&quot;");
								  		String fieldfontvalue = StringHelper.null2String(m.get("fieldfontvalue"));
								  		fieldfontvalue= fieldfontvalue.replaceAll("\"", "&quot;");
								  		if("4".equals(htmltype)){
								  			if("1".equals(value1)){
								  				valuedes = SystemEnv.getHtmlLabelName(1426,user.getLanguage());//选中
								  			}else{
								  				valuedes = SystemEnv.getHtmlLabelName(22906,user.getLanguage());//未选中
								  			}
								  		}else if("5".equals(htmltype)){
								  			// 查询选择框的所有可以选择的值
								            rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
								            while(rs.next()){
								                String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
								                String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
												if(value1.equals(tmpselectvalue)){ 
													valuedes=tmpselectname;
												}
								            }
								  		}else if("8".equals(htmltype)){
								  			// 查询选择框的所有可以选择的值
								            String selSql = "select * from mode_selectitempagedetail where mainid="+selectitemid+" and statelev="+level+"  and (cancel=0 or cancel is null)  order by disorder asc,id asc";
		           							rs.executeSql(selSql);
								            while(rs.next()){
								                String tmpselectvalue = Util.null2String(rs.getString("id"));
								                String tmpselectname = Util.toScreen(rs.getString("name"),user.getLanguage());
												if(value1.equals(tmpselectvalue)){ 
													valuedes=tmpselectname;
												}
								            }
								  		}
							  		%>
								  	<tr>
								  		<td><div><input type="checkbox" name="chkField" index="<%=index%>" value="0" ></div>
									  			<%if("5".equals(htmltype)){%>
									  				<td><div><select class=inputstyle  name="con_<%=index%>_opt" style="width:90" >
									  					<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
														<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
													</select></span></div></td>
													<td><div><input class="InputStyle selectitemname" value="<%=valuedes%>" type="text" size="10" name="con_<%=index%>_optvaluedesc" style="width:90%" disabled="disabled">
								  						<input type="hidden" id="con_<%=index%>_optvalue" name="con_<%=index%>_optvalue" value="<%=value1%>">
								  					</div></td>
									  			<%}else if("8".equals(htmltype)){%>
										  				<td><div><select class=inputstyle  name="con_<%=index%>_opt" style="width:90" >
									  					<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
														<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
													</select></span></div></td>
													<td><div><input class="InputStyle selectitemname" value="<%=valuedes%>" type="text" size="10" name="con_<%=index%>_optvaluedesc" style="width:90%" disabled="disabled">
								  						<input type="hidden" id="con_<%=index%>_optvalue" name="con_<%=index%>_optvalue" value="<%=value1%>">
								  					</div></td>
									  			<%}else if("4".equals(htmltype)){%>
									  				<td><div><select class=inputstyle  name="con_<%=index%>_opt" style="width:90" disabled="disabled">
									  					<option value="5" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
									  				</select></span></div></td>
									  				<td><div><input class="InputStyle selectitemname" value="<%=valuedes%>" type="text" size="10" name="con_<%=index%>_optvaluedesc" style="width:90%" disabled="disabled">
								  						<input type="hidden" id="con_<%=index%>_optvalue" name="con_<%=index%>_optvalue" value="<%=value1%>">
								  					</div></td>
								  				<%}else if(("3".equals(htmltype)&&"2".equals(type))||-1==fieldid) { %>
									  				<td><div><select class=inputstyle  name="con_<%=index%>_opt" style="width:90" >
														<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!--大于-->
														<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!--大于或等于-->
														<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
														<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
													</select>&nbsp;&nbsp;<input class="InputStyle selectitemname" value="<%=value1%>" type="text" size="15" name="con_<%=index%>_optvalue" >&nbsp;<input type="hidden" id="con_<%=index%>_optvaluedesc"><button type="button"  class="calendar" onclick="onSearchWFQTDate('con_<%=index%>_optvaluedesc','con_<%=index%>_optvalue')" ></button>
													</div></td>
													<td><div><select class=inputstyle  name="con_<%=index%>_opt2" style="width:90" >
																<option value="3" <%if(tmpopt2==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!--小于-->
																<option value="4" <%if(tmpopt2==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!--小于或等于-->
																<option value="5" <%if(tmpopt2==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
																<option value="6" <%if(tmpopt2==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
														</select>&nbsp;&nbsp;<input class="InputStyle selectitemname" value="<%=value2%>" type="text" size="15" name="con_<%=index%>_optvalue2">&nbsp;<input type="hidden" id="con_<%=index%>_optvalue2desc"><button type="button"  class="calendar" onclick="onSearchWFQTDate('con_<%=index%>_optvalue2desc','con_<%=index%>_optvalue2')" ></button>
								  					</div></td>
									  			<%}else{ %>
									  				<td><div><select class=inputstyle  name="con_<%=index%>_opt" style="width:90" >
														<option value="1" <%if(tmpopt==1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option><!--大于-->
														<option value="2" <%if(tmpopt==2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option><!--大于或等于-->
														<option value="5" <%if(tmpopt==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
														<option value="6" <%if(tmpopt==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
													</select>&nbsp;&nbsp;<input class="InputStyle selectitemname" value="<%=value1%>" type="text" size="15" name="con_<%=index%>_optvalue"  onchange="checkVal(this)"></span></div></td>
													<td><div><select class=inputstyle  name="con_<%=index%>_opt2" style="width:90" >
																<option value="3" <%if(tmpopt2==3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option><!--小于-->
																<option value="4" <%if(tmpopt2==4){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option><!--小于或等于-->
																<option value="5" <%if(tmpopt2==5){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
																<option value="6" <%if(tmpopt2==6){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
														</select>&nbsp;&nbsp;<input class="InputStyle selectitemname" value="<%=value2%>" type="text" size="15" name="con_<%=index%>_optvalue2" onchange="checkVal(this)">
								  					</div></td>
									  			<%}%>
								  			<td ><div><input class="InputStyle selectitemname" value="<%=fieldshowvalue%>" type="text" size="10" name="con_<%=index%>_showvalue" style="width:90%" >
								  			</div></td>
								  			<td ><div>
								  			<input class="InputStyle selectitemname" style="width:50%;background-color:<%=fieldbackvalue%> " type="text" size="10" id="con_<%=index%>_backvalue" value="<%=fieldbackvalue%>"/>
								  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_<%=index%>_backvalue' r_attr='color' name="con_<%=index%>_backvalue"><%=fieldbackvalue%></span>
								  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_<%=index%>_backvalue');" src="/images/homepage/menu/del_1_wev8.png"
								  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
								  			<td ><div>
								  			<input class="InputStyle selectitemname" style="width:50%;background-color:<%=fieldfontvalue%>" type="text" size="10" id="con_<%=index%>_fontvalue" value="<%=fieldfontvalue%>"/>
								  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_<%=index%>_fontvalue' r_attr='color' name="con_<%=index%>_fontvalue"><%=fieldfontvalue%></span>
								  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_<%=index%>_fontvalue');" src="/images/homepage/menu/del_1_wev8.png"
								  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
									</tr>
								  <%}%><input type="hidden" value="<%=index%>" name="choiceRows"><%
							 }else{
							  		//选择框
								  	if("5".equals(htmltype)){
								  		int index = 0;
								  		// 查询选择框的所有可以选择的值
	           							rs.executeProc("workflow_SelectItemSelectByid",""+fieldid+flag+"1");
									  	while(rs.next()){
										  	index+=1;
										  	String tmpselectvalue = Util.null2String(rs.getString("selectvalue"));
	               							String tmpselectname = Util.toScreen(rs.getString("selectname"),user.getLanguage());
											%>
										  	<tr>
										  		<td><div><input type="checkbox" name="chkField" index="<%=index%>" value="0" disabled>
										  		</div></td>
										  		<td><div>
											  		<select class=inputstyle  name="con_<%=index%>_opt" style="width:90" >
														<option value="5" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
														<option value="6" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
													</select>
													</div></td>
										  			<td><div><input class="InputStyle selectitemname" value="<%=tmpselectname%>" type="text" size="10" name="con_<%=index%>_optvaluedesc" style="width:90%" >
										  			<input type="hidden" id="con_<%=index%>_optvalue" name="con_<%=index%>_optvalue" value="<%=tmpselectvalue%>"></td></div></td>
										  			<td><div><input class="InputStyle selectitemname" value="$<%=fieldname%>$" type="text" size="10" name="con_<%=index%>_showvalue" style="width:90%" >
										  			</div></td>
										  			<td ><div>
										  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_<%=index%>_backvalue" value=""/>
										  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_<%=index%>_backvalue' r_attr='color' name="con_<%=index%>_backvalue"></span>
										  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_<%=index%>_backvalue');" src="/images/homepage/menu/del_1_wev8.png"
										  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
										  			<td ><div>
										  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_<%=index%>_fontvalue" value=""/>
										  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_<%=index%>_fontvalue' r_attr='color' name="con_<%=index%>_fontvalue"></span>
										  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_<%=index%>_fontvalue');" src="/images/homepage/menu/del_1_wev8.png"
										  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
											</tr>
										  	<%}%>
										  	<input type="hidden" value="<%=index%>" name="choiceRows">
										  	<%
										  }else if("8".equals(htmltype)){//公共选择框
									  		int index = 0;
									  		// 查询选择框的所有可以选择的值
									  		String selSql = "select * from mode_selectitempagedetail where mainid="+selectitemid+" and statelev="+level+"  and (cancel=0 or cancel is null)  order by disorder asc,id asc";
		           							rs.executeSql(selSql);
										  	while(rs.next()){
											  	index+=1;
											  	String tmpselectvalue = Util.null2String(rs.getString("id"));
		               							String tmpselectname = Util.null2String(rs.getString("name"));
												%>
											  	<tr>
											  		<td><div><input type="checkbox" name="chkField" index="<%=index%>" value="0" disabled>
											  		</div></td>
											  		<td><div>
												  		<select class=inputstyle  name="con_<%=index%>_opt" style="width:90" >
															<option value="5" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
															<option value="6" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option><!--不等于-->
														</select>
														</div></td>
											  			<td><div><input class="InputStyle selectitemname" value="<%=tmpselectname%>" type="text" size="10" name="con_<%=index%>_optvaluedesc" style="width:90%" >
											  			<input type="hidden" id="con_<%=index%>_optvalue" name="con_<%=index%>_optvalue" value="<%=tmpselectvalue%>"></td></div></td>
											  			<td><div><input class="InputStyle selectitemname" value="$<%=fieldname%>$" type="text" size="10" name="con_<%=index%>_showvalue" style="width:90%" >
											  			</div></td>
											  			<td ><div>
											  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_<%=index%>_backvalue" value=""/>
											  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_<%=index%>_backvalue' r_attr='color' name="con_<%=index%>_backvalue"></span>
											  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_<%=index%>_backvalue');" src="/images/homepage/menu/del_1_wev8.png"
											  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
											  			<td ><div>
											  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_<%=index%>_fontvalue" value=""/>
											  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_<%=index%>_fontvalue' r_attr='color' name="con_<%=index%>_fontvalue"></span>
											  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_<%=index%>_fontvalue');" src="/images/homepage/menu/del_1_wev8.png"
											  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
												</tr>
											  	<%}%>
											  	<input type="hidden" value="<%=index%>" name="choiceRows">
											  	<%
										 }else if("4".equals(htmltype)){%>
								  		<tr>
								  		<td><div><input type="checkbox" name="chkField" index="1" value="0">
								  		<td><div>
									  		<select class=inputstyle  name="con_1_opt" style="width:90" disabled="disabled">
												<option value="5" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
											</select></span>
											</div></td><!--未选中-->
								  			<td><div><input class="InputStyle selectitemname" value="<%=SystemEnv.getHtmlLabelName(22906,user.getLanguage())%>" type="text" size="10" name="con_1_optvaluedesc" style="width:90%" disabled="disabled">
								  				<input type="hidden" id="con_1_optvalue" name="con_1_optvalue" value="0">
								  			</div></td>
								  			<td  ><div><input class="InputStyle selectitemname" value="$<%=fieldname%>$" type="text" size="10" name="con_1_showvalue" style="width:90%" >
								  			</div></td>
								  			<td ><div>
								  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_1_backvalue" value=""/>
								  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_1_backvalue' r_attr='color' name="con_1_backvalue"></span>
								  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_1_backvalue');" src="/images/homepage/menu/del_1_wev8.png"
								  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
								  			<td ><div>
								  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_1_fontvalue" value=""/>
								  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_1_fontvalue' r_attr='color' name="con_1_fontvalue"></span>
								  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_1_fontvalue');" src="/images/homepage/menu/del_1_wev8.png"
								  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
								  		
									</tr>
									<tr>
								  		<td><div><input type="checkbox" name="chkField" index="2" value="0"></div></td>
								  		<td><div>
									  		<select class=inputstyle  name="con_2_opt" style="width:90" disabled="disabled">
												<option value="5" selected><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option><!--等于-->
											</select></span>
											</div></td><!--选中-->
								  			<td><div><input class="InputStyle selectitemname" value="<%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%>" type="text" size="10" name="con_2_optvaluedesc" style="width:90%" disabled="disabled">
								  				<input type="hidden" id="con_2_optvalue" name="con_2_optvalue" value="1">
								  			</div></td>
								  			<td  ><div><input class="InputStyle selectitemname" value="$<%=fieldname%>$" type="text" size="10" name="con_2_showvalue" style="width:90%" >
								  			</div></td>
								  			<td ><div>
								  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_2_backvalue" value=""/>
								  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_2_backvalue' r_attr='color' name="con_2_backvalue"></span>
								  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_2_backvalue');" src="/images/homepage/menu/del_1_wev8.png"
								  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
								  			<td ><div>
								  			<input class="InputStyle selectitemname" style="width:50%;" type="text" size="10" id="con_2_fontvalue" value=""/>
								  			<span style='border:0;display: none;' id='head_hover' class='colorblock'  r_id='con_2_fontvalue' r_attr='color' name="con_2_fontvalue"></span>
								  			<img class="colorimg" title="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" onclick="clearColor('con_2_fontvalue');" src="/images/homepage/menu/del_1_wev8.png"
								  			onmouseover="this.src='/images/homepage/menu/del_2_wev8.png'" onmouseout="this.src='/images/homepage/menu/del_1_wev8.png'"></div></td>
								  		
									</tr>
									<input type="hidden" value="2" name="choiceRows">
								  	<%
								  	}else{%>
								  	<input type="hidden" value="0" name="choiceRows">
								  	<%}
								  } %>
						</table>
					</div>
					
				</div>
	<%if(htmltype.equals("3")&&type.equals("2")){ %>
	<div style="padding: 10px;color: red;">
		<p><%=SystemEnv.getHtmlLabelName(125776, user.getLanguage()) %></p>
		<p>1 <%=SystemEnv.getHtmlLabelName(128161, user.getLanguage()) %></p>
		<p>2 <%=SystemEnv.getHtmlLabelName(128162, user.getLanguage()) %></p>
		<p>3 <%=SystemEnv.getHtmlLabelName(128163, user.getLanguage()) %></p>
		<p>4 <%=SystemEnv.getHtmlLabelName(128164, user.getLanguage()) %></p>
	</div>
	<%} %>
	<%if(htmltype.equals("1")&& ( type.equals("2") || type.equals("3"))){ %>
	<div style="padding: 10px;color: red;">
		<p><%=SystemEnv.getHtmlLabelName(125776, user.getLanguage()) %></p>
		<p>1 <%=SystemEnv.getHtmlLabelName(129550, user.getLanguage()) %></p>
		<p>2 <%=SystemEnv.getHtmlLabelName(129551, user.getLanguage()) %></p>
	</div>
	<%} %>
	<script type="text/javascript">
	//主表字段 选择框 添加选项
		function addoTableRow(){
			var obj1 = $G("choiceTable");
			var choicerowindex =$G("choiceRows").value*1+1;
			$G("choiceRows").value = choicerowindex;
			ncol1 = obj1.rows[0].cells.length;
			oRow1 = obj1.insertRow(-1);
			for(j=0; j<ncol1; j++) {
				oCell1 = oRow1.insertCell(j);
				switch(j) {
					case 0:
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input   type='checkbox' name='chkField' index='"+choicerowindex+"' value='0'>"+
							" <input type=\"hidden\" id=\"con_"+choicerowindex+"_id\" name=\"con_"+choicerowindex+"_id\" value=\"\">";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 1:
						var oDiv1 = document.createElement("div");
						var sHtml1 ="";
						<%if(("3".equals(htmltype)&&"2".equals(type))||(-1==fieldid)){%>
							sHtml1 = "<select class=inputstyle  name=\"con_"+choicerowindex+"_opt\" style=\"width:90\" >"+
									" <option value=\"1\" selected><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>"+//大于
									" <option value=\"2\" ><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>"+//大于或等于
									" <option value=\"5\" ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>"+//等于
									" <option value=\"6\" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>"+//不等于
									"</select>&nbsp;&nbsp;<input class=\"InputStyle selectitemname\" value=\"\" type=\"text\" size=\"15\" name=\"con_"+choicerowindex+"_optvalue\" >&nbsp;<input  type=\"hidden\" id=\"con_"+choicerowindex+"_optvaluedesc\" ><button type=\"button\"  class=\"calendar\" onclick=\"onSearchWFQTDate('con_"+choicerowindex+"_optvaluedesc','con_"+choicerowindex+"_optvalue')\" ></button>";
						<%}else{%>
							sHtml1 = "<select class=inputstyle  name=\"con_"+choicerowindex+"_opt\" style=\"width:90\" >"+
									" <option value=\"1\" selected><%=SystemEnv.getHtmlLabelName(15508,user.getLanguage())%></option>"+//大于
									" <option value=\"2\" ><%=SystemEnv.getHtmlLabelName(325,user.getLanguage())%></option>"+//大于或等于
									" <option value=\"5\" ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>"+//等于
									" <option value=\"6\" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>"+//不等于
									"</select>&nbsp;&nbsp;<input class=\"InputStyle selectitemname\" value=\"\" type=\"text\" size=\"15\" name=\"con_"+choicerowindex+"_optvalue\" onchange=\"checkVal(this)\">";
						<%}%>
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 2:
						var oDiv1 = document.createElement("div");
						var sHtml1 ="";
						<%if(("3".equals(htmltype)&&"2".equals(type))||(-1==fieldid)){%>
							sHtml1 = "<select class=inputstyle  name=\"con_"+choicerowindex+"_opt2\" style=\"width:90\" >"+
									" <option value=\"3\" ><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>"+//小于
									" <option value=\"4\" selected><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>"+//小于或等于
									" <option value=\"5\" ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>"+//等于
									" <option value=\"6\" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>"+//不等于
									"</select>&nbsp;&nbsp;<input class=\"InputStyle selectitemname\" value=\"\" type=\"text\" size=\"15\" name=\"con_"+choicerowindex+"_optvalue2\" >&nbsp;<input  type=\"hidden\" id=\"con_"+choicerowindex+"_optvalue2desc\" ><button type=\"button\"  class=\"calendar\" onclick=\"onSearchWFQTDate('con_"+choicerowindex+"_optvalue2desc','con_"+choicerowindex+"_optvalue2')\" ></button>";
						<%}else{%>
							sHtml1 = "<select class=inputstyle  name=\"con_"+choicerowindex+"_opt2\" style=\"width:90\" >"+
									" <option value=\"3\" ><%=SystemEnv.getHtmlLabelName(15509,user.getLanguage())%></option>"+//小于
									" <option value=\"4\" selected><%=SystemEnv.getHtmlLabelName(326,user.getLanguage())%></option>"+//小于或等于
									" <option value=\"5\" ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>"+//等于
									" <option value=\"6\" ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>"+//不等于
									"</select>&nbsp;&nbsp;<input class=\"InputStyle selectitemname\" value=\"\" type=\"text\" size=\"15\" name=\"con_"+choicerowindex+"_optvalue2\" onchange=\"checkVal(this)\">";
						<%}%>
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 3:
						var oDiv1 = document.createElement("div");
						var sHtml1 = "";
						<%if(-1==fieldid){%>
							sHtml1 = " <input class=\"InputStyle selectitemname\" value=\"$createdate$ $createtime$\" type=\"text\" size=\"10\" name=\"con_"+choicerowindex+"_showvalue\" style=\"width:90%\" >";
						<%}else{%>
							sHtml1 = " <input class=\"InputStyle selectitemname\" value=\"$<%=fieldname%>$\" type=\"text\" size=\"10\" name=\"con_"+choicerowindex+"_showvalue\" style=\"width:90%\" >";
						<%}%>
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						break;
					case 4:
						var oDiv1 = document.createElement("div");
						var sHtml1 = " <input id='con_"+choicerowindex+"_backvalue' type='text' style='width:50%;' type='text' size='10' class='InputStyle selectitemname' value=''/> "+
							"<span style='border:0;display:none' id='head_hover' class='colorblock' r_id='con_"+choicerowindex+"_backvalue' r_attr='color' name='con_"+choicerowindex+"_backvalue'></span> "+
							"<img class='colorimg' title='<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>' onclick='clearColor(\"con_"+choicerowindex+"_backvalue\");' src='/images/homepage/menu/del_1_wev8.png' "+
							"onmouseover=\"this.src='/images/homepage/menu/del_2_wev8.png'\" onmouseout=\"this.src='/images/homepage/menu/del_1_wev8.png'\">";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						initColor($("span[r_id='con_"+choicerowindex+"_backvalue']"));
						break;
					case 5:
						var oDiv1 = document.createElement("div");
						var sHtml1 = " <input id='con_"+choicerowindex+"_fontvalue' type='text' style='width:50%;' type='text' size='10' class='InputStyle selectitemname' value=''/> "+
							"<span style='border:0;display:none' id='head_hover' class='colorblock'  r_id='con_"+choicerowindex+"_fontvalue' r_attr='color' name='con_"+choicerowindex+"_fontvalue'></span> "+
							"<img class='colorimg' title='<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>' onclick='clearColor(\"con_"+choicerowindex+"_fontvalue\");' src='/images/homepage/menu/del_1_wev8.png' "+
							"onmouseover=\"this.src='/images/homepage/menu/del_2_wev8.png'\" onmouseout=\"this.src='/images/homepage/menu/del_1_wev8.png'\">";
						oDiv1.innerHTML = sHtml1;
						oCell1.appendChild(oDiv1);
						initColor($("span[r_id='con_"+choicerowindex+"_fontvalue']"));
						break;
				}		
			}
			jQuery("body").jNice();
			//jQuery("select").beautySelect();
			beautySelect();
		}
		//删除行
		function submitClear(){
		  var flag = false;
			var ids = document.getElementsByName('chkField');
			for(i=0; i<ids.length; i++) {
				if(ids[i].checked==true) {
					flag = true;
					break;
				}
			}
		    if(flag) {
		        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function(){
					 deleteRow1();
				});
		    }else{
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");//请选择需要删除的数据
				return;
		    }
		}
		
		//删除行
		function deleteRow1(){
			var objTbl = $("#choiceTable");
			var objChecks=objTbl.find("input[name=chkField]");	
			
			for(var i=objChecks.length-1;i>=0;i--){
				if(objChecks.get(i).checked) {
					$(objChecks.get(i)).parent().parent().parent().parent().remove();
				}
			}
		}
		function onSave(){
			var modifiedDatas = new Array();
			var rowsum = $G("choiceRows").value;
			var sel_detaildata = [];
			var tempIndex = $("#choiceTable").find("input[name=chkField]");
			for(var m = 0; m < rowsum; m++){
				var sel_d_data = {};
				var q = $(tempIndex.get(m)).attr('index');
				if($G("con_"+q+"_opt")){
					var value2 = $G("con_"+q+"_opt").value;
					var value3 = $G("con_"+q+"_optvalue").value;
					var value1 = "";
					var value7 = "";
					if($G("con_"+q+"_optvalue2")){
						value1 = $G("con_"+q+"_optvalue2").value;
					}
					if($G("con_"+q+"_opt2")){
						value7 = $G("con_"+q+"_opt2").value;
					}
					var value4 = $G("con_"+q+"_showvalue").value;
					var value5 = $G("con_"+q+"_backvalue").value;
					
					var value6 = $G("con_"+q+"_fontvalue").value;
					
					sel_d_data["field_opt"] = value2;
					sel_d_data["field_optvalue"] = value3;
					sel_d_data["field_optvalue2"] = value1;
					sel_d_data["field_showvalue"] = value4;
					sel_d_data["field_backvalue"] = value5;
					sel_d_data["field_fontvalue"] = value6;
					sel_d_data["field_opt2"] = value7;
					sel_detaildata.push(sel_d_data);
				}
			}	
			var jsonstr = Ext.util.JSON.encode(sel_detaildata);
			enableAllmenu();
			var paramData = {"data": encodeURI(jsonstr), "customid": "<%=customid%>", "fieldid": "<%=fieldid%>"};
	    	var url = "/formmode/setup/showChangeAction.jsp?action=saveForm";
	    	FormmodeUtil.doAjaxDataSave(url, paramData, function(res){
	    		if(res != "error"){
	    			top.closeTopDialog(res);
	    		}else if(res == "0"){
	    			window.top.Dialog.alert("error");
					return;
	    		}
	    	});
		}
		function onClear(){
			enableAllmenu();
			top.closeTopDialog("0");
			//var paramData = {"customid": "<%=customid%>", "fieldid": "<%=fieldid%>"};
	    	//var url = "/formmode/setup/showChangeAction.jsp?action=clearForm";
	    	// FormmodeUtil.doAjaxDataSave(url, paramData, function(res){
	    		//if(res != "error"){
	    			//top.closeTopDialog("0");
	    		//}else if(res == "0"){
	    			//alert("error");
	    		//}
	    	//}); 
		}
		function checkVal(obj){
			var valid=false;
			var checkrule='^(-?\\d+)(\\.\\d+)?$';
			var fieldvalue=obj.value;
			eval("valid=/"+checkrule+"/.test(\""+fieldvalue+"\");");
			if (fieldvalue!=''&&!valid){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82068,user.getLanguage())%>");//字段值中请输入数字！
				obj.value='';
			}
		}
		function onSearchWFQTDate(spanname,inputname){
			var oncleaingFun = function(){
			 spanname.value='';
			 inputname.value='';
			}
			WdatePicker({el:spanname,onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname).value=returnvalue;
				},oncleared:oncleaingFun});
		}</script>
	<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</body>
<script>
	$(document).ready(function(){
	    
		$(".colorblock").each(function(){				
			initColor($(this));
		});
		
		var index = $G("choiceRows").value;
	    if(index == 0){
	       addoTableRow();
	    }	
	});
	
	var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
	/*RGB颜色转换为16进制*/
	String.prototype.colorHex = function(){
		var that = this;
		if(/^(rgb|RGB)/.test(that)){
			var aColor = that.replace(/(?:\(|\)|rgb|RGB)*/g,"").split(",");
			var strHex = "#";
			for(var i=0; i<aColor.length; i++){
				var hex = Number(aColor[i]).toString(16);
				if(hex === "0"){
					hex += hex;	
				}
				strHex += hex;
			}
			if(strHex.length !== 7){
				strHex = that;	
			}
			return strHex;
		}else if(reg.test(that)){
			var aNum = that.replace(/#/,"").split("");
			if(aNum.length === 6){
				return that;	
			}else if(aNum.length === 3){
				var numHex = "#";
				for(var i=0; i<aNum.length; i+=1){
					numHex += (aNum[i]+aNum[i]);
				}
				return numHex;
			}
		}else{
			return that;	
		}
	};
	var language = readCookie("languageidweaver");
	function initColor(obj){
		var r_id=obj.attr("r_id");
		var r_attr=obj.attr("r_attr");
		var color="#ffffff";
		if(r_id!=null){
		 	color=getScriptStyleValue(r_id,r_attr);
		}
		color=$.trim(color);
		obj.text(color);							
		obj.css("background-color",color);
		
		var colorpic=$("<img src='/js/jquery/plugins/farbtastic/color_wev8.png' style='cursor:pointer;margin-left:3px;vertical-align: middle;'  border=0/>");
        obj.after(colorpic);

        colorpic.spectrum({
			//showPalette:true,
			showButtons:false,
			showInitial:true,
			showInput:true,
			allowEmpty:false,
			//showNoColorBtn:true,
			preferredFormat: "hex",
			chooseText:SystemEnv.getHtmlNoteName(3451,language),
			cancelText:SystemEnv.getHtmlNoteName(3516,language),
			//clearText:"清除",
			color:color,
			noclickhide:true,
			move: function(color) {
				    //console.dir(this);
					color = color.toHexString(); // #ff0000
					setColor(colorpic,color);
					
			},
			palette: [
					["#000","#444","#666","#999","#ccc","#eee","#f3f3f3","#fff"],
					["#f00","#f90","#ff0","#0f0","#0ff","#00f","#90f","#f0f"],
					["#f4cccc","#fce5cd","#fff2cc","#d9ead3","#d0e0e3","#cfe2f3","#d9d2e9","#ead1dc"],
					["#ea9999","#f9cb9c","#ffe599","#b6d7a8","#a2c4c9","#9fc5e8","#b4a7d6","#d5a6bd"],
					["#e06666","#f6b26b","#ffd966","#93c47d","#76a5af","#6fa8dc","#8e7cc3","#c27ba0"],
					["#c00","#e69138","#f1c232","#6aa84f","#45818e","#3d85c6","#674ea7","#a64d79"],
					["#900","#b45f06","#bf9000","#38761d","#134f5c","#0b5394","#351c75","#741b47"],
					["#600","#783f04","#7f6000","#274e13","#0c343d","#073763","#20124d","#4c1130"]
			]
		});

		if(color=="transparent") {
			obj.text("#ffffff");
		}

		//obj.width(60);
	}
	
	function getScriptStyleString(str){
		var returnStr=str;
		if(str=="font-size") returnStr="fontSize";
		else if(str=="font-family") returnStr="fontFamily";
		else if(str=="font-weight") returnStr="fontWeight";
		else if(str=="font-style") returnStr="fontStyle";
		else if(str=="background-color") returnStr="backgroundColor";
		else if(str=="background-image") returnStr="backgroundImage";		
		return returnStr;
	}
	function getScriptStyleValue(r_id,r_attr){
		var returnStr="";
		returnStr=$("#"+r_id).val();
		if("0"==(returnStr+"").indexOf("rgb")){
			returnStr=returnStr.colorHex();
		}
		return returnStr;
	}
	//设置颜色
    function  setColor(obj,piccolor){
	    var currentSetSpan=obj.prev();
		var value=piccolor;
		var color=piccolor;
	
		currentSetSpan.text(value);
		currentSetSpan.css("background-color",value);

		var r_id=currentSetSpan.attr("r_id");
		var r_attr=currentSetSpan.attr("r_attr");
		$("#"+r_id).val(value);
		$("#"+r_id).css("background-color",value);
		//setScriptStyleValue(r_id,r_attr,value);			
	}
	function setScriptStyleValue(r_id,r_attr,value){
		if(r_attr!="font-weight" && r_attr!="font-style"){
			if(!isNaN(value)&&value!=''){
					value=value+"px"
			}
		}
		$("#"+r_id).css('cssText',$("#"+r_id)[0].style.cssText+";"+r_attr+':'+value+'!important;');
	}
	function clearColor(id){
		var currentSetSpan = $("#"+id);
		currentSetSpan.val("");
		currentSetSpan.css("background-color","");
	}
</script>
</html>