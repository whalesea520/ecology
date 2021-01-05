<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
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
//			case 0: 
//				var oDiv = document.createElement("div");
//				var sHtml = "<input type='text' name='itemdsp"+rowindex+"' size=30 maxlength='30'>" ;
//				oDiv.innerHTML = sHtml;
//				oCell.appendChild(oDiv);
//				break;
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='itemvalue"+rowindex+"' size=30 maxlength='30'>" ;
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
int itemid = Util.getIntValue(request.getParameter("itemid"),0);
rs.executeProc("T_IReportItem_SelectByItemid",""+itemid);
rs.next() ;

String inprepid = Util.null2String(rs.getString("inprepid")) ;
String itemtypeid = Util.null2String(rs.getString("itemtypeid")) ;
String itemdspname = Util.toScreenToEdit(rs.getString("itemdspname"),user.getLanguage()) ;
String itemfieldname = Util.null2String(rs.getString("itemfieldname")) ;
String itemfieldtype = Util.null2String(rs.getString("itemfieldtype")) ;
String itemfieldscale = Util.null2String(rs.getString("itemfieldscale")) ;
String itemexcelsheet = Util.null2String(rs.getString("itemexcelsheet")) ;
String itemexcelrow = Util.null2String(rs.getString("itemexcelrow")) ;
String itemexcelcolumn = Util.null2String(rs.getString("itemexcelcolumn")) ;

