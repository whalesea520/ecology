
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfoHandler" %>
<%@ page import="weaver.systeminfo.menuconfig.MainMenuInfo" %>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


int defaultLevel = Util.getIntValue(request.getParameter("defaultLevel"),0);
String parentId = Util.null2String(request.getParameter("defaultParentId"));
int defaultParentId = Util.getIntValue(parentId,0);

String sqlWhere = "";
String searchMenuName ="";

searchMenuName = Util.null2String(request.getParameter("searchMenuName"));

if(!searchMenuName.equalsIgnoreCase("")){
        sqlWhere+=" and t3.labelName like '%" + searchMenuName + "%' ";
}
if(!parentId.equalsIgnoreCase("")&&!parentId.equalsIgnoreCase("0")){
    sqlWhere+=" and defaultParentId =" + defaultParentId + " ";
}

MainMenuInfoHandler mainMenuInfoHandler = new MainMenuInfoHandler();
ArrayList sysLevelMainMenuInfos = mainMenuInfoHandler.getPreLevelMainMenuInfos(0,0,"");

ArrayList preLevelMainMenuInfos = mainMenuInfoHandler.getPreLevelMainMenuInfos(defaultLevel,defaultParentId,sqlWhere);

RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

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


<FORM NAME=SearchForm STYLE="margin-bottom:0" action="PreLevelMainMenuBrowser.jsp" method=post>
<DIV align=right style="display:none">
<BUTTON class=btn accessKey=1 onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=2 id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
<TABLE>

    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
      <TD width=35% class=field><input class=inputstyle name=searchMenuName value="<%=searchMenuName%>"></TD>
<%          if(defaultLevel!=0){                    %>

      <TD width=15%><%=SystemEnv.getHtmlLabelName(84225,user.getLanguage())%></TD>
      <TD width=40% class=field>
        <select class=inputstyle id=systemLevelId name=systemLevelId >
		<option value="0"></option>
		<% for(int i=0;i<sysLevelMainMenuInfos.size();i++) {  
			 MainMenuInfo sysInfo = (MainMenuInfo)sysLevelMainMenuInfos.get(i);
             int tempSysInfoId = sysInfo.getId();
		%>
          <option value=<%=tempSysInfoId%> >
		  <%=sysInfo.getOriginalName(user.getLanguage())%></option>
		<% } %>
        </select>
      </TD>

<%          }else{                                       %>
      <TD width=15%></TD>
      <TD width=40%></TD>
<%          }                                            %>
    </TR>
    <TR><TD class=Line colSpan=6></TD></TR> 

</TABLE>
<TABLE ID=BrowseTable class=BroswerStyle width="100%"   cellspacing=1>
<TR class=DataHeader>
<TH><%=SystemEnv.getHtmlLabelName(84042,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
<TH><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>

<%
for(int i=0;i<preLevelMainMenuInfos.size();i++){
    MainMenuInfo info = (MainMenuInfo)preLevelMainMenuInfos.get(i);
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
	<TD width=50%><%=SystemEnv.getHtmlLabelName(info.getLabelId(),user.getLanguage())%></TD>
	<TD width=50%><A HREF=#><%=info.getId()%></A></TD>
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
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[2]).text(),name:replaceToHtml(jQuery(curTr.cells[1]).text())};
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
</BODY>
</HTML>