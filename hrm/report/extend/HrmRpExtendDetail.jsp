<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
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

var dialog = parent.parent.getDialog(parent);
dialog.checkDataChange = false
function excel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</head>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15968,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;
String filename = SystemEnv.getHtmlLabelName(15969,user.getLanguage()) ;

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}

String fromtodateselect = Util.null2String(request.getParameter("fromtodateselect"));
String fromtodate=Util.fromScreen(request.getParameter("fromtodate"),user.getLanguage());
String endtodate=Util.fromScreen(request.getParameter("endtodate"),user.getLanguage());
if(!fromtodateselect.equals("") && !fromtodateselect.equals("0")&& !fromtodateselect.equals("6")){
	fromtodate = TimeUtil.getDateByOption(fromtodateselect,"0");
	endtodate = TimeUtil.getDateByOption(fromtodateselect,"1");
}

String olddepartment=Util.fromScreen(request.getParameter("olddepartment"),user.getLanguage());
String oldjobtitle=Util.fromScreen(request.getParameter("oldjobtitle"),user.getLanguage());

String sqlwhere = "";

if(!fromdate.equals("")){
	sqlwhere+=" and t1.changedate>='"+fromdate+"'";
	filename += fromdate;
}
if(!enddate.equals("")){
	sqlwhere+=" and (t1.changedate<='"+enddate+"')";
	filename += "--"+enddate;
}
if(!fromtodate.equals("")){
	sqlwhere+=" and t1.changeenddate>='"+fromtodate+"'";
}
if(!endtodate.equals("")){
  if(rs.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.changeenddate<='"+endtodate+"' and t1.changeenddate is not null)";
  }else{
    sqlwhere+=" and (t1.changeenddate<='"+endtodate+"' and t1.changeenddate is not null and t1.changeenddate <> '')";
  }
}
if(!oldjobtitle.equals("")){
	sqlwhere+=" and t1.oldjobtitleid ="+oldjobtitle+" ";
}

if(!olddepartment.equals("")){
	sqlwhere+=" and t2.departmentid = "+olddepartment+" ";
}

String sql = "";
//if(!olddepartment.equals("")){
  sql = "select count(t1.id) from HrmStatusHistory t1,HrmResource t2 where type_n = 3 and t1.resourceid = t2.id  "+sqlwhere;
//}else{
 // sql = "select count(t1.id) from HrmStatusHistory t1 where type_n = 3 "+sqlwhere;
//}
rs.executeSql(sql);
rs.next();
total = rs.getInt(1);

String sqlstr = "";
//if(!olddepartment.equals("")){
  sqlstr = "select t1.*, t2.departmentid as departmentid from HrmStatusHistory t1,HrmResource t2 where type_n = 3 and t1.resourceid = t2.id  "+sqlwhere+" order by changedate desc";
//}else{
 // sqlstr = "select t1.* from HrmStatusHistory t1 where type_n = 3 "+sqlwhere+" order by changedate desc";
