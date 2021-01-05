<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>

<%
User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
if(!(HrmUserVarify.checkUserRight("CptCapital:InStockCheck", user)||HrmUserVarify.checkUserRight("CptCapital:InStock", user) )){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
}
String Id = Util.fromScreen(request.getParameter("id"),user.getLanguage());
String contactno = Util.fromScreen(request.getParameter("contactno"),user.getLanguage());
String BuyerID = Util.fromScreen(request.getParameter("BuyerID"),user.getLanguage());
String customerid = Util.fromScreen(request.getParameter("customerid"),user.getLanguage());
String CheckerID = Util.fromScreen(request.getParameter("CheckerID"),user.getLanguage());
String StockInDate_gz = Util.fromScreen(request.getParameter("StockInDate_gz"),user.getLanguage());
String StockInDate = Util.fromScreen(request.getParameter("StockInDate"),user.getLanguage());
String Method = Util.fromScreen(request.getParameter("method"),user.getLanguage());
int totaldetail = Util.getIntValue(request.getParameter("totaldetail"),0);


char separator = Util.getSeparator() ;
String para = "";
String sql = "";

if (Method.equals("add")) {

    para = contactno;
    para +=separator+BuyerID;
    para +=separator+customerid;
    para +=separator+CheckerID;
    para +=separator+StockInDate;
	para +=separator+"0";
    RecordSet.executeProc("CptStockInMain_Insert",para);

	RecordSet.next();
	String cptstockinid=""+RecordSet.getInt(1);
	String cpttype="";
	String plannumber="";
	String price="";
    String Invoice="";
    String customerid_dtl="";
    String StockInDate_dtl="";
    String capitalspec="";
    String location="";
	String contractno="";//合同号

	int i=0;
	
	String dtinfo = Util.null2String(request.getParameter("dtinfo")).replaceAll("`#weaver#`", "\\\\\\\\");
	dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		for(i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=6){
				capitalspec= dtJsonArray2.getJSONObject(1).getString("capitalspec");
				price= dtJsonArray2.getJSONObject(2).getString("price");
				plannumber= dtJsonArray2.getJSONObject(3).getString("capitalnum");
				Invoice= dtJsonArray2.getJSONObject(4).getString("invoice");
				location= dtJsonArray2.getJSONObject(5).getString("location");
				cpttype= dtJsonArray2.getJSONObject(6).getString("capitalid");
				customerid_dtl=customerid;
				StockInDate_dtl=StockInDate_gz;
				contractno=contactno;
				
				if(!cpttype.equals("")){
					para = cptstockinid;
					para +=separator+cpttype;
					para +=separator+plannumber;
					para +=separator+"0";
					para +=separator+price;
			        para +=separator+customerid_dtl;
			        para +=separator+StockInDate_dtl;
			        para +=separator+capitalspec;
			        para +=separator+location;
			        para +=separator+Invoice;
					RecordSet.executeProc("CptStockInDetail_Insert",para);
					if(RecordSet.next()){
						String detailid = Util.null2String(RecordSet.getString(1));
						if(!detailid.equals("")&&!detailid.equals("0")){
							RecordSet.executeSql("update CptStockInDetail set contractno = '" + contractno + "' where id = " + detailid);
						}			
					}
			     }
			}
		}
	}  
	PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue(CheckerID),11,"0",Util.getIntValue(cptstockinid),"",1);

    String reapplyflag=Util.null2String(request.getParameter("reapplyflag"));
    String respurl="CptCapitalInstock1tab.jsp";
    if("1".equals(reapplyflag)){
    	respurl="CptCapitalInstock1tab.jsp?isclose=1&isdialog=1";
    }
    response.sendRedirect(respurl);

}else if (Method.equals("edit")) {//编辑收回的入库单


    RecordSet.executeSql("update CptStockInMain set ischecked=0,buyerid='"+BuyerID+"',checkerid='"+CheckerID+"',invoice='"+contactno+"',stockindate='"+StockInDate+"' where id="+Id);
    RecordSet.executeSql("delete CptStockInDetail where cptstockinid="+Id);

	String cptstockinid=""+Id;
	String cpttype="";
	String plannumber="";
	String price="";
    String Invoice="";
    String customerid_dtl="";
    String StockInDate_dtl="";
    String capitalspec="";
    String location="";
	String contractno="";//合同号

	int i=0;
	
	String dtinfo = Util.null2String(request.getParameter("dtinfo")).replaceAll("`#weaver#`", "\\\\\\\\");
	dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
	//System.out.println("dtinfo:"+dtinfo);
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		for(i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=6){
				capitalspec= dtJsonArray2.getJSONObject(1).getString("capitalspec");
				price= dtJsonArray2.getJSONObject(2).getString("price");
				plannumber= dtJsonArray2.getJSONObject(3).getString("capitalnum");
				Invoice= dtJsonArray2.getJSONObject(4).getString("invoice");
				location= dtJsonArray2.getJSONObject(5).getString("location");
				cpttype= dtJsonArray2.getJSONObject(6).getString("capitalid");
				customerid_dtl=customerid;
				StockInDate_dtl=StockInDate_gz;
				contractno=contactno;
				
				if(!cpttype.equals("")){
					para = cptstockinid;
					para +=separator+cpttype;
					para +=separator+plannumber;
					para +=separator+"0";
					para +=separator+price;
			        para +=separator+customerid_dtl;
			        para +=separator+StockInDate_dtl;
			        para +=separator+capitalspec;
			        para +=separator+location;
			        para +=separator+Invoice;
					RecordSet.executeProc("CptStockInDetail_Insert",para);
					if(RecordSet.next()){
						String detailid = Util.null2String(RecordSet.getString(1));
						if(!detailid.equals("")&&!detailid.equals("0")){
							RecordSet.executeSql("update CptStockInDetail set contractno = '" + contractno + "' where id = " + detailid);
						}			
					}
			     }
			}
		}
	}
    PoppupRemindInfoUtil.insertPoppupRemindInfo(Util.getIntValue(CheckerID),11,"0",Util.getIntValue(cptstockinid));

	response.sendRedirect("CptCapitalInstock1tab.jsp?isclose=1&isdialog=1");

}


