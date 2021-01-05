<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportItemManager" class="weaver.datacenter.InputReportItemManager" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript" language="javascript" src="/js/jquery/jquery.js"></script>
</head>


<%

int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);

String imagefilename = "/images/hdHRMCard.gif";
//String titlename = Util.toScreen("输入项信息",user.getLanguage(),"0") + itemdspname ;
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage()) +"：" +SystemEnv.getHtmlLabelName(15199,user.getLanguage()) ;
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

List itemTypeList=new ArrayList();
Map itemTypeMap=null;
String tempItemTypeId=null;
String tempItemTypeName=null;
RecordSet.executeSql("select itemTypeId,itemTypeName from T_InputReportItemtype  where inprepId="+inprepid+"  order by dspOrder asc");
while(RecordSet.next()){
	tempItemTypeId=Util.null2String(RecordSet.getString("itemTypeId"));
	tempItemTypeName=Util.null2String(RecordSet.getString("itemTypeName"));
	itemTypeMap=new HashMap();
	itemTypeMap.put("itemTypeId",tempItemTypeId);
	itemTypeMap.put("itemTypeName",tempItemTypeName);
	itemTypeList.add(itemTypeMap);
}
DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式

Map itemIdItemSelectDspMap=new HashMap();
String tempItemId="";
String tempItemSelectDsp="";
String tempItemSelectDspString="";
String hisTempItemId="";
String checkstr="";
RecordSet.executeSql("select t1.itemId,t1.itemDsp   from T_InputReportItemDetail t1,T_InputReportItem t2 where t1.itemId=t2.itemId   and t2.inprepId="+inprepid+" order by t1.itemId asc");
while(RecordSet.next()){
	tempItemId=Util.null2String(RecordSet.getString("itemId"));
	tempItemSelectDsp=Util.null2String(RecordSet.getString("itemDsp"));

	if((!hisTempItemId.equals(tempItemId))&&(!hisTempItemId.equals(""))){
		if(!tempItemSelectDspString.equals("")){
			tempItemSelectDspString=tempItemSelectDspString.substring(1);
			itemIdItemSelectDspMap.put(hisTempItemId,tempItemSelectDspString);
		}
		tempItemSelectDspString=","+tempItemSelectDsp;
	}else{
		tempItemSelectDspString+=","+tempItemSelectDsp;
	}
	hisTempItemId=tempItemId;
}

if(!tempItemSelectDspString.equals("")){
	tempItemSelectDspString=tempItemSelectDspString.substring(1);
	itemIdItemSelectDspMap.put(hisTempItemId,tempItemSelectDspString);
}
int rowsum=0;
StringBuffer sb=new StringBuffer();


sb.append("     select t1.itemId,t1.itemTypeId, t1.itemDspName,t1.itemFieldName,t1.itemFieldType,t1.itemFieldScale,t1.itemExcelSheet,t1.itemExcelRow,t1.itemExcelColumn,t1.itemFieldUnit,t1.dspOrder as itemDspOrder,t1.itemGongSi,t2.dspOrder as itemTypeDspOrder ")
  .append("       from T_inputReportItem t1,T_inputReportItemType t2 ")
  .append("      where t1.itemTypeId=t2.itemTypeId ")
  .append("        and t1.inprepId=t2.inprepId  ")
  .append("        and t1.inprepId=").append(inprepid)
  .append(" order by itemTypeDspOrder asc,itemDspOrder asc ");

RecordSet.executeSql(sb.toString());
while(RecordSet.next()){
	checkstr+=",itemDspName_"+rowsum+",itemFieldName_"+rowsum;
	rowsum++;
}
%>


