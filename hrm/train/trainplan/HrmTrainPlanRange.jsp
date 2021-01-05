
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
int planid = Util.getIntValue(request.getParameter("planid"),0);
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);

function onBtnSearchClick(){
	jQuery("#weaver").submit();
}

function doDel(id){
	if(!id){
		id = _xtable_CheckedCheckboxId();
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		var idArr = id.split(",");
		var ajaxNum = 0;
		for(var i=0;i<idArr.length;i++){
			ajaxNum++;
			jQuery.ajax({
				url:"TrainPlanRangeOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
				type:"post",
				async:true,
				complete:function(xhr,status){
					ajaxNum--;
					if(ajaxNum==0){
						_table.reLoad();
					}
				}
			});
		}
	});
}

function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(id==null){
		id="";
	}
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=TrainPlanRangeAdd&isdialog=1";
	if(!!id){
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6104,user.getLanguage())%>";
		url = "/hrm/HrmDialogTab.jsp?_fromURL=TrainPlanRangeEdit&isdialog=1&id="+id;
	}else{
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6104,user.getLanguage())%>";
	}
	url +="&planid=<%=planid%>";
	dialog.Width = 500;
	dialog.Height = 253;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6104,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/trainplan/HrmTrainPlanEdit.jsp?id="+planid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
			<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="HrmTrainPlanRange.jsp" method=post>
<input type="hidden" name="planid" value="<%=planid%>">
<%
String backfields = " a.id, a.type_n, a.resourceid, seclevel, seclevel_to"; 
String fromSql  = " from HrmTrainPlanRange a ";
String sqlWhere = " where planid =  "+planid;
String orderby = " a.id " ;
String tableString = "";

//操作字符串
String  operateString= "";
operateString = "<operates width=\"20%\">";
 	       operateString+=" <popedom></popedom> ";
 	       operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\" isalwaysshow=\"true\"/>";
 	       operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\" isalwaysshow=\"true\"/>";
 	       operateString+="</operates>";	
 	  tableString =" <table pageId=\""+PageIdConst.Hrm_TrainPlanRange+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_TrainPlanRange,user.getUID(),PageIdConst.HRM)+"\" >"+
		" <checkboxpopedom showmethod=\"weaver.hrm.HrmTransMethod.getHrmArrangeShiftSetCheckbox\"  id=\"checkbox\"  popedompara=\"column:id\" />"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
    operateString+
    "			<head>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(21956,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.hrm.HrmTransMethod.getTrainPlanShareTypeName\" otherpara=\""+user.getLanguage()+"\"/>"+
    "				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(106,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" transmethod=\"weaver.hrm.HrmTransMethod.getTrainPlanRelatedIdName\" otherpara=\"column:type_n\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" orderkey=\"seclevel\" otherpara=\"column:seclevel_to\" transmethod=\"weaver.hrm.HrmTransMethod.getLevelShow\"  />"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_TrainPlanRange %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
 <%if("1".equals(isDialog)){ %>
   </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
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
<script language=javascript>
function doSave() {
thisvalue=document.weaver.sharetype.value;
if (thisvalue==1)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==2)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==3)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else if (thisvalue==4)
	{if(check_form(document.weaver,'relatedshareid'))
	document.weaver.submit();}
else
	document.weaver.submit();
}
</script>

<script language=javascript>
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	document.weaver.relatedshareid.value="";
	document.all("showseclevel").style.display='';
    showrelatedsharename.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"

    if(thisvalue==0){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='none';	
		document.all("showseclevel").style.display="";
		showrelatedsharename.innerHTML = ""
	}
	if(thisvalue==1){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='none';	
		document.all("showseclevel").style.display='none';		
	}
	if(thisvalue==2){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='';	
 		document.all("showjobtitles").style.display='none';	
		document.all("showseclevel").style.display='none';
	}	
	if(thisvalue==3){
 		document.all("showresource").style.display='none';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='';		 
		document.all("showseclevel").style.display='none';
	}
	if(thisvalue==4){
 		document.all("showresource").style.display='';
 		document.all("showdepartment").style.display='none';
 		document.all("showjobactivities").style.display='none';	
 		document.all("showjobtitles").style.display='none';	 
		document.all("showseclevel").style.display='none';
	}	
}

function onShowResource(spanname, inputname) {
    tmpids = document.all(inputname).value;
    if(tmpids!="-1"){ 
     url="/hrm/resource/MutiResourceBrowser.jsp?resourceids="+tmpids;
    }else{
     url="/hrm/resource/MutiResourceBrowser.jsp";
    }
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        } else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}

function onShowDepartment(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+document.all(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.all(spanname).innerHTML = jsid[1].substring(1);
            document.all(inputname).value = jsid[0].substring(1);
        }else {
            document.all(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            document.all(inputname).value = "";
        }
    }
}

</script>
</BODY>
</HTML>