else if (Method.equals("delete")) {
	sql = "update CptStockInMain set ischecked = -1 where id = " + Id ;
	RecordSet.executeSql(sql);
	int checkerid=user.getUID();
	sql="select checkerid from CptStockInMain where id="+Id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		checkerid=Util.getIntValue( RecordSet.getString("checkerid"));
	}
	
    PoppupRemindInfoUtil.updatePoppupRemindInfo(checkerid,11,"0",Util.getIntValue(Id));
	response.sendRedirect("/cpt/search/CptInstockSearchTab.jsp");
	
}else if (Method.equals("reject")) {//收回待验入库单
	sql = "update CptStockInMain set ischecked = -2 where id = " + Id ;
	RecordSet.executeSql(sql);
	int checkerid=user.getUID();
	sql="select checkerid from CptStockInMain where id="+Id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		checkerid=Util.getIntValue( RecordSet.getString("checkerid"));
	}
	
    PoppupRemindInfoUtil.updatePoppupRemindInfo(checkerid,11,"0",Util.getIntValue(Id));
	//response.sendRedirect("/cpt/search/CptInstockSearchTab.jsp");
	return;
	
}else if (Method.equals("loaddetaildata")) {
	String from = Util.null2String(request.getParameter("from"));
	
	JSONArray arr=new JSONArray();
	if(Util.getIntValue(Id,0)>0){
		sql = "select * from CptStockInDetail where cptstockinid=" + Id+" order by id " ;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			JSONArray jsonArray=new JSONArray();
			JSONObject jsonObject=new JSONObject();
			
			jsonObject.put("name", "capitalid");
			jsonObject.put("value", Util.null2String(RecordSet.getString("cpttype") ));
			jsonObject.put("label", CapitalComInfo.getCapitalname(Util.null2String(RecordSet.getString("cpttype") )));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "browser");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "capitalspec");
			jsonObject.put("value", Util.null2String(RecordSet.getString("capitalspec") ));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "input");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "price");
			jsonObject.put("value", Util.null2String(RecordSet.getString("price") ));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "input");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "capitalnum");
			jsonObject.put("value", Util.null2String(RecordSet.getString("plannumber") ));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "input");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "invoice");
			jsonObject.put("value", Util.null2String(RecordSet.getString("invoice") ));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "input");
			jsonArray.add(jsonObject);
			
			jsonObject=new JSONObject();
			jsonObject.put("name", "location");
			jsonObject.put("value", Util.null2String(RecordSet.getString("location") ));
			jsonObject.put("iseditable", true);
			jsonObject.put("type", "input");
			jsonArray.add(jsonObject);
			
			arr.add(jsonArray);
		}
	}else if("cptalertsearch".equalsIgnoreCase(from) ){//低库存预警入口的入库
		String type = Util.null2String(request.getParameter("type"));
		String applyid = Util.null2String(request.getParameter("applyid"));
		if(!"".equals(applyid)){
			if(applyid.startsWith(",")){
				applyid=applyid.substring(1);
			}
			if(applyid.endsWith(",")){
				applyid=applyid.substring(0,applyid.length()-1);
			}
			sql="select * from cptcapital where id in ( select distinct t2.datatype from cptcapital t2 where t2.id in ("+applyid+") ) ";
			RecordSet.executeSql(sql);
			while(RecordSet.next()){
				
				JSONArray jsonArray=new JSONArray();
				JSONObject jsonObject=new JSONObject();
				
				jsonObject.put("name", "capitalid");
				jsonObject.put("value", Util.null2String(RecordSet.getString("id") ));
				jsonObject.put("label", CapitalComInfo.getCapitalname(Util.null2String(RecordSet.getString("id") )));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "browser");
				jsonArray.add(jsonObject);
				
				jsonObject=new JSONObject();
				jsonObject.put("name", "capitalspec");
				jsonObject.put("value", Util.null2String(RecordSet.getString("capitalspec") ));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "input");
				jsonArray.add(jsonObject);
				
				jsonObject=new JSONObject();
				jsonObject.put("name", "price");
				jsonObject.put("value", Util.null2String(RecordSet.getString("startprice") ));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "input");
				jsonArray.add(jsonObject);
				
				jsonObject=new JSONObject();
				jsonObject.put("name", "capitalnum");
				jsonObject.put("value", Util.null2String(""));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "input");
				jsonArray.add(jsonObject);
				
				jsonObject=new JSONObject();
				jsonObject.put("name", "invoice");
				jsonObject.put("value", Util.null2String("" ));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "input");
				jsonArray.add(jsonObject);
				
				jsonObject=new JSONObject();
				jsonObject.put("name", "location");
				jsonObject.put("value", Util.null2String("" ));
				jsonObject.put("iseditable", true);
				jsonObject.put("type", "input");
				jsonArray.add(jsonObject);
				
				arr.add(jsonArray);
				
			}
			
			
		}
	}
	
	out.print(arr.toString());
}else if (Method.equals("checkstate")) {
	JSONObject jsonObject=new JSONObject();
	boolean success=true;
	String[] checkids=Util.TokenizerString2( Util.null2String( request.getParameter("checkstateids")),",");
	if(checkids!=null&&checkids.length>0){
		for(int k=0;k<checkids.length;k++){
			sql = "select ischecked from CptStockInMain where id=" + checkids[k]+" and ischecked='-2' " ;
			RecordSet.executeSql(sql);
			if(RecordSet.next()){
				success=false;
				break;
			}
		}
	}
	jsonObject.put("msg", ""+success);
	out.print(jsonObject.toString());
}
%>
