<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String flag	= Util.null2String(request.getParameter("flag"));
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}
if(!flag.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where flag = '";
		sqlwhere += Util.null2String(flag);
		sqlwhere += "'";
	}
	else{
		sqlwhere += " and flag = '";
		sqlwhere += Util.null2String(flag);
		sqlwhere += "'";
	}
}
if(!name.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and name like '%";
		sqlwhere += Util.fromScreen2(name,user.getLanguage());
		sqlwhere += "%'";
	}
}
if(!description.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
	else{
		sqlwhere += " and description like '%";
		sqlwhere += Util.fromScreen2(description,user.getLanguage());
		sqlwhere += "%'";
	}
}
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="RewardsTypeBrowser.jsp" method=post>
<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
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
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=ViewForm>
<TR class=spacing><TD class=line1 colspan=6></TD></TR>
<TR>
<TD width=10%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TD>
<TD width=10%>
<select width=10% class=inputstyle id=flag name=flag>
                <option value="0" <% if (flag.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%></option>
                <option value="1" <% if (flag.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%></option>
				<option value="2" <% if (flag.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
</select>
</TD>
<TD width=10%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
<TD width=25% class=field><input class=inputstyle name=name value="<%=name%>"></TD>
<TD width=10%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
<TD width=25% class=field><input class=inputstyle name=description value="<%=description%>"></TD>
</TR>
</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=20%><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></TH>
<TH width=20%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH width=60%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmRewardsType "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
String flagdis = RecordSet.getString("flag");
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
	<TD style="display:none"><%=RecordSet.getString(1)%></TD>
	<TD>
		<% if (flagdis.equals("0")) {%><%=SystemEnv.getHtmlLabelName(809,user.getLanguage())%><%}%>
		<% if (flagdis.equals("1")) {%><%=SystemEnv.getHtmlLabelName(810,user.getLanguage())%><%}%>
		<% if (flagdis.equals("2")) {%><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%><%}%>
	</TD>
	<TD><%=RecordSet.getString("name")%></TD>
	<TD><%=RecordSet.getString("description")%></TD>
	
</TR>
<%}%>
</TABLE></FORM>
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
	window.parent.parent.returnValue = {id:"",name:""};
	window.parent.parent.close();
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>