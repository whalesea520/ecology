<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CapitalRelateWFComInfo" class="weaver.cpt.capital.CapitalRelateWFComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page" />
<jsp:useBean id="CptCardGroupComInfo" class="weaver.cpt.util.CptCardGroupComInfo" scope="page" />
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<%

String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<link href="/proj/js/colortip-1.0/colortip-1.0-jquery_wev8.css" rel="stylesheet" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/cpt/js/cptswfupload_wev8.js"></script>

<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	var parentDialog = parent.parent.getDialog(parent);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>

<style type="text/css">
.InputStyle{width:30%!important;}
.inputstyle{width:30%!important;}
.Inputstyle{width:30%!important;}
.inputStyle{width:30%!important;}
.e8_os{width:30%!important;}
select.InputStyle{width:10%!important;} 
select.inputstyle{width:10%!important;} 
select.inputStyle{width:10%!important;} 
select.Inputstyle{width:10%!important;} 
textarea.InputStyle{width:70%!important;} 
</style>

</HEAD>
<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String rightStr = "";
String id = Util.null2String(request.getParameter("id"));
int msgid = Util.getIntValue(request.getParameter("msgid"),-1);
Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

RecordSet.executeProc("CptCapital_SelectByID",id);
RecordSet.next();
String mark = Util.toScreenToEdit(RecordSet.getString("mark"),user.getLanguage()) ;			/*编码*/
String name = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage()) ;			/*名称*/
String barcode = Util.toScreenToEdit(RecordSet.getString("barcode"),user.getLanguage()) ;			/*条形码*/
String startdate = Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage()) ;			/*生效日*/
String enddate= Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage()) ;				/*生效至*/
String seclevel= Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage()) ;				/*安全级别*/
String currencyid = Util.toScreenToEdit(RecordSet.getString("currencyid"),user.getLanguage()) ;	/*币种*/
String capitalcost = Util.toScreenToEdit(RecordSet.getString("capitalcost"),user.getLanguage()) ;	/*成本*/
String startprice = Util.toScreenToEdit(RecordSet.getString("startprice"),user.getLanguage()) ;	/*开始价格*/
String capitaltypeid = Util.toScreenToEdit(RecordSet.getString("capitaltypeid"),user.getLanguage()) ;			/*资产类型*/
String capitalgroupid = Util.toScreenToEdit(RecordSet.getString("capitalgroupid"),user.getLanguage()) ;			/*资产组*/

rs1.executeSql("SELECT supassortmentstr FROM CptCapitalAssortment WHERE id =  "+capitalgroupid);
String asstr = "";
if(rs1.next()){
	asstr = rs1.getString("supassortmentstr");
}

String str[] = asstr.split("\\|");
String groupname = "";
for(int j=1;j<str.length;j++){
	groupname += CapitalAssortmentComInfo.getAssortmentName(str[j])+" > ";
}
groupname += CapitalAssortmentComInfo.getAssortmentName(capitalgroupid);

