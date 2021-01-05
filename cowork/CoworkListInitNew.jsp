
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 weaver.docs.docs.CustomFieldManager" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<%@page import="weaver.cowork.CoworkItemMarkOperation"%>
<%@page import="weaver.cowork.CoworkLabelVO"%>
<%@page import="java.net.URLDecoder"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%

String CustomerID = Util.null2String(request.getParameter("CustomerID"));
int userid=user.getUID();
// 查看类型
String type = Util.null2String(request.getParameter("type"));
//关注的或者直接参与的协作
String viewType = Util.null2String(request.getParameter("viewtype"));
//排序方式
String orderType = Util.null2String(request.getParameter("orderType"));
//是否是搜索操作
String isSearch = Util.null2String(request.getParameter("isSearch"));
//关键字
String name =URLDecoder.decode( Util.null2String(request.getParameter("name")));
//协作区ID
String typeid = Util.null2String(request.getParameter("typeid"));
//协作状态
String status = Util.null2String(request.getParameter("status"));
//参与类型
String jointype = Util.null2String(request.getParameter("jointype"));
// 创建者
String creater = Util.null2String(request.getParameter("creater"));
//负责人
String principal = Util.null2String(request.getParameter("principal"));
//开始时间
String startdate = Util.null2String(request.getParameter("startdate"));
// 结束时间
String enddate = Util.null2String(request.getParameter("enddate"));

String labelid=Util.null2String(request.getParameter("labelid"));

int index=Util.getIntValue(request.getParameter("index"));                 //下标 
int pagesize=Util.getIntValue(request.getParameter("pagesize"));           //每一次取多少
String disattention=Util.null2String(request.getParameter("disattention"));
String disdirect=Util.null2String(request.getParameter("disdirect"));

String projectid=Util.null2String(request.getParameter("projectid"));
String taskIds=Util.null2String(request.getParameter("taskIds"));

String searchStr="jointype is not null";
  if(isSearch.equals("true")){
	if(!name.equals("")){
		searchStr += " and name like '%"+name+"%' "; 
	}
	if(!typeid.equals("")){
		searchStr += "  and typeid='"+typeid+"'  ";
	}
	if(!status.equals("")){
		searchStr += " and status ="+status+"";
	}
	if(jointype.equals("")){        //参与 关注
		searchStr += " and jointype is not null";
	}else if(jointype.equals("1")){ //关注
		searchStr += " and jointype=1";
	}else if(jointype.equals("2")){ //参与
		searchStr += " and jointype=0";
	}
	if(!creater.equals("")){
		searchStr += " and creater='"+creater+"'  ";
	}
	if(!principal.equals("")){
		searchStr += " and principal='"+principal+"'  "; 
	}
	if(!startdate.equals("")){
		searchStr +=" and begindate >='"+startdate+"'  ";
	}
	if(!enddate.equals("")){
		searchStr +=" and enddate <='"+enddate+"'  ";
	}
  }else{
    searchStr += " and status =1";
  }
  
  if(!projectid.equals("")){
	   if ("oracle".equals(RecordSet.getDBType())) {
	       searchStr += " and mutil_prjs||',' like '%"+projectid+",%'";
	   } else if ("sqlserver".equals(RecordSet.getDBType())) {
	       searchStr += " and mutil_prjs+',' like '%"+projectid+",%'";
	   } else if ("mysql".equals(RecordSet.getDBType())) {
	       searchStr += " and concat(mutil_prjs, ',') like '%"+projectid+",%'";
	   }
  }
  if(!CustomerID.equals("")){
	   if ("oracle".equals(RecordSet.getDBType())) {
	       searchStr += " and relatedcus||',' like '%"+CustomerID+",%'";
	   } else if ("sqlserver".equals(RecordSet.getDBType())) {
	       searchStr += " and relatedcus+',' like '%"+CustomerID+",%'";
	   } else if ("mysql".equals(RecordSet.getDBType())) {
	       searchStr += " and concat(relatedcus, ',') like '%"+CustomerID+",%'";
	   }
  }
 if(!taskIds.equals("")){
		 searchStr +=" and id in ("+taskIds+")";
   } 
   
String sqlStr ="";

int departmentid=user.getUserDepartment();   //用户所属部门
int subCompanyid=user.getUserSubCompany1();  //用户所属分部
String seclevel=user.getSeclevel();          //用于安全等级

int iTotal =Util.getIntValue(request.getParameter("total"),0);
int iNextNum =index;
int ipageset = pagesize;
if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
if(iTotal < pagesize) ipageset = iTotal;

