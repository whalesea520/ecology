<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
//取出所有关系表中的字段
String mainid = request.getParameter("id");
String isclosed = Util.null2String(request.getParameter("isclosed"),"0");
rs.executeSql("select formid from carbasic where id="+mainid);
String formid = "";
if (rs.next()) {
	formid = rs.getString("formid");
}
HashMap existsMap = new HashMap();
String sql = "select * from mode_carrelatemode where mainid="+mainid;
rs.executeSql(sql);
while (rs.next()) {
	String carfieldid = rs.getString("carfieldid");
	String modefieldid = rs.getString("modefieldid");
	String key = carfieldid+"_"+modefieldid;
	existsMap.put(key,key);
}

String imagefilename = "/images/hdHRM_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

boolean flag = false;
%>
<HTML>
<HEAD>
<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology8/skins/default/wui_wev8.css'/>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script>
	<%if ("1".equals(isclosed)){%>
		window.parent.closeWinAFrsh();
	<%}%>
</script>
</head>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="javascript:doSave()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<form name="frmmain" method="post" action="/cpt/car/UseCarWorkflowSetOperation.jsp">
	<input name="operation" value="saveFieldRelate" type="hidden">
	<input name="mainid" value="<%=mainid %>" type="hidden">
	<wea:layout type="twoCol">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(128242,user.getLanguage())%>'>
			<wea:item>
				<input type="hidden" name="carfieldid" value="627"/>
				<%=SystemEnv.getHtmlLabelName(920,user.getLanguage())%><!-- 车辆 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="carid" style="width:100%" onchange="checkSelect('carid','caridSpan');">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and type=137";
						rs.executeSql(sql);
						flag = false;
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("627_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
								flag = true;
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
				<span id="caridSpan">
					<% if (!flag) { %>
						<img align='absMiddle' src='/images/BacoError_wev8.gif' >
					<% } %>
				</span>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="628"/>
				<%=SystemEnv.getHtmlLabelName(17649,user.getLanguage())%><!-- 司机 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="driver" style="width:100%">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and (type=1 or type=165)";
						rs.executeSql(sql);
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("628_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="629"/>
				<%=SystemEnv.getHtmlLabelName(17670,user.getLanguage())%><!-- 用车人 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="usecarer" style="width:100%" onchange="checkSelect('usecarer','usecarerSpan');">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and (type=1 or type=165)";
						rs.executeSql(sql);
						flag = false;
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("629_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
								flag = true;
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
				<span id="usecarerSpan">
					<% if (!flag) { %>
						<img align='absMiddle' src='/images/BacoError_wev8.gif' >
					<% } %>
				</span>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="634"/>
				<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%><!-- 开始日期 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="startdate" style="width:100%" onchange="checkSelect('startdate','startdateSpan');">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and type=2";
						rs.executeSql(sql);
						flag = false;
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("634_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
								flag = true;
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
				<span id="startdateSpan">
					<% if (!flag) { %>
						<img align='absMiddle' src='/images/BacoError_wev8.gif' >
					<% } %>
				</span>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="635"/>
				<%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%><!-- 开始时间 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="starttime" style="width:100%" onchange="checkSelect('starttime','starttimeSpan');">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and type=19";
						rs.executeSql(sql);
						flag = false;
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("635_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
								flag = true;
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
				<span id="starttimeSpan">
					<% if (!flag) { %>
						<img align='absMiddle' src='/images/BacoError_wev8.gif' >
					<% } %>
				</span>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="636"/>
				<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%><!-- 结束日期 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="enddate" style="width:100%" onchange="checkSelect('enddate','enddateSpan');">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and type=2";
						rs.executeSql(sql);
						flag = false;
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("636_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
								flag = true;
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
				<span id="enddateSpan">
					<% if (!flag) { %>
						<img align='absMiddle' src='/images/BacoError_wev8.gif' >
					<% } %>
				</span>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="637"/>
				<%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%><!-- 结束时间 -->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="endtime" style="width:100%" onchange="checkSelect('endtime','endtimeSpan');">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=3 and type=19";
						rs.executeSql(sql);
						flag = false;
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("637_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
								flag = true;
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
				<span id="endtimeSpan">
					<% if (!flag) { %>
						<img align='absMiddle' src='/images/BacoError_wev8.gif' >
					<% } %>
				</span>
			</wea:item>
			<wea:item>
				<input type="hidden" name="carfieldid" value="639"/>
				<%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%><!-- 撤销-->
			</wea:item>
			<wea:item>
				<select name="modefieldid" id="cancel" style="width:100%">
					<option value=""></option>
					<%
						sql = "select id,fieldname,fieldlabel from workflow_billfield where (viewtype is null or viewtype<>1) and billid = " + formid + " and fieldhtmltype=4";
						rs.executeSql(sql);
						while (rs.next()) {
							String fieldid = rs.getString("id");
							String fieldname = rs.getString("fieldname");
							int fieldlabel = rs.getInt("fieldlabel");
							String showname = "".equals(fieldlabel) ? "" : SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							boolean selected = existsMap.containsKey("639_"+fieldid);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
							}
					%>
							<option value="<%=fieldid%>" <%=selectedstr%>><%=showname %></option>
					<%  } %>
				</select>
			</wea:item>
	</wea:group>
</wea:layout>
</form>
<script>
function doSave(){
	var checkFields = "carid,usecarer,startdate,starttime,enddate,endtime";
	var isMust = true;
	var chkobj = checkFields.split(",");
	for (var i = 0 ; i < chkobj.length ; i++) {
		if (!jQuery("#"+ chkobj[i]).val()) {
			isMust = false;
			break;
		}
	}
	if (!isMust) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
		return;
	}
	enableAllmenu();
	$GetEle("frmmain").submit();
}
function checkSelect(objid,objspanid){
	var img = "<img align='absMiddle' src='/images/BacoError_wev8.gif'>";
	var modeid= jQuery("#"+objid).val();
	var modeidSpan = jQuery("#"+objspanid);
	if(modeid!=""){
		modeidSpan.html("");
	}else{
		modeidSpan.html(img);
	}
}
</script>