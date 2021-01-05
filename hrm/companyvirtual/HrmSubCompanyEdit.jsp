
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="SubCompanyVirtualComInfo" class="weaver.hrm.companyvirtual.SubCompanyVirtualComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String virtualtype = Util.null2String(request.getParameter("virtualtype"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);
String subcompanyname = SubCompanyVirtualComInfo.getSubCompanyname(""+id);
String subcompanydesc = SubCompanyVirtualComInfo.getSubCompanydesc(""+id);
int companyid = Util.getIntValue(SubCompanyVirtualComInfo.getCompanyid(""+id),0);
String companyname = CompanyVirtualComInfo.getVirtualType(""+companyid);
String canceled = SubCompanyVirtualComInfo.getCompanyiscanceled(""+id);;
String subcompanycode = SubCompanyVirtualComInfo.getSubCompanycode(""+id);;
String supsubcomid=SubCompanyVirtualComInfo.getSupsubcomid(""+id);
String showorder=SubCompanyVirtualComInfo.getShowOrder(""+id);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(141,user.getLanguage())+":"+companyname+"-"+subcompanyname;
String needfav ="1";
String needhelp ="";

boolean canEdit = true;
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_parent} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(HrmUserVarify.checkUserRight("HrmSubCompanyEdit:Edit", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=frmMain action="SubCompanyOperation.jsp" method=post>
 <input class=inputstyle type=hidden name=operation>
 <input class=inputstyle type=hidden name=companyid value="<%=companyid%>">
 <input class=inputstyle type=hidden id=id name=id value="<%=id%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
    <wea:item><%if(canEdit){%>
    <INPUT class=inputstyle maxLength=60 size=50 id="subcompanyname" name="subcompanyname" value="<%=subcompanyname%>" onblur="checkLength('subcompanyname',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"  onchange='checkinput("subcompanyname","subcompanynameimage")'>
    <SPAN id=subcompanynameimage></SPAN>
    <%}else{%><%=subcompanyname%><%}%></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></wea:item>
    <wea:item><%if(canEdit){%>
    <INPUT class=inputstyle type=text maxLength=60 size=50 id="subcompanydesc" name="subcompanydesc" value="<%=subcompanydesc%>" onblur="checkLength('subcompanydesc',60,'','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" onchange='checkinput("subcompanydesc","subcompanydescimage")'>
    <SPAN id=subcompanydescimage></SPAN>
    <%}else{%><%=subcompanydesc%><%}%></wea:item>
  	<wea:item><%=SystemEnv.getHtmlLabelNames("596,141",user.getLanguage())%></wea:item>
    <wea:item><%if(canEdit){
    	String browUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/companyvirtual/SubCompanyBrowser.jsp?virtualtype="+virtualtype+"&selectedids=";
    	String completeurl = "/data.jsp?type=subcompanyvirtual&virtualtype="+virtualtype;
    %>
    	<brow:browser viewType="0"  name="supsubcomid" browserValue='<%=supsubcomid %>' 
      browserUrl='<%=browUrl %>' hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
      completeUrl='<%=completeurl %>'
      browserSpanValue='<%=SubCompanyVirtualComInfo.getSubCompanyname(""+supsubcomid) %>'>
      </brow:browser>
    <%}else{%><%=SubCompanyVirtualComInfo.getSubCompanyname(""+supsubcomid)%><%}%>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>  
    <wea:item><%if(canEdit){%><INPUT class=inputstyle size=50 name="showorder" value='<%=showorder%>'  >
    <%}else{%><%=showorder%><%}%></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></wea:item>  
    <wea:item><%if(canEdit){%><INPUT class=inputstyle size=50 maxlength=100 name="subcompanycode" value='<%=subcompanycode%>'  >
    <%}else{%><%=subcompanycode%><%}%></wea:item>
	</wea:group>
</wea:layout>
 </form>
  <%if("1".equals(isDialog)){ %>
  </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %> 
<script>
function onSave(){
  if(document.frmMain.supsubcomid.value==<%=id%>){
     window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22214,user.getLanguage())%>");
     return false;
  }		
	if(check_form(document.frmMain,'subcompanyname,subcompanydesc')){
		var hasChecked = true;
		jQuery("img").each(function(){
			if(jQuery(this).attr("src")=="/images/BacoError_wev8.gif"){
				hasChecked = false;
				return false;
			}
		});
		
		if(!hasChecked){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");;
			return false;
		}
	
	 	document.frmMain.operation.value="editsubcompany";
	 	
	 	//校验重复名
	 	var id = jQuery("#id").val();
 	 	var companyid = jQuery("input[name=companyid]").val();
	 	var subcompanyname = jQuery("#subcompanyname").val();
	 	var subcompanydesc = jQuery("#subcompanydesc").val();
	 	jQuery.ajax({
			url:"/hrm/ajaxData.jsp?cmd=checksubcompanyname&id="+id+"&subcompanyname="+subcompanyname+"&subcompanydesc="+subcompanydesc+"&companyid="+companyid,
			type:"post",
			async:true,
			success:function(data,status){
				if(data.trim()=="1"){
					document.frmMain.submit();
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26603, user.getLanguage())%>");
				}
			},
		});
	}
}
function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}

function doCanceled(){
    if(confirm("<%=SystemEnv.getHtmlLabelName(22153, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22155, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	            }else{
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22253, user.getLanguage())%>");
	            }
            }catch(e){
                return false;
            }
        }
     }
  }
}

 function doISCanceled(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(22154, user.getLanguage())%>")){
	  var ajax=ajaxinit();
      ajax.open("POST", "HrmCanceledCheck.jsp", true);
      ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      ajax.send("deptorsupid=<%=id%>&cancelFlag=1&userid=<%=user.getUID()%>&operation=subcompany");
      ajax.onreadystatechange = function() {
        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
	            if(ajax.responseText == 1){
	              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22156, user.getLanguage())%>");
	              parent.leftframe.location.reload();
	              window.location.href = "HrmSubCompanyDsp.jsp?id=<%=id%>";
	            } else {
	               window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24298, user.getLanguage())%>");
	               return;
	            }
            }catch(e){
                return false;
            }
        }
     }
   }
 }
 </script>
</BODY>
</HTML>
