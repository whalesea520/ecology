<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.workflow.request.RequestComInfo"%>
<%@page import="weaver.crm.Maint.CustomerInfoComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.docs.docs.DocComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page" />
<jsp:useBean id="CapitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="CapitalTypeComInfo" class="weaver.cpt.maintenance.CapitalTypeComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="DepreMethodComInfo" class="weaver.cpt.maintenance.DepreMethodComInfo" scope="page"/>
<jsp:useBean id="CapitalExcelToDB" class="weaver.cpt.ExcelToDB.CapitalExcelToDB" scope="page"/>
<jsp:useBean id="CapitalTransUtil" class="weaver.cpt.util.CapitalTransUtil" scope="page"/>
<jsp:useBean id="CodeBuild" class="weaver.system.code.CodeBuild" scope="page"/>
<jsp:useBean id="CptFieldComInfo" class="weaver.cpt.util.CptFieldComInfo" scope="page"/>
<jsp:useBean id="CptFieldManager" class="weaver.cpt.util.CptFieldManager" scope="page"/>
<jsp:useBean id="CodeUtil" class="weaver.proj.util.CodeUtil" scope="page"/>
<jsp:useBean id="CommonShareManager" class="weaver.cpt.util.CommonShareManager" scope="page" />


<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	return;
}
  FileUpload fu = new FileUpload(request);
  String isdialog = Util.null2String(fu.getParameter("isdialog"));
  String operation = Util.null2String(fu.getParameter("operation"));
  char separator = Util.getSeparator() ;
  String id = Util.null2String(fu.getParameter("id")) ;
//可编辑资产和有资产编辑功能权限的用户id
int canEditCptRealUID=user.getUID(user, "CptCapitalEdit:Edit", "cpt_cptshare", id);
  if(operation.equalsIgnoreCase("delpic")) {
	
	String oldcapitalimageid= Util.null2String(fu.getParameter("oldcapitalimage"));
	RecordSet.executeProc("CptCapital_UpdatePic",id+separator+oldcapitalimageid);

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
	SysMaintenanceLog.setRelatedName("Image");
    SysMaintenanceLog.setOperateItem("51");
    SysMaintenanceLog.setOperateUserid(canEditCptRealUID);
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	SysMaintenanceLog.setOperateType("2");
	SysMaintenanceLog.setOperateDesc("CptCapital_UpdatePic,"+id+separator+oldcapitalimageid);
	SysMaintenanceLog.setSysLogInfo();

	response.sendRedirect("CptCapitalEdit.jsp?id="+id);
	return ;
  }

  if(operation.equalsIgnoreCase("addcapital") || operation.equalsIgnoreCase("editcapital")){
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
	Calendar now = Calendar.getInstance();
	String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage()) ;			/*名称*/
String smark = Util.fromScreen(fu.getParameter("mark"),user.getLanguage()).trim() ;			/*编码*/

String barcode = Util.fromScreen(fu.getParameter("barcode"),user.getLanguage()) ;			/*条形码*/
String startdate = Util.fromScreen(fu.getParameter("startdate"),user.getLanguage()) ;			/*生效日*/
String enddate= Util.fromScreen(fu.getParameter("enddate"),user.getLanguage()) ;				/*生效至*/
String seclevel= Util.fromScreen(fu.getParameter("seclevel"),user.getLanguage()) ;				/*安全级别*/
if (seclevel.equals("")) seclevel="0";
String currencyid = ""+Util.getIntValue(fu.getParameter("currencyid"),0) ;	/*币种*/
String capitalcost = ""+Util.getDoubleValue(fu.getParameter("capitalcost"),0) ;	/*成本*/
String startprice =Util.null2String( fu.getParameter("startprice")) ;	/*开始价格*/
if("".equals(startprice)){
	startprice = "0";
}
String capitaltypeid = fu.getParameter("capitaltypeid") ;			/*资产类型*/
String capitalgroupid = ""+Util.getIntValue(fu.getParameter("capitalgroupid"),0) ;			/*资产组*/
String unitid = ""+Util.getIntValue(fu.getParameter("unitid"),0) ;				/*计量单位*/
String replacecapitalid = ""+Util.getIntValue(fu.getParameter("replacecapitalid"),0) ;				/*替代*/
String version = Util.fromScreen(fu.getParameter("version"),user.getLanguage()) ;			/*版本*/
//String itemid = Util.fromScreen(fu.getParameter("itemid"),user.getLanguage()) ;			/*物品*/
//if(itemid.equals("")){
//    itemid = "0";
//}
String remark = Util.fromScreen(fu.getParameter("remark"),user.getLanguage()) ;			/*备注*/
String capitalimageid= Util.null2String(fu.uploadFiles("capitalimage"));
String oldcapitalimageid= Util.null2String(fu.getParameter("oldcapitalimage"));
	if(capitalimageid.equals("") && operation.equalsIgnoreCase("addcapital")) capitalimageid="0" ;
	if(capitalimageid.equals("") && operation.equalsIgnoreCase("editcapital")) capitalimageid=oldcapitalimageid ;
