<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*" %>
<%@ page import="weaver.conn.ConnStatement"%>
<%@ page import="oracle.sql.CLOB"%> 
<%@ page import="java.io.BufferedReader"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology7/skins/default/wui_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />

<%
	String keyword = Util.null2String(request.getParameter("keyword"));
	String btnG = Util.null2String(request.getParameter("btnG"));
	String showtitle = (String)valueList.get(nameList.indexOf("showtitle"));
	String showauthor = (String)valueList.get(nameList.indexOf("showauthor"));
	String showpubdate = (String)valueList.get(nameList.indexOf("showpubdate"));
	String showpubtime = (String)valueList.get(nameList.indexOf("showpubtime"));
	String tabId = Util.null2String(request.getParameter("tabid"));
	String whereKey = "";
	
	//获取当前新闻页ID
	String tabSql = "";
	if(!tabId.equals("")){
		tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid= ? and tabid= ? order by tabId";
		rs.executeQuery(tabSql,eid,tabId);
		if(rs.next()){
			whereKey = rs.getString("sqlWhere");
		}
	}else{
		tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid= ? order by tabId";
		rs.executeQuery(tabSql,eid);
		if(rs.next()){
			whereKey = rs.getString("sqlWhere");
		}else{
			whereKey = "none";
		}
	}
	 
	if(whereKey.trim().equals("")||whereKey.trim().equals("0")){
		whereKey = "none";
	}

	//获取所使用的新闻模板ID
	String newstemplateid="";
	rs_Setting.executeQuery("select newstemplate from hpElement where id= ?",eid);
	
	if(rs_Setting.next()){
		newstemplateid = rs_Setting.getString("newstemplate");	
	}
	
	//获取新闻页条件
	String newsclause ="";
	if(!"none".equals(whereKey)){
		dnm.resetParameter();
		dnm.setId(Util.getIntValue(whereKey));
		dnm.getDocNewsInfoById();
		newsclause = dnm.getNewsclause();
		dnm.closeStatement();
	}else{
		newsclause = "1!=1";
	}
	newsclause = newsclause.trim();
	if (!newsclause.equals("")){
		newsclause = " and (" + newsclause+") ";
	} else{
		newsclause = " ";
	}

	// 组装查询信息
	newsclause =  " (docpublishtype='2' or docpublishtype='3') and docstatus in('1','2') "+newsclause;
	//得到当前数据
	String sql ="";
	String backFields = "";
	String sqlFrom = "";
	String sqlWhere = "";
	if ((rs.getDBType()).equals("oracle")) { // oralce
		//sql = " select a.id,a.docsubject,b.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid, a.usertype";
		//sql +=" from DocDetail a, DocDetailContent b";
		//sql +=" where  a.id=b.docid  and "+newsclause;
		//sql +=" order by a.doclastmoddate desc,a.doclastmodtime desc ";
		backFields = " a.id,a.docsubject,b.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreatedate,a.doccreaterid, a.usertype ";
		sqlFrom = " from DocDetail a, DocDetailContent b";
		sqlWhere = " where  a.id=b.docid  and "+newsclause;
		
	} else {
		//sql = " select id,docsubject,doccontent,doclastmoddate,doclastmodtime,doccreaterid,usertype";
		//sql +=" from DocDetail";
		//sql +=" where "+newsclause;
		//sql +=" order by doclastmoddate desc ,doclastmodtime desc ";
		backFields = " id,docsubject,doccontent,doclastmoddate,doclastmodtime,doccreatedate,doccreaterid,usertype ";
		sqlFrom = " from DocDetail";
		sqlWhere = " where "+newsclause;
	}

	//sppb.setIsPrintExecuteSql(true);
	//rs.execute(sql);
	sppb.setBackFields(Util.toHtmlForSplitPage(backFields));
    sppb.setSqlFrom(sqlFrom);
    sppb.setSqlWhere(sqlWhere);

	sppb.setPrimaryKey("id");
    sppb.setSqlOrderBy("doclastmoddate,doclastmodtime");
    sppb.setSortWay(sppb.DESC);
    spu.setSpp(sppb);
    
	int languageId=7;
	int index = Util.getIntValue(request.getParameter("index"),1);
	perpage=10;
	int totalCount =spu.getRecordCount();		
	rs=spu.getCurrentPageRs(index,perpage);	


	int totalPage =  totalCount%perpage==0?totalCount/perpage:totalCount/perpage+1;

	String toolBarStr = "";
	String toolBarStr_1 = "";
	String toolBarStr_2= "";
	if(totalPage<2){
		toolBarStr="&raquo;"+SystemEnv.getHtmlLabelName(18861,languageId)+totalCount+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(265,languageId)+perpage+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18609,languageId)+totalPage+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(524,languageId)+SystemEnv.getHtmlLabelName(15323,languageId)+index+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18363,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(1258,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(1259,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18362,languageId)+"&nbsp;&nbsp;";

	}else{
		if(index==1){
			toolBarStr="&raquo;"+SystemEnv.getHtmlLabelName(18861,languageId)+totalCount+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(265,languageId)+perpage+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18609,languageId)+totalPage+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(524,languageId)+SystemEnv.getHtmlLabelName(15323,languageId)+index+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18363,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(1258,languageId)+"&nbsp;&nbsp; <a href='javascript:nextPage("+index+")'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(1259,languageId)+"</font></a>&nbsp;&nbsp;<a href='javascript:lastPage()'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(18362,languageId)+"</font></a>&nbsp;&nbsp;";
		}else if(index>1&&index<totalPage){
			toolBarStr="&raquo;"+SystemEnv.getHtmlLabelName(18861,languageId)+totalCount+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(265,languageId)+perpage+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18609,languageId)+totalPage+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(524,languageId)+SystemEnv.getHtmlLabelName(15323,languageId)+index+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;<a href='javascript:firstPage()'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(18363,languageId)+"</font></a>&nbsp;&nbsp;<a href='javascript:prevPage("+index+")'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(1258,languageId)+"</font></a>&nbsp;&nbsp;<a href='javascript:nextPage("+index+")'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(1259,languageId)+"</font></a>&nbsp;&nbsp;<a href='javascript:lastPage()'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(18362,languageId)+"</font></a>&nbsp;&nbsp;";
		}else if(index>=totalPage){
			toolBarStr="&raquo;"+SystemEnv.getHtmlLabelName(18861,languageId)+totalCount+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(265,languageId)+perpage+SystemEnv.getHtmlLabelName(24683,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18609,languageId)+totalPage+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(524,languageId)+SystemEnv.getHtmlLabelName(15323,languageId)+index+SystemEnv.getHtmlLabelName(23161,languageId)+"&nbsp;&nbsp;<a href='javascript:firstPage()'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(18363,languageId)+"</font></a>&nbsp;&nbsp;<a href='javascript:prevPage("+index+")'><font class='toolbar'>"+SystemEnv.getHtmlLabelName(1258,languageId)+"</font></a>&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(1259,languageId)+"&nbsp;&nbsp;"+SystemEnv.getHtmlLabelName(18362,languageId)+"&nbsp;&nbsp;";
		}
	}

		toolBarStr_1=toolBarStr+"<button   onclick='javascript:gotoBefore()' title="+SystemEnv.getHtmlLabelName(23162,languageId)+">"+SystemEnv.getHtmlLabelName(23162,languageId)+"</button> "+SystemEnv.getHtmlLabelName(15323,languageId)+"<input name=pageBefore id=pageBefore type=text size=2 height=1 style='TEXT-ALIGN:right' value="+index+">"+SystemEnv.getHtmlLabelName(23161,languageId)+"";
		toolBarStr_2=toolBarStr+"<button   onclick='javascript:gotoAfter()' title="+SystemEnv.getHtmlLabelName(23162,languageId)+">"+SystemEnv.getHtmlLabelName(23162,languageId)+"</button> "+SystemEnv.getHtmlLabelName(15323,languageId)+"<input name=pageAfter id=pageAfter type=text size=2 height=1 style='TEXT-ALIGN:right' value="+index+">"+SystemEnv.getHtmlLabelName(23161,languageId)+"";


