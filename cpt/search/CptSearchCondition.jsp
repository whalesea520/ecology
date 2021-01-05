<%@page import="weaver.cpt.util.html.HtmlElement"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.*"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs_condition" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="LanguageComInfo" class="weaver.systeminfo.language.LanguageComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page"/>



<%
//初始展现查询条件
String initDisplayCptSearchCondition=Util.null2String( (String)session.getAttribute("initDisplayCptSearchCondition"));
session.removeAttribute("initDisplayCptSearchCondition");

CptSearchComInfo.resetSearchInfo();


String from = Util.null2String(request.getParameter("from"));
String isdata = Util.null2String(request.getParameter("isdata"));

String needshowadv = Util.null2String(request.getParameter("needshowadv"));
String typedesc = Util.null2String(request.getParameter("typedesc"));
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
String parentid=CptSearchComInfo.getCapitalgroupid();
rs.executeSql("select cptdetachable from SystemSet");
int detachable=0;
if(rs.next()){
    detachable=rs.getInt("cptdetachable");
}
String CurrentUser = ""+user.getUID();
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String logintype = ""+user.getLogintype();
String ProcPara = "";
char flag = 2;
ProcPara = CurrentUser;
ProcPara += flag+logintype;

int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
int perpage=Util.getIntValue(request.getParameter("perpage"),0);
if(perpage<=1 )	perpage=10;

//添加判断权限的内容--new

String tempsearchsql = CptSearchComInfo.FormatSQLSearch();
String rightStr = "";
if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
	rightStr = "Capital:Maintenance";
}
String blonsubcomid = "";
int userId = user.getUID();
int belid = user.getUserSubCompany1();
//权限条件 modify by ds Td:9699
if(detachable == 1 && userId!=1){
	if(isdata.endsWith("2")){
		String sqltmp = "";
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+rightStr);
		while(rs2.next()){
		    blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//角色设置的权限
			sqltmp = sqltmp.substring(1);

				tempsearchsql += " and blongsubcompany in ("+sqltmp+") ";
		}else{
				tempsearchsql += " and blongsubcompany in ("+belid+") ";		
		}
	}
}
String type= Util.fromScreen(request.getParameter("type"),user.getLanguage()) ;

String strData="";
String strURL="";
%>



<%
//高级搜索
int mouldid=Util.getIntValue(request.getParameter("mouldid"),0);

String mark = "";			/*编号*/
String name = "";			/*名称*/
String startdate = "";			/*生效日从*/
String startdate1 = "";			/*生效日到*/
String enddate= "";				/*生效至从*/
String enddate1= "";				/*生效至到*/
String seclevel= "";				/*安全级别从*/
String seclevel1= "";				/*安全级别到*/
String subcompanyid = "";           /*分部*/
String departmentid = "";/*部门*/
String costcenterid = "";			/*成本中心*/
String resourceid = "";		/*人力资源*/
String currencyid = "";	/*币种*/
String capitalcost = "";	/*成本从*/
String capitalcost1 = "";	/*成本到*/
String startprice = "";	/*开始价格从*/
String startprice1 = "";	/*开始价格到*/
String depreendprice = ""; /*折旧底价(新)从*/
String depreendprice1 = ""; /*折旧底价(新)到*/
String capitalspec = "";			/*规格型号(新)*/
String capitallevel = "";	/*资产等级(新)*/
String manufacturer	= "";			/*制造厂商(新)*/
String manudate	= "";			/*出厂日期(新)从*/
String manudate1	= "";			/*出厂日期(新)到*/
String capitaltypeid = "";			/*资产类型*/
String capitalgroupid = "";			/*资产组*/
String unitid = "";				/*计量单位*/
String capitalnum = "";			/*数量从*/
String capitalnum1 = "";			/*数量到*/
String currentnum = "";			/*当前数量从*/
String currentnum1 = "";			/*当前数量到*/
String replacecapitalid ="";				/*替代*/
String version = "" ;			/*版本*/
String itemid ="";			/*物品*/
String depremethod1 ="";			/*折旧法一*/
String depremethod2 ="";			/*折旧法二*/
String deprestartdate ="";		/*折旧开始日期从*/
String deprestartdate1 ="";		/*折旧开始日期到*/
String depreenddate ="" ;			/*折旧结束日期从*/
String depreenddate1 ="" ;			/*折旧结束日期到*/
String customerid="";			/*客户id*/
String attribute= "";
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
String stateid = "";	/*资产状态*/
String location = "";			/*存放地点*/
String counttype = "";		/*固资或低耗*/
String isinner = "";		/*帐内或帐外*/
String stockindate	= "";			/*入库日期从*/
String stockindate1	= "";		    /*入库日期到*/

