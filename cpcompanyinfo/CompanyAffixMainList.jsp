
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<link href="/cpcompanyinfo/style/Operations_wev8.css" rel="stylesheet" type="text/css" />
<link href="/cpcompanyinfo/style/Public_wev8.css" rel="stylesheet" type="text/css" />
<link href="/cpcompanyinfo/style/Business_wev8.css" rel="stylesheet" type="text/css" />
<link href="/newportal/style/Contacts_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String companyid = Util.null2String(request.getParameter("companyid"));
String userId = String.valueOf(user.getUID()); //当前用户Id
String moudel = Util.null2String(request.getParameter("moudel"));

List list1 = new ArrayList();
String taball = "";
int tabid = 0;
int taballsize = 0;
String tabname = "";
String fg="@_____@";
String sql1="select  t1.id,t1.searchname,t1.LASTUPDATETIME from  CPCOMPANYAFFIXSEARCH t1   where t1.isdel='T' and t1.companyid= "+companyid+" and t1.userid="+userId+" and t1.whichmoudel='"+moudel+"' order by t1.LASTUPDATETIME desc  ";
//System.out.println("sql =============="+sql1);
	rs.execute(sql1);
	while(rs.next()){
		
		tabid = rs.getInt("id");
		tabname = rs.getString("searchname");
		taball = tabid+fg+tabname;
		list1.add(taball);
	}
	taballsize = list1.size();
	//System.out.println(taballsize);
 %>

<div style="padding-left: 10px">
<input type=hidden id="hideCheckvalue"> 
	<table width="98%" border="0" align="center" cellpadding="0"  id="tableId" cellspacing="0" class="MT5">
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>0) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(0)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(0)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(0)).split(fg)[1]%>"><%=String.valueOf(list1.get(0)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>1) {%>
				<input type="checkbox"  onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(1)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(1)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(1)).split(fg)[1]%>"><%=String.valueOf(list1.get(1)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>2) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(2)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(2)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(2)).split(fg)[1]%>"><%=String.valueOf(list1.get(2)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>3) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(3)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(3)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(3)).split(fg)[1]%>"><%=String.valueOf(list1.get(3)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>4) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(4)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(4)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(4)).split(fg)[1]%>"><%=String.valueOf(list1.get(4)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>5) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(5)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(5)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(5)).split(fg)[1]%>"><%=String.valueOf(list1.get(5)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>6) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(6)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(6)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(6)).split(fg)[1]%>"><%=String.valueOf(list1.get(6)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>7) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(7)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(7)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(7)).split(fg)[1]%>"><%=String.valueOf(list1.get(7)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>8) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(8)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(8)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(8)).split(fg)[1]%>"><%=String.valueOf(list1.get(8)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>9) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(9)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(9)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(9)).split(fg)[1]%>"><%=String.valueOf(list1.get(9)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>10) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(10)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(10)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(10)).split(fg)[1]%>"><%=String.valueOf(list1.get(10)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>11) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(11)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(11)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(11)).split(fg)[1]%>"><%=String.valueOf(list1.get(11)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>12) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(12)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(12)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(12)).split(fg)[1]%>"><%=String.valueOf(list1.get(12)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>13) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(13)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(13)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(13)).split(fg)[1]%>"><%=String.valueOf(list1.get(13)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>14) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(14)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(14)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(14)).split(fg)[1]%>"><%=String.valueOf(list1.get(14)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>15) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(15)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(15)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(15)).split(fg)[1]%>"><%=String.valueOf(list1.get(15)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>16) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(16)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(16)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(16)).split(fg)[1]%>"><%=String.valueOf(list1.get(16)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>17) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(17)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(17)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(17)).split(fg)[1]%>"><%=String.valueOf(list1.get(17)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
		<tr>
			<td width="33%" height="29">
				<%if(taballsize>18) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(18)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(18)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(18)).split(fg)[1]%>"><%=String.valueOf(list1.get(18)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>19) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(19)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(19)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(19)).split(fg)[1]%>"><%=String.valueOf(list1.get(19)).split(fg)[1]%></a>
				<%} %>
			</td>
			<td width="33%">
				<%if(taballsize>20) {%>
				<input type="checkbox" onclick="getdbValue();" dbvalue="<%=String.valueOf(list1.get(20)).split(fg)[0]%>"/>
				<a href="javascript:f2(<%=String.valueOf(list1.get(20)).split(fg)[0]%>);" title="<%=String.valueOf(list1.get(20)).split(fg)[1]%>"><%=String.valueOf(list1.get(20)).split(fg)[1]%></a>
				<%} %>
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">

	/*刷新自身页面*/
	function reloadListContent(){
		window.location.reload();
	}
	/*获得搜索策略 ID*/
	function getrequestids(){
		var requestids = jQuery("#hideCheckvalue").val();
		return requestids;
	}
	function getdbValue(){
		var checkvalues="";
		//$("input[type=checkbox][checked=true]").each(function(){
		$("#tableId input:checked").each(function(){
			checkvalues += $(this).attr("dbvalue")+",";
		});
		jQuery("#hideCheckvalue").val(checkvalues);
	}
	function f2(o4this){
		window.parent.f1("affix2SEdit","edit",o4this);
	}
</script>