<%@page import="weaver.formmode.setup.ModeSetUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.general.GCONST" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Browser_wev8.css>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" type="text/css" href="/css/xpSpin_wev8.css">
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<link href="/formmode/js/jquery/jquery-ui-1.10.3/themes/base/jquery-ui_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/formmode/js/modebrow_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script language="javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript" src="../js/dynamicLoadingUtils.js"></script>
</HEAD>
<%

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String id=Util.null2String(request.getParameter("id"));
String action=Util.null2String(request.getParameter("action"));
String name="";
String remark="";
String formid="";
String modeid="";
if("".equals(id)){
	modeid = Util.null2String(request.getParameter("modeid"));
}else{
	rs.executeSql("select * from mode_batchmodify where id="+id);
	if(rs.next()){
		name = Util.null2String(rs.getString("name"));
		remark = Util.null2String(rs.getString("remark"));
		modeid = Util.null2String(rs.getString("modeid"));
		formid = Util.null2String(rs.getString("formid"));
	}
}

modeSetUtil.setModeId(Util.getIntValue(modeid));
modeSetUtil.loadMode();
int pformid = modeSetUtil.getFormId();
if("create".equals(action)){//create 创建  modify 修改
	formid = pformid+"";
}else{
	if(!formid.equals(pformid+"")){
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(125495,user.getLanguage())+",javascript:submitAndGetData(this),_self} " ;//保存并选择
RCMenuHeight += RCMenuHeightStep;
//删除 zwbo
if(!id.equals("")){
RCMenu += "{"+SystemEnv.getHtmlLabelName(131200,user.getLanguage())+",javascript:deleteData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:close(),_self} " ;//关闭
RCMenuHeight += RCMenuHeightStep;
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存 -->
				<input class="e8_btn_top middle" onclick="javascript:submitData(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(125495,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存并选择 -->
				<input class="e8_btn_top middle" onclick="javascript:submitAndGetData(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(125495,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<FORM NAME=ModifyForm STYLE="margin-bottom:0" action="/formmode/setup/batchmodifyOperation.jsp" method="post">
<input type="hidden" value="<%=id%>" name="id">
<input type="hidden" value="<%=modeid%>" id="modeid"; name="modeid">
<input type="hidden" value="<%=formid%>" id="formid" name="formid">
<input type="hidden" value="0" name="saveflag" id="saveflag">
<!-- 删除操作的标志  1为删除 0为其他  zwbo -->
<input type="hidden" value="0" name="deleteflag" id="deleteflag">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
</colgroup>
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

<table style="width: 100%;" class="e8_tblForm">
<COLGROUP>
   <COL width="30%">
   <COL width="70%">
</COLGROUP>
<TR class="Spacing" style="height:1px;"><TD class="Line1" colspan=2></TD></TR>
<TR height="30px">
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(33439,user.getLanguage())%></td>
	<td class="e8_tblForm_field">
		<input type="text" name="name" style="width:90%" value="<%=name%>" onblur="checkname();"><span id="namespan"><img align="absMiddle" src="/images/BacoError_wev8.gif"/></span>
	</td>
</TR>
<TR>
	<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(81710,user.getLanguage())%></td>
	<td class="e8_tblForm_field">
		<textarea rows="2" cols="200" style="width:90%" name="remark"><%=remark %></textarea>
	</td>
</TR>
<TR class="Spacing" style="height:10px;"><TD class="Line1" colspan=2></TD></TR>
<TR>
  <TD  colspan=2 style="text-align:right;">
   <button
   	type="button"
   	title="<%=SystemEnv.getHtmlLabelName(21690,user.getLanguage())%>" 
   	class="addbtn2" 
   	onClick="addfeild()"></button><!-- 添加字段 -->
   <button 
   	type="button"
   	title="<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%>"
   	class="deletebtn2" 
   	onclick="delfeild()"></button><!-- 删除字段 -->
  </TD>
</TR>
</table>
<table id="oTable" style="width: 100%;border: 1px" class="viewform"  >
	<COLGROUP>
	   <COL width="5%">
	   <COL width="30%">
	   <COL width="20%">
	   <COL width="45%">
	</COLGROUP>
	<tr class="header">
		<th><input type="checkbox" name="feildindex_all" onclick="onfeildindex_all()" value=""></th>
		<th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(30585,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(125391, user.getLanguage()) %></th>
	</tr>
	<%
		rs.executeSql("select * from mode_batchmodifydetail where mainid="+id);
		int index=0;
		while(rs.next()){
			index++;
			String feildid=Util.null2String(rs.getString("feildid"));
			String changetype=Util.null2String(rs.getString("changetype"));
			String feildvalue=Util.null2String(rs.getString("feildvalue"));
		%>
			<TR class=header style="height: 40px" >
	<td>
		<input type="checkbox" name="feildindex" value=""></td><td>
		<select name="feildid" onchange="onFeildId(this)" style="width: 90%">
			<option value=""></option>
			<%
				int groupid=0;
				String tmpgroupname="";
				String tablename="";
				String sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype as dbtype,detailtable  "+
				" from workflow_billfield where viewtype=0 and billid = "+formid + 
				" and fieldhtmltype!=6 order by viewtype,detailtable,dsporder ";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					String wfeildid = Util.null2String(RecordSet.getString("id"));
					String fieldname = Util.null2String(RecordSet.getString("name"));
					String detailtable = Util.null2String(RecordSet.getString("detailtable"));
					if(!detailtable.equals("")){
						if(!tmpgroupname.equals(detailtable)){
							groupid++;
							tmpgroupname=detailtable;
						}
						tablename=SystemEnv.getHtmlLabelName(84496, user.getLanguage())+groupid;
					}else{
						tablename=SystemEnv.getHtmlLabelName(21778, user.getLanguage());
					}
					String label = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("label")),user.getLanguage());
			%>
			<option value="<%=wfeildid%>" <%=feildid.equals(wfeildid)?"selected":"" %>><%=label+"("+fieldname+")" %></option>
			<%	} %>
		</select>
	</td>
	<td>
		<select name="changetype" onchange="onChangeType(this)">
 			<option value="1" <%="1".equals(changetype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(19206, user.getLanguage()) %></option>
			<option value="2" <%="2".equals(changetype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(125392, user.getLanguage()) %></option>
			<option value="3" <%="3".equals(changetype)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(73, user.getLanguage()) %></option>
		</select>
	</td>
	<td tdid="defaultvaluetd" feildvalue="<%=feildvalue %>">
		<textarea name="defaultvalue" rows="2" cols="20" style="width:90%" ><%=feildvalue %></textarea>
	</td>
</TR>
		
		<%
		}
	 %>
</table>
</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="100px" colspan="3">
	<div style="color: red; padding-left: 20px;">
<%=SystemEnv.getHtmlLabelName(125776, user.getLanguage()) %><br/>
<%=SystemEnv.getHtmlLabelName(128099, user.getLanguage()) %><br/>
<%=SystemEnv.getHtmlLabelName(128100, user.getLanguage()) %><br/>
<%=SystemEnv.getHtmlLabelName(82151, user.getLanguage()) %>$UserId$<br/>
<%=SystemEnv.getHtmlLabelName(16727, user.getLanguage()) %>$UserCode$<br/>
<%=SystemEnv.getHtmlLabelName(128101, user.getLanguage()) %>$DepartmentId$<br/>
<%=SystemEnv.getHtmlLabelName(82167, user.getLanguage()) %>$AllDepartmentId$<br/>
<%=SystemEnv.getHtmlLabelName(82168, user.getLanguage()) %>$SubcompanyId$<br/>
<%=SystemEnv.getHtmlLabelName(82169, user.getLanguage()) %>$AllSubcompanyId$<br/>
<%=SystemEnv.getHtmlLabelName(15625, user.getLanguage()) %>$date$<br/>
<%=SystemEnv.getHtmlLabelName(128102, user.getLanguage()) %>$<%=SystemEnv.getHtmlLabelName(33331, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(15930, user.getLanguage()) %>$<br/>

</div>
	</td>
</tr>
<tr>
	<td height="50px" colspan="3"></td>
</tr>
</table>
<%
				String sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype as dbtype,detailtable  "+
				" from workflow_billfield where  viewtype=0 and billid = "+formid + 
				" and fieldhtmltype!=6 order by viewtype,detailtable,dsporder ";
				rs.executeSql(sql);
				while(rs.next()){
					String feildid = Util.null2String(rs.getString("id"));
					String htmltype =  Util.null2String(rs.getString("htmltype"));
					String type =  Util.null2String(rs.getString("type"));
					String dbtype =  Util.null2String(rs.getString("dbtype"));
			%>
			<input id="feildid<%=feildid%>" type="hidden" value="" htmltype="<%=htmltype%>" feildtype="<%=type%>" dbtype="<%=dbtype%>">
			<%	} %>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="parent.closeWinAFrsh();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

</BODY>
</HTML>
<script>
	//var parentWin = parent.parent.getParentWindow(parent);
 //var dialog = parent.parent.parent.getDialog(parent);
	function close(){
 	//	dialog.close();
 		parent.closeWinAFrsh();
	}
	function submitData(obj){
		if(jQuery("[name=name]").val()==''){
			alert("<%=SystemEnv.getHtmlLabelName(125393, user.getLanguage())%>");
			return false;
		}
		obj.disabled=true;
		jQuery("#saveflag").val(0);
		jQuery("#deleteflag").val(0);
		var message = setDefaultValue();
		if(message!=''){
			if(!confirm(message)){
				obj.disabled=false;
				return false;
			}
		}
    	ModifyForm.submit();
	}
	function submitAndGetData(obj){
		if(jQuery("[name=name]").val()==''){
			alert("<%=SystemEnv.getHtmlLabelName(125393, user.getLanguage())%>");
			return false;
		}
		obj.disabled=true;
		jQuery("#saveflag").val(1);
		jQuery("#deleteflag").val(0);
		var message = setDefaultValue();
		if(message!=''){
			if(!confirm(message)){
				obj.disabled=false;
				return false;
			}
		}
    	ModifyForm.submit();
	}
	//删除操作JS  zwbo
	function deleteData(obj){
		if(confirm("<%=SystemEnv.getHtmlLabelName( 82017 , user.getLanguage())%>")){
			 obj.disabled=true;
			jQuery("#deleteflag").val(1);
    		ModifyForm.submit();
		}
	}
	//提交前设置默认值
	function setDefaultValue(){
		var message="";
		jQuery("[name=feildid]").each(function(i,val){
			var defaultvaluestr = jQuery.trim(jQuery("[name=con"+jQuery(val).val()+"_value]").val());
			jQuery("[name=con"+jQuery(val).val()+"_value]").parents("td:first").find("[name=defaultvalue]").val(defaultvaluestr);
			var changetype = jQuery(val).parents("tr").find("[name=changetype]").val();
			if(changetype=='1'||changetype=='2'){
				if(jQuery(val).parents("tr").find("[name=defaultvalue]").val()==''){
					message+=","+jQuery(val).find("option:selected").text();
				}
			}
		})
		if(message.length>0){
			message = message.substring(1);
			message+="<%=SystemEnv.getHtmlLabelName(128103, user.getLanguage()) %>";
		}
		return message;
	}
	var otrhtml="<TR class=header style=\"height: 60px\" >"+
	"<td>"+
		"<input type=\"checkbox\" name=\"feildindex\" value=\"\"></td>"+
		"<td><select name=\"feildid\" style=\"width:90%\" onchange=\"onFeildId(this)\">"+
			"<option value=\"\"></option>"+
			<%
				int groupid=0;
				String tmpgroupname="";
				String tablename="";
				sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype as dbtype,detailtable  "+
				" from workflow_billfield where viewtype=0 and billid = "+formid + 
				" and fieldhtmltype!=6 order by viewtype,detailtable,dsporder ";
				rs.executeSql(sql);
				while(rs.next()){
					String feildid = Util.null2String(rs.getString("id"));
					String fieldname = Util.null2String(rs.getString("name"));
					String detailtable = Util.null2String(rs.getString("detailtable"));
					String htmltype = Util.null2String(rs.getString("htmltype"));
					String type = Util.null2String(rs.getString("type"));
					if((htmltype.equals("2")&&type.equals("2"))||(htmltype.equals("6"))||(htmltype.equals("7"))){
						continue;
					}
					if(!detailtable.equals("")){
						if(!tmpgroupname.equals(detailtable)){
							groupid++;
							tmpgroupname=detailtable;
						}
						tablename=SystemEnv.getHtmlLabelName(84496, user.getLanguage())+groupid;
					}else{
						tablename=SystemEnv.getHtmlLabelName(21778, user.getLanguage());
					}
					String label = SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("label")),user.getLanguage());
			%>
			"<option value=\"<%=feildid%>\"><%=label+"("+fieldname+")" %></option>"+
			<%	} %>
		"</select>"+
	"</td>"+
	"<td>"+
		"<select name=\"changetype\" onchange=\"onChangeType(this)\">"+
			"<option value=\"1\"><%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%></option>"+
			"<option value=\"2\"><%=SystemEnv.getHtmlLabelName(125392, user.getLanguage())%></option>"+
			"<option value=\"3\"><%=SystemEnv.getHtmlLabelName(73, user.getLanguage())%></option>"+
		"</select>"+
	"</td>"+
	"<td tdid=\"defaultvaluetd\" feildvalue=\"\">"+
		"<textarea name=\"defaultvalue\" rows=\"2\" style=\"width:90%\" cols=\"20\"></textarea>"+
	"</td>"+
"</TR>";
	function checkname(){
		if(jQuery("[name=name]").val()==''){
			jQuery("#namespan").show();
		}else{
			jQuery("#namespan").hide();
		}
	}
	jQuery(document).ready(function(){
		if(jQuery("[name=name]").val()==''){
			jQuery("#namespan").show();
		}else{
			jQuery("#namespan").hide();
		}
		jQuery("#oTable").jNice();
		jQuery("#oTable [name=changetype]").each(function(i,val){
			onChangeType(val);
		})
	})
	function onfeildindex_all(){
		if(jQuery("[name=feildindex_all]").attr("checked")){
			jQuery("[name=feildindex]").attr("checked",true);
			jQuery("#oTable .jNiceWrapper").find("span").addClass("jNiceChecked");
		}else{
			jQuery("[name=feildindex]").attr("checked",false);
			jQuery("#oTable .jNiceWrapper").find("span").removeClass("jNiceChecked");
		}
		jQuery("#oTable").jNice();
	}
	function addfeild(){
		jQuery("#oTable").append(otrhtml);
		//jQuery("#oTable tr:last select").selectbox("attach");
		//jQuery("#oTable tr:last").find("[name=changetype]").selectbox("attach");
		jQuery("#oTable").jNice();
	}
	function delfeild(){
		if(jQuery("input:checkbox[name=feildindex]:checked").length==0){
			alert("<%=SystemEnv.getHtmlLabelName(31017, user.getLanguage())%>");
		}else{
			jQuery("input:checkbox[name=feildindex]:checked").parent().parent().parent().remove();
		}
	}

	function onFeildId(feildidobj){//修改字段后重置修改类型
		jQuery("[name=feildid]").each(function(i,val){
			if(jQuery(val).val()==jQuery(feildidobj).val()&&val!=feildidobj&&jQuery(feildidobj).val()!=''){
				alert("<%=SystemEnv.getHtmlLabelName(125394, user.getLanguage())%>");
				jQuery(feildidobj).val('');
				return false;
			}
		})
		jQuery(feildidobj).parent().parent().find("[name=changetype]").val(1);
		onChangeType(jQuery(feildidobj).parent().parent().find("[name=changetype]")[0]);
	}
	function onChangeType(changetypeobj){
		var valuehtml="";
		var changetypevalue = jQuery(changetypeobj).val();
		var feildid = jQuery(changetypeobj).parent().parent().find("[name=feildid]").val();
		var htmltype = jQuery("#feildid"+feildid).attr("htmltype");
		var feildtype = jQuery("#feildid"+feildid).attr("feildtype");
		var dbtype = jQuery("#feildid"+feildid).attr("dbtype");
		var feildvalue="";
		feildvalue = jQuery(changetypeobj).parent().parent().find("[tdid=defaultvaluetd]").attr("feildvalue");
		if(changetypevalue==1){//默认值
			if(feildid!="")
				valuehtml=getDefaultValueElement(feildid,htmltype,feildtype,dbtype,feildvalue);
			valuehtml+="<textarea name=\"defaultvalue\" style=\"display:none\" rows=\"3\" cols=\"20\">"+feildvalue+"</textarea>";
		}else if(changetypevalue==2){//变量值
			valuehtml="<textarea name=\"defaultvalue\" rows=\"3\" style=\"width:90%\" cols=\"20\">"+feildvalue+"</textarea>";
		}else if(changetypevalue==3){//用户自定义 设置为空 不显示
			valuehtml="<textarea name=\"defaultvalue\" rows=\"3\" style=\"display:none\" cols=\"20\"></textarea>";
		}
		jQuery(changetypeobj).parent().parent().find("[tdid=defaultvaluetd]").html(valuehtml);
		//jQuery(changetypeobj).parents("tr").find("[tdid=defaultvaluetd]").find("select").selectbox("attach");
	}
	function getDefaultValueElement(feildid,htmltype,feildtype,dbtype,feildvalue){
		var modeid="<%=modeid%>";
		var formid="<%=formid%>";
		var valuehtml="";
		var aj = jQuery.ajax( {    
		    url:'/formmode/setup/getfeildelement.jsp',// 跳转到 action    
		    data:{    
		             feildid : feildid,    
		             htmltype : htmltype,    
		             feildtype : feildtype,    
		             dbtype : dbtype,
		             modeid:modeid,
		             formid:formid,
		             feildvalue:feildvalue
		    },    
		    type:'post',    
		    cache:false,
		    async:false,    
		    dataType:'text',    
		    success:function(data1) {    
		        valuehtml= jQuery.trim(data1);
		     },    
		     error : function() {    
		          alert("<%=SystemEnv.getHtmlLabelName(124899, user.getLanguage()) %>");    
		     }    
		});  
		return valuehtml;
	}
	function onShowBrowser(id,url) {
		var url = url + "?selectedids=" + $G("con" + id + "_value").value;
		disModalDialog(url, $G("con" + id + "_valuespan"), $G("con" + id + "_value"), false);
		//$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
	}
	function disModalDialog(url, spanobj, inputobj, need, curl) {
		var id = window.showModalDialog(url, "",
				"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "" && wuiUtil.getJsonValueByIndex(id, 0) != "0") {
				if (curl != undefined && curl != null && curl != "") {
					spanobj.innerHTML = "<A href='" + curl
							+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
							+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
				} else {
					spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
				}
				inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
			} else {
				spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
				inputobj.value = "";
			}
		}
	}
	function onSearchWFQTDate(spanname,inputname,inputname1){
		var oncleaingFun = function(){
			  $(spanname).innerHTML = '';
			  inputname.value = '';
			}
			WdatePicker({el:spanname,onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname).value = returnvalue;
				},oncleared:oncleaingFun});
	}
	function onSearchWFQTTime(spanname,inputname,inputname1){
	    var dads  = document.all.meizzDateLayer2.style;
	    setLastSelectTime(inputname);
		var th = spanname;
		var ttop  = spanname.offsetTop;
		var thei  = spanname.clientHeight;
		var tleft = spanname.offsetLeft;
		var ttyp  = spanname.type;
		while (spanname = spanname.offsetParent){
			ttop += spanname.offsetTop;
			tleft += spanname.offsetLeft;
		}
		var t = (ttyp == "image") ? ttop + thei : ttop + thei + 22;
		dads.top = t+"px";
		dads.left = tleft+"px";
		$(document.all.meizzDateLayer2).css("z-index",99999);
		outObject = th;
		outValue = inputname;
		outButton = (arguments.length == 1) ? null : th;
		dads.display = '';
		bShow = true;
	    CustomQuery=0;
	    outValue1 = inputname1;
	}
	function onShowCQWorkFlow(inputname, spanname) {
		var tmpids = $G(inputname).value;
		var url = "/systeminfo/BrowserMain.jsp?url=/workflow/report/WorkFlowofFormBrowser.jsp";
	
		disModalDialogRtnM(url, inputname, spanname);
	}
	function disModalDialogRtnM(url, inputname, spanname) {
		var id = window.showModalDialog(url);
		if (id != null) {
			if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
				var ids = wuiUtil.getJsonValueByIndex(id, 0);
				var names = wuiUtil.getJsonValueByIndex(id, 1);
				
				if (ids.indexOf(",") == 0) {
					ids = ids.substr(1);
					names = names.substr(0);
				}
				$G(inputname).value = ids;
				var sHtml = "";
				
				var ridArray = ids.split(",");
				var rNameArray = names.split(",");
				
				for ( var i = 0; i < ridArray.length; i++) {
					var curid = ridArray[i];
					var curname = rNameArray[i];
					if (i != ridArray.length - 1) sHtml += curname + "，"; 
					else sHtml += curname;
				}
				
				$G(spanname).innerHTML = sHtml;
			} else {
				$G(inputname).value = "";
				$G(spanname).innerHTML = "";
			}
		}
	}
	
	function onShowBrowserCustomNew(id, url, type1) {
		if (type1 == 256|| type1==257) {
			url+="&iscustom=1";
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "&selectedids=" + tmpids;
		}else{
			tmpids = $GetEle("con"+id+"_value").value;
			url = url + "|" + id + "&beanids=" + tmpids;
			url = url.substring(0,url.indexOf("?")+1)+"iscustom=1&"+url.substring(url.indexOf("url="), url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
		}
		var dialogurl = url;
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != null) {
			if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
				var ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
				var names = wuiUtil.getJsonValueByIndex(id1, 1);
				var descs = wuiUtil.getJsonValueByIndex(id1, 2);
				if (type1 == 161) {
					var href = "";
					if(id1.href&&id1.href!=""){
						href = id1.href+ids;
					}else{
						href = "";
					}
					var hrefstr="";
					if(href!=''){
						hrefstr=" href='"+href+"' target='_blank' ";
					}
					var sHtml = "<a "+hrefstr+"  title='" + names + "'>" + names + "</a>";
					$G("con" + id + "_valuespan").innerHTML = wrapshowhtml(sHtml,ids,1);
					$G("con" + id + "_value").value = ids;
					$G("con" + id + "_name").value = sHtml;
				}
				if (type1 == 162) {
					var sHtml = "";
	
					var idArray = ids.split(",");
					var curnameArray = names.split("~~WEAVERSplitFlag~~");
					if(curnameArray.length < idArray.length){
						curnameArray = names.split(",");
					}
					var curdescArray = descs.split(",");
					var showname = "";
					for ( var i = 0; i < idArray.length; i++) {
						var curid = idArray[i];
						var curname = curnameArray[i];
						var curdesc = curdescArray[i];
						if(curdesc==''||curdesc=='undefined'||curdesc==null){
							curdesc = curname;
						}
						if(curdesc){
							curdesc = curname;
						}
						showname += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
						sHtml +=  wrapshowhtml("<a title='" + curdesc + "' >" + curname + "</a>&nbsp",curid,1);
					}
	
					$G("con" + id + "_valuespan").innerHTML = sHtml;
					$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
					$G("con" + id + "_name").value = showname;
				}
				if (type1 == 256||type1 == 257) {
					var sHtml = "";
	
					var idArray = ids.split(",");
					var curnameArray = names.split("~~WEAVERSplitFlag~~");
					if(curnameArray.length < idArray.length){
						curnameArray = names.split(",");
					}
					var curdescArray = descs.split(",");
					var showname = "";
					for ( var i = 0; i < idArray.length; i++) {
						var curid = idArray[i];
						var curname = curnameArray[i];
						var curdesc = curdescArray[i];
						if(curdesc==''||curdesc=='undefined'||curdesc==null){
							curdesc = curname;
						}
						if(curdesc){
							curdesc = curname;
						}
						showname += curname+"&nbsp";
						sHtml +=  wrapshowhtml(curname + "&nbsp",curid,1);
					}
					$G("con" + id + "_valuespan").innerHTML = sHtml;
					$G("con" + id + "_value").value = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1, 0));
					$G("con" + id + "_name").value = showname;
				}
			} else {
				$G("con" + id + "_valuespan").innerHTML = "";
				$G("con" + id + "_value").value = "";
				$G("con" + id + "_name").value = "";
			}
		}
			
		hoverShowNameSpan(".e8_showNameClass");
		   
		};
		
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
		dialog.Width = 550 ;
		if(url.indexOf("/MutiResourceBrowser.jsp")!=-1){ 
			dialog.Width=648; 
		}
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
	
	}
	
	function doReturnSpanHtml(obj){
		var t_x = obj.substring(0, 1);
		if(t_x == ','){
			t_x = obj.substring(1, obj.length);
		}else{
			t_x = obj;
		}
		return t_x;
	}
	
	$(document).ready(function() {
		dynamicLoading.css("../css/dynamicLoadingStyle.css");		
	});
	
</script>