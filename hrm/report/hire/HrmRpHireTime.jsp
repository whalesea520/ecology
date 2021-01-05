
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script> 
<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmReport_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
</script>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15984,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String sqlwhere = "";
String sql = "";
List<Integer> lsData = new ArrayList<Integer>();
for(int month = 1;month<13;month++){
  String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
  String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
  sqlwhere =" and (changedate >='"+firstday +"' and changedate <= '"+lastday+"')";
  sql = "select count(t1.id) resultcount from HrmStatusHistory t1, HrmResource t2 where type_n = 2 and t1.resourceid = t2.id "+sqlwhere;		     
  rs.executeSql(sql);
  rs.next();
  lsData.add(rs.getInt("resultcount"));
}
String items = "";  
for(int data : lsData){
if(items.length()>0)items+=",";
items +=data;
}
items = "["+items+"]";
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onBtnSearchClick(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<!-- 
		<input type=button class="e8_btn_top" onclick="onBtnSearchClick();" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		 -->
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=frmmain name=frmmain method=post action="HrmRpHireTime.jsp">
<input name="isdialog" type="hidden" value="1">
	<wea:layout type="4col">
	  <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'> 
			<wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
			<wea:item>
		  	<INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
			</wea:item> 
		</wea:group>
		<wea:group context="">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				</wea:item> 
		</wea:group>
	</wea:layout> 
</form>
</div>
<wea:layout type="table" attributes="{'cols':'13','csw':'12%,8%,8%,8%,8%,8%,8%,8%,8%,8%,8%,8%,8%,8%,8%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
		<%for(int month=0;month<12;month++){ %>
		<wea:item type="thead"><%=month+1%><%=SystemEnv.getHtmlLabelName(33452,user.getLanguage())%></wea:item>
		<%} %>
		<wea:item><%=year%></wea:item>
		<%for(int month=0;month<12;month++){ %>
		<wea:item><%=lsData.get(month)%></wea:item>
		<%} %>
	</wea:group>
</wea:layout>
<br><br>
<TABLE class=ViewForm>
  <TBODY> 
  <TR> 
    <TD align=center colspan =2>
		 <div id="container" style="min-width:390px;height:350px"></div>
    </TD>
    <TD align=center colspan =2>
     <div id="container1" style="min-width:390px;height:350px"></div>
    </TD>
  </TR>    
  </TBODY> 
</TABLE>
<%if("1".equals(isDialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
    	</wea:item>
   	</wea:group>
  </wea:layout>
</div>
<%} %>
<script language=javascript>  
jQuery(document).ready(function(){
	initChart('','<%=items%>');
	initChart1('','<%=items%>');
})
</script>
</body>
</html>
