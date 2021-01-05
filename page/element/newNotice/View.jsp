
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
/*用户验证*/


boolean isSystemer=false;
if(loginuser!=null){
	if(HrmUserVarify.checkUserRight("homepage:Maint", loginuser)) isSystemer=true;
	if (pc.getIsLocked(hpid).equals("1")) {//门户锁定，重新取下用户id
		userid=pu.getHpUserId(hpid,""+subCompanyId,loginuser);
		usertype=pu.getHpUserType(hpid,""+subCompanyId,loginuser);
	}
}
String esharelevel="";


strSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	
RecordSet rs_common = new RecordSet();
rs_common.executeSql(strSql);
if(!rs_common.next()){
	int _sharelevel = 1;
	if(isSystemer){
			_sharelevel = 2;
	}
	String insertSql = "insert into hpElementSettingDetail (userid,usertype,eid,linkmode,perpage,showfield,sharelevel,hpid) select "+userid+", "+usertype+", "+eid+", linkmode,perpage,showfield,"+_sharelevel+","+hpid+" from hpElementSettingDetail where eid="+eid+" and userid=1";
	//System.out.println("sttingCommon.jsp:===> insertSql "+ insertSql);
	rs_common.executeSql(insertSql);

	rs_common.executeSql(strSql);
}else{
	rs_common.beforFirst();
}

if(rs_common.next()){
	esharelevel=Util.null2String(rs_common.getString("sharelevel"));  //1:为查看 2:为编辑
}
if(loginuser!=null){
	if(HrmUserVarify.checkUserRight("homepage:Maint", loginuser)){
	    esharelevel = "2";
	} else {
	//    esharelevel = "0";
	}
}

RecordSet rs = new RecordSet();
if (rs.getDBType().equals("sqlserver")) {
	rs.executeSql("select top " + perpage + " * from hpElement_notice order by id desc");
} else {
    rs.executeSql("select * from (select * from hpElement_notice  order by id desc)t where ROWNUM<" + (perpage + 1)  );
}

%>

<script type="text/javascript">
function initElement_<%=eid%>() {
	$("#addItem_<%=eid %>").bind("click", function () {
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = "/page/element/newNotice/detailsetting.jsp?eid=<%=eid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,loginuser.getLanguage()) + SystemEnv.getHtmlLabelName(23666,loginuser.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 768;
		dialog.normalDialog = false;
		dialog.maxiumnable = true;
		dialog.callbackfun = function (paramobj, id1) {
		
		};
		dialog.show();
	});
	$("tr[name=newnoticeitem_<%=eid %>]").bind("click", function () {
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		
		//dialog.URL = "/page/element/newNotice/detailsetting.jsp?eid=<%=eid%>&id=" + $(this).find("input[name=id_<%=eid %>]").val();
		dialog.URL = "/page/element/newNotice/detailviewTab.jsp?eid=<%=eid%>&subCompanyId=<%=subCompanyId %>&hpid=<%=hpid %>&id=" + $(this).find("input[name=id_<%=eid %>]").val();
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(367,loginuser.getLanguage()) + SystemEnv.getHtmlLabelName(23666,loginuser.getLanguage())%>";
		dialog.Width = 600;
		dialog.Height = 768;
		dialog.normalDialog = false;
		dialog.maxiumnable = true;
		dialog.callbackfun = function (paramobj, id1) {
		
		};
		dialog.show();
	});
}
$(document).ready(function() {
initElement_<%=eid%>();
});
</script>


<table id="newNoticeViewTalbe_<%=eid %>" width="100%" height="100%" cellpadding="0" cellspacing="0" style="table-layout:fixed;">
	<colgroup><col width="97px"><col width="18px"><col width="*"></colgroup>
	<%
	while (rs.next()) {
	    String id = rs.getString("id");
	    String noticeimgsrc = Util.null2String(rs.getString("imgsrc"));
	    String noticetitle = Util.null2String(rs.getString("title"));
	    String noticeconent = Util.null2String(rs.getString("content"));
	    
	%>
	<tr style="cursor:pointer;" name="newnoticeitem_<%=eid %>" valign="middle">
		<td>
		<!-- 此处使用class="noticeitemimgblock"定义div的高宽，在ie中不能成功，都放style里-->
			<div style="height:66px;width:97px;position:relative;border:1px solid #d7d8e0;background:url('<%=noticeimgsrc %>') center center no-repeat;background-size:100% 100%;">
			</div>
			<input type="hidden" name="id_<%=eid %>" value="<%=id %>">
		</td>
		<td>
		</td>
		<td valign="middle">
			<div class="siteminputblock">
				<div class="noticeinfoline" style="height:11px!important;"></div>
				<div class="noticeitemtitle"><%=noticetitle %></div>
				<div class="noticeinfoline"></div>
				<div class="noticeitemdesc">
					<%=Util.delHtmlWithSpace(noticeconent) %>
				</div>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<div class="noticeitemline"></div>
		</td>
	</tr>
	<%
	}
	%>
</table>

<%
if (esharelevel.equals("2")) {
%>
<div class="noticeitemnew" style="">
	<div style="position:absolute;height:24px;width:24px;z-index:10000;top:50%;left:50%;cursor:pointer; ">
		<img src="/page/element/newNotice/resource/image/new.png" height="24px" width="24px" style="margin-top:-12px;margin-left:-12px;" id="addItem_<%=eid %>" title="<%=SystemEnv.getHtmlLabelName(611,loginuser.getLanguage()) + SystemEnv.getHtmlLabelName(23666,loginuser.getLanguage())%>">
	</div>
</div>

<%
}
%>

