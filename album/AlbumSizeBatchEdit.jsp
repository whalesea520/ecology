<%@page import="java.text.DecimalFormat"%>
<%@page import="com.informix.lang.Decimal"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<% 
if(!(user.getUID()==1)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<%
DecimalFormat df=new DecimalFormat("##0.00");

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
var parentDialog=null;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
	parentDialog = parent.getDialog(parent);
}

if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(432,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name="weaver" action="/album/PhotoOperation.jsp" method=post onsubmit="return false;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="photo"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("20290",user.getLanguage()) %>'/>
</jsp:include>
  <input type="hidden" name="operation" value="updateAlbumSize">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="submitData();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%
if(!"".equals(subcompanyid)){
	String albumTotalSize="";
	String albumUsedSize="";
	rs.executeSql("select * FROM AlbumSubcompany where subcompanyId='"+subcompanyid+"' ");
	if(rs.next()){
		albumTotalSize=df.format(Util.getDoubleValue(rs.getString("albumSize"))/1000.0);
		albumUsedSize=df.format(Util.getDoubleValue(rs.getString("albumSizeUsed"))/1000.0);
	}
	
%>
<input type="hidden" name="id" value="<%=subcompanyid %>" />
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="{'groupDisplay':'none'}" >
		<wea:item><%=SystemEnv.getHtmlLabelName(20290,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle onkeyup="clearNoNum(this)" style="width:80px!important;" maxLength=8 size=10 name="albumSize" value="<%=albumTotalSize %>"   />
			MB
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20005,user.getLanguage())%></wea:item>
		<wea:item><%=albumUsedSize %>MB</wea:item>
	</wea:group>
</wea:layout>

<%
	
	
}else{
	%>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>' attributes="" >
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="settype" id="settype" onchange="changeType();">
				<option value="1"><%=SystemEnv.getHtmlLabelName(128188,user.getLanguage())%></option>
				<option value="0"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item attributes="{'samePair':'seclevel_td','display':'none'}"><%=SystemEnv.getHtmlLabelName(33256,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'seclevel_td','display':'none'}">
			<brow:browser viewType="0" name="id" browserValue="" browserSpanValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=164"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20290,user.getLanguage())%></wea:item>
		<wea:item>
			<INPUT class=InputStyle onkeyup="clearNoNum(this)" style="width:80px!important;" maxLength=8 size=10 name="albumSize" value="1000"   />
			MB
		</wea:item>
	</wea:group>
</wea:layout>	
	
	<%
}

%>



	
			<!-- 对话框底下的按钮 -->
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.close();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
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
function submitData()
{
	if (check_form(weaver,'')){
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
				parentWin.closeDialog();
			}
		});
	}
}

function changeType(){
	var val=$("#settype option:selected").val();
	if(val=="1"){
		hideEle('seclevel_td');
	}else{
		showEle('seclevel_td');
	}
}
</script>
</BODY>
</HTML>
