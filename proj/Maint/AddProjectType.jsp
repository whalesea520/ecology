<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<% if(!HrmUserVarify.checkUserRight("AddProjectType:Add",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}


if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(586,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sqlwhere = xssUtil.put("isbill=1 and ( formid=74 or exists(select 1 from prj_prjwfconf where prj_prjwfconf.isopen='1' and prj_prjwfconf.wftype=2 and prj_prjwfconf.wfid=workflow_base.id))");
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(2),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(32159,user.getLanguage())+",javascript:submitData(1),_top} " ;
RCMenuHeight += RCMenuHeightStep;

%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("586",user.getLanguage()) %>'/>
</jsp:include>
<FORM id=weaver action="/proj/Maint/ProjectTypeOperation.jsp" method=post>
<input type="hidden" name="method" value="add">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(2);">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" class="e8_btn_top" onclick="submitData(1);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

  
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(15795,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=50 size=20 name="type" onchange='checkinput("type","typeimage")' id="checktypeName">
			<SPAN id=typeimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21942,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle name="txtTypeCode">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15057,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="approvewfid" browserValue="" 
						browserUrl=""
					  	getBrowserUrlFn='getWfBrowserUrl'
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=workflowBrowser&from=prjwf&sqlwhere=<%sqlwhere %>" />
			<span class="e8_browserSpan"><button class="e8_browserAdd" title="<%=SystemEnv.getHtmlLabelNames("125",user.getLanguage())%>" id="wfid_addbtn" type="button" onclick="onCreateWf();"></button></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33130,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="insertWorkPlan" value="1" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle maxLength=150 size=50 name="desc" onchange=''>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle onkeyup="clearNoNum(this)" style="width:80px!important;" maxLength=8 size=10 name="dsporder" value=""   >
		</wea:item>
	</wea:group>
</wea:layout>	
	
			<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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

</FORM>
<script language="javascript">
function getWfBrowserUrl(data){

	return "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=<%=xssUtil.put("where isbill=1 and ( formid=74 or exists(select 1 from prj_prjwfconf where prj_prjwfconf.isopen='1' and prj_prjwfconf.wftype=2 and prj_prjwfconf.wfid=workflow_base.id))") %>";
}
function submitData(type)
{
	if (check_form(weaver,'type')){
		var value = $("#checktypeName").val();
		 var returnValue = "";
		 var msg="<%=SystemEnv.getHtmlLabelName(21943,user.getLanguage())%>";
		 var URL = "/proj/Maint/CheckTypeName.jsp?typeName="+value+"&type=add&time="+new Date();
		 URL = encodeURI(URL);
		    var flag=false;
		    jQuery.ajax({
	        url: URL,
	        type: "post",
	        async: false,
	        success: function(data){
		    	returnValue = jQuery.trim(data);
	           if('1'==returnValue) {
	        	   window.top.Dialog.alert(msg);
				        flag=false;
				        $("#checktypeName").val("");
				        checkinput("type","typeimage");
		    		}
		    		else{
		    		    flag=true;
		    		}
	        }
	    });
		if(flag){
				//weaver.submit();
				var form=jQuery("#weaver");
				var form_data=form.serialize();
				var form_url=form.attr("action");
				jQuery.ajax({
					url : form_url,
					type : "post",
					async : true,
					data : form_data,
					dataType : "json",
					contentType: "application/x-www-form-urlencoded; charset=utf-8", 
					success: function do4Success(msg){
						parentWin._table.reLoad();
						if(type==1&&msg.newid){
							onDetailEdit(msg.newid);
						}
						parentWin.closeDialog();
					}
				});
		}
		
	}
}

function onDetailEdit(id){
	var url="/proj/Maint/EditProjectType.jsp?isdialog=1&id="+id;
	var title="<%=SystemEnv.getHtmlLabelNames("83843",user.getLanguage())%>";
	openDialog(url,title,600,350);
}

function onCreateWf() {
    try{
    	var url="/workflow/workflow/addwf.jsp?isTemplate=0&isdialog=1&ajax=1&from=prjwf";
    	var formid=0;
    	if(formid!=""){
    		url+="&prjwfformid="+formid;
    	}
    	var inputid="approvewfid";
		showModalDialogForBrowser(event,
				url, '#', inputid, true, 2, '', 
				{name:inputid,hasInput:false,zDialog:true,needHidden:false,dialogTitle:'',arguments:'',_callback:onCreateWf_callback
				,dialogWidth:"800px",dialogHeight:"600px",maxiumnable:true
				}
			);
	}catch(ex1){
		alert(ex1);
	}
}
function onCreateWf_callback(p1,datas,fieldname,p4,p5){
	if (datas&&fieldname) {
		if(datas.id!=""){
			
		}else{
			
		}
    }
}
</script>
</BODY>
</HTML>
