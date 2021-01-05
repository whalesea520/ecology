
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.CrmShareBase"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="java.io.File"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<%
char flag = 2;
String CustomerID = Util.null2String(request.getParameter("CustomerID"));
String TypeID = Util.null2String(request.getParameter("TypeID"));
String CurrentUser = ""+user.getUID();
String ClientIP = request.getRemoteAddr();
String SubmiterType = ""+user.getLogintype();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

String method = Util.null2String(request.getParameter("method"));
String ProcPara = "";

if(method.equals("add")){
	
	ProcPara = CustomerID;
	ProcPara += flag+"ma";
	ProcPara += flag+"0";
	ProcPara += flag+"";
	ProcPara += flag+CurrentDate;
	ProcPara += flag+CurrentTime;
	ProcPara += flag+CurrentUser;
	ProcPara += flag+SubmiterType;
	ProcPara += flag+ClientIP;
	RecordSet.executeProc("CRM_Log_Insert",ProcPara);
	
	
	String sql = "select fieldhtmltype ,type,fieldname from CRM_CustomerDefinField "+
	" where usetable = 'CRM_CustomerAddress' and isopen = 1 ";
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
		 if(RecordSet.getInt("fieldhtmltype")== 1 && RecordSet.getInt("type")== 3){//浮点数
			 fieldValue = fieldValue.equals("")?"0":fieldValue;
		 }
		
		 fieldSql += fieldName+",";
		 valueSql += "'"+fieldValue+"',";
	}
	
	String city=Util.fromScreen3(request.getParameter("city"),user.getLanguage());
	String province = "0";
	String country = "0";
	if(!"".equals(city)){
		province =CityComInfo.getCityprovinceid(city);
		country = CityComInfo.getCitycountryid(city);
	}
	
	fieldSql += "typeid,customerid,isequal,country,province";
	valueSql += TypeID+","+CustomerID+",0,'"+country+"',"+province;
	sql = "insert into CRM_CustomerAddress("+fieldSql+") values ("+valueSql+")";
	RecordSet.execute(sql);
	
	out.println("<script>parent.getParentWindow(window).callback()</script>");
}

//编辑地址信息字段
if("edit_address_field".equals(method)){
	String addressid = Util.fromScreen3(request.getParameter("addressid"),user.getLanguage());
	String customerid = "";
	rs.executeSql("select customerid , typeid from CRM_CustomerAddress where id="+addressid);
	if (rs.next()) {
		customerid = rs.getString("customerid");
		TypeID = rs.getString("typeid");
		//判断是否有编辑该客户权限
		if(!checkRight(customerid,"",user.getUID()+"",2)) return;
	}else{
		return;
	}
	String fieldName = URLDecoder.decode(Util.fromScreen3(request.getParameter("fieldname"),user.getLanguage()),"utf-8");
	String oldvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("oldvalue")),"utf-8"));
	String newvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("newvalue")),"utf-8"));
	String fieldtype = Util.fromScreen3(request.getParameter("fieldtype"),user.getLanguage());
	
	String delvalue = Util.convertInput2DB(URLDecoder.decode(Util.null2String(request.getParameter("delvalue")),"utf-8"));
	
	String sql = "";
	if(fieldtype.equals("attachment")){
		rs.execute("select "+fieldName+" from CRM_CustomerAddress where id = "+addressid);
		rs.next();
		String att = rs.getString(1);
		if(att.equals(delvalue)){
			att = "";
		}else{
			att = (","+att+",").replace((","+delvalue+","), "");
			att = att.indexOf(",")==0?att.substring(1):att;
			att = att.lastIndexOf(",")==att.length()-1?att.substring(0,att.length()-1):att;
		}
		rs.execute("update CRM_CustomerAddress set "+fieldName+" = '"+att +"' where id = "+customerid);
		rs.execute("select filerealpath from ImageFile where imagefileid = "+delvalue);
		while(rs.next()){
			File file = new File(rs.getString("filerealpath"));
			if(file.exists()) file.delete();
		}
		rs.execute("delete from ImageFile where imagefileid = "+delvalue);
		
	}else{
		sql = "update CRM_CustomerAddress set "+fieldName+"='"+newvalue+"' where id="+addressid;
	}
	rs.executeSql(sql);
	
	
	rs.execute("select fieldlabel from CRM_CustomerDefinField where usetable = 'CRM_CustomerAddress' and fieldname = '"+fieldName+"'");
	rs.next();
	String labelName = SystemEnv.getHtmlLabelName(rs.getInt("fieldlabel"),user.getLanguage());
	
	ProcPara = customerid+flag+"3"+flag+TypeID+flag+"0";
	ProcPara += flag+labelName+flag+CurrentDate+flag+CurrentTime+flag+oldvalue+flag+newvalue;
	ProcPara += flag+CurrentUser+flag+SubmiterType+flag+ClientIP;
	RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
}

if("deleteInfo".equals(method)){
	String ids = Util.null2String(request.getParameter("ids"));
	if(!"".equals(ids)){
		rs.execute("delete from CRM_CustomerAddress where id in ("+ids+")");
	}
	
}
%>

<%!
private boolean checkRight(String customerid,String contacterid,String userid,int level) throws Exception{
	CrmShareBase crmShareBase = new CrmShareBase();
	RecordSet rs = new RecordSet();
	if(!"".equals(contacterid)){
		rs.executeSql("select t.customerid from CRM_CustomerContacter t where t.id="+contacterid);
		if(rs.next()) customerid = Util.null2String(rs.getString(1)); 
	}
	if(!customerid.equals("")){
		//判断此客户是否存在
		rs.executeProc("CRM_CustomerInfo_SelectByID",customerid);
		if(!rs.next()){
			return false;
		}
		int sharelevel = crmShareBase.getRightLevelForCRM(userid,customerid);
		if(level==1){
			//判断是否有查看该客户商机权限
			if(sharelevel<1){
				return false;
			}
		}else{
			//判断是否有编辑该客户商机权限
			if(sharelevel<2){
				return false;
			}
			if(rs.getInt("status")==7 || rs.getInt("status")==8 || rs.getInt("status")==10){
				return false;
			}
		}
		return true;
	}
	return false;
}
%>
