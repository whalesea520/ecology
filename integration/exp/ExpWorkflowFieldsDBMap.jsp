<%@ page import="weaver.general.Util" %>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="weaver.workflow.mode.FieldInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.expdoc.ExpUtil"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("intergration:expsetting", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%> 
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<!--新增  QC284050-->
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
	<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
	<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />

	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	<!--新增  QC284050-->


<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />



</head>
<%
ExpUtil eu=new ExpUtil();
//String dbProOptions=eu.getDBProOptions("exp_dbdetail","name","id");

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
String needfav ="1";
String needhelp ="";
String tiptitle = "";
//String typename = Util.null2String(request.getParameter("typename"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
String isDialog = Util.null2String(request.getParameter("isdialog"));

String id = Util.null2String(request.getParameter("id"));//id
String workflowid="";
String maintable="";
String detailtable="";
String dbProid="";
String dbprosetingid="";

RecordSet rs=new RecordSet();
String sql="select d.id as dbProid,d.maintable as maintable,d.detailtable as detailtable,a.workflowid as workflowid,c.id as dbprosetingid from exp_workflowDetail a,exp_ProList b,exp_DBProSettings c,exp_dbdetail d where a.expid=b.id and b.Proid=c.id and c.regitDBId=d.id and a.id='"+id+"'";
rs.executeSql(sql);

if(rs.next()){
	workflowid=rs.getString("workflowid");
	maintable=rs.getString("maintable");
	detailtable=rs.getString("detailtable");
	dbProid=rs.getString("dbProid");
	dbprosetingid=rs.getString("dbprosetingid");
	
}


ArrayList arrayfieldids=new ArrayList();
ArrayList arrayvalueTypes=new ArrayList();
ArrayList arrayexpfieldnames=new ArrayList();
ArrayList arrayexpfieldtypes=new ArrayList();

sql="select * from exp_workflowFieldDBMap  where rgworkflowid='"+id+"' order by id";
rs.executeSql(sql);
while(rs.next()){
	String tempFieldid=Util.null2String(rs.getString("fieldid"));
	String tempExpFieldName=Util.null2String(rs.getString("expfieldname"));
	String tempExpFieldType=Util.null2String(rs.getString("expfieldtype"));
	String tempValueType=Util.null2String(rs.getString("valueType"));
	if(!tempFieldid.equals("")){
		arrayfieldids.add(tempFieldid);
		arrayvalueTypes.add(tempValueType);
		arrayexpfieldnames.add(tempExpFieldName);
		arrayexpfieldtypes.add(tempExpFieldType);
	}
}


weaver.workflow.workflow.WorkflowComInfo workflowcominfo=new WorkflowComInfo();

String formid=workflowcominfo.getFormId(workflowid);
String isbill=workflowcominfo.getIsBill(workflowid);

FieldInfo fieldinfo=new FieldInfo();
fieldinfo.GetManTableField(Util.getIntValue(formid,-1),Util.getIntValue(isbill,-1),user.getLanguage());

ArrayList mainTableFieldNames=fieldinfo.getManTableFieldNames();
ArrayList mainTableFieldFieldNames=fieldinfo.getManTableFieldFieldNames();

ArrayList mainTableFields=fieldinfo.getManTableFields();


sql="select fieldid,valueType from exp_workflowFieldDBMap  where rgworkflowid='"+id+"'";
rs.executeSql(sql);
Map fieldidToRules=new HashMap();
while(rs.next()){
	String tempFieldid=Util.null2String(rs.getString("fieldid"));
	String tempValueType=Util.null2String(rs.getString("valueType"));
	if(!tempFieldid.equals("")){
		fieldidToRules.put(tempFieldid,tempValueType);
	}
}

//QC284050
	sql="select * from exp_dbdetail where id='"+dbProid+"'";
	rs.executeSql(sql);
	String datasourceid =  "";
	if(rs.next()){
		datasourceid = Util.null2String(rs.getString("resoure"));
	}
//QC284050

String outFieldInf=eu.IniDBProFields_new(dbProid,dbprosetingid);
if(outFieldInf.equals("")){
outFieldInf=" # # # # # # # # #";
}
String[] outFieldInfArray=outFieldInf.split("#");



rs.executeSql("SELECT * FROM exp_wfDBMainFixField where talbetype='0' and rgworkflowid='"+id+"' order by id");
StringBuffer tempMainFixDatas = new StringBuffer();

while (rs.next()) 
{
    String expfieldname= Util.null2String(rs.getString("expfieldname"));
    String expfieldtype= Util.null2String(rs.getString("expfieldtype"));
    String value= Util.null2String(rs.getString("value"));
    tempMainFixDatas.append("[");
	tempMainFixDatas.append("{name:'mfixfieldName',value:'"+expfieldname +"',label:'"+ expfieldname  +  "',iseditable:true,type:'browser'},");//QC284050
    tempMainFixDatas.append("{name:'mfixfieldtypespan',value:'"+expfieldtype+"',iseditable:false,type:'span'},");
    tempMainFixDatas.append("{name:'mfixfieldtype',value:'"+expfieldtype+"',iseditable:true,type:'input|hidden'},");
    tempMainFixDatas.append("{name:'mainfixValue',value:'"+value +"',iseditable:true,type:'input'}");
    tempMainFixDatas.append("],");
}
String mainFixDatas = tempMainFixDatas.toString();
if(!"".equals(mainFixDatas))
{
	mainFixDatas = mainFixDatas.substring(0,(mainFixDatas.length()-1));
}
mainFixDatas = "["+mainFixDatas+"]";


rs.executeSql("SELECT * FROM exp_wfDBMainFixField where talbetype='1' and rgworkflowid='"+id+"' order by id");
StringBuffer tempDetailFixDatas = new StringBuffer();

while (rs.next()) 
{
    String expfieldname= Util.null2String(rs.getString("expfieldname"));
    String expfieldtype= Util.null2String(rs.getString("expfieldtype"));
    String value= Util.null2String(rs.getString("value"));
    tempDetailFixDatas.append("[");
	tempDetailFixDatas.append("{name:'dtfixfieldName',value:'"+expfieldname +"',label:'"+ expfieldname  + "',iseditable:true,type:'browser'},");//QC284050
    tempDetailFixDatas.append("{name:'dtfixfieldtypespan',value:'"+expfieldtype+"',iseditable:false,type:'span'},");
    tempDetailFixDatas.append("{name:'dtfixfieldtype',value:'"+expfieldtype+"',iseditable:true,type:'input|hidden'},");
    tempDetailFixDatas.append("{name:'dtfixValue',value:'"+value +"',iseditable:true,type:'input'}");
    tempDetailFixDatas.append("],");
}
String detailFixDatas = tempDetailFixDatas.toString();
if(!"".equals(detailFixDatas))
{
	detailFixDatas = detailFixDatas.substring(0,(detailFixDatas.length()-1));
}
detailFixDatas = "["+detailFixDatas+"]";


%>
<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<%if(HrmUserVarify.checkUserRight("intergration:expsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<script language=javascript>
<%
if(msgid!=-1){
%>
top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(msgid,user.getLanguage())%>!');
<%}%>
</script>
			<FORM id=weaver name=frmMain action="/integration/exp/ExpWorkflowDetailOperation.jsp?isdialog=1"" method=post>
				<input class=inputstyle type=hidden name="id" value="<%=id%>">
				<input class=inputstyle type=hidden name="backto" value="">
				<input class=inputstyle type="hidden" name=operation value="editDB">

				<wea:layout attributes="{'expandAllGroup':'false'}">
					<!-- 流程主表字段转换规则-->
					<wea:group context="<%=SystemEnv.getHtmlLabelName(125762,user.getLanguage())%>"
						attributes="{'itemAreaDisplay':'none','groupSHBtnDisplay':'none'}">
					</wea:group>
				</wea:layout>

				<wea:layout>
					<!-- 归档库主表固定值设置-->
					<wea:group context=""
						attributes="{'groupDisplay':'none','groupSHBtnDisplay':'none'}">
						<wea:item attributes="{'isTableList':'true','colspan':'2'}">
							<table class="ListStyle" cellSpacing="0" cellpadding="2">
								<colgroup>
									<col width="64%">
									<col width="32%">
								</colgroup>
								<thead>
									<tr class="HeaderForXtalbe">
										<th width="64%" style="text-align: center;">
											<%=SystemEnv.getHtmlLabelName(34130,user.getLanguage())%><!-- 流程表单 -->
										</th>
										<th width="32%" style="text-align: center;">
											<%=SystemEnv.getHtmlLabelName(125763,user.getLanguage())%><!-- 归档库 -->
										</th>
									</tr>
									</tr>
								</thead>
							</table>
						</wea:item>
						<wea:item attributes="{'isTableList':'true','colspan':'2'}">
							<wea:layout type="table" attributes="{cols:6,cws:16%}">
								<wea:group context=""
									attributes="{'groupDisplay':'none','groupSHBtnDisplay':'none','isTableList':'true'}">
									<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item><!-- 字段显示名 -->
									<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(124937,user.getLanguage())%></wea:item><!-- 数据库字段名称 -->
									<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></wea:item><!-- 字段类型 -->
									<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%></wea:item><!-- 转换规则 -->
									<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item><!-- 字段名称 -->
									<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></wea:item><!-- 字段类型 -->

									<% 
		if(mainTableFieldNames!=null){
		for(int i=0;i<mainTableFieldNames.size();i++){
		String tempfield=(String)mainTableFields.get(i);
		String[] temp=tempfield.split("_");
		String fieldid=temp[0].substring(temp[0].indexOf("field")+5);
		weaver.general.FormFieldTransMethod formfieldtransmethod=new FormFieldTransMethod();
		String displayType="";
		if(temp[2].equals("5")&&temp[1].equals("1")){
			displayType=formfieldtransmethod.getHTMLType(temp[2],user.getLanguage()+"");
		}else{
			displayType=formfieldtransmethod.getHTMLType(temp[2],user.getLanguage()+"")+"-"+formfieldtransmethod.getFieldType(temp[1],temp[2]+"+"+fieldid+"+"+user.getLanguage()+"");	
		}
		
		%>
									<wea:item><%=mainTableFieldNames.get(i)%>
										<input type="hidden" name="mainFieldNames"
											value="<%=mainTableFieldNames.get(i)%>">
										<input type="hidden" name="mainFieldIds" value="<%=fieldid%>">
										<input type="hidden" name="fieldhtmltypes"
											value="<%=temp[2]%>">
										<input type="hidden" name="types" value="<%=temp[1]%>">
										<input type="hidden" name="mainfileddbnames"
											value="<%=mainTableFieldFieldNames.get(i)%>">
									</wea:item>

									<wea:item><%=mainTableFieldFieldNames.get(i)%></wea:item>
									<wea:item><%=displayType%></wea:item>
									<wea:item>
										<%out.print(eu.getExpWorkflowFieldRulseSelect(fieldid,temp[2],temp[1]));%>
		<%if(temp[2].equals("5")&&temp[1].equals("1")){
		 %>
		  <div id="selectValueConvert_<%=fieldid%>" style="display:none">
		  	<table class="ListStyle" cellSpacing="0" cellpadding="2">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<thead >
									<tr >
										<th  style="text-align: left;">
										<font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125764,user.getLanguage())%></font><!-- 选择文字 -->
										</th>
										<th  style="text-align:center">
										<font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125765,user.getLanguage())%></font><!-- 转换值 -->
										</th>
									</tr>
									
								</thead>
								 <%
			 String[] tempvalues=formfieldtransmethod.getFieldType(temp[1],temp[2]+"+"+fieldid+"+"+user.getLanguage()+"").split("<br>");
				for(int t=0;t<tempvalues.length;t++){
		     %>
								<tr>
								<td><%=tempvalues[t]%><input  type="hidden" name="selectValue_<%=fieldid%>" value="<%=tempvalues[t]%>"></td>
								<td style="text-align:center">
								<input  type="text" name="selectValueTo_<%=fieldid%>" value="<%=eu.getSelectConvertValue(id,"1",fieldid,tempvalues[t])%>">
								</td>
								</tr>
						<%}%>
							</table>
		   	</div>
		  	 <%}%>
		  	 <%if(temp[2].equals("4")&&temp[1].equals("1")){  //check框
		 %>
		  <div id="checkValueConvert" >
		  	<table class="ListStyle" cellSpacing="0" cellpadding="2">
								<colgroup>
									<col width="50%">
									<col width="50%">
								</colgroup>
								<thead >
									<tr >
										<th  style="text-align: left;">
										        <font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelNames("172,602",user.getLanguage())%></font><!-- 选择状态 -->
										</th>
										<th  style="text-align:center">
										<font style="font-weight:normal;"><%=SystemEnv.getHtmlLabelName(125765,user.getLanguage())%></font><!-- 转换值 -->
										</th>
									</tr>
									
								</thead>
								<tr>
								<td style="text-align: left;"><!-- 已勾选 --><%=SystemEnv.getHtmlLabelName(125766,user.getLanguage())%><input  type="hidden" name="checkedValue_<%=fieldid%>" value="1"></td>
								<td style="text-align:center">
								<input  type="text" name="checkedValueTo_<%=fieldid%>" value="<%=eu.getSelectConvertValue(id,"1",fieldid,"1")%>">
								</td>
								</tr>
								<tr>
								<td style="text-align: left;"><!-- 不勾选 --><%=SystemEnv.getHtmlLabelName(125767,user.getLanguage())%><input  type="hidden" name="uncheckedValue_<%=fieldid%>" value="0"></td>
								<td style="text-align:center">
								<input  type="text" name="uncheckedValueTo_<%=fieldid%>" value="<%=eu.getSelectConvertValue(id,"1",fieldid,"0")%>">
								</td>
								</tr>
							</table>
		   	</div>
		  	 <%}%>
									</wea:item>
									<wea:item>
										<brow:browser name="expfieldName" viewType="0" hasBrowser="true" hasAdd="false"
													  isMustInput="1" completeUrl="/data.jsp"   linkUrl="#"  isSingle="true" hasInput="false"
													  getBrowserUrlFn="onShowTableFieldValue" _callback="onSetTableField" _callbackParams="dml" >
										</brow:browser>
									</wea:item>
									<wea:item>
										<span name='expfieldtypespan'></span>
										<INPUT type='hidden' name='expfieldtype' value=''>
									</wea:item>
									<% 
		}
		}
		%>

								</wea:group>
							</wea:layout>
						</wea:item>
					</wea:group>
				</wea:layout>

				
					<wea:layout>
						<!-- 归档库主表固定值设置-->
						<wea:group context="<%=SystemEnv.getHtmlLabelName(125768,user.getLanguage())%>"
							attributes="{'samePair':'SetInfo1','groupOperDisplay':'none','itemAreaDisplay':'block',id='mainheader'}">
							<wea:item type="groupHead">
								<div style='float: right;'>
									<input id='addbutton' type="button"
										title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)"
										onClick="addRow('mainFields')" ACCESSKEY="A" class="addbtn" />
									<input type="button"
										title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)"
										onClick="removeRow('mainFields')" ACCESSKEY="G" class="delbtn" />
								</div>
							</wea:item>
							<wea:item attributes="{'colspan':'2','isTableList':'true'}">
								<div id="mainFields">
								</div>
							</wea:item>
						</wea:group>
					<%if(!"".equals(detailtable)){ %>
						<!-- 归档库明细表固定值设置-->
						<wea:group context="<%=SystemEnv.getHtmlLabelName(125769,user.getLanguage())%>"
							attributes="{'samePair':'SetInfo1','groupOperDisplay':'none','itemAreaDisplay':'block',id='detailheader'}">
							<wea:item type="groupHead">
								<div style='float: right;'>
									<input id='addbutton' type="button"
										title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>(ALT+A)"
										onClick="addRow('detailFields')" ACCESSKEY="A" class="addbtn" />
									<input type="button"
										title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>(ALT+G)"
										onClick="removeRow('detailFields')" ACCESSKEY="G"
										class="delbtn" />
								</div>
							</wea:item>
							<wea:item attributes="{'colspan':'2','isTableList':'true'}">
								<div id="detailFields">
								</div>
							</wea:item>
							<wea:item></wea:item>
							<wea:item></wea:item>
						</wea:group>
						<%} %>
					</wea:layout>
				
				<br>
				<%if("1".equals(isDialog)){ %>
				<input type="hidden" name="isdialog" value="<%=isDialog%>">
				<%} %>
			</form>

			<script language="javascript">


