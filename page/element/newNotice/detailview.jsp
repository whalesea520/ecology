<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@page import="weaver.general.PageIdConst"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>

<jsp:useBean id="pc" class="weaver.page.PageCominfo" scope="page" />
<jsp:useBean id="pu" class="weaver.page.PageUtil" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

int userid=user.getUID(); 
int usertype = 0 ;

int eid = Util.getIntValue(Util.null2String(request.getParameter("eid")));
int isfromlist = Util.getIntValue(Util.null2String(request.getParameter("isfromlist")));
int id = Util.getIntValue(Util.null2String(request.getParameter("id")), -1);

String hpid = Util.null2String(request.getParameter("hpid"));
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"), -1);

String noticetitle = "";
String noticeconent = "";
String noticeimgsrc = "";
RecordSet rs = new RecordSet();
if (id > 0) {
	rs.executeSql("select * from hpElement_notice where id=" + id);
    if (rs.next()) {
        noticeimgsrc = Util.null2String(rs.getString("imgsrc"));
	    noticetitle = Util.null2String(rs.getString("title"));
	    noticeconent = Util.null2String(rs.getString("content"));
    }
}
int sqlUid = userid;
int sqlUtype = 0;


sqlUid=pu.getHpUserId(hpid,""+subCompanyId,user);
sqlUtype=pu.getHpUserType(hpid,""+subCompanyId,user);

String esharelevel="1";
String strSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+sqlUid+" and usertype="+sqlUtype;	
rs.executeSql(strSql);
if(rs.next()){
	esharelevel=Util.null2String(rs.getString("sharelevel"));  //1:为查看 2:为编辑
}
if(HrmUserVarify.checkUserRight("homepage:Maint", user)){
    esharelevel = "2";
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
	
	<style type="text/css">
		* {
			font-size:12px;
		}
	</style>
	
	<script type="text/javascript">
	  	function cancle() {
			parent.dialog.close();
	  	}
		$(function () {
			jQuery("#topTitle").topMenuTitle();
			resizeDialog(document);
		})
		
		function updatenotice(id) { 
			parent.parent.$("#_Title_" + parent.dialog.ID).html(" <%=SystemEnv.getHtmlLabelName(26473,user.getLanguage()) + SystemEnv.getHtmlLabelName(23666,user.getLanguage())%>");
			window.parent.location.href = "/page/element/newNotice/detailsetting.jsp?isfromlist=1&id=<%=id%>&isfromlist=<%=isfromlist %>&eid=<%=eid %>";
		}
		function onMultiDel() {
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83877,user.getLanguage())%>?",function(){
				$.ajax({
					url: "/page/element/newNotice/detailsettingOperation.jsp",
					type : "GET", 
					data : {isdel:"true", delids:"<%=id %>," , isfromlist:"<%=isfromlist %>"},
			        contentType : "charset=UTF-8", 
			        error:function(ajaxrequest){
			        	//dialog.close();
					}, 
			        success:function(content) {
			        	//parentWin.location.reload();
			        	try {
							parent.parentWin.onRefresh('<%=eid %>','newNotice');
						} catch (e) {}
						
						try {
							parent.parentWin._table.reLoad();
						} catch (e) {}
						parent.dialog.close();
					}
				});
			});
		}
	</script>
  </head>
  <body style="margin:0px;">
  <form method="post" action="list.jsp" id="noticeform"> 
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;" >	
			<%
			//门户编辑权限验证
		    if(esharelevel.equals("2")){
			%>
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>" style="font-size:12px" class="e8_btn_top" onclick="updatenotice(this)">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" style="font-size:12px" class="e8_btn_top middle" onclick="onMultiDel(this)">
				<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu" id="rightclickcornerMenu"></span>
			<%
			}
			%>
			</td>
		</tr>
	</table>
	</form>
  <div class="zDialog_div_content" style="position:absolute;bottom:40px;top:0px;width: 100%;">
  
	<div style="margin:0px 10px;height: 95%">
	<iframe id = 'detailviewframe' src="/page/element/newNotice/detailviewframe.jsp?id=<%=id%>&eid=<%=eid%>" style='width:100%;height:100%;border:none'></iframe>
	</div>
	
	
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="" class="zd_btn_cancle" onclick="cancle();"/>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	
  </body>
</html>