<FORM id=weaver name=frmMain action="InputReportItemMultiOperation.jsp" method=post >
	<input type="hidden" name=operation>
    <input type="hidden" name=inprepid value=<%=inprepid%>>
    <input type="hidden" value="0" name="recordNum">
    <input type="hidden" value="" name="delids">
    <input type="hidden" value="" name="changeRowIndexs">
	
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
      <td><b><%=SystemEnv.getHtmlLabelName(15199,user.getLanguage())%></b></td>
      <td align=right>
	  <button type="button" class=btn accessKey=A onClick="addRow()"><U>A</U>-<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button> 
	  <button type="button" class=btn accessKey=E onClick="deleteRow()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
      <button type="button" class=btn accessKey=C onClick="copyRow()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%></button>
      </td>
    </TR>
    <TR class=Spacing style="height: 1px"> 
      <TD class=line1 colSpan=2 ></TD>
    </TR>
    </TBODY> 
  </TABLE> 
<div id="itemtypediv"><%=SystemEnv.getHtmlLabelName(19945,user.getLanguage())%></div>

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
changeRowIndexs = ",";
var rowColor="" ;
var paraStr="<%=checkstr%>";
function addRow(){			
    rowColor = getRowBg();
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	oRow.style.height=24;
	setChange(rowindex);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.noWrap=true;
		//oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemDspName_"+rowindex+"' style='width:90%'   onchange=checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')><span id='itemDspName_"+rowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=InputReportItemManager.getItemFieldTypeSelectForAddRow(user)%>";	
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size=3 maxlength=30  name='itemFieldUnit_"+rowindex+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = 
				  " <%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%> "+ 
				  "<input type='text' class='InputStyle' name='itemExcelRow_"+rowindex+"' size='3' value='' onKeyPress=ItemCount_KeyPress() onchange='checkcount(\"itemExcelRow_"+rowindex+"\")' style='text-align:right;'>"+
				  " <%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%> "+ 
				  "<input type='text' class='InputStyle' name='itemExcelColumn_"+rowindex+"' size='3' value='' onKeyPress=ItemCount_KeyPress() onchange='checkcount(\"itemExcelColumn_"+rowindex+"\")' style='text-align:right;'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = "<%=InputReportItemManager.getItemTypeSelectForAddRow(itemTypeList)%>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;	
			case 7:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=6 maxlength=6 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00'  onKeyPress='ItemDecimal_KeyPress(\"itemDspOrder_"+rowindex+"\",15,2)' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)' style='text-align:right;'>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
		}
	}
    paraStr+=",itemDspName_"+rowindex+",itemFieldName_"+rowindex;
	rowindex = rowindex*1 +1;
}

function deleteRow(){

    if(!confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
		return ;
	}
    len = document.getElementsByName("check_select").length;
    var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
            if(document.getElementsByName("check_select")[i].checked==true) {
				checkSelectValue=document.getElementsByName("check_select")[i].value;
				checkSelectArray=checkSelectValue.split("_");
				itemId=checkSelectArray[0];
				if(itemId!='0'){
					delids +=","+ itemId;
				}
                paraStr=(paraStr+",").replace(",itemDspName_"+checkSelectArray[1]+",itemFieldName_"+checkSelectArray[1]+",",",");
                oTable.deleteRow(i+1);
			}
	}
}

