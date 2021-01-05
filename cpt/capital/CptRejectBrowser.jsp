<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.ArrayList" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="cptReject" class="weaver.cpt.capital.CptReject" scope="page" />


<HTML><HEAD> 
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>

<%
String currUserId = ""+user.getUID();
String userType = user.getLogintype();
String name = Util.null2String(request.getParameter("name"));
String mark = Util.null2String(request.getParameter("mark"));

ArrayList browserData = cptReject.getRejectData(new String[] {currUserId, userType, mark, name});
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

<FORM NAME=SearchForm STYLE="margin-bottom:0" action="CptRejectBrowser.jsp" method=post>

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

		<table width=100% class=ViewForm>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
		<TD width=35% class=field><input name=mark value="<%=mark%>" class="InputStyle"></TD>
		<TD width=15%><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
		<TD width=35% class=field><input name=name value="<%=name%>" class="InputStyle"></TD>
		</TR>
		<TR style="height:1px;"><TD class=Line colSpan=4></TD></TR>
		</table>
		<BR>
		<TABLE ID=BrowseTable class=BroswerStyle cellspacing="1" style="width:100%;">
        <COLGROUP>
        <COL width="0%">
        <COL width="40%">
        <COL width="30%">
        <COL width="30%">
        </COLGROUP>
        <TR class="DataHeader">
          <TH style=""></TH>
          <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
          <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TH>
          <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TH>
        </TR>
        <TR class="Line"><TH colspan="4"></TH></TR>

		<%
		boolean isLight = true;
		String m_id = "";
        String m_no = "";
        String m_name = "";
        String m_count = "";
        String[] data;
		for (int i = 0; i < browserData.size(); i++) {
            data = (String[]) browserData.get(i);

            m_id = data[0];
            m_no = data[1];
            m_name = data[2];
            m_count = data[3];

            if (m_count.indexOf(".") != -1)
                m_count = m_count.substring(0, m_count.lastIndexOf("."));

			isLight = !isLight;
		%>
		<TR class="<%=(isLight ? "DataLight" : "DataDark")%>">		
			<TD style="display:none"><A HREF="#"><%=m_id%></A></TD>
			
			<TD colSpan="2"><%=m_name%></TD>
			<TD><%=m_no%></TD>
			<TD><%=m_count%></TD>
		</TR>
		<%}%>
		</TABLE>

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

</FORM>
</BODY></HTML>

<SCRIPT type="text/javascript">
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
		window.parent.parent.returnValue = {id:jQuery(curTr.cells[0]).text(),name:(jQuery(curTr.cells[1]).text())};
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
});
</SCRIPT>
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