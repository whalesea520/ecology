
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = request.getParameter("isclose");
String error = request.getParameter("error");

%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}

function changeMsg(msg)
{
    if(msg==0){
        if(jQuery("input[name=validatecode]").val()=='<%=SystemEnv.getHtmlLabelName(84270, user.getLanguage())%>') 
            jQuery("input[name=validatecode]").val('');
    }else if(msg==1){
        if(jQuery("input[name=validatecode]").val()=='') 
            jQuery("input[name=validatecode]").val('<%=SystemEnv.getHtmlLabelName(84270, user.getLanguage())%>');
    }
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33233,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<body>
<%
if("1".equals(error)){
 %>
<DIV>
    <font color=red size=2>
    <%=SystemEnv.getHtmlLabelName(128878,user.getLanguage())%>
</font>
</DIV>
<%} %>
<FORM id=weaver name=frmMain action="HrmResourceSysValidateCode.jsp" method=post >
<input type="hidden" name="error" value=""/>
	<div class="zDialog_div_content">
		<wea:layout type="2col">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(22910, user.getLanguage())%></wea:item>
					<wea:item>
						<wea:required id="validatecodespan" required="true">
							<input type="text" class="InputStyle" name="validatecode" style="width:50%" size="15"  value="<%=SystemEnv.getHtmlLabelName(84270, user.getLanguage())%>" onchange='checkinput("validatecode","validatecodespan")' onfocus="changeMsg(0)" onblur="changeMsg(1)" onkeydown="if(event.keyCode==13)return false;">
						</wea:required>
						 <a href="javascript:changeCode()" ><img  id="imgCode" border=0 align='absmiddle' style="height: 30px;" src='/weaver/weaver.file.MakeValidateCode?notneedvalidate=1'></a>
						<script>
					   	 var seriesnum_=0;
					  	 function changeCode(){
					  	 	seriesnum_++;
					  		setTimeout('$("#imgCode").attr("src", "/weaver/weaver.file.MakeValidateCode?notneedvalidate=1&seriesnum_="+seriesnum_)',50); 
					  	 }
					  	</script>
					</wea:item>
			</wea:group>
		</wea:layout>		
	</div>
</FORM>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="submitData();">
	    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
	    	</wea:item>
	   	</wea:group>
	  </wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</body>
<script language=javascript>  
function submitData() {
	var validatecode = jQuery('input[name=validatecode]').val();
	
	if(validatecode =='<%=SystemEnv.getHtmlLabelName(84270, user.getLanguage())%>'){
		Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		return;
	}
	
	 jQuery.ajax({
		 url:"/js/hrm/getdata.jsp",
		 type:"post",
		 data:{cmd:"checkValidatecode",validatecode:validatecode},
		 dataType:"text",
		 success:function(result){
		 	if(jQuery.trim(result) == ""){
		 		jQuery("input[name='error']").val(1);
		 		frmMain.submit();
		 	}else{
		 		parentWin.afterValidateSave(validatecode);
				parentWin.closeDialog();	
		 	} 
		 }
	 });
}
</script>
</HTML>
