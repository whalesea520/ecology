<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
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
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />
<% if(!(user.getLogintype()).equals("1")) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
   }
%>

<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String querystr=request.getQueryString();
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("cpt","CptCardEdit");
if(CusFormSetting!=null&&CusFormSetting.getStatus()==2){//自定义布局页面
	//request.getRequestDispatcher("/cpt/capital/CptCapitalEdit_l.jsp").forward(request, response);
	response.sendRedirect("/cpt/capital/CptCapitalEdit_l.jsp"+"?"+querystr);
	return;
}

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
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self}";
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



<wea:layout >
	<!-- baseinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=60 name="name" size=30
						onChange='checkinput("name","nameimage")' value="<%=name%>">
						  <span id=nameimage><%if (name.equals("")) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
		</wea:item>
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
if("2".equals( codeuse)){
	%>
		<wea:item  ><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item  >
			<input class=InputStyle maxlength=50 name="mark" size=30 
						onChange='checkinput("mark","markimage")' value="<%=mark %>">
			<%
			if("".equals(mark)){
				%>
						  <span id=markimage><img src="/images/BacoError_wev8.gif" align=absMiddle></span>
				<%
			}
			%>			
		
		</wea:item>
	
	<%
}else if("1".equals(codeuse) ){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item><%=mark %></wea:item>
	<%
}
%>		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
		<wea:item>
				<span id=capitalgroupidspan><%=groupname%><%if (capitalgroupid.equals("") || capitalgroupid.equals("0")) {%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
						  <input type=hidden name=capitalgroupid value="<%=capitalgroupid%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="capitaltypeid" browserValue='<%=capitaltypeid %>' browserSpanValue='<%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=242" />
		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=60 size=30 value="<%=capitalspec%>" name="capitalspec" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=100 size=30 value="<%=manufacturer%>" name="manufacturer" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=30 size=30 value="<%=capitallevel%>" name="capitallevel" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=InputStyle id=attribute name=attribute>
				<option value=0 <% if(attribute.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%></option>
				<option value=1 <% if(attribute.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%></option>
				<option value=2 <% if(attribute.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%></option>
				<option value=3 <% if(attribute.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%></option>
				<option value=4 <% if(attribute.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></option>
				<option value=5 <% if(attribute.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%></option>
				<option value=6 <% if(attribute.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
			  </select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="unitid" browserValue='<%=unitid %>' browserSpanValue='<%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=-99993" />
		
		</wea:item>
<%
if(!"1".equals(isdata)){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=30 size=30
						name="barcode" value="<%=barcode%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=60 name="fnamark" size=30 value="<%=fnamark%>">
		</wea:item>
	<%
}
if(!sptcount.equals("1")&&!isdata.equals("1")){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15294,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=16 size=10 value="<%=alertnum%>" name="alertnum" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("alertnum");'>
		</wea:item>
	
	<%

}

%>		
	</wea:group>
	
	<!-- manageinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27858,user.getLanguage())%>' attributes="{'itemAreaDisplay':'true'}">

<%
if(!"1".equals(isdata)){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(stateid.equals("-7")) {%>
			<%=SystemEnv.getHtmlLabelName(1385,user.getLanguage())%>
			<%} else if(stateid.equals("-6")) {%>
			<%=SystemEnv.getHtmlLabelName(1381,user.getLanguage())%>
			<%} else if(stateid.equals("-5")) {%>
			<%=SystemEnv.getHtmlLabelName(1377,user.getLanguage())%>
			<%} else if(stateid.equals("-4")) {%>
			<%=SystemEnv.getHtmlLabelName(1376,user.getLanguage())%>
			<%} else if(stateid.equals("-3")) {%>
			<%=SystemEnv.getHtmlLabelName(1396,user.getLanguage())%>
			<%} else if(stateid.equals("-2")) {%>
			<%=SystemEnv.getHtmlLabelName(1397,user.getLanguage())%>
			<%} else if(stateid.equals("-1")) {%>
			<%=SystemEnv.getHtmlLabelName(1398,user.getLanguage())%>
			<%} else if(stateid.equals("0")) {%>
			<%=SystemEnv.getHtmlLabelName(1384,user.getLanguage())%>
			<%} else if(stateid.equals("1")) {%>
			<%=SystemEnv.getHtmlLabelName(1375,user.getLanguage())%>
			<%} else if(stateid.equals("2")) {%>
			<%=SystemEnv.getHtmlLabelName(1378,user.getLanguage())%>
			<%} else if(stateid.equals("3")) {%>
			<%=SystemEnv.getHtmlLabelName(1379,user.getLanguage())%>
			<%} else if(stateid.equals("4")) {%>
			<%=SystemEnv.getHtmlLabelName(1382,user.getLanguage())%>
			<%} else if(stateid.equals("5")) {%>
			<%=SystemEnv.getHtmlLabelName(1386,user.getLanguage())%>
			<%} else{%>
			<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></wea:item>
		<wea:item>
			<%=DepartmentComInfo.getDepartmentname(blongdepartment)%>
						  <input class=InputStyle id=blongdepartment value="<%=blongdepartment%>" type=hidden name=blongdepartment>
		</wea:item>
	
	<%
}

%>		
		
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName((!isdata.equals("1")?1508:1507),user.getLanguage()) %></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" />
		
		</wea:item>
		
<%
if(true){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="blongsubcompany" browserValue='<%=Util.getIntValue( blongsubcompany)>0?""+blongsubcompany:""%>' browserSpanValue='<%=Util.getIntValue( blongsubcompany)>0? SubCompanyComInfo.getSubCompanyname(String.valueOf(blongsubcompany)):""%>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" />
		
		</wea:item>
	
	<%
}
%>		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="sptcount" value="<%=sptcount%>"  <%="1".equals(sptcount)?"checked":"" %> readonly="readonly" />
		</wea:item>
<%
if(!"1".equals(isdata)){
	%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></wea:item>
		<wea:item><%=capitalnum %></wea:item>
		
	<%
}
%>		


		<wea:item><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="customerid" browserValue='<%=customerid %>' browserSpanValue='<%=CustomerInfoComInfo.getCustomerInfoname(customerid) %>' 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						completeUrl="/data.jsp?type=7" />
		
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="replacecapitalid" browserValue='<%=replacecapitalid%>' browserSpanValue='<%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
				completeUrl="/data.jsp?type=23"  />
		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=60 size=30 name=version value="<%=version%>">
		</wea:item>
<%
if(!"1".equals(isdata)){
	%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></wea:item>
		<wea:item>
			<select class="" id=isinner name=isinner >
				<option value=""></option>
			  	<option value="1" <%="1".equals(isinner)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
			  	<option value="2" <%="2".equals(isinner)?"selected":"" %>  ><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></wea:item>
		<wea:item>
			<button type=button  class=Calendar id=selectstartdate onClick="getstartDate()"></button>
						  <span id=startdatespan style="FONT-SIZE: x-small"><%=startdate%></span>
						  <input type="hidden" name="startdate" value="<%=startdate%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></wea:item>
		<wea:item>
			<button type=button  class=Calendar id=selectenddate onClick="getendDate()"></button>
						  <span id=enddatespan style="FONT-SIZE: x-small"><%=enddate%></span>
						  <input type="hidden" name="enddate" value="<%=enddate%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></wea:item>
		<wea:item>
			<button type=button  class=Calendar id=selectmanudate onClick="getDate(manudatespan,manudate)"></button>
						  <span id=manudatespan style="FONT-SIZE: x-small"><%=manudate%></span>
						  <input type="hidden" name="manudate" value="<%=manudate%>" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
		<wea:item>
			<button type=button  class=Calendar id=selectStockInDate onClick="getDate(StockInDatespan,StockInDate)"></button>
                          <span id=StockInDatespan style="FONT-SIZE: x-small"><%=StockInDate%></span>
                          <input type="hidden" name="StockInDate" value="<%=StockInDate%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=100 size=30 value="<%=location%>"
						name="location">
		</wea:item>
	<%
}

%>
		
	</wea:group>
	
	<!-- supplyinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
		
<%
if(!"1".equals(isdata)){
	%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item>
		<wea:item>
			<button type=button  class=Calendar onClick="getDate(SelectDateSpan,selectdate)"></button>
							<span id="SelectDateSpan"><%=SelectDate%></span>
						  <input id=selectdate type=hidden name=selectdate value="<%=SelectDate%>">
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle
						maxlength=20 size=15 value="<%=contractno%>" name="contractno">
		</wea:item>
	<%
}

%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="currencyid" browserValue='<%=currencyid%>' browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=12"  />
		</wea:item>
		<wea:item><%="1".equals(isdata)?""+SystemEnv.getHtmlLabelName(191,user.getLanguage()):"" %><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle
						maxlength=16 size=10 value="<%=startprice%>" name="startprice" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice")' value="0">
		</wea:item>
<%
if(!"1".equals(isdata)){
	%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=30 size=30 value="<%=Invoice%>" name="Invoice">
		</wea:item>
	<%
}

%>		
	</wea:group>
	
	<!-- depinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1374,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=16 size=10 value="<%=depreyear%>" name="depreyear" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear")'>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=InputStyle maxlength=16 size=10 value="<%=deprerate%>" name="deprerate" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate")'>%
		</wea:item>
<%
if(!"1".equals(isdata)){
	%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></wea:item>
		<wea:item>
			<button type=button  class=Calendar id=selectdeprestartdate onClick="getDate(deprestartdatespan,deprestartdate)"></button>
                          <span id=deprestartdatespan style="FONT-SIZE: x-small"><%=deprestartdate%></span>
                          <input type="hidden" name="deprestartdate" value="<%=deprestartdate%>">
		</wea:item>
	<%
}

%>		
	</wea:group>
	
	<!-- otherinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>'>
<%
//cusfield
TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(openfieldMap!=null){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
	
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
	<wea:item>
		<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString(Util.null2String(RecordSet.getString(v.getString("fieldname"))), v, user) %>
	</wea:item>
	
	<%
	}
}

%>		
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		<wea:item><textarea class="InputStyle"  name=remark rows="6" style="width:80%!important;"><%=remark %></textarea></wea:item>
		
	</wea:group>
	
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

<script type="text/javascript">


function onShowMDocid(inputename, spanname) {
	var tmpids = $GetEle(inputename).value;
	var id1 = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp?documentids="
					+ tmpids, "", "dialogWidth:550px;dialogHeight:550px;");
	if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
		var DocIds = wuiUtil.getJsonValueByIndex(id1, 0).substr(1);
		var DocName = wuiUtil.getJsonValueByIndex(id1, 1).substr(1);
		var sHtml = "";

		$GetEle(inputename).value = DocIds;

		var docIdArray = DocIds.split(",");
		var DocNameArray = DocName.split(",");

		for ( var _i = 0; _i < docIdArray.length; _i++) {
			var curid = docIdArray[_i];
			var curname = DocNameArray[_i];

			sHtml = sHtml + "<a href=/docs/docs/DocDsp.jsp?id=" + curid + ">"
					+ curname + "</a>&nbsp";
		}

		$GetEle(spanname).innerHTML = sHtml;

	} else {
		$GetEle(spanname).innerHTML = "";
		$GetEle(inputename).value = "";
	}
}

function onShowCostCenter() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="
							+ $GetEle("departmentid").value, "",
					"dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != 0) {
			$GetEle("costcenterspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("costcenterid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("costcenterspan").innerHTML = "";
			$GetEle("costcenterid").value = "";
		}
	}
}

function onShowResourceID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("resourceidspan").innerHTML = "<A href='/hrm/resource/HrmResource.jsp?id="
					+ wuiUtil.getJsonValueByIndex(id, 0)
					+ "'>"
					+ wuiUtil.getJsonValueByIndex(id, 1) + "</A>";
			$GetEle("resourceid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("resourceidspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$GetEle("resourceid").value = "";
		}
	}
}