%>
<form name="weaver" method="get" action="more.jsp">
	<input type="hidden" name="eid" value="<%=eid%>">
	<input type="hidden" name="tabid" value="<%=tabId%>">
	<input type="hidden" name="keyword" value="<%=keyword%>">
	<input type="hidden" name="btnG" value="<%=btnG%>">
	<input type="hidden" name="index" value="<%=index%>">
<table width=100% height=96% border="0" cellspacing="0" cellpadding="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">

    <tr><td height="10" colspan="3"></td></tr>
    <tr>
        <td ></td>
        <td valign="top">
	 <TABLE class=Shadow>
            <tr>
             <td valign="top">
<table width="100%">
<tr>
	<td align="right" totalPage="<%=totalPage%>" class='toolbar' height="36" colspan="3">
	<%=toolBarStr_1 %>&nbsp;&nbsp;&nbsp;
	</td>
</tr>
</table>
				<table class=ListStyle width=100%>
				<colgroup>
				<col width="*">
				<col width="100">
				</colgroup>
				
				<thead>
					<TR class=HeaderForXtalbe style=' height:25px! important'>
						<th>
						<%=SystemEnv.getHtmlLabelName(229,7) %>
						</th>
						<th>
						<%=SystemEnv.getHtmlLabelName(722,7) %>
						</th>
						<th>
						<%=SystemEnv.getHtmlLabelName(723,7) %>
						</th>
					</TR>
				</thead>
				<%
					int count=0;
					while(rs.next()){
						String title = rs.getString("docsubject");
						title = Util.getMoreStr(title,20,"...");
						if(!newstemplateid.equals("")){
							title ="<a href=\"javascript:openFullWindowForXtable('/page/maint/template/news/newstemplateprotal.jsp?templatetype=1&templateid="+newstemplateid+"&docid="+rs.getString("id")+"&npid="+Util.getIntValue(whereKey)+"')\"><font class=\"font\">"+title+"</font></A>";
						}
					    String trClass="DataLight";
					    if(count%2==0){
					    	trClass = "DataDark";
					    }
					%>
					<tr class=<%=trClass %>>
						<td width="*">
							<%=title %>
						</td>
						<td width="100">
							<%=rs.getString("doccreatedate") %>
						</td>
						<td width="100">
							<%=rs.getString("doclastmoddate") %>
						</td>
					</tr>
					<%	
					count++;
					}
				%>
				
				</table>
