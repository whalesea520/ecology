
<%@page import="weaver.formmode.setup.CodeBuild"%>
<%@page import="weaver.cpt.job.CptLowInventoryRemindJob"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util,weaver.formmode.setup.ModeRightInfo,weaver.conn.RecordSet,weaver.formmode.cuspage.cpt.Cpt4modeUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%

char separator = Util.getSeparator() ;

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;
String lastmoderid = ""+user.getUID();

//--------------
String isbatch = Util.null2String (request.getParameter("isbatch"));
String Ids = Util.fromScreen(request.getParameter("id"),user.getLanguage());

//String Invoice = Util.fromScreen(request.getParameter("Invoice"),user.getLanguage());
String BuyerID = Util.fromScreen(request.getParameter("BuyerID"),user.getLanguage());
String supplierid = Util.fromScreen(request.getParameter("customerid"),user.getLanguage());
int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);

String departmentid = "" + Util.getIntValue(request.getParameter("CptDept_to"),0);  //入库部门
String blongdepartment = departmentid;//所属部门
String blongsubcompany = DepartmentComInfo.getSubcompanyid1(departmentid);//所属分部

String[] idArr=Ids.split(",");

//bb.writeLog("tagtag start batchcptinstock4mode...");
/**bb.writeLog("isbatch:"+isbatch);
bb.writeLog("Ids:"+Ids);
bb.writeLog("BuyerID:"+BuyerID);
bb.writeLog("supplierid:"+supplierid);
bb.writeLog("departmentid:"+departmentid);
bb.writeLog("stockindate:"+stockindate);
bb.writeLog("totaldetail:"+totaldetail);**/
synchronized(this){

String ids=Util.null2String(request.getParameter("id"));
String[] idsArray = ids.split(",");
ModeRightInfo modeRightInfo = new ModeRightInfo();
for (int j = 0 ; j < idsArray.length ; j++) {
	String billid = idsArray[j];
	
	
	String detailid="";
	String mainid="";
	String price="";
    String customerid="";
    String capitalspec="";
    String location="";
    String Invoice="";
	String sptcount1="";
	String contractno="";
	int i=0;
	int v=0;
    
for (i=0;i<totaldetail;i++){
	detailid =request.getParameter("node_"+i+"_id");
	mainid =Util.null2String( request.getParameter("node_"+i+"_mainid"));
	
	if(!mainid.equals(billid)) continue;
	rs.executeSql("select m.stockindepart,dt.id,m.checkerid,dt.plannumber,dt.innumber,dt.cpttype,stockindate from uf_CptStockIn m, uf_CptStockIn_dt1 dt where m.id=dt.mainid and dt.id="+detailid);
	if(!rs.next()){
		continue;
	}
    int checkerid = rs.getInt("checkerid");//验收人
	int cpttype =Util.getIntValue(request.getParameter("node_" + i + "_cptid"), 0);
	String stockindate = rs.getString("stockindate"); //入库日期
	double innumber =Util.getDoubleValue( request.getParameter("node_"+i+"_innumber"),0.0);
	price = request.getParameter("node_"+i+"_unitprice");
	BigDecimal inprice = new BigDecimal(""+Util.getDoubleValue( rs.getString("price"),0));//单价
    customerid = request.getParameter("node_"+i+"_customerid");
    capitalspec =Util.null2String( request.getParameter("node_"+i+"_capitalspec"));
    location = Util.null2String(request.getParameter("node_"+i+"_location"));
    Invoice = Util.null2String(request.getParameter("node_"+i+"_Invoice"));
	contractno = Util.null2String(request.getParameter("node_"+i+"_contractno"));
    String tempselectdate=Util.null2String(request.getParameter("node_"+i+"_stockindate"));
    
    
	RecordSet rs2 =new RecordSet();
	int dtid = Util.getIntValue( detailid);//明细表ID
	
	
	rs2.executeSql("update uf_CptStockIn_dt1 set innumber="+innumber+" where id="+dtid);
	rs2.executeSql("select sptcount from uf_cptcapital where id="+cpttype);
	String sptcount = "";
	if (rs2.next()) sptcount = rs2.getString("sptcount");//核算方式
	if ("0".equals(sptcount)) { //单独核算
		for (int ii=0;ii<innumber;ii++){
			//生成资产信息
			if (rs2.getDBType().equals("sqlserver")) {//SQL SERVER
				//获取资产资料表所有列
				rs2.executeSql("Select Name FROM SysColumns Where id=Object_Id('uf_cptcapital')");
			} else if (rs2.getDBType().equals("oracle")) { //ORACLE
				rs2.executeSql("select COLUMN_NAME from dba_tab_columns where table_name =upper('uf_cptcapital') order by COLUMN_NAME ");
			}
			String names = "";
			while (rs2.next()) {
				String name = rs2.getString("Name");
				if ("id".equals(name.toLowerCase())) continue;
				names += name + ",";
			}
			if (!"".equals(names)) {
				names = names.substring(0,names.length() - 1);
				rs2.executeSql("insert into uf_cptcapital("+names+") select "+names+" from uf_cptcapital where id="+cpttype);
			}
			rs2.executeSql("select max(id) as id from uf_cptcapital");
			rs2.next();
			int cptbillid = Util.getIntValue(rs2.getString("id"),0);
			//修改isdata=2
			rs2.executeSql("update uf_cptcapital set location='"+location+"',capitalspec='"+capitalspec+"',datatype='"+cpttype+"',stateid='0',capitalnum=1,currentnum=1,resourceid=null,departmentid=null,blongdepartment='"+blongdepartment+"',blongsubcompany='"+blongsubcompany+"',formmodeid='"+Cpt4modeUtil.getModeid("zcxx")+"',modedatacreater="+checkerid+",isdata=2 where id="+cptbillid);
			//插入权限
			modeRightInfo.editModeDataShare(checkerid, Util.getIntValue( Cpt4modeUtil.getModeid("zcxx")), cptbillid);
			CodeBuild codeBuild = new CodeBuild(Util.getIntValue( Cpt4modeUtil.getModeid("zcxx")));
			String capitalno= codeBuild.getModeCodeStr(Util.getIntValue( Cpt4modeUtil.getFormid(Cpt4modeUtil.getModeid("zcxx"))), cptbillid);
			rs2.executeSql("insert into uf_CptUseInfo(formmodeid,modedatacreater,modedatacreatertype,modedatacreatedate,modedatacreatetime) values('"+Util.getIntValue( Cpt4modeUtil.getModeid("zcrk"))+"','"+checkerid+"','0','"+currentdate+"','"+currenttime+"') ");
			rs2.executeSql("select max(id) as id from uf_CptUseInfo");
			rs2.next();
			int uselogid = Util.getIntValue(rs2.getString("id"),0);
			String sql22=" insert into uf_CptUseInfo_dt1(mainid,Usedate,capitalid,usecount,useaddress,usestatus,capitalno,capitalspec,remark,fee) "+
							" values('"+uselogid+"','"+stockindate+"','"+cptbillid+"','1','"+location+"','0','"+capitalno+"','"+capitalspec+"','','"+Util.getDoubleValue(price,0.0)+"') ";
			rs2.executeSql(sql22);
			//bb.writeLog("tagtag instockuselog:"+sql22);
			//插入权限
			modeRightInfo.editModeDataShare(checkerid, Util.getIntValue( Cpt4modeUtil.getModeid("zcrk")), uselogid);
		}
	} else { //非单独核算
		//通过资产和部门确定该部门下是否已经拥有该资产
		RecordSet recordSetInner = new RecordSet();
		recordSetInner.executeSql("select id,mark,startprice,capitalnum from uf_cptcapital where datatype="+cpttype+" and blongdepartment="+departmentid);
		String rltid = ""; 
		//String tempmark = "";
		if (recordSetInner.next()) { //该部门下已经拥有该资产
			//费用平均
			rltid = recordSetInner.getString("id");
			//tempmark = recordSetInner.getString("mark");//资产编号
			BigDecimal oldprice = new BigDecimal(""+Util.getDoubleValue( recordSetInner.getString("startprice"),0));
	        BigDecimal oldnum   = new BigDecimal(""+Util.getDoubleValue( recordSetInner.getString("capitalnum"),0));
	        inprice = inprice.multiply(new BigDecimal(""+innumber));
	        inprice = inprice.add(oldprice.multiply(oldnum));
	        inprice = inprice.divide(oldnum.add(new BigDecimal(""+ innumber)),2,BigDecimal.ROUND_UP);
	           //修改资产信息
	           recordSetInner.executeSql("update uf_cptcapital set capitalnum="+(Util.getDoubleValue(""+(oldnum.doubleValue()+innumber),0.0))+",currentnum=currentnum+"+innumber+",stateid='0',startdate='"+stockindate+"',startprice='"+inprice+"' where id="+rltid);
	           
	           
		} else { //该部门下不存在该资产
			//获取资产资料表所有列
			if (rs2.getDBType().equals("sqlserver")) {//SQL SERVER
				rs2.executeSql("Select Name FROM SysColumns Where id=Object_Id('uf_cptcapital')");
			} else if (rs2.getDBType().equals("oracle")) { //ORACLE
				rs2.executeSql("select COLUMN_NAME from dba_tab_columns where table_name =upper('uf_cptcapital') order by COLUMN_NAME ");
			}
			String names = "";
			while (rs2.next()) {
				String name = rs2.getString("Name");
				if ("id".equals(name.toLowerCase())) continue;
				names += name + ",";
			}
			if (!"".equals(names)) {
				names = names.substring(0,names.length() - 1);
				rs2.executeSql("insert into uf_cptcapital("+names+") select "+names+" from uf_cptcapital where id="+cpttype);
			}
			rs2.executeSql("select max(id) as id from uf_cptcapital");
			rs2.next();
			int cptbillid = Util.getIntValue(rs2.getString("id"),0);
			//修改isdata=2
			rs2.executeSql("update uf_cptcapital set location='"+location+"',capitalspec='"+capitalspec+"',datatype='"+cpttype+"',stateid='0',capitalnum="+Util.getDoubleValue(""+innumber,0.0)+",currentnum="+Util.getDoubleValue(""+innumber,0.0)+",resourceid=null,departmentid=null,blongdepartment='"+blongdepartment+"',blongsubcompany='"+blongsubcompany+"',formmodeid='"+Cpt4modeUtil.getModeid("zcxx")+"',modedatacreater="+checkerid+",isdata=2 where id="+cptbillid);
			//插入权限
			modeRightInfo.editModeDataShare(checkerid, Util.getIntValue( Cpt4modeUtil.getModeid("zcxx")), cptbillid);
			
			CodeBuild codeBuild = new CodeBuild(Util.getIntValue( Cpt4modeUtil.getModeid("zcxx")));
			String capitalno= codeBuild.getModeCodeStr(Util.getIntValue( Cpt4modeUtil.getFormid(Cpt4modeUtil.getModeid("zcxx"))), cptbillid);
			rs2.executeSql("insert into uf_CptUseInfo(formmodeid,modedatacreater,modedatacreatertype,modedatacreatedate,modedatacreatetime) values('"+Util.getIntValue(Cpt4modeUtil.getModeid("zcrk"))+"','"+checkerid+"','0','"+currentdate+"','"+currenttime+"') ");
			rs2.executeSql("select max(id) as id from uf_CptUseInfo");
			rs2.next();
			int uselogid = Util.getIntValue(rs2.getString("id"),0);
			inprice = inprice.multiply(new BigDecimal(""+innumber));
			String sql22=" insert into uf_CptUseInfo_dt1(mainid,Usedate,capitalid,usecount,useaddress,usestatus,capitalno,capitalspec,remark,fee) "+
							" values('"+uselogid+"','"+stockindate+"','"+cptbillid+"','"+Util.getDoubleValue(""+innumber,0.0)+"','"+location+"','0','"+capitalno+"','"+capitalspec+"','','"+inprice.doubleValue()+"') ";
			rs2.executeSql(sql22);
			//bb.writeLog("tagtag instockuselog:"+sql22);
			//插入权限
			modeRightInfo.editModeDataShare(checkerid, Util.getIntValue( Cpt4modeUtil.getModeid("zcrk")), uselogid);
		}
	}
	rs2.executeSql("update uf_CptStockIn set ischecked='1' where id="+billid);//验收
    
    
}
}

}

//bb.writeLog("tagtag end batchcptinstock4mode...");
%>
<script type="text/javascript">
try{
	var parentWin=parent.getParentWindow(window);
	parentWin._table.reLoad();
	parentWin.closeDlgARfsh(0); 
}catch(e){
	var parentWin=parent.parent.getParentWindow(window);
	parentWin.closeDlgARfsh(0);
}


</script>