//}
rs.executeSql(sqlstr);
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
<form id=frmmain name=frmmain method=post action="HrmRpExtendDetail.jsp">
	<input name="isdialog" type="hidden" value="1">
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'> 
	    <wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
	    <wea:item>
		  	<brow:browser viewType="0" name="olddepartment" browserValue='<%=olddepartment%>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/DepartmentBrowser.jsp?selectedids="
	      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1' 
	      browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(olddepartment),user.getLanguage())%>'
	      completeUrl="/data.jsp?type=4">
      	</brow:browser>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
	    <wea:item>
		    <brow:browser viewType="0" name="oldjobtitle" browserValue='<%=oldjobtitle%>' 
	      browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
	      hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
	      browserSpanValue='<%=Util.toScreen(JobTitlesComInfo.getJobTitlesname(oldjobtitle),user.getLanguage())%>'
	      completeUrl="/data.jsp?type=hrmjobtitles">
	      </brow:browser>
	    </wea:item>     
	    <wea:item><%=SystemEnv.getHtmlLabelName(15965,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<select name="fromdateselect" id="fromdateselect" onchange="changeDate(this,'spanFromdate');" style="width: 135px">
	    		<option value="0" <%=fromdateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value="1" <%=fromdateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
	    		<option value="2" <%=fromdateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
	    		<option value="3" <%=fromdateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
	    		<option value="4" <%=fromdateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
	    		<option value="5" <%=fromdateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
	    		<option value="6" <%=fromdateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    	 </select>
       <span id=spanFromdate style="<%=fromdateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON class=Calendar type="button" id=selectFromdate onclick="getDate(fromdatespan,fromdate)"></BUTTON>
       		<SPAN id=fromdatespan ><%=fromdate%></SPAN>－
       		<BUTTON class=Calendar type="button" id=selectEnddate onclick="getDate(enddatespan,enddate)"></BUTTON>
       		<SPAN id=enddatespan ><%=enddate%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="fromdate" name="fromdate" value="<%=fromdate%>">
       <input class=inputstyle type="hidden" id="enddate" name="enddate" value="<%=enddate%>">
	    </wea:item>   
	    <wea:item><%=SystemEnv.getHtmlLabelName(15966,user.getLanguage())%></wea:item>
	    <wea:item>
	     <select name="fromtodateselect" id="fromtodateselect" onchange="changeDate(this,'spanFromtodate');" style="width: 135px">
	    		<option value="0" <%=fromtodateselect.equals("0")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
	    		<option value="1" <%=fromtodateselect.equals("1")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option>
	    		<option value="2" <%=fromtodateselect.equals("2")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option>
	    		<option value="3" <%=fromtodateselect.equals("3")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option>
	    		<option value="4" <%=fromtodateselect.equals("4")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option>
	    		<option value="5" <%=fromtodateselect.equals("5")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option>
	    		<option value="6" <%=fromtodateselect.equals("6")?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option>
    	 </select>
       <span id=spanFromtodate style="<%=fromtodateselect.equals("6")?"":"display:none;" %>">
      		<BUTTON class=Calendar type="button" id=selectFromtodate onclick="getDate(fromtodatespan,fromtodate)"></BUTTON>
       		<SPAN id=fromtodatespan ><%=fromtodate%></SPAN>－
       		<BUTTON class=Calendar type="button" id=selectEndtodate onclick="getDate(endtodatespan,endtodate)"></BUTTON>
       		<SPAN id=endtodatespan ><%=endtodate%></SPAN>
       </span>
       <input class=inputstyle type="hidden" id="fromtodate" name="fromtodate" value="<%=fromtodate%>">
       <input class=inputstyle type="hidden" id="endtodate" name="endtodate" value="<%=endtodate%>"> 
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
<table class=ListStyle cellspacing=1 style="display:none;">
<tbody>
  <tr class=header>
    <td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
    <td><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15970,user.getLanguage())%></td>    
    <td><%=SystemEnv.getHtmlLabelName(15971,user.getLanguage())%></td>    
  </tr>
  <%
   ExcelFile.init ();   
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(filename) ;

   // 下面设置每一列的宽度, 如果不设置, 将按照excel默认的宽度  
   et.addColumnwidth(4000) ;
   et.addColumnwidth(6000) ;   
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   et.addColumnwidth(4000) ;
   
   ExcelRow er = null ;

   er = et.newExcelRow() ;
   er.addStringValue( SystemEnv.getHtmlLabelName(1867,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(124,user.getLanguage()) , "Header" ) ;  
   er.addStringValue( SystemEnv.getHtmlLabelName(6086,user.getLanguage()) , "Header" ) ;     
   er.addStringValue( SystemEnv.getHtmlLabelName(15970,user.getLanguage()) , "Header" ) ;     
   er.addStringValue( SystemEnv.getHtmlLabelName(15971,user.getLanguage()) , "Header" ) ;     
     
   if(total!=0){
     while(rs.next()){
     String resourcename = Util.toScreen(ResourceComInfo.getResourcename(rs.getString("resourceid")),user.getLanguage());	
     String olddepartnemtname = Util.toScreen(DepartmentComInfo.getDepartmentname(rs.getString("departmentid")),user.getLanguage());
     String oldjobtitlename = Util.toScreen(JobTitlesComInfo.getJobTitlesname(rs.getString("oldjobtitleid")),user.getLanguage());     
     String changedate = Util.toScreen(rs.getString("changedate"),user.getLanguage());
     String changeenddate = Util.toScreen(rs.getString("changeenddate"),user.getLanguage());
     
     er = et.newExcelRow() ;
     er.addStringValue(resourcename) ;
     er.addStringValue(olddepartnemtname) ;
     er.addStringValue(oldjobtitlename) ;     
     er.addStringValue(changedate) ;    
     er.addStringValue(changeenddate) ;     
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>
    <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("resourceid")%>"> <%=resourcename%></a></TD>
    <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=rs.getString("departmentid")%>"> <%=olddepartnemtname%></a></TD>
    <TD><a href="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=<%=rs.getString("oldjobtitleid")%>"> <%=oldjobtitlename%></a></TD>    
    <TD><%=changedate%></TD>        
    <TD><%=changeenddate%></TD>        
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}
	} %>  
</table>
<%
	String tableString=""+
		"<table datasource=\"weaver.hrm.HrmDataSource.getHrmRpExtendDetailList\" sourceparams=\"sqlstr:"+Util.toHtmlForSplitPage(sqlstr)+"\" pageId=\""+PageIdConst.HRM_Select+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_Select,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"none\">"+
		"<sql backfields=\"*\"  sqlform=\"temp\" sqlorderby=\"changedate\"  sqlprimarykey=\"changedate\" sqlsortway=\"desc\"  />"+
		"<head>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(1867,user.getLanguage())+"\" column=\"resourcename\" orderkey=\"resourcename\" />"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"olddepartnemtname\" orderkey=\"olddepartnemtname\" />"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"oldjobtitlename\" orderkey=\"oldjobtitlename\" />"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(15970,user.getLanguage())+"\" column=\"changedate\" orderkey=\"changedate\" />"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15971,user.getLanguage())+"\" column=\"changeenddate\" orderkey=\"changeenddate\" />"+
		"</head>"+
		"</table>";
%> 
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/> 
<%if("1".equals(isDialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