<table width="100%">
<tr>
	<td align="right" totalPage="<%=totalPage%>" class='toolbar' height="36" colspan="3">
	<%=toolBarStr_2 %>&nbsp;&nbsp;&nbsp;
	</td>
</tr>
</table>
			 </td>
            </tr>
        </TABLE>
		</td>
        <td></td>
    </tr>
    <tr><td height="10" colspan="3"></td></tr>
</table>

<SCRIPT LANGUAGE="JavaScript">
var maxPage = "<%=totalPage%>";
var index = "<%=index%>";
function gotoBefore(){
	var current = $GetEle("index");
	current.value = $GetEle("pageBefore").value;
	if(current.value>0 && current.value<=parseInt(maxPage))
		document.weaver.submit();
	else{
		$GetEle("pageAfter").value=index;
		$GetEle("pageBefore").value=index;
	}
}

function gotoAfter(){
	var current = $GetEle("index");
	current.value = $GetEle("pageAfter").value;
	if(current.value>0 && current.value<=parseInt(maxPage))
		document.weaver.submit();
	else{
		$GetEle("pageAfter").value=index;
		$GetEle("pageBefore").value=index;
	}
}

//首页
function firstPage(){
	$GetEle("index").value=1;
	document.weaver.submit();
}
//尾页
function lastPage(){
	$GetEle("index").value=<%=totalPage%>;
	document.weaver.submit();
}

//下一页
function nextPage(index){
	$GetEle("index").value=index+1;
	document.weaver.submit();	
}

//上一页
function prevPage(index){
	$GetEle("index").value=index-1;
	document.weaver.submit();
}	

function openFullWindowForXtable(url){
	  var redirectUrl = url ;
	  var width = screen.width ;
	  var height = screen.height ;
	  var szFeatures = "top=100," ; 
	  szFeatures +="left=400," ;
	  szFeatures +="width="+width/2+"," ;
	  szFeatures +="height="+height/2+"," ; 
	  szFeatures +="directories=no," ;
	  szFeatures +="status=yes," ;
	  szFeatures +="menubar=no," ;
	  szFeatures +="scrollbars=yes," ;
	  szFeatures +="resizable=yes" ;
	  window.open(redirectUrl,"",szFeatures) ;
}
 </SCRIPT>