function onShowCurrencyID() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("currencyidspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("currencyid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("currencyidspan").innerHTML = "";
			$GetEle("currencyid").value = "";
		}
	}
}

function onShowDepremethod1() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/DepremethodBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 1) != "") {
			$GetEle("depremethod1span").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("depremethod1").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("depremethod1span").innerHTML = "";
			$GetEle("depremethod1").value = "";
		}
	}
}

function onShowDepremethod2() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/DepremethodBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("depremethod2span").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("depremethod2").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("depremethod2span").innerHTML = "";
			$GetEle("depremethod2").value = "";
		}
	}
}

function onShowCapitaltypeid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != ""&&wuiUtil.getJsonValueByIndex(id, 0) != "0") {
			$GetEle("capitaltypeidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitaltypeid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitaltypeidspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$GetEle("capitaltypeid").value = "";
		}
	}
}

function onShowCapitalgroupid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("capitalgroupidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("capitalgroupid").value = wuiUtil
					.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("capitalgroupidspan").innerHTML = "";
			$GetEle("capitalgroupid").value = "";
		}
	}
}

function onShowCustomerid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("customeridspan").innerHTML = wuiUtil.getJsonValueByIndex(
					id, 1);
			$GetEle("customerid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("customeridspan").innerHTML = "";
			$GetEle("customerid").value = "";
		}
	}
}