var group=null;
var group_dt=null;
jQuery(document).ready(function(){
	//changeFileSaveType($("#FileSaveType"));
   // changeRegitDBId();
   // reshowCheckBox();
    //changeEncryptType('');
    //onChangeTypeFun('');
    //onInitTypeChange();
    //jQuery(".optionhead").hide();
    //jQuery(".tablecontainer").css("padding-left","0px");
   changeAllmfixfieldNames();
   changeAlldtfixfieldNames();
   iniwfMainInf();
   //QC284050
    jQuery("#mainFields").empty();
    group=new WeaverEditTable(optionmain);
    jQuery("#mainFields").append(group.getContainer());
    var params=group.getTableSeriaData();

    jQuery("#detailFields").empty();
    group_dt=new WeaverEditTable(optiondt);
    jQuery("#detailFields").append(group_dt.getContainer());
    var params_dt=group_dt.getTableSeriaData();


    jQuery("#mainTableSpan").html(mainTalbeName);
    jQuery("#dtTableSpan").html(detailTableName);
    
    <%
if(mainTableFieldNames!=null&&fieldidToRules.size()>0){
	for(int i=0;i<mainTableFieldNames.size();i++){
	String tempfield=(String)mainTableFields.get(i);
	String[] temp=tempfield.split("_");
	String fieldid=temp[0].substring(temp[0].indexOf("field")+5);
	%>
	 $("#fieldRules_<%=fieldid%>").val("<%=fieldidToRules.get(fieldid)%>");
	 	//解绑，绑定
	jQuery("#fieldRules_<%=fieldid%>").selectbox("detach");
 	__jNiceNamespace__.beautySelect("#fieldRules_<%=fieldid%>");
 	 $("#fieldRules_<%=fieldid%>").change();
 
	<%
	}
}
	
%>
});
function iniwfMainInf() {

<%
if(arrayfieldids!=null){
for(int j=0;j<arrayfieldids.size();j++){
%>
   var tempmainFieldId="<%=arrayfieldids.get(j)%>";
  
   var len= $("*[name='mainFieldIds']").length;
    for(var i=0;i<len;i++){
     var v=$("*[name='mainFieldIds']").eq(i).val();
     if(tempmainFieldId==v){
    	 var temprulename="fieldRules_"+tempmainFieldId;
     	 var objrule= $("*[name="+temprulename+"]").eq(0);
     	  objrule.val("<%=arrayvalueTypes.get(j)%>");
     	  //解绑，绑定
		 $(objrule).selectbox("detach");
 		__jNiceNamespace__.beautySelect(objrule);
     	   var objrule= $("*[name='expfieldName']").eq(i);		   
     	   objrule.val("<%=arrayexpfieldnames.get(j)%>");
		   $(objrule).next('span').text("<%=arrayexpfieldnames.get(j)%>");
     	    //$(objrule).selectbox("detach");
 		__jNiceNamespace__.beautySelect(objrule);
     	   objrule= $("*[name='expfieldtypespan']").eq(i);
     	   objrule.html("<%=arrayexpfieldtypes.get(j)%>");
     	   objrule= $("*[name='expfieldtype']").eq(i);
     	   objrule.val("<%=arrayexpfieldtypes.get(j)%>");
       
     }
    }
    <%
}
}
%>
}