String depremethod1 = ""+Util.getIntValue(fu.getParameter("depremethod1"),0) ;			/*折旧法一*/
String depremethod2 = ""+Util.getIntValue(fu.getParameter("depremethod2"),0) ;			/*折旧法二*/
String deprestartdate = Util.fromScreen(fu.getParameter("deprestartdate"),user.getLanguage()) ;		/*折旧开始日期*/
String depreenddate = Util.fromScreen(fu.getParameter("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
String customerid= ""+Util.getIntValue(fu.getParameter("customerid"),0) ;			/*客户id*/
//9默认为空
String attribute= ""+Util.getIntValue(fu.getParameter("attribute"),9) ;
/*属性:
0:自制
1:采购
2:租赁
3:出租
4:维护
5:租用
6:其它
*/
/*新增部分*/
String depreendprice = ""+Util.getDoubleValue(fu.getParameter("depreendprice"),0) ;	/*折旧底价*/
String capitalspec = Util.fromScreen(fu.getParameter("capitalspec"),user.getLanguage()) ;	/*规格型号*/
String capitallevel = Util.fromScreen(fu.getParameter("capitallevel"),user.getLanguage()) ;	/*资产等级*/
String manufacturer = Util.fromScreen(fu.getParameter("manufacturer"),user.getLanguage()) ;	/*制造厂商*/
String manudate = Util.fromScreen(fu.getParameter("manudate"),user.getLanguage()) ;	/*出厂日期*/
String location = Util.fromScreen(fu.getParameter("location"),user.getLanguage()) ;	/*存放地点*/
String sptcount = Util.fromScreen(fu.getParameter("sptcount"),user.getLanguage()) ;	/*单独核算*/
String resourceid = ""+Util.getIntValue(fu.getParameter("resourceid"),0) ;	/*管理员或使用人*/
String relatewfid = ""+Util.getIntValue(fu.getParameter("relatewfid"),0) ;	/*相关工作流*/
String alertnum = ""+Util.getDoubleValue(fu.getParameter("alertnum"),0.0) ;	/*报警数量*/
String fnamark = Util.fromScreen(fu.getParameter("fnamark"),user.getLanguage()) ;	/*财务编号*/
String isinner = Util.null2String(fu.getParameter("isinner")) ;			                /*帐内帐外*/
String invoice = Util.null2String(fu.getParameter("invoice")) ;			                /*发票号码*/
String StockInDate = Util.null2String(fu.getParameter("stockindate")) ;                 /*入库日期*/
String depreyear =""+ Util.getDoubleValue(fu.getParameter("depreyear"),0) ;                 /*折旧年限*/
String deprerate =""+ Util.getDoubleValue(fu.getParameter("deprerate"),0) ;                 /*残值率*/
String contractno = ""+Util.null2String(fu.getParameter("contractno"));//合同号
String blongsubcompany = Util.null2String(fu.getParameter("blongsubcompany"));/*所属分部*/
String blongdepartment = Util.null2String(fu.getParameter("blongdepartment"));/*所属部门*/
String issupervision = Util.null2String(fu.getParameter("issupervision"));/*是否海关检查*/
double amountpay = Util.getDoubleValue(fu.getParameter("amountpay"),0d); /*已付金额*/
String purchasestate = Util.null2String(fu.getParameter("purchasestate"));/*采购状态*/
String departmentid = Util.null2String(fu.getParameter("departmentid"));/*使用部门*/
String mequipmentpower = Util.null2String(fu.getParameter("mequipmentpower"));/*设备功率*/

String SelectDate = Util.null2String(fu.getParameter("selectdate")) ;                 /*购置日期*/

	String createrid = ""+canEditCptRealUID;
	String createdate = currentdate ;
	String createtime = currenttime ;
	String lastmoderid = ""+canEditCptRealUID;
	String lastmoddate = currentdate ;
	String lastmodtime = currenttime ;

	String dff01=Util.null2String(fu.getParameter("dff01"));
	String dff02=Util.null2String(fu.getParameter("dff02"));
	String dff03=Util.null2String(fu.getParameter("dff03"));
	String dff04=Util.null2String(fu.getParameter("dff04"));
	String dff05=Util.null2String(fu.getParameter("dff05"));

	String nff01=Util.null2String(fu.getParameter("nff01"));
	if(nff01.equals("")) {
		if(rs.getDBType().equals("oracle")) nff01="0";
		else 	nff01="0.0";
	}
	String nff02=Util.null2String(fu.getParameter("nff02"));
	if(nff02.equals("")) {
		if(rs.getDBType().equals("oracle")) nff02="0";
		else 	nff02="0.0";
	}
	String nff03=Util.null2String(fu.getParameter("nff03"));
	if(nff03.equals("")) {
		if(rs.getDBType().equals("oracle")) nff03="0";
		else 	nff03="0.0";
	}
	String nff04=Util.null2String(fu.getParameter("nff04"));
	if(nff04.equals("")) {
		if(rs.getDBType().equals("oracle")) nff04="0";
		else 	nff04="0.0";
	}
	String nff05=Util.null2String(fu.getParameter("nff05"));
	if(nff05.equals("")) {
		if(rs.getDBType().equals("oracle")) nff05="0";
		else 	nff05="0.0";
	}

	String tff01=Util.fromScreen(fu.getParameter("tff01"),user.getLanguage());
	String tff02=Util.fromScreen(fu.getParameter("tff02"),user.getLanguage());
	String tff03=Util.fromScreen(fu.getParameter("tff03"),user.getLanguage());
	String tff04=Util.fromScreen(fu.getParameter("tff04"),user.getLanguage());
	String tff05=Util.fromScreen(fu.getParameter("tff05"),user.getLanguage());

	String bff01=Util.null2String(fu.getParameter("bff01"));
	if(bff01.equals("")) bff01="0";
	String bff02=Util.null2String(fu.getParameter("bff02"));
	if(bff02.equals("")) bff02="0";
	String bff03=Util.null2String(fu.getParameter("bff03"));
	if(bff03.equals("")) bff03="0";
	String bff04=Util.null2String(fu.getParameter("bff04"));
	if(bff04.equals("")) bff04="0";
	String bff05=Util.null2String(fu.getParameter("bff05"));
	if(bff05.equals("")) bff05="0";


	String docff01=Util.fromScreen(fu.getParameter("docff01"),user.getLanguage());
	String docff02=Util.fromScreen(fu.getParameter("docff02"),user.getLanguage());
	String docff03=Util.fromScreen(fu.getParameter("docff03"),user.getLanguage());
	String docff04=Util.fromScreen(fu.getParameter("docff04"),user.getLanguage());
	String docff05=Util.fromScreen(fu.getParameter("docff05"),user.getLanguage());

	String depff01=Util.fromScreen(fu.getParameter("depff01"),user.getLanguage());
	String depff02=Util.fromScreen(fu.getParameter("depff02"),user.getLanguage());
	String depff03=Util.fromScreen(fu.getParameter("depff03"),user.getLanguage());
	String depff04=Util.fromScreen(fu.getParameter("depff04"),user.getLanguage());
	String depff05=Util.fromScreen(fu.getParameter("depff05"),user.getLanguage());
	
	String crmff01=Util.fromScreen(fu.getParameter("crmff01"),user.getLanguage());
	String crmff02=Util.fromScreen(fu.getParameter("crmff02"),user.getLanguage());
	String crmff03=Util.fromScreen(fu.getParameter("crmff03"),user.getLanguage());
	String crmff04=Util.fromScreen(fu.getParameter("crmff04"),user.getLanguage());
	String crmff05=Util.fromScreen(fu.getParameter("crmff05"),user.getLanguage());
	
	String reqff01=Util.fromScreen(fu.getParameter("reqff01"),user.getLanguage());
	String reqff02=Util.fromScreen(fu.getParameter("reqff02"),user.getLanguage());
	String reqff03=Util.fromScreen(fu.getParameter("reqff03"),user.getLanguage());
	String reqff04=Util.fromScreen(fu.getParameter("reqff04"),user.getLanguage());
	String reqff05=Util.fromScreen(fu.getParameter("reqff05"),user.getLanguage());		

	SysMaintenanceLog.resetParameter();
	SysMaintenanceLog.setRelatedName(name);
    SysMaintenanceLog.setOperateItem("51");
	
	if("addcapital".equalsIgnoreCase(operation) ){
		SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalAdd:Add"));
	}else{
		SysMaintenanceLog.setOperateUserid(canEditCptRealUID);
	}
    
    SysMaintenanceLog.setClientAddress(request.getRemoteAddr());

	String procedurepara = "";

	if(operation.equalsIgnoreCase("addcapital")) {

	/*按资产组生成编号头*/
	String tempcapitalgroupid = capitalgroupid;
	String mark = "";
	if("2".equals( CodeUtil.getCptData1CodeUse())){
		mark=smark;
	}else{
		mark= CodeBuild.getCurrentCapitalCode1("","",capitalgroupid,capitaltypeid);
		if("lengthMaxError".equals(mark)){
			response.sendRedirect("CptCapitalAdd.jsp?isdialog="+isdialog+"&lme=false");
  			return ;
		}
	}
	//mark = CapitalExcelToDB.getCapitalNo(1,capitalgroupid);
	
		procedurepara = mark ;
		procedurepara += separator+name;
		procedurepara += separator+barcode;
//		procedurepara += separator+startdate;
//		procedurepara += separator+enddate;
		procedurepara += separator+seclevel;
		procedurepara += separator+resourceid;
        procedurepara += separator+sptcount;
		procedurepara += separator+currencyid;
		procedurepara += separator+capitalcost;
		procedurepara += separator+startprice;
		procedurepara += separator+depreendprice;
		procedurepara += separator+capitalspec;
		procedurepara += separator+capitallevel;
		procedurepara += separator+manufacturer;
//		procedurepara += separator+manudate;
		procedurepara += separator+capitaltypeid;
		procedurepara += separator+capitalgroupid;
		procedurepara += separator+unitid;
		procedurepara += separator+"0";//capitalnum初始值为零
		procedurepara += separator+replacecapitalid;
		procedurepara += separator+version;
//		procedurepara += separator+itemid;
		procedurepara += separator+remark;
		procedurepara += separator+capitalimageid;
		procedurepara += separator+depremethod1;
		procedurepara += separator+depremethod2;
//		procedurepara += separator+deprestartdate;
//		procedurepara += separator+depreenddate;
		procedurepara += separator+customerid;
		procedurepara += separator+attribute;

		procedurepara += separator+dff01;
		procedurepara += separator+dff02;
		procedurepara += separator+dff03;
		procedurepara += separator+dff04;
		procedurepara += separator+dff05;
		procedurepara += separator+nff01;
		procedurepara += separator+nff02;
		procedurepara += separator+nff03;
		procedurepara += separator+nff04;
		procedurepara += separator+nff05;
		procedurepara += separator+tff01;
		procedurepara += separator+tff02;
		procedurepara += separator+tff03;
		procedurepara += separator+tff04;
		procedurepara += separator+tff05;
		procedurepara += separator+bff01;
		procedurepara += separator+bff02;
		procedurepara += separator+bff03;
		procedurepara += separator+bff04;
		procedurepara += separator+bff05;

		procedurepara += separator+createrid;
		procedurepara += separator+createdate;
		procedurepara += separator+createtime;
		procedurepara += separator+lastmoderid;
		procedurepara += separator+lastmoddate;
		procedurepara += separator+lastmodtime;
		procedurepara += separator+"1";//isdata = "1" 管理员
        procedurepara += separator+depreyear;
        procedurepara += separator+deprerate;

        //System.out.println(procedurepara.replaceAll(""+separator, "/"));

		RecordSet.executeProc("CptCapital_Insert",procedurepara);
		RecordSet.next();
		String idadd = RecordSet.getString(1);
		//插入资产资料新增或更新记录
		
		
		CptFieldManager.updateCusfieldValue(idadd, fu, user);
		//增加新的自定义字段
		//String sql = "update cptcapital set docff01name='"+docff01+"',docff02name='"+docff02+"',docff03name='"+docff03+"',docff04name='"+docff04+"',docff05name='"+docff05+"',depff01name='"+depff01+"',depff02name='"+depff02+"',depff03name='"+depff03+"',depff04name='"+depff04+"',depff05name='"+depff05+"',crmff01name='"+crmff01+"',crmff02name='"+crmff02+"',crmff03name='"+crmff03+"',crmff04name='"+crmff04+"',crmff05name='"+crmff05+"',reqff01name='"+reqff01+"',reqff02name='"+reqff02+"',reqff03name='"+reqff03+"',reqff04name='"+reqff04+"',reqff05name='"+reqff05+"' where id = " + idadd;
		//RecordSet.executeSql(sql);
		//new weaver.general.BaseBean().writeLog(sql);
		String sql = "update cptcapital set blongsubcompany='"+blongsubcompany+"',blongdepartment='"+blongdepartment+"',issupervision='"+issupervision+"',amountpay='"+amountpay+"',purchasestate='"+purchasestate+"',equipmentpower = '"+mequipmentpower+"' where id = " + idadd;
		RecordSet.executeSql(sql);
		
		String equipmentname[] = fu.getParameterValues("equipmentname");
		String equipmentspec[] = fu.getParameterValues("equipmentspec");
		String equipmentsum[] = fu.getParameterValues("equipmentsum");		
		String equipmentpower[] = fu.getParameterValues("equipmentpower");
		String equipmentvoltage[] = fu.getParameterValues("equipmentvoltage");				
		if(equipmentname!=null){
			for(int i=0;i<equipmentname.length;i++){
				String _equipmentname = Util.null2String(equipmentname[i]);
				String _equipmentspec = Util.null2String(equipmentspec[i]);
				int _equipmentsum = Util.getIntValue(equipmentsum[i],0);
				String _equipmentpower = Util.null2String(equipmentpower[i]);
				String _equipmentvoltage = Util.null2String(equipmentvoltage[i]);
				if(!_equipmentname.equals("")){
					sql = "insert into cptcapitalequipment (cptid,equipmentname,equipmentspec,equipmentsum,equipmentpower,equipmentvoltage) values ('"+idadd+"','"+_equipmentname+"','"+_equipmentspec+"','"+_equipmentsum+"','"+_equipmentpower+"','"+_equipmentvoltage+"')";
					RecordSet.executeSql(sql);
				}												
			}		
		}
		
		String partsname[] = fu.getParameterValues("partsname");
		String partsspec[] = fu.getParameterValues("partsspec");
		String partssum[] = fu.getParameterValues("partssum");
		String partsweight[] = fu.getParameterValues("partsweight");
		String partssize[] = fu.getParameterValues("partssize");								
		if(partsname!=null){
			for(int i=0;i<partsname.length;i++){
				String _partsname = Util.null2String(partsname[i]);
				String _partsspec = Util.null2String(partsspec[i]);
				String _partssum = Util.null2String(partssum[i]);
				String _partsweight = Util.null2String(partsweight[i]);
				String _partssize = Util.null2String(partssize[i]);
				if(!_partsname.equals("")){
					sql = "insert into cptcapitalparts (cptid,partsname,partsspec,partssum,partsweight,partssize) values('"+idadd+"','"+_partsname+"','"+_partsspec+"','"+_partssum+"','"+_partsweight+"','"+_partssize+"')";
					RecordSet.executeSql(sql);
				}				
			}		
		}
		
		
		
		


		SysMaintenanceLog.setRelatedId(Util.getIntValue(idadd));
		SysMaintenanceLog.setOperateType("1");
		SysMaintenanceLog.setOperateDesc("CptCapital_Insert,"+procedurepara);
		SysMaintenanceLog.setSysLogInfo();

		//modify by huaitian 2012/9/24
		//CapitalComInfo.removeCapitalCache();
		CapitalComInfo.addCapitalCache(idadd);

  		CapitalAssortmentComInfo.removeCapitalAssortmentCache();
  		//response.sendRedirect("CptCapital.jsp?id="+idadd);
  		
  		response.sendRedirect("CptCapitalAdd.jsp?isclose=1&isdialog="+isdialog);
  		return ;
	}
	if(operation.equalsIgnoreCase("editcapital")) {

		RecordSetS.executeProc("CptCapital_SelectByID",id);
		RecordSetS.next();

        String mark_old = RecordSetS.getString("mark");
        String isdata = ""+RecordSetS.getString("isdata");
        String codeuse="1";
        if("1".equals(isdata)){
        	codeuse=CodeUtil.getCptData1CodeUse();
        }else{
        	codeuse=CodeUtil.getCptData2CodeUse();
        }
        String mark = "";
        if("2".equals(codeuse)){
        	mark=smark;
        }else if("1".equals(codeuse)) {
        	mark=mark_old;
        }
        
        
		String name_old = Util.toScreen(RecordSetS.getString("name"),user.getLanguage()) ;			/*名称*/
		String barcode_old = Util.toScreen(RecordSetS.getString("barcode"),user.getLanguage()) ;			/*条形码*/
		String startdate_old = Util.toScreen(RecordSetS.getString("startdate"),user.getLanguage()) ;			/*生效日*/
		String enddate_old= Util.toScreen(RecordSetS.getString("enddate"),user.getLanguage()) ;				/*生效至*/
		String seclevel_old= Util.toScreen(RecordSetS.getString("seclevel"),user.getLanguage()) ;				/*安全级别*/
		String departmentid_old = Util.toScreen(RecordSetS.getString("departmentid"),user.getLanguage()) ;/*部门*/
		String costcenterid_old = Util.toScreen(RecordSetS.getString("costcenterid"),user.getLanguage()) ;			/*成本中心*/
		String resourceid_old = ""+Util.getIntValue(RecordSetS.getString("resourceid"),0) ;		/*人力资源*/
		String crmid_old = Util.toScreen(RecordSetS.getString("crmid"),user.getLanguage()) ;
		String sptcount_old = Util.toScreen(RecordSetS.getString("sptcount"),user.getLanguage()) ;	/*单独核算*/
		String currencyid_old = ""+Util.getIntValue(RecordSetS.getString("currencyid"),0) ;	/*币种*/
		String capitalcost_old = ""+Util.getDoubleValue(RecordSetS.getString("capitalcost"),0) ;	/*成本*/
		String startprice_old = RecordSetS.getString("startprice") ;	/*开始价格*/
		String depreendprice_old = RecordSetS.getString("depreendprice") ;	/*折旧底价*/
		String capitalspec_old = Util.toScreen(RecordSetS.getString("capitalspec"),user.getLanguage()) ;	/*规格型号*/
		String capitallevel_old = Util.toScreen(RecordSetS.getString("capitallevel"),user.getLanguage()) ;	/*资产等级*/
		String manufacturer_old = Util.toScreen(RecordSetS.getString("manufacturer"),user.getLanguage()) ;	/*制造厂商*/
		String manudate_old = Util.toScreen(RecordSetS.getString("manudate"),user.getLanguage()) ;	/*出厂日期*/
		String capitaltypeid_old = ""+Util.getIntValue(RecordSetS.getString("capitaltypeid"),0) ;			/*资产类型*/
		String capitalgroupid_old = ""+Util.getIntValue(RecordSetS.getString("capitalgroupid"),0) ;			/*资产组*/
		String unitid_old = ""+Util.getIntValue(RecordSetS.getString("unitid"),0) ;				/*计量单位*/
		String capitalnum_old = Util.toScreen(RecordSetS.getString("capitalnum"),user.getLanguage()) ;			/*数量*/
		String currentnum_old = Util.toScreen(RecordSetS.getString("currentnum"),user.getLanguage()) ;	/*当前数量*/
		String replacecapitalid_old = ""+Util.getIntValue(RecordSetS.getString("replacecapitalid"),0) ;				/*替代*/
		String version_old = Util.toScreen(RecordSetS.getString("version"),user.getLanguage()) ;			/*版本*/
		String itemid_old = "0";//Util.toScreen(RecordSetS.getString("itemid"),user.getLanguage()) ;			/*物品*/
		String remark_old = Util.toScreen(RecordSetS.getString("remark"),user.getLanguage()) ;			/*备注*/
		String depremethod1_old = ""+Util.getIntValue(RecordSetS.getString("depremethod1"),0) ;			/*折旧法一*/
		String depremethod2_old = ""+Util.getIntValue(RecordSetS.getString("depremethod2"),0) ;			/*折旧法二*/
		String deprestartdate_old = Util.toScreen(RecordSetS.getString("deprestartdate"),user.getLanguage()) ;		/*折旧开始日期*/
		String depreenddate_old = Util.toScreen(RecordSetS.getString("depreenddate"),user.getLanguage()) ;			/*折旧结束日期*/
		String customerid_old= ""+Util.getIntValue(RecordSetS.getString("customerid"),0) ;			/*供应商id*/
		String attribute_old= ""+Util.getIntValue(RecordSetS.getString("attribute"),9) ;
		
		String SelectDate_old= ""+Util.toScreen(RecordSetS.getString("SelectDate"),user.getLanguage()) ;
		if(!SelectDate_old.equals(SelectDate)){
		    RecordSetS.executeSql("update CptCapital set SelectDate='"+SelectDate+"' where id="+id);
		}
		/*属性:
		0:自制
		1:采购
		2:租赁
		3:出租
		4:维护
		5:租用
		6:其它
		*/
		String stateid_old = Util.toScreen(RecordSetS.getString("stateid"),user.getLanguage()) ;	/*资产状态*/
		String location_old = Util.toScreen(RecordSetS.getString("location"),user.getLanguage()) ;			/*存放地点*/
		String usedhours_old = Util.toScreen(RecordSetS.getString("usedhours"),user.getLanguage()) ;

		String datefield1_old = Util.toScreen(RecordSetS.getString("datefield1"),user.getLanguage()) ;
		String datefield2_old = Util.toScreen(RecordSetS.getString("datefield2"),user.getLanguage()) ;
		String datefield3_old = Util.toScreen(RecordSetS.getString("datefield3"),user.getLanguage()) ;
		String datefield4_old = Util.toScreen(RecordSetS.getString("datefield4"),user.getLanguage()) ;
		String datefield5_old = Util.toScreen(RecordSetS.getString("datefield5"),user.getLanguage()) ;

		String numberfield1_old = Util.toScreen(RecordSetS.getString("numberfield1"),user.getLanguage()) ;
		String numberfield2_old = Util.toScreen(RecordSetS.getString("numberfield2"),user.getLanguage()) ;
		String numberfield3_old = Util.toScreen(RecordSetS.getString("numberfield3"),user.getLanguage()) ;
		String numberfield4_old = Util.toScreen(RecordSetS.getString("numberfield4"),user.getLanguage()) ;
		String numberfield5_old = Util.toScreen(RecordSetS.getString("numberfield5"),user.getLanguage()) ;
		
		String textfield1_old = Util.toScreen(RecordSetS.getString("textfield1"),user.getLanguage()) ;
		String textfield2_old = Util.toScreen(RecordSetS.getString("textfield2"),user.getLanguage()) ;
		String textfield3_old = Util.toScreen(RecordSetS.getString("textfield3"),user.getLanguage()) ;
		String textfield4_old = Util.toScreen(RecordSetS.getString("textfield4"),user.getLanguage()) ;
		String textfield5_old = Util.toScreen(RecordSetS.getString("textfield5"),user.getLanguage()) ;

		String tinyintfield1_old = Util.toScreen(RecordSetS.getString("tinyintfield1"),user.getLanguage()) ;
		String tinyintfield2_old = Util.toScreen(RecordSetS.getString("tinyintfield2"),user.getLanguage()) ;
		String tinyintfield3_old = Util.toScreen(RecordSetS.getString("tinyintfield3"),user.getLanguage()) ;
		String tinyintfield4_old = Util.toScreen(RecordSetS.getString("tinyintfield4"),user.getLanguage()) ;
		String tinyintfield5_old = Util.toScreen(RecordSetS.getString("tinyintfield5"),user.getLanguage()) ;

		if(tinyintfield1_old.equals("")) tinyintfield1_old="0";
		if(tinyintfield2_old.equals("")) tinyintfield2_old="0";
		if(tinyintfield3_old.equals("")) tinyintfield3_old="0";
		if(tinyintfield4_old.equals("")) tinyintfield4_old="0";
		if(tinyintfield5_old.equals("")) tinyintfield5_old="0";
		
		if(numberfield1_old.equals("")) {
			if(rs.getDBType().equals("oracle")) numberfield1_old="0";
			else 	numberfield1_old="0.0";
		}
		if(numberfield2_old.equals("")) {
			if(rs.getDBType().equals("oracle")) numberfield2_old="0";
			else 	numberfield2_old="0.0";
		}
		if(numberfield3_old.equals("")) {
			if(rs.getDBType().equals("oracle")) numberfield3_old="0";
			else 	numberfield3_old="0.0";
		}
		if(numberfield4_old.equals("")) {
			if(rs.getDBType().equals("oracle")) numberfield4_old="0";
			else 	numberfield4_old="0.0";
		}
		if(numberfield5_old.equals("")) {
			if(rs.getDBType().equals("oracle")) numberfield5_old="0";
			else 	numberfield5_old="0.0";
		}
		
		
		String relatewfid_old = ""+Util.getIntValue(RecordSetS.getString("relatewfid"),0) ;
		String fnamark_old = Util.toScreen(RecordSetS.getString("fnamark"),user.getLanguage()) ;	/*财务编号*/
		String alertnum_old = ""+Util.getDoubleValue(RecordSetS.getString("alertnum"),0.0) ;	/*报警数量*/
        String isinner_old = ""+Util.null2String(RecordSetS.getString("isinner")) ;	/*帐内或帐外*/
        String invoice_old = ""+RecordSetS.getString("invoice");
        String StockInDate_old = ""+RecordSetS.getString("StockInDate") ;
        String depreyear_old = ""+RecordSetS.getString("depreyear") ;
        String deprerate_old = ""+RecordSetS.getString("deprerate") ;
        String contractno_old= ""+RecordSetS.getString("contractno");
		
		
		
		
		String docff01_old=Util.fromScreen(RecordSetS.getString("docff01name"),user.getLanguage());
		String docff02_old=Util.fromScreen(RecordSetS.getString("docff02name"),user.getLanguage());
		String docff03_old=Util.fromScreen(RecordSetS.getString("docff03name"),user.getLanguage());
		String docff04_old=Util.fromScreen(RecordSetS.getString("docff04name"),user.getLanguage());
		String docff05_old=Util.fromScreen(RecordSetS.getString("docff05name"),user.getLanguage());

		String depff01_old=Util.fromScreen(RecordSetS.getString("depff01name"),user.getLanguage());
		String depff02_old=Util.fromScreen(RecordSetS.getString("depff02name"),user.getLanguage());
		String depff03_old=Util.fromScreen(RecordSetS.getString("depff03name"),user.getLanguage());
		String depff04_old=Util.fromScreen(RecordSetS.getString("depff04name"),user.getLanguage());
		String depff05_old=Util.fromScreen(RecordSetS.getString("depff05name"),user.getLanguage());
		
		String crmff01_old=Util.fromScreen(RecordSetS.getString("crmff01name"),user.getLanguage());
		String crmff02_old=Util.fromScreen(RecordSetS.getString("crmff02name"),user.getLanguage());
		String crmff03_old=Util.fromScreen(RecordSetS.getString("crmff03name"),user.getLanguage());
		String crmff04_old=Util.fromScreen(RecordSetS.getString("crmff04name"),user.getLanguage());
		String crmff05_old=Util.fromScreen(RecordSetS.getString("crmff05name"),user.getLanguage());
		
		String reqff01_old=Util.fromScreen(RecordSetS.getString("reqff01name"),user.getLanguage());
		String reqff02_old=Util.fromScreen(RecordSetS.getString("reqff02name"),user.getLanguage());
		String reqff03_old=Util.fromScreen(RecordSetS.getString("reqff03name"),user.getLanguage());
		String reqff04_old=Util.fromScreen(RecordSetS.getString("reqff04name"),user.getLanguage());
		String reqff05_old=Util.fromScreen(RecordSetS.getString("reqff05name"),user.getLanguage());
		
		

		String modifypara = "";
		
		if (!mark_old.equals(mark))
		{//资产编码变更
		modifypara = id;
		modifypara += separator+"77";
		modifypara += separator+mark_old;
		modifypara += separator+mark;
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		
		if (!docff01_old.equals(docff01))
		{
		modifypara = id;
		modifypara += separator+"56";
		modifypara += separator+CapitalTransUtil.getDocNames(docff01_old);
		modifypara += separator+CapitalTransUtil.getDocNames(docff01);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!docff02_old.equals(docff02))
		{
		modifypara = id;
		modifypara += separator+"57";
		modifypara += separator+CapitalTransUtil.getDocNames(docff02_old);
		modifypara += separator+CapitalTransUtil.getDocNames(docff02);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!docff03_old.equals(docff03))
		{
		modifypara = id;
		modifypara += separator+"58";
		modifypara += separator+CapitalTransUtil.getDocNames(docff03_old);
		modifypara += separator+CapitalTransUtil.getDocNames(docff03);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!docff04_old.equals(docff04))
		{
		modifypara = id;
		modifypara += separator+"59";
		modifypara += separator+CapitalTransUtil.getDocNames(docff04_old);
		modifypara += separator+CapitalTransUtil.getDocNames(docff04);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!docff05_old.equals(docff05))
		{
		modifypara = id;
		modifypara += separator+"60";
		modifypara += separator+CapitalTransUtil.getDocNames(docff05_old);
		modifypara += separator+CapitalTransUtil.getDocNames(docff05);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		
		
		if (!depff01_old.equals(depff01))
		{
		modifypara = id;
		modifypara += separator+"61";
		modifypara += separator+CapitalTransUtil.getDepNames(depff01_old);
		modifypara += separator+CapitalTransUtil.getDepNames(depff01);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!depff02_old.equals(depff02))
		{
		modifypara = id;
		modifypara += separator+"62";
		modifypara += separator+CapitalTransUtil.getDepNames(depff02_old);
		modifypara += separator+CapitalTransUtil.getDepNames(depff02);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!depff03_old.equals(depff03))
		{
		modifypara = id;
		modifypara += separator+"63";
		modifypara += separator+CapitalTransUtil.getDepNames(depff03_old);
		modifypara += separator+CapitalTransUtil.getDepNames(depff03);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!depff04_old.equals(depff04))
		{
		modifypara = id;
		modifypara += separator+"64";
		modifypara += separator+CapitalTransUtil.getDepNames(depff04_old);
		modifypara += separator+CapitalTransUtil.getDepNames(depff04);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!depff05_old.equals(depff05))
		{
		modifypara = id;
		modifypara += separator+"65";
		modifypara += separator+CapitalTransUtil.getDepNames(depff05_old);
		modifypara += separator+CapitalTransUtil.getDepNames(depff05);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		
		
		if (!crmff01_old.equals(crmff01))
		{
		modifypara = id;
		modifypara += separator+"66";
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff01_old);
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff01);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!crmff02_old.equals(crmff02))
		{
		modifypara = id;
		modifypara += separator+"67";
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff02_old);
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff02);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!crmff03_old.equals(crmff03))
		{
		modifypara = id;
		modifypara += separator+"68";
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff03_old);
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff03);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!crmff04_old.equals(crmff04))
		{
		modifypara = id;
		modifypara += separator+"69";
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff04_old);
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff04);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!crmff05_old.equals(crmff05))
		{
		modifypara = id;
		modifypara += separator+"70";
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff05_old);
		modifypara += separator+CapitalTransUtil.getCrmNames(crmff05);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		
		
		if (!reqff01_old.equals(reqff01))
		{
		modifypara = id;
		modifypara += separator+"71";
		modifypara += separator+CapitalTransUtil.getReqNames(reqff01_old);
		modifypara += separator+CapitalTransUtil.getReqNames(reqff01);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!reqff02_old.equals(reqff02))
		{
		modifypara = id;
		modifypara += separator+"72";
		modifypara += separator+CapitalTransUtil.getReqNames(reqff02_old);
		modifypara += separator+CapitalTransUtil.getReqNames(reqff02);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!reqff03_old.equals(reqff03))
		{
		modifypara = id;
		modifypara += separator+"73";
		modifypara += separator+CapitalTransUtil.getReqNames(reqff03_old);
		modifypara += separator+CapitalTransUtil.getReqNames(reqff03);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!reqff04_old.equals(reqff04))
		{
		modifypara = id;
		modifypara += separator+"74";
		modifypara += separator+CapitalTransUtil.getReqNames(reqff04_old);
		modifypara += separator+CapitalTransUtil.getReqNames(reqff04);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		if (!reqff05_old.equals(reqff05))
		{
		modifypara = id;
		modifypara += separator+"75";
		modifypara += separator+CapitalTransUtil.getReqNames(reqff05_old);
		modifypara += separator+CapitalTransUtil.getReqNames(reqff05);
		modifypara += separator+""+canEditCptRealUID;
		modifypara += separator+currentdate;
		RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
		}
		
		
		if (!name_old.equals(name))
			{
			modifypara = id;
			modifypara += separator+"1";
			modifypara += separator+name_old;
			modifypara += separator+name;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!barcode_old.equals(barcode))
			{
			modifypara = id;
			modifypara += separator+"2";
			modifypara += separator+barcode_old;
			modifypara += separator+barcode;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!startdate_old.equals(startdate))
			{
			modifypara = id;
			modifypara += separator+"3";
			modifypara += separator+startdate_old;
			modifypara += separator+startdate;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!enddate_old.equals(enddate))
			{
			modifypara = id;
			modifypara += separator+"4";
			modifypara += separator+enddate_old;
			modifypara += separator+enddate;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (Util.getIntValue( seclevel_old,0) != Util.getIntValue (seclevel,0))
			{
			modifypara = id;
			modifypara += separator+"5";
			modifypara += separator+seclevel_old;
			modifypara += separator+seclevel;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!resourceid_old.equals(resourceid))
			{
			modifypara = id;
			modifypara += separator+"6";
			modifypara += separator+Util.toScreen(ResourceComInfo.getResourcename(resourceid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			//如果资产的使用人被修改，那么需要个新的使用人添加共享权限
			if(isdata.equals("2")){
				User useUser=new User();
				useUser.setUid(Util.getIntValue(resourceid));
				useUser.setLogintype(ResourceComInfo.getResourcetype(resourceid));
				useUser.setLanguage(Util.getIntValue( ResourceComInfo.getSystemLanguage(resourceid),7));
				useUser.setSeclevel(ResourceComInfo.getSeclevel(resourceid));
				rs.executeSql( CommonShareManager.getSharLevel("cpt", id, useUser));
				if(!rs.next()){
					RecordSetS.executeSql("INSERT INTO CptCapitalShareInfo ( relateditemid, sharetype , sharelevel, userid )  VALUES ("+id+",1,1,"+resourceid+")");
				}
				
			}
			}
		if (!currencyid_old.equals(currencyid))
			{
			modifypara = id;
			modifypara += separator+"7";
			modifypara += separator+Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!capitalcost_old.equals(capitalcost))
			{
			modifypara = id;
			modifypara += separator+"8";
			modifypara += separator+capitalcost_old;
			modifypara += separator+capitalcost;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!startprice_old.equals(startprice))
			{
			modifypara = id;
			modifypara += separator+"9";
			modifypara += separator+startprice_old;
			modifypara += separator+startprice;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		//if (!depreendprice_old.equals(depreendprice))
		if (Util.getDoubleValue( depreendprice_old,0)!=Util.getDoubleValue( depreendprice,0))
			{
			modifypara = id;
			modifypara += separator+"10";
			modifypara += separator+depreendprice_old;
			modifypara += separator+depreendprice;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!capitalspec_old.equals(capitalspec))
			{
			modifypara = id;
			modifypara += separator+"11";
			modifypara += separator+capitalspec_old;
			modifypara += separator+capitalspec;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!capitallevel_old.equals(capitallevel))
			{
			modifypara = id;
			modifypara += separator+"12";
			modifypara += separator+capitallevel_old;
			modifypara += separator+capitallevel;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!manufacturer_old.equals(manufacturer))
			{
			modifypara = id;
			modifypara += separator+"13";
			modifypara += separator+manufacturer_old;
			modifypara += separator+manufacturer;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!manudate_old.equals(manudate))
			{
			modifypara = id;
			modifypara += separator+"14";
			modifypara += separator+manudate_old;
			modifypara += separator+manudate;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!capitaltypeid_old.equals(capitaltypeid))
			{
			modifypara = id;
			modifypara += separator+"15";
			modifypara += separator+Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(CapitalTypeComInfo.getCapitalTypename(capitaltypeid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!capitalgroupid_old.equals(capitalgroupid))
			{
			modifypara = id;
			modifypara += separator+"16";
			modifypara += separator+Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(CapitalAssortmentComInfo.getAssortmentName(capitalgroupid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!unitid_old.equals(unitid))
			{
			modifypara = id;
			modifypara += separator+"17";
			modifypara += separator+Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(AssetUnitComInfo.getAssetUnitname(unitid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!replacecapitalid_old.equals(replacecapitalid))
			{
			modifypara = id;
			modifypara += separator+"18";
			modifypara += separator+Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(CapitalComInfo.getCapitalname(replacecapitalid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!version_old.equals(version))
			{
			modifypara = id;
			modifypara += separator+"19";
			modifypara += separator+version_old;
			modifypara += separator+version;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!location_old.equals(location))
			{
			modifypara = id;
			modifypara += separator+"20";
			modifypara += separator+location_old;
			modifypara += separator+location;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!remark_old.equals(remark))
			{
			modifypara = id;
			modifypara += separator+"21";
			modifypara += separator+remark_old;
			modifypara += separator+remark;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!depremethod1_old.equals(depremethod1))
			{
			modifypara = id;
			modifypara += separator+"22";
			modifypara += separator+Util.toScreen(DepreMethodComInfo.getDepreMethodname(depremethod1_old),user.getLanguage());
			modifypara += separator+Util.toScreen(DepreMethodComInfo.getDepreMethodname(depremethod1),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!depremethod2_old.equals(depremethod2))
			{
			modifypara = id;
			modifypara += separator+"23";
			modifypara += separator+Util.toScreen(DepreMethodComInfo.getDepreMethodname(depremethod2_old),user.getLanguage());
			modifypara += separator+Util.toScreen(DepreMethodComInfo.getDepreMethodname(depremethod2),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!customerid_old.equals(customerid))
			{
			modifypara = id;
			modifypara += separator+"26";
			modifypara += separator+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid_old),user.getLanguage());
			modifypara += separator+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(customerid),user.getLanguage());
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!attribute_old.equals(attribute))
			{
			String attributeStr_old = "";
			String attributeStr = "";
			if(attribute_old.equals("0")) attributeStr_old = SystemEnv.getHtmlLabelName(1366,user.getLanguage());
			if(attribute_old.equals("1")) attributeStr_old = SystemEnv.getHtmlLabelName(1367,user.getLanguage());
			if(attribute_old.equals("2")) attributeStr_old = SystemEnv.getHtmlLabelName(1368,user.getLanguage());
			if(attribute_old.equals("3")) attributeStr_old = SystemEnv.getHtmlLabelName(1369,user.getLanguage());
			if(attribute_old.equals("4")) attributeStr_old = SystemEnv.getHtmlLabelName(60,user.getLanguage());
			if(attribute_old.equals("5")) attributeStr_old = SystemEnv.getHtmlLabelName(1370,user.getLanguage());
			if(attribute_old.equals("6")) attributeStr_old = SystemEnv.getHtmlLabelName(811,user.getLanguage());

			if(attribute.equals("0")) attributeStr = SystemEnv.getHtmlLabelName(1366,user.getLanguage());
			if(attribute.equals("1")) attributeStr = SystemEnv.getHtmlLabelName(1367,user.getLanguage());
			if(attribute.equals("2")) attributeStr = SystemEnv.getHtmlLabelName(1368,user.getLanguage());
			if(attribute.equals("3")) attributeStr = SystemEnv.getHtmlLabelName(1369,user.getLanguage());
			if(attribute.equals("4")) attributeStr = SystemEnv.getHtmlLabelName(60,user.getLanguage());
			if(attribute.equals("5")) attributeStr = SystemEnv.getHtmlLabelName(1370,user.getLanguage());
			if(attribute.equals("6")) attributeStr = SystemEnv.getHtmlLabelName(811,user.getLanguage());

			modifypara = id;
			modifypara += separator+"27";
			modifypara += separator+attributeStr_old;
			modifypara += separator+attributeStr;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}

//其他字段
		if (!datefield1_old.equals(dff01))
			{
			modifypara = id;
			modifypara += separator+"28";
			modifypara += separator+datefield1_old;
			modifypara += separator+dff01;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!datefield2_old.equals(dff02))
			{
			modifypara = id;
			modifypara += separator+"29";
			modifypara += separator+datefield2_old;
			modifypara += separator+dff02;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!datefield3_old.equals(dff03))
			{
			modifypara = id;
			modifypara += separator+"30";
			modifypara += separator+datefield3_old;
			modifypara += separator+dff03;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!datefield4_old.equals(dff04))
			{
			modifypara = id;
			modifypara += separator+"31";
			modifypara += separator+datefield4_old;
			modifypara += separator+dff04;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!datefield5_old.equals(dff05))
			{
			modifypara = id;
			modifypara += separator+"32";
			modifypara += separator+datefield5_old;
			modifypara += separator+dff05;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!numberfield1_old.equals(nff01))
			{
			modifypara = id;
			modifypara += separator+"33";
			modifypara += separator+numberfield1_old;
			modifypara += separator+nff01;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!numberfield2_old.equals(nff02))
			{
			modifypara = id;
			modifypara += separator+"34";
			modifypara += separator+numberfield2_old;
			modifypara += separator+nff02;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!numberfield3_old.equals(nff03))
			{
			modifypara = id;
			modifypara += separator+"35";
			modifypara += separator+numberfield3_old;
			modifypara += separator+nff03;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!numberfield4_old.equals(nff04))
			{
			modifypara = id;
			modifypara += separator+"36";
			modifypara += separator+numberfield4_old;
			modifypara += separator+nff04;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!numberfield5_old.equals(nff05))
			{
			modifypara = id;
			modifypara += separator+"37";
			modifypara += separator+numberfield5_old;
			modifypara += separator+nff05;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!textfield1_old.equals(tff01))
			{
			modifypara = id;
			modifypara += separator+"38";
			modifypara += separator+textfield1_old;
			modifypara += separator+tff01;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!textfield2_old.equals(tff02))
			{
			modifypara = id;
			modifypara += separator+"39";
			modifypara += separator+textfield2_old;
			modifypara += separator+tff02;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!textfield3_old.equals(tff03))
			{
			modifypara = id;
			modifypara += separator+"40";
			modifypara += separator+textfield3_old;
			modifypara += separator+tff03;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!textfield4_old.equals(tff04))
			{
			modifypara = id;
			modifypara += separator+"41";
			modifypara += separator+textfield4_old;
			modifypara += separator+tff04;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!textfield5_old.equals(tff05))
			{
			modifypara = id;
			modifypara += separator+"42";
			modifypara += separator+textfield5_old;
			modifypara += separator+tff05;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!tinyintfield1_old.equals(bff01))
			{
			modifypara = id;
			modifypara += separator+"43";
			modifypara += separator+tinyintfield1_old;
			modifypara += separator+bff01;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!tinyintfield2_old.equals(bff02))
			{
			modifypara = id;
			modifypara += separator+"44";
			modifypara += separator+tinyintfield2_old;
			modifypara += separator+bff02;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!tinyintfield3_old.equals(bff03))
			{
			modifypara = id;
			modifypara += separator+"45";
			modifypara += separator+tinyintfield3_old;
			modifypara += separator+bff03;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!tinyintfield4_old.equals(bff04))
			{
			modifypara = id;
			modifypara += separator+"46";
			modifypara += separator+tinyintfield4_old;
			modifypara += separator+bff04;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!tinyintfield5_old.equals(bff05))
			{
			modifypara = id;
			modifypara += separator+"47";
			modifypara += separator+tinyintfield5_old;
			modifypara += separator+bff05;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!fnamark_old.equals(fnamark))
			{
			modifypara = id;
			modifypara += separator+"48";
			modifypara += separator+fnamark_old;
			modifypara += separator+fnamark;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!alertnum_old.equals(alertnum))
			{
			modifypara = id;
			modifypara += separator+"49";
			modifypara += separator+alertnum_old;
			modifypara += separator+alertnum;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
         if (!isinner_old.equals(isinner))
			{
             String isinner_oldstr = "" ;
             String isinnerstr = "" ;

             if( isinner_old.equals("0") ) isinner_oldstr = SystemEnv.getHtmlLabelName(15298,user.getLanguage()) ;
             else isinner_oldstr = SystemEnv.getHtmlLabelName(15299,user.getLanguage()) ;

             if( isinner.equals("0") ) isinnerstr = SystemEnv.getHtmlLabelName(15298,user.getLanguage()) ;
             else isinnerstr = SystemEnv.getHtmlLabelName(15299,user.getLanguage()) ;

			modifypara = id;
			modifypara += separator+"50";
			modifypara += separator+isinner_oldstr;
			modifypara += separator+isinnerstr;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!invoice_old.equals(invoice))
			{
			modifypara = id;
			modifypara += separator+"51";
			modifypara += separator+invoice_old;
			modifypara += separator+invoice;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if (!StockInDate_old.equals(StockInDate))
			{
			modifypara = id;
			modifypara += separator+"52";
			modifypara += separator+StockInDate_old;
			modifypara += separator+StockInDate;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		//if (!depreyear_old.equals(depreyear))
		if (Util.getDoubleValue( depreyear_old,0)!=Util.getDoubleValue (depreyear,0))
			{
			modifypara = id;
			modifypara += separator+"53";
			modifypara += separator+depreyear_old;
			modifypara += separator+depreyear;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		//if (!deprerate_old.equals(deprerate))
		if (Util.getDoubleValue( deprerate_old,0)!=Util.getDoubleValue(deprerate,0))
			{
			modifypara = id;
			modifypara += separator+"54";
			modifypara += separator+deprerate_old;
			modifypara += separator+deprerate;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}
		if(!contractno_old.equals(contractno)){
			modifypara = id;
			modifypara += separator+"76";
			modifypara += separator+contractno_old;
			modifypara += separator+contractno;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			
		}
		if (!deprestartdate_old.equals(deprestartdate))
			{
			modifypara = id;
			modifypara += separator+"55";
			modifypara += separator+deprestartdate_old;
			modifypara += separator+deprestartdate;
			modifypara += separator+""+canEditCptRealUID;
			modifypara += separator+currentdate;
			RecordSetS.executeProc("CptCapitalModify_Insert",modifypara) ;
			}

		procedurepara = id;
		procedurepara += separator+mark;
		procedurepara += separator+name;
		procedurepara += separator+barcode;
		procedurepara += separator+startdate;
		procedurepara += separator+enddate;
		procedurepara += separator+seclevel;
		procedurepara += separator+resourceid;
    procedurepara += separator+sptcount;
		procedurepara += separator+currencyid;
		procedurepara += separator+capitalcost;
		procedurepara += separator+startprice;
		procedurepara += separator+depreendprice;
		procedurepara += separator+capitalspec;
		procedurepara += separator+capitallevel;
		procedurepara += separator+manufacturer;
		procedurepara += separator+manudate;
		procedurepara += separator+capitaltypeid;
		procedurepara += separator+capitalgroupid;
		procedurepara += separator+unitid;
		procedurepara += separator+replacecapitalid;
		procedurepara += separator+version;
		procedurepara += separator+location;
//	rocedurepara += separator+itemid;
		procedurepara += separator+remark;
		procedurepara += separator+capitalimageid;
		procedurepara += separator+depremethod1;
		procedurepara += separator+depremethod2;
		procedurepara += separator+customerid;
		procedurepara += separator+attribute;

		procedurepara += separator+dff01;
		procedurepara += separator+dff02;
		procedurepara += separator+dff03;
		procedurepara += separator+dff04;
		procedurepara += separator+dff05;
		procedurepara += separator+nff01;
		procedurepara += separator+nff02;
		procedurepara += separator+nff03;
		procedurepara += separator+nff04;
		procedurepara += separator+nff05;
		procedurepara += separator+tff01;
		procedurepara += separator+tff02;
		procedurepara += separator+tff03;
		procedurepara += separator+tff04;
		procedurepara += separator+tff05;
		procedurepara += separator+bff01;
		procedurepara += separator+bff02;
		procedurepara += separator+bff03;
		procedurepara += separator+bff04;
		procedurepara += separator+bff05;

		procedurepara += separator+lastmoderid;
		procedurepara += separator+lastmoddate;
		procedurepara += separator+lastmodtime;
		procedurepara += separator+relatewfid;
		procedurepara += separator+alertnum;
		procedurepara += separator+fnamark;
        procedurepara += separator+isinner;
        procedurepara += separator+invoice;
        procedurepara += separator+StockInDate;
        procedurepara += separator+depreyear;
        procedurepara += separator+deprerate;
        procedurepara += separator+deprestartdate;
        procedurepara += separator+contractno;
		RecordSet.executeProc("CptCapital_Update",procedurepara);

		
		CptFieldManager.updateCusfieldValue(id, fu, user);
		//增加新的自定义字段
		//String sql = "update cptcapital set docff01name='"+docff01+"',docff02name='"+docff02+"',docff03name='"+docff03+"',docff04name='"+docff04+"',docff05name='"+docff05+"',depff01name='"+depff01+"',depff02name='"+depff02+"',depff03name='"+depff03+"',depff04name='"+depff04+"',depff05name='"+depff05+"',crmff01name='"+crmff01+"',crmff02name='"+crmff02+"',crmff03name='"+crmff03+"',crmff04name='"+crmff04+"',crmff05name='"+crmff05+"',reqff01name='"+reqff01+"',reqff02name='"+reqff02+"',reqff03name='"+reqff03+"',reqff04name='"+reqff04+"',reqff05name='"+reqff05+"' where id = " + id;
		//RecordSet.executeSql(sql);
		//new weaver.general.BaseBean().writeLog(sql);
		String sql = "update cptcapital set blongsubcompany='"+blongsubcompany+"',blongdepartment='"+blongdepartment+"',issupervision='"+issupervision+"',amountpay='"+amountpay+"',purchasestate='"+purchasestate+"',departmentid='"+departmentid+"',equipmentpower = '"+mequipmentpower+"',mark='"+mark+"' where id = " + id;
		RecordSet.executeSql(sql);
		
		String equipmentname[] = fu.getParameterValues("equipmentname");
		String equipmentspec[] = fu.getParameterValues("equipmentspec");
		String equipmentsum[] = fu.getParameterValues("equipmentsum");		
		String equipmentpower[] = fu.getParameterValues("equipmentpower");
		String equipmentvoltage[] = fu.getParameterValues("equipmentvoltage");				
		sql= "delete from cptcapitalequipment where cptid = " + id;
		RecordSet.executeSql(sql);
		if(equipmentname!=null){
			for(int i=0;i<equipmentname.length;i++){
				String _equipmentname = Util.null2String(equipmentname[i]);
				String _equipmentspec = Util.null2String(equipmentspec[i]);
				int _equipmentsum = Util.getIntValue(equipmentsum[i],0);
				String _equipmentpower = Util.null2String(equipmentpower[i]);
				String _equipmentvoltage = Util.null2String(equipmentvoltage[i]);
				if(!_equipmentname.equals("")){
					sql = "insert into cptcapitalequipment (cptid,equipmentname,equipmentspec,equipmentsum,equipmentpower,equipmentvoltage) values ('"+id+"','"+_equipmentname+"','"+_equipmentspec+"','"+_equipmentsum+"','"+_equipmentpower+"','"+_equipmentvoltage+"')";
					RecordSet.executeSql(sql);
				}												
			}		
		}
		
		String partsname[] = fu.getParameterValues("partsname");
		String partsspec[] = fu.getParameterValues("partsspec");
		String partssum[] = fu.getParameterValues("partssum");
		String partsweight[] = fu.getParameterValues("partsweight");
		String partssize[] = fu.getParameterValues("partssize");								
		sql= "delete from cptcapitalparts where cptid = " + id;
		RecordSet.executeSql(sql); 
		if(partsname!=null){
			for(int i=0;i<partsname.length;i++){
				String _partsname = Util.null2String(partsname[i]);
				String _partsspec = Util.null2String(partsspec[i]);
				String _partssum = Util.null2String(partssum[i]);
				String _partsweight = Util.null2String(partsweight[i]);
				String _partssize = Util.null2String(partssize[i]);
				if(!_partsname.equals("")){
					sql = "insert into cptcapitalparts (cptid,partsname,partsspec,partssum,partsweight,partssize) values('"+id+"','"+_partsname+"','"+_partsspec+"','"+_partssum+"','"+_partsweight+"','"+_partssize+"')";
					RecordSet.executeSql(sql);
				}				
			}		
		}

		SysMaintenanceLog.setRelatedId(Util.getIntValue(id));
		SysMaintenanceLog.setOperateType("2");
//		SysMaintenanceLog.setOperateDesc("CptCapital_Update,"+procedurepara);
        SysMaintenanceLog.setOperateDesc("");
		SysMaintenanceLog.setSysLogInfo();

		//modify by huaitian 2012/9/24
		//CapitalComInfo.removeCapitalCache();
		CapitalComInfo.updateCapitalCache(id);

  		CapitalAssortmentComInfo.removeCapitalAssortmentCache();
%>
<script>
	window.parent.location="CptCapital.jsp?id=<%=id %>&isdialog=<%=isdialog %>";
</script>
<%


  		//response.sendRedirect("CptCapital.jsp?id="+id);
  		return ;
	}
  }
	else if(operation.equals("deletecapital")){
    String capitalid = Util.null2String(fu.getParameter("id")) ;
	String name = Util.fromScreen(fu.getParameter("name"),user.getLanguage()) ;			/*名称*/

	String para = ""+capitalid;
	//added by dongping 2004-8-9 for TD558
	//description :实现 资产资料被入库申请引用时，删除资产资料需要弹出提示"该记录已被引用，不能被删除！",当不引用时,就可以被删除!

	//查看入库的明细表中有没有 capitalid 的引用,如果有引用 就查看其 现在是否已被入库验收过
    boolean candelete = false;
	String strSql = "select * from cptcapital where datatype = "+capitalid ;
	RecordSet.executeSql(strSql) ;
	if(RecordSet.next()) candelete = true;
	strSql = "select * from cptstockinmain t1 , cptstockindetail t2 where t1.id = t2.cptstockinid and ischecked = 0 and cpttype = "+capitalid ;
	RecordSet.executeSql(strSql) ;
	if(RecordSet.next()) candelete = true;
	if (candelete) {%>

            <SCRIPT LANGUAGE="JavaScript">
                alert ("<%=SystemEnv.getHtmlLabelNames("83610",user.getLanguage())%>");
                window.location="CptCapital.jsp?id="+<%=capitalid%>;
		    </SCRIPT>
        <%
          return ;
	}
	//end.
   
    String treeid = "";
    strSql = "select * from cptcapital where id = '"+capitalid+"'";
    RecordSet.executeSql(strSql);
    if(RecordSet.next()){
       treeid = RecordSet.getString("capitalgroupid");
    }
    
    // added by lupeng 2004-07-21 for TD558
    boolean canForcedDel = HrmUserVarify.checkUserRight("Capital:Maintenance",user);
    if (canForcedDel) {
        RecordSet.executeProc("CptCapital_ForcedDelete", para);

        SysMaintenanceLog.resetParameter();
        SysMaintenanceLog.setRelatedId(Util.getIntValue(capitalid));
        SysMaintenanceLog.setRelatedName(name);
        SysMaintenanceLog.setOperateType("3");
        SysMaintenanceLog.setOperateDesc("CptCapital_Delete,"+para);
        SysMaintenanceLog.setOperateItem("51");
        SysMaintenanceLog.setOperateUserid(user.getUID(user,"Capital:Maintenance"));
        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
        SysMaintenanceLog.setSysLogInfo();

        //modify by huaitian 2012/9/24
		//CapitalComInfo.removeCapitalCache() ;
		CapitalComInfo.deleteCapitalCache(capitalid);

        CapitalAssortmentComInfo.removeCapitalAssortmentCache();

		RecordSet.executeSql("delete from CptCapitalShareInfo where relateditemid="+capitalid);
		//RecordSet.executeProc("CptShareDetail_DeleteByCptId", capitalid);
      %>
        <SCRIPT LANGUAGE="JavaScript">
            setTimeout("window.close()",0);
            try{
                window.opener._table.reLoad();
            }catch(e){
                window.location="../search/CptSearchResult.jsp";
            }
            window.opener.parent.treeFrame.location="/cpt/maintenance/CptAssortmentTree.jsp?paraid=<%=treeid%>";
        </SCRIPT>
      <%
        return;
    }
    // end.

	RecordSet.executeProc("CptCapital_Delete",para);
    RecordSet.next();
    String rtvalue = "";
    if((rtvalue=RecordSet.getString(1)).equals("-1")){
   		response.sendRedirect("CptCapitalEdit.jsp?id="+capitalid+"&msgid=20");
		return ;
    }
      SysMaintenanceLog.resetParameter();
      SysMaintenanceLog.setRelatedId(Util.getIntValue(capitalid));
	  SysMaintenanceLog.setRelatedName(name);
      SysMaintenanceLog.setOperateType("3");
      SysMaintenanceLog.setOperateDesc("CptCapital_Delete,"+para);
      SysMaintenanceLog.setOperateItem("51");
      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalEdit:Delete"));
      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
      SysMaintenanceLog.setSysLogInfo();

	  CapitalComInfo.removeCapitalCache() ;
	  CapitalAssortmentComInfo.removeCapitalAssortmentCache();

	  RecordSet.executeSql("delete from CptCapitalShareInfo where relateditemid="+capitalid);
	 //RecordSet.executeProc("CptShareDetail_DeleteByCptId", capitalid);
      %>
        <SCRIPT LANGUAGE="JavaScript">
            setTimeout("window.close()",0);
            try{
                window.opener._table.reLoad();
            }catch(e){
                window.location="../search/CptSearchResult.jsp";
            }           
        </SCRIPT>
      <%
 }else if("batchdelete".equalsIgnoreCase(operation)){//批量删除
	JSONArray jsonArray=new JSONArray();
	String assortmentid = Util.null2String(request.getParameter("id"));

	String [] arr= Util.TokenizerString2(assortmentid, ",");
	boolean canForcedDel = HrmUserVarify.checkUserRight("Capital:Maintenance",user);
	for(int i=0;i<arr.length;i++){
		String para = ""+arr[i];
		
		//查看入库的明细表中有没有 capitalid 的引用,如果有引用 就查看其 现在是否已被入库验收过
	    boolean candelete = false;
		String strSql = "select * from cptcapital where datatype = "+para ;
		RecordSet.executeSql(strSql) ;
		if(RecordSet.next()) candelete = true;
		strSql = "select * from cptstockinmain t1 , cptstockindetail t2 where t1.id = t2.cptstockinid and ischecked = 0 and cpttype = "+para ;
		RecordSet.executeSql(strSql) ;
		if(RecordSet.next()) candelete = true;
		if (candelete) {
			jsonArray.put(""+CapitalComInfo.getCapitalname(para)+" "+SystemEnv.getHtmlLabelName(20151,user.getLanguage()) );
			continue;
		}
	   
	    if (canForcedDel) {
	        RecordSet.executeProc("CptCapital_ForcedDelete", para);
	        SysMaintenanceLog.resetParameter();
	        SysMaintenanceLog.setRelatedId(Util.getIntValue(para));
	        SysMaintenanceLog.setRelatedName(CapitalComInfo.getCapitalname(para));
	        SysMaintenanceLog.setOperateType("3");
	        SysMaintenanceLog.setOperateDesc("CptCapital_Delete,"+para);
	        SysMaintenanceLog.setOperateItem("51");
	        SysMaintenanceLog.setOperateUserid(user.getUID(user,"Capital:Maintenance"));
	        SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
	        SysMaintenanceLog.setSysLogInfo();
			RecordSet.executeSql("delete from CptCapitalShareInfo where relateditemid="+para);
			//RecordSet.executeProc("CptShareDetail_DeleteByCptId", para);
			
	    }else{
	    	  RecordSet.executeProc("CptCapital_Delete",para);
		      SysMaintenanceLog.resetParameter();
		      SysMaintenanceLog.setRelatedId(Util.getIntValue(para));
			  SysMaintenanceLog.setRelatedName(CapitalComInfo.getCapitalname(para));
		      SysMaintenanceLog.setOperateType("3");
		      SysMaintenanceLog.setOperateDesc("CptCapital_Delete,"+para);
		      SysMaintenanceLog.setOperateItem("51");
		      SysMaintenanceLog.setOperateUserid(user.getUID(user,"CptCapitalEdit:Delete"));
		      SysMaintenanceLog.setClientAddress(request.getRemoteAddr());
		      SysMaintenanceLog.setSysLogInfo();
			  RecordSet.executeSql("delete from CptCapitalShareInfo where relateditemid="+para);
			  //RecordSet.executeProc("CptShareDetail_DeleteByCptId", para);
	    }
		CapitalComInfo.deleteCapitalCache(para);
		CapitalAssortmentComInfo.removeCapitalAssortmentCache();
		
	}
	
	out.println(jsonArray.toString());
	return;
	
 }
 	//判断资产编码是否重复
	
	if("checkmark".equalsIgnoreCase(operation)){
	  		String isdata = Util.null2String(fu.getParameter("isdata")) ;
			String smark = Util.fromScreen(fu.getParameter("mark"),user.getLanguage()).trim() ;	
			String codeuse = Util.fromScreen(fu.getParameter("codeuse"),user.getLanguage()) ;		/*编码*/
			JSONObject jsonObject=new JSONObject();
			if("2".equals(codeuse)){
				
				boolean success=true;
				String sql = "select * from cptcapital where rtrim(ltrim(mark))='" + smark + "' ";
				if(!"".equals(isdata)){
					sql+="and isdata = '"+isdata+"'";
				}
				if(!"".equals(id)){
					sql+="and id <> "+id;
				}
		        RecordSet.executeSql(sql);
		        if (RecordSet.next()) {
		           success = false;
		        } else {
		           success = true;
		        }
				jsonObject.put("msg", ""+success);
				out.print(jsonObject.toString());
			}else{
				jsonObject.put("msg", ""+true);
				out.print(jsonObject.toString());
			}
	}
%>