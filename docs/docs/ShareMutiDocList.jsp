
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>


<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />

<jsp:useBean id="DocSearchManage" class="weaver.docs.search.DocSearchManage" scope="page" />
<jsp:useBean id="DocSearchComInfo" class="weaver.docs.search.DocSearchComInfo" scope="session" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
</head>
<%

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17220,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(197,user.getLanguage());
String needfav ="1";
String needhelp ="";

String sqlWhere="";
//查询设置
String userid=user.getUID()+"" ;
String loginType = user.getLogintype() ;
String userSeclevel = user.getSeclevel() ;
String userType = ""+user.getType();
String userdepartment = ""+user.getUserDepartment();
String usersubcomany = ""+user.getUserSubCompany1();
char flag=2;
boolean shownewicon=false;
String dspreply = DocSearchComInfo.getContainreply() ;
String tabletype="checkbox";
String browser="";



/* added by yinshun.xu 2006-07-19 按组织结构显示 */
//String subcompanyid=Util.null2String(request.getParameter("subcompanyid"));
//String departmentid=Util.null2String(request.getParameter("departmentid"));
String subcompanyid=DocSearchComInfo.getDocSubCompanyId();
String departmentid=DocSearchComInfo.getDocdepartmentid();
/* added end */








String tableString = "";
String tableInfo = "";

	String outFields = "isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	if(RecordSet.getDBType().equals("oracle"))
	{
		outFields = "nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
	}
	//backFields
	String backFields="t1.id,t1.seccategory,t1.doclastmodtime,t1.docsubject,t2.sharelevel,t1.docextendname,t1.doccreaterid,";
	//from

	//where
	
	
	String whereclause = " where " + DocSearchComInfo.FormatSQLSearch(user.getLanguage()) ;
	String customersql = DocSearchComInfo.getCustomSqlWhere();
	whereclause+=" and t2.sharelevel=3 ";
	whereclause+=" and exists(select 1 from DocSecCategory where DocSecCategory.id=t1.secCategory and DocSecCategory.shareable='1') ";

	/* added by wdl 2006-08-28 不显示历史版本 */
	whereclause+=" and (ishistory is null or ishistory = 0) ";
	/* added end */	
	
	//String tableInfo
	tableInfo = "";
 

	sqlWhere = DocSearchManage.getShareSqlWhere(whereclause,user);
	String  sqlFrom = "";
	if(customersql.equals("")){
		sqlFrom = "DocDetail  t1, "+tables+"  t2";
	}else{
		sqlFrom = "DocDetail  t1, "+tables+"  t2,cus_fielddata tCustom";
	}
	//System.out.println(sqlWhere);
	//colString
	String userInfoForotherpara =loginType+"+"+userid;
	String colString ="";

	colString +="<col name=\"id\" width=\"3%\"  align=\"center\" text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>";
	
	colString +="<col name=\"id\" width=\"22%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\"/>";
	

	//orderBy
	String orderBy = "doclastmoddate,doclastmodtime";    
	//primarykey
	String primarykey = "t1.id";
	//pagesize
	UserDefaultManager.setUserid(user.getUID());
	UserDefaultManager.selectUserDefault();
	int pagesize = UserDefaultManager.getNumperpage();
	if(pagesize <2) pagesize=10;
	
	//operateString userType_userId_userSeclevel
	String popedomOtherpara=loginType+"_"+userid+"_"+userSeclevel+"_"+userType+"_"+userdepartment+"_"+usersubcomany;
	String popedomOtherpara2="column:seccategory+column:docStatus+column:doccreaterid+column:ownerid+column:sharelevel";

	
	//  用户自定义设置
	boolean dspcreater = false ;
	boolean dspcreatedate = false ;
	boolean dspmodifydate = false ;
	boolean dspdocid = false;
	boolean dspcategory = false ;
	boolean dspaccessorynum = false ;
	boolean dspreplynum = false ;
	
	
	if (UserDefaultManager.getHasdocid().equals("1")) {
	    dspdocid = true;    
	}
	if (UserDefaultManager.getHascreater().equals("1")) {
	      dspcreater = true ;
	      backFields+="ownerid,t1.usertype,";
	      colString +="<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"ownerid\" orderkey=\"ownerid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"column:usertype\"/>";
	}
	if (UserDefaultManager.getHascreatedate().equals("1")) { 
	    dspcreatedate = true ;
	    backFields+="doccreatedate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>";
	}
	if (UserDefaultManager.getHascreatetime().equals("1")) {
	    dspmodifydate = true ;
	    backFields+="doclastmoddate,";
	    colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>";
	}
	if (UserDefaultManager.getHascategory().equals("1")) {   
	    dspcategory = true ;
	    backFields+="maincategory,";
	    colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(92,user.getLanguage())+"\" column=\"id\" orderkey=\"maincategory\" returncolumn=\"id\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllDirName\"/>";
	}
	if (UserDefaultManager.getHasreplycount().equals("1")) {  
	    dspreplynum = true ;
	    backFields+="replaydoccount,";
	    colString +="<col width=\"6%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"id\" otherpara=\"column:replaydoccount\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getAllEditionReplaydocCount\"/>";
	}
	if (UserDefaultManager.getHasaccessorycount().equals("1")) {  
	    dspaccessorynum = true ;
	    backFields+="accessorycount,";
	    colString +="<col width=\"6%\" text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>";
	}
	
	backFields+="sumReadCount,docstatus,sumMark";
	

		colString +="<col width=\"6%\"   text=\""+SystemEnv.getHtmlLabelName(18469,user.getLanguage())+"\" column=\"sumReadCount\" orderkey=\"sumReadCount\"/>";
		colString +="<col width=\"5%\"   text=\""+SystemEnv.getHtmlLabelName(15663,user.getLanguage())+"\" column=\"sumMark\" orderkey=\"sumMark\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"docstatus\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus\" otherpara=\""+user.getLanguage()+"\"/>";
		//colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus2\"  otherpara=\""+user.getLanguage()+"\"/>";
		colString +="<col width=\"5%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"id\" orderkey=\"docstatus\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocStatus3\"  otherpara=\""+user.getLanguage()+"+column:docstatus+column:seccategory\"/>";

		
	//默认为按文档创建日期排序所以,必须要有这个字段
	if (backFields.indexOf("doclastmoddate")==-1) {
	    backFields+=",doclastmoddate";
	}

	//String tableString
	tableString="<table  pagesize=\""+pagesize+"\" tabletype=\""+tabletype+"\">";
	tableString+=browser;
    //tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\""+primarykey+"\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />";
    tableString+="<head>"+colString+"</head>";
    tableString+="</table>";     
       
       
%>
<BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>  
    <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:shareNext(this),_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    %>
    <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<Form name="docshare" method="post">

<TABLE width=100% height=96% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<TD valign="top">
		<TABLE class=Shadow>		
         <TR>
			<TD valign="top">
						<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" tableInfo="<%=tableInfo%>"/>
              </TD>  
         </TR>      
         </TABLE>
    </TD>
    <td ></td>
</TR>
</TABLE>
</Form>
</BODY>
</HTML>
<script language="javaScript">



function shareNext(obj){
    var sharedocids = _xtable_CheckedCheckboxId();
    if(sharedocids==""){
        alert("<%=SystemEnv.getHtmlLabelName(19065,user.getLanguage())%>");
        return;
    }

    document.docshare.action="ShareMutiDocTo.jsp?sharedocids="+sharedocids;
    obj.disabled=true;
    document.docshare.submit();
}

   
</script>
