<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);

String imagefilename = "/images/hdHRMCard.gif";
//String titlename = Util.toScreen("新：输入项信息",user.getLanguage(),"0");
String titlename =SystemEnv.getHtmlLabelName(82,user.getLanguage()) +"："+SystemEnv.getHtmlLabelName(15199,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
// 查询现在已经有的表 

String itemfieldnames = "" ;

RecordSet.executeProc("T_IRItem_SelectByInprepid" , ""+inprepid);
while(RecordSet.next()) {
    String itemfieldname = Util.null2String(RecordSet.getString("itemfieldname")) ;
    itemfieldnames += ","+itemfieldname ;
}

if(!itemfieldnames.equals("")) itemfieldnames += "," ;

double  dsporder=1.00;
RecordSet.executeSql("select max(dsporder) as maxdsporder from T_InputReportItem where inprepId="+inprepid);
if(RecordSet.next()){
	dsporder=Util.getDoubleValue(RecordSet.getString("maxdsporder"),0);
	dsporder=dsporder+1;
}
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
%>

<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM id=frmMain name=frmMain action="InputReportItemOperation.jsp" method=post >
<input type="hidden" name="hasitem" id="hasitem">
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
        <INPUT type=text class=inputstyle size=50 name="itemdspname" onchange='checkinput("itemdspname","itemdspnameimage")'>
        <SPAN id=itemdspnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR>
	<TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </TR>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(20826,user.getLanguage())%></TD>
      <TD class=Field > 
        <select class="InputStyle" name="itemfieldtype" style="width:50%" onChange="showType()">
          <option value="1"><%=SystemEnv.getHtmlLabelName(15201,user.getLanguage())%></option>
          <option value="6"><%=SystemEnv.getHtmlLabelName(15206,user.getLanguage())%></option>
          <option value="2"><%=SystemEnv.getHtmlLabelName(15202,user.getLanguage())%></option>
          <option value="3"><%=SystemEnv.getHtmlLabelName(15203,user.getLanguage())%></option>
          <option value="4"><%=SystemEnv.getHtmlLabelName(20791,user.getLanguage())%></option>
          <option value="5"><%=SystemEnv.getHtmlLabelName(20792,user.getLanguage())%></option>
        </select>
      </TD>
    </TR>	<TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD></tr>
    <TR> 
      <TD><%=SystemEnv.getHtmlLabelName(15209,user.getLanguage())%></TD>
      <TD class=Field> 
        <INPUT type=text class=inputstyle size=50 name="itemfieldname" onchange='checkinput("itemfieldname","itemfieldnameimage")'>
        <SPAN id=itemfieldnameimage><IMG src="/images/BacoError.gif" align=absMiddle></SPAN></TD>
    </TR>	<TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD></tr>
    <tr  id = textscale style="display:''" > 
      <td><%=SystemEnv.getHtmlLabelName(15211,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldscale1 name="itemfieldscale" value=60 onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemfieldscale1);checkItemFieldScaleForAdd(itemfieldscale1,1,4000,60)' style='text-align:right;'>
      </td>
    </tr>
		<TR id=textscale1  class=spacing style="display:'';height: 1px"> 
      <TD class=line colSpan=2 ></TD></tr>
	  
    <tr id=numberscale style="display:none"> 
      <td><%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldscale2 name="itemfieldscale" value=2 disabled onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemfieldscale2);checkItemFieldScaleForAdd(itemfieldscale2,1,9,2)' style='text-align:right;'>
      </td>
    </tr>
	<TR id=numberscale1 class=spacing style="display:none;height: 1px"> 
      <TD class=line colSpan=2 ></TD></tr>
	  
    <tr id=jisuangongsi style="display:none"> 
      <td><%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=50 id=gongsi name="gongsi" disabled>
      </td>
    </tr>		<TR id=jisuangongsi1 class=spacing style="display:none;height: 1px;"> 
      <TD class=line colSpan=2 ></TD></tr>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=itemfieldunit name="itemfieldunit">
      </td>
    </tr>
		<TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    </tr>
		<TR class=Spacing style="height: 1px"> 
      <td><%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></td>
      <td class=Field > 
        <select class=InputStyle name="itemtypeid" style="width:50%">
          <%
			RecordSet.executeProc("T_IRItemtype_SelectByInprepid",""+inprepid);
			while(RecordSet.next()) {
				String itemtypeid = Util.null2String(RecordSet.getString("itemtypeid")) ;
				String itemtypename = Util.toScreen(RecordSet.getString("itemtypename"),user.getLanguage()) ;
		%>
          <option value="<%=itemtypeid%>"><%=itemtypename%></option>
          <%}%>
        </select>
      </td>
    </tr>	<TR class=Spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD></tr>
    <TR id = excelsheet > 
      <TD><%=SystemEnv.getHtmlLabelName(20790,user.getLanguage())%></TD>
      <TD class=FIELD> 
        <%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%> 
        <input type="text"  class=inputstyle name="itemexcelrow" size="7" onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemexcelrow)' style='text-align:right;'>
        <%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%> 
        <input type="text" class=inputstyle name="itemexcelcolumn" size="7" onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemexcelcolumn)' style='text-align:right;'>
      </TD>
    </TR>
		<TR id=excelsheet1 class=spacing style="height: 1px"> 
      <TD class=line colSpan=2 ></TD>
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
      <td class=Field> 
        <INPUT type=text class=inputstyle size=7 id=dsporder name="dsporder" value="<%=decimalFormat.format(dsporder)%>" onKeyPress='ItemDecimal_KeyPress("dsporder",15,2)'  onchange='checknumber("dsporder");checkDigit("dsporder",15,2)' style='text-align:right;'>
      </td>
    </tr>
    <TR class=Spacing style="height: 1px"><TD class=line colSpan=2 ></TD></TR>
    <input type="hidden" name="inputablefact" value="1">
    <input type="hidden" name=operation value=add>
    <input type="hidden" name=inprepid value=<%=inprepid%>>
    </TBODY> 
  </TABLE>

