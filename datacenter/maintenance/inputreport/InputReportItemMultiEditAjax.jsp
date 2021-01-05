<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*,weaver.systeminfo.*,java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportItemManager" class="weaver.datacenter.InputReportItemManager" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
int inprepid = Util.getIntValue(request.getParameter("inprepid"),0);

int languageid = Util.getIntValue(request.getParameter("languageid"), 7);




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
%>

  	  <table class=ListStyle id="oTable" cols=8  border=0 cellspacing=1>
      	<COLGROUP>
		<COL width="5%">
		<COL width="15%">
		<COL width="15%">
		<COL width="30%">
		<COL width="5%">
		<COL width="10%">
		<COL width="15%">
		<COL width="5%">
          <tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(15207,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(15209,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(20826,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(1329,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(20790,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(15208,languageid)%></td>
            <td><%=SystemEnv.getHtmlLabelName(88,languageid)%></td>
          </tr>
<%

			String trClass="DataLight";
			int rowsum=0;

			int itemId=0;
			int itemTypeId=0;
			String itemDspName=null;
			String itemFieldName=null;
			String itemFieldType=null;
			int itemFieldScale=0;
			String itemExcelSheet=null;
			int itemExcelRow=0;
			int itemExcelColumn=0;
			String itemFieldUnit=null;
			//int itemDspOrder=0;
			double itemDspOrder=0;
			String itemGongSi=null;
			int fieldId=0;

			StringBuffer sb=new StringBuffer();
//			sb.append(" select itemId,itemTypeId,itemDspName,itemFieldName,itemFieldType,itemFieldScale,itemExcelSheet,itemExcelRow,itemExcelColumn,itemFieldUnit,itemDspOrder,itemGongSi,workflow_billfield.id as fieldId ")
//			  .append("   from ")
//			  .append("   ( ")
//			  .append("     select t1.itemId,t1.itemTypeId, t1.itemDspName,t1.itemFieldName,t1.itemFieldType,t1.itemFieldScale,t1.itemExcelSheet,t1.itemExcelRow,t1.itemExcelColumn,t1.itemFieldUnit,t1.dspOrder as itemDspOrder,t1.itemGongSi,t2.dspOrder as itemTypeDspOrder,t3.billId ")
//			  .append("       from T_inputReportItem t1,T_inputReportItemType t2,T_inputReport t3 ")
//			  .append("      where t1.itemTypeId=t2.itemTypeId ")
//			  .append("        and t1.inprepId=t3.inprepId  ")
//			  .append("        and t2.inprepId=t3.inprepId ")
//			  .append("        and t3.inprepId=").append(inprepid)
//			  .append("   )itemInfo  left join workflow_billfield on (itemInfo.billId=workflow_billfield.billId and itemInfo.itemFieldName=workflow_billfield.fieldName) ")
//			  .append(" order by itemTypeDspOrder asc,itemDspOrder asc ");

			sb.append("     select t1.itemId,t1.itemTypeId, t1.itemDspName,t1.itemFieldName,t1.itemFieldType,t1.itemFieldScale,t1.itemExcelSheet,t1.itemExcelRow,t1.itemExcelColumn,t1.itemFieldUnit,t1.dspOrder as itemDspOrder,t1.itemGongSi,t2.dspOrder as itemTypeDspOrder ")
			  .append("       from T_inputReportItem t1,T_inputReportItemType t2 ")
			  .append("      where t1.itemTypeId=t2.itemTypeId ")
			  .append("        and t1.inprepId=t2.inprepId  ")
			  .append("        and t1.inprepId=").append(inprepid)
			  .append(" order by itemTypeDspOrder asc,itemDspOrder asc ");

			RecordSet.executeSql(sb.toString());
			while(RecordSet.next()){
				itemId=Util.getIntValue(RecordSet.getString("itemId"),0);
				itemTypeId=Util.getIntValue(RecordSet.getString("itemTypeId"),0);
				itemDspName=Util.null2String(RecordSet.getString("itemDspName"));
				itemFieldName=Util.null2String(RecordSet.getString("itemFieldName"));
				itemFieldType=Util.null2String(RecordSet.getString("itemFieldType"));
				itemFieldScale=Util.getIntValue(RecordSet.getString("itemFieldScale"),0);
				itemExcelSheet=Util.null2String(RecordSet.getString("itemExcelSheet"));
				itemExcelRow=Util.getIntValue(RecordSet.getString("itemExcelRow"),0);
				itemExcelColumn=Util.getIntValue(RecordSet.getString("itemExcelColumn"),0);
				itemFieldUnit=Util.null2String(RecordSet.getString("itemFieldUnit"));
				//itemDspOrder=Util.getIntValue(RecordSet.getString("itemDspOrder"),0);
				itemDspOrder=Util.getDoubleValue(RecordSet.getString("itemDspOrder"),0);
				itemGongSi=Util.null2String(RecordSet.getString("itemGongSi"));
				fieldId=Util.getIntValue(RecordSet.getString("fieldId"),0);
				checkstr+=",itemDspName_"+rowsum+",itemFieldName_"+rowsum;
%>
          <TR class=<%=trClass%>>
			<td  height="23" >
			    <input type='checkbox' name='check_select' value="<%=itemId%>_<%=rowsum%>">
			    <input type="hidden"  name="itemId_<%=rowsum%>"  value="<%=itemId%>">
			    <input type="hidden"  name="fieldId_<%=rowsum%>" value="<%=fieldId%>">
		    </td>
			<td NOWRAP >
			  <input   class=Inputstyle type=text name="itemDspName_<%=rowsum%>" style="width:90%"  value="<%=Util.toScreen(itemDspName,languageid)%>"  onchange="checkinput('itemDspName_<%=rowsum%>','itemDspName_<%=rowsum%>_span');setChange(<%=rowsum%>)">
			  <span id="itemDspName_<%=rowsum%>_span"></span>
			</td>
			<td NOWRAP >
			  <input   class=Inputstyle type=text name="itemFieldName_<%=rowsum%>" style="width:90%"   value="<%=Util.toScreen(itemFieldName,languageid)%>"   onchange="checkinput('itemFieldName_<%=rowsum%>','itemFieldName_<%=rowsum%>_span');setChange(<%=rowsum%>)" onblur="checkKey(this)">
			  <span id="itemFieldName_<%=rowsum%>_span"></span>
			</td>
			<td NOWRAP >
				  <%=InputReportItemManager.getItemFieldTypeSelect(user,itemFieldType,itemFieldScale,itemGongSi,rowsum,itemId,itemIdItemSelectDspMap)%>
		    </td>
		    <td NOWRAP >
			  <input   class=Inputstyle type=text size=3 maxlength=30 name="itemFieldUnit_<%=rowsum%>"  value="<%=Util.toScreen(itemFieldUnit,languageid)%>"  onchange="setChange(<%=rowsum%>)">				  
    		</td>
		    <td NOWRAP > 
				  <%=SystemEnv.getHtmlLabelName(18620,languageid)%> 
				  <input type="text" class="InputStyle" name="itemExcelRow_<%=rowsum%>" size="3" value="<%=itemExcelRow%>" onKeyPress=ItemCount_KeyPress() onchange='checkcount("itemExcelRow_<%=rowsum%>");setChange(<%=rowsum%>)' style='text-align:right;'>
				  <%=SystemEnv.getHtmlLabelName(18621,languageid)%> 
				  <input type="text" class="InputStyle" name="itemExcelColumn_<%=rowsum%>" size="3" value="<%=itemExcelColumn%>" onKeyPress=ItemCount_KeyPress() onchange='checkcount("itemExcelColumn_<%=rowsum%>");setChange(<%=rowsum%>)' style='text-align:right;'>
    		</td>
		    <td NOWRAP >
				  <%=InputReportItemManager.getItemTypeSelect(itemTypeList,itemTypeId,rowsum)%>
    		</td>
		    <td NOWRAP >
                <input class='InputStyle' type='text' size=6 maxlength=6 name='itemDspOrder_<%=rowsum%>'  value = '<%=decimalFormat.format(itemDspOrder)%>' onKeyPress='ItemDecimal_KeyPress("itemDspOrder_<%=rowsum%>",15,2)' onchange='checknumber("itemDspOrder_<%=rowsum%>");checkDigit("itemDspOrder_<%=rowsum%>",15,2);setChange(<%=rowsum%>)' style='text-align:right;'   >
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