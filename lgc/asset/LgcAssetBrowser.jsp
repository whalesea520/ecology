
<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AssetAssortmentComInfo" class="weaver.lgc.maintenance.AssetAssortmentComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css"></HEAD>
<%
String assetmark = Util.null2String(request.getParameter("assetmark"));
String assetname = Util.null2String(request.getParameter("assetname"));
String assortmentid = Util.null2String(request.getParameter("assortmentid"));
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
if(!assetmark.equals("")){
		sqlwhere += " and LgcAsset.assetmark = '" + Util.fromScreen2(assetmark,user.getLanguage()) +"' ";
}
if(!assetname.equals("")){
		sqlwhere += " and LgcAssetCountry.assetname like '%" + Util.fromScreen2(assetname,user.getLanguage()) +"%' ";
}
if(!assortmentid.equals("")){
		sqlwhere += " and  LgcAsset.assortmentstr like '%"+ assortmentid + "|%' ";
}
String sqlstr = "select LgcAsset.id,assetmark,assetname,assetproductid,assetdm "+
			    "from LgcAsset,LgcAssetCountry where LgcAsset.id=LgcAssetCountry.assetid and LgcAssetCountry.isdefault='1' " + sqlwhere ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="LgcAssetBrowser.jsp" method=post>
<DIV align=right style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.SearchForm.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnSearch accessKey=S id=myfun1  type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnReset accessKey=T id=myfun2  type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.parent.close(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=1 id=myfun3  onclick="window.parent.close()"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btn accessKey=2 id=btnclear onclick="submitClear()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
</DIV>
  <table width=100% class=ViewForm>
    <TR class=Spacing style="height: 1px"> 
      <TD class=Line1 colspan=4></TD>
    </TR>
    <TR> 
      <TD width=12%><%=SystemEnv.getHtmlLabelName(16813,user.getLanguage())%></TD>
      <TD width=38% class=field> 
        <input class=InputStyle  name=assetmark value="<%=assetmark%>">
      </TD>
      <TD width=12%><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></TD>
      <TD width=38% class=field> 
        <input class=InputStyle  name=assetname value="<%=assetname%>">
      </TD>
    </TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>
    <TR> 
      <TD width=12%><%=SystemEnv.getHtmlLabelName(716,user.getLanguage())%></TD>
      <TD width=38% class=field> 
        <select class=InputStyle  id=assortmentid name=assortmentid>
          <option value=""></option>
          <% while(AssetAssortmentComInfo.next()) {  
			String tmpassortmentid= AssetAssortmentComInfo.getAssortmentId() ;
		%>
          <option value=<%=tmpassortmentid%> <% if(tmpassortmentid.equals(assortmentid)) {%>selected<%}%>> 
          <%=Util.toScreen(AssetAssortmentComInfo.getAssortmentName(),user.getLanguage())%></option>
          <% } %>
        </select>
      </TD>
      <TD width=12%>&nbsp;</TD>
      <TD width=38% class=field>&nbsp;</TD>
    </TR><tr style="height: 1px"><td class=Line colspan=4></td></tr>

  </table>
<TABLE ID=BrowseTable class=BroswerStyle cellspacing=1 width="100%">
<TR class=DataHeader>
      <TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></TH>      	 
       <TH width=0% style="display:none"></TH>
	   <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></TH><!--产品名称-->
	   <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17130,user.getLanguage())%></TH><!--产品编码-->
	  <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(17038,user.getLanguage())%></TH><!--产品代码-->	  
	  <TH style="TEXT-ALIGN: center"><%=SystemEnv.getHtmlLabelName(16814,user.getLanguage())%></TH><!--生产编号-->	  
	   </TR>
	  
<TR class=Line style="height: 1px"><TH colSpan=4></TH></TR>
<%
int i=0;
//out.print(sqlstr);
RecordSet.executeSql(sqlstr);
while(RecordSet.next()){
	String ids = RecordSet.getString("id");
	String assetmarkdisp = Util.toScreen(RecordSet.getString("assetmark"),user.getLanguage());
	String assetnamedisp= Util.toScreen(RecordSet.getString("assetname"),user.getLanguage());
	String assetproductid= Util.toScreen(RecordSet.getString("assetproductid"),user.getLanguage());
	String assetdm= Util.toScreen(RecordSet.getString("assetdm"),user.getLanguage());

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
	<TD><%=assetnamedisp%></TD>
	<TD><%=assetmarkdisp%></TD>
	<TD><%=assetdm%></TD>	
	<TD><%=assetproductid%></TD>	
</TR>
<%}
%>

</TABLE>
  <input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
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
<script type="text/javascript">

jQuery(document).ready(function(){
	//alert(jQuery("#BrowseTable").find("tr").length)
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
			
		window.parent.returnValue = {id:$(this).find("td:first").text(),name:$(this).find("td:first").next().text()};
			window.parent.close()
		})
	jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
			$(this).addClass("Selected")
		})
		jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
			$(this).removeClass("Selected")
		})

})


function submitClear()
{
	window.parent.returnValue = {id:"",name:""};
	window.parent.close()
}

</script>
</BODY></HTML>