<%@page import="weaver.general.Util"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.browser.Browser"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet"/>
<jsp:useBean id="rs_child" class="weaver.conn.RecordSet"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="InputReportItemManager" class="weaver.datacenter.InputReportItemManager" scope="page" />
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="DeptFieldManager0" class="weaver.proj.util.PrjTypeFieldManager" scope="page"/>
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page"/>
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
</head>


<%
	
	if(!HrmUserVarify.checkUserRight("ProjectFreeFeild:Edit", user)){
		response.sendRedirect("/notice/noright.jsp");	
		return;
	}
%>

<%
int strProTypeId = Util.getIntValue(request.getParameter("proTypeId"),0);

int formid = Util.getIntValue(request.getParameter("formid"),0);
String qname = Util.null2String(request.getParameter("flowTitle"));
String fieldname_kwd = Util.null2String(request.getParameter("fieldname_kwd"));
String fieldlabel_kwd = Util.null2String(request.getParameter("fieldlabel_kwd"));
boolean isoracle = (rs.getDBType()).equals("oracle") ;
boolean canDelete = true;
String tablename = "";


boolean canChange = false;
/**
rs.executeSql("select 1 from workflow_base where formid="+formid);
if(rs.getCounts()<=0){//如果表单还没有被引用，字段可以修改。
    canChange = true;
}**/

int rowsum = 0;
String dbfieldnamesForCompare = ",";
/**
String sql = "select t1.*,t2.* from cus_formfield t1, cus_formdict t2 where t1.scope='ProjCustomField'  and t1.fieldid=t2.id "+(strProTypeId>0?" and t1.scopeid='"+strProTypeId+"' ":"")+" order by t1.fieldorder ";

RecordSet.executeSql(sql);
while(RecordSet.next()){
    rowsum++;
    String fieldname = RecordSet.getString("fieldname");
    dbfieldnamesForCompare += fieldname.toUpperCase()+",";
}**/


%>
<%    


	
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>

<script language=javascript>
function showdetaildata(){
	$("#detaildata").load("/proj/ffield/editprjtypeFieldBatchDetail.jsp?proTypeId=<%=strProTypeId %>&qname=<%=qname%>&fieldname_kwd=<%=fieldname_kwd%>&fieldlabel_kwd=<%=fieldlabel_kwd%>",function(){
	}); 
}
</script>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep;
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
DecimalFormat decimalFormat=new DecimalFormat("##0.00");//使用系统默认的格式

%>
<FORM id="frmMain" name="frmMain" action="/proj/ffield/editprjtypeFieldBatch.jsp" method="post" >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
				<input type=button class="e8_btn_top" onclick="addRow();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type=button class="e8_btn_top" onclick="deleteRow();" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
				<!-- input type=button class="e8_btn_top" onclick="copyRow();" value="<%=SystemEnv.getHtmlLabelName(77, user.getLanguage())%>"></input-->
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:'' " >
	
	<wea:layout type="4col">
		<wea:group context="搜索条件">
			<wea:item><%=SystemEnv.getHtmlLabelNames("15024,685",user.getLanguage()) %></wea:item>
			<wea:item><input type="text" id="fieldname_kwd" name="fieldname_kwd" class="InputStyle" value='<%=fieldname_kwd%>' ></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage()) %></wea:item>
			<wea:item><input type="text" id="fieldlabel_kwd" name="fieldlabel_kwd" class="InputStyle" value='<%=fieldlabel_kwd%>' ></wea:item>
		</wea:group>
		<wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_submit" type="button" name="query" value="搜索" onclick="frmMain.submit()"/>
	    		<input class="zd_btn_cancle" type="reset" name="reset" value="重置"/>
	    		<input class="zd_btn_cancle" type="button" name="cancel" id="cancel" value="取消"  />
	    	</wea:item>
	    </wea:group>
		
	</wea:layout>
	
	
</div>
	<input type="hidden" name=src value="addfieldbatch">
	<input type="hidden" name=formid value=<%=formid%>>
	<input type="hidden" value="0" name="recordNum">
	<input type="hidden" value="" name="delids">
	<input type="hidden" value="" name="changeRowIndexs">
	
<div style="display:none">
<table id="hidden_tab" cellpadding='0' width=0 cellspacing='0'>
</table>
</div>


