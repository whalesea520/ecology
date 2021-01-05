<%@page import="weaver.cpt.util.OAuth"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%
String querystr=request.getQueryString();
String capitalid = Util.null2String(request.getParameter("id"));
String isfromCapitalTab = Util.null2String(request.getParameter("isfromCapitalTab"));
if(!"1".equals(isfromCapitalTab)){
	response.sendRedirect("/cpt/capital/CptCapitalTab.jsp?capitalid="+capitalid+"&"+querystr);
	return;
}
%>

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
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<jsp:useBean id="CapitalCurPrice" class="weaver.cpt.capital.CapitalCurPrice" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="CapitalRelateWFComInfo" class="weaver.cpt.capital.CapitalRelateWFComInfo" scope="page"/>
<jsp:useBean id="WorkflowRequestComInfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>

<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />

<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
weaver.system.CusFormSettingComInfo CusFormSettingComInfo = new weaver.system.CusFormSettingComInfo();
weaver.system.CusFormSetting CusFormSetting= CusFormSettingComInfo.getCusFormSetting("cpt","CptCardView");
if(CusFormSetting!=null&&CusFormSetting.getStatus()==2){//自定义布局页面
	//request.getRequestDispatcher("/cpt/capital/CptCapital_l.jsp").forward(request, response);
	response.sendRedirect("/cpt/capital/CptCapital_l.jsp"+"?"+querystr);
	return;
}
%>
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
<script type="text/javascript">
	hs.graphicsDir = '/js/messagejs/highslide/graphics';
	hs.align = 'center';
	hs.transitions = ['expand', 'crossfade'];
	hs.outlineType = 'rounded-white';
	hs.fadeInOut = true;
	//hs.dimmingOpacity = 0.75;

	// Add the controlbar
	if (hs.addSlideshow) hs.addSlideshow({
		//slideshowGroup: 'group1',
		interval: 5000,
		repeat: false,
		useControls: true,
		fixedControls: false,
		overlayOptions: {
			opacity: 1,
			position: 'top right',
			hideOnMouseOut: false
		}
	});
</script>



</HEAD>
<%





RecordSet.executeProc("CptCapital_SelectByID",capitalid);
RecordSet.next();
String mark = Util.toScreen(RecordSet.getString("mark"),user.getLanguage()) ;			/*编号*/
String name = Util.toScreen(RecordSet.getString("name"),user.getLanguage()) ;			/*名称*/
String barcode = Util.toScreen(RecordSet.getString("barcode"),user.getLanguage()) ;			/*条形码*/
String startdate = Util.toScreen(RecordSet.getString("startdate"),user.getLanguage()) ;			/*生效日*/
String enddate= Util.toScreen(RecordSet.getString("enddate"),user.getLanguage()) ;				/*生效至*/
String seclevel= Util.toScreen(RecordSet.getString("seclevel"),user.getLanguage()) ;				/*安全级别*/
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;/*部门*/
String costcenterid = Util.toScreen(RecordSet.getString("costcenterid"),user.getLanguage()) ;			/*成本中心*/
String resourceid = Util.toScreen(RecordSet.getString("resourceid"),user.getLanguage()) ;		/*人力资源*/
String currencyid = Util.toScreen(RecordSet.getString("currencyid"),user.getLanguage()) ;	/*币种*/
String capitalcost = Util.toScreen(RecordSet.getString("capitalcost"),user.getLanguage()) ;	/*成本*/
if(capitalcost.equals("")){
    capitalcost="0";
}
String startprice = Util.toScreen(RecordSet.getString("startprice"),user.getLanguage()) ;	/*开始价格*/
if(startprice.equals("")){
    startprice="0";
}
String capitaltypeid = Util.toScreen(RecordSet.getString("capitaltypeid"),user.getLanguage()) ;			/*资产类型*/
String capitalgroupid = Util.toScreen(RecordSet.getString("capitalgroupid"),user.getLanguage()) ;			/*资产组*/

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