String capitalnum = Util.toScreen(RecordSet.getString("capitalnum"),user.getLanguage()) ;
String unitid = Util.toScreenToEdit(RecordSet.getString("unitid"),user.getLanguage()) ;				/*计量单位*/
String replacecapitalid = Util.toScreenToEdit(RecordSet.getString("replacecapitalid"),user.getLanguage()) ;				/*替代*/
String version = Util.toScreenToEdit(RecordSet.getString("version"),user.getLanguage()) ;			/*版本*/
String itemid = Util.toScreenToEdit(RecordSet.getString("itemid"),user.getLanguage()) ;			/*物品*/
String remark = Util.toScreenToEdit(RecordSet.getString("remark"),user.getLanguage()) ;			/*备注*/
String capitalimageid = Util.getFileidOut(RecordSet.getString("capitalimageid")) ;				/*照片id由SequenceIndex表得到，和使用它的表相关联*/
String depremethod1 = Util.toScreenToEdit(RecordSet.getString("depremethod1"),user.getLanguage()) ;			/*折旧法一*/
String depremethod2 = Util.toScreenToEdit(RecordSet.getString("depremethod2"),user.getLanguage()) ;			/*折旧法二*/
String deprestartdate = Util.toScreenToEdit(RecordSet.getString("deprestartdate"),user.getLanguage()) ;		/*折旧开始日期*/
String depreenddate = Util.toScreenToEdit(RecordSet.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String customerid= Util.toScreenToEdit(RecordSet.getString("customerid"),user.getLanguage()) ;			/*供应商id*/
String attribute= Util.toScreenToEdit(RecordSet.getString("attribute"),user.getLanguage()) ;
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
/*new add*/
String depreendprice = Util.toScreenToEdit(RecordSet.getString("depreendprice"),user.getLanguage()) ;	/*折旧底价*/
String capitalspec = Util.toScreenToEdit(RecordSet.getString("capitalspec"),user.getLanguage()) ;	/*规格型号*/
String capitallevel = Util.toScreenToEdit(RecordSet.getString("capitallevel"),user.getLanguage()) ;	/*资产等级*/
String manufacturer = Util.toScreenToEdit(RecordSet.getString("manufacturer"),user.getLanguage()) ;	/*制造厂商*/
String manudate = Util.toScreenToEdit(RecordSet.getString("manudate"),user.getLanguage()) ;	/*出厂日期*/
String sptcount = Util.toScreenToEdit(RecordSet.getString("sptcount"),user.getLanguage()) ;	/*单独核算*/
String stateid = Util.toScreenToEdit(RecordSet.getString("stateid"),user.getLanguage()) ;	/*状态*/
String resourceid= Util.toScreenToEdit(RecordSet.getString("resourceid"),user.getLanguage()) ;	/*相关人力资源*/
String location= Util.toScreenToEdit(RecordSet.getString("location"),user.getLanguage()) ;	/*存放地点*/
String isdata= Util.toScreenToEdit(RecordSet.getString("isdata"),user.getLanguage()) ;	/*资产资料判断*/
String datatype= Util.toScreenToEdit(RecordSet.getString("datatype"),user.getLanguage()) ;	/*资产所属资料*/
String relatewfid= Util.toScreenToEdit(RecordSet.getString("relatewfid"),user.getLanguage()) ;	/*相关工作流*/
String alertnum= Util.toScreenToEdit(RecordSet.getString("alertnum"),user.getLanguage()) ;	/*报警数量*/
String fnamark= Util.toScreenToEdit(RecordSet.getString("fnamark"),user.getLanguage()) ;	/*财务编号*/
String isinner = Util.null2String(RecordSet.getString("isinner")) ;	/*帐内帐外*/
String Invoice = Util.toScreenToEdit(RecordSet.getString("Invoice"),user.getLanguage()) ;			/*发票号码*/
String StockInDate = Util.toScreenToEdit(RecordSet.getString("StockInDate"),user.getLanguage()) ;			/*采购日期*/
String depreyear  = Util.toScreen(RecordSet.getString("depreyear"),user.getLanguage()) ;			/*折旧年限*/
String deprerate  = Util.toScreen(RecordSet.getString("deprerate"),user.getLanguage()) ;			/*折旧率*/
String blongsubcompany = Util.null2String(RecordSet.getString("blongsubcompany"));/*所属分部*/
String blongdepartment = Util.null2String(RecordSet.getString("blongdepartment"));/*所属部门*/
String issupervision = Util.null2String(RecordSet.getString("issupervision"));/*是否海关检查*/
String amountpay = Util.null2String(RecordSet.getString("amountpay")); /*已付金额*/
String purchasestate = Util.null2String(RecordSet.getString("purchasestate"));/*采购状态*/
String departmentid = Util.null2String(RecordSet.getString("departmentid"));/*使用部门*/
String mequipmentpower = Util.null2String(RecordSet.getString("equipmentpower"));/*设备功率*/

String SelectDate= Util.toScreenToEdit(RecordSet.getString("SelectDate"),user.getLanguage()) ; /*购置日期*/
String contractno = Util.toScreenToEdit(RecordSet.getString("contractno"),user.getLanguage());//合同号

String codeuse="1";
if("1".equals(isdata)){
	codeuse=CodeUtil.getCptData1CodeUse();
}else{
	codeuse=CodeUtil.getCptData2CodeUse();
}


if(deprerate.equals("")) deprerate="0";

//added by lupeng 2004.2.19
//avoid sptcount is null
if (sptcount == null || sptcount.equals("") || sptcount.length() == 0)
    sptcount =String.valueOf("0");
//end

/*自定义字段*/
String datefield[] = new String[5] ;
String numberfield[] = new String[5] ;
String textfield[] = new String[5] ;
String tinyintfield[] = new String[5] ;
String docff[] = new String[5] ; 
String depff[] = new String[5] ; 
String crmff[] = new String[5] ; 
String reqff[] = new String[5] ;

for(int k=1 ; k<6;k++) datefield[k-1] = RecordSet.getString("datefield"+k) ;
for(int k=1 ; k<6;k++) numberfield[k-1] = RecordSet.getString("numberfield"+k) ;
for(int k=1 ; k<6;k++) textfield[k-1] = RecordSet.getString("textfield"+k) ;
for(int k=1 ; k<6;k++) tinyintfield[k-1] = RecordSet.getString("tinyintfield"+k) ;
for(int k=1 ; k<6;k++) docff[k-1] = RecordSet.getString("docff0"+k+"name") ;
for(int k=1 ; k<6;k++) depff[k-1] = RecordSet.getString("depff0"+k+"name") ;
for(int k=1 ; k<6;k++) crmff[k-1] = RecordSet.getString("crmff0"+k+"name") ;
for(int k=1 ; k<6;k++) reqff[k-1] = RecordSet.getString("reqff0"+k+"name") ;


/*权限判断*/
boolean canedit = false;

/*可否编辑*/
/*由于现在资产资料和资产的权限控制完全不同所以需做以下区分*/
if (isdata.equals("1")) {
    // added by lupeng 2204-07-21 for TD558
    if (HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
		canedit = true;
	}
    // end
} else {
	/*共享权限判断*/
	RecordSetShare.executeSql(CommonShareManager.getSharLevel("cpt", id, user) );
	if( RecordSetShare.next() ) {
		int sharelevel = Util.getIntValue(RecordSetShare.getString(1), 0) ;
		if( sharelevel == 2 ) {//只要有数据共享就可编辑,不需要资产编辑
			canedit     =   true;
		}
	}
	if(HrmUserVarify.checkUserRight("CptCapital:modify", user)){//资产变更
		canedit     =   true;
	}
	
}

if(HrmUserVarify.checkUserRight("CptCapitalEdit:Edit",user))  {
	canedit = true;
	rightStr="CptCapitalEdit:Edit";
}
if(HrmUserVarify.checkUserRight("CptCapital:modify",user))  {
	canedit = true;
}

// added by lupeng 2204-07-21 for TD558
boolean canDelete = false;
if (HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
    canDelete = true;
    canedit = true;
    rightStr="Capital:Maintenance";
}
// end

/*可否编辑*/
if(!canedit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限判断结束*/

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if(isdata.equals("1")){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage())+" : "+name;
}else{
	titlename = SystemEnv.getHtmlLabelName(6055,user.getLanguage())+" : "+name;
}
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!"1".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-1),_self}";
	RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
