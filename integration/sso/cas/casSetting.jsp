<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.RecordSet" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../../js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</head>
<%!
public String getOaAddress(RecordSet recordSet){
	
	recordSet.executeProc("SystemSet_Select","");
	recordSet.next();
	String ecologyurl = Util.null2String(recordSet.getString("oaaddress"));
	String ecologyurlWithNoHttp = ecologyurl.replace("http://","").replace("https://","");
	if(ecologyurlWithNoHttp.indexOf("/")!=-1){
		ecologyurl = (ecologyurl.indexOf("http://")!=-1?"http://":"")+
		(ecologyurl.indexOf("https://")!=-1?"https://":"")+ecologyurlWithNoHttp.substring(0,ecologyurlWithNoHttp.indexOf("/"));
	}
	return ecologyurl;
}
%>

<%
if(!HrmUserVarify.checkUserRight("CAS:ALL",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String titlename = SystemEnv.getHtmlLabelName(23663,user.getLanguage());
RecordSet rs = new RecordSet();

rs.execute("select * from int_cas_setting ");
String isuse="";
String casserverurl = "";
String casserverloginpage = "";
String casserverlogoutpage = "";
String ecologyloginpage = "";
String pcauth = "";
String appauth = "";
String accounttype = "";
String customsql = "";
String appauthAddress = "";

if(rs.next()){
	isuse = rs.getString(1);
	casserverurl = rs.getString(2);
	casserverloginpage = rs.getString(3);
	casserverlogoutpage = rs.getString(4);
	ecologyloginpage = rs.getString(6);
	pcauth = rs.getString(7);
	appauth = rs.getString(8);
	accounttype = rs.getString(9);
	customsql = rs.getString(10);
	appauthAddress = rs.getString(11);
}

String ecologyurl = getOaAddress(rs);
%>

<BODY>
<script language=javascript >
	function changeCasServerAdd(currentInput){
		var casserverurl = $(currentInput).val();
		if(casserverurl.length>0){
			jQuery("#casserverurlPrespan1").val(casserverurl);
			jQuery("#casserverurlPrespan2").val(casserverurl);
			jQuery("#casserverurlPrespan3").val(casserverurl);
		}
	}
	function goopenWindow(title,url){	
		var dlg=new window.top.Dialog();//定义Dialog对象
		var title = title;
		dlg.currentWindow = window;
		dlg.Model=true;
		dlg.Width=730;//定义长度
		dlg.Height=600;
		dlg.URL=url;
		dlg.Title=title;
		dlg.show();
		dlg.callbackfunc4CloseBtn = function(){
				//window.location.href='casSetting.jsp';
				onSubmit(2);
			};
	}
	function changeAccountType(objvalue)
	{
		var type = objvalue;
		if(type=="7"){
			jQuery("#customsqlDiv").removeAttr("style");
		}else{
			jQuery("#customsqlDiv").attr("style","display:none");
		}
	}
	function tesCasUrl(){
			var casserverurl = $("#casserverurl").val();
			if(casserverurl==""){
				top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(128654 ,user.getLanguage())%>');
				return;
			}
		   jQuery.ajax({
			url : "/integration/sso/cas/testCas.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : "casserverurl="+casserverurl,
			success: function do4Success(resultStr){
				if(resultStr=="ok"){
					top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32297 ,user.getLanguage())%>!');
				}else{
					top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32296 ,user.getLanguage())%>!');	
				}
			},
	        error: function() {
				top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32296 ,user.getLanguage())%>!');
	        }
		});	
	}
	function openAppAuth(ischecked)
	{
		if(ischecked){
			jQuery("#appauthAddressDiv").removeAttr("style");
		}else{
			jQuery("#appauthAddressDiv").attr("style","display:none");
		}
	}
	function openCas(ischecked)
	{
		if(ischecked){
			showGroup("SetInfo");
		}else{
			hideGroup("SetInfo");
		}
	}
	function tesAppauthAddress(){
		var address = jQuery("#appauthAddress").val();
		if(address!=""){
			var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage())%>";
			dlg.currentWindow = window;
			dlg.Model=true;
			dlg.Width=730;//定义长度
			dlg.Height=600;
			dlg.URL="/integration/sso/cas/testResetAPIFrame.jsp?appauthAddress="+address;
			dlg.Title=title;
			dlg.show();
			dlg.callbackfunc4CloseBtn = function(){
			};
		}else{
			top.Dialog.alert('CAS ServerRest API地址为空!');
		}
	}
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:beforeOnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage())%>" class="e8_btn_top" onclick="onSubmit()"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(555 ,user.getLanguage())%>" class="e8_btn_top" onclick="beforeOnSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<script language=javascript>
<%
if(msgid==1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(128637,user.getLanguage())%>!');
<%}%>
<%
if(msgid==2){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(129281,user.getLanguage())%>');
<%}%>
</script>
<FORM id=weaver name=frmMain action="casSettingOperation.jsp" method=post >
	<input type="hidden" id="saveType" name="saveType" value="0"/>
	<wea:layout>
		<!-- 启用 -->
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		  <wea:item><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" tzCheckbox="true" type=checkbox id="isuse" name="isuse" value="1" <%if(isuse.equals("1"))out.print("checked"); %>  onclick="javascript:openCas(this.checked);"/>
		  </wea:item>
		</wea:group>
		<!--cas 配置-->
		<wea:group context='<%="CAS server"+SystemEnv.getHtmlLabelName(561,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
		  <wea:item>CAS server<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<wea:required id="casserverurlspan" required="true" value="<%=casserverurl %>">
		  		<input class="inputstyle" type="text" style='width:320px!important;' id="casserverurl" value="<%=casserverurl %>" name="casserverurl" onChange="checkinput('casserverurl','casserverurlspan');changeCasServerAdd(this);" onblur="isExist(this.value)" _noMultiLang='true'>
		  	</wea:required>
		  	&nbsp;&nbsp;<input  type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" onclick="tesCasUrl()"></input>
		  </wea:item>
		  <wea:item>CAS server<%=SystemEnv.getHtmlLabelName(674,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%></wea:item>
		  <wea:item>
		  		<input class="inputstyle" type="text" id="casserverurlPrespan1" style='width:320px!important;' 
		  		<%if(casserverurl.length()==0){ %>
			  		value="<%=SystemEnv.getHtmlLabelName(83869,user.getLanguage())%>CAS server<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>"
			  	<%}else{ %>
			  		value="<%=casserverurl %>"
			  	<%} %>
		  		 disabled="disabled" _noMultiLang='true'/>
		  	<wea:required id="casserverloginpagespan" required="true" value="<%=casserverloginpage %>">
		  		<input class="inputstyle" type="text" style='width:320px!important;' id="casserverloginpage" value="<%=casserverloginpage %>" name="casserverloginpage" onChange="checkinput('casserverloginpage','casserverloginpagespan')" onblur="isExist(this.value)" _noMultiLang='true'>
		  	</wea:required>
		  </wea:item>
		  <wea:item>CAS server<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%></wea:item>
		  <wea:item>
		  		<input class="inputstyle" type="text" id="casserverurlPrespan2" style='width:320px!important;' 
		  		<%if(casserverurl.length()==0){ %>
			  		value="<%=SystemEnv.getHtmlLabelName(83869,user.getLanguage())%>CAS server<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>"
			  	<%}else{ %>
			  		value="<%=casserverurl %>"
			  	<%} %> 
		  		disabled="disabled" _noMultiLang='true'/>
		  	<wea:required id="casserverlogoutpagespan" required="true" value="<%=casserverlogoutpage %>">
		  		<input class="inputstyle" type="text" style='width:320px!important;' id="casserverlogoutpage" value="<%=casserverlogoutpage %>" name="casserverlogoutpage" onChange="checkinput('casserverlogoutpage','casserverlogoutpagespan')" onblur="isExist(this.value)" _noMultiLang='true'>
		  	</wea:required>
		  </wea:item>
		</wea:group>	
		<!-- oa配置 -->	  
		<wea:group context='<%="Ecology"+SystemEnv.getHtmlLabelName(561,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
		  
		   <wea:item>Ecology<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type="text" id="ecologyloginpagespan1" style='width:320px!important;' 
			  	<%if(ecologyurl.length()==0){ %>
			  		value="<%=SystemEnv.getHtmlLabelName(126554,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>Ecology<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>" 
			  	<%}else{ %>
			  		value="<%=ecologyurl %>"
			  	<%} %>
			  	disabled="disabled" _noMultiLang='true'/>
		  	<wea:required id="ecologyurlspan" required="true" value="<%=ecologyurl %>">
		  	<input type="hidden" id='ecologyurl' name='ecologyurl' value="<%=ecologyurl %>" onChange="checkinput('ecologyurl','ecologyurlspan')"/>
		  	</wea:required>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>" onClick="javascript:goopenWindow('<%=SystemEnv.getHtmlLabelName(774,user.getLanguage())%>','/docs/tabs/DocCommonTab.jsp?_fromURL=52')" class="e8_btn_top"/>
			<!-- QC:270811   [90]CAS集成-调整CAS集成页面中设置按钮样式，以保持统一 e8_btn_top-->
		  </wea:item>
		  <wea:item>Ecology<%=SystemEnv.getHtmlLabelName(674,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%></wea:item>
		  <wea:item>
		  	<input class="inputstyle" type="text" id="ecologyloginpagespan2" style='width:320px!important;' 
			  	<%if(ecologyurl.length()==0){ %>
			  		value="<%=SystemEnv.getHtmlLabelName(126554,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>Ecology<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>" 
			  	<%}else{ %>
			  		value="<%=ecologyurl %>"
			  	<%} %>
			  	disabled="disabled" _noMultiLang='true'/>
		  	<wea:required id="ecologyloginpagespan" required="true" value="<%=ecologyloginpage %>">
		  	<input class="inputstyle" type="text" style='width:320px!important;' id="ecologyloginpage" value="<%=ecologyloginpage %>" name="ecologyloginpage" size="50"  onChange="checkinput('ecologyloginpage','ecologyloginpagespan')" _noMultiLang='true'>
		  	</wea:required>
		  </wea:item>
		  <wea:item>Ecology<%=SystemEnv.getHtmlLabelName(83594,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(579,user.getLanguage())%></wea:item>
		  <wea:item>
		  		<select style='width:120px!important;' id="accounttype" name="accounttype" onchange="javascript:changeAccountType(this.value);">
				  <option value="1" <%if("1".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
				  <option value="2" <%if("2".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(1887,user.getLanguage())%></option>
				  <option value="3" <%if("3".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(128556,user.getLanguage())%></option>
				  <option value="4" <%if("4".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(27940,user.getLanguage())%></option>
				  <option value="5" <%if("5".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(477,user.getLanguage())%></option>
				  <option value="6" <%if("6".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(620,user.getLanguage())%></option>
				  <option value="7" <%if("7".equals(accounttype)) out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(126492,user.getLanguage())%></option>
				</select><br/>
				<div 
				<%if(!"7".equals(accounttype)){ %>
					style="display: none;"
			  	<%}%>
				 id="customsqlDiv">
				<wea:required id="customsqlspan" required="true" value="<%=customsql %>">
			  		<input class="inputstyle" type="text" style='width:320px!important;' id="customsql" value="<%=customsql %>" name="customsql" size="50"  onChange="checkinput('customsql','customsqlspan')" _noMultiLang='true'>
			  	</wea:required>
			  	</div>
		  </wea:item>
	</wea:group>
	<!-- 手机、app认证开关 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(128638,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
		  <wea:item><%=SystemEnv.getHtmlLabelName(128642,user.getLanguage())%></wea:item><!-- 启用 -->
		  <wea:item>
		  	<input class="inputstyle" tzCheckbox="true" type=checkbox id="pcauth" name="pcauth" value="1" <%if(pcauth.equals("1"))out.print("checked"); %> />
		  </wea:item>
		  <wea:item><%=SystemEnv.getHtmlLabelName(128643,user.getLanguage())%></wea:item><!-- 启用 -->
		  <wea:item>
		  	<input class="inputstyle" tzCheckbox="true" type=checkbox id="appauth" name="appauth" value="1" <%if(appauth.equals("1"))out.print("checked"); %> onclick="javascript:openAppAuth(this.checked);"/>
		  	<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(128655,user.getLanguage())%>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
			<div 
		  		<%if(!appauth.equals("1")){ %>
					style="display: none;"
			  	<%}%>
		   id="appauthAddressDiv">
		   
		   <input class="inputstyle" type="text" id="casserverurlPrespan3" style='width:320px!important;' 
		  		<%if(casserverurl.length()==0){ %>
			  		value="<%=SystemEnv.getHtmlLabelName(83869,user.getLanguage())%>CAS server<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>"
			  	<%}else{ %>
			  		value="<%=casserverurl %>"
			  	<%} %> 
		  		disabled="disabled" _noMultiLang='true'/>
		  		
				<wea:required id="appauthAddressspan" required="true" value="<%=appauthAddress %>">
			  		<input class="inputstyle" type="text" style='width:320px!important;' id="appauthAddress" value="<%=appauthAddress %>" name="appauthAddress" size="50"  onChange="checkinput('appauthAddress','appauthAddressspan')" _noMultiLang='true'>
			  	</wea:required>
			  	&nbsp;&nbsp;<input  type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(25496 ,user.getLanguage()) %>" onclick="tesAppauthAddress()"></input>
		  </div>
		  </wea:item>
	</wea:group>	
	<!-- cas白名单 -->	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(128644,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
		<wea:item type="groupHead">
		  <div style='float:right;'>
			<input id='addbutton' type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)" onClick="addRow()" ACCESSKEY="A" class="addbtn"/>
			<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)" onClick="removeRow()" ACCESSKEY="G" class="delbtn"/>
		  </div>
	    </wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">
			<div id="temptsetting">
			</div>
		</wea:item>
	</wea:group>
	<!-- cas配置说明 -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>' attributes="{'samePair':'RemarkInfo','groupOperDisplay':'none','itemAreaDisplay':'block'}">
	  <wea:item attributes="{'colspan':'2'}">
		
		1、<%=SystemEnv.getHtmlLabelName(129491,user.getLanguage())%>
		<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129489,user.getLanguage())%> 
		<BR>
		2、<%=SystemEnv.getHtmlLabelName(129469,user.getLanguage())%>
		<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129490,user.getLanguage())%> 
		<BR>
		3、<%=SystemEnv.getHtmlLabelName(129490,user.getLanguage())%>：
		<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129471,user.getLanguage())%>
		<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129472,user.getLanguage())%>
		<BR>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129473,user.getLanguage())%>
		<BR>
		4、<%=SystemEnv.getHtmlLabelName(129474,user.getLanguage())%>
		<BR>
			 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(129475,user.getLanguage())%>
		 	 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1:<%=SystemEnv.getHtmlLabelName(34032,user.getLanguage())%> (MultiLangFilter)
			 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2:<%=SystemEnv.getHtmlLabelName(129476,user.getLanguage())%> (SecurityFilter)
			 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3:<%=SystemEnv.getHtmlLabelName(129477,user.getLanguage())%> filter (encodingFilter)
		<BR>	 
		5、<%=SystemEnv.getHtmlLabelName(129478,user.getLanguage())%>
		</wea:item>
	</wea:group>
	</wea:layout>
  </FORM>
</BODY>
<%
	
	StringBuffer ajaxdata = new StringBuffer();
	
	rs.executeSql("select * from int_cas_exclueurl_sys order by id");
	while (rs.next()) 
	{
		ajaxdata.append("[");
		ajaxdata.append("{name:'paramid',value:'',iseditable:false,type:'input'},");
	    ajaxdata.append("{name:'paramids',value:'',iseditable:true,type:'input'},");
	    ajaxdata.append("{name:'ids',value:'"+Util.null2String(rs.getString("id"))+"',iseditable:false,type:'input'},");
	    ajaxdata.append("{name:'excludeurl',value:'"+Util.null2String(rs.getString("excludeurl"))+"',iseditable:false,type:'input'},");
	    ajaxdata.append("{name:'excludedescription',value:'"+Util.null2String(rs.getString("excludedescription"))+"',iseditable:false,type:'input'}");
	    ajaxdata.append("],");
	}
	rs.executeSql("select * from int_cas_exclueurl order by id");
	while (rs.next()) 
	{
		ajaxdata.append("[");
		ajaxdata.append("{name:'paramid',value:'',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'paramids',value:'',iseditable:true,type:'input'},");
        ajaxdata.append("{name:'ids',value:'"+Util.null2String(rs.getString("id"))+"',iseditable:false,type:'input'},");
	    ajaxdata.append("{name:'excludeurl',value:'"+Util.null2String(rs.getString("excludeurl"))+"',iseditable:true,type:'input'},");
	    ajaxdata.append("{name:'excludedescription',value:'"+Util.null2String(rs.getString("excludedescription"))+"',iseditable:true,type:'input'}");
	    ajaxdata.append("],");
	}
	String tempajaxdata = ajaxdata.toString();
	if(!"".equals(tempajaxdata))
	{
		tempajaxdata = tempajaxdata.substring(0,(tempajaxdata.length()-1));
	}
	tempajaxdata = "["+tempajaxdata+"]";
%>
<script language="javascript">
function setDataSource()
{
	window.open("/integration/integrationTab.jsp?urlType=3");
}
function beforeOnSubmit(){
	if(jQuery("#isuse").attr("checked")){
		window.top.Dialog.confirm('完成后会自动重启服务，若有失败，请手动重启服务，以确保系统能正常使用！',function(){
			     onSubmit(1);
			 	});
	}else{
		onSubmit(1);
	} 
}
function onSubmit(saveType){
	if("1" == saveType){
		jQuery("#saveType").val("1");
	}
	
	var checkvalue = "casserverurl,casserverloginpage,casserverlogoutpage,ecologyloginpage";
	if("2" != saveType){
		checkvalue+=",ecologyurl";
	}
	if($("#accounttype").val()=='7'){
		checkvalue+=",customsql";
	}
	if(jQuery("#appauth").attr("checked")){
		checkvalue+=",appauthAddress";
	}
	if("1" == saveType){
		if(!jQuery("#isuse").attr("checked")){
			window.top.Dialog.confirm('是否要关闭CAS？',function(){
		     if(check_form(frmMain,checkvalue)){
				    frmMain.submit();
		     }
		 	}); 
			return;
		}
		if(!jQuery("#appauth").attr("checked") && !jQuery("#pcauth").attr("checked")){
			top.Dialog.alert('请开启pc认证或手机认证!');
			return;
		}
	}
    if(check_form(frmMain,checkvalue)){
		    frmMain.submit();
    }
}
function onBack()
{
	parentWin.closeDialog();
}
function isExist(newvalue){
}
function changeCheck(classname,obj)
{
	var status = obj.checked;
	changeCheckboxStatus(jQuery("."+classname),false);
	$("."+classname).parent().next().val("0");
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
var items=[
	{width:"0%",colname:"",itemhtml:"<INPUT  type='hidden' name='ids'  value='' _noMultiLang=true>"},
    {width:"50%",colname:"<%=SystemEnv.getHtmlLabelName(83578,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='excludeurl'  value='' _noMultiLang=true>"},
    {width:"50%",colname:"<%=SystemEnv.getHtmlLabelName(25734,user.getLanguage())%>",itemhtml:"<INPUT class='Inputstyle' type='text' name='excludedescription'  value=''>"}
    ];

var option= {
   navcolor:"#003399",
   basictitle:"",
   toolbarshow:false,
   optionHeadDisplay:"none",
   colItems:items,
   addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
   deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
   usesimpledata:true,
   openindex:false,
   configCheckBox:true,
   checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='paramid'><INPUT type='hidden' name='paramids' value='-1'>",width:"7%"},
   initdatas:eval("<%=tempajaxdata%>")
};


var group=null;

jQuery(document).ready(function () {
	group=new WeaverEditTable(option);
    jQuery("#temptsetting").append(group.getContainer());
	$("#topTitle").topMenuTitle();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
	
	if("<%=isuse%>"=="1"){
		showGroup("SetInfo");
	}else{
		hideGroup("SetInfo");
	}
});

function addRow()
{
	if(null!=group)
	{
		group.addRow(null);
	}
}
function removeRow()
{
	var count = 0;//删除数据选中个数
	jQuery("#temptsetting input[name='paramid']").each(function(){
		if($(this).is(':checked')){
			count++;
		}
	});
	//alert(v+":"+count);
	if(count==0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
	}else{
		  if(null!=group)
		{
			group.deleteRows();
		}
	}
}
</script>
</HTML>