String unitid = Util.toScreen(RecordSet.getString("unitid"),user.getLanguage()) ;				/*计量单位*/
String capitalnum = Util.toScreen(RecordSet.getString("capitalnum"),user.getLanguage()) ;			/*数量*/
String replacecapitalid = Util.toScreen(RecordSet.getString("replacecapitalid"),user.getLanguage()) ;				/*替代*/
String version = Util.toScreen(RecordSet.getString("version"),user.getLanguage()) ;			/*版本*/
String itemid = "0";//Util.toScreen(RecordSet.getString("itemid"),user.getLanguage()) ;			/*物品*/
String remark = Util.toScreen(RecordSet.getString("remark"),user.getLanguage()) ;			/*备注*/
String depremethod1 = Util.toScreen(RecordSet.getString("depremethod1"),user.getLanguage()) ;			/*折旧法一*/
String depremethod2 = Util.toScreen(RecordSet.getString("depremethod2"),user.getLanguage()) ;			/*折旧法二*/
String deprestartdate = Util.toScreen(RecordSet.getString("deprestartdate"),user.getLanguage()) ;		/*折旧开始日期*/
String depreenddate = Util.toScreen(RecordSet.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String customerid= Util.toScreen(RecordSet.getString("customerid"),user.getLanguage()) ;			/*供应商id*/
String attribute= Util.toScreen(RecordSet.getString("attribute"),user.getLanguage()) ;
String Invoice = Util.toScreen(RecordSet.getString("Invoice"),user.getLanguage()) ;         /*发票号码*/
String StockInDate = Util.toScreen(RecordSet.getString("StockInDate"),user.getLanguage()) ;         /*入库日期*/
String SelectDate = Util.toScreen(RecordSet.getString("SelectDate"),user.getLanguage()) ;         /*购置日期*/
String depreyear  = Util.toScreen(RecordSet.getString("depreyear"),user.getLanguage()) ;			/*折旧年限*/
String deprerate  = Util.toScreen(RecordSet.getString("deprerate"),user.getLanguage()) ;			/*折旧率*/
if(deprerate.equals("")) deprerate="0";
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
String stateid = Util.toScreen(RecordSet.getString("stateid"),user.getLanguage()) ;	/*资产状态*/
String location = Util.toScreen(RecordSet.getString("location"),user.getLanguage()) ;			/*存放地点*/
String createrid = Util.toScreen(RecordSet.getString("createrid"),user.getLanguage()) ;					/*创建人id*/
String createdate = Util.toScreen(RecordSet.getString("createdate"),user.getLanguage()) ;					/*创建日期*/
String createtime = Util.toScreen(RecordSet.getString("createtime"),user.getLanguage()) ;					/*创建时间*/
String lastmoderid = Util.toScreen(RecordSet.getString("lastmoderid"),user.getLanguage()) ;					/*最后修改人id*/
String lastmoddate = Util.toScreen(RecordSet.getString("lastmoddate"),user.getLanguage()) ;					/*修改日期*/
String lastmodtime = Util.toScreen(RecordSet.getString("lastmodtime"),user.getLanguage()) ;					/*修改时间*/
/*new add*/
String depreendprice = Util.toScreen(RecordSet.getString("depreendprice"),user.getLanguage()) ;	/*折旧底价*/
if(depreendprice.equals("")){
    depreendprice="0";
}
String capitalspec = Util.toScreen(RecordSet.getString("capitalspec"),user.getLanguage()) ;	/*规格型号*/
String capitallevel = Util.toScreen(RecordSet.getString("capitallevel"),user.getLanguage()) ;	/*资产等级*/
String manufacturer = Util.toScreen(RecordSet.getString("manufacturer"),user.getLanguage()) ;	/*制造厂商*/
String manudate = Util.toScreen(RecordSet.getString("manudate"),user.getLanguage()) ;	/*出厂日期*/
String currentnum = Util.toScreen(RecordSet.getString("currentnum"),user.getLanguage()) ;	/*当前数量*/
String sptcount = Util.toScreen(RecordSet.getString("sptcount"),user.getLanguage()) ;	/*单独核算*/
//String crmid = Util.toScreen(RecordSet.getString("crmid"),user.getLanguage()) ;	/*单独核算*/
String alertnum= Util.toScreenToEdit(RecordSet.getString("alertnum"),user.getLanguage()) ;	/*报警数量*/
String fnamark= Util.toScreenToEdit(RecordSet.getString("fnamark"),user.getLanguage()) ;	/*财务编号*/
String isinner= Util.toScreenToEdit(RecordSet.getString("isinner"),user.getLanguage()) ;	/*财务编号*/
String blongsubcompany = Util.null2String(RecordSet.getString("blongsubcompany"));/*所属分部*/
String blongdepartment = Util.null2String(RecordSet.getString("blongdepartment"));/*所属部门*/
String issupervision = Util.null2String(RecordSet.getString("issupervision"));/*是否海关检查*/
String amountpay = Util.null2String(RecordSet.getString("amountpay")); /*已付金额*/
String purchasestate = Util.null2String(RecordSet.getString("purchasestate"));/*采购状态*/
String contractno = Util.null2String(RecordSet.getString("contractno"));/*合同号*/
String equipmentpower = Util.null2String(RecordSet.getString("equipmentpower"));/*设备功率*/

String isdata = Util.toScreen(RecordSet.getString("isdata"),user.getLanguage()) ;	/*资产资料判断:1:资料2:资产*/
String capitalimageid = ""; /*照片id 由SequenceIndex表得到，和使用它的表相关联*/
if("2".equals(isdata)){
	capitalimageid = Util.getIntValue(RecordSet.getString("capitalimageid"),0)+"";
	rs.executeSql("select capitalimageid from CptCapital where id = "+Util.null2String(RecordSet.getString("datatype")));
	if(rs.next()&&new Integer(capitalimageid).intValue()<=0){
	   capitalimageid = Util.getFileidOut(rs.getString("capitalimageid")) ;
	}
}else{
	capitalimageid = Util.getFileidOut(RecordSet.getString("capitalimageid")) ;
}
/*2002-9-23*/
String relatewfid = Util.toScreen(RecordSet.getString("relatewfid"),user.getLanguage()) ;	/*资产相关工作流*/
if(relatewfid.equals("")){
	relatewfid = "0";
}
//如果是资料,则不做折旧计算
boolean dataornot = true;//false if is not data;
if(isdata.equals("2")){
	dataornot = false;
}

/*information which need calculate*/
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     			Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
today.roll(Calendar.MONTH,-1);

/*显示权限判断*/
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int userid = user.getUID();
String logintype = ""+user.getLogintype();

boolean displayAll = false;
boolean canedit = false;
boolean canview = false;
boolean canDelete = false;
boolean canviewlog = false;
boolean onlyview=false;
/*有显示权限的可以查看所有资产*/
if(HrmUserVarify.checkUserRight("CptCapital:Display",user))  {
	displayAll=	true;
	canview=true;
}

/*可否编辑*/
/*由于现在资产资料和资产的权限控制完全不同所以需做以下区分*/
if (isdata.equals("1")) {
    // added by lupeng 2204-07-21 for TD558
    if (HrmUserVarify.checkUserRight("Capital:Maintenance",user)) {
        canview = true;
		canedit = true;
		canDelete = true;
		canviewlog	= true;/*可否查看日志*/
	}
    // end
} else {
	if (HrmUserVarify.checkUserRight("CptCapitalEdit:Delete",user)) {
		canDelete = true;
	}
	/*共享权限判断*/
	RecordSetShare.executeSql(CommonShareManager.getSharLevel("cpt", capitalid, user) );
	if( RecordSetShare.next() ) {
		int sharelevel = Util.getIntValue(RecordSetShare.getString(1), 0) ;
		if( sharelevel == 2 ) {
			canedit     =   true;
			canviewlog	 = true;
		}
		canview    =   true ;
	}
	if(HrmUserVarify.checkUserRight("CptCapital:modify", user)){//资产变更
		canedit     =   true;
		canviewlog	 = true;
		canview    =   true ;
	}
	
}

if(!canview){
	boolean isurger=WFUrgerManager.UrgerHaveCrmViewRight(requestid,userid,Util.getIntValue(logintype),capitalid);
	boolean ismoitor=WFUrgerManager.getMonitorViewObjRight(requestid,userid,""+capitalid,"3");
	if(OAuth.onlyView(user, "cpt", request, new JSONObject())){
		onlyview=true;
	}else if(!isurger && !ismoitor){
        response.sendRedirect("/notice/noright.jsp") ;
        return ;
    }else{
        onlyview=true;
    }
}

if(!canview&&!onlyview){
	response.sendRedirect("/notice/noright.jsp") ;
    return ;
}
/*权限判断结束*/

//String deprerate = "";       /*残值率*/
//String monthdepre = "";   /*月折旧率*/
String currentprice = startprice;    /*当前价值*/
String usedyear = "0";			/*使用年限*/
String usedmonth = "0";		/*使用月份*/
if(!dataornot){ //资产
/*计算当前价值*/
    CapitalCurPrice.setSptcount(sptcount);
    CapitalCurPrice.setStartprice(startprice);
    CapitalCurPrice.setCapitalnum(capitalnum);
    CapitalCurPrice.setDeprestartdate(deprestartdate);
    CapitalCurPrice.setDepreyear(depreyear);
    CapitalCurPrice.setDeprerate(deprerate);
    
    usedyear=CapitalCurPrice.getUsedYear();
    currentprice=CapitalCurPrice.getCurPrice();
}

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

// 文档的总数
DocSearchComInfo.resetSearchInfo();
DocSearchComInfo.addDocstatus("1");
DocSearchComInfo.addDocstatus("2");
DocSearchComInfo.addDocstatus("5");
DocSearchComInfo.setAssetid(capitalid);
String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
DocSearchManage.getSelectResultCount(whereclause,user) ;
String doccount=""+DocSearchManage.getRecordersize();




String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
if(dataornot){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage())+" : "+name;
}else{
	titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage())+" : "+name;
}
String newtitlename = titlename;
String needfav ="1";
String needhelp ="";
%>
<BODY>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
	session.setAttribute("fav_pagename" , newtitlename ) ;	
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(canedit ){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:onEdit("+capitalid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}


if(!"1".equals( isdata)&&sptcount.equals("1")&&HrmUserVarify.checkUserRight("CptCapital:Return",user)&&(stateid.equals("2")||stateid.equals("3")||stateid.equals("4"))){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1384,user.getLanguage())+",javascript:onGiveback("+capitalid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}

if(!"1".equals( isdata)&&sptcount.equals("1")&&HrmUserVarify.checkUserRight("CptCapital:Mend",user)&&(!stateid.equals("4")&&!stateid.equals("5"))){
	RCMenu += "{"+SystemEnv.getHtmlLabelNames("83557",user.getLanguage())+",javascript:onMend("+capitalid+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}



//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.go(-2),_self} ";
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM name=frmain id=frmain action=CptCapitalOperation.jsp method=post enctype="multipart/form-data">
<input type=hidden name=operation value="deletecapital">
<input type=hidden name="id" value="<%=capitalid%>">
<input type=hidden name="name" value="<%=name%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		
		<%
		if(canedit){
			%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %> " class="e8_btn_top" onclick="onEdit(<%=capitalid %>)"/>
			<%
		}
		%>
			
			
			<input type="text" class="searchInput" name="flowTitle"  value="<%=nameQuery %>" />
			&nbsp;&nbsp;&nbsp;
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<wea:layout>
	<!-- baseinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
		<wea:item>
			<%=name %>
			<%
			if(!capitalimageid.equals("") && !capitalimageid.equals("0")){
			%>
			<div style='position:absolute;top:61px;right:0px;
				width:300px;height:215px;border:1px double #E6E6E6' id='float-div' >
				<a href="/weaver/weaver.file.FileDownload?fileid=<%=capitalimageid%>" class="highslide"  onclick="return hs.expand(this)" style="width:300px;height:215px;">
					<img style="width:300px;height:215px;" src="/weaver/weaver.file.FileDownload?fileid=<%=capitalimageid%>" alt="<%=SystemEnv.getHtmlLabelName(128241,user.getLanguage())%>" title="<%=SystemEnv.getHtmlLabelName(128241,user.getLanguage())%>" />
				</a>
			</div>
			<%
			}
			%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
		<wea:item><%=mark %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
		<wea:item><%=groupname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
		<wea:item><%=capitalspec %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></wea:item>
		<wea:item><%=manufacturer %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></wea:item>
		<wea:item><%=capitallevel %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(attribute.equals("0")) {%>
			<%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%>
			<%}%>
			<% if(attribute.equals("1")) {%>
			<%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%>
			<%}%>
			<% if(attribute.equals("2")) {%>
			<%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%>
			<%}%>
			<% if(attribute.equals("3")) {%>
			<%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%>
			<%}%>
			<% if(attribute.equals("4")) {%>
			<%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%>
			<%}%>
			<% if(attribute.equals("5")) {%>
			<%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%>
			<%}%>
			<% if(attribute.equals("6")) {%>
			<%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%>
			<%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%></wea:item>
		
<%
if(!dataornot){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></wea:item>
		<wea:item><%=barcode %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></wea:item>
		<wea:item><%=fnamark %></wea:item>
	<%
}
if(!dataornot &&!"1".equals( sptcount)){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15294,user.getLanguage())%></wea:item>
		<wea:item><%=alertnum %></wea:item>
	<%
}

%>		
		
	</wea:group>
	
	<!-- manageinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27858,user.getLanguage())%>'>