<table  width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top" width="100%">
			<div id="detaildata">
				<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
				<script>showdetaildata();</script>
			<div>
	</td>
</tr>
</table>

 </form>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
<script language=javascript>
rowindex = "<%=rowsum%>";
delids = ",";
changeRowIndexs = ",";
var rowColor="" ;
var paraStr="";
function addRow(){		
    rowColor = getRowBg();
	ncol = oTable.rows[0].cells.length;
	oRow = oTable.insertRow(1);
	oRow.style.height=24;
	setChange(rowindex);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(j);
		oCell.noWrap=true;
		//oCell.style.height=24;
		oCell.style.background=rowColor;
		switch(j){
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
				
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=DeptFieldManager0.getItemFieldTypeSelectForAddMainRow(user)%>";	
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 3:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox'  class=inputstyle name='isopen_"+rowindex+"' value='1' checked>";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }  				
            case 4:
            {
                var oDiv = document.createElement("div");
                var sHtml = "<input type='checkbox'  class=inputstyle onchange='linkageIsopen("+rowindex+")' name='ismand_"+rowindex+"' value='1' >";
                oDiv.innerHTML = sHtml;
                oCell.appendChild(oDiv);
                break;
            }  				
				
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00'  onKeyPress='ItemNum_KeyPress(\"itemDspOrder_"+rowindex+"\")' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)' style='text-align:right;'>";						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
		}
	}
	rowindex = rowindex*1 +1;
	jQuery(oRow).jNice();
}
function checkmaxlength(maxlen,elementname){
    tmpvalue = elementname.value;
    if(tmpvalue < maxlen){
    	alert("<%=SystemEnv.getHtmlLabelName(23548,user.getLanguage())%>");
        elementname.value = maxlen;
    }
}
function checklength(elementname,spanid){
	tmpvalue = elementname.value;
	while(tmpvalue.indexOf(" ") == 0)
		tmpvalue = tmpvalue.substring(1,tmpvalue.length);
	if(tmpvalue!=""&&tmpvalue!=0){
		 spanid.innerHTML='';
	}
	else{
	 spanid.innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 elementname.value = "";
	}
}
function deleteRow(){
	var flag = false;
	var ids = document.getElementsByName('check_select');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
        if(isdel()){
            len = document.getElementsByName("check_select").length;
            var i=0;
            var rowsum1 = 0;
            var deleteFlag = false;
            for(i=len-1; i >= 0;i--){
                if(document.getElementsByName("check_select")[i].checked==true) {
                    checkSelectValue=document.getElementsByName("check_select")[i].value;
                    checkSelectArray=checkSelectValue.split("_");
                    itemId=checkSelectArray[0];
                    if(itemId!='0'){
                        delids +=itemId+",";
                    }
                    changeRowIndexs = changeRowIndexs.replace(checkSelectArray[1]+",","");

                    try{
                    var dbfieldname = document.all("itemDspName_"+checkSelectArray[1]).value.toUpperCase();
                    dbfieldnames = dbfieldnames.replace(","+dbfieldname+",",",");
                    }catch(e){}

                oTable.deleteRow(i+1);
                }
            }
        }
    }else{
        alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return;
    }
}

