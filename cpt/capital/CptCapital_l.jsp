<%@page import="weaver.cpt.util.OAuth"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.cpt.util.CptSettingsComInfo" %>
<%
String querystr=request.getQueryString();
String capitalid = Util.null2String(request.getParameter("id"));
String isdialog = Util.null2String(request.getParameter("isdialog"));
String isfromCapitalTab = Util.null2String(request.getParameter("isfromCapitalTab"));
if(!"1".equals(isfromCapitalTab)){
	response.sendRedirect("/cpt/capital/CptCapitalTab.jsp?capitalid="+capitalid+"&isdialog="+isdialog+"&"+querystr);
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
<jsp:useBean id="CptCardGroupComInfo" class="weaver.cpt.util.CptCardGroupComInfo" scope="page" />
<jsp:useBean id="CapitalTransUtil" class="weaver.cpt.util.CapitalTransUtil" scope="page" />
<jsp:useBean id="CptWfUtil" class="weaver.cpt.util.CptWfUtil" scope="page" />
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />

<%
String nameQuery=Util.null2String(request.getParameter("flowTitle"));

%>
<HTML><HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>

<script type="text/javascript">
var parentWin;
var parentDialog;
if("<%=isdialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(parent.window);
	parentDialog = parent.parent.getDialog(parent);
}
</script>

</HEAD>
<%





RecordSet.executeProc("CptCapital_SelectByID",capitalid);
RecordSet.next();
double frozennum = Util.getDoubleValue(RecordSet.getString("frozennum"),0) ;			/*冻结数量*/
String  frozenhelptitle="";
if(frozennum>0){
    frozenhelptitle+= "<ul style='padding-left:15px;'>";
    HashMap<String,String> frozenworkflowmap= CptWfUtil.getCptFrozenWorkflow(capitalid);
    if(frozenworkflowmap!=null&&frozenworkflowmap.size()>0){
        for (Map.Entry<String, String> entry : frozenworkflowmap.entrySet()) {
//            System.out.println("key= " + entry.getKey() + " and value= " + entry.getValue());
            String reqid=entry.getKey();
            String reqnum=entry.getValue();
            frozenhelptitle    +=  	"<li style='padding:5px;'>"+"<a href='javascript:openfrozenwf("+reqid+")'>"+RequestComInfo.getRequestname(reqid)+"</a><span style='color:red;margin-left:15px;'>"+reqnum+"</span>"+"</li>";
        }
    }
    frozenhelptitle+= "</ul>";
}
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
		canviewlog	= true;/*可否查看日志*/
	}
    if(CapitalTransUtil.canDeleteData1(user,capitalid)){
        canDelete=true;
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
		if( sharelevel == 2 ) {//只要有数据共享就可编辑,不需要资产编辑
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
if(canDelete ){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete("+capitalid+"),_self} " ;
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
			
			
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>


<wea:layout>
<%
int fieldcount=0;//用来定位插图片
String needHideField=",";//用来隐藏字段
if(dataornot){//资产资料
	needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,alertnum,";
}else if(!"1".equals( sptcount)){
	needHideField+="deprerate,depreyear,deprestartdate,usedyear,";
}
if("1".equals(sptcount)){
	needHideField+="alertnum,";
}

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
		JSONObject v= entry.getValue();
		int fieldlabel=v.getInt("fieldlabel");
		String fieldName=v.getString("fieldname");
		String fieldValue=CptFieldManager.getFieldvalue(user, v.getInt("id"), v.getInt("fieldhtmltype"), v.getInt("type"), Util.null2String( RecordSet.getString(v.getString("fieldname"))) , 0,true);
		
		
		if("capitalgroupid".equals(fieldName)){
			fieldValue = groupname;
		}
		
		String hideField="{}";
		if(needHideField.indexOf(","+fieldName+",")!=-1){
			hideField="{'samePair':'hideField'}";
		}
		if("resourceid".equals( fieldName)&&dataornot){
			fieldlabel=1507;
		}else if("deprerate".equalsIgnoreCase(fieldName)){
			fieldValue=fieldValue+ " %";
		}else if("barcode".equalsIgnoreCase(fieldName)){
            fieldValue= CptSettingsComInfo.getBarcodeImageStr(request,barcode,mark,capitalid);
        }
		fieldcount++;
		
	%>
	<wea:item attributes='<%=hideField %>'><%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%></wea:item>
	<wea:item attributes='<%=hideField %>'>
		<%=fieldValue %>
		<%
		if(fieldcount==1 && !capitalimageid.equals("") && !capitalimageid.equals("0")){
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
	
	<%
	if(!dataornot&&"startprice".equalsIgnoreCase(fieldName)){
        //显示当前价值
	%>		
	<wea:item><%=SystemEnv.getHtmlLabelName(1389,user.getLanguage())%></wea:item>
	<wea:item><%=currentprice %></wea:item>
	<%
	}else if(!dataornot&&"capitalnum".equalsIgnoreCase(fieldName)&&frozennum>0){
        //冻结数量
    %>
    <wea:item><%=SystemEnv.getHtmlLabelNames("1232,1331", user.getLanguage()) %></wea:item>
    <wea:item><span id="frozenhelpspan" title="<%=frozenhelptitle %>"><%=""+frozennum %>&nbsp;&nbsp;<img src="/images/tooltip_wev8.png" align="absMiddle"/></span></wea:item>
    <%
    }
	
	
	}
}

%>
</wea:group>
	<%
}
%>

	
</wea:layout>


</form>


<Script language="javascript">

function onDelete(id){
    if(id){
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("23271",user.getLanguage())%>",function(){
            var url="/cpt/capital/CptCapitalOperation.jsp";
            jQuery.post(
                    url,
                    {"operation":"deletecapital","id":id,"name":"<%=name %>"},
                    function(data){
                        try{
                            parent.opener._table.reLoad();
                            parent.close();
                        }catch(e){}
                    }
            );
        });
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

function openfrozenwf(requestid){
    openFullWindowHaveBarForWFList('/workflow/request/ViewRequest.jsp?requestid='+requestid+'&isovertime=0',requestid);
}

$(function(){
	//高亮搜索
	$("#topTitle").topMenuTitle({});
	$("#hoverBtnSpan").hoverBtn();
});


</Script>
<script type="text/javascript">
jQuery(function(){
	hideEle('hideField');
    jQuery("#frozenhelpspan").wTooltip({html:true});
});
</script>


<%
if("1".equals(isdialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.close();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>
</BODY>
</HTML>
