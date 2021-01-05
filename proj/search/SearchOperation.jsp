<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.proj.util.PrjFieldComInfo"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<%
SearchComInfo1.resetSearchInfo();
int perpage = Util.getIntValue(request.getParameter("perpage"),10);
String msg=Util.null2String(request.getParameter("msg"));
String from=Util.null2String(request.getParameter("from"));
if(msg.equals("report")){
	String settype=Util.null2String(request.getParameter("settype"));	
	String id=Util.null2String(request.getParameter("id"));
	if(settype.equals("projecttype")){
		SearchComInfo1.setprjtype(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("worktype")){
		SearchComInfo1.setworktype(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("projectstatus")){
		SearchComInfo1.setstatus(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("manager")){
		SearchComInfo1.setmanager(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	if(settype.equals("department")){
		SearchComInfo1.setdepartment(id);
		response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
		return;
	}
	response.sendRedirect("/notice/noright.jsp");//返回到一个出错页面，待定义
	return;
}

String destination = Util.null2String(request.getParameter("destination"));

if(destination.equals("prjindept"))
{
	SearchComInfo1.setdepartment(Util.null2String(request.getParameter("depid")));
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
	return ;
}

if(destination.equals("myProject"))
{
	SearchComInfo1.setmanager("" + user.getUID());
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
	return ;
}

SearchComInfo1.setname(Util.null2String(request.getParameter("name")));
if("".equals(SearchComInfo1.getname())){
	SearchComInfo1.setname(Util.null2String(request.getParameter("flowTitle")));
}

if(destination.equals("QuickSearch"))
{
	response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage="+perpage);
	return ;
}

String prjtype=Util.null2String( request.getParameter("prjtype") );
String worktype=Util.null2String(request.getParameter("worktype"));
String status=Util.null2String(request.getParameter("status"));


SearchComInfo1.setprjtype(prjtype);
SearchComInfo1.setworktype(worktype);
SearchComInfo1.setstatus(status);
SearchComInfo1.setnameopt(Util.null2String(request.getParameter("nameopt")));
SearchComInfo1.setdescription(Util.null2String(request.getParameter("description")));
SearchComInfo1.setcustomer(Util.null2String(request.getParameter("customer")));
SearchComInfo1.setparent(Util.null2String(request.getParameter("parent")));
SearchComInfo1.setsecurelevel(Util.null2String(request.getParameter("securelevel")));
SearchComInfo1.setdepartment(Util.null2String(request.getParameter("department")));
SearchComInfo1.setmanager(Util.null2String(request.getParameter("manager")));
SearchComInfo1.setmember(Util.null2String(request.getParameter("member")));
SearchComInfo1.setProcode(Util.null2String(request.getParameter("procode")));

SearchComInfo1.setStartDate(Util.null2String(request.getParameter("startdate")));
SearchComInfo1.setStartDateTo(Util.null2String(request.getParameter("startdateTo")));
SearchComInfo1.setEndDate(Util.null2String(request.getParameter("enddate")));
SearchComInfo1.setEndDateTo(Util.null2String(request.getParameter("enddateTo")));
SearchComInfo1.setFinish(Util.null2String(request.getParameter("finish")));
SearchComInfo1.setFinish1(Util.null2String(request.getParameter("finish1")));
SearchComInfo1.setSubcompanyid1(Util.null2String(request.getParameter("subcompanyid1")));

//tagtag
StringBuffer cusSql=new StringBuffer();//自定义字段条件
HashMap<String,String> cusFieldVal= new HashMap<String, String>();//自定义字段值
PrjFieldComInfo  CptFieldComInfo=new PrjFieldComInfo();
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
			if(fieldhtmltype==1&&(type==2||type==3||type==4)){
				cusSql.append(" and "+fieldname+" ="+val+"  ");
			}else if(fieldhtmltype==3){
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
	 			cusSql.append(" and exists(select 1 from prj_SelectItem ttt2 where ttt2.fieldid="+fieldid+" and ttt2.selectvalue='"+val+"' and ttt2.selectvalue=t1."+fieldname+" ) ");
	 		}else{
	 			cusSql.append(" and "+fieldname+" like'%"+val+"%'  ");
	 		}
		}
		
	}
}
SearchComInfo1.setCusSql(cusSql.toString());
SearchComInfo1.setCusFieldInfo(cusFieldVal);


response.sendRedirect("/proj/search/SearchResult.jsp?from="+from+"&start=1&perpage="+perpage);
%>