if(itemfieldscale.equals("0")) itemfieldscale = "" ;
if(itemexcelrow.equals("0")) itemexcelrow = "" ;
if(itemexcelcolumn.equals("0")) itemexcelcolumn = "" ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("输入项信息",user.getLanguage(),"0") + itemdspname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>


	<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%><%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",InputReportItemAdd.jsp?inprepid="+inprepid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="InputReportItemOperation.jsp" method=post >
	<input type="hidden" name=operation>
    <input type="hidden" name=inprepid value=<%=inprepid%>>
	<input type="hidden" name=itemid value=<%=itemid%>>
	<INPUT type=hidden name="olditemfieldname" value="<%=itemfieldname%>">
	<INPUT type=hidden name="olditemfieldtype" value="<%=itemfieldtype%>">
	<INPUT type=hidden name="olditemfieldscale" value="<%=itemfieldscale%>">
	<input type="hidden" name="totaldetail"> 

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

  <TABLE class=viewform>
    <COLGROUP> <COL width="20%"> <COL width="80%"> <TBODY> 
    <TR class=title> 
      <TH colSpan=2>输入项信息</TH>
    </TR>
    <TR class=spacing> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>输入项名称</TD>
      <TD class=Field> 
        <INPUT type=text class=inputstyle size=50 name="itemdspname" onchange='checkinput("itemdspname","itemdspnameimage")' value=<%=itemdspname%>>
        <SPAN id=itemdspnameimage></span></TD>
    </TR>
	    <TR class=spacing> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>输入项字段名</TD>
      <TD class=Field> 
        <INPUT type=text class=inputstyle size=50 name="itemfieldname" onchange='checkinput("itemfieldname","itemfieldnameimage")' value="<%=itemfieldname%>">
        <SPAN id=itemfieldnameimage></SPAN>
	 </TD>
    </TR>    <TR class=spacing> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>输入项类型</TD>
      <TD class=Field > 
        <select class="InputStyle" name="itemfieldtype" style="width:50%" onChange="showType()">
          <option value="1" <% if(itemfieldtype.equals("1")) {%> selected <%}%>>文本型</option>
          <option value="2" <% if(itemfieldtype.equals("2")) {%> selected <%}%>>整数型</option>
          <option value="3" <% if(itemfieldtype.equals("3")) {%> selected <%}%>>浮点型</option>
          <option value="4" <% if(itemfieldtype.equals("4")) {%> selected <%}%>>选择型</option>
        </select>
      </TD>
    </TR>    <TR class=spacing> 
      <TD class=line colSpan=2 ></TD>
    </TR>
	<%
	String dspstatus = "" ;
	String disabled = "" ;
	if(!itemfieldtype.equals("1")) {
		dspstatus = "style='display:none'" ;
		disabled = "disabled" ;
	}
	%>
    <tr  id = textscale <%= dspstatus %>> 
      <td>文本字段宽度</td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldscale1 name="itemfieldscale" value=<%=itemfieldscale%> <%=disabled%>>
      </td>
    </tr>
	    <TR class=spacing id = textscale1 <%= dspstatus %>> 
      <TD class=line colSpan=2 ></TD>
    </TR>
	<%
	dspstatus = "" ;
	disabled = "" ;
	if(!itemfieldtype.equals("3")) {
		dspstatus = "style='display:none'" ;
		disabled = "disabled" ;
	}
	%>
    <tr id=numberscale <%= dspstatus %>> 
      <td>小数位数</td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldscale2 name="itemfieldscale" value=<%=itemfieldscale%> <%=disabled%>>
      </td>
    </tr>
	    <TR class=spacing id=numberscale1 <%= dspstatus %>> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td>输入项种类</td>
      <td class=Field > 
        <select class="InputStyle" name="itemtypeid" style="width:50%">
          <%
			rs.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
			while(rs.next()) {
				String itemtypeids = Util.null2String(rs.getString("itemtypeid")) ;
				String itemtypenames = Util.toScreen(rs.getString("itemtypename"),user.getLanguage()) ;
				String selected = "" ;
				if(itemtypeids.equals(itemtypeid)) selected = "selected" ;
		%>
          <option value="<%=itemtypeids%>" <%=selected%>><%=itemtypenames%></option>
          <%}%>
        </select>
      </td>
    </tr>    <TR class=spacing> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>Excel表中位置</TD>
      <TD class=FIELD> sheet 
        <input type="text" class="InputStyle" name="itemexcelsheet" size="15" value=<%=itemexcelsheet%>>
        行 
        <input type="text" class="InputStyle"  name="itemexcelrow" size="7" value=<%=itemexcelrow%>>
        列 
        <input type="text" class="InputStyle"  name="itemexcelcolumn" size="7" value=<%=itemexcelcolumn%>>
      </TD>
    </TR>    <TR class=spacing> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    </TBODY> 
  </TABLE>
  
  
  <% if(itemfieldtype.equals("4")) { %>
  <br>
  <table class=viewform>
  <TR class=title> 
      <TH>选择项详细值</TH>
	  <td align=right>
        <BUTTON class=btnSave accessKey=A onClick="addRow();"><U>A</U>-加入一行</BUTTON> 
	  </td>
    </TR>
    <TR class=Seperator> 
      <TD class=line1 colSpan=2></TD>
    </TR>
  </table>
  
  <TABLE class=liststyle cellspacing=1 id="oTable" cols=1>
    <COLGROUP> <COL width="100%"><!--COL width="70%" -->
    <TBODY> 
	<TR class=Header> 
      <!--TD>显示值</TD -->
      <!--TD>实际值</TD -->
      <TD>可选值</TD>
    </TR>
	<TR class=Line><TD ></TD></TR> 
<%
rs.executeProc("T_IRItemDetail_SelectByItemid",""+itemid);
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
      <!--td> 
        <input type="text" name="itemdsp<%=recorderindex%>" size=30 maxlength="100" value="<%=itemdsp%>">
      </td -->
     
      <td>
        <input type="text" class="InputStyle" name="itemvalue<%=recorderindex%>" size=30 maxlength="30" value="<%=itemvalue%>">
      </td>
    </tr>
<% recorderindex ++ ;} %>
    </tbody> 
  </table>
 <%}%> 
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

 </form>
 <script language=javascript>
 function showType(){
		itemfieldtypelist = window.document.frmMain.itemfieldtype;
		if(itemfieldtypelist.value==1){
			textscale.style.display='';
			numberscale.style.display='none';
			textscale1.style.display='';
			numberscale1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = false ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
		}
		if(itemfieldtypelist.value==2){
			textscale.style.display='none';
			numberscale.style.display='none';
			textscale1.style.display='none';
			numberscale1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
		}
		if(itemfieldtypelist.value==3){
			textscale.style.display='none';
			numberscale.style.display='';
			textscale1.style.display='none';
			numberscale1.style.display='';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
		}
		if(itemfieldtypelist.value==4){
			textscale.style.display='none';
			numberscale.style.display='none';
			textscale1.style.display='none';
			numberscale1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
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

</BODY></HTML>