function copyRow(){

	var copyedRow="";
	var copyedItemId="";

	len = document.getElementsByName("check_select").length;
	var i=0;
	for(i=len-1; i >= 0;i--) {
			if(document.getElementsByName("check_select")[i].checked==true) {
				checkSelectValue=document.getElementsByName("check_select")[i].value;
				checkSelectArray=checkSelectValue.split("_");
				itemId=checkSelectArray[0];
				rowNum=checkSelectArray[1];
				copyedItemId+=","+itemId;
				copyedRow+=","+rowNum;
			}
	}

	var copyedItemArray =copyedItemId.split(",");
	var copyedRowArray =copyedRow.split(",");
	fromRow=0;
    var gotorow=rowindex;
    for (loop=copyedRowArray.length-1; loop >=0 ;loop--){
		fromRow=copyedRowArray[loop] ;
        if(fromRow==""){
			continue;
		}
        itemId=copyedItemArray[loop];
		itemDspName=$GetEle("itemDspName_"+fromRow).value;
		itemDspName=trim(itemDspName);
		itemFieldName=$GetEle("itemFieldName_"+fromRow).value;
		itemFieldName=trim(itemFieldName);

		itemFieldType=$GetEle("itemFieldType_"+fromRow).value;
		itemFieldUnit=$GetEle("itemFieldUnit_"+fromRow).value;
		itemExcelRow=$GetEle("itemExcelRow_"+fromRow).value;
		itemExcelColumn=$GetEle("itemExcelColumn_"+fromRow).value;
		itemDspOrder=$GetEle("itemDspOrder_"+fromRow).value;



      rowColor = getRowBg();
	  ncol = oTable.cols;
	  oRow = oTable.insertRow();
	  setChange(rowindex);

	  for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.noWrap=true;
		oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemDspName_"+rowindex+"' value='"+itemDspName+"' style='width:90%'   onchange=checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')><span id='itemDspName_"+rowindex+"_span'>";
				if(itemDspName==""){
					sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' value='"+itemFieldName+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'>";
				if(itemFieldName==""){
					sHtml+="<IMG src='/images/BacoError.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				//var sHtml = "<select class='InputStyle' name='itemFieldType_" + rowindex + "'  onChange='onChangItemFieldType("  + rowindex +  ")'></select><div id=divItemFieldScale1_" + rowindex + " style='display:inline' > <%=SystemEnv.getHtmlLabelName(15211,user.getLanguage())%> <input class='InputStyle' type='text' size=3 maxlength=6 id=itemFieldScale1_" + rowindex + " name='itemFieldScale_" + rowindex + "'  value = '"+itemFieldScale+"' style='display:inline' onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemFieldScale1_"+rowindex+")' style='text-align:right;'></div><div id=divItemFieldScale2_" + rowindex + " style='display:none' > <%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%> <input class='InputStyle' type='text' size=3 maxlength=6 id=itemFieldScale2_" + rowindex + " name='itemFieldScale_" + rowindex + "'  value = '"+itemFieldScale+"' disabled onKeyPress='ItemCount_KeyPress()' onchange='checkcount1(itemFieldScale2_"+rowindex+")' style='text-align:right;'></div><div id=divItemGongSi_" + rowindex + " style='display:none' > <%=SystemEnv.getHtmlLabelName(15828,user.getLanguage())%> <input class='InputStyle' type='text' size=10 maxlength=60 id=itemGongSi_" + rowindex + " name='itemGongSi_" + rowindex + "'  value = '"+itemGongSi+"' disabled></div>";
				var sHtml = "<%=InputReportItemManager.getItemFieldTypeSelectForAddRow(user)%>";				
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				//from=$GetEle("itemFieldType_"+fromRow);
				//to=$GetEle("itemFieldType_"+rowindex);
				//copyOptions(from,to);
				$GetEle("itemFieldScale1_"+rowindex).value=$GetEle("itemFieldScale1_"+fromRow).value;
				$GetEle("itemFieldScale2_"+rowindex).value=$GetEle("itemFieldScale2_"+fromRow).value;
				$GetEle("itemGongSi_"+rowindex).value=$GetEle("itemGongSi_"+fromRow).value;
				$GetEle("itemSelectDsp_"+rowindex).value=$GetEle("itemSelectDsp_"+fromRow).value;

				if(itemId>0){
					$GetEle("itemFieldType_"+rowindex).selectedIndex=$GetEle("itemFieldTypeTemp_"+fromRow).selectedIndex;
				}else{
					$GetEle("itemFieldType_"+rowindex).selectedIndex=$GetEle("itemFieldType_"+fromRow).selectedIndex;
				}
				$GetEle("divItemFieldScale1_"+rowindex).style.display=$GetEle("divItemFieldScale1_"+fromRow).style.display;
				$GetEle("divItemFieldScale2_"+rowindex).style.display=$GetEle("divItemFieldScale2_"+fromRow).style.display;
				$GetEle("divItemGongSi_"+rowindex).style.display=$GetEle("divItemGongSi_"+fromRow).style.display;
				$GetEle("divItemSelectDsp_"+rowindex).style.display=$GetEle("divItemSelectDsp_"+fromRow).style.display;

				$GetEle("itemFieldScale1_"+rowindex).disabled = $GetEle("itemFieldScale1_"+fromRow).disabled ;
				$GetEle("itemFieldScale2_"+rowindex).disabled = $GetEle("itemFieldScale2_"+fromRow).disabled ;
				$GetEle("itemGongSi_"+rowindex).disabled = $GetEle("itemGongSi_"+fromRow).disabled ;
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size=3 maxlength=30  name='itemFieldUnit_"+rowindex+"' value='"+itemFieldUnit+"'>"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml =
				  " <%=SystemEnv.getHtmlLabelName(18620,user.getLanguage())%> "+ 
				  "<input type='text' class='InputStyle' name='itemExcelRow_"+rowindex+"' value='"+itemExcelRow+"' size='3' value='' onKeyPress=ItemCount_KeyPress() onchange='checkcount(\"itemExcelRow_"+rowindex+"\")' style='text-align:right;'>"+
				  " <%=SystemEnv.getHtmlLabelName(18621,user.getLanguage())%> "+ 
				  "<input type='text' class='InputStyle' name='itemExcelColumn_"+rowindex+"' value='"+itemExcelColumn+"' size='3' value='' onKeyPress=ItemCount_KeyPress() onchange='checkcount(\"itemExcelColumn_"+rowindex+"\")' style='text-align:right;'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 6:
				var oDiv = document.createElement("div");
				//var sHtml = "<select class='InputStyle' name='itemTypeId_" + rowindex + "' ></select>";
				var sHtml = "<%=InputReportItemManager.getItemTypeSelectForAddRow(itemTypeList)%>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				//from=$GetEle("itemTypeId_"+fromRow);
				//to=$GetEle("itemTypeId_"+rowindex);
				//copyOptions(from,to);
				$GetEle("itemTypeId_"+rowindex).selectedIndex=$GetEle("itemTypeId_"+fromRow).selectedIndex;
				break;	
			case 7:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=6 maxlength=6 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00' onKeyPress='ItemDecimal_KeyPress(\"itemDspOrder_"+rowindex+"\",15,2)' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)'  style='text-align:right;'>";
						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
		}
	  }
      paraStr+=",itemDspName_"+rowindex+",itemFieldName_"+rowindex;
	  rowindex = rowindex*1 +1;
	}
    if(copyedRowArray.length>0) $GetEle("itemDspName_"+gotorow).focus();
}

