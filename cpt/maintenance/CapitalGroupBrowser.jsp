<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = parent.parent.getParentWindow(parent);
	var dialog = parent.parent.getDialog(parent);
</script>
</HEAD>
<%
String fromcapital = Util.null2String(request.getParameter("fromcapital"));
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String name = Util.null2String(request.getParameter("name"));
String description = Util.null2String(request.getParameter("description"));
String sqlwhere = " ";
int ishead = 0;

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

if(fromcapital.equals("1")){
	if (ishead==0){
		ishead = 1;
		sqlwhere += " where id not in (select parentid from CptCapitalGroup) ";
	}
	else{
		sqlwhere += " and id not in (select parentid from CptCapitalGroup) ";
	}
}
else{
	if (ishead==0){
		ishead = 1;
		sqlwhere += " where parentid = 0 ";
	}
	else{
		sqlwhere += " and parentid = 0 ";
	}
}
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:onClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CapitalGroupBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<input type=hidden name=parentid>
<input type=hidden name=fromcapital value="<%=fromcapital%>">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("15774",user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></wea:item>
		<wea:item><input name=name value='<%=name%>' class="InputStyle"></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item>
		<wea:item><input name=description value='<%=description%>' class="InputStyle"></wea:item>
	</wea:group>
</wea:layout>

<TABLE ID=BrowseTable class="BroswerStyle" cellspacing="1" style="width:100%">
<TR class=DataHeader>
<TH style='display:none'></TH>
<TH width=49%><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TH>
<TH width=50%><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TH>
</TR>
<TR class=Line><TH colspan="3" ></TH></TR> 
<%
int i=0;
sqlwhere = "select * from CptCapitalGroup "+sqlwhere;
RecordSet.execute(sqlwhere);
while(RecordSet.next()){
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
	<TD style='display:none'><A HREF=# ><%=RecordSet.getString("id")%></A></TD>
	<TD><%=RecordSet.getString("name")%></TD>
	<TD><%=RecordSet.getString("description")%></TD>
</TR>
<%}%>
</TABLE>

 
 
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="btnclear_onclick();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>

</BODY>
</HTML>
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
		
		if(dialog){
			var returnjson =  {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
	    	dialog.callback(returnjson);
		}else{
			window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
			window.parent.parent.close();
		}
		
		
	}
}

function btnclear_onclick(){
	if(dialog){
		var returnjson =  {id:"",name:""};
    	dialog.callback(returnjson);
	}else{
		window.parent.returnValue = {id:"",name:""};
		window.parent.close();
	}
	
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
});
</script>
<script language="javascript">
function onClear()
{
	btnclear_onclick() ;
}
function onSubmit()
{
	SearchForm.submit();
}
function onClose()
{
	window.parent.close() ;
}
</script>