sqlStr="("+
		" select t1.id,t1.name,t1.status,t1.typeid,t1.creater,t1.principal,t1.begindate,t1.enddate,t1.replayNum,t1.readNum,t1.lastdiscussant,t1.lastupdatedate,t1.lastupdatetime,"+
		" case when  t3.sourceid is not null then 1 when t2.cotypeid is not null then 0 end as jointype,"+
		" case when  t4.coworkid is not null then 0 else 1 end as isnew,"+
		" case when  t5.coworkid is not null then 1 else 0 end as important,"+
		" case when  t6.coworkid is not null then 1 else 0 end as ishidden"+
		(type.equals("label")?" ,case when  t7.coworkid is not null then 1 else 0 end as islabel":"")+
		" from cowork_items  t1 left join "+
		//关注的协作
		" (select distinct cotypeid from  cotype_sharemanager where (sharetype=1 and sharevalue like '%,"+userid+",%' )"+
		" or (sharetype=2 and sharevalue like '%,"+departmentid+",%' and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax) "+
		" or (sharetype=3 and sharevalue like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
		" or (sharetype=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and  sharevalue=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
		" or (sharetype=5 and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
		" )  t2 on t1.typeid=t2.cotypeid left join "+
        //直接参与的协作
		" (select distinct sourceid from coworkshare where"+
		" (type=1 and  (content='"+userid+"' or content like '%,"+userid+",%') )"+
		" or (type=2 and content like '%,"+subCompanyid+",%'  and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax) "+
		" or (type=3 and content like '%,"+departmentid+",%' and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
		" or (type=4 and exists (select id from hrmrolemembers  where resourceid="+userid+"  and content=Cast(roleid as varchar(100))) and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
		" or (type=5 and "+seclevel+">=seclevel and "+seclevel+" < = seclevelMax)"+
		" )  t3 on t3.sourceid=t1.id"+
        //阅读|重要|隐藏
		" left join (select distinct coworkid,userid from cowork_read where userid="+userid+")  t4 on t1.id=t4.coworkid"+       //阅读状态
		" left join (select distinct coworkid,userid from cowork_important where userid="+userid+" )  t5 on t1.id=t5.coworkid"+ //重要性
		" left join (select distinct coworkid,userid from cowork_hidden where userid="+userid+" )  t6 on t1.id=t6.coworkid"+    //是否隐藏
		(type.equals("label")?" left join (select distinct coworkid from cowork_item_label where labelid="+labelid+") t7 on t1.id=t7.coworkid":"")+ 
		" ) t ";

		if("unread".equals(type)){
			searchStr=searchStr+" and isnew=1 and ishidden<>1";
		}else if("important".equals(type)){
			searchStr=searchStr+" and important=1 and ishidden<>1";
		}else if("hidden".equals(type)){
			searchStr=searchStr+" and ishidden=1";
		}else if("all".equals(type)){
			searchStr=searchStr+" and ishidden<>1";
		}else if("coworkArea".equals(type)){
			searchStr=searchStr+" and ishidden<>1 and typeid="+typeid;
        }else if("label".equals(type)){
        	searchStr=searchStr+" and ishidden<>1 and islabel=1";
        }



String tableString = "";
int perpage=10;                                 
String backfields = " id,name,status,typeid,creater,principal,begindate,enddate,jointype,isnew,important,ishidden,replayNum,readNum,lastdiscussant,lastupdatedate,lastupdatetime ";
String fromSql  = sqlStr ;
String sqlWhere = searchStr;
String orderby = " id ";

tableString = " <table tabletype=\"checkbox\" pagesize=\""+perpage+"\" >"+
			  " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getResultCheckBox\" />"+
			  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
              " <head>"+
              "	<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" orderkey=\"name\" column=\"name\" linkvaluecolumn=\"id\" href=\"javascript:editCoworkType('{0}')\"/>"+
              "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" orderkey=\"principal\" column=\"principal\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getLastname\"/>"+
              "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(117,user.getLanguage())+"\" orderkey=\"replayNum\" column=\"replayNum\" />"+
              "	<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+"\" orderkey=\"readNum\" column=\"readNum\" />"+
              "	<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(83227,user.getLanguage())+"\" column=\"lastdiscussant\" otherpara='column:lastupdatedate+column:lastupdatetime' transmethod=\"weaver.general.CoworkTransMethod.getLastUpdate\"/>"+
              "	</head>"+ 
              "</table>";

%>	

	<div id ='divContent1' style='' >
		<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" /> 
	</div>
