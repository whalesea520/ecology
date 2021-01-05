
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="dc" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rolec" class="weaver.hrm.roles.RolesComInfo" scope="page" />

<%
String id =Util.null2String(request.getParameter("id"));
String menuid =Util.null2String(request.getParameter("menuid"));
String menutype= Util.null2String(request.getParameter("menutype"));
String method= Util.null2String(request.getParameter("method"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));

String closeDialog = Util.null2String(request.getParameter("closeDialog"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
String needfav ="1";
String needhelp ="";

boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  
boolean hasRight = false;
if(HeadMenuhasRight || SubMenuRight)
	hasRight = true;
/*CheckSubCompanyRight cscr=new CheckSubCompanyRight();
int opreateLevel=cscr.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",Util.getIntValue(subCompanyId));
hasRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);
/*if(user.getUID()==1||opreateLevel>0){
	hasRight = true;
}*/
if(!hasRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%  
   	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
   	RCMenuHeight += RCMenuHeightStep ;
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(),_self} " ;
   	//RCMenuHeight += RCMenuHeightStep ;
	
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:onGoBack(),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
%>

<%
boolean isUsed =false; // 该菜单是否被使用
rs.execute("select id from hpelementsetting where name = 'menuIds' and value='"+id+"'");
if(rs.next()){
	isUsed = true;
}

String menuname = "";
String menutarget = "";
String menuhref = "";
String sharetype = "";
String sharevalue = "";
if("editMenu".equals(method)){
	rs.executeSql("select menuname,menuhref,menutarget,sharetype,sharevalue from menucustom where id="+id+" and menutype="+menuid);
	rs.next();
	menuname = rs.getString("menuname");
	menutarget = rs.getString("menutarget");
	menuhref = rs.getString("menuhref").replaceAll("：",":");
	sharetype = rs.getString("sharetype");
	sharevalue = rs.getString("sharevalue");
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
  </head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="portal"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(33497,user.getLanguage())%>"/> 
</jsp:include>
<div class="zDialog_div_content">
<form id="frmInfo" name='frmInfo' action="/page/maint/menu/MenuOperate.jsp" method="post">
	<input type="hidden" name="method" id="method" value="<%=method %>">
	<input type="hidden" name="id" value="<%=id%>">
	<input type="hidden" name="menuid" value="<%=menuid%>">
	<input type="hidden" name="subCompanyId" value="<%=subCompanyId %>">
	<input type="hidden" name="isUsed" id="isUsed" value="<%=isUsed %>">
<wea:layout type="2Col">
     <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
      <wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题--></wea:item>
      <wea:item>
        <wea:required id="namespan" required="true" value='<%=menuname %>'>
         <input type="text" class="inputstyle" name="name" id="name" value="<%=menuname %>" onchange='checkinput("name","namespan")' >
         </wea:required>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%><!--链接--></wea:item>
      <wea:item>
      	 <!--<input type="text" id="menuhref" name="menuhref" class='inputstyle' value="<%=menuhref %>">
         <button type="button"   class=Browser onclick="onShowLoginPages('menuhref','hrefSpan','')"></BUTTON>
		 <span id=hrefSpan name=hrefSpan></span>-->
		 <div id="linktypeDiv">
      	<select name="changelinktype" style="width:85px;float:left;" id="changelinktype">
         	<option value="normal"><%=SystemEnv.getHtmlLabelName(18016,user.getLanguage())%></option>
         	<option value="advance"><%=SystemEnv.getHtmlLabelName(19048,user.getLanguage())%></option>
         </select>
     	<INPUT class="InputStyle linktype" style="width:200px;float:left;" id="menuhref" name="menuhref" value="<%=menuhref %>" title="<%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>">
     	<%if("1".equals(menutype)){%>
		<brow:browser viewType="0" name="brow_menuhref" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/HomepageTabs.jsp?_fromURL=pageContent&menutype=1" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="200px"
							 linkUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=1" 
							browserSpanValue='<%=menuhref %>' _callback='doCallBack'></brow:browser>
		<%}else if("2".equals(menutype)){%>
		<brow:browser viewType="0" name="brow_menuhref" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/HomepageTabs.jsp?_fromURL=pageContent&menutype=2" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='1'  width="200px"
							 linkUrl="/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=2" 
							browserSpanValue='<%=menuhref %>' _callback='doCallBack'></brow:browser>
		<%}%>
		<SPAN>
      		<IMG title='<%=SystemEnv.getHtmlLabelName(20599,user.getLanguage())%>  "Http://"' src="/images/homepage/remind_wev8.png" align=absMiddle ></a>
      	</SPAN>
		</div>
      </wea:item>
      <wea:item><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%><!--位置--></wea:item>
      <wea:item>
         <select name="menutarget"  id="menutarget">
			<option value='mainFrame' <%="mainFrame".equals(menutarget)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%><!--默认窗口--></option>
			<option value='_blank' <%="_blank".equals(menutarget)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%><!--弹出窗口--></option>
			<option value='_parent' <%="_parent".equals(menutarget)?"selected":"" %>><%=SystemEnv.getHtmlLabelName(25491,user.getLanguage())%><!--父窗口--></option>
		</select>
      </wea:item>
     </wea:group>
</wea:layout>	
	</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="onSave();"/>
	     <span class="e8_sep_line">|</span>
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<SCRIPT LANGUAGE="JavaScript">

	function onSave(){
		if($("#securitylevel").is(":hidden")){
			if(!check_form(document.frmInfo,'name,sharevalue')){
				return;
			}
		}else{
			if(!check_form(document.frmInfo,'name,sharevalue,securitylevel')){
				return;
			}
		}
		jQuery("#menusharetype").val(getShareType());
		jQuery("#menusharevalue").val(getShareValue());
		jQuery("#sharevalue").val(getShareValue());
		//jQuery("#menuhref").val(jQuery("#menuhref").val().replace(":","："));
		document.frmInfo.submit();
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);
		dialog.close();
	}
	
	jQuery(document).ready(function(){
		resizeDialog(document);
		
		var closeDialog = "<%=closeDialog%>";
		if(closeDialog=="close"){
			var parentWin = parent.getParentWindow(window); 
			parentWin.location.reload();
			onCancel();
		}
		
		$("#changelinktype").bind("change",function(){
			var id = $(this).val();
			if(id=="normal"){
				$("#linktypeDiv .e8_os").hide();
				$("#menuhref").show();
			}else{
				$("#linktypeDiv .e8_os").show();
				$("#menuhref").hide();
			}
		})
		$("#linktypeDiv .e8_os").hide();
	})
	
	function doCallBack(event,datas,name,_callbackParams){
		var input = name.replace("brow_","")
		$("#"+input).val($("#"+name).val())
	}
</SCRIPT>

<SCRIPT LANGUAGE="JavaScript">
<!--
	//添加一条权限
	function addPurview(){
		if($("#securitylevel").is(":hidden")){
			if(!check_form(document.frmInfo,'name,sharevalue')){
				return;
			}
		}else{
			if(!check_form(document.frmInfo,'name,sharevalue,securitylevel')){
				return;
			}
		}
		var valueString = getShareValueString();
		$("#purviewContent").append(valueString);
		jQuery("body").jNice();
	}
	
	//删除所选权限
	function removePurview(){
		$(":checkbox[checked=true]").each(function(){
			$("#tr_"+this.id).remove();
		});
		
	}
	var first = false;
	function getShareValueString(){
		
		var sharetype=$("#sharetype").val();
		var maxid = $("#purviewContent").attr("maxid");
		maxid++;
		$("#purviewContent").attr("maxid",maxid)
		
		var sharevalue;
		var sharevalueString;
		switch(parseInt(sharetype)){
			case 1:
				sharevalue=$("#sharevalue").val();
				sharevalueString="<td class=\"field\">"+$("#sharetype option:selected").text()+"</td><td class=\"field\" width=10></td><td class=\"field\">"+$("#sharetext").html()+"</td>"
				break;
			case 2:
				sharevalue=$("#sharevalue").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString="<td class=\"field\">"+$("#sharetype option:selected").text()+"+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td class=\"field\" width=10></td><td class=\"field\">"+$("#sharetext").html()+""+"+"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
			case 3:
				sharevalue=$("#sharevalue").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString="<td class=\"field\">"+$("#sharetype option:selected").text()+"+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td class=\"field\" width=10></td><td class=\"field\">"+$("#sharetext").html()+""+"+"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
			case 5:
				sharevalue=1;
				sharevalueString="<td class=\"field\">"+$("#sharetype option:selected").text()+"</td><td class=\"field\" width=10></td><td class=\"field\">"+$("#sharetype option:selected").text()+"</td>";
				break;
			case 6:
				sharevalue=$("#sharevalue").val()+"_"+$("#roletype").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString="<td class=\"field\">"+$("#sharetype option:selected").text()+"+<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td class=\"field\" width=10></td><td class=\"field\">"+$("#sharetext").html()+"+"+$("#roletype option:selected").text()+"+"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
			case 7:
				sharevalue =  $("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString = "<td class=\"field\"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td class=\"field\" width=10></td><td class=\"field\">"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
		}
		var line = "<tr style=\"height:1px;\"><td class=\"line\" colspan=4></td></tr>";
		
		if("<%=method%>"=="editMenu")sharevalueString = line + "<tr id='tr_"+maxid+"' sharetype="+sharetype+" sharevalue='"+sharevalue+"'><td class=\"field\"><input type=checkbox id="+maxid+"></td>"+sharevalueString+"</tr>";
		else if(first)sharevalueString = line + "<tr id='tr_"+maxid+"' sharetype="+sharetype+" sharevalue='"+sharevalue+"'><td class=\"field\"><input type=checkbox id="+maxid+"></td>"+sharevalueString+"</tr>";
		else sharevalueString = "<tr id='tr_"+maxid+"' sharetype="+sharetype+" sharevalue='"+sharevalue+"'><td class=\"field\"><input type=checkbox id="+maxid+"></td>"+sharevalueString+"</tr>";
		first = true;
		
		return sharevalueString;
	}
	

	function onDel(){	
		if(isdel()){
			if($("#isUsed").val()=="true"){
				alert("<%=SystemEnv.getHtmlLabelName(22688,user.getLanguage())%>")
				return;
			}
			$("#method").val("del");
			frmEdit.submit();		
		}	
		
	}
	
	function onGoBack(){
	    if(confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>？"))
		  location.href="/page/maint/menu/MenuCenter.jsp?menutype=<%=menutype%>&subCompanyId=<%=subCompanyId%>"
	}

	/**
	*获取菜单共享信息
	*/
	function getShareValue(){
		var sharevalue="";
		$(":checkbox").each(function(){
			sharevalue+=$("#tr_"+this.id).attr("sharevalue")+"$"
		})
		if(sharevalue!=""){
			sharevalue = sharevalue.substring(0,sharevalue.length-1);
		}else{
			sharevalue = "1";
		}
		return sharevalue;
	}
	
	function getShareType(){
		var sharetype="";
		$(":checkbox").each(function(){
			sharetype+=$("#tr_"+this.id).attr("sharetype")+"$"
		})
		if(sharetype!=""){
			sharetype = sharetype.substring(0,sharetype.length-1);
		}else{
			sharetype = "5"
		}
		return sharetype;
	}

//-->
function onChangeSharetype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	
	if(thisvalue==1){  //人员
 		document.getElementById("btnHrm").style.display='';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide()
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==2)	{ //分部
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==3)	{ //部门
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==5)	{ //所有人
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		$("#operate").val(0);
		txtObj.value="1";
		spanObj.innerHTML="";
	}else if (thisvalue==6){
		$("#btnRole").show();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").show();
		$("#roletype_tr").prev().show();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;
	}else if (thisvalue==7){
		$("#btnRole").hide();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		txtObj.value=$("#securitylevel").val();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#securitylevelspan").html("");
		$("#operate").val(0);
		spanObj.innerHTML="";
	}
	
}

function onShowLoginPages(input,span,eid){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/homepage/maint/LoginPageBrowser.jsp?menutype=<%=rs.getString("menutype")%>&menuId=<%=id%>","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if (datas){
		mtype = "<%=rs.getString("menutype")%>"
		//alert(datas.name+"------"+datas.id);
		if (mtype==1){
			if (datas.id!="") {
				if(datas.id.length>4){
					datas.id=datas.id.substring(0,4)+"...";
			    }
				$($G(span)).html("<a href='"+datas.name +"' target='_blank'>" + datas.id+ "</a>");
				$($G(input)).val(""+datas.name);
			}else {
				$($G(span)).html("");
				$($G(input)).val("");
			}
		}else{
			if (datas.id!="") {
				if(datas.id.length>4){
					datas.id=datas.id.substring(0,4)+"...";
			    }
				$($G(span)).html("<a href='"+datas.name +"' target='_blank'>" + datas.id+ "</a>");
				$($G(input)).val(""+datas.name);
			}
			else{
				$($G(span)).html("");
				$($G(input)).val("");
			}
		}
		}
}
</SCRIPT>
<script type="text/javascript">
function onShowSubcompany(inputname,spanname)  {
		linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	    		"","dialogHeight=550px;dialogWidth=550px;");
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
			"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	 if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
	    }
	    else	{
    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputname+"]").val("");
	    }
	}
}


function onShowRole(inputename,tdname){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
	    }
	}
}
function onShowResource(inputname,spanname){
	 linkurl="javaScript:openhrm(";
	 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
</script>
