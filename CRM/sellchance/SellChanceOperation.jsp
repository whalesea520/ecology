
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.io.File"%>
<%@page import="java.net.URLDecoder"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SysRemindWorkflow" class="weaver.system.SysRemindWorkflow" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<%
char flag=2;
String para="";
String method = request.getParameter("method");
User user = HrmUserVarify.getUser (request , response) ;
String chanceid = Util.null2String(request.getParameter("chanceid"));//当edit和delete时候有值
String subject = request.getParameter("subject");
String Creater = Util.null2String(request.getParameter("Creater"));
String CustomerID = Util.null2String(request.getParameter("customer"));
String Comefrom =Util.null2String(request.getParameter("Comefrom"));
String sellstatusid =Util.null2String(request.getParameter("sellstatusid"));
String endtatusid =Util.null2String(request.getParameter("endtatusid"));
String preselldate =Util.null2String(request.getParameter("preselldate"));
String preyield =Util.null2String(request.getParameter("preyield"));
String probability =Util.null2String(request.getParameter("probability"));
String content =Util.null2String(request.getParameter("Agent"));
String isfromtab  = Util.null2String(request.getParameter("isfromtab"),"false");
if(content.trim().equals(""))content="0";

String sufactorid =Util.null2String(request.getParameter("sufactorid"));//成功关键因素
String defactorid =Util.null2String(request.getParameter("defactorid"));//失败关键因素

String departmentId = ResourceComInfo.getDepartmentID(Creater);//客户经理的部门ID
String subCompanyId = DepartmentComInfo.getSubcompanyid1(departmentId);//客户经理的分部ID

String currencyid="";
if(preyield.equals("")) preyield="0";
if(probability.equals("")) probability="0";
int rownum = Util.getIntValue(request.getParameter("rownum"),user.getLanguage()) ;//行数

Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
Calendar now = Calendar.getInstance();
String currenttime = Util.add0(now.getTime().getHours(), 2) +":"+
                     Util.add0(now.getTime().getMinutes(), 2) +":"+
                     Util.add0(now.getTime().getSeconds(), 2) ;

 
//以下是给相应的人员触发工作流
/*=================================================*/
String CurrentUser = ""+user.getUID();
String CurrentUserName = ""+user.getUsername();


String SWFAccepter="";
String SWFTitle="";
String SWFRemark="";
String SWFSubmiter="";
String Subject="";

String thesql="select managerid from HrmResource where id = "+CurrentUser;
RecordSetM.executeSql(thesql);
RecordSetM.next();
String managerid=RecordSetM.getString("managerid"); //通知上级
/*================================================*/
if(method.equals("add")){
	
	
    if(rownum==0){
        currencyid = "1";
    }//货币单位默认为"1"
    else{
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+0),user.getLanguage());
    }//通过第一行的货币单位来设置货币单位
	    
	String sql = "select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField "+
	" where usetable = 'CRM_SellChance' and isopen = 1 ";
	RecordSet.execute(sql);
	if(0 == RecordSet.getCounts()){
		out.println("<script>parent.getParentWindow(window).callback()</script>");
		return;
	}
	
	String fieldSql = "";
	String valueSql = "";
	while(RecordSet.next()){
		 String fieldName= RecordSet.getString("fieldname");
		 String fieldValue = Util.null2String(request.getParameter(fieldName));
		 if(fieldName.equals("subject")) subject = fieldValue;		 
		 if(RecordSet.getInt("fieldhtmltype")== 1 && RecordSet.getInt("type")== 3){//浮点数
			 fieldValue = fieldValue.equals("")?"0":fieldValue;
		 }
		
		 fieldSql += fieldName+",";
		 valueSql += "'"+fieldValue+"',";
	}
	
	
	fieldSql += "endtatusid,currencyid,createdate,createtime,departmentId,subCompanyId";
	valueSql += "0,'"+currencyid+"','"+currentdate+"','"+currenttime+"','"+departmentId+"','"+subCompanyId+"'";
	sql = "insert into CRM_SellChance("+fieldSql+") values ("+valueSql+")";
	RecordSet.execute(sql);
   
    rs.executeProc("CRM_SellChance_SMAXID","");  
    rs.next();
    String sellchanceid = rs.getString("sellchanceid");

    if(!sellchanceid.equals("0")){    
        for(int i = 0;i<rownum;i++){
        String productid = Util.fromScreen(request.getParameter("productname_"+i),user.getLanguage());
        String assetunitid = Util.fromScreen(request.getParameter("assetunitid_"+i),user.getLanguage());
               currencyid = Util.fromScreen(request.getParameter("currencyid_"+i),user.getLanguage());
        String salesprice = Util.fromScreen(request.getParameter("salesprice_"+i),user.getLanguage());
        String salesnum = Util.fromScreen(request.getParameter("number_"+i),user.getLanguage());
        String totelprice =Util.fromScreen(request.getParameter("totelprice_"+i),user.getLanguage()); 
        String info = productid+assetunitid+currencyid+salesprice+salesnum+totelprice;
        if(!info.trim().equals("")){
        para = ""+sellchanceid+flag+productid+flag+assetunitid+flag+currencyid+flag+salesprice+flag+salesnum+flag+totelprice;
        rs.executeProc("CRM_ProductTable_insert",para);  
        }
        }
    }

