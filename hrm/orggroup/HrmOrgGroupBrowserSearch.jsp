
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2014-11-13 [E7 to E8] -->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(24002,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<link REL="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
	</HEAD>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			BaseBean baseBean_self = new BaseBean();
			int userightmenu_self = 1;
			try{
				userightmenu_self = Util.getIntValue(baseBean_self.getPropValue("systemmenu", "userightmenu"), 1);
			}catch(Exception e){}	
			RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.btnsearch.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset.click(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="HrmOrgGroupBrowserSelect.jsp" method=post target="frame2">
			<BUTTON class=btnSearch accessKey=S style="display:none" type="button" onclick="btnsearch_onclick()"  id="btnsearch" ><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
			<BUTTON class=btnReset accessKey=T style="display:none" id=reset type="reset"><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
			<BUTTON class=btn accessKey=O style="display:none" id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%></BUTTON>
			<BUTTON class=btnReset accessKey=T style="display:none" id=btncancel onclick="btncancel_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
			<BUTTON class=btn accessKey=2 style="display:none" id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
			<input type="hidden" name="isinit" value="1"/>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(24679,user.getLanguage())%></wea:item>
					<wea:item> 
					  <input class="inputstyle" name="orgGroupName" value="">
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(24680,user.getLanguage())%></wea:item>
					<wea:item> 
					  <input class="inputstyle" name="orgGroupDesc" value="">
					</wea:item>
				</wea:group>
			</wea:layout>
			<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(sqlwhere)%>'>
			<input type="hidden" name="resourceids" >
		</FORM>
		<script language="javascript">
			var resourceids =""
			var resourcenames = ""
			function reset_onclick(){
				document.all("orgGroupName").value="";
				document.all("orgGroupDesc").value="";
			}
			function btnclear_onclick(){
				window.parent.parent.returnValue = {id:"",name:""};
				window.parent.parent.close();
			}

			function btnok_onclick(){
				setResourceStr();
				replaceStr();
				window.parent.parent.returnValue = {id:resourceids,name:resourcenames};
				window.parent.parent.close();
			}
			function btncancel_onclick(){
				 window.close();
			}

			var resourceids="";
			function btnsearch_onclick(){
				setResourceStr() ;
				$("input[name=resourceids]").val(jQuery(parent.document).find("#frame2").contents().find("#systemIds").val());
				$("#SearchForm").submit();
			}

			function setResourceStr(){
				
				var resourceids1 =""
					var resourcenames1 = ""
				 try{   
				for(var i=0;i<parent.frame2.resourceArray.length;i++){
					resourceids1 += ","+parent.frame2.resourceArray[i].split("~")[0] ;
					
					resourcenames1 += ","+parent.frame2.resourceArray[i].split("~")[1] ;
				}
				resourceids=resourceids1
				resourcenames=resourcenames1
				 }catch(err){}
			}

			function replaceStr(){
				var re=new RegExp("[ ]*[|][^|]*[|]","g")
				resourcenames=resourcenames.replace(re,"|")
				re=new RegExp("[|][^,]*","g")
				resourcenames=resourcenames.replace(re,"")
			} 
		</script>
	</BODY>
</HTML>
