
<%@page import="weaver.filter.XssUtil"%>
<%@page import="weaver.formmode.cuspage.cpt.Cpt4modeUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@page import="weaver.fullsearch.util.RmiConfig"%>
<%@page import="weaver.fullsearch.SearchResultBean"%> 
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<%
int mainid = Util.getIntValue(request.getParameter("mainid"),0);
int stype = Util.getIntValue(request.getParameter("stype"),0);
String fieldname = Util.null2String(request.getParameter("fieldname"),"");
%>



<%
session.removeAttribute("RequestViewResource");   //查看下属代办后，防止下次搜索还是下属的流程  requestview.jsp   set 进去的
int searchtype=Util.getIntValue(request.getParameter("searchtype"),0);
String searchvalue=Util.fromScreen2(request.getParameter("searchvalue"),user.getLanguage());
String searchvalue2=Util.null2String(request.getParameter("searchvalue"));
// 快捷搜索使用微搜中转开始
//判断是否启用了微搜,是否通过微搜中转搜索
boolean isUseES="1".equals(RecordSet.getPropValue("QuickSearch","useES"));
String fromES=Util.null2String(request.getParameter("fromES"));
if("1".equals(fromES)){
	searchtype=Util.getIntValue(RecordSet.getPropValue("QuickSearch",Util.null2String(request.getParameter("contentType"))));
}
//(系统模块)启用微搜快捷搜索,且微搜功能正常,且是内部人员
if(isUseES && RmiConfig.isSearchFile()&&!"".equals(searchvalue)&&"1".equals(user.getLogintype())){
	if(!"1".equals(fromES)){
		//微搜中对应类型
		String esType=RecordSet.getPropValue("QuickSearch",""+searchtype);
		if(!"".equals(esType)){
			boolean isUse="1".equals(RecordSet.getPropValue("QuickSearch",esType+".use"));
			if(isUse){
				//微搜启用模块
				Set<String> set=new SearchResultBean().getSearchInfoSet(user);
				if(set.contains(esType)){
					if(searchtype==4){//资产
						if(!Cpt4modeUtil.isUse()){//非建模搭建
							response.sendRedirect("/fullsearch/SearchResult.jsp?searchType=CONTENT&contentType="+esType+"&key="+URLEncoder.encode(searchvalue,"utf-8"));
							return;
						}
					}else{
						response.sendRedirect("/fullsearch/SearchResult.jsp?searchType=CONTENT&contentType="+esType+"&key="+URLEncoder.encode(searchvalue,"utf-8"));
						return;
					}
				}
			}
		}
	}
}
//快捷搜索使用微搜中转结束
String whereclause="";
String orderclause="";
BaseBean baseBean = new BaseBean();
String date2durings = "";
int olddate2during = 0;
if(searchtype==1){//docs
%>
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<%
	DocSearchComInfo.resetSearchInfo();
	//DocSearchComInfo.setDocsubject(searchvalue2);
	DocSearchComInfo.addDocstatus("1");
	DocSearchComInfo.addDocstatus("2");
	DocSearchComInfo.addDocstatus("5");
	DocSearchComInfo.addDocstatus("7");
	
	try
	{
		date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
	}
	catch(Exception e)
	{}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
	if(date2duringTokens.length>0)
	{
		olddate2during = Util.getIntValue(date2duringTokens[0],0);
	}
	if(olddate2during<0||olddate2during>36)
	{
		olddate2during = 0;
	}
	//String redirecturl = "/docs/search/DocSearch.jsp?date2during="+olddate2during+"&isinit=false";
	String redirecturl = "/docs/search/DocMain.jsp?urlType=14&docsubject="+URLEncoder.encode(searchvalue,"utf-8")+"&fromUrlType=1&date2during="+olddate2during+"&isinit=false";
	response.sendRedirect(redirecturl);		
}
if(searchtype==2){//hrm
%>
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<%
	String belongto=Util.fromScreen2(request.getParameter("belongto"),user.getLanguage());
	HrmSearchComInfo.resetSearchInfo();
	HrmSearchComInfo.setResourcename(searchvalue);
	if(belongto.length()>0)HrmSearchComInfo.setBelongto(belongto);
	HrmSearchComInfo.setOrderby("id");
	int userid=user.getUID();
	RecordSet.executeSql("select dspperpage from HrmUserDefine where userid="+userid);
	RecordSet.next();
	String perpage=RecordSet.getString("dspperpage");
	if(perpage.equals(""))	perpage="10";
	response.sendRedirect("/hrm/search/HrmResourceSearch_frm.jsp?from=QuickSearch");
}
if(searchtype==3){//crm
%>
<jsp:useBean id="CRMSearchComInfo" class="weaver.crm.search.SearchComInfo" scope="session" />
<%	
	CRMSearchComInfo.resetSearchInfo();
	searchvalue=Util.null2String(request.getParameter("searchvalue"));
	CRMSearchComInfo.setCustomerName(searchvalue);
	response.sendRedirect("/CRM/data/CustomerFrame.jsp?type=quick&start=1&perpage=10");
}

