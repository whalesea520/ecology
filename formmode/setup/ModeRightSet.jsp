
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page"/>
<html>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());// 权限设置 
String needfav ="";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);
ModeRightInfo.setModeid(modeId);
ModeRightInfo.getModeRight();
List rightList = ModeRightInfo.getRightList();
Map indexMap = ModeRightInfo.getIndexMap();
//显示模板
String sharetype_view = "";
String relatedid_view = "";
String relatedname_view = "";
String operate_view = "";
String level_view = "";
int index_view = Util.getIntValue((String)indexMap.get("0"),-1);
if(index_view > -1){
	Map dataMap_view = (Map)rightList.get(index_view);
	sharetype_view = (String)dataMap_view.get("sharetype");
	relatedid_view = (String)dataMap_view.get("relatedid");
	relatedname_view = (String)dataMap_view.get("relatedname");
	operate_view = (String)dataMap_view.get("operate");
	level_view = (String)dataMap_view.get("level");
}


//新建
String sharetype_add = "";
String relatedid_add = "";
String relatedname_add = "";
String operate_add = "";
String level_add = "";
int index_add = Util.getIntValue((String)indexMap.get("1"),-1);
if(index_add > -1){
	Map dataMap_add = (Map)rightList.get(index_add);
	sharetype_add = (String)dataMap_add.get("sharetype");
	relatedid_add = (String)dataMap_add.get("relatedid");
	relatedname_add = (String)dataMap_add.get("relatedname");
	operate_add = (String)dataMap_add.get("operate");
	level_add = (String)dataMap_add.get("level");
}

//编辑
String sharetype_edit = "";
String relatedid_edit = "";
String relatedname_edit = "";
String operate_edit = "";
String level_edit = "";
int index_edit = Util.getIntValue((String)indexMap.get("2"),-1);
if(index_edit > -1){
	Map dataMap_edit = (Map)rightList.get(index_edit);
	sharetype_edit = (String)dataMap_edit.get("sharetype");
	relatedid_edit = (String)dataMap_edit.get("relatedid");
	relatedname_edit = (String)dataMap_edit.get("relatedname");
	operate_edit = (String)dataMap_edit.get("operate");
	level_edit = (String)dataMap_edit.get("level");
}

//监控
String sharetype_monitor = "";
String relatedid_monitor = "";
String relatedname_monitor = "";
String operate_monitor = "";
String level_monitor = "";
int index_monitor = Util.getIntValue((String)indexMap.get("3"),-1);
if(index_edit > -1){
	Map dataMap_monitor = (Map)rightList.get(index_monitor);
	sharetype_monitor = (String)dataMap_monitor.get("sharetype");
	relatedid_monitor = (String)dataMap_monitor.get("relatedid");
	relatedname_monitor = (String)dataMap_monitor.get("relatedname");
	operate_monitor = (String)dataMap_monitor.get("operate");
	level_monitor = (String)dataMap_monitor.get("level");
}