function copyRow(){
	var copyedRow="";
	len = document.getElementsByName("check_select").length;
	var i=0;
	var countChecked=0;
	for(i=len-1; i >= 0;i--){
			if(document.getElementsByName("check_select")[i].checked==true) {
			    countChecked=countChecked+1;
				checkSelectValue=document.getElementsByName("check_select")[i].value;
				checkSelectArray=checkSelectValue.split("_");
				rowNum=checkSelectArray[1];
				copyedRow+=","+rowNum;
			}
	}
	
	var copyedRowArray =copyedRow.substring(1).split(",");
	fromRow=0;
	if(countChecked<=0){
	  alert("<%=SystemEnv.getHtmlLabelName(31433,user.getLanguage())%>");
	  return false;
	}
	for (loop=copyedRowArray.length-1; loop >=0 ;loop--){
		setChange(rowindex);
		fromRow=copyedRowArray[loop] ;
		if(fromRow==""){
			continue;
		}
		itemDspName=$G("itemDspName_"+fromRow).value;
		itemDspName=trim(itemDspName);
		itemFieldName=$G("itemFieldName_"+fromRow).value;
		itemFieldName=trim(itemFieldName);
		itemFieldType=$G("itemFieldType_"+fromRow).value;
	    isopen=$G("isopen_"+fromRow).value;
		isopen=trim(isopen);
		checkedFlag="";
		if(isopen=='1'){
		  checkedFlag="checked";
		}
	    ismand=$G("ismand_"+fromRow).value;
	    ismand=trim(ismand);
		checkedFlag2="";
		if(ismand=='1'){
			checkedFlag2="checked";
		}


		rowColor = getRowBg();
	  ncol = oTable.rows[0].cells.length;
	  oRow = oTable.insertRow(-1);
	  
	  var rowsLen=oTable.rows.length;
	  if(rowsLen%2==0)
	     oRow.className="DataLight";
	  else
	     oRow.className="DataDark";   

	  for(i=0; i<ncol; i++) {
		oCell = oRow.insertCell(i);
		oCell.noWrap=true;
		oCell.style.height=24;
		//oCell.style.background=rowColor;
		switch(i) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input   type='checkbox' name='check_select' value='0_"+rowindex+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text' size='35' maxlength='30' name='itemDspName_"+rowindex+"' value='"+itemDspName+"' style='width:90%'   onblur=\"checkKey(this);checkinput_char_num('itemDspName_"+rowindex+"');checkinput('itemDspName_"+rowindex+"','itemDspName_"+rowindex+"_span')\"><span id='itemDspName_"+rowindex+"_span'>";
				if(itemDspName==""){
					sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='InputStyle' type='text'  name='itemFieldName_"+rowindex+"' value='"+itemFieldName+"' style='width:90%'   onchange=\"checkinput('itemFieldName_"+rowindex+"','itemFieldName_"+rowindex+"_span')\" onblur=\"checkKey(this)\"><span id='itemFieldName_"+rowindex+"_span'>";
				if(itemFieldName==""){
					sHtml+="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
				}
				sHtml+="</span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=DeptFieldManager0.getItemFieldTypeSelectForAddMainRow(user)%>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				itemFieldType_index = $G("itemFieldType_"+fromRow).value;
				$G("itemFieldType_"+rowindex).value=itemFieldType_index;

				if(itemFieldType_index==3){
					$G("div3_"+rowindex).style.display="inline";
					$G("broswerType_"+rowindex).value=$G("broswerType_"+fromRow).value;
					
					var broswerType_index = $G("broswerType_"+fromRow).value;
					//alert(broswerType_index);
				}
				break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  class=inputstyle name='isopen_"+rowindex+"' value='"+isopen+"' "+checkedFlag+" >";	   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;					
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox'  class=inputstyle onchange='linkageIsopen("+rowindex+")' name='ismand_"+rowindex+"' value='"+ismand+"' "+checkedFlag2+" >";	   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;					
			case 6:
				var oDiv = document.createElement("div");
				var sHtml = " <input class='InputStyle' type='text' size=10 maxlength=7 name='itemDspOrder_"+rowindex+"' value='"+(rowindex*1 +1)+".00' onKeyPress='ItemNum_KeyPress(\"itemDspOrder_"+rowindex+"\")' onchange='checknumber(\"itemDspOrder_"+rowindex+"\");checkDigit(\"itemDspOrder_"+rowindex+"\",15,2)'  style='text-align:right;'>";
						   
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;				
			case 7:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_"+index+"_"+choicerowindex+",childItem_"+index+"_"+choicerowindex+",'_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
		}
		//onChangItemFieldType(i);
	  }
	  rowindex = rowindex*1 +1;
	  jQuery(oRow).jNice();
  	  jQuery(oRow).find("input[type=checkbox][tzCheckbox='true']").each(function(){
		 jQuery(this).tzCheckbox({labels:['','']});
	  });
	}
}

