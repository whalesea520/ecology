
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<link href="/integration/css/intepublic_wev8.css" type=text/css rel=stylesheet>
<%
if(!HrmUserVarify.checkUserRight("intergration:SAPsetting", user)){
 	response.sendRedirect("/notice/noright.jsp");
 	return;
}
%>
<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968,user.getLanguage()) %></title>
	</head>
	<%
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));//异构产品的id
		String closeDialog=Util.null2String(request.getParameter("closeDialog"));
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(30691,user.getLanguage());
		String opera="save";
		String hetename="";
		String hetedesc="";
		String sid="";

		if("1".equals(isNew))
		{
			titlename = SystemEnv.getHtmlLabelName(30692,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from int_heteProducts where id='"+id+"'");
			if(RecordSet.next())
			{
				hetename=RecordSet.getString("hetename");
				hetedesc=RecordSet.getString("hetedesc");
				sid=RecordSet.getString("sid");
			}
		}
		String needhelp ="";
		
	%>
	<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="integration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31694,user.getLanguage())%>"/> 
</jsp:include>

			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			//RCMenuHeight += RCMenuHeightStep ;
			if("1".equals(isNew)&&(SapUtil.IsShowHeteProducts(sid,id)==false))
			{
				RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td width="160px">
		</td>
		<td class="rightSearchSpan"
			style="text-align: right; width: 500px !important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit_0" class="e8_btn_top" onclick="doSubmit(this);">
			<%if("1".equals(isNew)&&(SapUtil.IsShowHeteProducts(sid,id)==false)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" class="e8_btn_top" onclick="doDelete(this,'<%=id%>')" />
			<%}%>&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
			
			<form action="/integration/heteProductsOperation.jsp" method="post" name="heteProducts" id="heteProducts">
			
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="ids" value="<%=id%>">
				<input type="hidden" name="isDialog" value="1">
<wea:layout type="2Col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'groupDisplay':\"\"}">
	<wea:item><%=SystemEnv.getHtmlLabelName(30693,user.getLanguage())%></wea:item>
    <wea:item attributes="{colspan:3}">
        <wea:required id="hetenamespan" required="true" value='<%=hetename%>'>
         <input type="text" name="hetename" id="hetename" onchange='checkinput("hetename","hetenamespan")' value="<%=hetename%>" class="selectmax_width"  maxlength="50">
        </wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30694,user.getLanguage())%></wea:item>
    <wea:item>
        <wea:required id="sidspan" required="true" value='<%=sid %>'>
			<%
				if(SapUtil.IsShowHeteProducts(sid,id)){
					out.println(SapUtil.getDataInterSelect("","hideimg(this,sidspan)",sid,"selectmax_width","     "));
					out.println("<input type='hidden' name='sid' value='"+sid+"'>");
				}else
				{
					out.println(SapUtil.getDataInterSelect("sid","hideimg(this,sidspan)",sid,"selectmax_width","     "));
				}
			 %>
		</wea:required>
    </wea:item>
	<wea:item><%=SystemEnv.getHtmlLabelName(30696,user.getLanguage())%></wea:item>
    <wea:item>
        <textarea rows="5" cols="150" name="hetedesc"  onpropertychange="checkLength(this,100);" oninput="checkLength(this,100);"  style="height: 80px"><%=hetedesc%></textarea>
    </wea:item>
	</wea:group>
</wea:layout>

			</form>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();">
	 	</wea:item>
	</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body>
<script type="text/javascript">
		function onCancel(){
			var dialog = parent.getDialog(window);   //弹出窗口的引用，用于关闭页面
			dialog.close();
		}
		
		$(document).ready(function(){
			if("<%=closeDialog%>"=="close"){			
				var parentWin = parent.getParentWindow(window);
				parentWin.location.reload();
				onCancel();
			}
		});

		function doSubmit()
		{
			var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			if(temp!=0)
			{
				
				alert("<%=SystemEnv.getHtmlLabelName(30622,user.getLanguage())%>"+"!");
				return;
			}
			$("#heteProducts").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/heteProductslist.jsp";
		}
		function doDelete(obj,id)
		{
			
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage())%>"+"!"))
			{
				window.location.href="/integration/heteProductsOperation.jsp?isDialog=1&opera=delete&ids="+id;
			}
		}
		function hideimg(obj,objspan)
		{
			if(obj.value)
			{
				$(objspan).html("");
			}else
			{
				$(objspan).html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
			}
		}
		//限制文本域的长度
		function checkLength(obj,maxlength){
		    if(obj.value.length > maxlength){
		        obj.value = obj.value.substring(0,maxlength);
		    }
		}
		
</script>
</html>