function onChangItemFieldType(rowNum){

		itemFieldType = $GetEle("itemFieldType_"+rowNum).value;

		if(itemFieldType==1){
			$GetEle("divItemFieldScale1_"+rowNum).style.display='inline';
			$GetEle("divItemFieldScale2_"+rowNum).style.display='none';
			$GetEle("divItemGongSi_"+rowNum).style.display='none';
			$GetEle("divItemSelectDsp_"+rowNum).style.display='none';

			$GetEle("itemFieldScale1_"+rowNum).disabled = false ;
			$GetEle("itemFieldScale2_"+rowNum).disabled = true ;
			$GetEle("itemGongSi_"+rowNum).disabled = true ;
		}
		if(itemFieldType==2){
			$GetEle("divItemFieldScale1_"+rowNum).style.display='none';
			$GetEle("divItemFieldScale2_"+rowNum).style.display='none';
			$GetEle("divItemGongSi_"+rowNum).style.display='none';
			$GetEle("divItemSelectDsp_"+rowNum).style.display='none';

			$GetEle("itemFieldScale1_"+rowNum).disabled = true ;
			$GetEle("itemFieldScale2_"+rowNum).disabled = true ;
			$GetEle("itemGongSi_"+rowNum).disabled = true ;
		}
		if(itemFieldType==3){
			$GetEle("divItemFieldScale1_"+rowNum).style.display='none';
			$GetEle("divItemFieldScale2_"+rowNum).style.display='inline';
			$GetEle("divItemGongSi_"+rowNum).style.display='none';
			$GetEle("divItemSelectDsp_"+rowNum).style.display='none';

			$GetEle("itemFieldScale1_"+rowNum).disabled = true ;
			$GetEle("itemFieldScale2_"+rowNum).disabled = false ;
			$GetEle("itemGongSi_"+rowNum).disabled = true ;
		}
		if(itemFieldType==4){
			$GetEle("divItemFieldScale1_"+rowNum).style.display='none';
			$GetEle("divItemFieldScale2_"+rowNum).style.display='none';
			$GetEle("divItemGongSi_"+rowNum).style.display='none';
			$GetEle("divItemSelectDsp_"+rowNum).style.display='inline';

			$GetEle("itemFieldScale1_"+rowNum).disabled = true ;
			$GetEle("itemFieldScale2_"+rowNum).disabled = true ;
			$GetEle("itemGongSi_"+rowNum).disabled = true ;
		}
        if(itemFieldType==5){
			$GetEle("divItemFieldScale1_"+rowNum).style.display='none';
			$GetEle("divItemFieldScale2_"+rowNum).style.display='inline';
			$GetEle("divItemGongSi_"+rowNum).style.display='inline';
			$GetEle("divItemSelectDsp_"+rowNum).style.display='none';

			$GetEle("itemFieldScale1_"+rowNum).disabled = true ;
			$GetEle("itemFieldScale2_"+rowNum).disabled = false ;
			$GetEle("itemGongSi_"+rowNum).disabled = false ;
		}
        if(itemFieldType==6){
			$GetEle("divItemFieldScale1_"+rowNum).style.display='none';
			$GetEle("divItemFieldScale2_"+rowNum).style.display='none';
			$GetEle("divItemGongSi_"+rowNum).style.display='none';
			$GetEle("divItemSelectDsp_"+rowNum).style.display='none';

			$GetEle("itemFieldScale1_"+rowNum).disabled = true ;
			$GetEle("itemFieldScale2_"+rowNum).disabled = true ;
			$GetEle("itemGongSi_"+rowNum).disabled = true ;
		}
	
}

