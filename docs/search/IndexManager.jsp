
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="com.weaver.ecology.search.util.CommonUtils"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%com.weaver.ecology.search.web.IndexManagerBean.languageId.set(user.getLanguage());%>
<jsp:useBean id="indexMng" class="com.weaver.ecology.search.web.IndexManagerBean"/>
<jsp:setProperty name="indexMng" property="pageContext" value="<%=pageContext%>"/>
<jsp:setProperty name="indexMng" property="action" param="action"/>
<jsp:setProperty name="indexMng" property="indexDbName" param="indexDbName"/>
<jsp:setProperty name="indexMng" property="area" param="area"/>
<jsp:setProperty name="indexMng" property="date1" param="date1"/>
<jsp:setProperty name="indexMng" property="date2" param="date2"/>
<jsp:setProperty name="indexMng" property="init" value="true"/>


<%  if(!HrmUserVarify.checkUserRight("searchIndex:manager",user)) {
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }
%>

<html><head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="../../js/weaver_wev8.js"></script>
    
    <style type="text/css">
    	body{font-size:10pt;}
    </style>

	<script language="javascript">
	function $(id){return (typeof(id)=='string')?document.getElementById(id):id;}
	
	function chDbName(obj){
		//$('indexDbName').value=obj.options(obj.selectedIndex).value;
	}

	function getArea(){
		var radios=document.getElementsByName("area");
		var obj=null;
		for(var i=0;i<radios.length;i++){
			obj=radios[i];
			if(obj.checked)	break;
		}
		return obj;
	}
	function ViewVisibility(o,blView){
		$(o).style.display=$(o.id+"Line").style.display=(blView)?"":"none";
	}
	function areaClicks(obj){
		var btn2=$("date2Btn");
		var obj=$(obj);
		var date2=$("date2Span");

		if(obj.value=="1"){
			btn2.disabled=false;
			ViewVisibility(date2,true);
		}else if(obj.value=="2"){
			btn2.disabled=true;
			ViewVisibility(date2,false);
		}else if(obj.value=="3"){
			btn2.disabled=true;
			ViewVisibility(date2,false);
		}
	}
	
	function deleteIndexDb(){
	//删除索引库

		if($G('indexDbName').value==""){
		  alert("<%=SystemEnv.getHtmlLabelName(26026,user.getLanguage())%>");/*索引库名称不能为空*/
		  $G('indexDbName').focus();
		  return;
		}
		if(confirm("<%=SystemEnv.getHtmlLabelName(26027,user.getLanguage())%>")){/*确认删除该索引库吗?*/
			$G("action").value="deleteIndex";
			jQuery("#frm1").submit();
		}
	}
	
	function chkForm(){
		var date1=$G("date1").value;
		var date2=$G("date2").value;
		var btn=getArea();
		
		if(btn.value=="1"){
			if(date1=="" || date2==""){/*请选择起始日期和结束日期*/
				alert('<%=SystemEnv.getHtmlLabelName(20465,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20466,user.getLanguage())%>');
				return false;
			}
		}else if(btn.value=="2"||btn.value=="3"){
			if(date1==""){
				alert('<%=SystemEnv.getHtmlLabelName(20465,user.getLanguage())%>');/*请选择起始日期*/
				return false;
			}
		}
		jQuery("#frm1").submit();
	}
	</script>
</head>
<%
String name = SystemEnv.getHtmlLabelName(19653,user.getLanguage());//搜索索引库管理及相关配置
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18446,user.getLanguage())+":"+name;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
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
<table class=Shadow>
<tr>
<td valign="top">

