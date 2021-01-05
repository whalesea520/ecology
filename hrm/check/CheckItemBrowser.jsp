<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script type="text/javascript">
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</HEAD>
<%
String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
String checkitemname = Util.null2String(request.getParameter("checkitemname"));

String sqlwhere = " ";
int ishead = 0;
if(!sqlwhere1.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += sqlwhere1;
	}
}

if(!checkitemname.equals("")){
	if(ishead==0){
		ishead = 1;
		sqlwhere += " where checkitemname = '" + checkitemname + "' ";
	}
	else{
		sqlwhere += " and checkitemname = '" + checkitemname + "' ";
	}
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="AwardTypeBrowser.jsp" method=post>
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere1)%>">
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 onclick="btncancel_onclick()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:document.SearchForm.btnclear.click(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<table width=100% class=Viewform>

</table>
<TABLE ID=BrowseTable class="BroswerStyle"  cellspacing="1" STYLE="margin-top:0;width:100%;">
<TR class=DataHeader>
<TH width=0% style="display:none"></TH>
<TH width=40%><%=SystemEnv.getHtmlLabelName(6117,user.getLanguage())%></TH>
<TH width=60%><%=SystemEnv.getHtmlLabelName(15752,user.getLanguage())%></TH>
</tr><TR class=Line><TH colspan="4" ></TH></TR>
<%
int i=0;
sqlwhere = "select * from HrmCheckItem  " + sqlwhere;
rs.execute(sqlwhere);

while(rs.next()){
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
	<TD width=0% style="display:none"><A HREF=#><%=rs.getString("id")%></A></TD>
	<TD><%=Util.toScreen(rs.getString("checkitemname"),user.getLanguage())%></TD>
   
    <TD><%=Util.toScreen(rs.getString("checkitemexplain"),user.getLanguage())%></TD>
</TR>
<%}%>
</TABLE>
</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
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
		var returnjson = {id:jQuery(curTr.cells[0]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
		if(dialog){
			dialog.callback(returnjson);
		}else{
			window.parent.parent.returnValue = returnjson;
			window.parent.parent.close();
		}
	}
}


function btnclear_onclick(){
	if(dialog){
  	var returnjson = {id:"", name:""};
   	dialog.callback(returnjson);
  }else{
    window.parent.returnValue = {id:"", name:""};
    window.parent.close();
	}
}

function btncancel_onclick(){
	if(dialog){
		dialog.close();
	}else{
    window.parent.close();
  }
}

$(function(){
	$("#BrowseTable").mouseover(BrowseTable_onmouseover);
	$("#BrowseTable").mouseout(BrowseTable_onmouseout);
	$("#BrowseTable").click(BrowseTable_onclick);
	$("#btnclear").click(btnclear_onclick);
});
</script>