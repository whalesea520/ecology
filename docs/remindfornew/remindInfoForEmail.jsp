<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UtilForSendNewDoc" class="weaver.docs.docs.util.UtilForSendNewDoc" scope="page" />
<%
int urlType=1;
String method=Util.null2String(request.getParameter("method"));
String secid=Util.null2String(request.getParameter("secid"));
String titlemsg=Util.null2String(request.getParameter("titlemsg"));
String bodymsg=Util.null2String(request.getParameter("bodymsg"));
String needclose="false";
if("edit".equals(method)){
    String sql = "update remindfornewDoc set titlemessage='"+titlemsg+"',bodymessage='"+bodymsg+"'  where secid= "+secid+" and urltype="+urlType;
	RecordSet.execute(sql);
	needclose="true";
}else{
	RecordSet.execute("select * from remindfornewDoc where secid= "+secid+"and urltype="+urlType);
	if(RecordSet.next()){
		titlemsg=RecordSet.getString("titlemessage");
		bodymsg=RecordSet.getString("bodymessage");
	}else{
		titlemsg="您有新的待阅文档《$DOC_Subject》，请查阅";
		bodymsg="您有新的待阅文档《$DOC_SubjectByLink 》，请查阅";
		//response.sendRedirect("/notice/noright.jsp");
		//return;
		RecordSet1.execute("insert into remindfornewDoc values(1,'您有新的待阅文档《$DOC_Subject》，请查阅','您有新的待阅文档《$DOC_SubjectByLink 》，请查阅',"+secid+")");
		RecordSet1.executeSql("insert into remindfornewDoc values(2,'','您有新的待阅文档《$DOC_Subject》，请查阅',"+secid+")");
	}

}
String titlename = SystemEnv.getHtmlLabelName(32714,user.getLanguage());
int langid=user.getLanguage();
%>
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/wui_wev8.css">
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">


var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
function jsOK(){
	$('#myForm').submit();
}
var obj;
function insertTemplate(value){
	if(obj){
		jQuery(obj).insertContent(value);
	}else{
		jQuery("#bodymsg").insertContent(value);
	}
}

function changefoucus(thisobj){
	obj=thisobj;
}

function changeTitle(){
	if($("#type").find("option:selected").attr("hastitle")=='1'){
		showEle("titletr", true);
	}else{
		hideEle("titletr", true);
		obj=null;
	}
}

$(document).ready(function() {
	 changeTitle();
	 jQuery("#remindVariable").perfectScrollbar();
	 if("<%=needclose%>"=="true"){
	 	dialog.close();
	 }
});
</script>
<style>
	.e8_btn{
		white-space:nowrap;
	}
</style>
</HEAD>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:jsOK();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="jsOK();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form id="myForm" name="myForm" action="remindInfoForEmail.jsp" method="post">
	<input name="urlType" type="hidden" value="<%=urlType %>">
	<input name="secid" type="hidden" value="<%=secid %>">
	<input name="method" type="hidden" value="edit">
 	<table cellspacing="0" style="background-color: rgb(248,248,248)">
 		<tr>
 		 <td width="70%" valign="top">
 		 	<wea:layout type="2col">
		 		<wea:group context='<%=SystemEnv.getHtmlLabelName(19480, user.getLanguage()) %>' attributes="{'groupSHBtnDisplay':'none'}">
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(82223, user.getLanguage()) %>:
					</wea:item>
					<wea:item>
					</wea:item>
					<wea:item>
						<textarea rows="3" style="width:500px;height:90px;" id="titlemsg" name="titlemsg" value="<%=titlemsg %> " onfocus="changefoucus(this)"><%=titlemsg %> </textarea>
					</wea:item>
					<wea:item>
					</wea:item>
		 			<wea:item>
		 				<%=SystemEnv.getHtmlLabelName(81729, user.getLanguage()) %>:
		 			</wea:item>
					<wea:item>
					</wea:item>
		 			<wea:item>
		 				<textarea rows="6" style="width:500px;height:160px;" id="bodymsg" name="bodymsg" value="<%=bodymsg %> " onfocus="changefoucus(this)"><%=bodymsg %> </textarea>
		 			</wea:item>
					<wea:item>
					</wea:item>
		 		</wea:group>
			</wea:layout>
 		 </td>
 		 <td  width="30%"  valign="top">
 		 	<table class="LayoutTable" id="" style="display:'';width:100%;">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr class="intervalTR" _samepair="" style="display:''">
						<td colspan="2">
							<table class="LayoutTable" style="width:100%;">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<tbody><tr class="groupHeadHide">
									<td class="interval">
										<span class="groupbg"> </span>
										<span class="e8_grouptitle"><%=SystemEnv.getHtmlLabelNames("33748", user.getLanguage()) %></span>
									</td>
									<td class="interval" colspan="2" style="text-align:right;">
												<span class="toolbar">
												</span>
										<span _status="0" class="hideBlockDiv" style="display:none">
											<!----><img src="/wui/theme/ecology8/templates/default/images/2_wev8.png"> 
										</span>
									</td>
								</tr>
							</tbody></table>
						</td>
					</tr>
					<tr class="Spacing" style="height:1px;display:">
						<td class="Line" colspan="2">
					</td></tr>
			</tbody>
	    </table>
		<div id="remindVariable" style="height:80%;overflow: hidden">
			<div style="background-color: rgb(248,248,248) !important">
 				<%
 					Map fieldList=UtilForSendNewDoc.getSendContent(urlType);
					Iterator it = fieldList.entrySet().iterator();
					while(it.hasNext()){
					    Map.Entry entry =(Map.Entry)it.next();
						int fieldlabel = Util.getIntValue((String) entry.getKey());
						String template=(String)entry.getValue();
				%>	
					<button style="padding-left: 0px !important; padding-right: 0px !important" type=button  class="e8_btn" onclick="insertTemplate('<%=template %>')"><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())+"-"+template%></button><br> 
				<%	
				}
 				%>
 			</div>
		</div>					
 		 </td>
 		</tr>
 		<tr style="height:1px!important;display:;" class="Spacing">
			<td class="paddingLeft" colspan="2">
				<div class="intervalDivClass">
			</div></td>
		</tr>
 	</table>

 	<div>
		<span>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;说明：为使从邮件里快速打开文档查阅，邮件内容务必加上"文档链接" 。
		</span>
	</div>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
	    </td></tr>
	</table>
</div>
</form>
</div>
</BODY>
</HTML>