function onChangBroswerType(index){
	broswerType = $G("broswerType_"+index).value;
	if(broswerType==161||broswerType==162){
		//$G("div3_0_"+index).style.display='inline';
		$G("div3_1_"+index).style.display='inline';
		//$G("div3_4_"+index).style.display='none';
		var defineBrowserOptionValue = $G("definebroswerType_"+index).value;
		if(defineBrowserOptionValue==''||defineBrowserOptionValue==0){
		    $G("div3_0_"+index).style.display="inline"
		}else{
		    $G("div3_0_"+index).style.display="none"
		}
	}else if(broswerType==224||broswerType==225){
		$G("div3_1_"+index).style.display='none';
		//$G("div3_4_"+index).style.display='inline';
		var sapbrowserOptionValue = $G("sapbrowser_"+index).value;
		if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
		    $G("div3_0_"+index).style.display="inline"
		}else{
		    $G("div3_0_"+index).style.display="none"
		}
	}else{
		$G("div3_0_"+index).style.display='none';
		$G("div3_1_"+index).style.display='none';
		//$G("div3_4_"+index).style.display='none';
	}
	if(broswerType==165||broswerType==166||broswerType==167||broswerType==168){
		$G("div3_2_"+index).style.display='inline';
	}else{
		$G("div3_2_"+index).style.display='none';
	}
}


