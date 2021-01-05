
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SapUtil" class="com.weaver.integration.util.IntegratedUtil" scope="page"/>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>


<html>
	<head>
		<title><%=SystemEnv.getHtmlLabelName(26968 ,user.getLanguage())%></title>
	</head>
	<%
		String isNew=Util.null2String(request.getParameter("isNew"));
		String id=Util.null2String(request.getParameter("id"));
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(1421 ,user.getLanguage())+SystemEnv.getHtmlLabelName(30694 ,user.getLanguage());
		String opera="save";
		String dataname="";
		String datadesc="";
		String Sysbuilt="";
		if("1".equals(isNew))
		{
			titlename = SystemEnv.getHtmlLabelName(103 ,user.getLanguage())+SystemEnv.getHtmlLabelName(30694 ,user.getLanguage());
			opera="update";
			//查出默认值
			RecordSet.execute("select * from int_dataInter where id='"+id+"'");
			if(RecordSet.next())
			{
				 dataname=RecordSet.getString("dataname");
				 datadesc=RecordSet.getString("datadesc");
				 Sysbuilt=RecordSet.getString("Sysbuilt");
			}
		}
		Sysbuilt = "1";
		String needhelp ="";
		
	%>
	<body>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
			/**
			RCMenu += "{确定,javascript:doSubmit(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			*/
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290 ,user.getLanguage())+",javascript:doGoBack(this),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			/**
			if("1".equals(isNew)&&SapUtil.getHaveHeteProducts(id))
			{
				RCMenu += "{删除,javascript:doDelete(this,"+id+"),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			**/
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			
			<form action="/integration/dataInterOperation.jsp" method="post" name="dataInterNew" id="dataInterNew">
			
				<input type="hidden" name="opera" value="<%=opera%>">
				<input type="hidden" name="sid" value="<%=id%>">
			
			<!-- 最外层表格-start-->
				<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
				<tr>
				<td height="10" colspan="3"></td>
				</tr>
				<tr>
				<td ></td>
				<td valign="top">
						<TABLE class="Shadow">
						<tr>
						<td valign="top">
								<table class=ViewForm>
								<colgroup>
								<col width="25%">
								<col width="75%">
								<tbody>
								<TR class=Spacing  style="height:1px;">
								  <TD colspan=2 class=line1></TD>
								</TR>
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30694 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(22009 ,user.getLanguage()) %></td>
								    <td class=field>
								    	<%
								    		if("1".equals(Sysbuilt))
								    		{
								    			out.println(dataname);
								    		}else
								    		{
								    	%>
								    		<input type="text" name="dataname" id="dataname" onchange='checkinput("dataname","datanamespan")' value="<%=dataname%>">
											<span id=datanamespan>
												<%if(!"1".equals(isNew)){%><img src="/images/BacoError_wev8.gif" align=absMiddle><%}%>
											</span>
								    	<%
								    		}
								    	 %>
										
									</td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
								<tr>    
								<tr>    
								    <td width=10%><%=SystemEnv.getHtmlLabelName(30694 ,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(433 ,user.getLanguage()) %></td>
								    <td class=field >
								    	<!--  
								    	<textarea rows="5" cols="150" name="datadesc" ></textarea>
								    	-->
								    	<%=datadesc%>
								    </td>
								</tr>
								<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR> 
								</tbody>
								</table>
						</td>
						</tr>
						</TABLE>
				</td>
				<td></td>
				</tr>
				<tr>
				<td height="10" colspan="3"></td>
				</tr>
				</table>
			<!--最外层表格-end  -->
			</form>
</body>
<script type="text/javascript">
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
				alert("<%=SystemEnv.getHtmlLabelName(30622 ,user.getLanguage()) %>"+"!");
				return;
			}
			$("#dataInterNew").submit();
		}
		function doGoBack()
		{
			window.location.href="/integration/dataInterlist.jsp";
		}
		function doDelete(obj,id)
		{
			if(window.confirm("<%=SystemEnv.getHtmlLabelName(30695 ,user.getLanguage()) %>"+"!"))
			{
				window.location.href="/integration/dataInterOperation.jsp?opera=delete&sid="+id;
			}
		}
</script>
</html>

