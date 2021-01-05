<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CompetencyComInfo" class="weaver.hrm.job.CompetencyComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="JobGroupsComInfo" class="weaver.hrm.job.JobGroupsComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>

<%!
    /**
     * Added by Charoes Huang On May 19,
     * @param typeid
     * @return  a boolean value
     */
    private boolean canDelete(int typeid){
        boolean canDelete =true;
        String sqlStr ="Select COUNT(*) AS COUNT FROM HrmAwardInfo WHERE rptypeid ="+typeid;
        RecordSet rs = new RecordSet();
        rs.executeSql(sqlStr);
        if(rs.next()){
            if(rs.getInt("COUNT") > 0)
                canDelete = false;
        }
        return canDelete;
    }
%>
<%
String id = request.getParameter("id");

boolean canDelete = canDelete(Integer.valueOf(id).intValue());
String name="";
String description="";
String transact="" ;
int awardtype=0;
RecordSet.executeProc("HrmAwardType_SByid",id);
RecordSet.next();
name = RecordSet.getString("name");
awardtype =RecordSet.getInt("awardtype");
description = Util.toScreenToEdit(RecordSet.getString("description"),user.getLanguage());
transact = Util.toScreenToEdit(RecordSet.getString("transact"),user.getLanguage());

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(6099,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Edit", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Edit", user)){
	canEdit = true;
}
%>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(HrmUserVarify.checkUserRight("HrmRewardsTypeEdit:Edit", user)){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
		<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=frmMain name=frmMain action="HrmAwardTypeOperation.jsp" method=post>
<input class=inputstyle type="hidden" name=operation value="edit">
<input class=inputstyle type="hidden" name=id value="<%=id%>">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(6099,user.getLanguage())%>'>
  	<wea:item><%=SystemEnv.getHtmlLabelName(15666,user.getLanguage())%></wea:item>
    <wea:item><%if(canEdit){%>
      <input class=inputstyle maxLength=60 type=text style="width: 90%" name="name" value="<%=name%>" onchange='checkinput("name","nameimage")'>
      <%}else{%><%=name%><%}%>
      <SPAN id=nameimage></SPAN>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(808,user.getLanguage())%></wea:item>
    <wea:item>
      <select class=inputstyle name=awardtype value="0">
        <option value="0"><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
       	<%if(awardtype==1){%>
				<option value="1" selected><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
      	<%}else{%>
        <option value="1"><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
	  	<%}%>
	  	</select>
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15667,user.getLanguage())%></wea:item>
    <wea:item> <%if(canEdit){%>
    	<TEXTAREA class=inputstyle name="description" style="width: 90%" rows=6><%=description%></TEXTAREA><%}else{%><%=description%><%}%>
    	<SPAN id=descriptionimage></SPAN>
   	</wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(15432,user.getLanguage())%></wea:item>
    <wea:item> <%if(canEdit){%>
    	<TEXTAREA class=inputstyle name="transact" style="width: 90%" rows=6><%=transact%></TEXTAREA><%}else{%><%=transact%><%}%>
    	<SPAN id=transact></SPAN>
    </wea:item>
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
 <script language=javascript>
 function onSave(){
    var maxlength = 100;
	if(check_form(frmMain,'name')&&checkTextLength(frmMain.description,maxlength)&&checkTextLength(frmMain.transact,maxlength)){

		document.frmMain.submit();
	}
 }

 function onDelete(){
		  <%if(canDelete) {%>
    if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
      document.frmMain.operation.value = "delete";
      document.frmMain.submit();
    }
	<%}else{%>
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17049,user.getLanguage())%>");
		<%}%>
}
function checkTextLength(textObj,maxlength){
    var len = trim(textObj.value).length
    if(len >  maxlength){
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83448,user.getLanguage())%>"+maxlength);
        return false;
    }
    return true;
  }
 /**
 * trim function ,add by Huang Yu
 */
 function trim(value) {
   var temp = value;
   var obj = /^(\s*)([\W\w]*)(\b\s*$)/;
   if (obj.test(temp)) { temp = temp.replace(obj, '$2'); }
   return temp;
}

 </script>
</BODY>
</HTML>
