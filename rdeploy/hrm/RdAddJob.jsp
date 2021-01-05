<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
</style>
</head>

<%
String deptid= Util.null2String(request.getParameter("deptid"));
String jobactivitId = "";  //职务ID
String sql = " select id  from HrmJobActivities a  where jobactivityname ='待定' ";
RecordSet.executeSql(sql);
if(RecordSet.next()){
    jobactivitId = RecordSet.getString(1);
}



%>

<BODY>
<FORM id=weaver name=frmMain action="RdJobOperation.jsp" method=post>
<input type=hidden id="method" name=method value="editDept">
<input type=hidden id="deptid" name=deptid value="<%=deptid %>">
<input type=hidden id="jobactivitId" name=jobactivitId value="<%=jobactivitId %>">
<div style="padding-top: 65px;height: 100px;">
<table>
  <tr>
   <td style="padding: 0 20px 0 40px;font-size: 13px;" class="rdeploycommoncolor"><%=SystemEnv.getHtmlLabelName(125228,user.getLanguage())%> </td>
   <td >
   	  <INPUT class=rdeploycommoninputclass type=text maxLength=20 size=30 style="height: 30px;width: 222px;" name=jobname id="jobname" value="" onchange=''>
   </td>
  </tr>
</table>

</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" id="dosubmit" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_cancel" onclick="doSubmit()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
 
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);	



function doSubmit() {
   var jobname = jQuery("#jobname").val();
   var departmentid = jQuery("#deptid").val();
   if(jobname==""){
   		window.parent.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125229,user.getLanguage())%>");
   		return;
   }
   $.ajax({
		 data:{"jobname":jobname,"departmentid":departmentid},
		 type: "post",
		 cache:false,
		 url:"RdJobOperationAjax.jsp",
		 dataType: 'json',
		 success:function(data){
			 if(data.success == "0"){
				   $("#dosubmit").attr('disabled',"true");
				   frmMain.submit();
			 }else{
		 	 	 window.parent.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125230,user.getLanguage())%>');
			 	 	 return;
			 }
		 }
   });
}

function back()
{
	window.history.back(-1);
}

</script>




</BODY></HTML>