if(searchtype==4){//cpt
%>
<jsp:useBean id="CptSearchComInfo" class="weaver.cpt.search.CptSearchComInfo" scope="session" />
<%	String isdata = "2";
	CptSearchComInfo.resetSearchInfo();
	CptSearchComInfo.setName(searchvalue);
	CptSearchComInfo.setIsData(isdata);
	//response.sendRedirect("/cpt/search/CptSearchResult.jsp?start=1");  
	String cpturl="";
	if(Cpt4modeUtil.isUse()){
		cpturl="/formmode/tree/ViewCustomTree.jsp?id="+Cpt4modeUtil.getTreeid("cxzc")+"&searchkeyname="+URLEncoder.encode(searchvalue,"utf-8")+"&sqlwhere="+new XssUtil().put(" name like '%"+searchvalue+"%' "); 
	}else{
		cpturl="/cpt/search/CptSearch.jsp?from=quick&start=1";
	}
	response.sendRedirect(cpturl);
	//response.sendRedirect("/lgc/search/LgcSearchOperation.jsp?operation=search&assetname="+searchvalue);
}
if(searchtype==5){//request
%>
<jsp:useBean id="SearchClause" class="weaver.search.SearchClause" scope="session" />
<%  session.removeAttribute("branchid");
	SearchClause.resetClause();
	SearchClause.setRequestName(searchvalue);
	//response.sendRedirect("/workflow/search/WFSearchTemp.jsp?reqeustname="+searchvalue);
	whereclause+=" requestname like '%"+searchvalue+"%' and t2.islasttimes=1 and t2.workflowid in (select id from workflow_base where (isvalid='1' or isvalid='3')) ";
	orderclause="t2.receivedate ,t2.receivetime";
	//SearchClause.setOrderClause(orderclause);
	//SearchClause.setWhereClause(whereclause);
	boolean isUseOldWfMode=sysInfo.isUseOldWfMode();
	try
	{
		date2durings = Util.null2String(baseBean.getPropValue("wfdateduring", "wfdateduring"));
	}
	catch(Exception e)
	{}
	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
	if(date2duringTokens.length>0)
	{
		olddate2during = Util.getIntValue(date2duringTokens[0],0);
	}
	if(olddate2during<0||olddate2during>36)
	{
		olddate2during = 0;
	}
	String redirecturl = "/workflow/search/WFSearch.jsp?date2during="+olddate2during+"&isinit=false";
	if(false){
		response.sendRedirect("/workflow/search/WFSearchResult.jsp?start=1&perpage=10");
	}else{
		response.sendRedirect(redirecturl);
	}
}
if(searchtype==6){//project
%>
<jsp:useBean id="SearchComInfo1" class="weaver.proj.search.SearchComInfo" scope="session" />
<%
	SearchComInfo1.resetSearchInfo();
	SearchComInfo1.setnameopt("1");
	SearchComInfo1.setname(searchvalue2);
	//response.sendRedirect("/proj/search/SearchResult.jsp?start=1&perpage=10");
	response.sendRedirect("/proj/search/Search.jsp?from=quick&start=1&perpage=10");
}
if(searchtype==7){//email
%>
<jsp:useBean id="mailSearchComInfo" class="weaver.email.search.MailSearchComInfo" scope="session" />
<%
	mailSearchComInfo.resetSearchInfo();
	mailSearchComInfo.setSubject(searchvalue2);
	response.sendRedirect("/email/new/MailInBox.jsp?quickSearch=true&receivemail=false&clickObj=1");
}
if(searchtype==8){
	response.sendRedirect("/cowork/coworkview.jsp?flag=search&quickSearch=true&name="+URLEncoder.encode(searchvalue,"utf-8"));
}
if(searchtype==9){
	response.sendRedirect("/fullsearch/SearchResult.jsp?searchType=CONTENT&contentType=ALL&key="+URLEncoder.encode(searchvalue,"utf-8"));
}
if(searchtype==10){

	if(stype == 1){
		RecordSet2.executeSql("select a.* from workflow_billfield a ,(select formid from mode_customsearch  where id="+mainid+")b where a.billid = b.formid and id="+fieldname);	
	}else{
		RecordSet2.executeSql("select * from mode_CustomDspField where customid="+(fieldname.equals("")?"''":fieldname)+" and iskey=1");	
	}
	boolean flag = RecordSet2.next();

	if(stype == 1){ //查询的搜索页面
		String url = "/formmode/search/CustomSearchBySimple.jsp?customid="+mainid;
	    String param1 = "&check_con="+fieldname;
	    String param2 = "&con"+fieldname+"_htmltype="+RecordSet2.getString("fieldhtmltype");
	    String param3 = "&con"+fieldname+"_type="+RecordSet2.getInt("type");
	    String param4 = "&con"+fieldname+"_colname="+RecordSet2.getString("fieldname");
	    String param5 = "&con"+fieldname+"_viewtype="+RecordSet2.getInt("viewtype");
	    String param6 = "";
	    if(RecordSet2.getInt("type") == 1){
	    	param6 = "&con"+fieldname+"_opt=3";
	    }else{
	    	param6 = "&con"+fieldname+"_opt=2";	
	    }
	    String param7 = "&con"+fieldname+"_value="+FieldInfo.escape(searchvalue);
		url = url+param1+param2+param3+param4+param5+param6+param7;
		response.sendRedirect(url);
	}
	if(stype == 2){//树的搜索页面
		if(flag){
			 fieldname = RecordSet2.getInt("fieldid")+"";			
		}
		String url = "/formmode/tree/ViewCustomTree.jsp?id="+mainid+"&isExpand=0";
		url = url + "&searchkeyname="+FieldInfo.escape(searchvalue)+"&fieldname="+fieldname;
		response.sendRedirect(url);
	}	
}
if(searchtype==99){
	response.sendRedirect("/messager/MsgSearch.jsp?msg="+URLEncoder.encode(searchvalue));
}
%>