if(msgid!=-1){
%>
<DIV>
<font color=red size=2>
<%=SystemEnv.getErrorMsgName(msgid,user.getLanguage())%>
</font>
</DIV>
<%}%>

<FORM name=frmain id=frmain action=CptCapitalOperation.jsp method=post enctype="multipart/form-data">
	<input type=hidden name=operation value="editcapital">
	<input type=hidden name=id value="<%=id%>">
	<input type=hidden name=isdialog value="<%=isDialog %>">
	<%if(!sptcount.equals("1")){%>
	<input type=hidden value="<%=depreyear%>" name="depreyear">
	<input type=hidden value="<%=deprerate%>" name="deprerate">
	<%}%>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		
		<%
		if(canedit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName( 86 ,user.getLanguage())%> " class="e8_btn_top" onclick="submitData()"/>
			<%
		}
		%>
			
			
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%

int fieldcount=0;//用来定位插图片
String needHideField=",";//用来隐藏字段
boolean dataornot="1".equals(isdata);
if(dataornot){//资产资料
	rs2.executeSql("select * from cptcapital where isdata = 2  and datatype = "+id+" ");
	if(rs2.next()){
		needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,sptcount,alertnum,";
	}else{
		needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,alertnum,";
	}
}else{
	needHideField+="resourceid,capitalnum,stateid,deprestartdate,usedyear,currentprice,sptcount,departmentid,";
	if(!"1".equals(sptcount)){
		needHideField+="depreyear,deprerate,";
	}else{
		needHideField+="alertnum,";
	}
}