function check_formself(thiswins, items){
	if(items == ""){
		return true;
	}
	var itemlist = items.split(",");
	for(var i=0;i<itemlist.length;i++){
		if($G(itemlist[i])){
			var tmpname = $G(itemlist[i]).name;
			var tmpvalue = $G(itemlist[i]).value;
			if(tmpvalue==null){
				continue;
			}
			while(tmpvalue.indexOf(" ") >= 0){
				tmpvalue = tmpvalue.replace(" ", "");
			}
			while(tmpvalue.indexOf("\r\n") >= 0){
				tmpvalue = tmpvalue.replace("\r\n", "");
			}

			if(tmpvalue == ""){
				if($G(itemlist[i]).getAttribute("temptitle")!=null){
					alert("\""+$G(itemlist[i]).getAttribute("temptitle")+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
					return false;
				}else{
					alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>！");
					return false;
				}
			}
		}
	}
	return true;
}


var dbfieldnames = "<%=dbfieldnamesForCompare%>";
function onSave(obj){
	frmMain.action="/proj/ffield/prjFieldOperation.jsp" 
	changeRows = 0;
	var changeRowIndexsArray;
	if(changeRowIndexs!=","){
		changeRowIndexsArray = changeRowIndexs.substring(1,changeRowIndexs.length-1).split(",");
		changeRows = changeRowIndexsArray.length;
	}
	var itemDspNames = ",";
	for(i=0;i<changeRows;i++){//主字段检查
			j=changeRowIndexsArray[i];
			if(j.indexOf("detail") == 0){
				j = j.substring(6, j.length);
			}
			check_String = "itemDspName_"+j+",itemFieldName_"+j;
			if(check_formself(frmMain,check_String)){

				if($G("itemFieldType_"+j).value==3&&($G("broswerType_"+j).value==161||$G("broswerType_"+j).value==162)){
					if($G("definebroswerType_"+j).value==""){//自定义浏览框必选
						alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
						return;
					}
				}
				var itemDspName = $G("itemDspName_"+j).value;
				if(itemDspName=="id"||itemDspName=="requestId"){
					alert(itemDspName+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}
				if(dbfieldnames.indexOf(","+itemDspName.toUpperCase()+",")>=0
					||	itemDspNames.indexOf(","+itemDspName.toUpperCase()+",")>=0){//数据库字段名称不能重复
					alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
					$G("itemDspName_"+j).select();
					return;
				}else{itemDspNames += itemDspName.toUpperCase()+",";}
                
				
			}else{
				return;
			}
	}
	obj.disabled=true;
	document.frmMain.recordNum.value=rowindex;
	document.frmMain.delids.value=delids;
	document.frmMain.changeRowIndexs.value=changeRowIndexs;	
	document.frmMain.submit();
	enableAllmenu();
}

	function checkKey(obj){
		var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
		//以下for oracle.update by cyril on 2008-12-08 td:9722
		keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
		keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
		keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
		keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
		keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
		keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
		keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
		keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
		keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
		keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
		keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
		keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
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
	tmpvalue = $G(elementName).value;

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
    $G(elementName).value=newValue;
}

function setChange(rowIndex){
	if(changeRowIndexs.indexOf(","+rowIndex+",")<0){
		changeRowIndexs+=rowIndex+",";
	}
	try{
	var olddbfieldname = document.all("olditemDspName_"+rowIndex).value.toUpperCase();
	dbfieldnames = dbfieldnames.replace(","+olddbfieldname+",",",");
	}catch(e){}
}


function onChangeChildField(childstr){
	var len = document.frmMain.elements.length;
	if(childstr.indexOf("_detail") == 0){
		childstr = "_"+childstr.substring(7, childstr.length);
	}
    for(i=len-1; i>=0; i--) {
        if(document.frmMain.elements[i].id.indexOf("childItem"+childstr) == 0){
			var inputObj = document.frmMain.elements[i];
			var idstr = document.frmMain.elements[i].id;
			idstr = idstr.substring(("childItem"+childstr).length, idstr.length);
			var spanid = "childItemSpan"+childstr+idstr;
			var spanObj = $G(spanid);
			try{
				inputObj.value = "";
				spanObj.innerHTML = "";
			}catch(e){}
    	}
	}
}
function setChangeChild(childstr){
	var index = getDetailTableIndex(childstr);
	var indexNum = getIndexNum(childstr);
	if(index == -1){
		setChange(indexNum);
	}else{
		setChangeDetail(index, indexNum);
	}
}
function getIndexNum(childstr){
	var indexNum = "";
	var s = childstr.substring(1, childstr.length);
	var index = s.indexOf("_");
	if(index > -1){
		indexNum = s.substring(index+1, s.length);
	}else{
		indexNum = s;
	}
	return indexNum;
}
function getDetailTableIndex(childstr){
	var index = "-1";
	var s = childstr.substring(1, childstr.length);
	var i = s.indexOf("_");
	if(i > -1){
		index = s.substring(6, i);
	}
	return index;
}
function getParentField(childstr){
	var pfieldidsql = "";
	try{
		if(childstr.indexOf("detail")>-1){
			childstr = "_"+childstr.substring(7, childstr.length);
		}
		var pfield = document.all("modifyflag"+childstr).value;
		pfieldidsql = " and id<>"+pfield+" ";
	}catch(e){}
	return pfieldidsql;
}
function getDetailTableName(childstr){
	var tablename = "";
	try{
		if(childstr.indexOf("detail")>-1){
			childstr = "_"+childstr.substring(7, childstr.lastIndexOf("_"));
			tablename = $G("detailTable_name"+childstr).value;
		}
	}catch(e){}
	return tablename;
}

function onShowChildField(spanname, inputname, childstr) {
    isdetail = "0";
    //hasdetail = Instr(childstr, "detail");
    hasdetail=childstr.indexOf("detail");
    if (hasdetail > 0) {
        isdetail = "1";
    }

    pfieldidsql = getParentField(childstr);
    oldvalue = inputname.value;
    //hasdetail = Instr(childstr, "detail");
    hasdetail=childstr.indexOf("detail");
    if (hasdetail > 0) {
        tablename = getDetailTableName(childstr);
        pfieldidsql = pfieldidsql + " && detailtable='" + tablename + "' ";
    }
	url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>" + pfieldidsql + "&isdetail=" + isdetail + "&isbill=1");
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            inputname.value =wuiUtil.getJsonValueByIndex(id,0);
            spanname.innerHTML =wuiUtil.getJsonValueByIndex(id,1);
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
    }
    if (oldvalue != inputname.value) {
        onChangeChildField(childstr);
        setChangeChild(childstr);
    }
}

function onShowChildSelectItem(spanname, inputname, childidstr) {

    cfid = $G("childfieldid" + childidstr).value;
    oldids = inputname.value;
    //url = escape("/workflow/field/SelectItemBrowser.jsp?isbill=1+isdetail=1+childfieldid=" + cfid + "+resourceids=" + oldids);
    url = escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=1&childfieldid=" + cfid + "&resourceids=" + oldids);
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            resourceids =wuiUtil.getJsonValueByIndex(id,0);
            resourcenames =wuiUtil.getJsonValueByIndex(id,1);
            //resourceids = Mid(resourceids, 2, len(resourceids));
            //resourcenames = Mid(resourcenames, 2, len(resourcenames));
            
            resourceids =resourceids.substr(1);
            resourcenames =resourcenames.substr(1);             
            
            inputname.value = resourceids;
            spanname.innerHTML = resourcenames;
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
        setChangeChild(childidstr);
    }
}


