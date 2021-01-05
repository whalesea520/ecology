
<%@page import="weaver.cpt.job.CptLowInventoryRemindJob"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.*" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetInner" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CodeBuild" class="weaver.system.code.CodeBuild" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>

<%

String isbatch = Util.null2String (request.getParameter("isbatch"));
String Ids = Util.null2String(request.getParameter("id"));
String BuyerID = Util.null2String(request.getParameter("BuyerID"));
String supplierid = Util.null2String(request.getParameter("customerid"));
String checkerid = Util.null2String(request.getParameter("CheckerID"));
String stockindate = Util.null2String(request.getParameter("StockInDate"));
int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);
String departmentid = "" + Util.getIntValue(request.getParameter("CptDept_to"),0);  //入库部门

JSONObject jsonObject=new JSONObject();
String[] idArr=Ids.split(",");
for(int k=0;k<idArr.length;k++){
	String Id= idArr[k];
	RecordSet.executeSql("select stockindate,buyerid,checkerid from CptStockInMain where id="+Id);
	if(RecordSet.next()){
		stockindate=RecordSet.getString("stockindate");
		if("1".equals(isbatch)){
			BuyerID=RecordSet.getString("buyerid");
			checkerid=RecordSet.getString("checkerid");
		}
	}
	
    String detailid="";
	String mainid="";
	String cpttype="";
	String innumber="";
	String price="";
    String customerid="";
    String capitalspec="";
    String location="";
    String Invoice="";
	String sptcount1="";
	String contractno="";
	int i=0;
	int j=0;
	int v=0;
for (i=0;i<totaldetail;i++){
	detailid =request.getParameter("node_"+i+"_id");
	mainid =Util.null2String( request.getParameter("node_"+i+"_mainid"));
	
	if(!mainid.equals(Id)) continue;
	cpttype = request.getParameter("node_"+i+"_cptid");
	innumber = request.getParameter("node_"+i+"_innumber");
	price = request.getParameter("node_"+i+"_unitprice");
    customerid = request.getParameter("node_"+i+"_customerid");
    capitalspec = request.getParameter("node_"+i+"_capitalspec");
    location = request.getParameter("node_"+i+"_location");
    Invoice = request.getParameter("node_"+i+"_Invoice");
	contractno = request.getParameter("node_"+i+"_contractno");
    String tempselectdate=request.getParameter("node_"+i+"_stockindate");
    
    String capitalgroupid1 = "";
    String capitaltypeid1 = "";
	RecordSetInner.executeProc("CptCapital_SelectByID",cpttype);
    if(RecordSetInner.next()){
    	sptcount1 = RecordSetInner.getString("sptcount");
    	capitalgroupid1 = RecordSetInner.getString("capitalgroupid");
		capitaltypeid1 = RecordSetInner.getString("capitaltypeid");
    }
    RecordSetInner.executeSql("select * from CptStockInDetail where id ="+detailid);
    String selectdate1 = "";
    if(RecordSetInner.next()){	
    	selectdate1 = RecordSetInner.getString("selectdate");
    }

	if(sptcount1.equals("1")){ 	
		
		int numt = (int)Util.getDoubleValue(innumber, 0.0);
		
		String isover = CodeBuild.getCurrentCapitalCodeIsOver(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid1,capitaltypeid1,selectdate1,stockindate,cpttype,numt);		
		
		if("yes".equals(isover)){
			
			RecordSetInner.executeSql("select name from cptcapital where id ="+cpttype);
			RecordSetInner.next();
			String cptname = RecordSetInner.getString(1);
			
			jsonObject.put("msg1","yes");
			jsonObject.put("msg2",cptname+" 流水号位数已超过使用限制,请重新设置编码规则");		
			
			break;
            
		}else{	
			jsonObject.put("msg1","no");			
		}
		
		
	}else{  
		String isover = CodeBuild.getCurrentCapitalCodeIsOver(DepartmentComInfo.getSubcompanyid1(departmentid),departmentid,capitalgroupid1,capitaltypeid1,selectdate1,stockindate,cpttype,1);	
		if("yes".equals(isover)){			
			RecordSetInner.executeSql("select name from cptcapital where id ="+cpttype);
			RecordSetInner.next();
			String cptname = RecordSetInner.getString(1);			
			jsonObject.put("msg1","yes");
			jsonObject.put("msg2",cptname+" 流水号位数已超过使用限制,请重新设置编码规则");	
			break;
		}else{			
			jsonObject.put("msg1","no");			
		}   
		
	}
	
}
}

out.print(jsonObject.toString());
%>
