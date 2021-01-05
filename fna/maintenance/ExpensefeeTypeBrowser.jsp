<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String userid=user.getUID()+"";
String feename=Util.null2String(request.getParameter("feename"));
String feeremark=Util.null2String(request.getParameter("feeremark"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!feename.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%" + Util.fromScreen2(feename,user.getLanguage()) +"%' ";
	}
	else 
		sqlwhere += " and name like '%" + Util.fromScreen2(feename,user.getLanguage()) +"%' ";
}
if(!feeremark.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where remark like '%" + Util.fromScreen2(feeremark,user.getLanguage()) +"%' ";
	}
	else
		sqlwhere += " and remark like '%" + Util.fromScreen2(feeremark,user.getLanguage()) +"%' ";
}

String sqlstr = "select * from FnaExpensefeeType" + sqlwhere ;
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
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
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="ExpensefeeTypeBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",document.SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear ><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class= Spacing style="height:1px;"><TD class=line1 colspan=4></TD></TR>
<TR>
<TD width=20%><%=SystemEnv.getHtmlLabelName(1455,user.getLanguage())%></TD>
<TD width=30% class=field><input class=inputstyle name=feename value="<%=feename%>"></TD>
<TD width=20%><%=SystemEnv.getHtmlLabelName(1456,user.getLanguage())%></TD>
<TD width=30% class=field><input class=inputstyle name=feeremark value="<%=feeremark%>"></TD>
</TR>
<TR class= Spacing style="height:1px;"><TD class=line1 colspan=4></TD></TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      
      <TH width=30%><%=SystemEnv.getHtmlLabelName(1457,user.getLanguage())%></TH>      
      <TH width=0% style="display:none">feerules</TH>      
      <TH width=70%><%=SystemEnv.getHtmlLabelName(1458,user.getLanguage())%></TH>
      </tr ><TR class=Line ><TH colspan="4" style="padding:0;"></TH></TR> 
      
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String feenames = Util.toScreen(RecordSet.getString("name"),user.getLanguage());
	String feeremarks = Util.toScreen(RecordSet.getString("remark"),user.getLanguage());
	
	String feerules="";
	
	String sql="select * from fnaexpensefeerules where feeid ="+ ids +" and resourceid in (-1,"+userid+" ) order by resourceid desc";
	rs.executeSql(sql);
	if(rs.next()){
	    feerules=rs.getString("standardfee");
	}
	if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
	<TD style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=feenames%></TD>
	<TD style="display:none"><%=feerules%></A></TD>
	<td><%=feeremarks%></td>
</TR>
<%}
%>

</TABLE>
  <input class=inputstyle type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
</FORM>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
<script	language="javascript">
function replaceToHtml(str){
	var re = str;
	var re1 = "<";
	var re2 = ">";
	do{
		re = re.replace(re1,"&lt;");
		re = re.replace(re2,"&gt;");
        re = re.replace(",","，");
	}while(re.indexOf("<")!=-1 || re.indexOf(">")!=-1)
	return re;
}

function BrowseTable_onmouseover(e){
	e=e||event;
   var target=e.srcElement||e.target;
   if("TD"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }else if("A"==target.nodeName){
		jQuery(target).parents("tr")[0].className = "Selected";
   }
}
function BrowseTable_onmouseout(e){
	var e=e||event;
   var target=e.srcElement||e.target;
   var p;
	if(target.nodeName == "TD" || target.nodeName == "A" ){
      p=jQuery(target).parents("tr")[0];
      if( p.rowIndex % 2 ==0){
         p.className = "DataDark"
      }else{
         p.className = "DataLight"
      }
   }
}

function BrowseTable_onclick(e){
	var e=e||event;
	var target=e.srcElement||e.target;
	if( target.nodeName =="TD"||target.nodeName =="A"  ){
		var curTr=jQuery(target).parents("tr")[0];
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		window.parent.parent.close();
	}
}

function btnclear_onclick(){
	window.parent.returnValue = {id:"",name:""};
	window.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>