function formCheckAll(checked) {
  len = document.getElementsByName('check_select').length;
  var i=0;
  for( i=0; i<len; i++) {
    if (document.getElementsByName("check_select")[i].name=='check_select') {
	  if(!document.getElementsByName("check_select")[i].disabled){
	  	var chkObj = jQuery(document.getElementsByName("check_select")[i]);
	  	if(checked){
	  		chkObj.siblings("span.jNiceCheckbox").addClass("jNiceChecked");
	  	}
	  	else{
	  		chkObj.siblings("span.jNiceCheckbox").removeClass("jNiceChecked");
	  	}
	  	document.getElementsByName("check_select")[i].checked=checked;
	  }
	} 
  } 
}

//字段类型:选择框
function addoTableRow(index){
  setChange(index);
  rowColor1 = getRowBg();
  obj1 = $G("choiceTable_"+index);
  choicerowindex =$G("choiceRows_"+index).value*1+1;
  $G("choiceRows_"+index).value = choicerowindex;
	ncol1 = obj1.rows[0].cells.length;
	oRow1 = obj1.insertRow(-1);
	for(j=0; j<ncol1; j++) {
		oCell1 = oRow1.insertCell(j);
		oCell1.style.height=24;
		oCell1.style.padding="0px";
		//oCell1.style.background=rowColor1;
		switch(j) {
			case 0:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input   type='checkbox' name='chkField' index='"+choicerowindex+"' value='0'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 1:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input class='InputStyle' type='text' size='10' name='field_"+index+"_"+choicerowindex+"_name' style='width=90%'"+
							" onchange=\"checkinput('field_"+index+"_"+choicerowindex+"_name','field_"+index+"_"+choicerowindex+"_span'),setChange("+index+")\">"+
							" <span id='field_"+index+"_"+choicerowindex+"_span'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 2:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input class='InputStyle' type='text' size='4' value = '0.00' onchange='setChange("+index+")' name='field_count_"+index+"_"+choicerowindex+"_name' style='width=90%'"+
							" onKeyPress=ItemNum_KeyPress('field_count_"+index+"_"+choicerowindex+"_name') onchange=checknumber('field_count_"+index+"_"+choicerowindex+"_name')>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 3:
				var oDiv1 = document.createElement("div");
				var sHtml1 = " <input type='checkbox' name='field_checked_"+index+"_"+choicerowindex+"_name' onchange='setChange("+index+")' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				break;
			case 4:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' name='isAccordToSubCom"+index+"_"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<button type='button' class=Browser onClick=\"onShowCatalog(mypath_"+index+"_"+choicerowindex+","+index+","+choicerowindex+")\" name=selectCategory></BUTTON>"
							+ "<span id=mypath_"+index+"_"+choicerowindex+"></span>"
						    + "<input type=hidden id='pathcategory_" + index + "_"+choicerowindex+"' name='pathcategory_" + index + "_"+choicerowindex+"' value=''>"
						    + "<input type=hidden id='maincategory_" + index + "_"+choicerowindex+"' name='maincategory_" + index + "_"+choicerowindex+"' value=''>";

				oDiv1.innerHTML = sHtml1;
				oDiv1.style.display="none";
				oCell1.appendChild(oDiv1);
				break;
			case 5:
				var oDiv1 = document.createElement("div");
				var sHtml1 = "<button type='button' class=\"Browser\" onClick=\"onShowChildSelectItem(childItemSpan_"+index+"_"+choicerowindex+",childItem_"+index+"_"+choicerowindex+",'_"+index+"')\" id=\"selectChildItem_"+index+"_"+choicerowindex+"\" name=\"selectChildItem_"+index+"_"+choicerowindex+"\"></BUTTON>"
							+ "<input type=\"hidden\" id=\"childItem_"+index+"_"+choicerowindex+"\" name=\"childItem_"+index+"_"+choicerowindex+"\" value=\"\" >"
							+ "<span id=\"childItemSpan_"+index+"_"+choicerowindex+"\" name=\"childItemSpan_"+index+"_"+choicerowindex+"\"></span>";
				oDiv1.innerHTML = sHtml1;
				oDiv1.style.display="none";
				oCell1.appendChild(oDiv1);
				break;
		}		
	}
	jQuery(oRow1).jNice();
	choicerowindex++;
}
//字段类型联动
function onChangItemFieldType(rowNum){

	itemFieldType = $G("itemFieldType_"+rowNum).value;
	//console.log("itemFieldType:"+itemFieldType);
	
	if(itemFieldType==1){
		$G("div1_"+rowNum).style.display='inline';
		$G("div1_1_"+rowNum).style.display='inline';
		$G("documentType_"+rowNum).selectedIndex=0;
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
		$G("div3_"+rowNum).style.display='none';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='none';
		$G("div5_5_"+rowNum).style.display='none';
	}
	if(itemFieldType==2){
		$G("div1_"+rowNum).style.display='none';
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='inline';
		$G("div3_"+rowNum).style.display='none';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='none';
		$G("div5_5_"+rowNum).style.display='none';
	}
	if(itemFieldType==3){
		$G("div1_"+rowNum).style.display='none';
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
		$G("div3_"+rowNum).style.display='inline';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='none';
		$G("div5_5_"+rowNum).style.display='none';
	}
	if(itemFieldType==4){
		$G("div1_"+rowNum).style.display='none';
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
		$G("div3_"+rowNum).style.display='none';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='none';
		$G("div5_5_"+rowNum).style.display='none';
	}
    if(itemFieldType==5){
		$G("div1_"+rowNum).style.display='none';
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
		$G("div3_"+rowNum).style.display='none';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='inline';
		$G("div5_5_"+rowNum).style.display='inline';
	}
    if(itemFieldType==6){
        $G("strlength_"+rowNum).value='5';
        $G("imgwidth_"+rowNum).value='100';
        $G("imgheight_"+rowNum).value='100';
		$G("div1_"+rowNum).style.display='none';
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
		$G("div3_"+rowNum).style.display='none';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='none';
		$G("div5_5_"+rowNum).style.display='none';
	}
    if(itemFieldType==7){
		$G("div1_"+rowNum).style.display='none';
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
		$G("div3_"+rowNum).style.display='none';
		$G("div3_0_"+rowNum).style.display='none';
		$G("div3_1_"+rowNum).style.display='none';
		$G("div3_2_"+rowNum).style.display='none';
		//$G("div3_4_"+rowNum).style.display='none';
		$G("div5_"+rowNum).style.display='none';
		$G("div5_5_"+rowNum).style.display='none';
	}	
}