function onShowStateid() {
	var id = window
			.showModalDialog(
					"/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search",
					"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 1) != "") {
			$GetEle("Stateidspan").innerHTML = wuiUtil.getJsonValueByIndex(id,
					1);
			$GetEle("Stateid").value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			$GetEle("Stateidspan").innerHTML = "";
			$GetEle("Stateid").value = "";
		}
	}
}

function onShowReplacecapitalid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("replacecapitalidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("replacecapitalid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("replacecapitalidspan").innerHTML = "";
			$GetEle("replacecapitalid").value = "";
		}
	}
}

function onShowSubcompany(tdname, inputename) {
	var result = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=Capital:Maintenance&selectedids="+$G(inputename).value);
	if(result){
	    if(result.id!=""&&result.id!="0"){
			$G(tdname).innerHTML=result.name;
			$G(inputename).value=result.id;
		}else{
			$G(tdname).innerHTML= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$G(inputename).value="";
		}
	}
}


function onShowUnitid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("unitidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 2);
			$GetEle("unitid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("unitidspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			$GetEle("unitid").value = "";
		}
	}
}

function onShowItemid() {
	var id = window.showModalDialog(
			"/systeminfo/BrowserMain.jsp?url=/lgc/asset/LgcAssetBrowser.jsp",
			"", "dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			$GetEle("itemidspan").innerHTML = wuiUtil
					.getJsonValueByIndex(id, 1);
			$GetEle("itemid").value = wuiUtil.getJsonValueByIndex(id,
					0);
		} else {
			$GetEle("itemidspan").innerHTML = "";
			$GetEle("itemid").value = "";
		}
	}
}