function changeAllmfixfieldNames() {
   var len= $("*[name='mfixfieldName']").length;
    for(var i=0;i<len;i++){
     var obj=$("*[name='mfixfieldName']").eq(i);
      checkinput1(obj);
    }
}
function changeAlldtfixfieldNames() {
   var len= $("*[name='dtfixfieldName']").length;
    for(var i=0;i<len;i++){
     var obj=$("*[name='dtfixfieldName']").eq(i);
      checkinput1(obj);
    }
}
function submitData() {
	//var checkvalue = "";
	//var typenametmp = document.getElementById("typename").value;
	//var encrypttype = document.getElementById("encrypttype").value;
	
	//if(typenametmp == 1) {
		//checkvalue = "sysid,name,iurl,ourl,accountcode";
	//} else {
		//checkvalue = "sysid,name,iurl,ourl";
	//}
	//if(encrypttype == 2) {
		//checkvalue += ",encryptclass,encryptmethod";
	//}
	
	var len= $("input[name='mfixfieldName']").length;
  
	for(k =0 ; k < len; k++) {
	 //alert($("*[name='mfixfieldName']").eq(k).val());
		if($("input[name='mfixfieldName']").eq(k).val() == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125770,user.getLanguage())%>");//归档库主表固定值设置字段名称,内容不完整
			return;
		}	
	}
	len= $("input[name='dtfixfieldName']").length;
   for(k =0 ; k < len; k++) {
		if($("input[name='dtfixfieldName']").eq(k).val() == "") {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125771,user.getLanguage())%>");//归档库明细表固定值设置字段名称,内容不完整
			return;
		}	
	}
	
    frmMain.submit();
   
}
function doBack()
{
	//document.location.href="/interface/outter/OutterSys.jsp?typename=""";
}
function changeEncryptType(val)
{
	if(val=="1")
	{
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").show();
		$(".isencrypt").show();
		$(".maybelast").attr("colspan","1");
		
	}
	else if(val=="2")
	{
		showEle("encrypt1");
		showEle("encrypt2");
		$(".encryptcode").hide();
		$(".isencrypt").show();
		$(".maybelast").attr("colspan","2");
	}
	else
	{
		hideEle("encrypt1");
		hideEle("encrypt2");
		$(".encryptcode").hide();
		$(".isencrypt").hide();
		$(".maybelast").attr("colspan","3");
	}
}
	
