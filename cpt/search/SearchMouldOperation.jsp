<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
User user= HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}

String operation = Util.null2String(request.getParameter("operation"));
char separator = Util.getSeparator() ;
String mouldid = Util.fromScreen(request.getParameter("mouldid"),user.getLanguage());
String mouldname = Util.fromScreen(request.getParameter("mouldname"),user.getLanguage()) ;				/*编号*/
String userid = ""+user.getUID();

String mark = Util.fromScreen(request.getParameter("mark"),user.getLanguage()) ;				/*编号*/
String name = Util.fromScreen(request.getParameter("name"),user.getLanguage());			/*名称*/
String resultname = Util.fromScreen(request.getParameter("resultname"),user.getLanguage());			/*名称*/
if(resultname!=null&&!"".equals(resultname)){
	name = resultname;
}
String startdate = Util.fromScreen(request.getParameter("startdate"),user.getLanguage());			/*生效日*/
String startdate1 = Util.fromScreen(request.getParameter("startdate1"),user.getLanguage());			/*生效日*/
String enddate= Util.fromScreen(request.getParameter("enddate"),user.getLanguage());				/*生效至*/
String enddate1= Util.fromScreen(request.getParameter("enddate1"),user.getLanguage());				/*生效至*/
String seclevel= Util.fromScreen(request.getParameter("seclevel"),user.getLanguage());				/*安全级别*/
String seclevel1= Util.fromScreen(request.getParameter("seclevel1"),user.getLanguage());				/*安全级别*/
String departmentid = Util.fromScreen(request.getParameter("departmentid"),user.getLanguage());/*部门*/
String costcenterid = Util.fromScreen(request.getParameter("costcenterid"),user.getLanguage());			/*成本中心*/
String resourceid = Util.fromScreen(request.getParameter("resourceid"),user.getLanguage());		/*人力资源*/
String currencyid = Util.fromScreen(request.getParameter("currencyid"),user.getLanguage());	/*币种*/
String capitalcost = Util.fromScreen(request.getParameter("capitalcost"),user.getLanguage());	/*成本*/
String capitalcost1 = Util.fromScreen(request.getParameter("capitalcost1"),user.getLanguage());	/*成本*/
String startprice = Util.fromScreen(request.getParameter("startprice"),user.getLanguage());	/*开始价格*/
String startprice1 = Util.fromScreen(request.getParameter("startprice1"),user.getLanguage());	/*开始价格*/
String depreendprice = Util.fromScreen(request.getParameter("depreendprice"),user.getLanguage()); /*折旧底价(新)*/
String depreendprice1 = Util.fromScreen(request.getParameter("depreendprice1"),user.getLanguage()); /*折旧底价(新)*/
String capitalspec = Util.fromScreen(request.getParameter("capitalspec"),user.getLanguage());			/*规格型号(新)*/
String capitallevel = Util.fromScreen(request.getParameter("capitallevel"),user.getLanguage());	/*资产等级(新)*/
String manufacturer = Util.fromScreen(request.getParameter("manufacturer"),user.getLanguage());			/*制造厂商(新)*/
String manudate	= Util.fromScreen(request.getParameter("manudate"),user.getLanguage());			/*出厂日期(新)*/
String manudate1	= Util.fromScreen(request.getParameter("manudate1"),user.getLanguage());			/*出厂日期(新)*/
String capitaltypeid = Util.fromScreen(request.getParameter("capitaltypeid"),user.getLanguage());			/*资产类型*/
String capitalgroupid = Util.fromScreen(request.getParameter("capitalgroupid1"),user.getLanguage());			/*资产组*/
String unitid = Util.fromScreen(request.getParameter("unitid"),user.getLanguage());				/*计量单位*/
String capitalnum = Util.fromScreen(request.getParameter("capitalnum"),user.getLanguage());			/*数量*/
String capitalnum1 = Util.fromScreen(request.getParameter("capitalnum1"),user.getLanguage());			/*数量*/
String currentnum = Util.fromScreen(request.getParameter("currentnum"),user.getLanguage());			/*当前数量*/
String currentnum1 = Util.fromScreen(request.getParameter("currentnum1"),user.getLanguage());			/*当前数量*/
String replacecapitalid =Util.fromScreen(request.getParameter("replacecapitalid"),user.getLanguage());				/*替代*/
String version =Util.fromScreen(request.getParameter("version"),user.getLanguage()) ;			/*版本*/
String itemid =Util.fromScreen(request.getParameter("itemid"),user.getLanguage());			/*物品*/
String depremethod1 =Util.fromScreen(request.getParameter("depremethod1"),user.getLanguage());			/*折旧法一*/
String depremethod2 =Util.fromScreen(request.getParameter("depremethod2"),user.getLanguage());			/*折旧法二*/
String deprestartdate =Util.fromScreen(request.getParameter("deprestartdate"),user.getLanguage());		/*折旧开始日期*/
String deprestartdate1 =Util.fromScreen(request.getParameter("deprestartdate1"),user.getLanguage());		/*折旧开始日期*/
String depreenddate = Util.fromScreen(request.getParameter("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String depreenddate1 = Util.fromScreen(request.getParameter("depreenddate1"),user.getLanguage()) ;			/*折旧结束日期*/
String customerid=Util.fromScreen(request.getParameter("customerid"),user.getLanguage());			/*客户id*/
String attribute= Util.fromScreen(request.getParameter("attribute"),user.getLanguage());
String stateid = Util.fromScreen(request.getParameter("stateid"),user.getLanguage());	/*资产状态*/
String location = Util.fromScreen(request.getParameter("location"),user.getLanguage()) ;			/*存放地点*/
String isdata = Util.fromScreen(request.getParameter("isdata"),user.getLanguage()) ;			/*资产或资料*/
String counttype = Util.fromScreen(request.getParameter("counttype"),user.getLanguage()) ;			/*固资或低耗*/
String isinner = Util.fromScreen(request.getParameter("isinner"),user.getLanguage()) ;			/*帐内或帐外*/
String stockindate = Util.fromScreen(request.getParameter("stockindate"),user.getLanguage()) ;			/*入库日期从*/
String stockindate1 = Util.fromScreen(request.getParameter("stockindate1"),user.getLanguage()) ;			/*入库日期到*/

//新增加字段
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

String blongsubcompany = Util.fromScreen(request.getParameter("blongsubcompany"),user.getLanguage());/*所属分部*/

if(operation.equals("add")){
     
  	String para = "";
	para  =mouldname;
	para +=separator+userid;
	para +=separator+mark;
	para +=separator+name;
	para +=separator+startdate;
	para +=separator+startdate1;
	para +=separator+enddate;
	para +=separator+enddate1;
	para +=separator+seclevel;
	para +=separator+seclevel1;
	para +=separator+departmentid;
	para +=separator+costcenterid;
	para +=separator+resourceid;
	para +=separator+currencyid;
	para +=separator+capitalcost;
	para +=separator+capitalcost1;
	para +=separator+startprice;
	para +=separator+startprice1;
	para +=separator+depreendprice;
	para +=separator+depreendprice1;
	para +=separator+capitalspec;
	para +=separator+capitallevel;
	para +=separator+manufacturer;
	para +=separator+manudate;
	para +=separator+manudate1;
	para +=separator+capitaltypeid;
	para +=separator+capitalgroupid;
	para +=separator+unitid;
	para +=separator+capitalnum;
	para +=separator+capitalnum1;
	para +=separator+currentnum;
	para +=separator+currentnum1;
	para +=separator+replacecapitalid;
	para +=separator+version;
	para +=separator+itemid;
	para +=separator+depremethod1;
	para +=separator+depremethod2;
	para +=separator+deprestartdate;
	para +=separator+deprestartdate1;
	para +=separator+depreenddate;
	para +=separator+depreenddate1;
	para +=separator+customerid;
	para +=separator+attribute;
	para +=separator+stateid;
	para +=separator+location;
	para +=separator+isdata;
	para +=separator+counttype;
	para +=separator+isinner;
    para +=separator+stockindate;
    para +=separator+stockindate1;
    para +=separator+alertnum;

	RecordSet.executeProc("CptSearchMould_Insert",para);
	RecordSet.next() ;
	String tempmouldid = RecordSet.getString(1);

	String sql = "update CptSearchMould set blongsubcompany = '"+ blongsubcompany+"' where id = " + tempmouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set fnamark = '"+ fnamark+"',barcode = '"+ barcode+"',blongdepartment = '"+ blongdepartment+"',sptcount = '"+ sptcount+"',relatewfid = '"+ relatewfid +"',SelectDate = '"+SelectDate +"',SelectDate1 = '"+SelectDate1 +"',contractno = '"+contractno +"',Invoice = '"+Invoice+"',depreyear = '"+depreyear +"',deprerate = '"+ deprerate +"',issupervision = '"+issupervision +"',amountpay = '"+ amountpay +"',amountpay1 = '"+ amountpay1 +"',depreyear1 = '"+ depreyear1 +"',deprerate1 = '"+ deprerate1 +"',purchasestate = '"+ purchasestate +"' where id = " + tempmouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set datafield1 = '"+ datafield1 +"',datafield11 = '"+ datafield11 +"',datafield2 = '"+ datafield2 +"',datafield22 = '"+datafield22 +"',datafield3 = '"+ datafield3 +"',datafield33 = '"+datafield33 +"',datafield4 = '"+ datafield4 +"',datafield44 = '"+ datafield44 +"',datafield5 = '"+ datafield5 +"',datafield55 = '"+ datafield55 + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set numberfield1 = '"+ numberfield1 +"',numberfield11 = '"+ numberfield11 +"',numberfield2 = '"+ numberfield2 +"',numberfield22 = '"+ numberfield22 +"',numberfield3 = '"+ numberfield3+"',numberfield33 = '"+numberfield33 +"', numberfield4 = '"+ numberfield4 +"',numberfield44 = '"+ numberfield44 +"',numberfield5 = '"+ numberfield5 +"',numberfield55 = '"+ numberfield55 +"' where id = " + tempmouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set textfield1 = '"+ textfield1 +"',textfield2 = '"+ textfield2 +"',textfield3 = '"+ textfield3 +"',textfield4 = '"+ textfield4 +"',textfield5 = '"+ textfield5 + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set tinyintfield1 = '"+ tinyintfield1 +"',tinyintfield2 = '"+ tinyintfield2 +"',tinyintfield3 = '"+tinyintfield3 +"',tinyintfield4 = '"+tinyintfield4 +"',tinyintfield5 = '"+ tinyintfield5 + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set docff01name = '"+ docff01name +"',docff02name = '"+ docff02name +"',docff03name = '"+ docff03name +"',docff04name = '"+ docff04name +"',docff05name = '"+ docff05name + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set depff01name = '"+ depff01name +"',depff02name = '"+ depff02name +"',depff03name = '"+ depff03name +"',depff04name = '"+ depff04name +"',depff05name = '"+ depff05name + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set crmff01name = '"+ crmff01name +"',crmff02name = '"+ crmff02name +"',crmff03name = '"+ crmff03name +"',crmff04name = '"+ crmff04name +"',crmff05name = '"+ crmff05name + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set reqff01name = '"+ reqff01name +"',alertnum = '"+ alertnum + "',reqff02name = '"+ reqff02name +"',reqff03name = '"+ reqff03name +"',reqff04name = '"+ reqff04name +"',reqff05name = '"+ reqff05name + "' where id = " + tempmouldid;
	RecordSet.executeSql(sql);	

	if(stateid ==null || "".equals(stateid)){
		RecordSet.executeSql("update CptSearchMould set stateid = null where  id ="+tempmouldid);
	}else{
		RecordSet.executeSql("update CptSearchMould set stateid = '"+stateid+"' where  id ="+tempmouldid);
	}

	sql = "select * from CptSearchDefinition where mouldid = -1";
	RecordSet.executeSql(sql);
	while(RecordSet.next()){		
		sql = "insert into CptSearchDefinition (fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder,mouldid) select fieldname,isconditionstitle,istitle,isconditions,isseniorconditions,displayorder,'"+tempmouldid+"' from CptSearchDefinition where id = " + RecordSet.getString("id");	
		rs.executeSql(sql);
	}


	//response.sendRedirect("CptSearch.jsp?advanced=1&mouldid="+tempmouldid);
 }
else if(operation.equals("edit")){
  	String para = "";
	para  =mouldid;
	para +=separator+userid;
	para +=separator+mark;
	para +=separator+name;
	para +=separator+startdate;
	para +=separator+startdate1;
	para +=separator+enddate;
	para +=separator+enddate1;
	para +=separator+seclevel;
	para +=separator+seclevel1;
	para +=separator+departmentid;
	para +=separator+costcenterid;
	para +=separator+resourceid;
	para +=separator+currencyid;
	para +=separator+capitalcost;
	para +=separator+capitalcost1;
	para +=separator+startprice;
	para +=separator+startprice1;
	para +=separator+depreendprice;
	para +=separator+depreendprice1;
	para +=separator+capitalspec;
	para +=separator+capitallevel;
	para +=separator+manufacturer;
	para +=separator+manudate;
	para +=separator+manudate1;
	para +=separator+capitaltypeid;
	para +=separator+capitalgroupid;
	para +=separator+unitid;
	para +=separator+capitalnum;
	para +=separator+capitalnum1;
	para +=separator+currentnum;
	para +=separator+currentnum1;
	para +=separator+replacecapitalid;
	para +=separator+version;
	para +=separator+itemid;
	para +=separator+depremethod1;
	para +=separator+depremethod2;
	para +=separator+deprestartdate;
	para +=separator+deprestartdate1;
	para +=separator+depreenddate;
	para +=separator+depreenddate1;
	para +=separator+customerid;
	para +=separator+attribute;
	para +=separator+stateid;
	para +=separator+location;
	para +=separator+isdata;
	para +=separator+counttype;
	para +=separator+isinner;
    para +=separator+stockindate;
    para +=separator+stockindate1;
    para +=separator+alertnum;
    
	out.print(para);
	RecordSet.executeProc("CptSearchMould_Update",para);
	String sql = "update CptSearchMould set blongsubcompany = '"+ blongsubcompany+"' where id = " + mouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set fnamark = '"+ fnamark+"',barcode = '"+ barcode+"',blongdepartment = '"+ blongdepartment+"',sptcount = '"+ sptcount+"',relatewfid = '"+ relatewfid +"',SelectDate = '"+SelectDate +"',SelectDate1 = '"+SelectDate1 +"',contractno = '"+contractno +"',Invoice = '"+Invoice+"',depreyear = '"+depreyear +"',deprerate = '"+ deprerate +"',issupervision = '"+issupervision +"',amountpay = '"+ amountpay +"',amountpay1 = '"+ amountpay1 +"',depreyear1 = '"+ depreyear1 +"',deprerate1 = '"+ deprerate1 +"',purchasestate = '"+ purchasestate +"' where id = " + mouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set datafield1 = '"+ datafield1 +"',datafield11 = '"+ datafield11 +"',datafield2 = '"+ datafield2 +"',datafield22 = '"+datafield22 +"',datafield3 = '"+ datafield3 +"',datafield33 = '"+datafield33 +"',datafield4 = '"+ datafield4 +"',datafield44 = '"+ datafield44 +"',datafield5 = '"+ datafield5 +"',datafield55 = '"+ datafield55 + "' where id = " + mouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set numberfield1 = '"+ numberfield1 +"',numberfield11 = '"+ numberfield11 +"',numberfield2 = '"+ numberfield2 +"',numberfield22 = '"+ numberfield22 +"',numberfield3 = '"+ numberfield3+"',numberfield33 = '"+numberfield33 +"', numberfield4 = '"+ numberfield4 +"',numberfield44 = '"+ numberfield44 +"',numberfield5 = '"+ numberfield5 +"',numberfield55 = '"+ numberfield55 +"' where id = " + mouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set textfield1 = '"+ textfield1 +"',textfield2 = '"+ textfield2 +"',textfield3 = '"+ textfield3 +"',textfield4 = '"+ textfield4 +"',textfield5 = '"+ textfield5 + "' where id = " + mouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set tinyintfield1 = '"+ tinyintfield1 +"',tinyintfield2 = '"+ tinyintfield2 +"',tinyintfield3 = '"+tinyintfield3 +"',tinyintfield4 = '"+tinyintfield4 +"',tinyintfield5 = '"+ tinyintfield5 + "' where id = " + mouldid;
	RecordSet.executeSql(sql);
	sql = "update CptSearchMould set docff01name = '"+ docff01name +"',docff02name = '"+ docff02name +"',docff03name = '"+ docff03name +"',docff04name = '"+ docff04name +"',docff05name = '"+ docff05name + "' where id = " + mouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set depff01name = '"+ depff01name +"',depff02name = '"+ depff02name +"',depff03name = '"+ depff03name +"',depff04name = '"+ depff04name +"',depff05name = '"+ depff05name + "' where id = " + mouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set crmff01name = '"+ crmff01name +"',crmff02name = '"+ crmff02name +"',crmff03name = '"+ crmff03name +"',crmff04name = '"+ crmff04name +"',crmff05name = '"+ crmff05name + "' where id = " + mouldid;
	RecordSet.executeSql(sql);	
	sql = "update CptSearchMould set reqff01name = '"+ reqff01name +"',alertnum = '"+ alertnum + "',reqff02name = '"+ reqff02name +"',reqff03name = '"+ reqff03name +"',reqff04name = '"+ reqff04name +"',reqff05name = '"+ reqff05name + "' where id = " + mouldid;
	RecordSet.executeSql(sql);	
	if(stateid ==null || "".equals(stateid)){
		RecordSet.executeSql("update CptSearchMould set stateid = null where id = "+mouldid);
	}else{
		RecordSet.executeSql("update CptSearchMould set stateid = '"+stateid+"' where  id ="+mouldid);
	}
	
  	//response.sendRedirect("CptSearch.jsp?advanced=1&mouldid="+mouldid);
 }
 else if(operation.equals("delete")){
	String para = ""+mouldid;
	RecordSet.executeProc("CptSearchMould_Delete",para);
	RecordSet.executeSql("delete from CptSearchDefinition where mouldid = " + mouldid);		  
 	//response.sendRedirect("CptSearch.jsp");
 }
%>