</script>

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

function   addRow1(){ //增加附属设备明细   
   
	var   alltbDetailUsed=    $GetEle("equipment").rows;   
	var   theFirstSelectedDetail=alltbDetailUsed.length;   	
	var   newRow   =    $GetEle("equipmenttable").rows[0].cloneNode(true);   
	var   desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );
  
	alltbDetailUsed=    $GetEle("equipment").rows;   
	theFirstSelectedDetail=alltbDetailUsed.length;   	
	newRow   =    $GetEle("equipmenttable").rows[1].cloneNode(true);   
	desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );       
}   
    
function   deleteRow1(){ //删除附属设备明细     
	var   alltbDetailUsed=    $GetEle("equipment").rows;   
	for(var   i=4;i<alltbDetailUsed.length-1;i=i+2){   
		if (alltbDetailUsed[i].all("equipment_select").checked==true){   
			 $GetEle("equipment").deleteRow(i);   
			 $GetEle("equipment").deleteRow(i);   
			i=i-2;   
		}   
	}   
	 $GetEle("equipment_select_all").checked=false;
}

function selectall1(obj){//附属设备全选    
	var   tureorfalse=obj.checked;   
	var   theDetail=equipment.rows;   
	for(var   i=4;i<theDetail.length-1;i=i+2){   
		theDetail[i].all("equipment_select").checked=tureorfalse;   
	}    	
}