function onTypeChange(obj){
	if(obj.value==0){
		obj.nextSibling.nextSibling.style.display='inline-block';
	}
    else{
		obj.nextSibling.nextSibling.style.display='none';
	}
}
function onInitTypeChange(){
	var paramtypes = jQuery("select[name='paramtypes']");
    jQuery.each(paramtypes, function(i, n){
      var obj = n;
      //alert( "Item #" + i + ": " + n +" obj.value : "+obj.outerHTML);
      onTypeChange(obj);
   });
}

function onChangeTypeFun(obj){
	
}
function changeParamValue(obj)
{

var ck=$(obj).attr("checked");

	if(obj.checked){
		$(obj).val("1");
		$(obj).closest("td").find("input").eq(1).val("1")
	}	
	else
	{
	 $(obj).val("0");
	 $(obj).closest("td").find("input").eq(1).val("0")
	}
	var temp= $(obj).closest("td").find("input").eq(1).val();
	
	
}

function onBack()
{
	parentWin.closeDialog();
}

function onChangeRequestType(obj){

//var radiovar=document.getElementsByName("urlencodeflag");
//alert(radiovar.length);
	if(obj == "1") {  //get
	
	 jQuery("#urlencodeflag1").trigger("checked",true);
	  jQuery("#encodespan").show();
	 
	
    } else { 
	 jQuery("#urlencodeflag0").trigger("checked",true);
	  jQuery("#encodespan").hide();
	 
	}
	//alert($("#urlencodeflag").val());
}

  function isimag(obj){   
	
	  var file = obj.value.match(/[^\/\\]+$/gi)[0]; 
	  var rx = new RegExp('\\.(gif)$','gi');
	   var rx1 = new RegExp('\\.(png)$','gi');
	    var rx2 = new RegExp('\\.(jpg)$','gi');
		 var rx3 = new RegExp('\\.(jpeg)$','gi');
		  var rx4 = new RegExp('\\.(ico)$','gi');
		    var rx5 = new RegExp('\\.(bmp)$','gi');
	  if(file&&!file.match(rx)&&!file.match(rx1)&&!file.match(rx2)&&!file.match(rx3)&&!file.match(rx4)&&!file.match(rx5))
		  {    
		  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82744,user.getLanguage())%>.gif,png,jpg,jpeg,ico,bmp<%=SystemEnv.getHtmlLabelName(82745,user.getLanguage())%>!");
		  //alert("选择的文件不是图片文件，请选择图片文件！");       //重新构建input file       
	
		var file=document.getElementById("urllinkimagid");
		file.outerHTML=file.outerHTML;
	 
			}   
	  }
	  
