<%@page import="weaver.formmode.setup.ModeSetUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.general.GCONST" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="modeSetUtil" class="weaver.formmode.setup.ModeSetUtil" scope="page" />
<jsp:useBean id="FormModeTransMethod" class="weaver.formmode.search.FormModeTransMethod" scope="page" />
<jsp:useBean id="FormInfoService" class="weaver.formmode.service.FormInfoService" scope="page"></jsp:useBean>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
<style type="text/css">
#feildvalueshow { color:red;}
#feildvalueshow a { color:red;}
</style>
</HEAD>
<%

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
String id=Util.null2String(request.getParameter("id"));
String billids=Util.null2String(request.getParameter("billids"));
String action=Util.null2String(request.getParameter("action"));
int detailid = Util.getIntValue(request.getParameter("detailid"), 0);
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:submitData(this),_self} " ;//保存
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:close(),_self} " ;//关闭
RCMenuHeight += RCMenuHeightStep;


String maintablename = "";
maintablename = FormInfoService.getTablenameByFormid(Util.getIntValue(formid));
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" style="font-size: 12px;cursor: pointer;"><!-- 保存 -->
				<input class="e8_btn_top middle" onclick="javascript:submitData(this)" type="button" value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
		</wea:item>
	</wea:group>
</wea:layout>
<FORM NAME=ModifyForm STYLE="margin-bottom:0" action="/formmode/setup/batchmodifyfeildvalueOperation.jsp" method="post">
<input type="hidden" value="<%=id%>" name="id">
<input type="hidden" value="<%=modeid%>" id="modeid" name="modeid">
<input type="hidden" value="<%=formid%>" id="formid" name="formid">
<input type="hidden" value="<%=maintablename%>" id="maintablename" name="maintablename">
<input type="hidden" value="<%=billids%>" id="billids" name="billids">
<input type="hidden" value="<%=detailid%>" id="detailid" name="detailid"> 
<input type="hidden" value="0" name="saveflag" id="saveflag">

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
<span style="color: red;"><% out.print(Util.null2String(SystemEnv.getHtmlLabelName(125493,user.getLanguage())).replace("{0}",billids.split(",").length+"")); %></span>
<table id="oTable" style="width: 100%;border: 1px" class="viewform"  >
	<COLGROUP>
	   <COL width="45%">
	   <COL width="0%" style="display:none">
	   <COL width="55%">
	</COLGROUP>
	<tr class="header">
		<th><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></th>
		<th style="display:none"><%=SystemEnv.getHtmlLabelName(30585,user.getLanguage())%></th>
		<th><%=SystemEnv.getHtmlLabelName(125391, user.getLanguage()) %></th>
	</tr>
	<%
		rs.executeSql("select * from mode_batchmodifydetail where mainid="+id);
		int index=0;
		Map<String, String> fieldNameMapForLable = new HashMap<String, String>();
		while(rs.next()){
			index++;
			String feildid=Util.null2String(rs.getString("feildid"));
			String changetype=Util.null2String(rs.getString("changetype"));
			String feildvalue=Util.null2String(rs.getString("feildvalue"));
			String fieldlableId = "";
		%>
			<TR class=header style="height: 40px" >
	<td>
		<input type="hidden" name="feildid" value="<%=feildid%>">
			<%
				int groupid=0;
				String tmpgroupname="";
				String tablename="";
				String sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype as dbtype,detailtable  "+
				" from workflow_billfield where billid = "+formid + 
				" and fieldhtmltype!=6 order by viewtype,detailtable,dsporder ";
				String htmltype="";
				String type="";
				String dbtype="";
				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					String wfeildid = Util.null2String(RecordSet.getString("id"));
					String fieldname = Util.null2String(RecordSet.getString("name"));
					String detailtable = Util.null2String(RecordSet.getString("detailtable"));
					String fieldlabel = Util.null2String(RecordSet.getString("label"));
					
					if(fieldNameMapForLable.get(fieldname) == null) {
						fieldNameMapForLable.put(fieldname, fieldlabel);
					}
					
					if(!detailtable.equals("")){
						if(!tmpgroupname.equals(detailtable)){
							groupid++;
						}
						tablename=SystemEnv.getHtmlLabelName(84496, user.getLanguage())+groupid;
					}else{
						tablename=SystemEnv.getHtmlLabelName(21778, user.getLanguage());
						detailtable = maintablename;
					}
					String label = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("label")),user.getLanguage());
					if(feildid.equals(wfeildid)){
						htmltype=Util.null2String(RecordSet.getString("htmltype"));
						type=Util.null2String(RecordSet.getString("type"));
						dbtype=Util.null2String(RecordSet.getString("dbtype"));
					%>
						<input type="hidden" name="tablename" value="<%=detailtable%>">
						<input type="hidden" name="feildname" value="<%=fieldname%>">
						<input type="hidden" name="labelfeildname" value="<%=label%>">
						<%=label %>
					<%}
			%>
			<%	} %>
	</td>
	<td style="display:none">
		<input name="changetype" type="hidden" value="<%=changetype%>" onchange="onChangeType(this)">
		<%
			if(changetype.equals("1")){
				out.print(SystemEnv.getHtmlLabelName(19206, user.getLanguage()));
			}else if(changetype.equals("2")){
				out.print(SystemEnv.getHtmlLabelName(125392, user.getLanguage()));
			}else if(changetype.equals("3")){
				out.print(SystemEnv.getHtmlLabelName(73, user.getLanguage()));
			}
		 %>
	</td>
	<td tdid="defaultvaluetd" feildvalue="<%=feildvalue %>">
				
		<%
			String feildname="";
			if(changetype.equals("1")){
				String para3=feildvalue+"+"+feildid+"+"+htmltype+"+"+type+"+"+user.getLanguage()
								+"+"+1+"+"+dbtype+"+"+0+"+"+modeid+"+"+formid+"+"+0;
				if(!feildvalue.equals("")&&!feildvalue.equals("NULL")){
					feildname = FormModeTransMethod.getOthersSearchname(feildvalue,para3);
				}
			}else if(changetype.equals("2")){
				feildname=feildvalue;
				feildname = FormModeTransMethod.getDefaultSql(user,"","",feildname);
				if(!feildvalue.equals("")&&!feildvalue.equals("NULL")&&!(feildname.indexOf("$")>-1)){
					String para3=feildvalue+"+"+feildid+"+"+htmltype+"+"+type+"+"+user.getLanguage()
								+"+"+1+"+"+dbtype+"+"+0+"+"+modeid+"+"+formid+"+"+0;
					feildname = FormModeTransMethod.getOthersSearchname(feildname,para3);
				}
				
				if(feildname.matches("^\\$.+\\$$") && (fieldlableId = fieldNameMapForLable.get(feildname.substring(1, feildname.length() - 1))) != null) {
					feildname = "$" + SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlableId, -1), user.getLanguage()) + "$";
				}
			}else if(changetype.equals("3")){
				
			}
		 %>
		 <span class="feildvalueshow" id="feildvalueshow"><%out.println(feildname); %></span>
		 <textarea style="display: none;width:90%" name="defaultvalue" rows="2" cols="20"><%=feildvalue %></textarea>
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
	<td height="50px" colspan="4"></td>
