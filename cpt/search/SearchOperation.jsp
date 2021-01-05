<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.cpt.util.CptFieldComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="weaver.file.FileUpload"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.cpt.search.CptSearchComInfo" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%
String userid = ""+user.getUID();
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String Tempdeptid=""+user.getUserDepartment();
String	subcompanyid = Util.fromScreen(request.getParameter("subcompanyid"),user.getLanguage());/*分部*/
String	departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());/*部门*/
String	resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());

CptSearchComInfo.resetSearchInfo();

String from = Util.fromScreen(request.getParameter("from"),user.getLanguage()) ;				/*查询走向*/
String blongsubcompany = Util.fromScreen(request.getParameter("blongsubcompany"),user.getLanguage());//所属分部
String subcompanyid1 = Util.fromScreen(request.getParameter("subcompanyid1"),user.getLanguage()) ;	
String  mark = Util.fromScreen(request.getParameter("mark"),user.getLanguage()) ;				/*编号*/
String	name = Util.fromScreen2(request.getParameter("name"),user.getLanguage());			/*名称*/
String	resultname = Util.fromScreen2(request.getParameter("resultname"),user.getLanguage());			/*查询结果页高级查询名称*/
if(!"".equals(resultname)){
	name=resultname;
}
String	nameQuery = Util.fromScreen2(request.getParameter("nameQuery"),user.getLanguage());			/*名称*/
String	flowTitle = Util.fromScreen2(request.getParameter("flowTitle"),user.getLanguage());			/*名称*/
String	startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());			/*生效日*/
String	startdate1 = Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());			/*生效日*/
String	enddate= Util.fromScreen(request.getParameter("enddate"),user.getLanguage());				/*生效至*/
String	enddate1= Util.fromScreen(request.getParameter("enddate1"),user.getLanguage());				/*生效至*/
String	seclevel= Util.fromScreen(request.getParameter("seclevel"),user.getLanguage());				/*安全级别*/
String	seclevel1= Util.fromScreen(request.getParameter("seclevel1"),user.getLanguage());				/*安全级别*/
//String	departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());/*部门*/
//out.println(departmentid);
if (departmentid.equals("0")){ departmentid="";}
if (subcompanyid.equals("0")){ subcompanyid="";}
String	costcenterid = Util.fromScreen(request.getParameter("costcenterid"),user.getLanguage());			/*成本中心*/
if (costcenterid.equals("0")){ costcenterid="";}
//String	resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());		/*人力资源*/
if (resourceid.equals("0")){ resourceid="";}
if (resourceid.equals("-1")){ resourceid="0";}
String	currencyid = Util.fromScreen(request.getParameter("currencyid"),user.getLanguage());	/*币种*/
if (currencyid.equals("0")){ currencyid="";}
String	capitalcost = Util.fromScreen(request.getParameter("capitalcost"),user.getLanguage());	/*成本*/
String	capitalcost1 = Util.fromScreen(request.getParameter("capitalcost1"),user.getLanguage());	/*成本*/
String	startprice = Util.fromScreen(request.getParameter("startprice"),user.getLanguage());	/*开始价格*/
String	startprice1 = Util.fromScreen(request.getParameter("startprice1"),user.getLanguage());	/*开始价格*/
String	depreendprice = Util.fromScreen(request.getParameter("depreendprice"),user.getLanguage()); /*折旧底价(新)*/
String	depreendprice1 = Util.fromScreen(request.getParameter("depreendprice1"),user.getLanguage()); /*折旧底价(新)*/
String	capitalspec = Util.fromScreen(request.getParameter("capitalspec"),user.getLanguage());			/*规格型号(新)*/
String	capitallevel = Util.fromScreen(request.getParameter("capitallevel"),user.getLanguage());	/*资产等级(新)*/
String	manufacturer = Util.fromScreen(request.getParameter("manufacturer"),user.getLanguage());			/*制造厂商(新)*/
String	manudate	= Util.fromScreen(request.getParameter("manudate"),user.getLanguage());			/*出厂日期(新)*/
String	manudate1	= Util.fromScreen(request.getParameter("manudate1"),user.getLanguage());			/*出厂日期(新)*/
String	capitaltypeid = Util.fromScreen(request.getParameter("capitaltypeid"),user.getLanguage());			/*资产类型*/
if (capitaltypeid.equals("0")){ capitaltypeid="";}
String	capitalgroupid = Util.fromScreen(request.getParameter("capitalgroupid"),user.getLanguage());			/*资产组*/
String	capitalgroupid1 = Util.fromScreen(request.getParameter("capitalgroupid1"),user.getLanguage());			/*资产组*/
String	unitid = Util.fromScreen(request.getParameter("unitid"),user.getLanguage());				/*计量单位*/
if (unitid.equals("0")){ unitid="";}
String	capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());			/*数量*/
String	capitalnum1 = Util.fromScreen(request.getParameter("capitalnum1"),user.getLanguage());			/*数量*/
String	currentnum = Util.fromScreen(request.getParameter("currentnum"),user.getLanguage());			/*当前数量*/
String	currentnum1 = Util.fromScreen(request.getParameter("currentnum1"),user.getLanguage());			/*当前数量*/
String	replacecapitalid =Util.fromScreen(request.getParameter("replacecapitalid"),user.getLanguage());				/*替代*/
if (replacecapitalid.equals("0")){ replacecapitalid="";}
String	version =Util.fromScreen(request.getParameter("version"),user.getLanguage()) ;			/*版本*/
String	itemid =Util.fromScreen(request.getParameter("itemid"),user.getLanguage());			/*物品*/
if (itemid.equals("0")){ itemid="";}
String	depremethod1 =Util.fromScreen(request.getParameter("depremethod1"),user.getLanguage());			/*折旧法一*/
if (depremethod1.equals("0")){ depremethod1="";}
String	depremethod2 =Util.fromScreen(request.getParameter("depremethod2"),user.getLanguage());			/*折旧法二*/
if (depremethod2.equals("0")){ depremethod2="";}
String	deprestartdate =Util.fromScreen(request.getParameter("deprestartdate"),user.getLanguage());		/*折旧开始日期*/
String	deprestartdate1 =Util.fromScreen(request.getParameter("deprestartdate1"),user.getLanguage());		/*折旧开始日期*/
String	depreenddate = Util.fromScreen(request.getParameter("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String	depreenddate1 = Util.fromScreen(request.getParameter("depreenddate1"),user.getLanguage()) ;			/*折旧结束日期*/
String	customerid=Util.fromScreen(request.getParameter("customerid"),user.getLanguage());			/*客户id*/
if (customerid.equals("0")){ customerid="";}
String	attribute= Util.fromScreen(request.getParameter("attribute"),user.getLanguage());
String	stateid = Util.fromScreen(request.getParameter("stateid"),user.getLanguage());	/*资产状态*/
//if (stateid.equals("0")){ stateid="";}
String	location = Util.fromScreen(request.getParameter("location"),user.getLanguage()) ;			/*存放地点*/
String	isdata = Util.fromScreen(request.getParameter("isdata"),user.getLanguage()) ;			/*存放地点*/


String	counttype = Util.fromScreen(request.getParameter("counttype"),user.getLanguage());	/*固资或低耗*/
if (counttype.equals("0")){ counttype="";}
String	isinner = Util.fromScreen(request.getParameter("isinner"),user.getLanguage());	/*帐内或帐外*/
//if (isinner.equals("0")){ isinner="";}
String stockindate	= Util.fromScreen(request.getParameter("stockindate"),user.getLanguage());			/*入库日期从*/
String stockindate1	= Util.fromScreen(request.getParameter("stockindate1"),user.getLanguage());		    /*入库日期到*/




String fnamark = Util.fromScreen(request.getParameter("fnamark"),user.getLanguage()); /*财务编号*/
String barcode = Util.fromScreen(request.getParameter("barcode"),user.getLanguage()); /*条形码*/
String blongdepartment = Util.fromScreen(request.getParameter("blongdepartment"),user.getLanguage());/*所属部门*/
String sptcount = Util.fromScreen(request.getParameter("sptcount"),user.getLanguage());/*单独核算*/
String relatewfid = Util.fromScreen(request.getParameter("relatewfid"),user.getLanguage()); /*相关工作流*/
String SelectDate = Util.fromScreen(request.getParameter("SelectDate"),user.getLanguage());/*购置日期*/
String SelectDate1 = Util.fromScreen(request.getParameter("SelectDate1"),user.getLanguage());/*购置日期1*/
String contractno = Util.fromScreen(request.getParameter("contractno"),user.getLanguage());/*合同号*/
String Invoice = Util.fromScreen(request.getParameter("Invoice"),user.getLanguage());/*发票号*/
String depreyear = Util.fromScreen(request.getParameter("depreyear"),user.getLanguage());/*折旧年限*/
String deprerate = Util.fromScreen(request.getParameter("deprerate"),user.getLanguage());/*残值率*/
String depreyear1 = Util.fromScreen(request.getParameter("depreyear1"),user.getLanguage());/*折旧年限*/
String deprerate1 = Util.fromScreen(request.getParameter("deprerate1"),user.getLanguage());/*残值率*/
String issupervision = Util.fromScreen(request.getParameter("issupervision"),user.getLanguage());/*是否海关监管*/
String amountpay = Util.fromScreen(request.getParameter("amountpay"),user.getLanguage());/*已付金额*/
String amountpay1 = Util.fromScreen(request.getParameter("amountpay1"),user.getLanguage());/*已付金额*/
String purchasestate = Util.fromScreen(request.getParameter("purchasestate"),user.getLanguage());/*采购状态*/
String alertnum = Util.fromScreen(request.getParameter("alertnum"),user.getLanguage());/*报警数量*/


String datafield1 = Util.fromScreen(request.getParameter("datafield1"),user.getLanguage());/*自定义日期类型*/
String datafield11 = Util.fromScreen(request.getParameter("datafield11"),user.getLanguage());/*自定义日期类型*/
String datafield2 = Util.fromScreen(request.getParameter("datafield2"),user.getLanguage());/*自定义日期类型*/
String datafield22 = Util.fromScreen(request.getParameter("datafield22"),user.getLanguage());/*自定义日期类型*/
String datafield3 = Util.fromScreen(request.getParameter("datafield3"),user.getLanguage());/*自定义日期类型*/
String datafield33 = Util.fromScreen(request.getParameter("datafield33"),user.getLanguage());/*自定义日期类型*/
String datafield4 = Util.fromScreen(request.getParameter("datafield4"),user.getLanguage());/*自定义日期类型*/
String datafield44 = Util.fromScreen(request.getParameter("datafield44"),user.getLanguage());/*自定义日期类型*/
String datafield5 = Util.fromScreen(request.getParameter("datafield5"),user.getLanguage());/*自定义日期类型*/
String datafield55 = Util.fromScreen(request.getParameter("datafield55"),user.getLanguage());/*自定义日期类型*/	
	
String numberfield1 = Util.fromScreen(request.getParameter("numberfield1"),user.getLanguage());/*自定义浮点数*/
String numberfield11 = Util.fromScreen(request.getParameter("numberfield11"),user.getLanguage());/*自定义浮点数*/
String numberfield2 = Util.fromScreen(request.getParameter("numberfield2"),user.getLanguage());/*自定义浮点数*/
String numberfield22 = Util.fromScreen(request.getParameter("numberfield22"),user.getLanguage());/*自定义浮点数*/
String numberfield3 = Util.fromScreen(request.getParameter("numberfield3"),user.getLanguage());/*自定义浮点数*/
String numberfield33 = Util.fromScreen(request.getParameter("numberfield33"),user.getLanguage());/*自定义浮点数*/
String numberfield4 = Util.fromScreen(request.getParameter("numberfield4"),user.getLanguage());/*自定义浮点数*/
String numberfield44 = Util.fromScreen(request.getParameter("numberfield44"),user.getLanguage());/*自定义浮点数*/
String numberfield5 = Util.fromScreen(request.getParameter("numberfield5"),user.getLanguage());/*自定义浮点数*/
String numberfield55 = Util.fromScreen(request.getParameter("numberfield55"),user.getLanguage());/*自定义浮点数*/
	
String textfield1 = Util.fromScreen(request.getParameter("textfield1"),user.getLanguage());/*自定义文本*/
String textfield2 = Util.fromScreen(request.getParameter("textfield2"),user.getLanguage());/*自定义文本*/
String textfield3 = Util.fromScreen(request.getParameter("textfield3"),user.getLanguage());/*自定义文本*/
String textfield4 = Util.fromScreen(request.getParameter("textfield4"),user.getLanguage());/*自定义文本*/
String textfield5 = Util.fromScreen(request.getParameter("textfield5"),user.getLanguage());/*自定义文本*/

String tinyintfield1 = Util.fromScreen(request.getParameter("tinyintfield1"),user.getLanguage());/*自定义check框*/
String tinyintfield2 = Util.fromScreen(request.getParameter("tinyintfield2"),user.getLanguage());/*自定义check框*/
String tinyintfield3 = Util.fromScreen(request.getParameter("tinyintfield3"),user.getLanguage());/*自定义check框*/
String tinyintfield4 = Util.fromScreen(request.getParameter("tinyintfield4"),user.getLanguage());/*自定义check框*/
String tinyintfield5 = Util.fromScreen(request.getParameter("tinyintfield5"),user.getLanguage());/*自定义check框*/
	
String docff01name = Util.fromScreen(request.getParameter("docff01name"),user.getLanguage());/*自定义多文档*/
String docff02name = Util.fromScreen(request.getParameter("docff02name"),user.getLanguage());/*自定义多文档*/
String docff03name = Util.fromScreen(request.getParameter("docff03name"),user.getLanguage());/*自定义多文档*/
String docff04name = Util.fromScreen(request.getParameter("docff04name"),user.getLanguage());/*自定义多文档*/
String docff05name = Util.fromScreen(request.getParameter("docff05name"),user.getLanguage());/*自定义多文档*/
	
String depff01name = Util.fromScreen(request.getParameter("depff01name"),user.getLanguage());/*自定义多部门*/
String depff02name = Util.fromScreen(request.getParameter("depff02name"),user.getLanguage());/*自定义多部门*/
String depff03name = Util.fromScreen(request.getParameter("depff03name"),user.getLanguage());/*自定义多部门*/
String depff04name = Util.fromScreen(request.getParameter("depff04name"),user.getLanguage());/*自定义多部门*/
String depff05name = Util.fromScreen(request.getParameter("depff05name"),user.getLanguage());/*自定义多部门*/
	
String crmff01name = Util.fromScreen(request.getParameter("crmff01name"),user.getLanguage());/*自定义多客户*/
String crmff02name = Util.fromScreen(request.getParameter("crmff02name"),user.getLanguage());/*自定义多客户*/
String crmff03name = Util.fromScreen(request.getParameter("crmff03name"),user.getLanguage());/*自定义多客户*/
String crmff04name = Util.fromScreen(request.getParameter("crmff04name"),user.getLanguage());/*自定义多客户*/
String crmff05name = Util.fromScreen(request.getParameter("crmff05name"),user.getLanguage());/*自定义多客户*/
	
String reqff01name = Util.fromScreen(request.getParameter("reqff01name"),user.getLanguage());/*自定义多请求*/
String reqff02name = Util.fromScreen(request.getParameter("reqff02name"),user.getLanguage());/*自定义多请求*/
String reqff03name = Util.fromScreen(request.getParameter("reqff03name"),user.getLanguage());/*自定义多请求*/
String reqff04name = Util.fromScreen(request.getParameter("reqff04name"),user.getLanguage());/*自定义多请求*/
String reqff05name = Util.fromScreen(request.getParameter("reqff05name"),user.getLanguage());/*自定义多请求*/



//资产组tab传过来
String fromassortmenttab_name=Util.null2String(request.getParameter("fromassortmenttab_name"));
String fromassortmenttab_isdata=Util.null2String(request.getParameter("fromassortmenttab_isdata"));
if("cptsearch".equals(from)){
	if(name!=null&&!name.equals(fromassortmenttab_name)){
		flowTitle = name;
	}else{
		name = flowTitle;
	}
	fromassortmenttab_name = "";
	fromassortmenttab_isdata = "";
}

if(!"".equals(fromassortmenttab_name) ){
	name=fromassortmenttab_name;
}
if(!"".equals(fromassortmenttab_isdata) ){
	isdata=fromassortmenttab_isdata;
}

//set CptSearchComInfo values------------------------------------

CptSearchComInfo.setBlongsubcompany(blongsubcompany);
CptSearchComInfo.setMark(mark);
CptSearchComInfo.setName(name);

/**
System.out.println("flowTitle:"+flowTitle);
System.out.println("nameQuery:"+nameQuery);
System.out.println("name:"+name);
**/
/**
if("".equals(name)&&!"".equals(flowTitle)){
	CptSearchComInfo.setName(flowTitle);
}else if("".equals(name)&&!"".equals(nameQuery)){
	CptSearchComInfo.setName(nameQuery);
}
**/
if("cptassortment".equals(from)){
	CptSearchComInfo.setName(flowTitle);
}
if("cptmycapital".equals(from)){
	CptSearchComInfo.setName(flowTitle);
}
if("search".equals(from)){
	CptSearchComInfo.setName(flowTitle);
}
CptSearchComInfo.setStartdate(startdate);
CptSearchComInfo.setStartdate1(startdate1);
CptSearchComInfo.setEnddate(enddate);
CptSearchComInfo.setEnddate1(enddate1);
CptSearchComInfo.setSeclevel(seclevel);
CptSearchComInfo.setSeclevel1(seclevel1);
CptSearchComInfo.setDepartmentid(departmentid);
CptSearchComInfo.setSubcompanyid(subcompanyid);
CptSearchComInfo.setCostcenterid(costcenterid);
CptSearchComInfo.setResourceid(resourceid);
CptSearchComInfo.setCurrencyid(currencyid);
CptSearchComInfo.setCapitalcost(capitalcost);
CptSearchComInfo.setCapitalcost1(capitalcost1);
CptSearchComInfo.setStartprice(startprice);
CptSearchComInfo.setStartprice1(startprice1);
CptSearchComInfo.setDepreendprice(depreendprice);
CptSearchComInfo.setDepreendprice1(depreendprice1);
CptSearchComInfo.setCapitalspec(capitalspec);
CptSearchComInfo.setCapitallevel(capitallevel);
CptSearchComInfo.setManufacturer(manufacturer);
CptSearchComInfo.setManudate(manudate);
CptSearchComInfo.setManudate1(manudate1);
CptSearchComInfo.setCapitaltypeid(capitaltypeid);
CptSearchComInfo.setCapitalgroupid(capitalgroupid);
CptSearchComInfo.setCapitalgroupid1(capitalgroupid1);
CptSearchComInfo.setUnitid(unitid);
CptSearchComInfo.setCapitalnum(capitalnum);
CptSearchComInfo.setCapitalnum1(capitalnum1);
CptSearchComInfo.setCurrentnum(currentnum);
CptSearchComInfo.setCurrentnum1(currentnum1);
CptSearchComInfo.setReplacecapitalid(replacecapitalid);
CptSearchComInfo.setVersion(version);
CptSearchComInfo.setItemid(itemid);
CptSearchComInfo.setDepremethod1(depremethod1);
CptSearchComInfo.setDepremethod2(depremethod2);
CptSearchComInfo.setDeprestartdate(deprestartdate);
CptSearchComInfo.setDeprestartdate1(deprestartdate1);
CptSearchComInfo.setDepreenddate(depreenddate);
CptSearchComInfo.setDepreenddate1(depreenddate1);
CptSearchComInfo.setCustomerid(customerid);
CptSearchComInfo.setAttribute(attribute);
CptSearchComInfo.setStateid(stateid);
CptSearchComInfo.setLocation(location);
CptSearchComInfo.setIsData(isdata);
CptSearchComInfo.setCountType(counttype);
CptSearchComInfo.setIsInner(isinner);
CptSearchComInfo.setStockindate(stockindate);
CptSearchComInfo.setStockindate1(stockindate1);

//==================新增加=================================================================
CptSearchComInfo.setFnamark(fnamark);
CptSearchComInfo.setBarcode(barcode);
CptSearchComInfo.setBlongdepartment(blongdepartment);
CptSearchComInfo.setSptcount(sptcount);
CptSearchComInfo.setRelatewfid(relatewfid);
CptSearchComInfo.setSelectDate(SelectDate);
CptSearchComInfo.setSelectDate1(SelectDate1);
CptSearchComInfo.setContractno(contractno);
CptSearchComInfo.setInvoice(Invoice);
CptSearchComInfo.setDepreyear(depreyear);
CptSearchComInfo.setDepreyear1(depreyear1);
CptSearchComInfo.setDeprerate(deprerate);
CptSearchComInfo.setDeprerate1(deprerate1);
CptSearchComInfo.setIssupervision(issupervision);
CptSearchComInfo.setAmountpay(amountpay);
CptSearchComInfo.setAmountpay1(amountpay1);
CptSearchComInfo.setPurchasestate(purchasestate);
CptSearchComInfo.setAlertnum(alertnum);

CptSearchComInfo.setDatefield1(datafield1);
CptSearchComInfo.setDatefield11(datafield11);
CptSearchComInfo.setDatefield2(datafield2);
CptSearchComInfo.setDatefield22(datafield22);
CptSearchComInfo.setDatefield3(datafield3);
CptSearchComInfo.setDatefield33(datafield33);
CptSearchComInfo.setDatefield4(datafield4);
CptSearchComInfo.setDatefield44(datafield44);
CptSearchComInfo.setDatefield5(datafield5);
CptSearchComInfo.setDatefield55(datafield55);
	
CptSearchComInfo.setNumberfield1(numberfield1);
CptSearchComInfo.setNumberfield11(numberfield11);
CptSearchComInfo.setNumberfield2(numberfield2);
CptSearchComInfo.setNumberfield22(numberfield22);
CptSearchComInfo.setNumberfield3(numberfield3);
CptSearchComInfo.setNumberfield33(numberfield33);
CptSearchComInfo.setNumberfield4(numberfield4);
CptSearchComInfo.setNumberfield44(numberfield44);
CptSearchComInfo.setNumberfield5(numberfield5);
CptSearchComInfo.setNumberfield55(numberfield55);

CptSearchComInfo.setTextfield1(textfield1);
CptSearchComInfo.setTextfield2(textfield2);
CptSearchComInfo.setTextfield3(textfield3);
CptSearchComInfo.setTextfield4(textfield4);
CptSearchComInfo.setTextfield5(textfield5);

CptSearchComInfo.setTinyintfield1(tinyintfield1);
CptSearchComInfo.setTinyintfield2(tinyintfield2);
CptSearchComInfo.setTinyintfield3(tinyintfield3);
CptSearchComInfo.setTinyintfield4(tinyintfield4);
CptSearchComInfo.setTinyintfield5(tinyintfield5);
	
CptSearchComInfo.setDocff01name(docff01name);
CptSearchComInfo.setDocff02name(docff02name);
CptSearchComInfo.setDocff03name(docff03name);
CptSearchComInfo.setDocff04name(docff04name);
CptSearchComInfo.setDocff05name(docff05name);

CptSearchComInfo.setDepff01name(depff01name);
CptSearchComInfo.setDepff02name(depff02name);
CptSearchComInfo.setDepff03name(depff03name);
CptSearchComInfo.setDepff04name(depff04name);
CptSearchComInfo.setDepff05name(depff05name);

CptSearchComInfo.setCrmff01name(crmff01name);
CptSearchComInfo.setCrmff02name(crmff02name);
CptSearchComInfo.setCrmff03name(crmff03name);
CptSearchComInfo.setCrmff04name(crmff04name);
CptSearchComInfo.setCrmff05name(crmff05name);

CptSearchComInfo.setReqff01name(reqff01name);
CptSearchComInfo.setReqff02name(reqff02name);
CptSearchComInfo.setReqff03name(reqff03name);
CptSearchComInfo.setReqff04name(reqff04name);
CptSearchComInfo.setReqff05name(reqff05name);
//=========================================================================


//tagtag
StringBuffer cusSql=new StringBuffer();//自定义字段条件
HashMap<String,String> cusFieldVal= new HashMap<String, String>();//自定义字段值
CptFieldComInfo CptFieldComInfo=new CptFieldComInfo();
TreeMap<String,JSONObject> openfieldMap= CptFieldComInfo.getOpenFieldMap();
if(!openfieldMap.isEmpty()){
	Iterator it=openfieldMap.entrySet().iterator();
	while(it.hasNext()){
		Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
		String k= entry.getKey();
		JSONObject v=new JSONObject(((JSONObject)entry.getValue()).toString());
		int fieldhtmltype= v.getInt("fieldhtmltype");
		String fieldid=v.getString("id");
		String fieldname=v.getString("fieldname");
		int type=v.getInt("type");
		if(fieldhtmltype==2||fieldhtmltype==6||fieldhtmltype==7){
			continue;
		}
		
		String val=Util.null2String( request.getParameter("field"+fieldid));
		if(!"".equals(val)){
			cusFieldVal.put(fieldid, val);
			if(fieldhtmltype==3){
	 			boolean isSingle="true".equalsIgnoreCase( BrowserManager.browIsSingle(""+type));
	 			if(isSingle){
	 				cusSql.append( " and "+fieldname+" ='"+val+"'  ");
	 			}else {
	 				String dbtype= RecordSet .getDBType();
	 				if("oracle".equalsIgnoreCase(dbtype)){
	 					cusSql.append(SQLUtil.filteSql(RecordSet .getDBType(),  " and ','+"+fieldname+"+',' like '%,"+val+",%'  "));
	 				}else{
	 					cusSql.append(" and ','+convert(varchar(2000),"+fieldname+")+',' like '%,"+val+",%'  ");
	 				}
	 				
				}
	 		}else if(fieldhtmltype==4){
	 			if("1".equals(val)){
	 				cusSql.append(" and "+fieldname+" ='"+val+"'  ");
	 			}
	 		}else if(fieldhtmltype==5){
	 			cusSql.append(" and exists(select 1 from cpt_SelectItem ttt2 where ttt2.fieldid="+fieldid+" and ttt2.selectvalue='"+val+"' and ttt2.selectvalue=t1."+fieldname+" ) ");
	 		}else{
	 			cusSql.append(" and "+fieldname+" like'%"+val+"%'  ");
	 		}
		}
		
	}
}
CptSearchComInfo.setCusSql(cusSql.toString());
CptSearchComInfo.setCusFieldInfo(cusFieldVal);

String type= Util.fromScreen(request.getParameter("type"),user.getLanguage()) ;
/*
if(type.equals("search")){
    response.sendRedirect("CptSearchResult.jsp?type=search");
}
*/
String paraid=Util.null2String( request.getParameter("paraid"));

if(from.equals("report")){
    response.sendRedirect("../report/CptRpCapitalResult.jsp?subcompanyid="+subcompanyid+"&paraid="+paraid);
}
else if(from.equals("checkstock")){
	response.sendRedirect("../report/CptRpCapitalCheckStockResult.jsp"+"&paraid="+paraid);
}
else if(from.equals("cptmodify")){
	response.sendRedirect("../capital/CptCapitalModify.jsp?from=1"+"&paraid="+paraid);
}
else if(from.equals("search")){
	response.sendRedirect("/cpt/capital/CptCapitalMaintenance.jsp?from=search&subcompanyid1="+subcompanyid1+""+"&paraid="+paraid);
}
else{
    response.sendRedirect("CptSearchResult.jsp?type="+type+"&isfromtab="+isfromtab+"&from="+from+"&paraid="+paraid+"&isdata="+isdata);
}


%>