if(!CurrentUser.equals(managerid)){//上级经理是本人，就不要触发工作流
	RecordSet.executeSql("select * from crm_customerSettings where id=-1");
	RecordSet.first();
	String Sell_addRemind=Util.null2String(RecordSet.getString("sell_rmd_create"));//是否开启创建客户提醒。             Y：开启，    N：关闭
	String Sell_addRemindTo=Util.null2String(RecordSet.getString("sell_rmd_create2"));//创建客户提醒对象。            1：直接上级，2：所有上级
	if("Y".equals(Sell_addRemind)){
		//通知客户提醒对象
		String operators = ResourceComInfo.getManagerID(CurrentUser);//默认提醒直接上级
		if("2".equals(Sell_addRemindTo))
			operators = ResourceComInfo.getManagersIDs(CurrentUser);
		/*添加客户销售机会触发工作流*/
	    Subject=SystemEnv.getHtmlLabelName(15249,user.getLanguage());
	    Subject+=":"+subject;
	
	    SWFAccepter=operators;
	    SWFTitle=SystemEnv.getHtmlLabelName(15249,user.getLanguage());
	    SWFTitle += ":"+subject;
	    SWFTitle += "-"+CurrentUserName;
	    SWFTitle += "-"+currentdate;
	    SWFRemark="<a href=/CRM/sellchance/ViewSellChance.jsp?id="+sellchanceid+"&CustomerID="+CustomerID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
	    SWFSubmiter=CurrentUser;
	
	    SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
		/*workflow _ end*/
	}
}
String target =Util.null2String(request.getParameter("target"));
if("fullwindow".equals(target)) {
	out.println("<script>window.close()</script>"); 
}else {
	out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
}  
return;
//response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID);
}


if(method.equals("edit")){
    if(rownum==0){
        currencyid = "1";
    }//货币单位默认为"1"
    else{
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+0),user.getLanguage());
    }//通过第一行的货币单位来设置货币单位
    rs.execute("update CRM_SellChance set currencyid = '"+currencyid+"' , preyield = '"+preyield+"' where id = "+chanceid);
    
    //对于产品表，先删除原先的，再做insert即可
    rs.executeProc("CRM_Product_Delete",chanceid);
    for(int i = 0;i<rownum;i++){
        String productid = Util.fromScreen(request.getParameter("productname_"+i),user.getLanguage());
        String assetunitid = Util.fromScreen(request.getParameter("assetunitid_"+i),user.getLanguage());
        currencyid = Util.fromScreen(request.getParameter("currencyid_"+i),user.getLanguage());
        String salesprice = Util.fromScreen(request.getParameter("salesprice_"+i),user.getLanguage());
        String salesnum = Util.fromScreen(request.getParameter("number_"+i),user.getLanguage());
        String totelprice =Util.fromScreen(request.getParameter("totelprice_"+i),user.getLanguage()); 
        String info = productid+assetunitid+currencyid+salesprice+salesnum+totelprice;
        if(!info.trim().equals("")){
	        para = ""+chanceid+flag+productid+flag+assetunitid+flag+currencyid+flag+salesprice+flag+salesnum+flag+totelprice;
	        rs.executeProc("CRM_ProductTable_insert",para);  
        }
    }


 if(isfromtab.equals("true")){
	response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?isfromtab="+isfromtab+"&needRefresh=true&id="+chanceid+"&CustomerID="+CustomerID);
 }else{
	 out.println("<script>parent.getParentWindow(window).closeDialog()</script>");
 }
}