function   addRow2(){ //增加备品配件明细   
   
	var   alltbDetailUsed=    $GetEle("parts").rows;   
	var   theFirstSelectedDetail=alltbDetailUsed.length;   	
	var   newRow   =    $GetEle("partstable").rows[0].cloneNode(true);   
	var   desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );
  
	alltbDetailUsed=    $GetEle("parts").rows;   
	theFirstSelectedDetail=alltbDetailUsed.length;   	
	newRow   =    $GetEle("partstable").rows[1].cloneNode(true);   
	desRow   =   alltbDetailUsed[theFirstSelectedDetail-1];   
	desRow.parentElement.insertBefore(newRow,desRow );       
}   
    
function   deleteRow2(){ //删除备品配件明细     
	var   alltbDetailUsed=    $GetEle("parts").rows;   
	for(var   i=4;i<alltbDetailUsed.length-1;i=i+2){   
		if (alltbDetailUsed[i].all("parts_select").checked==true){   
			 $GetEle("parts").deleteRow(i);   
			 $GetEle("parts").deleteRow(i);   
			i=i-2;   
		}   
	}   
	 $GetEle("parts_select_all").checked=false;
}

function selectall2(obj){//备品配件全选    
	var   tureorfalse=obj.checked;   
	var   theDetail=parts.rows;   
	for(var   i=4;i<theDetail.length-1;i=i+2){   
		theDetail[i].all("parts_select").checked=tureorfalse;   
	}    	
}

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
	//var isStateNull=0;
	var checkStr = "name," ;
	var isdataTemp = <%=isdata%> ;
	var sptcountTemp = <%=sptcount%> ;
	var stateidTemp = "" ;
	<%if (!stateid.equals("")) {%>
		stateidTemp = <%=stateid%>
	<%}%>

	if(stateidTemp!=1) checkStr += "resourceid," ;
	checkStr += "currencyid,capitaltypeid,capitalgroupid,unitid,blongsubcompany" ;
	//if("<%=isdata%>"=="1") checkStr += ",blongsubcompany";
	if("<%=codeuse %>"=="2") checkStr += ",mark";
	var cusfieldcheckstr='<%=CptFieldComInfo.getMandFieldStr() %>';
	if(cusfieldcheckstr!=''){
		checkStr+=cusfieldcheckstr;
	}
	if (check_form(frmain,checkStr)){
		frmain.submit();
	}
	
	
}

function onShowDepartmentMutil(spanname, inputname) {
    
    url=escape("/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+ $GetEle(inputname).value);
    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url, "", "dialogWidth:550px;dialogHeight:550px;");
    try {
    	jsid = new Array();jsid[0] = wuiUtil.getJsonValueByIndex(id, 0); jsid[1] = wuiUtil.getJsonValueByIndex(id, 1);
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
             $GetEle(spanname).innerHTML = jsid[1].substring(1);
             $GetEle(inputname).value = jsid[0].substring(1);
        }else {
             $GetEle(spanname).innerHTML = "";
             $GetEle(inputname).value = "";
        }
    }
}
function onShowDepartment(spanname, inputname) {	
    var url="";
	
	url=escape("/hrm/company/DepartmentBrowser.jsp?selectedids="+document.getElementById(inputname).value);


    id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url);
    try {
        jsid = new VBArray(id).toArray();
    } catch(e) {
        return;
    }
    if (jsid != null) {
        if (jsid[0] != "0" && jsid[1]!="") {
            document.getElementById(spanname).innerHTML = jsid[1];
            document.getElementById(inputname).value = jsid[0];
        }else {
            document.getElementById(spanname).innerHTML = "";
            document.getElementById(inputname).value = "";
        }
    }
}
</script>
<%
String docFlags="";
String formid="0";
String isbill="1";
%>
<script type="text/javascript">
function onShowBrowser3(id,url,linkurl,type1,ismand) {
	onShowBrowser2(id, url, linkurl, type1, ismand, 3);
}