<%
if(!dataornot){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="cptstatus_span">
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
			</span>
		</wea:item>
	<%
}
%>			
		<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
		<wea:item><%=SubCompanyComInfo.getSubCompanyname(blongsubcompany)%></wea:item>
		
<%
if(!dataornot){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></wea:item>
		<wea:item><%=DepartmentComInfo.getDepartmentname(blongdepartment)%></wea:item>
	<%
}
%>		

		<wea:item><%=SystemEnv.getHtmlLabelName((!dataornot?1508:1507),user.getLanguage()) %></wea:item>
		<wea:item><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></wea:item>
<%
if(!dataornot){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%></wea:item>
	<%
}
%>			
		<wea:item><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=checkbox value="1" readonly="readonly" <%="1".equals(sptcount)?"checked":"" %> />
		</wea:item>
<%
if(!dataornot){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></wea:item>
		<wea:item><%=capitalnum %></wea:item>
	<%
}
%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></wea:item>
		<wea:item><%=version %></wea:item>
<%
if(!dataornot){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></wea:item>
		<wea:item>
			<% if(isinner.equals("1")) {%><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%><%} else if(isinner.equals("2")) {%><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%> <%}%>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></wea:item>
		<wea:item><%=startdate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></wea:item>
		<wea:item><%=enddate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></wea:item>
		<wea:item><%=manudate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
		<wea:item><%=StockInDate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></wea:item>
		<wea:item><%=location %></wea:item>
	<%
}
%>		
		
	</wea:group>
	
	<!-- supplyinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></wea:item>
		<wea:item><%=startprice %></wea:item>
