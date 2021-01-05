<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	/*
	 关于字段的数据库类型的中文表述没完成，需要另外添加标签

	 */
%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.lang.*"%>

<jsp:useBean id="FieldInfo" class="weaver.workflow.field.FieldManager"
	scope="page" />
<jsp:useBean id="FieldMainManager"
	class="weaver.workflow.field.FieldMainManager" scope="page" />
<jsp:useBean id="BrowserComInfo"
	class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />


<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />

<%
	String advancedSearch = SystemEnv.getHtmlLabelName(21995 , user.getLanguage()) ;
	String menu = SystemEnv.getHtmlLabelName(81804 , user.getLanguage()) ;
	String newMainField = SystemEnv.getHtmlLabelName(125019 , user.getLanguage()) ;
	String editMainField = SystemEnv.getHtmlLabelName(125021 , user.getLanguage()) ;	
	//System.out.println("===================================mainField="+ mainField);
%>

</head>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(684,
			user.getLanguage());
	String needfav = "1";
	String needhelp = "";

	String fieldhtmltypeForSearch = Util.null2String(request.getParameter("fieldhtmltypeForSearch"));
	String type = Util.null2String(request.getParameter("type"));
	String type1 = Util.null2String(request.getParameter("type1"));
	String type2 = Util.null2String(request.getParameter("type2"));
	String type3 = Util.null2String(request.getParameter("type3"));
	String fieldnameForSearch = Util.null2String(request.getParameter("fieldnameForSearch"));
	String fielddec = Util.null2String(request.getParameter("fielddec"));
	//System.out.println(fieldnameForSearch+"AAA");
	//2012-08-10 ypc 添加以下代码
	if(fieldnameForSearch.equals("undefined")){
		fieldnameForSearch="";
	}
	if(fielddec.equals("undefined")){
		fielddec="";
	}
%>
<%
	if (Util.null2String(request.getParameter("srcType")).equals(
			"detailfield")) {
%>
<script language="javascript">
     location = "managedetailfield.jsp?fieldhtmltypeForSearch=<%=fieldhtmltypeForSearch%>&type=<%=type%>&type1=<%=type1%>&fieldnameForSearch=<%=fieldnameForSearch%>&fielddec=<%=fielddec%>";    
  </script>
<%
	}
%>
<script language="javascript">
function CheckAll(checked) {
len = document.form2.elements.length;
var i=0;
for( i=0; i<len; i++) {
if (document.form2.elements[i].name=='delete_field_id') {
if(!document.form2.elements[i].disabled){
    document.form2.elements[i].checked=(checked==true?true:false);
}
} } }


function unselectall()
{
    if(document.form2.checkall0.checked){
	document.form2.checkall0.checked =0;
    }
}
function confirmdel() {
	len=document.form2.elements.length;
	var i=0;
	for(i=0;i<len;i++){
		if (document.form2.elements[i].name=='delete_field_id')
			if(document.form2.elements[i].checked)
				break;
	}
	if(i==len){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15445, user.getLanguage())%>");
		return false;
	}
	
	var isbool = false;
	top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7, user.getLanguage())%>", function (){
		isbool = true;
	}, function () {}, 320, 90,true);

	return isbool;
}

