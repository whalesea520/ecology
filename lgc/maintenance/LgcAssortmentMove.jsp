<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<% if(!HrmUserVarify.checkUserRight("LgcAssortmentMove:Move",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AssetTypeComInfo" class="weaver.lgc.maintenance.AssetTypeComInfo" scope="page"/>
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page"/>
<%

String assortmentid1=Util.null2String(request.getParameter("assortmentid1"));
String assortmentid2=Util.null2String(request.getParameter("assortmentid2"));
int countid = Util.getIntValue(request.getParameter("countid"),-1);  
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdLOG_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(78,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(716,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
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
<%
if(countid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getHtmlNoteName(40,user.getLanguage())%> : <%=countid%>
</font>
</DIV>
<%}%>

<FORM id=frmmain name=frmmain action="LgcToolsOperation.jsp" method=post onsubmit="return check_form(this,'assortmentid1,assortmentid2')">
<input type="hidden" name="operation" value="assortmentmove">

<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(78,user.getLanguage())+",javascript:frmmain.myfun1.click(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnMove accessKey=M id=myfun1  type=submit><U>M</U>-<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(556,user.getLanguage())+",javascript:CheckAll(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=S onClick="CheckAll()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location='../LgcMaintenance.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=Btn accessKey=2 onclick='location="../LgcMaintenance.jsp"'><U>2</U>-取消</BUTTON> 
</DIV>
    <table class=ViewForm>
    	<colgroup>
	<COL width="49%">
	<COL width=10>
	<COL width="49%">
	<TBODY>
	<TR>
	<td>
	    <table class=ViewForm>
          <tbody> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(331,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <tr> 
            <td width="20%">种类</td>
            <td width="80%" class=field><button class=Browser id=SelectAssortment onClick="onShowAssortmentID1()"></button> 
        <span class=InputStyle id=assortmentidspan1>
		<% if(assortmentid1.equals("")) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle>
		<%} else {%><%=Util.toScreen(AssetAssortmentComInfo.getAssortmentMark(assortmentid1),user.getLanguage())%>-<%=Util.toScreen(AssetAssortmentComInfo.getAssortmentName(assortmentid1),user.getLanguage())%><%}%>
		</span> 
        <input id=assortmentid1 type=hidden name=assortmentid1 value="<%=assortmentid1%>"> </td>
          </TR><tr><td class=Line colspan=2></td></tr>
        </table>
	</td>
	<td>
	</td>
	
	<td>
	    <table class=ViewForm>
          <tbody> 
          <TR class=Title> 
            <TH colSpan=2><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%></TH>
          </TR>
          <TR class=Spacing> 
            <TD class=Line1 colSpan=2></TD>
          </TR>
          <tr> 
            <td width="20%">种类</td>
            <td width="80%" class=field>
			<button class=Browser id=SelectAssortment onClick="onShowAssortmentID2()"></button> 
        <span class=InputStyle id=assortmentidspan2>
		<% if(assortmentid2.equals("")) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle>
		<%} else {%><%=Util.toScreen(AssetAssortmentComInfo.getAssortmentMark(assortmentid2),user.getLanguage())%>-<%=Util.toScreen(AssetAssortmentComInfo.getAssortmentName(assortmentid2),user.getLanguage())%><%}%>
		</span> 
        <input id=assortmentid2 type=hidden name=assortmentid2 value="<%=assortmentid2%>">
			 </td>
          </TR><tr><td class=Line colspan=2></td></tr>
        </table>
	</td>
	
	</tr>
	
	<tr>
	<td colspan=3>
	<table class=ListStyle cellspacing=1>
	  <COLGROUP>
  	  <COL width="10%">
  	  <COL width="20%">
  	  <COL width="30%">
  	  <COL width="20%">
  	  <COL width="15%">
  	  <tbody>
  	  <TR class=header>
            <TH colSpan=6>资产</TH>
          </TR>
          <TR class=Header>
    	  <TD><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD>
		  <TD>标识</TD>
    	  <TD><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TD>
		  <TD>类型</TD>
    	  <TD><%=SystemEnv.getHtmlLabelName(120,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></TD>
    	  </TR>
<TR class=Line><TD colSpan=6></TD></TR>
    	  
<%
    	  RecordSet.executeProc("LgcAsset_SelectByAssortment",assortmentid1);
    	  int i=0;
    	  while(RecordSet.next()){
    	  	if(i==0){
  			i=1;
  		%>  
  	  <TR class=datalight>
  		<%
  		}else{
  			i=0;
  		%>
  	  <TR class=datadark>
  		<%  }
  		String ids=Util.null2String(RecordSet.getString("id"));
  		String assetmarks=Util.toScreen(RecordSet.getString("assetmark"),user.getLanguage());
		String assetnames=Util.toScreen(RecordSet.getString("assetname"),user.getLanguage());
		String assettypeids=Util.null2String(RecordSet.getString("assettypeid"));
		String seclevels=Util.null2String(RecordSet.getString("seclevel"));
  		%>
    	  <td><input type="checkbox" name="selectasset" value=<%=ids%>></td>
		  <td><a href="/lgc/asset/Asset.jsp?id=<%=ids%>"><%=assetmarks%></a></td>
    	  <td><%=assetnames%></td>
    	  <td><%=Util.toScreen(AssetTypeComInfo.getAssetTypename(assettypeids),user.getLanguage())%></td>
     	  <td><%=seclevels%></td>
    	  </tr>
    	  <%}%>
	</table>
	</td>
	</tr>
    </table>
</form>
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
<script language="vbs">
sub onShowAssortmentID1()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp ")
	if NOT isempty(id) then
	    if id(0)<> "" then
			if id(0) <> frmmain.assortmentid1.value then
				location.href="LgcAssortmentMove.jsp?assortmentid1="&id(0)&"&assortmentid2="&frmmain.assortmentid2.value
			end if
		else
			assortmentidspan1.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmmain.assortmentid1.value=""
		end if
	end if
end sub

sub onShowAssortmentID2()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssortmentBrowser.jsp ")
	if NOT isempty(id) then
	    if id(0)<> "" then
			assortmentidspan2.innerHtml = id(1)
			frmmain.assortmentid2.value=id(0)
		else
			assortmentidspan2.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			frmmain.assortmentid2.value=""
		end if
	end if
end sub
</script>
<script language="javascript">
function CheckAll() {
	len = document.frmmain.elements.length;
	for( i=0; i<len; i++) {
		if (document.frmmain.elements[i].name=='selectasset') {
			document.frmmain.elements[i].checked=true;
		} 
	} 
}
</script>
</body></html>