String fnamark = ""; /*财务编号*/
String barcode = ""; /*条形码*/
String blongdepartment = "";/*所属部门*/
String blongsubcompany = "";/*所属分部*/
String sptcount = "";/*单独核算*/
String relatewfid = ""; /*相关工作流*/
String SelectDate = "";/*购置日期*/
String SelectDate1 = "";/*购置日期1*/
String contractno = "";/*合同号*/
String Invoice = "";/*发票号*/
String depreyear = "";/*折旧年限*/
String deprerate = "";/*残值率*/
String depreyear1 = "";/*折旧年限*/
String deprerate1 = "";/*残值率*/
String issupervision = "";/*是否海关监管*/
String amountpay = "";/*已付金额*/
String amountpay1 = "";/*已付金额*/
String purchasestate = "";/*采购状态*/
String alertnum ="";/*报警数量*/

if(mouldid!=0){
	RecordSet.executeProc("CptSearchMould_SelectByID",""+mouldid);
	RecordSet.next();
	mark = Util.toScreenToEdit(RecordSet.getString("mark"),user.getLanguage()) ;				/*编号*/
	name = Util.toScreenToEdit(RecordSet.getString("name"),user.getLanguage());			/*名称*/
	startdate = Util.toScreenToEdit(RecordSet.getString("startdate"),user.getLanguage());			/*生效日*/
	startdate1 = Util.toScreenToEdit(RecordSet.getString("startdate1"),user.getLanguage());			/*生效日*/
	enddate= Util.toScreenToEdit(RecordSet.getString("enddate"),user.getLanguage());				/*生效至*/
	enddate1= Util.toScreenToEdit(RecordSet.getString("enddate1"),user.getLanguage());				/*生效至*/
	seclevel= Util.toScreenToEdit(RecordSet.getString("seclevel"),user.getLanguage());				/*安全级别*/
	seclevel1= Util.toScreenToEdit(RecordSet.getString("seclevel1"),user.getLanguage());				/*安全级别*/
	departmentid = Util.toScreenToEdit(RecordSet.getString("departmentid"),user.getLanguage());/*部门*/
	costcenterid = Util.toScreenToEdit(RecordSet.getString("costcenterid"),user.getLanguage());			/*成本中心*/
	resourceid = Util.toScreenToEdit(RecordSet.getString("resourceid"),user.getLanguage());		/*人力资源*/
	currencyid = Util.toScreenToEdit(RecordSet.getString("currencyid"),user.getLanguage());	/*币种*/
	capitalcost = Util.toScreenToEdit(RecordSet.getString("capitalcost"),user.getLanguage());	/*成本*/
	capitalcost1 = Util.toScreenToEdit(RecordSet.getString("capitalcost1"),user.getLanguage());	/*成本*/
	startprice = Util.toScreenToEdit(RecordSet.getString("startprice"),user.getLanguage());	/*开始价格*/
	startprice1 = Util.toScreenToEdit(RecordSet.getString("startprice1"),user.getLanguage());	/*开始价格*/
	depreendprice = Util.toScreenToEdit(RecordSet.getString("depreendprice"),user.getLanguage()); /*折旧底价(新)*/
	depreendprice1 = Util.toScreenToEdit(RecordSet.getString("depreendprice1"),user.getLanguage()); /*折旧底价(新)*/
	capitalspec = Util.toScreenToEdit(RecordSet.getString("capitalspec"),user.getLanguage());			/*规格型号(新)*/
	capitallevel = Util.toScreenToEdit(RecordSet.getString("capitallevel"),user.getLanguage());	/*资产等级(新)*/
	manufacturer = Util.toScreenToEdit(RecordSet.getString("manufacturer"),user.getLanguage());			/*制造厂商(新)*/
	manudate	= Util.toScreenToEdit(RecordSet.getString("manudate"),user.getLanguage());			/*出厂日期(新)*/
	manudate1	= Util.toScreenToEdit(RecordSet.getString("manudate1"),user.getLanguage());			/*出厂日期(新)*/
	capitaltypeid = Util.toScreenToEdit(RecordSet.getString("capitaltypeid"),user.getLanguage());			/*资产类型*/
	capitalgroupid = Util.toScreenToEdit(RecordSet.getString("capitalgroupid"),user.getLanguage());			/*资产组*/
	unitid = Util.toScreenToEdit(RecordSet.getString("unitid"),user.getLanguage());				/*计量单位*/
	capitalnum = Util.toScreenToEdit(RecordSet.getString("capitalnum"),user.getLanguage());			/*数量*/
	capitalnum1 = Util.toScreenToEdit(RecordSet.getString("capitalnum1"),user.getLanguage());			/*数量*/
	currentnum = Util.toScreenToEdit(RecordSet.getString("currentnum"),user.getLanguage());			/*当前数量*/
	currentnum1 = Util.toScreenToEdit(RecordSet.getString("currentnum1"),user.getLanguage());			/*当前数量*/
	replacecapitalid =Util.toScreenToEdit(RecordSet.getString("replacecapitalid"),user.getLanguage());				/*替代*/
	version =Util.toScreenToEdit(RecordSet.getString("version"),user.getLanguage()) ;			/*版本*/
	itemid =Util.toScreenToEdit(RecordSet.getString("itemid"),user.getLanguage());			/*物品*/
	depremethod1 =Util.toScreenToEdit(RecordSet.getString("depremethod1"),user.getLanguage());			/*折旧法一*/
	depremethod2 =Util.toScreenToEdit(RecordSet.getString("depremethod2"),user.getLanguage());			/*折旧法二*/
	deprestartdate =Util.toScreenToEdit(RecordSet.getString("deprestartdate"),user.getLanguage());		/*折旧开始日期*/
	deprestartdate1 =Util.toScreenToEdit(RecordSet.getString("deprestartdate1"),user.getLanguage());		/*折旧开始日期*/
	depreenddate = Util.toScreenToEdit(RecordSet.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
	depreenddate1 = Util.toScreenToEdit(RecordSet.getString("depreenddate1"),user.getLanguage()) ;			/*折旧结束日期*/
	customerid=Util.toScreenToEdit(RecordSet.getString("customerid"),user.getLanguage());			/*客户id*/
	attribute= Util.toScreenToEdit(RecordSet.getString("attribute"),user.getLanguage());
	stateid = Util.toScreenToEdit(RecordSet.getString("stateid"),user.getLanguage());	/*资产状态*/
	location = Util.toScreenToEdit(RecordSet.getString("location"),user.getLanguage()) ;			/*存放地点*/
	isdata = Util.toScreenToEdit(RecordSet.getString("isdata"),user.getLanguage()) ;			/*资产或资料*/
	counttype = Util.toScreenToEdit(RecordSet.getString("counttype"),user.getLanguage()) ;			/*固资或低耗*/
	isinner = Util.toScreenToEdit(RecordSet.getString("isinner"),user.getLanguage()) ;			/*帐内或帐外*/
    stockindate	    = Util.toScreenToEdit(RecordSet.getString("stockindate"),user.getLanguage()) ;			/*入库日期从*/
    stockindate1	= Util.toScreenToEdit(RecordSet.getString("stockindate1"),user.getLanguage()) ;		    /*入库日期到*/


	fnamark = Util.toScreenToEdit(RecordSet.getString("fnamark"),user.getLanguage()); /*财务编号*/
	barcode = Util.toScreenToEdit(RecordSet.getString("barcode"),user.getLanguage()); /*条形码*/
	blongdepartment = Util.toScreenToEdit(RecordSet.getString("blongdepartment"),user.getLanguage());/*所属部门*/
	blongsubcompany = Util.toScreenToEdit(RecordSet.getString("blongsubcompany"),user.getLanguage());/*所属分部*/
	sptcount = Util.toScreenToEdit(RecordSet.getString("sptcount"),user.getLanguage());/*单独核算*/
	relatewfid = Util.toScreenToEdit(RecordSet.getString("relatewfid"),user.getLanguage()); /*相关工作流*/
	SelectDate = Util.toScreenToEdit(RecordSet.getString("SelectDate"),user.getLanguage());/*购置日期*/
	SelectDate1 = Util.toScreenToEdit(RecordSet.getString("SelectDate1"),user.getLanguage());/*购置日期1*/
	contractno = Util.toScreenToEdit(RecordSet.getString("contractno"),user.getLanguage());/*合同号*/
	Invoice = Util.toScreenToEdit(RecordSet.getString("Invoice"),user.getLanguage());/*发票号*/
	depreyear = Util.toScreenToEdit(RecordSet.getString("depreyear"),user.getLanguage());/*折旧年限*/
	deprerate = Util.toScreenToEdit(RecordSet.getString("deprerate"),user.getLanguage());/*残值率*/
	depreyear1 = Util.toScreenToEdit(RecordSet.getString("depreyear1"),user.getLanguage());/*折旧年限*/
	deprerate1 = Util.toScreenToEdit(RecordSet.getString("deprerate1"),user.getLanguage());/*残值率*/
	issupervision = Util.toScreenToEdit(RecordSet.getString("issupervision"),user.getLanguage());/*是否海关监管*/
	amountpay = Util.toScreenToEdit(RecordSet.getString("amountpay"),user.getLanguage());/*已付金额*/
	amountpay1 = Util.toScreenToEdit(RecordSet.getString("amountpay1"),user.getLanguage());/*已付金额*/
	purchasestate = Util.toScreenToEdit(RecordSet.getString("purchasestate"),user.getLanguage());/*采购状态*/
	alertnum = Util.toScreenToEdit(RecordSet.getString("alertnum"),user.getLanguage());/*自定义日期类型*/
	
	

} else {
	isdata = Util.null2String(request.getParameter("isdata"));
    resourceid = Util.null2String(request.getParameter("resourceid"));
    type = Util.null2String(request.getParameter("type"));
    if(type.equals("")) type="search";
    
    
}

int rownum = 0;
int halfnum = 0;
if (isdata.equals(""))
	isdata = "1";

String needHideField=",";//用来隐藏字段
if("1".equals(isdata) ){//资产资料
	needHideField+="isinner,barcode,fnamark,stateid,blongdepartment,departmentid,capitalnum,startdate,enddate,manudate,stockindate,location,selectdate,contractno,invoice,deprestartdate,usedyear,currentprice,StockInDate,SelectDate,Invoice,";
}
%>



<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/common_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>

</HEAD>
<%
String titlename = "";
if(CptSearchComInfo.getIsData().equals("1")){
	titlename = SystemEnv.getHtmlLabelName(1509,user.getLanguage());
}else{
	titlename = SystemEnv.getHtmlLabelName(535,user.getLanguage());
}


String imagefilename = "/images/hdDOC_wev8.gif";
titlename = SystemEnv.getHtmlLabelName(197,user.getLanguage())+SystemEnv.getHtmlLabelName(356,user.getLanguage())+" - "+titlename;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%if(!isfromtab) {%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%} %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%


RCMenu += "{"+SystemEnv.getHtmlLabelName( 197 ,user.getLanguage())+",javascript:onSearch(),_top} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:onReset(),_top}" ;
RCMenuHeight += RCMenuHeightStep ;

if(mouldid==0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(350,user.getLanguage())+",javascript:onSaveas(),_top}";
RCMenuHeight += RCMenuHeightStep;
}

if(mouldid!=0) {
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top}" ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_top}" ;
RCMenuHeight += RCMenuHeightStep;
}

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="form2" id="form2" method="post"  action="SearchOperation.jsp" >
<input type="hidden" name="capitalgroupid" value="<%=parentid %>" />
<input type="hidden" name="paraid" value="<%=parentid %>" />
<input type="hidden" name="fromassortmenttab_name" value="<%=nameQuery %>" />
<input type="hidden" name="fromassortmenttab_isdata" value="<%=isdata %>" />
<input type="hidden" name="from" value="<%=from %>" />
<input type="hidden" name="isdata" value="<%=isdata %>" />
<input type="hidden" name="needshowadv" id="needshowadv" value="<%=needshowadv %>" />