</script>
<body>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		String fieldid = ""+ Util.getIntValue(request.getParameter("fieldid"), 0);
		String fieldname = Util.null2String(request.getParameter("fieldname"));
		String fielddbtype = Util.null2String(request.getParameter("fielddbtype"));
		String fieldhtmltype = Util.null2String(request.getParameter("fieldhtmltype"));

		String sql = "select distinct fieldid from workflow_formfield ";
		String useids = "";
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			useids += "," + RecordSet.getString(1);
		}
		//获得系统默认工作流所使用的字段ID TD9092
		sql = "select distinct fieldid from workflow_formfield where formid=14";
		String sysusedids = "";
		RecordSet.executeSql(sql);
		while (RecordSet.next()) {
			sysusedids += "," + RecordSet.getString(1);
		}
		//int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
		int detachable = 0;//字段管理不分权，TD10331
		int subCompanyId = -1;
		int operatelevel = 0;

		if (detachable == 1) {
			if (request.getParameter("subCompanyId") == null) {
				subCompanyId = Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")), -1);
			} else {
				subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);
			}
			if (subCompanyId == -1) {
				subCompanyId = user.getUserSubCompany1();
			}
			session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
			operatelevel = CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"FieldManage:All", subCompanyId);
		} else {
			if (HrmUserVarify.checkUserRight("FieldManage:All", user))
				operatelevel = 2;
		}
	%>
		<%
			//RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage())+ ",javascript:searchData(),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			//RCMenu += "{" + SystemEnv.getHtmlLabelName(199, user.getLanguage())+ ",javascript:doReset(),_self}";
			//RCMenuHeight += RCMenuHeightStep;
			if (operatelevel > 0) {
				RCMenu += "{"+ SystemEnv.getHtmlLabelName(82, user.getLanguage())+ ",javascript:newDialog(),_self}";
				RCMenuHeight += RCMenuHeightStep;
			}
			if (operatelevel > 1) {
				RCMenu += "{"+ SystemEnv.getHtmlLabelName(32136, user.getLanguage())+ ",javascript:deltype(),_self}";
				RCMenuHeight += RCMenuHeightStep;
			}
			/*
			RCMenu += "{"+ SystemEnv.getHtmlLabelName(197, user.getLanguage())+ ",javascript:onBtnSearchClick(),_self}";
			RCMenuHeight += RCMenuHeightStep;*/
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form id="form2" name="form2" method="post" action="delfields.jsp">
<TABLE class=Shadow>
<tr>
<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(operatelevel>0){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(83981 , user.getLanguage()) %>" class="e8_btn_top" onclick="newDialog()"/>
		<%} %>
		<%if(operatelevel>1){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136 , user.getLanguage()) %>" class="e8_btn_top" onclick="deltype()"/>
		<%} %>			
			<input type="text" class="searchInput" name="flowTitle" value="<%=fieldnameForSearch%>"/>
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch"></span>
			<span id="menu" title class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
	<wea:layout type="fourCol">
	    <wea:group context='<%=SystemEnv.getHtmlLabelName(20550 , user.getLanguage()) %>'>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></wea:item>
		    <wea:item><input type=text name=fieldnameForSearch class=Inputstyle value='<%=fieldnameForSearch%>'></wea:item>
	    	<wea:item><%=SystemEnv.getHtmlLabelName(687, user.getLanguage())%></wea:item>
	    	<wea:item>
	    			<select class=inputstyle size="1" name="fieldhtmltypeForSearch" onchange="showType()">
					<option value="0"></option>
					<option value="1" <%if (fieldhtmltypeForSearch.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(688, user.getLanguage())%></option>
					<option value="2" <%if (fieldhtmltypeForSearch.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(689, user.getLanguage())%></option>
					<option value="3" <%if (fieldhtmltypeForSearch.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(695, user.getLanguage())%></option>
					<option value="4" <%if (fieldhtmltypeForSearch.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(691, user.getLanguage())%></option>
					<option value="5" <%if (fieldhtmltypeForSearch.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(690, user.getLanguage())%></option>
					<option value="6" <%if (fieldhtmltypeForSearch.equals("6")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%></option>
					<option value="7" <%if (fieldhtmltypeForSearch.equals("7")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21691, user.getLanguage())%></option>
					<option value="9" <%if (fieldhtmltypeForSearch.equals("9")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(125583, user.getLanguage())%></option>
					</select>
	    	</wea:item>
	    	<%
	    		String typeShow = "{'samePair':'typeShow','display':'none'}";
	    		if (fieldhtmltypeForSearch.equals("1") || fieldhtmltypeForSearch.equals("3") || fieldhtmltypeForSearch.equals("7")) {
	    			typeShow = "{'samePair':'typeShow','display':'none'}";typeShow = "{'samePair':'typeShow','display':''}";
	    		}
	    	%>
	    	<wea:item attributes='<%=typeShow %>'>
				<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%> 
	    	</wea:item>
	    	<wea:item attributes='<%=typeShow %>'>
	    		<select class=inputstyle size="1" name="type" <%if (fieldhtmltypeForSearch.equals("1")) {%>style="display:'';width: 312px; " <%} else {%> style="display:none;width: 312px;" <%}%> >
					<option value="0"></option>
					<option value="1" <%if (type.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(608, user.getLanguage())%></option>
					<option value="2" <%if (type.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(696, user.getLanguage())%></option>
					<option value="3" <%if (type.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(697, user.getLanguage())%></option>
					<option value="4" <%if (type.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18004, user.getLanguage())%></option>
					<option value="5" <%if (type.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(22395, user.getLanguage())%></option>
				</select> 
				<select class=inputstyle size="1" name="type1" <%if (fieldhtmltypeForSearch.equals("3")) {%>style="display: '';width: 312px; " <%} else {%> style="display:none;width: 312px;" <%}%>>
					<option value="0"></option>
					<%
					while (BrowserComInfo.next()) {
						String browserid = Util.null2String(BrowserComInfo.getBrowserid());
						int browserlableid = Util.getIntValue(BrowserComInfo.getBrowserlabelid(), 0);
						if(browserid.equals("256") || browserid.equals("257")){
							continue;
						}
					%>
					<option value="<%=browserid%>" <%if (type1.equals(browserid)) {%> selected <%}%>>
					<%=SystemEnv.getHtmlLabelName(browserlableid,user.getLanguage())%>
					</option>
					<%}%>
				</select> 
				<select class=inputstyle size="1" name="type2" <%if (fieldhtmltypeForSearch.equals("7")) {%> style="display: '';width: 312px; " <%} else {%> style="display:none;width: 312px;" <%}%>>
					<option value="0"></option>
					<option value="1" <%if (type2.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21692, user.getLanguage())%></option>
					<option value="2" <%if (type2.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21693, user.getLanguage())%></option>
				</select> 
				<select class=inputstyle size="1" name="type3"  <%if (fieldhtmltypeForSearch.equals("6")) {%> style="display: '';width: 312px;" <%} else {%> style="display:none;width: 312px;" <%}%>>
					<option value="0"></option>
					<option value="1" <%if (type3.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20798, user.getLanguage())%></option>
					<option value="2" <%if (type3.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20001, user.getLanguage())%></option>
				</select>
	    	</wea:item>
	    	<wea:item attributes='<%=typeShow %>'>
				<%=SystemEnv.getHtmlLabelName(261, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%>
	    	</wea:item>
	    	<wea:item attributes='<%=typeShow %>'>
	    	   <input type=text name=fielddec class=Inputstyle value="<%=fielddec%>">
	    	</wea:item>
	    	
	    </wea:group>
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="searchData();"/>
				<span class="e8_sep_line">|</span>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
				<span class="e8_sep_line">|</span>
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>							
<%				
String sqlWhere = "";
if(subCompanyId != -1){
	if(sqlWhere.equals("")){
		sqlWhere += " where subcompanyid = " + subCompanyId;
	}else{
		sqlWhere += " and subcompanyid = " + subCompanyId;
	}
}
if(!fieldhtmltypeForSearch.equals("")&&!fieldhtmltypeForSearch.equals("0")){
	if(sqlWhere.equals("")){
		sqlWhere += " where fieldhtmltype = " + fieldhtmltypeForSearch;
	}else{
		sqlWhere += " and fieldhtmltype = " + fieldhtmltypeForSearch;
	}
}
if(!type.equals("")&&!type.equals("0")){
	if(sqlWhere.equals("")){
		sqlWhere += " where type = " + type;
	}else{
		sqlWhere += " and type = " + type;
	}
}
if(!type1.equals("")&&!type1.equals("0")){
	if(sqlWhere.equals("")){
		sqlWhere += " where type = " + type1;
	}else{
		sqlWhere += " and type = " + type1;
	}
}
if(!fieldnameForSearch.equals("")){
	if(sqlWhere.equals("")){
		sqlWhere += " where fieldname like '%" + fieldnameForSearch + "%'";
	}else{
		sqlWhere += " and fieldname like '%" + fieldnameForSearch + "%'";
	}
}
if(!fielddec.equals("")){
	if(sqlWhere.equals("")){
		sqlWhere += " where description like '%" + fielddec + "%'";
	}else{
		sqlWhere += " and description like '%" + fielddec + "%'";
	}
}
String orderby =" fieldhtmltype,type,fieldname ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,fieldname,fielddbtype,fieldhtmltype,type,subcompanyid,description,textheight,childfieldid,imgheight,imgwidth ";
String fromSql  = " workflow_formdict ";
String para1 = "column:id+column:fieldname+"+user.getLanguage()+"+"+sysusedids+"+"+useids+"+mainfield";
String para2 = "column:id+column:fieldname+"+user.getLanguage()+"+"+sysusedids+"+mainfield";
String para3 = "column:id+column:fieldname+"+user.getLanguage()+"+"+sysusedids+"+"+useids+"+column:description+column:fieldhtmltype+column:type"+"+mainfield";
String para4 = "column:type+"+user.getLanguage();
tableString =   " <table instanceid=\"workflow_formdictTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FIELD_MANAGEFIELD,user.getUID())+"\" >"+
				" <checkboxpopedom  id=\"checkbox\" popedompara=\""+para1+"\" showmethod=\"weaver.workflow.field.FieldMainManager.getCheckbox\" />"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"4%\"   text=\"\" otherpara=\""+para2+"\"  orderkey=\"fieldname\" transmethod=\"weaver.workflow.field.FieldMainManager.getSysField\"/>"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"fieldname\" otherpara=\""+para3+"\" orderkey=\"fieldname\" transmethod=\"weaver.workflow.field.FieldMainManager.getFieldName\" />"+
                "           <col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(261, user.getLanguage())+SystemEnv.getHtmlLabelName(433, user.getLanguage())+"\" column=\"description\" orderkey=\"description\" />"+
                "           <col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(687,user.getLanguage())+"\" column=\"fieldhtmltype\" otherpara=\""+para4+"\" orderkey=\"fieldhtmltype\" transmethod=\"weaver.workflow.field.FieldMainManager.getFieldHtmlTypeShow\" />"+
                "			<col width=\"18%\"  text=\""+SystemEnv.getHtmlLabelName(686,user.getLanguage())+"\" column=\"fielddbtype\" orderkey=\"fielddbtype\" />"+
                "       </head>"+
                "		<operates>"+
                "		<popedom column=\"id\" otherpara=\""+para1+"\" transmethod=\"weaver.workflow.field.FieldMainManager.checkEditAndDel\"></popedom> "+
                "		<operate href=\"javascript:onEdit();\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" target=\"_self\" index=\"0\"/>"+
				"		<operate href=\"javascript:onDel();\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"		</operates>"+                   
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>							
							</td>
						</tr>
					</TABLE>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_FIELD_MANAGEFIELD%>"/>
</form>
<script language="javascript">
function submitData()
{
	if (confirmdel())
	{
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22288, user.getLanguage())%>", function (){
			form2.submit();
			}, function () {}, 320, 90,true);
    }
}
function searchData(){
	//para4 = $("input[name=fieldnameForSearch]").val();
	//para5 =$("input[name=fielddec]").val();
	//para1 =$("select[name=fieldhtmltypeForSearch]").val();
	//para3 = $("select[name=type1]").val();
	//para2 = $("select[name=type]").val();
	//para6 = $("select[name=type2]").val();
	//para7 = $("select[name=type3]").val();
	
	//window.location="managefield.jsp?fieldhtmltypeForSearch="+para1+"&type="+para2+"&type1="+para3+"&fieldnameForSearch="+para4+"&fielddec="+para5+"&type2="+para6+"&type3="+para7;
	form2.action="managefield.jsp";
	form2.submit();
}

function showType(){
	//点击重置后 此处应该用getElementById去获取选中先的id值
	var htmltype=$("select[name=fieldhtmltypeForSearch]").val();
	hideEle("typeShow");
	if(htmltype==1){
		showEle("typeShow");
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');		
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type]").selectbox("detach");
		//$("select[name=type]").next().show();
		$("select[name=type]").selectbox("attach");
		$("select[name=type3]").next().hide();
		$("select[name=type1]").next().hide();
		$("select[name=type2]").next().hide();
	}else if(htmltype==3){
		showEle("typeShow");
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');
        $("select[name=type]").next().hide();
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type3]").next().hide();
		//$("select[name=type1]").next().show();
		$("select[name=type1]").selectbox("detach");
		$("select[name=type1]").selectbox("attach");
		$("select[name=type2]").next().hide();		
	}else if(htmltype==6){
		showEle("typeShow");
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');       
        $("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type]").next().hide();
		//$("select[name=type3]").next().show();
		$("select[name=type3]").selectbox("detach");
		$("select[name=type3]").selectbox("attach");
		$("select[name=type1]").next().hide();
		$("select[name=type2]").next().hide();
	}else if(htmltype==7){
		showEle("typeShow");
		$("#typename").html('<%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%>');
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type]").next().hide();
		//$("select[name=type3]").hide();
		//该字段属性改为show 才能带出 属性使用错误
		//2012-08-10 ypc 修改
		//$("select[name=type3]").next().show();
		$("select[name=type2]").selectbox("detach");
		$("select[name=type2]").selectbox("attach");
		$("select[name=type1]").next().hide();
		$("select[name=type3]").next().hide();
	} else {
		$("#typename").html('');
		$("select[name=type1]").val('0');
		$("select[name=type2]").val('0');
		$("select[name=type3]").val('0');
		$("select[name=type]").next().hide();
		$("select[name=type3]").next().hide();
		$("select[name=type1]").next().hide();
		$("select[name=type2]").next().hide();
	}
}

</script>
</body>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();

	$("#advancedSearch").html("<%=advancedSearch%>");
	$("#menu").attr("title", "<%=menu%>");	
});
function newDialog(){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 1000;
	diag_vote.Height = 450;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=newMainField%>";
	diag_vote.URL = "/workflow/field/addfield.jsp?dialog=1&srcType=mainfield";
	diag_vote.isIframe=false;
	diag_vote.show();
	//window.location = "/workflow/field/addfield.jsp?srcType=mainfield";
}

function closeDialog(){
	diag_vote.close();
}

function deltype(){
	var fieldids="";
	$("input[name='chkInTableTag']:checked").each(function(){
		fieldids +="&fieldid="+$(this).attr("checkboxId");
	});
	if(fieldids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return ;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/field/delfields.jsp?from=managefield"+fieldids;
				}, function () {}, 320, 90,true);
}

function onDel(id){
	$("#_xTable_"+id).attr("checked",true);
	changeCheckboxStatus($("#_xTable_"+id),true);
	
	deltype();	
}

function onEdit(id){
   var link = $("#ref_"+id).attr("rehref");
    link=link.substring(link.lastIndexOf("/")+1);
   	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 1000;
	diag_vote.Height = 450;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=editMainField%>";
	diag_vote.URL = "/workflow/field/"+link+"&dialog=1";
	diag_vote.isIframe=false;
	diag_vote.show();
    //window.location=link;	
}

function onBtnSearchClick(){
	var flowTitle = $("input[name=flowTitle]", parent.document).val();
		try{
		flowTitle = encodeURI(flowTitle);
	}catch(e){
		if(window.console)console.log(e)
	 }
	window.location="managefield.jsp?fieldnameForSearch="+flowTitle;
}	
	
</script>
</html>