function onuploadtype(obj,index) {
}
function specialtype(obj,index){
}
function onChangType(rowNum){
	itemFieldType = $G("documentType_"+rowNum).value;
	if(itemFieldType==1){
		$G("div1_1_"+rowNum).style.display='inline';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
	}else if(itemFieldType==3){
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='inline';
		$G("div2_"+rowNum).style.display='none';
	}else{
		$G("div1_1_"+rowNum).style.display='none';
		$G("div1_3_"+rowNum).style.display='none';
		$G("div2_"+rowNum).style.display='none';
	}
}
function submitClear(index){
  setChange(index);
  var flag = false;
	var ids = document.getElementsByName('chkField');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
        if(isdel()){
		    deleteRow1(index);
        }
    }else{
        alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
		return;
    }
}
function deleteRow1(index){
	var objTbl = $G("choiceTable_"+index);
	var objChecks=objTbl.getElementsByTagName("INPUT");	
	
	for(var i=objChecks.length-1;i>=0;i--){
		if(objChecks[i].name=="chkField" && objChecks[i].checked) {
			objTbl.deleteRow(objChecks[i].getAttribute("index"));	
			$G("choiceRows_"+index).value = parseInt($G("choiceRows_"+index).value) - 1;
		}
	}	 
}
//必填联动
function linkageIsopen(index){
	var ismand= jQuery("input[name='ismand_"+index+"']:checkbox");
	var isopen= jQuery("input[name='isopen_"+index+"']:checkbox");
	console.log(ismand.attr("checked"));
	if(isopen&&ismand&&ismand.attr("checked")==false){
		isopen.attr("checked", true).next("span").addClass("jNiceChecked");
	}
}
function onBtnSearchClick(){
	jQuery("#fieldname_kwd").val('');
	jQuery("#fieldlabel_kwd").val('');
	jQuery("input[name=query]").trigger('click');
}

$(function(){
	var cptgroupname='<%=ProjectTypeComInfo.getProjectTypename(""+strProTypeId) %>';
	if(cptgroupname==''){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(18630,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});

</script>

</BODY></HTML>