<input type="hidden" name="mouldname" value="" />
<input type="hidden" name="operation" value="" />

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input class="e8_btn_top" type="button" name="btn_search" value="<%=SystemEnv.getHtmlLabelNames("197",user.getLanguage())%>" onclick="onSearch();" />
			<input class="e8_btn_top" type="button" name="btn_reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>" onclick="$('input[name=reset]').trigger('click');" />
<%
if(mouldid>0){
	%>
			<input class="e8_btn_top" type="button" name="savetmp" value="<%=SystemEnv.getHtmlLabelNames("86",user.getLanguage())%>" onclick="onSave();" />
	<%
}else{
	%>
			<input class="e8_btn_top" type="button" name="saveastmp" value="<%=SystemEnv.getHtmlLabelNames("18418",user.getLanguage())%>" onclick="onSaveas();" />
	<%
}
%>			
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>


<%

	ArrayList<String> fieldnames=new ArrayList<String>();
	if(mouldid==0){
		rs.executeSql("select t1.* from CptSearchDefinition t1 left outer join cptDefineField t2 on lower(t1.fieldname)=lower(t2.fieldname) where t1.isconditions = 1 and t1.isseniorconditions = 0 and t1.mouldid=-1 and t2.isopen='1' order by displayorder asc");	
	}else{
		rs.executeSql("select t1.* from CptSearchDefinition t1 left outer join cptDefineField t2 on lower(t1.fieldname)=lower(t2.fieldname) where t1.isconditions = 1 and t1.isseniorconditions = 0 and t1.mouldid="+mouldid+" and t2.isopen='1' order by displayorder asc");	
	}
	rownum = rs.getCounts();
	while(rs.next()){
		String fieldname =Util.null2String( rs.getString("fieldname"));
		if(needHideField.indexOf(","+fieldname+",")==-1){
			fieldnames.add(fieldname.toLowerCase());
		}
		//halfnum++;
	}