<%
if("2".equals(isdata)){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1389,user.getLanguage())%></wea:item>
		<wea:item><%=currentprice %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item>
		<wea:item><%=SelectDate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></wea:item>
		<wea:item><%=contractno %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></wea:item>
		<wea:item><%=Invoice %></wea:item>
	
	<%
}
%>	
	</wea:group>

	
	<!-- depinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1374,user.getLanguage())%>' attributes="{'samePair':'depinfogroup'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></wea:item>
		<wea:item><%=depreyear %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></wea:item>
		<wea:item><%=deprerate %>%</wea:item>
<%
if(!dataornot && sptcount.equals("1")){
	%>
		<wea:item><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></wea:item>
		<wea:item><%=deprestartdate %></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1388,user.getLanguage())%></wea:item>
		<wea:item><%=usedyear %></wea:item>
		
	<%
}

%>		
		
	</wea:group>
	
	<!-- otherinfo -->
	<wea:group context='<%=SystemEnv.getHtmlLabelName(410,user.getLanguage())%>'>

<%
//cusfield
TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= entry.getValue();
	
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
	<wea:item><%=CptFieldManager.getFieldvalue(user, v.getInt("id"), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet.getString(v.getString("fieldname"))) , 0) %></wea:item>
	
	<%
	}
}