//必填字段控制
String[]mandStr= Util.TokenizerString2(CptFieldComInfo.getMandFieldStr(),",") ;
String checkStr="";
if(mandStr!=null&&mandStr.length>0){
	for(int i=0;i<mandStr.length;i++){
		if(mandStr[i].equals("mark")){
			continue;
		}
		if((","+needHideField).indexOf(","+mandStr[i]+",")>=0){
			continue;
		}
		checkStr+=mandStr[i]+",";
	}
}

%>

<wea:layout attributes="{'expandAllGroup':'true'}">
<%

TreeMap<String,TreeMap<String,JSONObject>> groupFieldMap=CptFieldComInfo.getGroupFieldMap();
CptCardGroupComInfo.setTofirstRow();
while(CptCardGroupComInfo.next()){
	String groupid=CptCardGroupComInfo.getGroupid();
	TreeMap<String,JSONObject> openfieldMap= groupFieldMap.get(groupid);
	if(openfieldMap==null||openfieldMap.size()==0){
		continue;
	}
	int grouplabel=Util.getIntValue( CptCardGroupComInfo.getLabel(),-1);
	
	%>
<wea:group context='<%=SystemEnv.getHtmlLabelName(grouplabel,user.getLanguage())%>'>	
<%
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldlabel=v.getInt("fieldlabel");
		String fieldName=v.getString("fieldname");
		String fieldValue=Util.null2String(RecordSet.getString(fieldName));
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		if("resourceid".equals( fieldName)&&dataornot){
			fieldlabel=1507;
		}else if("mark".equals(fieldName)&&!"2".equals(codeuse)){//非手动编码
			continue;
		}else if("capitalgroupid".equals(fieldName)){//自动带资产组
			//fieldValue=validatedAssortmentid;
		}
		
		fieldcount++;
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%
		if("capitalgroupid".equals(fieldName)){
			%>
			<%=groupname%>
			<input type="hidden" name="capitalgroupid" value="<%=fieldValue %>" />
			<%
		}else{
			%>
			<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(fieldValue, v, user) %>
			<%
		}
		%>
	
		<%
		if("deprerate".equals(fieldName)){
			%>
			%
			<%
		}
		%>
	</wea:item>
	<%
	if(fieldcount==1 ){
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></wea:item>
	<wea:item>
		<% 
		//图片编辑
		if(capitalimageid.equals("") || capitalimageid.equals("0")) {%>
		  <input type="file" name="capitalimage" class="InputStyle">
		  <%} else {%>
		  <img border=0  width=200 src="/weaver/weaver.file.FileDownload?fileid=<%=capitalimageid%>">
		  <button type=button  class=btnDelete id=Delete accessKey=P onclick="onDelPic()"><U>P</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></BUTTON>
		  <% } %>
		  <input type="hidden" name="oldcapitalimage" value="<%=capitalimageid%>">
	</wea:item>
	<%
	}
	%>
	
	<%
	}
}

%>
</wea:group>
	<%
}
%>

	
</wea:layout>



<div style="height:100px!important;"></div>
</FORM>
<table id="remindtbl" class=ReportStyle style="display:none;">
<TBODY>
<TR><TD>
<%=SystemEnv.getHtmlLabelName(21777,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21769,user.getLanguage())%><br>     
<%=SystemEnv.getHtmlLabelName(21770,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21771,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21772,user.getLanguage())%><br>
<%=SystemEnv.getHtmlLabelName(21773,user.getLanguage())%>
<%=SystemEnv.getHtmlLabelName(21774,user.getLanguage())%>
</TD>
</TR>
</TBODY>
</table>


