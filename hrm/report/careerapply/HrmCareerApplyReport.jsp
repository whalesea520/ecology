<%@ page import="weaver.general.Util,weaver.file.*" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<jsp:useBean id="RpCareerApplyManager" class="weaver.hrm.report.RpCareerApplyManager" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
var dialog = parent.parent.getDialog(parent);
dialog.checkDataChange = false
function excel(){
	window.location.href="/weaver/weaver.file.ExcelOut";
}
</script>
</head>
<%
String isDialog = Util.null2String(request.getParameter("isdialog"));
int year = Util.getIntValue(request.getParameter("year"),0);
if(year==0){
Calendar todaycal = Calendar.getInstance ();
year = todaycal.get(Calendar.YEAR);
}


String month = Util.null2String(request.getParameter("month"));
if(month.equals("")){
Calendar todaycal = Calendar.getInstance ();
month = Util.add0(todaycal.get(Calendar.MONTH)+1, 2);
}

String userid =""+user.getUID();
int space=Util.getIntValue(request.getParameter("space"));
int col=Util.getIntValue(request.getParameter("col"),1);
if(col == 3){
  space=Util.getIntValue(request.getParameter("space"),10000);  
}
if(col == 4){
  space=Util.getIntValue(request.getParameter("space"),1);
}
int row=Util.getIntValue(request.getParameter("row"),1);

String fromdateselect = Util.null2String(request.getParameter("fromdateselect"));
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
if(!fromdateselect.equals("") && !fromdateselect.equals("0")&& !fromdateselect.equals("6")){
	fromdate = TimeUtil.getDateByOption(fromdateselect,"0");
	enddate = TimeUtil.getDateByOption(fromdateselect,"1");
}

String sqlwhere = "";

