<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%
String typekind = Util.null2String(request.getParameter("typekind"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String sqlwhere1 = sqlwhere ;
int ishead = 0;
if(!sqlwhere.equals("")) ishead = 1;
if(!typekind.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where typekind = '" + typekind + "' " ;
	}
	else 
		sqlwhere += " and typekind = '" + typekind + "' " ;
}

String sqlstr = "select id,typename,typekind,typedesc "+
			    "from LgcAssetRelationType " + sqlwhere ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcAssetRelationTypeBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
  <table width=100% class=ViewForm>
    <TR class=Spacing style="height:1px;"> 
      <TD class=Line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=15%>类型</TD>
      <TD width=35% class=field>
        <select class=InputStyle id=State name=typekind>
		  <option value=""></option>
          <option value="1" <%if(typekind.equals("1")) {%> selected <%}%>>强制</option>
          <option value="2" <%if(typekind.equals("2")) {%> selected <%}%>>必选其一</option>
          <option value="3" <%if(typekind.equals("3")) {%> selected <%}%>>可选</option>
          <option value="4" <%if(typekind.equals("4")) {%> selected <%}%>>可选其一</option>
          <option value="5" <%if(typekind.equals("5")) {%> selected <%}%>>排除</option>
        </select>
      </TD>
      <TD width=15%>&nbsp;</TD>
      <TD width=35%>&nbsp; </TD>
    </TR>
<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
  </table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 style="width:100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"></TH>      
      <TH width=20%>名称</TH>
      <TH width=15%>类型</TH>
	  <TH width=65%>说明</TH></tr><TR class=Line><TH colSpan=4></TH></TR>
<%
int i=0;
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String typenames = Util.toScreen(RecordSet.getString("typename"),user.getLanguage());
	String typekinds = Util.toScreen(RecordSet.getString("typekind"),user.getLanguage());
	String typedescs = Util.toScreen(RecordSet.getString("typedesc"),user.getLanguage());
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
	<TD width=0% style="display:none"><A HREF=#><%=ids%></A></TD>
	<TD><%=typenames%></TD>
	<TD>
	<% if(typekind.equals("1")) {%>强制
	<%}else if(typekind.equals("2")) {%>必选其一
	<%}else if(typekind.equals("3")) {%>可选
	<%}else if(typekind.equals("4")) {%>可选其一
	<%}else if(typekind.equals("5")) {%>排除 <%}%>
	</TD>
	  <TD><%=typedescs%></TD>
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value="<%=xssUtil.put(sqlwhere1)%>">
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