function onShowBrowser2(id,url,linkurl,type1,ismand, funFlag) {
	var id1 = null;
	
    if (type1 == 9  && "<%=docFlags%>" == "1" ) {
        if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
        	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowser.jsp"
        } else {
	    	url = "/systeminfo/BrowserMain.jsp?url=/docs/docs/DocBrowserWord.jsp";
        }
	}
	
	if (type1 == 23) {
		url += "?billid=<%=formid%>";
	}
	if (type1 == 2 || type1 == 19 ) {
	    spanname = "field" + id + "span";
	    inputname = "field" + id;
	    
		if (type1 == 2) {
			onFlownoShowDate(spanname,inputname,ismand);
		} else {
			onWorkFlowShowTime(spanname, inputname, ismand);
		}
	} else {
		if (type1==224 || type1==225 ){
			id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
		}else if (type1==226 || type1==227 ){
			id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
		}
		 else if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170 && type1!=194) {
	    	if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
	    		id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
	    	} else {
			    if (type1 == 161) {
				    id1 = window.showModalDialog(url + "|" + id, window, "dialogWidth=550px;dialogHeight=550px");
				} else {
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
	    	}
		} else {
	        if (type1 == 135) {
				tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        //} else if (type1 == 4 || type1 == 167 || type1 == 164 || type1 == 169 || type1 == 170) {
	        //type1 = 167 是:分权单部门-分部 不应该包含在这里面 ypc 2012-09-06 修改
	        } else if (type1 == 4 || type1 == 164 || type1 == 169 || type1 == 170 || type1 == 194) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 37) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
	        } else if (type1 == 142 ) {
		        tmpids = $GetEle("field"+id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			} else if (type1 == 162 ) {
				tmpids = $GetEle("field"+id).value;

				if (wuiUtil.isNotNull(funFlag) && funFlag == 3) {
					url = url + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, "", "dialogWidth=550px;dialogHeight=550px");
				} else {
					url = url + "|" + id + "&beanids=" + tmpids;
					url = url.substring(0, url.indexOf("url=") + 4) + escape(url.substr(url.indexOf("url=") + 4));
					id1 = window.showModalDialog(url, window, "dialogWidth=550px;dialogHeight=550px");
				}
			} else if (type1 == 165 || type1 == 166 || type1 == 167 || type1 == 168 ) {
		        index = (id + "").indexOf("_");
		        if (index != -1) {
		        	tmpids=uescape("?isdetail=1&isbill=<%=isbill%>&fieldid=" + id.substring(0, index) + "&resourceids=" + $GetEle("field"+id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        } else {
		        	tmpids = uescape("?fieldid=" + id + "&isbill=<%=isbill%>&resourceids=" + $GetEle("field" + id).value+"&selectedids="+$GetEle("field"+id).value);
		        	id1 = window.showModalDialog(url + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
		        }
			} else {
		        tmpids = $GetEle("field" + id).value;
		        if (tmpids == "NULL" || tmpids == "Null" || tmpids == "null") {
		        	tmpids = "";
		        }
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids, "", "dialogWidth=550px;dialogHeight=550px");
			}
		}
		
	    if (id1 != undefined && id1 != null) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170 || type1==194) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0" ) {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = ""

					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					var tlinkurl = linkurl;
					var resourceIdArray = resourceids.split(",");
					var resourceNameArray = resourcename.split(",");
					for (var _i=0; _i<resourceIdArray.length; _i++) {
						var curid = resourceIdArray[_i];
						var curname = resourceNameArray[_i];

						if (type1 == 171 || type1 == 152) {
	                        linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                        if (linkno>0) {
	                        	curid = curid + "&wflinkno=" + linkno;
							} else {
	                        	tlinkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid="
							}
						}
						
						if (tlinkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml += "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml += "<a href=" + tlinkurl + curid + " target=_new>" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field"+id+"span").innerHTML = sHtml;
					$GetEle("field"+id).value= resourceids;
				} else {
 					if (ismand == 0) {
 						$GetEle("field"+id+"span").innerHTML = "";
 					} else {
 						$GetEle("field"+id+"span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
 					}
 					$GetEle("field"+id).value = "";
				}

			} else {
				
				//zzl
				var id0lflag = true;
				if(wuiUtil.getJsonValueByIndex(id1, 1) != ""){
					id0lflag = true;
				}else{
					if(wuiUtil.getJsonValueByIndex(id1, 0) != "0"){
						id0lflag = true;
					}else{
						id0lflag = false;
					}
				}
				//zzl
				
			   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && id0lflag ) {
	               if (type1 == 162) {
				   		var ids = wuiUtil.getJsonValueByIndex(id1, 0);
						var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						sHtml = ""
						ids = ids.substr(1);
						$GetEle("field"+id).value= ids;
						
						names = names.substr(1);
						descs = descs.substr(1);
						var idArray = ids.split(",");
						var nameArray = names.split(",");
						var descArray = descs.split(",");
						for (var _i=0; _i<idArray.length; _i++) {
							var curid = idArray[_i];
							var curname = nameArray[_i];
							var curdesc = descArray[_i];
							//sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp"; ypc 2012-09-14 把此行代码注释掉 此行代码是没有的 会导致自定义多选浏览按钮出现重复值
							if(href==''){
								sHtml += "<a title='" + curdesc + "' >" + curname + "</a>&nbsp";
							}else{
								sHtml += "<a title='" + curdesc + "' href='" + href + curid + "' target='_blank'>" + curname + "</a>&nbsp";
							}
						}
						
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return;
	               }
				   if (type1 == 161) {
					   	var ids = wuiUtil.getJsonValueByIndex(id1, 0);
					   	var names = wuiUtil.getJsonValueByIndex(id1, 1);
						var descs = wuiUtil.getJsonValueByIndex(id1, 2);
						var href = wuiUtil.getJsonValueByIndex(id1, 3);
						$GetEle("field"+id).value = ids;
						//sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						if(href==''){
							sHtml = "<a title='" + descs + "'>" + names + "</a>&nbsp";
						}else{
							sHtml = "<a title='" + descs + "' href='" + href + ids + "' target='_blank'>" + names + "</a>&nbsp";
						}
						$GetEle("field" + id + "span").innerHTML = sHtml;
						return ;
				   }

				   if (type1 == 16) {
					   curid = wuiUtil.getJsonValueByIndex(id1, 0);
                   	   linkno = getWFLinknum("slink" + id + "_rq" + curid);
	                   if (linkno>0) {
	                       curid = curid + "&wflinkno=" + linkno;
	                   } else {
	                       linkurl = linkurl.substring(0, linkurl.indexOf("?") + 1) + "requestid=";
	                   }
	                   $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
					   if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
						   $GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(e);'>" + wuiUtil.getJsonValueByIndex(id1, 1)+ "</a>&nbsp";
					   } else {
	                       $GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + curid + " target='_new'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
					   }
	                   return;
				   }
				   
	               if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
		                tempid = wuiUtil.getJsonValueByIndex(id1, 0);
		                $GetEle("field" + id + "span").innerHTML = "<a href='#' onclick=\"createDoc(" + id + ", " + tempid + ", 1)\">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a><button type=\"button\" id=\"createdoc\" style=\"display:none\" class=\"AddDocFlow\" onclick=\"createDoc(" + id + ", " + tempid + ",1)\"></button>";
	               } else {
	            	    if (linkurl == "") {
				        	$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
				        } else {
							if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
								$GetEle("field"+id+"span").innerHTML = "<a href=javaScript:openhrm("+ wuiUtil.getJsonValueByIndex(id1, 0) + "); onclick='pointerXY(event);'>" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
							} else {
								$GetEle("field"+id+"span").innerHTML = "<a href=" + linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + " target='_new'>"+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
							}
				        }
	               }
	               $GetEle("field"+id).value = wuiUtil.getJsonValueByIndex(id1, 0);
	                if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
	                	var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=createNewDoc]").html("");
	                }
			   } else {
					if (ismand == 0) {
						$GetEle("field"+id+"span").innerHTML = "";
					} else {
						$GetEle("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					}
					$GetEle("field"+id).value="";
					if (type1 == 9 && "<%=docFlags%>" == "1" && (funFlag == undefined || funFlag != 3)) {
						var evt = getEvent();
	               		var targetElement = evt.srcElement ? evt.srcElement : evt.target;
	               		jQuery(targetElement).next("span[id=createNewDoc]").html("<button type=button id='createdoc' class=AddDocFlow onclick=createDoc(" + id + ",'','1') title='<%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82, user.getLanguage())%></button>");
					}
			   }
			}
		}
	}
}

