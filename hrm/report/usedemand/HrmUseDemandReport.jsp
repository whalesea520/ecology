<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="GraphFile" class="weaver.file.GraphFile" scope="session"/>
<jsp:useBean id="UseDemandManager" class="weaver.hrm.report.UseDemandManager" scope="session"/>
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
String year = Util.null2String(request.getParameter("year"));
if(year.equals("")){
Calendar todaycal = Calendar.getInstance ();
year = Util.add0(todaycal.get(Calendar.YEAR), 4);
}

String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16060,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16063,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";

float resultpercent=0;
int total = 0;
int linecolor=0;


int content=Util.getIntValue(request.getParameter("content"),1);

String sqlwhere = "";
String sql = "";
sql= "select demandnum from HrmUseDemand  where 4 = 4 "+sqlwhere;
rs.executeSql(sql);
while(rs.next()){
total += rs.getInt(1);
}
String title = "";
if(content==1){title = SystemEnv.getHtmlLabelName(124,user.getLanguage());}
if(content==2){title = SystemEnv.getHtmlLabelName(6086,user.getLanguage());}
if(content==3){title = SystemEnv.getHtmlLabelName(6152,user.getLanguage());}
if(content==4){title = SystemEnv.getHtmlLabelName(818,user.getLanguage());}
%>
<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(352,user.getLanguage())+",javascript:submitData(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(15729,user.getLanguage())+",javascript:submitData(),_self} " ;
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
<form name=frmmain method=post action="HrmUseDemandReport.jsp">
<wea:layout type="4col" >
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(15933,user.getLanguage())%></wea:item>
    <wea:item>
      <INPUT class=inputStyle maxLength=4 size=4 name="year"    onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("year")' value="<%=year%>">
    </wea:item>  
    <wea:item><%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%></wea:item>
    <wea:item>
       <select class=inputstyle name="content" value="<%=content%>" onchange="dosubmit()">                
         <option value=1 <%if(content == 1){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> </option>
         <option value=2 <%if(content == 2){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> </option>
         <option value=3 <%if(content == 3){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(6152,user.getLanguage())%> </option>
         <option value=4 <%if(content == 4){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(818,user.getLanguage())%> </option>
       </select>
    </wea:item>    
</wea:group>
</wea:layout>
<table class=ListStyle cellspacing=1 style="display: none" >
<colgroup>
<tbody>
  <TR class=Header >
    <TH colspan=13><%=SystemEnv.getHtmlLabelName(15861,user.getLanguage())%>: <%=total%></TH>
  </TR>
  <tr class=header>    
    <td><%=title%></td>
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
  <TR class=Line><TD colspan="13" ></TD></TR> 
  <%
   int line = 0;
   ExcelFile.init ();
   String filename = SystemEnv.getHtmlLabelName(16064,user.getLanguage()) + title + SystemEnv.getHtmlLabelName(15101,user.getLanguage()) ;        
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
   er.addStringValue(title,"Header"); 
   for(int i = 1;i<13;i++){
     er.addStringValue(Util.toScreen(i+SystemEnv.getHtmlLabelName(33452,user.getLanguage()),user.getLanguage(),"0"),"Header"); 
   }
   
   
   int totalnum = 0;
   if(total!=0){
     Hashtable ht = new Hashtable();
     Hashtable show = new Hashtable();     
     ht = UseDemandManager.getResultByContent(content,sqlwhere);
     show = UseDemandManager.getShow();
     Enumeration keys = ht.keys();
     while(keys.hasMoreElements()){        
	String resultid = (String)keys.nextElement();
	int  resultcount = Util.getIntValue((String)ht.get(resultid));
	String name = Util.toScreen((String)show.get(resultid),user.getLanguage());
	ExcelRow ers = et.newExcelRow() ;
	ers.addStringValue(name);
	ArrayList al = new ArrayList();
	al =  UseDemandManager.getMonResultByContent(content,year,resultid);
   %>
  <TR <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%>>      
    <TD><%=name%></TD>
<%        for(int i=0;i<al.size();i++){
           ers.addStringValue((String)al.get(i));
     		
%>     
    <TD><%=al.get(i)%></TD>    
<%}%>    
    </TR>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}      	
    	}	
	%>  
</table>
</form>
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
					tableString+="		<col width=\""+(i==0?"20%":"10%")+"\" text=\""+er.getValue(i).replace("s_","")+"\" column=\""+i+"\" />";
			  }
				tableString+="	</head></table>";
			%>
						<input type="hidden" _showCol="false" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_RpUseDemand %>"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		</wea:item>
	</wea:group>
</wea:layout>
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
  function dosubmit(){
    document.frmmain.submit();
  }
  function submitData() {
 frmmain.submit();
}
</script>
</body>
  <SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
