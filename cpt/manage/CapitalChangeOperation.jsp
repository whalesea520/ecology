<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="com.weaver.formmodel.util.DateHelper" %>
<%@ page import="weaver.cpt.util.CptUtil" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="capitalAssortmentComInfo" class="weaver.cpt.maintenance.CapitalAssortmentComInfo" scope="page" />
<jsp:useBean id="capitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="CptShare" class="weaver.cpt.capital.CptShare" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("CptCapital:Change", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String currentdate = DateHelper.getCurrentDate();
char separator = Util.getSeparator() ;
int userid = user.getUID();

String dtinfo = Util.null2String(request.getParameter("dtinfo"));
dtinfo= dtinfo.replaceAll("_[0-9]*\":\"", "\":\"");
//System.out.println("dtinfo:"+dtinfo);
JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
if(dtJsonArray!=null&&dtJsonArray.size()>0){
	for(int i=0;i<dtJsonArray.size();i++){
		JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
		if(dtJsonArray2!=null){
			String capitalid = dtJsonArray2.getJSONObject(10).getString("capitalid");
			String mark = dtJsonArray2.getJSONObject(1).getString("mark");
			String capitalgroupid = dtJsonArray2.getJSONObject(11).getString("capitalgroupid");
			String resourceid = dtJsonArray2.getJSONObject(12).getString("resourceid");
			String departmentid = resourceComInfo.getDepartmentID(resourceid);
			String capitalspec = dtJsonArray2.getJSONObject(4).getString("capitalspec");
			String stockindate = dtJsonArray2.getJSONObject(13).getString("stockindate");
			String location = dtJsonArray2.getJSONObject(5).getString("location");
			double startprice = Util.getDoubleValue(dtJsonArray2.getJSONObject(6).getString("startprice"),0.0);
			double capitalnum = Util.getDoubleValue(dtJsonArray2.getJSONObject(7).getString("capitalnum"),0.0);
			String blongdepartment = dtJsonArray2.getJSONObject(14).getString("blongdepartment");
			String blongsubcompany = departmentComInfo.getSubcompanyid1(blongdepartment);
			String remark = dtJsonArray2.getJSONObject(9).getString("remark");
			
			rs.executeSql("select sptcount,stateid,resourceid,departmentid,capitalgroupid,capitalnum,mark,location,capitaltypeid," +
					  "capitalspec,StockInDate,startprice,blongsubcompany,blongdepartment from cptcapital where id='"+capitalid+"' and isdata=2");
			if (!rs.next()) return;
			String sptcount = rs.getString("sptcount");
			String stateid = Util.null2String(rs.getString("stateid"),"1");
			String resourceidO = rs.getString("resourceid");
			String departmentidO = rs.getString("departmentid");
			String capitalgroupidO = rs.getString("capitalgroupid");
			double capitalnumO = Util.getDoubleValue(rs.getString("capitalnum"),0.0);
			String markO = rs.getString("mark");
			String locationO = rs.getString("location");
			//String capitaltypeidO = rs.getString("capitaltypeid");
			String capitalspecO = rs.getString("capitalspec");
			String StockInDateO = rs.getString("StockInDate");
			double startpriceO = Util.getDoubleValue(rs.getString("startprice"),0.0);
			String blongsubcompanyO = rs.getString("blongsubcompany");
			String blongdepartmentO = rs.getString("blongdepartment");
			if ("1".equals(sptcount)) { //如果是单独核算的资产，默认数量为1
				capitalnum = 1.0;
			}
			String modifypara = "";
			
			String sql = "update cptcapital set ";
			if (!"".equals(resourceid) && "1".equals(sptcount) && !"1".equals(stateid) && !"5".equals(stateid) && !"-7".equals(stateid)) {
				sql += "resourceid='"+resourceid+"',departmentid='"+departmentid+"',";
				if (!resourceid.equals(resourceidO)) {
					modifypara = capitalid;
					modifypara += separator+"6";
					modifypara += separator+resourceComInfo.getResourcename(resourceidO);
					modifypara += separator+resourceComInfo.getResourcename(resourceid);
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
				if (!departmentid.equals(departmentidO)) {
					modifypara = capitalid;
					modifypara += separator+"82";
					modifypara += separator+departmentComInfo.getDepartmentName(departmentidO);
					modifypara += separator+departmentComInfo.getDepartmentName(departmentid);
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (!"".equals(capitalgroupid)) {
				sql += "capitalgroupid='"+capitalgroupid+"',";
				if (!capitalgroupid.equals(capitalgroupidO)) {
					modifypara = capitalid;
					modifypara += separator+"16";
					modifypara += separator+capitalAssortmentComInfo.getAssortmentName(capitalgroupidO);
					modifypara += separator+capitalAssortmentComInfo.getAssortmentName(capitalgroupid);
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (capitalnum != 0.0) {
				sql += "capitalnum='"+capitalnum+"',";
				if (capitalnum!=capitalnumO) {
					modifypara = capitalid;
					modifypara += separator+"78";
					modifypara += separator+""+capitalnumO;
					modifypara += separator+""+capitalnum;
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (!"".equals(mark) && !CptUtil.checkmarkstr(mark)) {
				sql += "mark='"+mark+"',";
				if (!mark.equals(markO)) {
					modifypara = capitalid;
					modifypara += separator+"77";
					modifypara += separator+markO;
					modifypara += separator+mark;
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			}  
			if (!"".equals(location)) {
				sql += "location='"+location+"',";
				if (!location.equals(locationO)) {
					modifypara = capitalid;
					modifypara += separator+"20";
					modifypara += separator+locationO;
					modifypara += separator+location;
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (!"".equals(capitalspec)) {
				sql += "capitalspec='"+capitalspec+"',";
				if (!capitalspec.equals(capitalspecO)) {
					modifypara = capitalid;
					modifypara += separator+"11";
					modifypara += separator+capitalspecO;
					modifypara += separator+capitalspec;
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (!"".equals(stockindate)) {
				sql += "StockInDate='"+stockindate+"',";
				if (!stockindate.equals(StockInDateO)) {
					modifypara = capitalid;
					modifypara += separator+"79";
					modifypara += separator+StockInDateO;
					modifypara += separator+stockindate;
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (startprice != 0.0) {
				sql += "startprice='"+startprice+"',";
				if (startprice != startpriceO) {
					modifypara = capitalid;
					modifypara += separator+"9";
					modifypara += separator+""+startpriceO;
					modifypara += separator+""+startprice;
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			} 
			if (!"".equals(blongsubcompany)) {
				sql += "blongsubcompany='"+blongsubcompany+"',blongdepartment='"+blongdepartment+"',";
				if (!blongsubcompany.equals(blongsubcompanyO)) {
					modifypara = capitalid;
					modifypara += separator+"80";
					modifypara += separator+subCompanyComInfo.getSubCompanyname(blongsubcompanyO);
					modifypara += separator+subCompanyComInfo.getSubCompanyname(blongsubcompany);
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
				if (!blongdepartment.equals(blongdepartmentO)) {
					modifypara = capitalid;
					modifypara += separator+"81";
					modifypara += separator+departmentComInfo.getDepartmentName(blongdepartmentO);
					modifypara += separator+departmentComInfo.getDepartmentName(blongdepartment);
					modifypara += separator+""+userid;
					modifypara += separator+currentdate;
					rs.executeProc("CptCapitalModify_Insert",modifypara) ;
				}
			}
			sql += "name=name where id='"+capitalid+"'";
			rs.executeSql(sql);
			
			sql = "insert into CptUseLog(capitalid,usedate,userequest,useresourceid,usestatus,remark,resourceid) values(";
			sql += "'"+capitalid+"','"+currentdate+"','','-1','7','"+remark+"','"+userid+"'";
			sql += ")";
			rs.executeSql(sql);
			//资产组变的时候改资产组
			if (!"".equals(capitalgroupid)) {
				if (!capitalgroupid.equals(capitalgroupidO)) {
					CptShare.freshenCptShareByCapitalgroup(capitalid);
				}
			}
			//使用人变的时候改使用人
			if (!"".equals(resourceid) && "1".equals(sptcount) && !"1".equals(stateid) && !"5".equals(stateid) && !"-7".equals(stateid)) {
				if (!resourceid.equals(resourceidO)) {
					CptShare.freshenCptShareByResource(capitalid);
				}
			}
		}
	}
}
response.sendRedirect("/cpt/manage/CptCapitalChangeTab.jsp"); 
 
%>