</tr>
</table>
<%
				String sql = "select id as id,fieldname as name,fieldlabel as label,fieldhtmltype as htmltype,type as type, fielddbtype as dbtype,detailtable  "+
				" from workflow_billfield where billid = "+formid + 
				" and fieldhtmltype!=6 order by viewtype,detailtable,dsporder ";
				rs.executeSql(sql);
				while(rs.next()){
					String feildid = Util.null2String(rs.getString("id"));
					String htmltype =  Util.null2String(rs.getString("htmltype"));
					String type =  Util.null2String(rs.getString("type"));
					String dbtype =  Util.null2String(rs.getString("dbtype"));
			%>
			<input id="feildid<%=feildid%>" type="hidden" htmltype="<%=htmltype%>" feildtype="<%=type%>" dbtype="<%=dbtype%>">
			<%	} %>
</FORM>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar"><!-- 关闭 -->
				<input type="button"
					value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
					id="zd_btn_cancle" class="zd_btn_cancle" onclick="parent.closeWinAFrsh(1);">
			</wea:item>
		</wea:group>
	</wea:layout>
</BODY>
</HTML>
<script>
	function close(){
		parent.closeWinAFrsh(1);
	}
	function submitData(obj){
		if(!confirm("<%=SystemEnv.getHtmlLabelName(125395, user.getLanguage())%>")){
			return false;
		}
		var message = setDefaultValue();
		if(message!=''){
			if(!confirm(message)){
				return false;
			}
		}
    	ModifyForm.submit();
	}
	//提交前设置默认值
	function setDefaultValue(){
		var message="";
		jQuery("[name=feildid]").each(function(i,val){
			var defaultvaluestr = jQuery.trim(jQuery("[name=con"+jQuery(val).val()+"_value]").val());
			jQuery("[name=con"+jQuery(val).val()+"_value]").parents("td:first").find("[name=defaultvalue]").val(defaultvaluestr);
			var changetype = jQuery(val).parents("tr").find("[name=changetype]").val();
			if(changetype=='3'){
				if(jQuery("[name=con"+jQuery(val).val()+"_value]").parents("td:first").find("[name=defaultvalue]").val()==''){
					message+=","+jQuery.trim(jQuery(val).parents("td").find("[name=labelfeildname]").val());
				}
			}
		})
		if(message.length>0){
			message = message.substring(1);
			message+="<%=SystemEnv.getHtmlLabelName(128103, user.getLanguage()) %>";
		}
		return message;
	}
	
	jQuery(document).ready(function(){
		jQuery("#oTable").jNice();
		jQuery("#oTable [name=changetype]").each(function(i,val){
			onChangeType(val);
		})
	})
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
			return;
			//valuehtml=getDefaultValueElement(feildid,htmltype,feildtype,dbtype,feildvalue);
			//valuehtml+="<textarea name=\"defaultvalue\" style=\"display:none\" rows=\"3\" cols=\"20\">"+feildvalue+"</textarea>";
		}else if(changetypevalue==2){//变量值
			return;
			//valuehtml="<textarea name=\"defaultvalue\" rows=\"3\" cols=\"20\">"+feildvalue+"</textarea>";
		}else if(changetypevalue==3){//用户自定义 设置为空 不显示
			valuehtml=getDefaultValueElement(feildid,htmltype,feildtype,dbtype,feildvalue);
			valuehtml+="<textarea name=\"defaultvalue\" rows=\"3\" style=\"display:none;width:90%\" cols=\"20\">"+feildvalue+"</textarea>";
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
		$G("con" + id + "_name").value = $G("con" + id + "_valuespan").innerHTML;
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