<div id='divSelect' style="display:none">
  <table class=viewform>
  <TR class=title> 
      <TH><%=SystemEnv.getHtmlLabelName(15214,user.getLanguage())%></TH>
	  <td align=right>
        <BUTTON type="button" class=btn accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15443,user.getLanguage())%></BUTTON>
        <BUTTON type="button" class=btn accessKey=E onClick="deleteRow();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(15444,user.getLanguage())%></BUTTON>	  
	  </td>
    </TR>
    <TR class=Seperator style="height: 1px"> 
      <TD class=line1 colSpan=2></TD>
    </TR>
  </table>
  
  <TABLE class=ListStyle  id="oTable" cols=2 border=0 cellspacing=>
    <COLGROUP> 
	  <COL width="10%">
	  <COL width="90%">
    <TBODY> 
	<TR class=Header> 
      <TD><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></TD>
      <TD><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></TD>
    </TR>
    </tbody> 
  </table>
<div>

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
 jQuery(document).ready(function(){
	 showType();
	 })
 function showType(){
		itemfieldtypelist = window.document.frmMain.itemfieldtype;
		if(itemfieldtypelist.value==1){
			textscale.style.display='';
            excelsheet.style.display='';
			numberscale.style.display='none';
            jisuangongsi.style.display='none';
			textscale1.style.display='';
            excelsheet1.style.display='';
			numberscale1.style.display='none';
            jisuangongsi1.style.display='none';
            window.document.frmMain.itemfieldscale1.disabled = false ;
            window.document.frmMain.gongsi.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = true ;
            divSelect.style.display='none';		
		}
		if(itemfieldtypelist.value==2){
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
            divSelect.style.display='none';
		}
		if(itemfieldtypelist.value==3){
			textscale.style.display='none';
			numberscale.style.display='';
            jisuangongsi.style.display='none';
            excelsheet.style.display='';
			textscale1.style.display='none';
			numberscale1.style.display='';
            jisuangongsi1.style.display='none';
            excelsheet1.style.display='';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
            window.document.frmMain.gongsi.disabled = true ;
            divSelect.style.display='none';
		}
		if(itemfieldtypelist.value==4){
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
            divSelect.style.display='';
		}
        if(itemfieldtypelist.value==5){
			textscale.style.display='none';
			numberscale.style.display='';
            jisuangongsi.style.display='';
            excelsheet.style.display='';
			textscale1.style.display='none';
			numberscale1.style.display='';
            jisuangongsi1.style.display='';
            excelsheet1.style.display='';
            window.document.frmMain.itemfieldscale1.disabled = true ;
            window.document.frmMain.itemfieldscale2.disabled = false ;
            window.document.frmMain.gongsi.disabled = false ;
            divSelect.style.display='none';
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
            divSelect.style.display='none';
		}
	}
</script>
<script language="javascript">
function submitData(obj)
{
	if (check_form(frmMain,'itemdspname,itemfieldname')&&checkKey($GetEle("itemfieldname"))) {
        allitemfieldname = "<%=itemfieldnames%>" ;
        theitemfieldname = ","+document.frmMain.itemfieldname.value+"," ;
        if( allitemfieldname.indexOf(theitemfieldname) !=-1) {
            if(confirm("<%=SystemEnv.getHtmlLabelName(20803,user.getLanguage())%>") ) {
                document.frmMain.hasitem.value = "1" ;
				obj.disabled=true;
		        frmMain.submit();
            }
        }else {
			obj.disabled=true;
            frmMain.submit();
        }
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
	tmpvalue = $GetEle(elementName).value;

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
    $GetEle(elementName).value=newValue;
}

function checkItemFieldScaleForAdd(newObj,minValue,maxValue,defaultValue){

	newValue=newObj.value;

    try{
        newValue=parseInt(newValue);
        if(isNaN(newValue)){
            newValue=0;
        }
    }catch(e){
        newValue=0;
    }

	if(newValue<minValue||newValue>maxValue){
		alert("<%=SystemEnv.getHtmlLabelName(20882,user.getLanguage())%>："+minValue+"-"+maxValue);
		newObj.value=defaultValue;
		return ;
	}
}


var rowindex=0;
var totalrows=0;
var totaldebit = 0 ;
var totalcredit = 0 ;
function addRow()
{	
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);	
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
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