function onShowResourceRole(id, url, linkurl, type1, ismand, roleid) {
	var tmpids = $GetEle("field" + id).value;
	url = url + roleid + "_" + tmpids;

	id1 = window.showModalDialog(url);
	if ((id1)) {

		if (wuiUtil.getJsonValueByIndex(id1, 0) != ""
				&& wuiUtil.getJsonValueByIndex(id1, 0) != "0") {

			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";

			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);

			$GetEle("field" + id).value = resourceids;

			var idArray = resourceids.split(",");
			var nameArray = resourcename.split(",");
			for ( var _i = 0; _i < idArray.length; _i++) {
				var curid = idArray[_i];
				var curname = nameArray[_i];

				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_new'>" + curname + "</a>&nbsp";
			}

			$GetEle("field" + id + "span").innerHTML = sHtml;

		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
		}
	}
}

function onShowResourceConditionBrowser(id, url, linkurl, type1, ismand) {
	var tmpids = $GetEle("field" + id).value;
	var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	if (dialogId) {
		if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
			var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
			var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
			var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
			var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
			var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
			var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
			var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
			var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

			var sHtml = "";
			var fileIdValue = "";
			
			var shareTypeValueArray = shareTypeValues.split("~");
			var shareTypeTextArray = shareTypeTexts.split("~");
			var relatedShareIdseArray = relatedShareIdses.split("~");
			var relatedShareNameseArray = relatedShareNameses.split("~");
			var rolelevelValueArray = rolelevelValues.split("~");
			var rolelevelTextArray = rolelevelTexts.split("~");
			var secLevelValueArray = secLevelValues.split("~");
			var secLevelTextArray = secLevelTexts.split("~");
			for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {
				var shareTypeValue = shareTypeValueArray[_i];
				var shareTypeText = shareTypeTextArray[_i];
				var relatedShareIds = relatedShareIdseArray[_i];
				var relatedShareNames = relatedShareNameseArray[_i];
				var rolelevelValue = rolelevelValueArray[_i];
				var rolelevelText = rolelevelTextArray[_i];
				var secLevelValue = secLevelValueArray[_i];
				var secLevelText = secLevelTextArray[_i];
				if (shareTypeValue == "") {
					continue;
				}
				fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
						+ relatedShareIds + "_" + rolelevelValue + "_"
						+ secLevelValue;
				
				if (shareTypeValue == "1") {
					sHtml = sHtml + "," + shareTypeText + "("
							+ relatedShareNames + ")";
				} else if (shareTypeValue == "2") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage())%>";
				} else if (shareTypeValue == "3") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage())%>";
				} else if (shareTypeValue == "4") {
					sHtml = sHtml
							+ ","
							+ shareTypeText
							+ "("
							+ relatedShareNames
							+ ")"
							+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage())%>="
							+ rolelevelText
							+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage())%>";
				} else {
					sHtml = sHtml
							+ ","
							+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%>>="
							+ secLevelValue
							+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage())%>";
				}

			}
			
			sHtml = sHtml.substr(1);
			fileIdValue = fileIdValue.substr(1);

			$GetEle("field" + id).value = fileIdValue;
			$GetEle("field" + id + "span").innerHTML = sHtml;
		} else {
			if (ismand == 0) {
				$GetEle("field" + id + "span").innerHTML = "";
			} else {
				$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}
			$GetEle("field" + id).value = "";
	    }
	} 
}


function goBack(){
	try{
		history.go(-1);
	}catch(e){}
}

</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
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
});
</script>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
