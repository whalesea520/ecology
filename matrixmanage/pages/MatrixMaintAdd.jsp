
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<style>
#showrelatedsharename img {
	position: absolute;
	top: 10px;
	left: 250px;
}

#showrolelevel {
	position: absolute;
	top: 5px;
	left:270px;
	width:110px!important;
}
</style>
</HEAD>
<%

boolean canmaint = HrmUserVarify.checkUserRight("Matrix:Maint",user);
if (!canmaint) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33940,user.getLanguage());
String needfav ="1";
String needhelp ="";

String matrixid=Util.fromScreen(request.getParameter("matrixid"),user.getLanguage());


%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

    //RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:window.close(),_top} " ;
    //RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="resource"/>
    <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19909, user.getLanguage())+SystemEnv.getHtmlLabelName(33508, user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=frmmain name=frmmain action="MatrixMaintOperation.jsp" method=post>
<input type="hidden" name="method" value="add">
<input type="hidden" name="matrixid" value="<%=matrixid%>">


<TABLE width=100% height=100% border="0" cellspacing="0">
      <colgroup>
        <col width="5">
          <col width="">
            <col width="5">
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
              <tr>
                <td></td>
                <td valign="top">  
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE class=Shadow>
                    <tr>
                      <td valign="top">
<table Class=ViewForm >
  <COLGROUP>
  <COL width="20%">
  <COL width="60%">
  <COL width="20%">
  <TR style="height: 1px!important;"><TD  class="line1" colSpan=3></TD></TR>
  <TR>
    <TD class=field>
    <SELECT name=type onchange="onChangeType()">
      <option value="1" selected><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
     
      <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
    </SELECT>
	</TD>
    <TD class=field style="position:relative;">
       
        <div id="showresourcediv" style="position: absolute;top: 5px;left:0;" >
		   <brow:browser viewType="0" name="showresource" browserValue="" 
			browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids="
			hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' _callback="afterCallBack"
			completeUrl="/data.jsp" linkUrl="" width="240px"
			browserSpanValue=""></brow:browser>
		</div>
		
		
		
		<div id="showrole" style="display:none;position: absolute;top: 5px;left:0;">
			<brow:browser viewType="0" name="showrole" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="afterCallBack"
					completeUrl="/data.jsp?type=65"   width="240px"
					browserSpanValue="">
			</brow:browser>
		</div>
		
        
         <INPUT type=hidden name=relatedshareid id="relatedshareid" value="">
         <span id=showrelatedsharename name=showrelatedsharename><IMG src='/images/BacoError_wev8.gif'  align=absMiddle></span>
        <span id=showrolelevel name=showrolelevel style="visibility:hidden;">
        <%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
        <SELECT name=rolelevel style="width:50px">
          <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
          <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
        </SELECT>
        </span>
    </TD>
    <td class=field>
        <span id=showseclevel name=showseclevel style="display:none"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
        <INPUT type=text class="inputStyle" name=seclevel size=6 value="10" onchange='checkinput("seclevel","seclevelimage")'>
        </span>
        <SPAN id=seclevelimage></SPAN>
	</TD>		
  </TR>
  <TR style="height: 1px!important;"><TD  class="line" colSpan=3></TD></TR>
</table>
                     </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
            </table>
</form>
<script language=javascript>
function doSave(obj) {
	thisvalue=document.frmmain.type.value;
	checkThrough = false;
	if (thisvalue==1){
	    document.frmmain.relatedshareid.value = document.frmmain.showresource.value;
	    if(check_form(document.frmmain,'relatedshareid')){
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else if (thisvalue==4){
	    if(check_form(document.frmmain,'relatedshareid,seclevel')){
          document.frmmain.submit();
          checkThrough = true;
	    }
	}else{
		if(check_form(document.frmmain,'seclevel')){
			document.frmmain.submit();
			checkThrough = true;
		}
	}
	if(checkThrough) obj.disabled = true;
}
</script>
<script language=javascript>

   function afterCallBack(e,data,name){
      //console.log(data);
	  if(data && data.id != ""){
	     $("#showrelatedsharename").html("");
	     $("input[name=relatedshareid]").val(data.id);
	  }else{
	     $("#showrelatedsharename").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	     $("input[name=relatedshareid]").val("");
	  }
  }

  function onChangeType(){
	 
	thisvalue=document.frmmain.type.value;
	document.frmmain.relatedshareid.value="";
	document.all("showseclevel").style.display='';

	showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

	if(thisvalue==1){
	   jQuery("#showresourcediv").css("display","");
	   jQuery("#showseclevel").css("display","none");
		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showresourcediv").css("display","none");
	}
	if(thisvalue==2){
	     jQuery("#showsubcompany").css("display","");
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showsubcompany").css("display","none");
		document.frmmain.seclevel.value=10;
	}
	if(thisvalue==3){
	    jQuery("#showdepartment").css("display","");
 		document.frmmain.seclevel.value=10;
 		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showdepartment").css("display","none");
		document.frmmain.seclevel.value=10;
	}
	if(thisvalue==4){
	    jQuery("#showrole").css("display","");
	    jQuery("#showrolelevel").css("visibility","visible");
		document.frmmain.seclevel.value=10;
		document.getElementById("seclevelimage").innerHTML="";
	}
	else{
	    jQuery("#showrole").css("display","none");
	    jQuery("#showrolelevel").css("visibility","hidden");
		document.frmmain.seclevel.value=10;
    }
	if(thisvalue==5){
		showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value=-1;
		document.frmmain.seclevel.value=10;
		document.getElementById("seclevelimage").innerHTML="";
	}
	if(thisvalue<0){
		showrelatedsharename.innerHTML = ""
		document.frmmain.relatedshareid.value=-1;
		document.frmmain.seclevel.value=0;
	}
}


 
</script>

</body>
</html>