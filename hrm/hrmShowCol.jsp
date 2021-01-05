<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.definedfield.HrmFieldManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<head>
<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<!--以下是显示定制组件所需的js -->
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);

function saveShowColInfo(){
	var pageId = jQuery("#pageId",parentWin.document).val();
	function addItem(data){
		if(data.result=="1"){
			if(jQuery("span#searchblockspan",parentWin.parent.document).find("img:first").length>0){
					jQuery("span#searchblockspan",parentWin.parent.document).find("img:first").click();
				}else{
					parentWin.location.reload();
				}
			dialog.close();
		}else{
			parentWin.top.Dialog.alert(data.msg);
		}
	}
	var systemIds = "";
	var systemOrders = "";
	jQuery("input[type=checkbox]").each(function(){ 
		var ischecked = jQuery(this).is(':checked');
		if(ischecked){
			if(systemIds.length>0)systemIds+=",";
		 	systemIds+=jQuery(this).val();
		 	
		 	var name = jQuery(this).attr("name")+"_index";
		 	if(systemOrders.length>0)systemOrders+=",";
		 	systemOrders+=jQuery("#"+name).val();
	 	}
	}); 
	 var saveurl = "/weaver/weaver.common.util.taglib.ShowColServlet?ts="+new Date().getTime()+"&src=save&pageId="+pageId+"&systemIds="+systemIds+"&systemOrders="+systemOrders;
	 ajaxHandler(saveurl, "", addItem, "json", false);
}

function jsChangeOrder(obj){
 var name = jQuery(obj).attr("name")+"_index";
 var max = 0;
 jQuery("input[name$='_index']").each(function(){ 
 	if(jQuery(this).val()!==""&&parseInt(jQuery(this).val(),10)>max){
 		max = parseInt(jQuery(this).val(),10);
 	}
 });
 if(obj.checked){
 	jQuery("#"+name).val(max+1);
 	jQuery("#"+name).show();
 }else{
 	jQuery("#"+name).val("");
 	jQuery("#"+name).hide();
 }
}

jQuery(document).ready(function(){
 jQuery("input[name$='_index']").each(function(){ 
 	if(jQuery(this).val()==""){
 		jQuery(this).hide();
 	}
 });
})
</script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16757,user.getLanguage());
String needfav ="1";
String needhelp ="";
int[] scopeIds = new int[]{-1,1,3}; 
HrmFieldManager hfm = null;

List<String> lsFieldChecked = new ArrayList<String>();
Hashtable<String, Integer> htSystemid = new Hashtable<String, Integer>();
Hashtable<String, Integer> htSystemOrder = new Hashtable<String, Integer>();
String sql = " SELECT DISTINCT sdc.column_ , udc.orders FROM  user_default_col udc, system_default_col sdc where udc.systemid = sdc.id "
					 + " AND udc.pageid = sdc.pageid and sdc.pageid = 'Hrm:resourceSearchResultByManager' and onlyWidth=0 AND udc.userid= "+user.getUID();
rs.executeSql(sql);
while(rs.next()){
	lsFieldChecked.add(rs.getString("column_"));
	htSystemOrder.put(rs.getString("column_"),rs.getInt("orders"));
}
if(lsFieldChecked.size()==0){
	int rowindex = 1;
	sql = " select id, column_, orders from system_default_col where isdefault=1 " 
			+ " and pageid='Hrm:resourceSearchResultByManager' and (hide_!='false' or hide_ is null) order by orders";
	rs.executeSql(sql);
	while(rs.next()){
		lsFieldChecked.add(rs.getString("column_"));
		htSystemOrder.put(rs.getString("column_"),rowindex++);
	}
}

