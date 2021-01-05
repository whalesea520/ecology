<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rss" class="weaver.conn.RecordSet" scope="page" />
<% if(!HrmUserVarify.checkUserRight("CheckScheme:Performance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<HTML><HEAD>
<STYLE>.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}
</STYLE>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<%
String contentId=Util.null2String(request.getParameter("id"));
String type=Util.null2String(request.getParameter("type"));
String cycle=Util.null2String(request.getParameter("cycle"));
String mainid=Util.null2String(request.getParameter("mainid"));
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+": "+ SystemEnv.getHtmlLabelName(18064,user.getLanguage());
String titlenamet="";
if (type.equals("0")) {
titlenamet="-"+SystemEnv.getHtmlLabelName(18060,user.getLanguage());
}
if (type.equals("1")) {
titlenamet="-"+SystemEnv.getHtmlLabelName(18061,user.getLanguage());
}
if (type.equals("2")) {
titlenamet="-"+SystemEnv.getHtmlLabelName(18062,user.getLanguage());
}
titlename+=titlenamet;
String needfav ="1";
String needhelp ="";
//用来判断自定义考核项的指数和不大于100%,(目标考核非月度考核也要判断)
if (rss.getDBType().equals("oracle"))
rss.execute("select sum(percent_n) from HrmPerformanceSchemeDetail where contentId="+contentId);
else if (rss.getDBType().equals("db2"))
rss.execute("select sum(double(percent_n)) from HrmPerformanceSchemeDetail where contentId="+contentId);
else
rss.execute("select sum(convert(float,percent_n)) from HrmPerformanceSchemeDetail where contentId="+contentId);
float sum=0;


if (rss.next())
{
  sum=Util.getFloatValue(rss.getString(1));
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:OnSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",CheckSchemeEdit.jsp?id="+mainid+"&cycle="+cycle+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;

%>	

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<FORM name=resource id=resource action="CheckSchemeOperation.jsp" method=post>
<input type=hidden name=inserttype value=detail>
<input type=hidden name=contentId value=<%=contentId%>>
<input type=hidden name=mainid value=<%=mainid%>>
<input type=hidden name=type value=<%=type%>>
<input type=hidden name=cycle value=<%=cycle%>>
<input type=hidden name=sum value=<%=sum%>>
   <TABLE class=ViewForm>
    <COLGROUP> 
    <COL width="15%"> 
    <COL width="85%"> 
    <TBODY> 
  
    <TR> 
      <TD vAlign=top> 
        <TABLE width="100%">
          <COLGROUP> <COL width=15%> <COL width=85%> <TBODY> 
          <TR class=title> 
            <TH colSpan=2 ><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
          </TR>
          <TR class=spacing> 
            <TD class=line1 colSpan=2></TD>
          </TR>
           <%if (type.equals("0")) {%>
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18064 ,user.getLanguage())%></TD>
            <TD class=Field>
             <select class=inputstyle name="item" id="item">
             <%if (!cycle.equals("3")) {%><option value="0" selected><%=SystemEnv.getHtmlLabelName(18170 ,user.getLanguage())%></option>
             <%}%>
             <%if (!cycle.equals("2")) {%><option value="1" ><%=SystemEnv.getHtmlLabelName(18137 ,user.getLanguage())%></option>
             <%}%>
             </select>
            </TD>
          </TR>
           <%}%>
             <%if (type.equals("1")) {%>
              <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18048 ,user.getLanguage())%></TD>
            <TD class=Field> 
           <BUTTON type="button" class=Browser id=SelectCheckID onClick="onShowCheck()"></BUTTON> 
              <span 
            id=checkidspan><img src="/images/BacoError.gif" 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=checkItem 
            type=hidden name=checkItem>
            </TD>
          </TR>
             <%}%>
             <%if (type.equals("2")) {%>
               <!-- TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18062 ,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(857 ,user.getLanguage())%></TD>
            <TD class=Field> 
            <BUTTON class=Browser id=SelectDocID onClick="onShowDoc()"></BUTTON> 
              <span 
            id=docidspan><img src="/images/BacoError.gif" 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=docItem 
            type=hidden name=docItem>
            </TD>
          </TR-->
             <%}%>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(6071 ,user.getLanguage())%></TD>
            <TD class=Field> 
              <input class=inputstyle  maxLength=4 size=4 
            name="percent_n"  onchange='checknumber("percent_n");checkinput("percent_n","nameimage")' >%
            <SPAN id=nameimage>
			<IMG src='/images/BacoError.gif' align=absMiddle>
			</SPAN> 
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          <TR> 
            <TD><%=SystemEnv.getHtmlLabelName(18067,user.getLanguage())%></TD>
            <TD class=Field> 
              <BUTTON type="button" class=Browser id=SelectFlowID onClick="onShowFlowID()"></BUTTON> 
              <span 
            id=flowidspan><img src='/images/BacoError.gif' 
            align=absMiddle></span> 
              <INPUT class=inputStyle id=checkFlow 
            type=hidden name=checkFlow>
           
            </TD>
          </TR>
        <TR><TD class=Line colSpan=2></TD></TR> 
          </TBODY> 
        </TABLE>
      </TD>
</tr>
</TABLE>
</FORM>
</td>
<td></td>
</tr>

<tr>
<td height="10" colspan="3"></td>
</tr>
</table>


<SCRIPT language="javascript">
function OnSubmit(){
    if(check_form(document.resource,"percent_n,checkFlow"))
    
	{	if (<%=type%>=="2")
	     {
	     if (parseFloat(document.resource.percent_n.value)!=100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18062,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(18179,user.getLanguage())%>");
	     return;
	     }
	     }
	     if ((<%=type%>=="0")&&(<%=cycle%>=="2"))
	     {
	     if (parseFloat(document.resource.percent_n.value)!=100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18136,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(18179,user.getLanguage())%>");
	     return;
	     }
	     }
	     if ((<%=type%>=="1"))
	     {
	     if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18061,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return;
	     }
	     }
	     if ((<%=type%>=="0"&&<%=cycle%>!="2"))
	     {
	     if ((parseFloat(document.resource.percent_n.value)+parseFloat(document.resource.sum.value))>100) 
	     {
	     alert("<%=SystemEnv.getHtmlLabelName(18060,user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelName(15223,user.getLanguage())%>"+100);
	     return;
	     }
	     }
		document.resource.submit();
		enablemenu();
	}
}

function onShowCheck(){ 
    result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/maintenance/diyCheck/CheckBrowser.jsp")
	if (result){
	if (result.id != ""){
		checkidspan.innerHTML =result.name;
		resource.checkItem.value=result.id;
	}else{
		checkidspan.innerHTML = "<img src='/images/BacoError.gif' align=absMiddle>";
		resource.checkItem.value="";
	}
	}
}

 
function onShowFlowID() {
    result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/FlowBrowser.jsp")
	if(result){
		if(result[0]!=''){
			flowidspan.innerHTML = result[1];
			resource.checkFlow.value=result[0];
		}else{
			flowidspan.innerHTML = "<img src='/images/BacoError.gif' align=absMiddle>"
			resource.checkFlow.value=""
		}
	}
}

function onShowDoc() {
     result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if(result){
		if(result.id!=''){
			flowidspan.innerHTML = result.name;
			resource.checkFlow.value=result.id
		}else{
			flowidspan.innerHTML = "<img src='/images/BacoError.gif' align=absMiddle>"
			resource.checkFlow.value=""
		}
	}
}
</SCRIPT>

</BODY>
</HTML>