function showFre(mode)
{
	for(i = 0; i < 4; i++)
	{
		document.getElementById("show_" + i).className = "vis4";
	}
	if("9" != mode)
	{
		document.getElementById("show_" + mode).className = "vis3";
	}
}

function addRow(v)
{
	if("mainFields" == v)
	{
		group.addRow(null);
	} else if("detailFields" == v) {
		group_dt.addRow(null);
	} else {
		group.addRow(null);
	}
}
function removeRow(v)
{

        if("mainFields" == v)
		{
			var count = 0;//删除数据选中个数
			jQuery("#"+v+" input[name='mainparamid']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
			});
	
			if(count==0){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
			}else{
				group.deleteRows();
			}
		} else if("detailFields" == v) {
			var count = 0;//删除数据选中个数
			jQuery("#"+v+" input[name='dtparamid']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
			});
	
			if(count==0){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
			}else{
				group_dt.deleteRows();
			}
			
		} 
	
}

var mailTableOptions="";
var detailTableOptions="";
var mailTableFiledNames="";
var mailTableFiledTypes="";
var detailTableFiledNames="";
var detailTableFiledTypes="";
var mainTalbeName="";
var	detailTableName="";
  <%
if(outFieldInfArray!=null&&outFieldInfArray.length>0){
%> 
	
  mailTableOptions="<%=outFieldInfArray[0]%>";
   detailTableOptions="<%=outFieldInfArray[1]%>";
   mailTableFiledNames="<%=outFieldInfArray[2]%>";
   mailTableFiledTypes="<%=outFieldInfArray[3]%>";
   detailTableFiledNames="<%=outFieldInfArray[4]%>";
   detailTableFiledTypes="<%=outFieldInfArray[5]%>";
   mainTalbeName="<%=outFieldInfArray[6]%>";
   detailTableName="<%=outFieldInfArray[7]%>";
<%
}
%>
//字段名称 字段类型 固定值设置
   var testd2 = onShowDetailTableFieldValue();//QC284050
   var itemsdt=[
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>",itemhtml:"<span class='browser' _callback='onSetTableField' completeurl='/data.jsp?type=164' browserurl='"+ testd2 + "' isAutoComplete='false' isMustInput='1' hasInput='false' name='dtfixfieldName' isSingle='true'></span>"},//"<SELECT style='width: 100px;height: 30px' name=\"dtfixfieldName\" onchange='changeDetailFieldValue(this);checkinput1(this);'>"+detailTableOptions+"</SELECT><span id=''><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>",itemhtml:"<span name='dtfixfieldtypespan'></span><INPUT  type='hidden' name='dtfixfieldtype'  value='' >"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(125772,user.getLanguage())%>",itemhtml:"<INPUT type='text' name='dtfixValue' value=''>"}];

var optiondt = {
    optionHeadDisplay:"none",
	navcolor:"#003399",
    basictitle:"",
    toolbarshow:false,
    colItems:itemsdt,
    addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
    deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
    usesimpledata:true,
    openindex:false,
    addrowCallBack:function() {
    },
    configCheckBox:true,
    checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='dtparamid'><INPUT type='hidden' name='dtparamids' value='-1'>","width":"6%"},
    initdatas:eval("<%=detailFixDatas%>")
};
//字段名称 字段类型 固定值设置
var testd1 = onShowTableFieldValue();//QC284050
var itemsmain=[
   {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%>",itemhtml:"<span class='browser' _callback='onSetTableField' completeurl='/data.jsp?type=164' browserurl='"+ testd1 + "' isAutoComplete='false' isMustInput='1' hasInput='false' name='mfixfieldName' isSingle='true'></span>"},//"<SELECT style='width: 100px;height: 30px' name=\"mfixfieldName\" onchange='changeMainFieldValue(this);checkinput1(this);'>"+mailTableOptions+" </SELECT><span ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"},
  // {width:"20%",colname:"字段名称",itemhtml:"<SELECT class='InputStyle' name=\"mfixfieldName\" onchange='changeMainFieldValue(this);'>"+mailTableOptions+" </SELECT><span class='mustinput'></span>"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%>",itemhtml:"<span name='mfixfieldtypespan'></span><INPUT  type='hidden' name='mfixfieldtype'  value='' >"},
    {width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(125772,user.getLanguage())%>",itemhtml:"<INPUT type='text' name='mainfixValue' value=''>"}];

var optionmain = {
    optionHeadDisplay:"none",
	navcolor:"#003399",
    basictitle:"",
    toolbarshow:false,
    colItems:itemsmain,
    addrowtitle:"<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>",
    deleterowstitle:"<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>",
    usesimpledata:true,
    openindex:false,
    addrowCallBack:function() {
    },
    configCheckBox:true,
    checkBoxItem:{"itemhtml":"<INPUT class='groupselectbox' type='checkbox' name='mainparamid'><INPUT type='hidden' name='mainparamids' value='-1'>","width":"6%"},
    initdatas:eval("<%=mainFixDatas%>")
};

   
    //jQuery("#mainFields").empty();
	//group=new WeaverEditTable(optionmain);
    //jQuery("#mainFields").append(group.getContainer());
    //var params=group.getTableSeriaData();

    //jQuery("#detailFields").empty();
     //group_dt=new WeaverEditTable(optiondt);
    //jQuery("#detailFields").append(group_dt.getContainer());
    //var params_dt=group_dt.getTableSeriaData();
    
 
	//jQuery("#mainTableSpan").html(mainTalbeName);
	//jQuery("#dtTableSpan").html(detailTableName);
	   


function changeSynType(obj)
{

    if(obj=="0"){
   
    hideEle("timeModulView");
   
    }else{
     showEle("timeModulView");
     
    }
}

function changeFileSaveType(obj)
{
   var temp=$(obj).val();
    $.ajax({ 
        	type:"POST",
            url: "/integration/exp/ExpGetRegitTypeOptons.jsp?"+Math.random(),
             data:{type:temp},
            cache: false,
  			async: false,
            success: function(data){
            data=data.replace(/(^\s+)|(\s+$)/g,"");
            
              //更改注册类型
    
  			$("#regitType option").remove();
   			$("#regitType").append(data);
  			
 		//解绑，绑定
		jQuery("#regitType").selectbox("detach");
 		__jNiceNamespace__.beautySelect("#regitType");
       
       }
        });

}

function changeMainFieldValue(obj)
{
 var mainNames=mailTableFiledNames.split(",");
 var maintyps=mailTableFiledTypes.split(",");
 var dtNames=detailTableFiledNames.split(",");
 var dttyps=detailTableFiledTypes.split(",");
 var t=mainNames.indexOf($(obj).val());
   $(obj).closest("td").next().find("input").val(maintyps[t]);
   $(obj).closest("td").next().find("span").html(maintyps[t]);
 
}
function changeDetailFieldValue(obj)
{

 var dtNames=detailTableFiledNames.split(",");
 var dtTyps=detailTableFiledTypes.split(",");
 var t=dtNames.indexOf($(obj).val());
  $(obj).closest("td").next().find("input").val(dtTyps[t]);
 $(obj).closest("td").next().find("span").html(dtTyps[t]);
 
}

function changeCheck(classname,obj)
{

/*
	var status = obj.checked;
	alert("status : "+status);
	alert("classname : "+classname);
	//$("."+classname).attr("checked",false);
	//$("."+classname).next().val("0");
	changeCheckboxStatus(jQuery("."+classname),false);
	$("."+classname).parent().next().val("0");
	changeCheckboxStatus(jQuery(obj),true);
	if(obj.checked)
	{
		obj.parentElement.nextSibling.value=1;
		jQuery(obj.nextSibling).addClass("jNiceChecked");
	}
	else
	{
		obj.parentElement.nextSibling.value=0;
	}*/
}

function changeDetailFieldValue(obj)
{

 var dtNames=detailTableFiledNames.split(",");
 var dtTyps=detailTableFiledTypes.split(",");
 var t=dtNames.indexOf($(obj).val());
  $(obj).closest("td").next().find("input").val(dtTyps[t]);
 $(obj).closest("td").next().find("span").html(dtTyps[t]);
 
}
function changeMainFieldValue(obj)
{
var mailTableFiledNames="<%=outFieldInfArray[2]%>";
var mailTableFiledTypes="<%=outFieldInfArray[3]%>";

 var mainNames=mailTableFiledNames.split(",");
 var maintyps=mailTableFiledTypes.split(",");

 var t=mainNames.indexOf($(obj).val());
   $(obj).closest("td").next().find("input").val(maintyps[t]);
   $(obj).closest("td").next().find("span").html(maintyps[t]);
 
}

function selectValueChange(obj) {
  var name=$(obj).attr('name');
  //alert(name);
  var arr = name.split('_');
  var tempname=arr[1];
  //alert(tempname);
	var v=$(obj).val();
	if(v!='2'){
	$("#selectValueConvert_"+tempname).hide();
	//hideGroup("selectValueGroup");
	}else{
	$("#selectValueConvert_"+tempname).show();
	}
    
   
}

function checkinput1(obj)
{
   var tmpvalue = $(obj).val();
  // alert( $(obj).closest("td").find("span").eq(1).html());
	// 处理$GetEle可能找不到对象时的情况，通过id查找对象
  if(tmpvalue==undefined)
	 tmpvalue = $GetEle(elementname).value;
    if(tmpvalue==undefined)
        tmpvalue=document.getElementById(elementname).value;

	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			//$GetEle(spanid).innerHTML = "";
			 $(obj).closest("td").find("span").eq(1).html("");
		}else{
		$(obj).closest("td").find("span").eq(1).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			//$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			//$GetEle(elementname).value = "";
		}
	}else{
			$(obj).closest("td").find("span").eq(1).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		//$GetEle(spanid).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		//$GetEle(elementname).value = "";
	}
}

//新增 QC284050
function onShowTableFieldValue(obj){
    var dbProid = "<%=dbProid%>";
    var dbprosetingid = "<%=dbprosetingid%>";
    var datasourceid ="<%=datasourceid%>";
    var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&needcheckds=3&datasourceid=" + datasourceid + "&dmlformid="+dbProid + "&dmlisdetail=" + dbprosetingid  + "&ajax=1&url=/integration/exp/ExpTableFieldsBrowser.jsp";
    //alert(urls);
    return urls;
}

function onShowDetailTableFieldValue(){
    var dbProid = "<%=dbProid%>";
    var dbprosetingid = "<%=dbprosetingid%>";
    var datasourceid ="<%=datasourceid%>";
    var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&needcheckds=4&datasourceid=" + datasourceid + "&dmlformid="+dbProid + "&dmlisdetail=" + dbprosetingid  + "&ajax=1&url=/integration/exp/ExpTableFieldsBrowser.jsp";
    //alert(urls);
    return urls;
}
function onSetTableField(event,data,name,dmltype,tg)
{

    var fieldname;
    var fielddbtype;
    var iscanhandle;
    //Dialog.alert("dmltype : "+dmltype);
    var obj = null;
    //alert(typeof(tg)+"  event : "+event);
    if(typeof(tg)=='undefined'){
        obj= event.target || event.srcElement;
    }
    else
    {
        obj = tg;
    }
    if(data){
        if(data.id != ""){
            fieldname = data.id;
            fielddbtype = data.type;
            iscanhandle = data.a1;
        }else{
            fieldname = "";
            fielddbtype = "";
            iscanhandle = "";
        }
    }
    appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj);
}
function appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj)
{

    try{
        if(fieldname=="")
        {
            fieldname = "";
            fielddbtype = "";
            //return;
        }
        if(typeof(fieldname)=="undefined")
        {
            return;
        }
        //字段名
        var obj = obj.parentElement.parentElement.parentElement.parentElement.parentElement;
        obj = $(obj).closest("td");
        //alert(obj.outerHTML)
        //var objfield = obj.parentElement.nextSi bling;
        //objfield.value = fieldname;
        //字段类型
		var nameTest = $(obj).find("input").attr("name");
		var nameTest1 = nameTest.substr(0,nameTest.length-4);
		var typespan = "[name='"+ nameTest1 + "typespan"+"']";
		console.log(typespan+"===");
		var type = "[name='"+ nameTest1 + "type"+"']";
        $(obj).next("td").find('"'+typespan+'"').text(fielddbtype);
        $(obj).next("td").find('"'+type+'"').val(fielddbtype);

    }catch(e){
        top.Dialog.alert(e);
    }
}
//新增 QC284050

</script>
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onBack();'></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
</BODY>
</HTML>