<Script language="javascript">
function onDelPic(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(8,user.getLanguage())%>")) {
		$GetEle("operation").value="delpic";
		$GetEle("frmain").submit();
	}
}
function onDelete(){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			$GetEle("operation").value="deletecapital";
			$GetEle("frmain").submit();
		}
}
</Script>
<script language="javascript">


function checkinputnumber(obj){
	
	valuechar = obj.value.split("");
	isnumber = false ;
	for(i=0 ; i<valuechar.length ; i++) { 
	    charnumber = parseInt(valuechar[i]) ; 
	    if( isNaN(charnumber)&& valuechar[i]!="." && valuechar[i]!="-") 
	    isnumber = true ;
	}
	if(isnumber) obj.value="";
}

function submitData()
{
	var checkStr = "<%=checkStr %>" ;
	if("<%=codeuse %>"=="2") {
		checkStr += ",mark";
	}
	if (check_form(frmain,checkStr)){
		 //检查资产编码是否重复
		var mark = $("#mark").val();
	   jQuery.ajax({
		url : "CptCapitalOperation.jsp",
		type : "post",
		async : true,
		processData : true,
		data : {"operation":"checkmark","mark":mark,"id":'<%=id %>',"isdata":'<%=isdata %>',"codeuse":"<%=codeuse %>"},
		dataType : "json",
		success: function do4Success(data){
				if(data.msg=="true"){
					frmain.submit();//82306
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("714",user.getLanguage())%>"+"<%=SystemEnv.getHtmlLabelNames("18082",user.getLanguage())%>");
					return;
				}
			}
		});
		
	}
}

</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>
<script type="text/javascript" src="/proj/js/colortip-1.0/colortip-1.0-jquery_wev8.js"></script>
<script type="text/javascript">	
$(function(){
	try{
		parent.setTabObjName("<%=CapitalComInfo.getCapitalname(id) %>");
		var remindimg="<a name='remindlink' href='javascript:void(0)' title='"+$("#remindtbl").text()+"'><img src='/wechat/images/remind_wev8.png' align='absMiddle'  /></a>";
		$("span.e8_grouptitle:contains('<%=SystemEnv.getHtmlLabelName( 1374 ,user.getLanguage()) %>')").append("&nbsp;&nbsp;&nbsp;&nbsp;").append(remindimg);
	}catch(e){}
	
	//$('a[name=remindlink][title]').colorTip({color:'yellow'});
	
	$("#deprerate").live("blur", function () { 
        var deprerate = $GetEle("deprerate").value;
		if(deprerate>100){
			$GetEle("deprerate").value = 100;
		}
      }); 
});
</script>
<script type="text/javascript">
jQuery(function(){
	hideEle('hideField');
});
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>
<script type="text/javascript">
function onShowTime(spanname,inputname){
	var dads  = document.getElementById("meizzDateLayer2").style;
	setLastSelectTime(inputname);
	/*var th = spanname;
	var ttop  = spanname.offsetTop; 
	var thei  = spanname.clientHeight;
	var tleft = spanname.offsetLeft; 
	var ttyp  = spanname.type;       
	while (spanname = spanname.offsetParent){
		ttop += spanname.offsetTop; 
		tleft += spanname.offsetLeft;
	}*/
	
	var th = $ele4p(spanname);
	var ttop  = $ele4p(spanname).offsetTop; 
	var thei  = $ele4p(spanname).clientHeight;
	var tleft = $ele4p(spanname).offsetLeft; 
	var ttyp  = $ele4p(spanname).type;    
	while (spanname = $ele4p(spanname).offsetParent){
		ttop += $ele4p(spanname).offsetTop; 
		tleft += $ele4p(spanname).offsetLeft;
	}
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei - 50)+"px";
	dads.top = (jQuery(th).offset().top+8)+"px";
	//dads.left = (tleft - 5)+"px";
	dads.left = jQuery(th).offset().left+"px";
	
	
	//dads.top  = ((ttyp == "image") ? ttop + thei : ttop + thei + 22)+"px";
	//dads.left = tleft+"px";
	outObject = th;
	outValue = inputname;
	outButton = (arguments.length == 1) ? null : th;
	dads.display = '';
	bShow = true;
}
</script>
</HTML>