%>

	
		
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		<wea:item><%=remark %></wea:item>
		
	</wea:group>
	
</wea:layout>


</form>


<Script language="javascript">





function onDelete(obj){
		if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
			jQuery("input[name=operation]").val("deletecapital");
			document.forms[0].submit();
            obj.disabled=true;
		}
}

function onEdit(id){
	if(id){
		window.location.href="CptCapitalEdit.jsp?id="+id;
	}
}
function onGiveback(id){
	if(id){
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("83559",user.getLanguage())%>",function(){
			var url="/cpt/capital/CptCapitalBackOperation.jsp";
			jQuery.post(
				url,
				{"method":"backMyCpt","capitalid":id},
				function(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83560",user.getLanguage())%>",function(){
						window.location.reload();
					});
				}
			);
		});
	}
}

function onMend(id){
	if(id){
		var url="/cpt/capital/CptCapitalMendOne.jsp?isdialog=1&capitalid="+id;
		var title="<%=SystemEnv.getHtmlLabelNames("83557",user.getLanguage())%>"
		openDialog(url,title,650,450,true);
	}
}



$(function(){
	//高亮搜索
	$("#topTitle").topMenuTitle({});
});


</Script>
<script type="text/javascript">
jQuery(function(){
	var sptcount='<%=sptcount %>';
	if(sptcount!=1){
		hideGroup('depinfogroup');
	}
});
</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</BODY>
</HTML>