function onSave(obj){
    if(checkSave()){
        obj.disabled=true;
        document.frmMain.recordNum.value=rowindex;
		document.frmMain.delids.value=delids;
		document.frmMain.changeRowIndexs.value=changeRowIndexs;
		document.frmMain.operation.value="edit";
		document.frmMain.submit();
	}
}

function checkSave(){
//	if(!check_form(document.frmMain,paraStr)){
//		return false;
//	}
    var parastrarray=paraStr.split(",");
    for(var i=0;i<parastrarray.length;i++){
        temp=trim(parastrarray[i]);
        if(temp.length>0) if(trim($GetEle(temp).value)==""){alert("必要信息不完整！");$GetEle(temp).focus();return false;}
    }
    var itemFieldNameExistString=",";
	var tempItemFieldName="";
    for(i=0;i<rowindex;i++){
		if($GetEle("itemFieldName_"+i)!=null){

			tempItemFieldName=trim($GetEle("itemFieldName_"+i).value);

			if(itemFieldNameExistString.indexOf(","+tempItemFieldName+",")!=-1){
				alert("<%=SystemEnv.getHtmlLabelName(19201,user.getLanguage())%>");
				$GetEle("itemFieldName_"+i).focus();
				return false;
			}else{
				itemFieldNameExistString+=tempItemFieldName+",";
			}
	   }
    }
	
	return true;
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

function setChange(rowIndex){
	if(changeRowIndexs.indexOf(","+rowIndex+",")<0){
		changeRowIndexs+=rowIndex+",";
	}
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

function getItemtypeJs(inprepid){
	jQuery.ajax({
		url : "/datacenter/maintenance/inputreport/InputReportItemMultiEditAjax.jsp",
		type : "post",
		processData : false,
		data : "languageid=<%=user.getLanguage()%>&inprepid="+inprepid,
		dataType : "html",
		success: function do4Success(msg){
			$GetEle("itemtypediv").innerHTML = msg;
		}
	});
}
getItemtypeJs('<%=inprepid%>');

</script>




