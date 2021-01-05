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
			case 0: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='itemdsp"+rowindex+"' size=20 maxlength='30'>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='itemendsp"+rowindex+"' size=20 maxlength='30'>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='conditionvalue"+rowindex+"' size=40 maxlength='100'>" ;
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

int conditionid = Util.getIntValue(request.getParameter("conditionid"),0);
rs.executeProc("T_CT_SelectByConditionid",""+conditionid);
rs.next() ;

String conditionname = Util.toScreenToEdit(rs.getString("conditionname"),user.getLanguage()) ;
String conditiondesc = Util.toScreenToEdit(rs.getString("conditiondesc"),user.getLanguage()) ;
String conditionitemfieldname = Util.null2String(rs.getString("conditionitemfieldname")) ;
String conditiontype = Util.null2String(rs.getString("conditiontype")) ;

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("报表条件信息",user.getLanguage(),"0") + conditionname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",OutReportConditionAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=weaver name=frmMain action="OutReportConditionOperation.jsp" method=post onSubmit="return check_form(this,'conditionname,conditionitemfieldname')">
<input type="hidden" name=operation>
<input type="hidden" name=conditionid value=<%=conditionid%>>
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
      <TH colSpan=2>报表条件信息</TH>
    </TR>
    <TR class=spacing style='height:1px'> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>条件名称</TD>
      <TD class=Field>
        <INPUT type=text class=inputstyle size=50 name="conditionname" onchange='checkinput("conditionname","conditionnameimage")' value=<%=conditionname%>>
        <SPAN id=conditionnameimage></SPAN></TD>
    </TR> <TR class=spacing style='height:1px'> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>对应字段名</TD>
      <TD class=Field> 
        <INPUT type=text class=inputstyle size=50 name="conditionitemfieldname" onchange='checkinput("conditionitemfieldname","conditionitemfieldnameimage")' value=<%=conditionitemfieldname%>>
        <SPAN id=conditionitemfieldnameimage></SPAN></TD>
    </TR> <TR class=spacing style='height:1px'> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD>输入项类型</TD>
      <TD class=Field > 
        <select class="InputStyle" name="conditiontype">
          <option value="1" <% if(conditiontype.equals("1")) {%> selected <%}%>>文本型</option>
          <option value="2" <% if(conditiontype.equals("2")) {%> selected <%}%>>选择型</option>
          <option value="3" <% if(conditiontype.equals("3")) {%> selected <%}%>>公式型</option>
        </select>
      </TD>
    </TR> <TR class=spacing style='height:1px'> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td>条件描述</td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=50 name="conditiondesc" value=<%=conditiondesc%>>
      </td>
    </tr> <TR class=spacing style='height:1px'> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    </TBODY> 
  </TABLE>

   <% if(!conditiontype.equals("1")) { %>
  <br>
  <table class=viewform>
  <TR class=title> 
      <TH>选择项详细值</TH>
	  <td align=right>
        <BUTTON class=btnSave accessKey=A onClick="addRow();"><U>A</U>-加入一行</BUTTON> 
	  </td>
    </TR>

  </table>
  
  <TABLE class=liststyle cellspacing=1 id="oTable" cols=3>
    <COLGROUP> <COL width="25%"><COL width="25%"><COL width="50%">
    <TBODY> 
	<TR class=Header> 
      <TD>中文名</TD>
      <TD>英文名</TD>
      <TD>值</TD>
    </TR>
	<TR class=Line><TD colspan="3" ></TD></TR> 
<%
rs.executeProc("T_CDetail_SelectByConditionid",""+conditionid);
int recorderindex = 0 ;
while(rs.next()) {
String conditiondsp = Util.toScreenToEdit(rs.getString("conditiondsp"),user.getLanguage());
String conditionendsp = Util.toScreenToEdit(rs.getString("conditionendsp"),user.getLanguage());
String conditionvalue = Util.toScreenToEdit(rs.getString("conditionvalue"),user.getLanguage());
%>
<script language=javascript>
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
</script>
    <tr> 
      <td> 
        <input type="text" class="InputStyle" name="itemdsp<%=recorderindex%>" size=20 maxlength="100" value="<%=conditiondsp%>">
      </td>
      <td> 
        <input type="text" class="InputStyle" name="itemendsp<%=recorderindex%>" size=20 maxlength="100" value="<%=conditionendsp%>">
      </td>
      <td align=left>
        <input type="text" class="InputStyle" name="conditionvalue<%=recorderindex%>" size=40 maxlength="100" value="<%=conditionvalue%>">
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
    conditiontypelist = window.document.frmMain.conditiontype;
    if(conditiontypelist.value==1){
        conditionitemfield.style.display='';
    }
    if(conditiontypelist.value==2){
        conditionitemfield.style.display='';
    }
    if(conditiontypelist.value==3){
        conditionitemfield.style.display='none';
    }
 }

	function onSave(){
		if(check_form(document.frmMain,'conditionname,conditionitemfieldname')){
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
 <script language="javascript">
function submitData()
{
	if (check_form(frmMain,'conditionname,conditionitemfieldname'))
		frmMain.submit();
}
</script>
</BODY></HTML>