<form action="#" name="frm1" method="post" id="frm1">
<input type="hidden" name="action" id="action" value="createIndex"/>
<table class="ViewForm" cellspacing="4">
<colgroup> 
<col width="15%" /> 
<col width="85%" />
</colgroup>
				<tbody>
				<tr class="Title">
				  <th colspan="2" align="left"><!--手动创建索引设置--><%=SystemEnv.getHtmlLabelName(20468,user.getLanguage())%></th>
				</tr><tr class=Spacing style="height: 1px;"><td class="Line1" colSpan="2"></td></tr>
				<tr>
				  <td ><!--库名称--><%=SystemEnv.getHtmlLabelName(20475,user.getLanguage())%></td>
				  <td class="Field">
				  <select id="existDbname" name="indexDbName" onChange="/*chDbName(this);*/">
					<c:forEach var="db" items="${existIndexDb}">
					<option value='<c:out value="${db}"/>'><c:out value="${db}"/></option>
					</c:forEach>
					</select>
				  <!--input id="indexDbName" class="InputStyle" readonly="readonly" name="indexDbName" size="10" value='' /-->				
				  &nbsp;&nbsp;
					<button type='button' accesskey="D" class="btnDelete" onClick="deleteIndexDb();" name="btnDetl1"><!--删除--><u>D</u>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>				  </td>
				</tr>
				<tr style="height: 1px;"><td class=Line colSpan=2></td></tr>
                <tr>
				  <td valign="top"><!--数据源范围--><%=SystemEnv.getHtmlLabelName(20469,user.getLanguage())%></td>
				  <td class="Field">
<label for="area1"><input type="radio" id="area1" name="area" onClick="areaClicks('area1');" value="1"/><%=SystemEnv.getHtmlLabelName(20479,user.getLanguage())%></label>
<br/>
<label for="area2"><input name="area" id="area2" type="radio" onClick="areaClicks('area2');" value="2" checked="checked" /><%=SystemEnv.getHtmlLabelName(20478,user.getLanguage())%></label>
<br/>
<label for="area3"><input type="radio" id="area3" name="area" onClick="areaClicks('area3');" value="3"/><%=SystemEnv.getHtmlLabelName(20480,user.getLanguage())%></label>
<br>
</td>
				</tr>
				<tr style="height: 1px;"><td class=Line colSpan=2></td></tr>
				<tr><td><!--起始日期--><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></td><td  class="Field">
					<button type='button' id="date1Btn" class="calendar" onClick="showCalendar('startDate','date1')">&nbsp;</button>
					<input type="hidden" name="date1" value=""><span id="startDate"></span>
				</td></tr>
				<tr style="height: 1px;"><td class=Line colSpan=2></td></tr>
				<tr id="date2Span" style="display:none;"><td><!--最后日期--><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td><td class="Field"><button type='button' disabled="disabled" id="date2Btn" class="calendar" onClick="showCalendar('endDate','date2')">&nbsp;</button>
					<input type="hidden" name="date2" value=""><span id="endDate"></span>
					</td></tr>
				<tr id="date2SpanLine" style="display:none;height: 1px;" ><td class=Line colSpan=2></td></tr>
				<tr><td >&nbsp;</td><td class="Field"><button class="btn" type="button" onclick="chkForm()" name="btn1" accesskey="C"><u>C</u>-<%=SystemEnv.getHtmlLabelName(20472,user.getLanguage())%></button>
				<div id="info"><c:out value="${info}"  escapeXml="false"/></div>
				</td></tr>
				</tbody>
	  </table>
</form>
<!--搜索系统属性-->
<!--
			  <br />
<table class="ViewForm" cellspacing="4">
<colgroup> 
<col width="25%" /> 
<col width="75%" />
</colgroup>
				<tbody>
				<tr class="Title">
				  <th colspan="2" align="left"><%=CommonUtils.getLabelById(20473)%></th>
				</tr>
				<tr class=Spacing><td class="Line1" colSpan="2"></td></tr>
				<c:forEach var="cfg" items="${cfgInfo}">
				<tr><td><c:out value="${cfgNotes[cfg.key]}"/></td>
				  <td class="Field"><input readonly="readonly" name='<c:out value="${cfg.key}"/>' type="text" class="InputStyle" value='<c:out value="${cfg.value}"/>' size="50"/>
				    (<c:out value="${cfg.key}"/>)</td></tr><tr><td class=Line colSpan=2></td></tr>
				</c:forEach>
				</tbody>
		    </table>
-->

</td>
</tr>
</table>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