sql = " SELECT column_,id,orders FROM system_default_col WHERE pageid='Hrm:resourceSearchResultByManager' ";
rs.executeSql(sql);
while(rs.next()){
	htSystemid.put(rs.getString("column_"),rs.getInt("id"));
}
%>
<BODY>
<div class="zDialog_div_content" style="overflow-x:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveShowColInfo();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="saveShowColInfo();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="2col">
<%
String fieldname = "";
int labelid = -1;
for(int i=0;i<scopeIds.length;i++){
	int scopeId=scopeIds[i];
	hfm = new HrmFieldManager("HrmCustomFieldByInfoType",scopeId);
	hfm.getCustomFields();
	if(scopeId==-1){
		labelid = 1361;
	}else if(scopeId==1){
		labelid = 15687;
	}else if(scopeId==3){
		labelid = 15688;
	}
	%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(labelid,user.getLanguage()) %>'>
	<%
		while(hfm.next()){
  	if(!hfm.isUse())continue;
  	if(!hfm.isBaseField(hfm.getFieldname())){
    	if(scopeId==-1){
    		fieldname = "t0_"+hfm.getFieldname();
    	}else if(scopeId==1){
    		fieldname = "t1_"+hfm.getFieldname();
    	}else if(scopeId==3){
    		fieldname = "t2_"+hfm.getFieldname();
    	}
  	}else{
  		fieldname = hfm.getFieldname();
  	}
  	if(htSystemid.get(fieldname)==null)continue;
  	if(fieldname.equals("workcode")){%>
  	<wea:item><input name="id" type="checkbox" value='<%=htSystemid.get("id") %>' <%=lsFieldChecked.contains("id")?"checked":"" %> onclick="jsChangeOrder(this)"></wea:item>
		<wea:item>
			<table style="width: 100%">
				<tr>
					<td style="width: 25%"><%=SystemEnv.getHtmlLabelName(547,user.getLanguage()) %></td>
					<td style="width: 75%"><input style="width: 100px" id="id_index" name="id_index" type="text" value="<%=lsFieldChecked.contains("id")?htSystemOrder.get("id"):"" %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onblur="this.value=this.value.replace(/\D/g,'')"></td>
				</tr>
			</table>
		</wea:item>
  	<%}else if(fieldname.equals("departmentid")){%>
  	<wea:item><input name="subcompanyid1" type="checkbox" value='<%=htSystemid.get("subcompanyid1") %>' <%=lsFieldChecked.contains("subcompanyid1")?"checked":"" %> onclick="jsChangeOrder(this)"></wea:item>
		<wea:item>
			<table style="width: 100%">
				<tr>
					<td style="width: 25%"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></td>
					<td style="width: 75%"><input style="width: 100px" id="subcompanyid1_index" name="subcompanyid1_index" type="text" value="<%=lsFieldChecked.contains("subcompanyid1")?htSystemOrder.get("subcompanyid1"):"" %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onblur="this.value=this.value.replace(/\D/g,'')"></td>
				</tr>
			</table>
		</wea:item>
  	<%}%>
		<wea:item><input name='<%=fieldname %>' type="checkbox" value='<%=htSystemid.get(fieldname) %>' <%=lsFieldChecked.contains(fieldname)?"checked":"" %> onclick="jsChangeOrder(this)"></wea:item>
		<wea:item>
			<table style="width: 100%">
				<tr>
					<td style="width: 25%"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(hfm.getLable()),user.getLanguage()) %></td>
					<td style="width: 75%"><input style="width: 100px" id="<%=fieldname %>_index" name="<%=fieldname %>_index" type="text" value="<%=lsFieldChecked.contains(fieldname)?htSystemOrder.get(fieldname):"" %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onblur="this.value=this.value.replace(/\D/g,'')"></td>
				</tr>
			</table>
		</wea:item>
		<%}%>
		</wea:group>
	<%
}
%>
<%if(HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){ 
fieldname = "seclevel";
%>
<wea:group context="<%=SystemEnv.getHtmlLabelName(15804,user.getLanguage()) %>">
	<wea:item><input name="<%=fieldname %>" type="checkbox" value="<%=htSystemid.get(fieldname) %>" <%=lsFieldChecked.contains(fieldname)?"checked":"" %> onclick="jsChangeOrder(this)"></wea:item>
	<wea:item>
			<table style="width: 100%">
				<tr>
					<td style="width: 25%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage()) %></td>
					<td style="width: 75%"><input style="width: 100px" id="<%=fieldname %>_index" name="<%=fieldname %>_index" type="text" value="<%=lsFieldChecked.contains(fieldname)?htSystemOrder.get(fieldname):"" %>" onkeyup="this.value=this.value.replace(/\D/g,'')" onblur="this.value=this.value.replace(/\D/g,'')"></td>
				</tr>
			</table>
	</wea:item>
</wea:group>
<%} %>
</wea:layout>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="saveShowColInfo();">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
	    </wea:item>
			</wea:group>
		</wea:layout>
</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</BODY>
</HTML>
