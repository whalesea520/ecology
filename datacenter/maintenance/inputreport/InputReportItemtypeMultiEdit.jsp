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
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) +"：" +SystemEnv.getHtmlLabelName(15208,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>


<%

List hasUsedItemTypeList=new ArrayList();
String hasUsedItemTypeId=null;
RecordSet.executeSql("select distinct itemTypeId from T_InputReportItem where inprepId="+inprepid+" ");
while(RecordSet.next()){
	hasUsedItemTypeId=Util.null2String(RecordSet.getString("itemTypeId"));
	hasUsedItemTypeList.add(hasUsedItemTypeId);
}

DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式
%>


<FORM id=weaver name=frmMain action="InputReportItemtypeMultiOperation.jsp" method=post >
	<input type="hidden" name=operation>
    <input type="hidden" name=inprepid value=<%=inprepid%>>
    <input type="hidden" value="0" name="recordNum">
    <input type="hidden" value="" name="delids">
	
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
    <COLGROUP> 
	<COL width="20%"> 
	<COL width="80%"> 
	<TBODY> 
    <TR class=title> 
      <td><b><%=SystemEnv.getHtmlLabelName(15208,user.getLanguage())%></b></td>
      <td align=right>
	  <button type="button" class=btn accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button> 
	  <button type="button" class=btn accessKey=E onClick="deleteRow()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
      </td>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    </TBODY> 
  </TABLE> 
  	  <table class=ListStyle id="oTable" cols=4  border=0 cellspacing=1>
      	<COLGROUP>
		<COL width="5%">
		<COL width="40%">
		<COL width="40%">
		<COL width="15%">
          <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(20801,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(20802,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(88,user.getLanguage())%></td>
          </tr>
<%

			String trClass="DataLight";
			int rowsum=0;


			int itemTypeId=0;
			String itemTypeName=null;
			String itemTypeDesc=null;
			double dspOrder=0;

			String disabled="";

			StringBuffer sb=new StringBuffer();
			sb.append(" select itemTypeId,itemTypeName,itemTypeDesc,dspOrder ")
			  .append("   from T_InputReportItemType ")
			  .append("  where inprepId=").append(inprepid)
			  .append("  order by dspOrder  asc ");

			RecordSet.executeSql(sb.toString());
			while(RecordSet.next()){
				itemTypeId=Util.getIntValue(RecordSet.getString("itemTypeId"),0);
				itemTypeName=Util.null2String(RecordSet.getString("itemTypeName"));
				itemTypeDesc=Util.null2String(RecordSet.getString("itemTypeDesc"));
				dspOrder=Util.getDoubleValue(RecordSet.getString("dspOrder"),0);
				disabled="";
				if(hasUsedItemTypeList.indexOf(String.valueOf(itemTypeId))!=-1){
					disabled="disabled";
				}

%>
          <TR class=<%=trClass%>>
			<td  height="23" >
			    <input type='checkbox' name='check_select' value="<%=itemTypeId%>" <%=disabled%>>
				<input type="hidden"  name="itemTypeId_<%=rowsum%>"  value="<%=itemTypeId%>">
		    </td>
			<td >
			  <input   class=Inputstyle type=text name="itemTypeName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(itemTypeName,user.getLanguage())%>"  onchange="checkinput('itemTypeName_<%=rowsum%>','itemTypeName_<%=rowsum%>_span')">
			  <span id="itemTypeName_<%=rowsum%>_span"></span>
			</td>
			<td>
			  <input   class=Inputstyle type=text name="itemTypeDesc_<%=rowsum%>" style="width:90%"   value="<%=Util.toScreen(itemTypeDesc,user.getLanguage())%>">
			</td>
		    <td>
                <input class='InputStyle' type='text' size=6 maxlength=6 name='dspOrder_<%=rowsum%>'  value = '<%=decimalFormat.format(dspOrder)%>' onKeyPress='ItemDecimal_KeyPress("dspOrder_<%=rowsum%>",15,2)' onchange='checknumber("dspOrder_<%=rowsum%>");checkDigit("dspOrder_<%=rowsum%>",15,2)' style='text-align:right;'   >
    		</td>
		</tr>
<%	
				if(trClass.equals("DataLight")){
					trClass="DataDark";
			    }else{
					trClass="DataLight";
				}
				rowsum++;
			}
%>


	  </table>
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

<script language="JavaScript" src="/js/addRowBg.js" >
</script>
<script language=javascript>
rowindex = "<%=rowsum%>";
delids = "";
var rowColor="" ;
function addRow(){			
    rowColor = getRowBg();
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemTypeName_"+rowindex+"' style='width:90%'   onchange=checkinput('itemTypeName_"+rowindex+"','itemTypeName_"+rowindex+"_span')><span id='itemTypeName_"+rowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemTypeDesc_"+rowindex+"' style='width:90%' >";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=6 maxlength=6 name='dspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00'  onKeyPress='ItemDecimal_KeyPress(\"dspOrder_"+rowindex+"\",15,2)' onchange='checknumber(\"dspOrder_"+rowindex+"\");checkDigit(\"dspOrder_"+rowindex+"\",15,2)' style='text-align:right;'>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
		}
	}
	rowindex = rowindex*1 +1;
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
				if(document.forms[0].elements[i].value!='0'){
					delids +=","+ document.forms[0].elements[i].value;
				}
				oTable.deleteRow(rowsum1);
			}
			rowsum1 -=1;
		}

	}
}


function onSave(obj){
	if(checkSave()){
		obj.disabled=true;
		document.frmMain.recordNum.value=rowindex;
		document.frmMain.delids.value=delids;
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}

//check_form(document.frmMain,'')
function checkSave(){

	var paraStr="";
    for(i=0;i<rowindex;i++){
		paraStr+=",itemTypeName_"+i;
	}

	if(!check_form(document.frmMain,paraStr)){
		return false;
	}

    for(i=0;i<rowindex;i++){
		if(document.all("itemTypeName_"+i)!=null){

			document.all("itemTypeName_"+i).value=trim(document.all("itemTypeName_"+i).value);
			
			for(j=i+1;j<rowindex;j++){
				if(document.all("itemTypeName_"+j)!=null){
					document.all("itemTypeName_"+j).value=trim(document.all("itemTypeName_"+j).value);					
                    if(document.all("itemTypeName_"+i).value==document.all("itemTypeName_"+j).value){
						alert("<%=SystemEnv.getHtmlLabelName(19201,user.getLanguage())%>");
                        document.all("itemTypeName_"+j).focus();
                        return false;
                    } 
		        }
           } 
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


</script>