//编辑地址信息字段
if("edit_sellchance_field".equals(method)){
	String fieldName = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
	String oldvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("oldvalue")),"utf-8"));
	String newvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("newvalue")),"utf-8"));
	String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
	
	String delvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("delvalue")),"utf-8"));
	
	String sql = "";
	if(fieldtype.equals("attachment")){
		rs.execute("select "+fieldName+" from CRM_SellChance where id = "+chanceid);
		rs.next();
		String att = rs.getString(1);
		if(att.equals(delvalue)){
			att = "";
		}else{
			att = (","+att+",").replace((","+delvalue+","), "");
			att = att.indexOf(",")==0?att.substring(1):att;
			att = att.lastIndexOf(",")==att.length()-1?att.substring(0,att.length()-1):att;
		}
		rs.execute("update CRM_SellChance set "+fieldName+" = '"+att +"' where id = "+chanceid);
		rs.execute("select filerealpath from ImageFile where imagefileid = "+delvalue);
		while(rs.next()){
			File file = new File(rs.getString("filerealpath"));
			if(file.exists()) file.delete();
		}
		rs.execute("delete from ImageFile where imagefileid = "+delvalue);
		
	}else{
		sql = "update CRM_SellChance set "+fieldName+"='"+newvalue+"' where id="+chanceid;
	}
	rs.executeSql(sql);
	
	if(!CurrentUser.equals(managerid)){//上级经理是本人，就不要触发工作流
		 /*编辑客户销售机会触发工作流*/
		  Subject=SystemEnv.getHtmlLabelName(15250,user.getLanguage());
		  Subject+=":"+subject;
	
		  SWFAccepter=managerid;
		  SWFTitle=SystemEnv.getHtmlLabelName(15250,user.getLanguage());
		  SWFTitle += ":"+subject;
		  SWFTitle += "-"+CurrentUserName;
		  SWFTitle += "-"+currentdate;
		     SWFRemark="<a href=/CRM/sellchance/ViewSellChance.jsp?id="+chanceid+"&CustomerID="+CustomerID+">"+Util.fromScreen2(Subject,user.getLanguage())+"</a>";
		     SWFSubmiter=CurrentUser;
		     SysRemindWorkflow.setCRMSysRemind(SWFTitle,Util.getIntValue(CustomerID),Util.getIntValue(SWFSubmiter),SWFAccepter,SWFRemark);	
		 /*workflow _ end*/    
  }
}

if(method.equals("del")){
    rs.executeProc("CRM_SellChance_Delete",chanceid);
    rs.executeProc("CRM_Product_Delete",chanceid);
//response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"");
    
}
if(method.equals("batchDel")){
	String chanceids =Util.null2String(request.getParameter("chanceids"));
	if(!"".equals(chanceids)){
		 chanceids = chanceids.substring(0,chanceids.length()-1);
		 rs.execute("delete from CRM_SellChance where id in ("+chanceids+")");
	     rs.execute("delete from CRM_ProductTable where sellchanceid in ("+chanceids+")");
	}
   
//response.sendRedirect("/CRM/sellchance/ListSellChance.jsp?CustomerID="+CustomerID+"");
    
}
if(method.equals("reopen")){
	String sqlStr = "Update CRM_SellChance set endtatusid = 0 where id = " + chanceid;
	RecordSet.executeSql(sqlStr);
response.sendRedirect("/CRM/sellchance/ViewSellChance.jsp?isfromtab="+isfromtab+"&id="+chanceid+"&CustomerID="+CustomerID);
}

if(method.equals("getProductInfo")){
	String productId = request.getParameter("productId");
	String sql = " SELECT t1.assetunitid,t2.currencyid , t2.salesprice "+
				 " FROM LgcAsset t1 , LgcAssetCountry t2"+
				 " WHERE t1.id = t2.assetid AND t2.id = "+productId;
	rs.execute(sql);
	rs.next();
	String assetunitid = Util.toScreen(rs.getString("assetunitid"),user.getLanguage());
	String assetunitname = Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage());
	currencyid = rs.getString("currencyid");
	String currencyname = Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage());
	String salesprice = rs.getString("salesprice");
	
	String info = "{'assetunitid':"+assetunitid+",'assetunitname':'"+assetunitname+"','currencyid':"+currencyid+",'currencyname':'"+currencyname+"','salesprice':"+salesprice+"}";
	
	Map map = new HashMap();
	map.put("assetunitid",assetunitid);
	map.put("assetunitname",assetunitname);
	map.put("currencyid",currencyid);
	map.put("currencyname",currencyname);
	map.put("salesprice",salesprice);
	out.println(info);
}
if(method.equals("markimportant")){//标记为重要
	String sellchanceId=Util.null2o(request.getParameter("sellchanceId"));
	String important=Util.null2o(request.getParameter("important"));
	String sql="insert into CRM_SellchanceAtt(resourceid,sellchanceid) values("+user.getUID()+","+sellchanceId+")";
	if(important.equals("1")){
		sql="delete from CRM_SellchanceAtt where resourceid="+user.getUID()+" and sellchanceid="+sellchanceId;
	}
	rs.execute(sql);
}

%>