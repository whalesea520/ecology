<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<script language=javascript>
var rowindex=0;
var totalrows=0;
var totaldebit = 0 ;
var totalcredit = 0 ;
function addRow()
{	
	ncol = oTable.cols;
	oRow = oTable.insertRow();	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(); 
		switch(j) {

			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='itemvalue"+rowindex+"' size=30 maxlength='30'>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='itemdsp"+rowindex+"' size=30 maxlength='30'>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
}

</script>

<%
String sql = "" ;
int itemid = Util.getIntValue(request.getParameter("itemid"),0);
sql = "select * from T_fieldItem where itemid ="+itemid ;
rs.executeSql(sql);
rs.next() ;

String inprepid = Util.null2String(rs.getString("inprepid")) ;
String itemdspname = Util.toScreenToEdit(rs.getString("itemdspname"),user.getLanguage()) ;
String itemfieldname = Util.null2String(rs.getString("itemfieldname")) ;
String itemfieldtype = Util.null2String(rs.getString("itemfieldtype")) ;
String itemfieldscale = Util.null2String(rs.getString("itemfieldscale")) ;
String itemfieldunit = Util.null2String(rs.getString("itemfieldunit")) ;


if(itemfieldscale.equals("0")) itemfieldscale = "" ;


String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+"："+SystemEnv.getHtmlLabelName(15213,user.getLanguage())+ itemdspname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:location='InputReportItemAdd.jsp?inprepid="+inprepid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

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
<FORM id=weaver name=frmMain action="InputReportItemOperation.jsp" method=post >
	<input type="hidden" name=operation>
    <input type="hidden" name=inprepid value=<%=inprepid%>>
	<input type="hidden" name=itemid value=<%=itemid%>>
	<INPUT type=hidden name="olditemfieldname" value="<%=itemfieldname%>">
	<INPUT type=hidden name="olditemfieldtype" value="<%=itemfieldtype%>">
	<INPUT type=hidden name="olditemfieldscale" value="<%=itemfieldscale%>">
	<input type="hidden" name="totaldetail"> 
	

  <TABLE class=ViewForm>
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=Title> 
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15199,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing> 
      <TD class=Line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15207,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class=InputStyle size=50 name="itemdspname" onchange='checkinput("itemdspname","itemdspnameimage")' value="<%=itemdspname%>">
        <SPAN id=itemdspnameimage></span></TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></TD>
      <TD class=Field > 
        <select class=InputStyle  name="itemfieldtype" style="width:50%" onChange="showType()">
          <option value="1" <% if(itemfieldtype.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15201,user.getLanguage())%></option>
          <option value="6" <% if(itemfieldtype.equals("6")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15206,user.getLanguage())%></option>
          <option value="2" <% if(itemfieldtype.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15202,user.getLanguage())%></option>
          <option value="3" <% if(itemfieldtype.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15203,user.getLanguage())%></option>
          <option value="4" <% if(itemfieldtype.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15204,user.getLanguage())%></option>
           <option value="5" <% if(itemfieldtype.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15205,user.getLanguage())%></option>
        </select>
      </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    <%
	String dspstatus = "" ;
	String disabled = "" ;
	%>
    <TR id=itemfield > 
      <TD><%=SystemEnv.getHtmlLabelName(15209,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text  class=InputStyle size=40 name="itemfieldname" onchange='checkinput("itemfieldname","itemfieldnameimage")' value="<%=itemfieldname%>">
        <SPAN id=itemfieldnameimage></SPAN>（<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>："f_"+"<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>"[<%=SystemEnv.getHtmlLabelName(642,user.getLanguage())%>]，<%=SystemEnv.getHtmlLabelName(15210,user.getLanguage())%>。）
	 </TD>
    </TR><tr><td class=Line colspan=2></td></tr>
    
	<%
	dspstatus = "" ;
	disabled = "" ;
	if(!itemfieldtype.equals("1")) {
		dspstatus = "style='display:none'" ;
		disabled = "disabled" ;
	}
	%>
    <tr  id = textscale <%= dspstatus %>> 
      <td><%=SystemEnv.getHtmlLabelName(15211,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text  class=InputStyle size=7 id=itemfieldscale1 name="itemfieldscale" value="<%=itemfieldscale%>" <%=disabled%>>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
	<%
	dspstatus = "" ;
	disabled = "" ;
	if(!itemfieldtype.equals("3")) {
		dspstatus = "style='display:none'" ;
		disabled = "disabled" ;
	}
	%>
    <tr id=numberscale <%= dspstatus %>> 
      <td><%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text  class=InputStyle size=7 id=itemfieldscale2 name="itemfieldscale" value="<%=itemfieldscale%>" <%=disabled%>>
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    <%
	dspstatus = "" ;
	disabled = "" ;
		dspstatus = "style='display:none'" ;
		disabled = "disabled" ;
	%>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
      <td class=Field> 
        <input type=text  class=InputStyle size=7 id=itemfieldunit name="itemfieldunit" value="<%=itemfieldunit%>" >
      </td>
    </TR><tr><td class=Line colspan=2></td></tr>
    </TBODY> 
  </TABLE>
  
  <% if(itemfieldtype.equals("4")) { %>
  <br>
  <table class=ViewForm>
  <TR class=Title> 
      <TH><%=SystemEnv.getHtmlLabelName(15214,user.getLanguage())%>  (<%=SystemEnv.getHtmlLabelName(15215,user.getLanguage())%>。)</TH>
	  <td align=right>
        <BUTTON class=btnSave accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></BUTTON> 
	  </td>
    </TR>
    <TR class=Seperator> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
  </table>
  
  <TABLE class=ListStyle id="oTable" cols=2 cellspacing=1>
    <COLGROUP> 
      <COL width="50%">
      <COL width="50%"><!--COL width="70%" -->
    <TBODY> 
	<TR class=Header> 
      <!--TD>显示值</TD -->
      <!--TD>实际值</TD -->
      <TD><%=SystemEnv.getHtmlLabelName(15216,user.getLanguage())%></TD>
      <td><%=SystemEnv.getHtmlLabelName(15217,user.getLanguage())%></td>
    </TR>
<TR class=Line><TD colSpan=2></TD></TR>
<%
rs.executeProc("T_fieldItemDetail_SelectByItemid",""+itemid);
int recorderindex = 0 ;
while(rs.next()) {
    String itemdsp = Util.toScreenToEdit(rs.getString("itemdsp"),user.getLanguage());
    String itemvalue = Util.toScreenToEdit(rs.getString("itemvalue"),user.getLanguage());
    %>
<script language=javascript>
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
</script>
    <tr> 
      <td>
        <input type=text class=InputStyle name="itemvalue<%=recorderindex%>" size=30 maxlength="30" value="<%=itemdsp%>">
      </td>
      <td>
        <input type=text class=InputStyle name="itemdsp<%=recorderindex%>" size=30 maxlength="30" value="<%=itemvalue%>">
      </td>
    </tr>
<% recorderindex ++ ;} %>
    </tbody> 
  </table>
 <%}%> 

<% if(itemfieldtype.equals("5")) { %>
  <br>
  <table class=ViewForm>
  <TR class=Title> 
      <TH><%=SystemEnv.getHtmlLabelName(15214,user.getLanguage())%>  (<%=SystemEnv.getHtmlLabelName(15215,user.getLanguage())%>。)</TH>
	  <td align=right>
        <BUTTON class=btnSave accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON> 
	  </td>
    </TR>
    <TR class=Seperator> 
      <TD class=Line1 colSpan=2></TD>
    </TR>
  </table>
  
  <TABLE class=ListStyle id="oTable" cols=2>
    <COLGROUP> 
      <COL width="50%">
      <COL width="50%"><!--COL width="70%" -->
    <TBODY> 
	<TR class=Header> 
      <!--TD>显示值</TD -->
      <!--TD>实际值</TD -->
      <TD><%=SystemEnv.getHtmlLabelName(15216,user.getLanguage())%></TD>
      <td><%=SystemEnv.getHtmlLabelName(15217,user.getLanguage())%></td>
    </TR>
<%
rs.executeProc("T_fieldItemDetail_SelectByItemid",""+itemid);
int recorderindex = 0 ;
while(rs.next()) {
    String itemdsp = Util.toScreenToEdit(rs.getString("itemdsp"),user.getLanguage());
    String itemvalue = Util.toScreenToEdit(rs.getString("itemvalue"),user.getLanguage());
    %>
<script language=javascript>
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
</script>
    <tr> 
      <td>
        <input type=text class=InputStyle name="itemvalue<%=recorderindex%>" size=30 maxlength="30" value="<%=itemdsp%>">
      </td>
      <td>
        <input type=text class=InputStyle name="itemdsp<%=recorderindex%>" size=30 maxlength="30" value="<%=itemvalue%>">
      </td>
    </tr>
<% recorderindex ++ ;} %>
    </tbody> 
  </table>
 <%}%> 
        
 </form>
 <script language=javascript>
 function showType(){
		itemfieldtypelist = window.document.frmMain.itemfieldtype;
		if(itemfieldtypelist.value==1){
			textscale.style.display='';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = false ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
		if(itemfieldtypelist.value==2){
			textscale.style.display='none';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
		if(itemfieldtypelist.value==3){
			textscale.style.display='none';
			numberscale.style.display='';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
            window.document.frmMain.gongsi.disabled = true ;
		}
		if(itemfieldtypelist.value==4){
			textscale.style.display='none';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
        if(itemfieldtypelist.value==5){
			textscale.style.display='none';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
        if(itemfieldtypelist.value==6){
			textscale.style.display='none';
			numberscale.style.display='none';
            jisuangongsi.style.display='none';
            excelsheet.style.display='';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
	}
	
	function onSave(){
		if(check_form(document.frmMain,'itemdspname,itemfieldname')){
			document.frmMain.operation.value="edit";
			document.frmMain.submit();
		}
	 }
	 function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			document.frmMain.operation.value="delete";
			document.frmMain.submit();
		}
	}

</script>
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
