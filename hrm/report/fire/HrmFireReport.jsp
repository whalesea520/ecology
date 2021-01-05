<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#frmmain").submit();
}
var parentDialog = parent.parent.getDialog(parent);
var dialog = parent.parent.getDialog(parent);
dialog.checkDataChange = false
function excel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</head>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String year = Util.null2String(request.getParameter("year"));
String newsubcompanyid=Util.fromScreen(request.getParameter("newsubcompanyid"),user.getLanguage());

if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15972,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

String sqlwhere = "";
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
RCMenu += "{Excel,/weaver/weaver.file.ExcelOut,ExcelOut} " ;
RCMenuHeight += RCMenuHeightStep ;
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
			<input type=button class="e8_btn_top" onclick="excel();" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>"></input>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
<form id=frmmain name=frmmain method=post action="HrmFireReport.jsp">
<input name="isdialog" type="hidden" value="1">
		<wea:layout type="4col">
		  <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'> 
		    <wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
		    <wea:item>
		      <INPUT class=inputStyle maxLength=4 size=4 name="year" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
		    </wea:item> 
		    <wea:item><%=SystemEnv.getHtmlLabelName(19799 ,user.getLanguage())%></wea:item>
		    <wea:item>
		     <%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?excludeid="+newsubcompanyid +"&selectedids=";%>
		   	<brow:browser viewType="0" name="newsubcompanyid" browserValue='<%=newsubcompanyid %>' 
		      browserUrl='<%= browserUrl %>' hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
		      completeUrl="/data.jsp?type=164" width="250px"
		      browserSpanValue='<%=newsubcompanyid.length()>0?Util.toScreen(SubCompanyComInfo.getSubcompanynames(newsubcompanyid+""),user.getLanguage()):""%>'>
		   	</brow:browser>
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
<table class=ListStyle cellspacing=1 style="display: none" >
<tbody>
<tr class=header>
  <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1492,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1493,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1494,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1495,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1496,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1497,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1498,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1499,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1800,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1801,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1802,user.getLanguage())%></td>
  <td><%=SystemEnv.getHtmlLabelName(1803,user.getLanguage())%></td>
</tr>
<%
   int line = 0;
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(15973,user.getLanguage()) ;
   ExcelFile.setFilename(""+year+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+year+filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(8000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(124,user.getLanguage()) , "Header" ) ; 
   for(int month = 1;month<13;month++){   
   	   String title = ""+month+Util.toScreen(""+SystemEnv.getHtmlLabelName(33452,user.getLanguage()),user.getLanguage(),"0");
   	   er.addStringValue(""+title, "Header" ) ;
   }
   
   String sql = "select distinct(t2.departmentid) resultid from HrmStatusHistory t1,HrmResource t2 where t1.resourceid = t2.id and type_n = 1 ";
   if(newsubcompanyid.length()>0)sql+=" and t2.subcompanyid1 = "+newsubcompanyid;
   rs2.executeSql(sql);
   while(rs2.next()){   
     String resultid = ""+rs2.getString(1);
     ExcelRow erdep = et.newExcelRow() ;
     String depname = Util.toScreen(DepartmentComInfo.getDepartmentname(resultid),user.getLanguage());
     erdep.addStringValue(depname);
     if(line%2==0){
     line++;
%>
<tr class=datalight>
<%}else{%><tr class=datadark><%line++;}%>
  <td><%=depname%></td>
<%     
     for(int month = 1;month<13;month++){   
	   String firstday = ""+year+"-"+Util.add0(month,2)+"-01";
	   String lastday = ""+year+"-"+Util.add0(month,2)+"-31";
	   sqlwhere =" and (changedate >='"+firstday +"' and changedate <= '"+lastday+"')";
	   
	   sql = "select count(t1.id) resultcount from HrmStatusHistory t1,HrmResource t2 where type_n = 1 and t1.resourceid = t2.id and t2.departmentid = "+resultid+sqlwhere;
	   //out.println(sql+"<br>");		     	   
	   rs.executeSql(sql);
	   rs.next();	   
	   String resultcount = ""+rs.getInt(1);
	   erdep.addStringValue(resultcount);
%>
  <td><%=resultcount%></td>
<%	   	   	   
   } 
%>
</tr>
<%    
 } 
%>
</tbody>
</table>
<%
	sql = "select distinct(t2.departmentid) resultid from HrmStatusHistory t1,HrmResource t2 where t1.resourceid = t2.id and type_n = 1 ";
  if(newsubcompanyid.length()>0)sql+=" and t2.subcompanyid1 = "+newsubcompanyid;
  String sql1 = "select count(t1.id) resultcount from HrmStatusHistory t1,HrmResource t2 where type_n = 1 and t1.resourceid = t2.id and t2.departmentid = ";
  
String tableString=""+
"<table instanceid=\"BrowseTable\" pageId=\""+PageIdConst.HRM_Select+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Select,user.getUID(),PageIdConst.HRM)+"\"  datasource=\"weaver.hrm.HrmDataSource.getHrmChangeStatusList\" sourceparams=\"type:HrmFireReport+year:"+year+"+sqlstr:"+Util.toHtmlForSplitPage(sql)+"+sqlstr1:"+Util.toHtmlForSplitPage(sql1)+"\" tabletype=\"none\">"+
"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"depname\"  sqlprimarykey=\"depname\" sqlsortway=\"desc\"  />"+
"<head>";
	tableString+=	 "<col width=\"16%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"depname\" orderkey=\"depname\"/>";
	tableString+=	 "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1492,user.getLanguage())+"\" column=\"1\" orderkey=\"1\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1493,user.getLanguage())+"\" column=\"2\" orderkey=\"2\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1494,user.getLanguage())+"\" column=\"3\" orderkey=\"3\"/>";
	tableString+=	 "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1495,user.getLanguage())+"\" column=\"4\" orderkey=\"4\"/>";
	tableString+=	 "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1496,user.getLanguage())+"\" column=\"5\" orderkey=\"5\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1497,user.getLanguage())+"\" column=\"6\" orderkey=\"6\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1498,user.getLanguage())+"\" column=\"7\" orderkey=\"7\"/>";
	tableString+=	 "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1499,user.getLanguage())+"\" column=\"8\" orderkey=\"8\"/>";
	tableString+=	 "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1800,user.getLanguage())+"\" column=\"9\" orderkey=\"9\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1801,user.getLanguage())+"\" column=\"10\" orderkey=\"10\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1802,user.getLanguage())+"\" column=\"11\" orderkey=\"11\"/>";
	tableString+=  "<col width=\"7%\"  text=\""+SystemEnv.getHtmlLabelName(1803,user.getLanguage())+"\" column=\"12\" orderkey=\"12\"/>"+
"</head>"+
"</table>";      
%>
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.HRM_Select %>"/>
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
<%if("1".equals(isDialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
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
</body>
<iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
</html>
