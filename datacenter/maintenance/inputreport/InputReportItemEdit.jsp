<%@ page language="java" contentType="text/html; charset=GBK" %> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportComInfo" class="weaver.datacenter.InputReportComInfo" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
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
				var sHtml = "<input   type='checkbox' name='check_select' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1: 
				var oDiv = document.createElement("div");
				var sHtml = "<input type='text' name='itemdsp"+rowindex+"' size=30 maxlength='30'>" ;
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
//			case 0: 
//				var oDiv = document.createElement("div");
//				var sHtml = "<input type='text' name='itemvalue"+rowindex+"' size=30 maxlength='30'>" ;
//				oDiv.innerHTML = sHtml;
//				oCell.appendChild(oDiv);
//				break;
		}
	}
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
}

function deleteRow(){

    if(!confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
		return ;
	}

	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_select'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
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
String itemfieldunit = Util.null2String(rs.getString("itemfieldunit")) ;
String dsporder = Util.null2String(rs.getString("dsporder")) ;
String itemgongsi = Util.null2String(rs.getString("itemgongsi")) ;
String inputablefact = Util.null2String(rs.getString("inputablefact")) ; // 实际是否可输入
String inputablebudg = Util.null2String(rs.getString("inputablebudg")) ; // 预算是否可输入
String inputablefore = Util.null2String(rs.getString("inputablefore")) ; // 预测是否可输入


if(itemfieldscale.equals("0")) itemfieldscale = "" ;
if(itemexcelrow.equals("0")) itemexcelrow = "" ;
if(itemexcelcolumn.equals("0")) itemexcelcolumn = "" ;

String imagefilename = "/images/hdHRMCard.gif";
//String titlename = Util.toScreen("输入项信息",user.getLanguage(),"0") + itemdspname ;
String titlename = SystemEnv.getHtmlLabelName(15199,user.getLanguage()) +"：" +itemdspname ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",InputReportItemAdd.jsp?inprepid="+inprepid+",_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
List hasUsedSelectList=new ArrayList();
String tempHasUsedSelect=null;
String inprepTableName=InputReportComInfo.getinpreptablename(inprepid);
rs.executeSql("select distinct "+itemfieldname+" from "+inprepTableName);
while(rs.next()){
	tempHasUsedSelect=Util.null2String(rs.getString(1));
	if(!tempHasUsedSelect.equals("")){
		hasUsedSelectList.add(tempHasUsedSelect);
	}
}
%>

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
      <TH colSpan=2><%=SystemEnv.getHtmlLabelName(15199,user.getLanguage())%></TH>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15207,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class=inputstyle size=50 name="itemdspname" onchange='checkinput("itemdspname","itemdspnameimage")' value="<%=itemdspname%>">
        <SPAN id=itemdspnameimage></span></TD>
    </TR> <TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20826,user.getLanguage())%></TD>
      <TD class=Field > 
        <select class="InputStyle" name="itemfieldtypeTemp" style="width:50%" onChange="showType()" disabled>
          <option value="1" <% if(itemfieldtype.equals("1")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15201,user.getLanguage())%></option>
          <option value="6" <% if(itemfieldtype.equals("6")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15206,user.getLanguage())%></option>
          <option value="2" <% if(itemfieldtype.equals("2")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15202,user.getLanguage())%></option>
          <option value="3" <% if(itemfieldtype.equals("3")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15203,user.getLanguage())%></option>
          <option value="4" <% if(itemfieldtype.equals("4")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20791,user.getLanguage())%></option>
           <option value="5" <% if(itemfieldtype.equals("5")) {%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20792,user.getLanguage())%></option>
        </select>
		<INPUT type=hidden name="itemfieldtype" value="<%=itemfieldtype%>">
      </TD>
    </TR><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <%
	String dspstatus = "" ;
	String disabled = "" ;
	if(itemfieldtype.equals("5")) {
		dspstatus = "style='display:none';height: 1px" ;
		disabled = "disabled" ;
	}else{
		dspstatus = "style='height: 1px" ;
	}
	%>
    <TR id=itemfield <%= dspstatus %>> 
      <TD><%=SystemEnv.getHtmlLabelName(15209,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class=inputstyle size=50 name="itemfieldname" onchange='checkinput("itemfieldname","itemfieldnameimage")' value="<%=itemfieldname%>">
        <SPAN id=itemfieldnameimage></SPAN>
	 </TD>
    </TR>
    <TR id=itemfield1 class=spacing <%= dspstatus %>> 
      <TD class=line colSpan=2 ></TD>
    </TR>
	<%
	dspstatus = "" ;
	disabled = "" ;
	if(!itemfieldtype.equals("1")) {
		dspstatus = "style='display:none;height: 1px'" ;
		disabled = "disabled" ;
	}else{
		dspstatus = "style='height: 1px'" ;
	}
	%>
    <tr  id = textscale <%= dspstatus %>> 
      <td><%=SystemEnv.getHtmlLabelName(15211,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldscale1 name="itemfieldscale" value="<%=itemfieldscale%>" <%=disabled%> onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemfieldscale1);checkItemFieldScale(hisItemFieldScale1,itemfieldscale1,1,4000)' style='text-align:right;'>
        <input type='hidden'  id=hisItemFieldScale1 name='hisItemFieldScale1'  value = '<%=itemfieldscale%>'>
      </td>
    </tr>
	 <TR id=textscale1 class=spacing <%= dspstatus %>> 
      <TD class=line colSpan=2 ></TD>
    </TR>
	<%
	dspstatus = "" ;
	disabled = "" ;
	if(!itemfieldtype.equals("3")&&!itemfieldtype.equals("5")) {
		dspstatus = "style='display:none;height: 1px'" ;
		disabled = "disabled" ;
	}else{
		dspstatus = "style='height: 1px'" ;
	}
	%>
    <tr id=numberscale <%= dspstatus %>> 
      <td><%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldscale2 name="itemfieldscale" value="<%=itemfieldscale%>" <%=disabled%> onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemfieldscale2);checkItemFieldScale(hisItemFieldScale2,itemfieldscale2,1,9)' style='text-align:right;'>
        <input type='hidden'  id=hisItemFieldScale2 name='hisItemFieldScale2'  value = '<%=itemfieldscale%>'>
      </td>
    </tr>
	<TR id=numberscale1 class=spacing <%= dspstatus %>> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <%
	dspstatus = "" ;
	disabled = "" ;
	if(!itemfieldtype.equals("5")) {
		dspstatus = "style='display:none;height: 1px'" ;
		disabled = "disabled" ;
	}else{
		dspstatus = "style='height: 1px'" ;
	}
	%>
    <tr id=jisuangongsi <%= dspstatus %> > 
      <td><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=50 id=gongsi name="gongsi" value="<%=itemgongsi%>" <%=disabled%>>
      </td>
    </tr>
	<TR id=jisuangongsi1 class=spacing <%= dspstatus %>> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldunit name="itemfieldunit" value="<%=itemfieldunit%>" >
      </td>
    </tr><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></td>
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
    </tr><TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR id = excelsheet > 
      <TD><%=SystemEnv.getHtmlLabelName(20790,user.getLanguage())%></TD>
      <TD class=FIELD> 
        <%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%> 
        <input type="text" class="InputStyle"  name="itemexcelrow" size="7" value="<%=itemexcelrow%>" onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemexcelrow)' style='text-align:right;'>
        <%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%> 
        <input type="text" class="InputStyle"  name="itemexcelcolumn" size="7" value="<%=itemexcelcolumn%>" onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemexcelcolumn)' style='text-align:right;'>
      </TD>
    </TR>
	<TR id=excelsheet1 class=spacing style="height: 1px" > 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=dsporder name="dsporder" value="<%=dsporder%>" onKeyPress='ItemDecimal_KeyPress("dsporder",15,2)'  onchange='checknumber("dsporder");checkDigit("dsporder",15,2)' style='text-align:right;'>
      </td>
    </tr><TR  class=spacing style="height: 1px" > 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <input type="hidden" name="inputablefact" value=1>

    </TBODY> 
  </TABLE>
  
  
  <% if(itemfieldtype.equals("4")) { %>
  <br>
  <table class=viewform>
  <TR class=title> 
      <TH><%=SystemEnv.getHtmlLabelName(15214,user.getLanguage())%></TH>
	  <td align=right>
        <BUTTON class=btn accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
        <BUTTON class=btn accessKey=E onClick="deleteRow();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>	  
	  </td>
    </TR>
    <TR class=Seperator> 
      <TD class=line1 colSpan=2></TD>
    </TR>
  </table>
  
  <TABLE class=ListStyle  id="oTable" cols=2 border=0 cellspacing=>
    <COLGROUP> 
	  <COL width="10%">
	  <COL width="90%"><!--COL width="70%" -->
    <TBODY> 
	<TR class=Header> 
      <!--TD>显示值</TD -->
      <!--TD>实际值</TD -->
      <TD><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></TD>
    </TR>
<%
rs.executeProc("T_IRItemDetail_SelectByItemid",""+itemid);
int recorderindex = 0 ;
String trClass="DataLight";
while(rs.next()) {
String itemdsp = Util.toScreenToEdit(rs.getString("itemdsp"),user.getLanguage());
String itemvalue = Util.toScreenToEdit(rs.getString("itemvalue"),user.getLanguage());
%>
<script language=javascript>
	rowindex = rowindex*1 +1;
	frmMain.totaldetail.value=rowindex;
	totalrows = rowindex;
</script>
    <tr class=<%=trClass%>> 
      <td> 
        <input type="checkbox" name="check_select"  value="<%=recorderindex%>"  
<%
	if(hasUsedSelectList.indexOf(itemvalue)!=-1){
%>
	disabled
<%
	}
%>
	    >
      </td>
      <td> 
        <input type="text" name="itemdsp<%=recorderindex%>" size=30 maxlength="100" value="<%=itemdsp%>">
        <input type="hidden" name="itemvalue<%=recorderindex%>" size=30 maxlength="100" value="<%=itemvalue%>">
      </td>
<!--     
      <td>
        <input type="text"  class="InputStyle"  name="itemvalue<%=recorderindex%>" size=30 maxlength="30" value="<%=itemvalue%>">
      </td>
-->
    </tr>
<% recorderindex ++ ;
      if(trClass.equals("DataLight")){
		  trClass="DataDark";
	  }else{
		  trClass="DataLight";
	  }
	} %>
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

 </BODY></HTML>
 <script language=javascript>
 function showType(){
		itemfieldtypelist = window.document.frmMain.itemfieldtype;
		if(itemfieldtypelist.value==1){
			textscale.style.display='';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
			textscale1.style.display='';
			numberscale1.style.display='none';
            excelsheet1.style.display='';
            jisuangongsi1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = false ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
		if(itemfieldtypelist.value==2){
			textscale.style.display='none';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
			textscale1.style.display='none';
			numberscale1.style.display='none';
            excelsheet1.style.display='';
            jisuangongsi1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
		if(itemfieldtypelist.value==3){
			textscale.style.display='none';
			numberscale.style.display='';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
			textscale1.style.display='none';
			numberscale1.style.display='';
            excelsheet1.style.display='';
            jisuangongsi1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
            window.document.frmMain.gongsi.disabled = true ;
		}
		if(itemfieldtypelist.value==4){
			textscale.style.display='none';
			numberscale.style.display='none';
            excelsheet.style.display='';
            jisuangongsi.style.display='none';
			textscale1.style.display='none';
			numberscale1.style.display='none';
            excelsheet1.style.display='';
            jisuangongsi1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
        if(itemfieldtypelist.value==5){
			textscale.style.display='none';
			numberscale.style.display='';
            jisuangongsi.style.display='';
            excelsheet.style.display='';
			textscale1.style.display='none';
			numberscale1.style.display='';
            jisuangongsi1.style.display='';
            excelsheet1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
            window.document.frmMain.gongsi.disabled = false ;
		}
        if(itemfieldtypelist.value==6){
			textscale.style.display='none';
			numberscale.style.display='none';
            jisuangongsi.style.display='none';
            excelsheet.style.display='';
			textscale1.style.display='none';
			numberscale1.style.display='none';
            jisuangongsi1.style.display='none';
            excelsheet1.style.display='';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            window.document.frmMain.gongsi.disabled = true ;
		}
	}
	
	function onSave(obj){
		if(check_form(document.frmMain,'itemdspname,itemfieldname')&&checkKey(document.getElementById("itemfieldname"))){
		    obj.disabled=true;
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

	function checkKey(obj){
		var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
		var fname=obj.value;
		if (fname!=""){
			fname=","+fname.toUpperCase()+",";
			if (keys.indexOf(fname)>0){
				alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
				obj.focus();
				return false;
			}
		}
		return true;
	}

/*
p（精度）
指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。

s（小数位数）
指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
*/
function checkDigit(elementName,p,s){
	tmpvalue = document.all(elementName).value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    document.all(elementName).value=newValue;
}

function checkItemFieldScale(oldObj,newObj,minValue,maxValue){
	oldValue=oldObj.value;
	newValue=newObj.value;

    try{
        oldValue=parseInt(oldValue);
        if(isNaN(oldValue)){
            oldValue=0;
        }
    }catch(e){
        oldValue=0;
    }

    try{
        newValue=parseInt(newValue);
        if(isNaN(newValue)){
            newValue=0;
        }
    }catch(e){
        newValue=0;
    }

	if(newValue<oldValue){
		alert("<%=SystemEnv.getHtmlLabelName(20881,user.getLanguage())%>");
		newObj.value=oldValue;
		return ;
	}
	if(newValue<minValue||newValue>maxValue){
		alert("<%=SystemEnv.getHtmlLabelName(20882,user.getLanguage())%>："+minValue+"-"+maxValue);
		newObj.value=oldValue;
		return ;
	}
}
</script>