%>	
	<wea:layout type="4col">
	    <wea:group context='<%=SystemEnv.getHtmlLabelNames("32905",user.getLanguage())%>'>
	    	<wea:item type="groupHead" >
	    		<select name="mouldid" id="mouldid" style="width: 135px;">
	    			<option value="0" ><%=SystemEnv.getHtmlLabelNames("149",user.getLanguage())%></option>
	    			<%
	    			rs.executeSql("select id,mouldname from CptSearchMould where userid='"+user.getUID()+"' ");
	    			while(rs.next()){
	    				int mid=Util.getIntValue( rs.getString("id"));
	    				String mname=Util.null2String( rs.getString("mouldname"));
	    				%>
	    				<option value="<%=rs.getString("id") %>" <%=mouldid==mid?"selected":"" %>><%=mname %></option>
	    				<%
	    				
	    			}
	    			%>
	    		</select>
	    	</wea:item>
<!-- 名称 -->
<%if(fieldnames.contains("name")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 name="name" size=30 value="<%=name%>">
			</wea:item>
<%} %>
<!-- 编号 -->
<%if(fieldnames.contains("mark")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 name="mark" value="<%=mark%>">
			</wea:item>
<%} %>
<!-- 规格型号 -->
<%if(fieldnames.contains("capitalspec")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(904,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 value="<%=capitalspec%>" name="capitalspec">
			</wea:item>
<%} %>
<!-- 财务编号 -->
<%if(fieldnames.contains("fnamark")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15293,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 name="fnamark" value="<%=fnamark%>">
			</wea:item>
<%} %>
<!-- 资产组 -->
<%if(fieldnames.contains("capitalgroupid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(831,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="capitalgroupid1" browserValue='<%=capitalgroupid%>' browserSpanValue='<%=Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CptAssortmentBrowser.jsp" completeUrl="/data.jsp?type=25"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 资产类型 -->
<%if(fieldnames.contains("capitaltypeid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(703,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="capitaltypeid" browserValue='<%=capitaltypeid%>' browserSpanValue='<%=Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalTypeBrowser.jsp" completeUrl="/data.jsp?type=25"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="false"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 单独核算 -->
<%if(fieldnames.contains("sptcount")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(707,user.getLanguage())%></wea:item>
			<wea:item>
				<select name=sptcount >
					<option value=""><%=SystemEnv.getHtmlLabelNames("332",user.getLanguage())%></option>
					<option value="1" <%="1".equals(sptcount)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(1363,user.getLanguage())%></option>
					<option value="0" <%="0".equals(sptcount)?"selected":"" %> ><%=SystemEnv.getHtmlLabelName(125023,user.getLanguage())%></option>
				</select>
			</wea:item>
<%} %>
<!-- 条形码 -->
<%if(fieldnames.contains("barcode")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1362,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 name="barcode" value="<%=barcode%>">
			</wea:item>
<%} %>
		</wea:group>
		
		
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("27858",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','itemAreaDisplay':''}">
		
		
<!-- 所属部门 -->
<%if(fieldnames.contains("blongdepartment")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15393,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="blongdepartment" browserValue='<%=blongdepartment%>' browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(blongdepartment),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" completeUrl="/data.jsp?type=4"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 所属分部 -->
<%if(fieldnames.contains("blongsubcompany")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="blongsubcompany" browserValue='<%=blongsubcompany%>' browserSpanValue='<%=Util.toScreen(SubCompanyComInfo.getSubCompanyname (blongsubcompany),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp" completeUrl="/data.jsp?type=164"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 使用部门 -->
<%if(fieldnames.contains("departmentid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(21030,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="departmentid" browserValue='<%=departmentid%>' browserSpanValue='<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp" completeUrl="/data.jsp?type=4"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 人力资源/使用人/管理员 -->
<%if(fieldnames.contains("resourceid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelNames(("1".equals(isdata)?"1507" :"1508"),user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="resourceid" browserValue='<%=resourceid%>' browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename (resourceid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" completeUrl="/data.jsp"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 状态 -->
<%if(fieldnames.contains("stateid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="stateid" browserValue='<%=stateid%>' browserSpanValue='<%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(stateid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/maintenance/CapitalStateBrowser.jsp?from=search" completeUrl="/data.jsp?type=?"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="false"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 数量 -->
<%if(fieldnames.contains("capitalnum")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></wea:item>
			<wea:item>
				<div style="white-space: nowrap;" >
				<input class=InputStyle style="width:40%!important;" maxlength=10 size=10 value="<%=capitalnum%>" name="capitalnum" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum")'>
				-<input class=InputStyle style="width:40%!important;" maxlength=10 size=10 value="<%=capitalnum1%>" name="capitalnum1" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("capitalnum1")'>
				</div>
			</wea:item>
<%} %>
<!-- 替代 -->
<%if(fieldnames.contains("replacecapitalid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1371,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="replacecapitalid" browserValue='<%=replacecapitalid%>' browserSpanValue='<%=Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp" completeUrl="/data.jsp?type=23"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 帐内或帐外 -->
<%if(fieldnames.contains("isinner")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15297,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle id=isinner name=isinner>
					<option value="" <% if(isinner.equals("")) {%>selected<%}%>></option>
				  	<option value=0 <% if(isinner.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15298,user.getLanguage())%></option>
				  	<option value=1 <% if(isinner.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15299,user.getLanguage())%></option>
				</select>
			</wea:item>
<%} %>
<!-- 生效日 -->
<%if(fieldnames.contains("startdate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(717,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="selectstartdate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="startdate" value="<%=startdate%>">
				    <input class=wuiDateSel  type="hidden" name="startdate1" value="<%=startdate1%>">
				</span>
			</wea:item>
<%} %>
<!-- 生效至 -->
<%if(fieldnames.contains("enddate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(718,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="selectenddate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate%>">
				    <input class=wuiDateSel  type="hidden" name="enddate1" value="<%=enddate1%>">
				</span>
			
			</wea:item>
<%} %>
<!-- 出厂日期 -->
<%if(fieldnames.contains("manudate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1365,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="selectmanudate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="manudate" value="<%=manudate%>">
				    <input class=wuiDateSel  type="hidden" name="manudate1" value="<%=manudate1%>">
				</span>
			</wea:item>
<%} %>
<!-- 入库日期 -->
<%if(fieldnames.contains("stockindate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(753,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="selectstockindate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="stockindate" value="<%=stockindate%>">
				    <input class=wuiDateSel  type="hidden" name="stockindate1" value="<%=stockindate1%>">
				</span>
			</wea:item>
<%} %>
<!-- 计量单位 -->
<%if(fieldnames.contains("unitid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="unitid" browserValue='<%=unitid%>' browserSpanValue='<%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/lgc/maintenance/LgcAssetUnitBrowser.jsp" completeUrl="/data.jsp?type=-99993"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 等级 -->
<%if(fieldnames.contains("capitallevel")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(603,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=30 size=30 value="<%=capitallevel%>" name="capitallevel">
			</wea:item>
<%} %>
<!-- 制造厂商 -->
<%if(fieldnames.contains("manufacturer")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1364,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=100 size=30 value="<%=manufacturer%>" name="manufacturer">
			</wea:item>
<%} %>
<!-- 属性 -->
<%if(fieldnames.contains("attribute")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></wea:item>
			<wea:item>
				<select class=InputStyle id=attribute name=attribute>
				  <option></option>
				  <option value=0 <% if(attribute.equals("0")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1366,user.getLanguage())%></option>
				  <option value=1 <% if(attribute.equals("1")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1367,user.getLanguage())%></option>
				  <option value=2 <% if(attribute.equals("2")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1368,user.getLanguage())%></option>
				  <option value=3 <% if(attribute.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1369,user.getLanguage())%></option>
				  <option value=4 <% if(attribute.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%></option>
				  <option value=5 <% if(attribute.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1370,user.getLanguage())%></option>
				  <option value=6 <% if(attribute.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(811,user.getLanguage())%></option>
				</select>
			</wea:item>
<%} %>
<!-- 存放地点 -->
<%if(fieldnames.contains("location")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1387,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=100 size=30 name=location value="<%=location%>">
			</wea:item>
<%} %>
<!-- 版本 -->
<%if(fieldnames.contains("version")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(567,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 name=version value="<%=version%>">
			</wea:item>
<%} %>
<!-- 领用日期 -->
<%if(fieldnames.contains("deprestartdate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1412,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="selectdeprestartdate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="deprestartdate" value="<%=deprestartdate%>">
				    <input class=wuiDateSel  type="hidden" name="deprestartdate1" value="<%=deprestartdate1%>">
				</span>
			
			</wea:item>
<%} %>
<!-- 报警数量 -->
<%if(fieldnames.contains("alertnum")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(15294,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=100 size=30 name="alertnum" value="<%=alertnum%>">
			</wea:item>
<%} %>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("34081",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':'none'}">
<!-- 购置日期 -->
<%if(fieldnames.contains("selectdate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(16914,user.getLanguage())%></wea:item>
			<wea:item>
				<span class="wuiDateSpan" selectId="bSelectDate_sel" selectValue="">
				    <input class=wuiDateSel type="hidden" name="SelectDate" value="<%=SelectDate%>">
				    <input class=wuiDateSel  type="hidden" name="SelectDate1" value="<%=SelectDate1%>">
				</span>
			
			</wea:item>
<%} %>
<!-- 价格/参考价格 -->
<%if(fieldnames.contains("startprice")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(726,user.getLanguage())%></wea:item>
			<wea:item>
				<div style="white-space: nowrap;" >
				<input class=InputStyle style="width:40%!important;" maxlength=16 size=10 value="<%=startprice%>" name="startprice" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice")'>
					   -<input class=InputStyle style="width:40%!important;" maxlength=16 size=10 value="<%=startprice1%>" name="startprice1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("startprice1")'>
				</div>
			</wea:item>
<%} %>
<!-- 发票号码 -->
<%if(fieldnames.contains("invoice")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(900,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 name="Invoice" value="<%=Invoice%>">
			</wea:item>
<%} %>
<!-- 合同号 -->
<%if(fieldnames.contains("contractno")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(21282,user.getLanguage())%></wea:item>
			<wea:item>
				<input class=InputStyle maxlength=60 size=30 name="contractno" value="<%=contractno%>">
			</wea:item>
<%} %>
<!-- 折旧年限 -->
<%if(fieldnames.contains("depreyear")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(19598,user.getLanguage())%></wea:item>
			<wea:item>
				<div style="white-space: nowrap;" >
					<input class=InputStyle style="width:40%!important;" maxlength=16 size=10 value="<%=depreyear%>" name="depreyear" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear")'>
						   -<input class=InputStyle style="width:40%!important;" maxlength=16 size=10 value="<%=depreyear1%>" name="depreyear1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("depreyear1")'>
				</div>
			</wea:item>
<%} %>
<!-- 残值率 -->
<%if(fieldnames.contains("deprerate")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(1390,user.getLanguage())%></wea:item>
			<wea:item>
				<div style="white-space: nowrap;" >
					<input class=InputStyle style="width:40%!important;" maxlength=16 size=10 value="<%=deprerate%>" name="deprerate" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate")'>
					   -<input class=InputStyle style="width:40%!important;" maxlength=16 size=10 value="<%=deprerate1%>" name="deprerate1" onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("deprerate1")'>
				</div>
			</wea:item>
<%} %>
<!-- 币种 -->
<%if(fieldnames.contains("currencyid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="currencyid" browserValue='<%=currencyid%>' browserSpanValue='<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp" completeUrl="/data.jsp?type=12"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
<!-- 供应商 -->
<%if(fieldnames.contains("customerid")){%>
			<wea:item><%=SystemEnv.getHtmlLabelName(138,user.getLanguage())%></wea:item>
			<wea:item>
				<brow:browser  name="customerid" browserValue='<%=customerid%>' browserSpanValue='<%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage())%>' browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type=2" completeUrl="/data.jsp?type=7"  isMustInput="1" viewType="0" browserOnClick=""  hasInput="true"  isSingle="true" hasBrowser = "true" />
			</wea:item>
<%} %>
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("16169",user.getLanguage())%>' attributes="{'samePair':'moreKeyWord','groupOperDisplay':'none'}">

<%
//cusfield
ArrayList<JSONObject> cusfieldlst=new ArrayList<JSONObject>();
String sql_condition="select t1.*,t2.* from CptSearchDefinition t1,cptDefineField t2 where lower(t1.fieldname)=lower(t2.fieldname) and t1.isconditions='1' and t2.issystem is null and t2.isopen='1' order by t1.displayorder";
rs_condition .executeSql(sql_condition);
String cusfieldnames=",";
while(rs_condition.next()){
	cusfieldnames+=rs_condition.getString("fieldname")+",";
}

TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v= new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldhtmltype= v.getInt("fieldhtmltype");
		if(fieldhtmltype==2||fieldhtmltype==6||fieldhtmltype==7){
			continue;
		}
		String fieldname= v.getString("fieldname");
		if(cusfieldnames.contains(","+fieldname+",")){
			v.put("ismand", "0");//查询不用必填
			cusfieldlst.add(v);
		}
	}
}
int cusfieldsize= cusfieldlst.size();
for(int i=0;i<cusfieldsize;i++){
	JSONObject v=(JSONObject)cusfieldlst.get(i);
	%>
	<wea:item><%=SystemEnv.getHtmlLabelName(v.getInt("fieldlabel"),user.getLanguage())%></wea:item>
	<wea:item>
		<%=((HtmlElement)Class.forName(v.getString("eleclazzname")).newInstance()).getHtmlElementString("", v, user) %>
	</wea:item>
	<%
}

%>



		
		
		</wea:group>
		
		
	</wea:layout>
<div style="height:50px!important;"></div>
	
<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="display:none;">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_submit" type="submit" name="submit1" value="<%=SystemEnv.getHtmlLabelNames("527",user.getLanguage())%>"/>
	    	<input class="zd_btn_cancle" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelNames("2022",user.getLanguage())%>"/>
	    	<input class="zd_btn_submit" type="button" name="savetmp" onclick="onSaveas();" value="<%=SystemEnv.getHtmlLabelNames("18418",user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
</form>
<script language="javascript">
function onSearch(){
	$("#form2").submit();
}

function onBtnSearchClick(){
	$("#form2").submit();
}

function onReset(){
	$("input[type=reset]").trigger('click');
}
function onDelete(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83695",user.getLanguage())%>',function(){
		jQuery.post(
			"/cpt/search/SearchMouldOperation.jsp",
			{"operation":"delete","mouldid":'<%=mouldid %>'},
			function(data){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83472",user.getLanguage())%>",function(){
					window.parent.location.href="/cpt/search/CptSearch.jsp?isdata=<%=isdata %>";
				});
			}
		);
		
	});
}
function onSave(){
	document.form2.operation.value="edit";
	document.form2.target="";
	var params=$("#form2").serialize();
	jQuery.ajax({
		url : "SearchMouldOperation.jsp",
		type : "post",
		async : true,
		data : params,
		dataType : "text",
		contentType: "application/x-www-form-urlencoded;charset=utf-8",
		success: function do4Success(data){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
		}
	});
}

function onSaveas(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 330;
	dialog.Height = 88;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("19468",user.getLanguage())%>";
	dialog.URL ="/cpt/search/CptSaveAsMould.jsp?isdialog=0";
	dialog.OKEvent = function(){
		document.form2.mouldname.value=dialog.innerFrame.contentWindow.document.getElementById('assortmentname').value;
		if(document.form2.mouldname.value==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			return;
		}else{
			document.form2.operation.value="add";
			document.form2.target="";
			var params=$("#form2").serialize();
			jQuery.ajax({
				url : "SearchMouldOperation.jsp",
				type : "post",
				async : true,
				data : params,
				dataType : "text",
				contentType: "application/x-www-form-urlencoded;charset=utf-8",
				success: function do4Success(data){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
					dialog.close();
				}
			});	
		}
		
	};
	dialog.show();
}

$(function(){
	$("#mouldid").bind('change',function(){
		document.form2.action="CptSearchCondition.jsp";
		$("input[name=needshowadv]").val('1');
		$("input[name=submit1]").trigger('click');
	});
	
});



$(function(){
	if('1'=='<%=isdata %>'){
		cptgroupname='<%=SystemEnv.getHtmlLabelName(33182,user.getLanguage()) %>';
	}else{
		cptgroupname='<%=SystemEnv.getHtmlLabelName(16425,user.getLanguage()) %>';
	}
	try{
		parent.setTabObjName(cptgroupname);
	}catch(e){}
});


$(function(){
	//setTimeout("hideLeftTree()",10);
});

function hideLeftTree(){
	$('#oTd1', parent.parent.document).slideLeftHide(200);
}
</script>

<script type="text/javascript">
	jQuery.fn.slideLeftHide = function( speed, callback ) {
		this.animate({
			width : "hide",
			paddingLeft : "hide",
			paddingRight : "hide",
			marginLeft : "hide",
			marginRight : "hide"
		}, speed, callback );
	};
	jQuery.fn.slideLeftShow = function( speed, callback ) {
		this.animate({
			width : "show",
			paddingLeft : "show",
			paddingRight : "show",
			marginLeft : "show",
			marginRight : "show"
		}, speed, callback );
	};
</script>
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
</body>
</html>
