
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:SearchForm.btnclear.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<BODY>
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


<FORM NAME=SearchForm STYLE="margin-bottom:0">
<DIV align=right style="display:none">
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<TABLE ID=browseTable class=BroswerStyle onclick="browseTable_onclick()" onmouseover="browseTable_onmouseover()" onmouseout="browseTable_onmouseout()"   cellspacing=1>
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(84042,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>
<%

MainMenuInfoHandler mainMenuInfoHandler = new MainMenuInfoHandler();
ArrayList sysLevelMainMenuInfos = mainMenuInfoHandler.getSysLevelMainMenuInfos();

for(int i=0;i<sysLevelMainMenuInfos.size();i++){
    MainMenuInfo info = (MainMenuInfo)sysLevelMainMenuInfos.get(i);
	if(i%2==0){
%>
<TR class=DataLight>
<%
	}else{
%>
<TR class=DataDark>
	<%
	}
	%>
    <TD><A HREF=#><%=info.getDefaultIndex()%></A></TD>
	<TD><%=info.getOriginalName(user.getLanguage())%></TD>
	<TD><A HREF=#><%=info.getId()%></A></TD>
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



<script language="javascript">

function btnclear_onclick(){
    var array = new Array(2);
    array[0] = "0";
    array[1] = "";
    window.parent.returnValue = array;

    //window.parent.returnValue = new Array{"0",""};
    window.parent.close();
}

function browseTable_onclick(){
    var array = new Array(2);
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        array[0] = e.parentElement.cells(0).innerText;
        array[1] = e.parentElement.cells(1).innerText;
    }
    else if(e.tagName == "A"){
        array[0] = e.parentElement.parentElement.cells(0).innerText;
        array[1] = e.parentElement.parentElement.cells(1).innerText;
    }
    window.parent.returnValue = array;
    window.parent.close();
}

function browseTable_onmouseover(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"){
        e.parentElement.className = "Selected";
    }
    else if(e.tagName == "A"){
        e.parentElement.parentElement.className = "Selected";
    }
}
function browseTable_onmouseout(){
    var e = window.event.srcElement;
    if(e.tagName == "TD"||e.tagName == "A"){
        var p;
        if(e.tagName == "TD"){
            p = e.parentElement;
        }
        else{
            p = e.parentElement.parentElement;
        }
        if(p.rowIndex%2==0){
            p.className = "DataLight";
        }
        else{
            p.className = "DataDark";
        }
    }
}

</script>

</BODY>
</HTML>