%>
<form id="modeRight" name="modeRight" method=post action="ModeRightOperation.jsp" >
<input type="hidden" name="modeId" value="<%=modeId %>">
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr><td height="10" colspan="3"></td></tr>
<tr>
<td></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<!--开始-->
  <table class="viewform">
    <COLGROUP>
    <COL width="20%">
	<COL width="80%">
    <TR class="Title"><Th colSpan=2><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></Th></TR><!-- 设置 -->
    <TR class="Spacing"><TD class="Line1" colspan=2></TD></TR>
    <tr><!-- 显示模板权限 -->
      <td><%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%></td>
      <td class=Field>
        <SELECT class=InputStyle  name=sharetype_view id="sharetype_view" onchange="onChangeSharetype(this,relatedid_view,showrelatedname_view,'view')" >
          <option value="-1"></option>
          <option value="0" <%if(sharetype_view.equals("0")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->   
          <option value="1" <%if(sharetype_view.equals("1")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
          <option value="2" <%if(sharetype_view.equals("2")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
          <option value="3" <%if(sharetype_view.equals("3")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
          <option value="4" <%if(sharetype_view.equals("4")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
        </SELECT>&nbsp;&nbsp;
        <span id=showspan_view <%if(sharetype_view.equals("0") || sharetype_view.equals("")){%>style="display:none"<%} %>>
	      <BUTTON class=Browser id="btnRelated_view" style="display:''" onClick="onShowRelated(relatedid_view,showrelatedname_view,'view')" name="btnRelated_view"></BUTTON> 
	      <INPUT type=hidden name="relatedid_view"  id="relatedid_view" value="<%=relatedid_view %>">
	      <span id="showrelatedname_view" name="showrelatedname_view">
	  		<%=relatedname_view %>
		  </span>
	    </span>
      </td>
    </tr>
    <tr style='display:none' style="height:1px;"><td></td><td class="line"></td></tr>
	<tr id='securitylevel_tr_view' style='display:none'>
		<td width="20%"></td>
		<td width="80%" class="field">
	 	<select class="InputStyle" name="operate_view" id="operate_view">
			<option value="0" <%if(operate_view.equals("0")){ %>selected<%} %>>>=</option>
			<option value="1" <%if(operate_view.equals("1")){ %>selected<%} %>><=</option>
		</select>
		<input id='level_view' name='level_view' value="<%=level_view %>" type='text' size='3' class='inputstyle' value='10'>
	 	<span id=levelspan_view name=levelspan_view ></span>
	 	<font color="red">(<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>)</font>
	 </td>
	</tr>
	
    <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
    <tr><!-- 新建模板权限 -->
      <td><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></td>
      <td class=Field>
        <SELECT class=InputStyle  name=sharetype_add id="sharetype_add" onchange="onChangeSharetype(this,relatedid_add,showrelatedname_add,'add')" >
          <option value="-1"></option>
          <option value="0" <%if(sharetype_add.equals("0")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->   
          <option value="1" <%if(sharetype_add.equals("1")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
          <option value="2" <%if(sharetype_add.equals("2")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
          <option value="3" <%if(sharetype_add.equals("3")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
          <option value="4" <%if(sharetype_add.equals("4")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
        </SELECT>&nbsp;&nbsp;
        <span id=showspan_add <%if(sharetype_add.equals("0") || sharetype_add.equals("")){%>style="display:none"<%} %>>
	      <BUTTON class=Browser id="btnRelated_add" style="display:''" onClick="onShowRelated(relatedid_add,showrelatedname_add,'add')" name="btnRelated_add"></BUTTON> 
	      <INPUT type=hidden name="relatedid_add"  id="relatedid_add" value="<%=relatedid_add %>">
	      <span id="showrelatedname_add" name="showrelatedname_add">
	  		<%=relatedname_add %>
		  </span>
	    </span>
      </td>
    </tr>
    <tr style='display:none' style="height:1px;"><td></td><td class="line"></td></tr>
	<tr id='securitylevel_tr_add' style='display:none'>
		<td width="20%"></td>
		<td width="80%" class="field">
	 	<select class="InputStyle" name="operate_add" id="operate_add">
			<option value="0" <%if(operate_add.equals("0")){ %>selected<%} %>>>=</option>
			<option value="1" <%if(operate_add.equals("1")){ %>selected<%} %>><=</option>
		</select>
		<input id='level_add' name='level_add' value="<%=level_add %>" type='text' size='3' class='inputstyle' value='10'>
	 	<span id=levelspan_add name=levelspan_add ></span>
	 	<font color="red">(<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>)</font>
	 </td>
    </tr>
    <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
    <tr><!-- 编辑模板权限 -->
      <td><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></td>
      <td class=Field>
        <SELECT class=InputStyle  name=sharetype_edit id="sharetype_edit" onchange="onChangeSharetype(this,relatedid_edit,showrelatedname_edit,'edit')" >
          <option value="-1"></option>
          <option value="0" <%if(sharetype_edit.equals("0")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->   
          <option value="1" <%if(sharetype_edit.equals("1")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
          <option value="2" <%if(sharetype_edit.equals("2")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
          <option value="3" <%if(sharetype_edit.equals("3")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
          <option value="4" <%if(sharetype_edit.equals("4")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
        </SELECT>&nbsp;&nbsp;
        <span id=showspan_edit <%if(sharetype_edit.equals("0") || sharetype_edit.equals("")){%>style="display:none"<%} %>>
	      <BUTTON class=Browser id="btnRelated_edit" style="display:''" onClick="onShowRelated(relatedid_edit,showrelatedname_edit,'edit')" name="btnRelated_edit"></BUTTON> 
	      <INPUT type=hidden name="relatedid_edit"  id="relatedid_edit" value="<%=relatedid_edit %>">
	      <span id="showrelatedname_edit" name="showrelatedname_edit">
	  		<%=relatedname_edit %>
		  </span>
	    </span>
      </td>
    </tr>
    <tr style='display:none' style="height:1px;"><td></td><td class="line"></td></tr>
	<tr id='securitylevel_tr_edit' style='display:none'>
		<td width="20%"></td>
		<td width="80%" class="field">
	 	<select class="InputStyle" name="operate_edit" id="operate_edit">
			<option value="0" <%if(operate_edit.equals("0")){ %>selected<%} %>>>=</option>
			<option value="1" <%if(operate_edit.equals("1")){ %>selected<%} %>><=</option>
		</select>
		<input id='level_edit' name='level_edit' value="<%=level_edit %>" type='text' size='3' class='inputstyle' value='10'>
	 	<span id=levelspan_edit name=levelspan_edit ></span>
	 	<font color="red">(<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>)</font>
	 </td>
    </tr>
    <TR class="Spacing"><TD class="Line" colSpan=2></TD></TR>
    <tr><!-- 监控模板权限 -->
      <td><%=SystemEnv.getHtmlLabelName(665,user.getLanguage())%></td>
      <td class=Field>
        <SELECT class=InputStyle  name=sharetype_monitor id="sharetype_monitor" onchange="onChangeSharetype(this,relatedid_monitor,showrelatedname_monitor,'monitor')" >
          <option value="-1"></option>
          <option value="0" <%if(sharetype_monitor.equals("0")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->   
          <option value="1" <%if(sharetype_monitor.equals("1")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
          <option value="2" <%if(sharetype_monitor.equals("2")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
          <option value="3" <%if(sharetype_monitor.equals("3")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
          <option value="4" <%if(sharetype_monitor.equals("4")){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
        </SELECT>&nbsp;&nbsp;
        <span id=showspan_monitor <%if(sharetype_monitor.equals("0") || sharetype_monitor.equals("")){%>style="display:none"<%} %>>
	      <BUTTON class=Browser id="btnRelated_monitor" style="display:''" onClick="onShowRelated(relatedid_monitor,showrelatedname_monitor,'monitor')" name="btnRelated_monitor"></BUTTON> 
	      <INPUT type=hidden name="relatedid_monitor"  id="relatedid_monitor" value="<%=relatedid_monitor %>">
	      <span id="showrelatedname_monitor" name="showrelatedname_monitor">
			<%=relatedname_monitor %>
		  </span>
	    </span>
      </td>
    </tr>
    <tr style='display:none' style="height:1px;"><td></td><td class="line"></td></tr>
	<tr id='securitylevel_tr_monitor' style='display:none'>
		<td width="20%"></td>
		<td width="80%" class="field">
	 	<select class="InputStyle" name="operate_monitor" id="operate_monitor">
			<option value="0" <%if(operate_monitor.equals("0")){ %>selected<%} %>>>=</option>
			<option value="1" <%if(operate_monitor.equals("1")){ %>selected<%} %>><=</option>
		</select>
		<input id='level_monitor' name='level_monitor' value="<%=level_monitor %>" type='text' size='3' class='inputstyle' value='10'>
	 	<span id=levelspan_monitor name=levelspan_monitor ></span>
	 	<font color="red">(<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>)</font>
	 </td>
    </tr>
    <TR class="Spacing"><TD class="Line1" colspan=2></TD></TR>
  </table>
<!--结束-->
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
</table>
</form>
</body>
<script type="text/javascript">
$(document).ready(function(){//onload事件
	$(".loading", window.parent.document).hide(); //隐藏加载图片
    loadbody('view');
    loadbody('add');
    loadbody('edit');
    loadbody('monitor');
})

function loadbody(type){
	var sharetype = jQuery("#sharetype_"+type).val();
    if(sharetype == 2 ||sharetype == 3 ||sharetype == 0 ){
    	jQuery("#securitylevel_tr_"+type).show();
		jQuery("#securitylevel_tr_"+type).prev().show();
    }
}
function doSubmit(obj){
	obj.disabled=true;
	modeRight.submit();
}

function onChangeSharetype(seleObj,txtObj,spanObj,types){
	var thisvalue=seleObj.value;	
    var strAlert= ""
	
	if(thisvalue==1 || thisvalue==4){  //人员或角色
		document.getElementById("showspan_"+types).style.display='';
		jQuery("#securitylevel_tr_"+types).hide();
		jQuery("#securitylevel_tr_"+types).prev().hide()
		jQuery("#operate"+types).val(0);
		jQuery("#level_"+types).val(10);
		txtObj.value="";
		spanObj.innerHTML=strAlert;
	} else if (thisvalue==2 || thisvalue==3 || thisvalue==0)	{ //分部,部门,所有人
		if(thisvalue>0){
			document.getElementById("showspan_"+types).style.display='';
		}else{
			document.getElementById("showspan_"+types).style.display='none';
		}
		jQuery("#securitylevel_tr_"+types).show();
		jQuery("#securitylevel_tr_"+types).prev().show();
		jQuery("#operate_"+types).val(0);
		jQuery("#level_"+types).val(10);
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}	
}

function onShowRelated(inputname,spanname,type){
	var sharetype = $G("sharetype_"+type).value;
	var datas = "";
	if(sharetype == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(sharetype == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(sharetype == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(sharetype == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}
	if (datas != undefined && datas != null) {
		var ids = "";
		var names = "";
		if(datas.id != ''){
			if(sharetype != '4'){
				ids = datas.id.substring(1);
				names = datas.name.substring(1);
			}else{
				ids = datas.id;
				names = datas.name;
			}
			inputname.value = ids;
			spanname.innerHTML = names;
		}else{
			inputname.value = ids;
			spanname.innerHTML = names;
		}
	}
}
</script>