if(fromdate.equals("")&&enddate.equals("")){
  fromdate = Util.add0(year,4)+"-01-01";
  enddate = Util.add0(year,4)+"-12-31";
}
if(row==1 || row == 2){
if(!fromdate.equals("")){
	sqlwhere+=" and t1.createdate>='"+fromdate+"'";
}
if(!enddate.equals("")){
  if(RecordSet.getDBType().equals("oracle")){
	sqlwhere+=" and (t1.createdate<='"+enddate+"' and t1.createdate is not null)";
  }else{
    sqlwhere+=" and (t1.createdate<='"+enddate+"' and t1.createdate is not null and t1.createdate <> '')";
  }
}
}
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(179,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApply.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",/hrm/report/careerapply/HrmRpCareerApplySearch.jsp,_self} " ;
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
			<input type=button class="e8_btn_top" onclick="submitData()" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		  <input type=button class="e8_btn_top" onclick="excel();" value="<%=SystemEnv.getHtmlLabelName(28343, user.getLanguage())%>"></input>
		  <span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<form name=frmmain action="HrmCareerApplyReport.jsp">
<wea:layout type="4col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15930,user.getLanguage())%></wea:item>
    <wea:item>
       <select class=inputStyle name="col" value="<%=col%>">                                    
         <option value=1 <%if(col == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15931,user.getLanguage())%> </option>
         <option value=2 <%if(col == 2){%> selected <%}%>> <%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%>     </option>                           
         <option value=3 <%if(col == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15673,user.getLanguage())%> </option>
         <option value=4 <%if(col == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(1844,user.getLanguage())%> </option>
       </select>
    </wea:item>
		<%if(col == 3|| col == 4){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15932,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=6 size=6 name="space"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("space")' value="<%=space%>">
    </wea:item>             
		<%}%> 
    <wea:item><%=SystemEnv.getHtmlLabelName(84764,user.getLanguage())%></wea:item>
    <wea:item>
       <select name="row" value="<%=row%>" onchange="onRefrash()">                                    
         <option value=1 <%if(row == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%></option>         
         <option value=2 <%if(row == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%> </option>         
         <option value=3 <%if(row == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(887,user.getLanguage())%> </option>         
       </select>
    </wea:item>   
	<%if(row == 3){%>
    <wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"  onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </wea:item>             
	<%}else{%>
	    <wea:item><%=SystemEnv.getHtmlLabelName(15934,user.getLanguage())%></wea:item>
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
	<%}%>    
	</wea:group>
</wea:layout>
<table border=1 width=100% style="display: none">
  <tr>
<td>
      <TABLE class=ListStyle cellspacing=1 >
        
        <TBODY> 
        <TR class=Header> 
          <TH colSpan=50><%=SystemEnv.getHtmlLabelName(15929,user.getLanguage())%></TH>
        </TR>
       
        <TR class=Header> 
<%
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(33535,user.getLanguage());
   ExcelFile.setFilename(""+filename) ;

   // 下面建立一个头部的样式, 我们系统中的表头都采用这个样式!
   ExcelStyle es = ExcelFile.newExcelStyle("Header") ;
   es.setGroundcolor(ExcelStyle.WeaverHeaderGroundcolor) ;
   es.setFontcolor(ExcelStyle.WeaverHeaderFontcolor) ;
   es.setFontbold(ExcelStyle.WeaverHeaderFontbold) ;
   es.setAlign(ExcelStyle.WeaverHeaderAlign) ;
   
   ExcelSheet et = ExcelFile.newExcelSheet(""+filename) ;
   
   ExcelRow er = null ;
   er = et.newExcelRow() ;
   String type = "";
   if(row == 1){ 
   	type=SystemEnv.getHtmlLabelName(15671,user.getLanguage());
   }
   if(row == 2){ 
   	type=SystemEnv.getHtmlLabelName(6132,user.getLanguage());
   }
   if(row == 3){ 
   	type=SystemEnv.getHtmlLabelName(887,user.getLanguage());
   }
   er.addStringValue(type,"Header");
%>
   <td>
     <%=type%>
   </td>   
<%   
Hashtable result = new Hashtable();
result = RpCareerApplyManager.getResultByColRow(col,row,sqlwhere,space,year,user);
Hashtable header = RpCareerApplyManager.getHeader();
Hashtable show = RpCareerApplyManager.getShow();

Enumeration skeys = show.keys();
while(skeys.hasMoreElements()){
  Integer index = (Integer)skeys.nextElement();
  String head = (String)show.get(index);
  er.addStringValue(head,"Header") ;
%>        
          <TD><%=head%></TD>
          
<%}%>          
        </TR>
        <TR class=Line><TD colspan="50" ></TD></TR> 
        <%
int needchange = 0;
Enumeration hkeys = header.keys();
while(hkeys.hasMoreElements()){
  Integer index = (Integer)hkeys.nextElement();
  ExcelRow erdep = et.newExcelRow() ; 
  String name = (String)header.get(index);
  erdep.addStringValue(name);
  
  Hashtable content = (Hashtable)result.get(index);
       	if(needchange ==0){
       		needchange = 1;
%>
        <TR class=datalight> 
          <%
  	}else{
  		needchange=0;
  %>
        <TR class=datadark> 
          <%  	}%>
          <td><%=Util.toScreen(name,7)%></td>
<%          
        Enumeration keys = content.keys();
        while(keys.hasMoreElements()){          
          Integer indexc = (Integer)keys.nextElement();          
          String num = (String)content.get(indexc);
          erdep.addStringValue(num);
  %>
          <TD><%=Util.toScreen(num,7)%></TD>                    
<%}%>          
        </TR>
<%   
}
%>        
        </TBODY> 
      </TABLE>
 </td>
 </tr>
  </table>
  <wea:layout type="diycol">
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
		<wea:item attributes="{'isTableList':'true','colspan':'full'}">
			<%
				request.getSession().setAttribute("et",et);
				String tableString =" <table datasource=\"weaver.hrm.HrmDataSource.getHrmCareerApplyReport\" sourceparams=\"\" pageId=\""+PageIdConst.Hrm_RpCareerApply+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_RpCareerApply,user.getUID(),PageIdConst.HRM)+"\" tabletype=\"none\">"+
					" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\"  sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
				"	<head>";
				er = et.getExcelRow(0);
		  	for(int i=0;er!=null&&i<er.size();i++){
					tableString+="		<col width=\"30%\" text=\""+er.getValue(i).replace("s_","")+"\" column=\""+i+"\" />";
			  }
				tableString+="	</head></table>";
			%>
						<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_RpUseDemand %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
 </FORM>
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
 <iframe id="ExcelOut" name="ExcelOut" border=0 frameborder=no noresize=NORESIZE height="0%" width="0%"></iframe>
<script language=javascript>
function onRefrash(){
  
	document.frmmain.submit();
  
}
function submitData() {
 frmmain.submit();
}
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
