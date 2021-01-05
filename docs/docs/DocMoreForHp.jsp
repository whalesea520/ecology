
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="hpc" class="weaver.homepage.cominfo.HomepageCominfo" scope="page" />
<jsp:useBean id="hpu" class="weaver.homepage.HomepageUtil" scope="page" />
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page"/>
<jsp:useBean id="hpefc" class="weaver.homepage.cominfo.HomepageElementFieldCominfo" scope="page"/>
<jsp:useBean id="hpes" class="weaver.homepage.HomepageExtShow" scope="page"/>
<jsp:useBean id="hpsu" class="weaver.homepage.style.HomepageStyleUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="dc" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page"/>
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
 
<%
String eid=Util.null2String(request.getParameter("eid"));
	
String tabid =Util.null2String(request.getParameter("tabid")); 
int date2during = Util.getIntValue(Util.null2String(request.getParameter("date2during")),38);
/*
*此处直接跳转到查询公共页面即可。
*/
if(true){
	response.sendRedirect("/docs/search/DocSearchTab.jsp?urlType=16&eid="+eid+"&tabid="+tabid+"&date2during="+date2during);
	return;
}
String docno =Util.null2String(request.getParameter("docno")); 
String keyword =Util.null2String(request.getParameter("keyword")); 
String doccreatedatefrom =Util.null2String(request.getParameter("doccreatedatefrom")); 
String doccreatedateto =Util.null2String(request.getParameter("doccreatedateto")); 
String doccreaterid = Util.null2String(request.getParameter("doccreaterid"));
String doccreaterid2 = Util.null2String(request.getParameter("doccreaterid2"));
String usertype = Util.null2String(request.getParameter("usertype"));
if("".equals(tabid)){
	rs.execute("select * from hpNewsTabInfo where eid="+eid +" order by tabId");
	rs.next();
	tabid = rs.getString("tabId");
}
String strsqlwhere =hpec.getStrsqlwhere(eid);

rs.execute("select sqlWhere from hpNewsTabInfo where eid = '"+eid+"' and tabId='"+tabid+"'");
if(rs.next()){
	strsqlwhere = rs.getString("sqlWhere");
}

if(strsqlwhere.indexOf("^topdoc^")!=-1){
	strsqlwhere = Util.StringReplace(strsqlwhere, "^topdoc^","#");
	String[] temp = Util.TokenizerString2(strsqlwhere, "#");
	strsqlwhere = Util.null2String(temp[0]);
	//topDocIds = Util.null2String(temp[1]);
}

// 得到新闻页ID以及相关的展现方式
if(strsqlwhere.length()<3) return;
if("^,^".equals(strsqlwhere.substring(0,3)))  return ;
try {
	strsqlwhere = Util.StringReplace(strsqlwhere, "^,^","&");
} catch (Exception e) {					
	e.printStackTrace();
}
String[] strsqlwheres = Util.TokenizerString2(strsqlwhere, "&");
String newsId = Util.null2String(strsqlwheres[0]);
int showModeId = Util.getIntValue(strsqlwheres[1]);
String srcOpenFirstAccess="0";
if (strsqlwheres.length>3) srcOpenFirstAccess=strsqlwheres[3];
String srcType="0";
String srcContent="0";
String srcReply="0";
ArrayList docSrcList=Util.TokenizerString(""+newsId, "|");
if (docSrcList.size()>0) srcType=(String)docSrcList.get(0);
if (docSrcList.size()>1) srcContent=(String)docSrcList.get(1);
if (docSrcList.size()>2) srcReply=(String)docSrcList.get(2);

if("0".equals(srcContent)) return ;

String strAccess="";
if("1".equals(srcOpenFirstAccess)) strAccess="isOpenFirstAss=1";
else strAccess="isOpenFirstAss=0"; 


//得到pageNum 与 perpage
UserDefaultManager.setUserid(user.getUID());
UserDefaultManager.selectUserDefault();
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
int perpage = UserDefaultManager.getNumperpage();
if(perpage <2) perpage=10;

//设置好搜索条件
String outFields = "";
String backFields ="";
String outFromSql = "";
String fromSql = " ";
String outSqlWhere = "";
String sqlWhere = " ";
String orderBy="";


String  userid1=""+user.getUID();
String ownerid=userid1;

String andSql="";
//String invalidStr = " or docstatus = 7 and  (sharelevel>1" + ((userid1!=null&&!"".equals(userid1))?" or (doccreaterid=" + userid1 + ((ownerid!=null&&!"".equals(ownerid))?" or ownerid=" + ownerid:"") + ")":"") + ") ";
//String strStatus=" and (docstatus='1' or docstatus='2' or docstatus='5' "+invalidStr+")";
String invalidStr = " or (docstatus = 7 and  (sharelevel>1" + ((userid1!=null&&!"".equals(userid1))?" or (doccreaterid=" + userid1 + ((ownerid!=null&&!"".equals(ownerid))?" or ownerid=" + ownerid:"") + ")":"") + ")) ";
String strStatus=" and (((docstatus='1' or docstatus='2' or docstatus='5') and sharelevel>0) "+invalidStr+")";

boolean isOralce=(rs.getDBType()).equals("oracle");

if("1".equals(srcType)){
	String newsclause = "";

	dnm.resetParameter();
	dnm.setId(Util.getIntValue(srcContent));
	dnm.getDocNewsInfoById();
	newsclause = dnm.getNewsclause();
	dnm.closeStatement();

	String newslistclause = newsclause.trim();
	if (!newslistclause.equals("")) 	newslistclause = " and (" + newslistclause+") ";
	andSql = newslistclause	+ "  and (ishistory is null or ishistory = 0)  and docpublishtype in('2','3') "+strStatus;
	andSql += dm.getDateDuringSql(date2during);
} else if("2".equals(srcType)){  //分目录
	if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
	andSql="  and (ishistory is null or ishistory = 0)  and exists (select id from docseccategory where id = seccategory and id in ("+srcContent+")) "+strStatus;
    if (!"1".equals(srcReply))	andSql+=" and (isreply!=1 or  isreply is null) ";
	//dm.selectNewsDocInfo(andSql, user,perpage, 1);
		
} else if("3".equals(srcType)){  //虚拟目录	
	if(",".equals(srcContent.substring(0,1))) srcContent=srcContent.substring(1);
	andSql=" and (ishistory is null or ishistory = 0)  "+strStatus;
	if (!"1".equals(srcReply))	andSql+=" and (isreply!=1 or  isreply is null) ";

	if(isOralce){
		//backFields="a.id,a.docsubject,b.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid, a.usertype,a.doccreatedate,a.doccreatetime,a.istop,a.topdate,a.toptime";
		//fromSql="from DocDetail a, DocDetailContent b";
		//sqlWhere="  where a.id in (select distinct t1.id from DocDetail t1, "
        //            + ShareManager.getShareDetailTableByUserNew("doc", user) + " t2,DocDummyDetail t3 where "
        //            + "t1.id=t2.sourceid and t1.id = t3.docid and t3.catelogid in("+srcContent+") " + andSql + ")  and a.id=b.docid ";
		
		//outFields=" b.doccontent ";
		outFields = "b.doccontent,nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
		backFields = " t1.id,t1.docsubject,t1.doclastmoddate,t1.doclastmodtime,t1.doccreaterid, t1.usertype,t1.doccreatedate,t1.doccreatetime,t1.istop,t1.topdate,t1.toptime ";
		fromSql="from DocDetail  t1, "+ ShareManager.getShareDetailTableByUserNew("doc", user) + " t2,DocDummyDetail  t3";
		outFromSql = " DocDetailContent  b ";
		if(!doccreatedatefrom.equals(""))
        {
			andSql+=" and t1.doccreatedate>='"+doccreatedatefrom+"' ";
     	}
        if(!doccreatedateto.equals(""))
        {
        	andSql+=" and t1.doccreatedate<='"+doccreatedateto+"' ";
        }
        if(!usertype.equals(""))
        {
        	andSql += " and t1.usertype=" + usertype;
        }
        if(!doccreaterid.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid;
        }
        if(!doccreaterid2.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid2;
        }
        
        if(!docno.equals(""))
        {
        	andSql += " and doccode like '%"+ Util.fromScreen2(docno, user.getLanguage()) + "%' ";
        }
        if(!keyword.equals(""))
        {
        	andSql += " and keyword like '%"+keyword+"%' ";
        }
		sqlWhere = " where  t1.id=t2.sourceid  and t1.id=t3.docid and t3.catelogid in("+srcContent+") "+ andSql;
		sqlWhere += dm.getDateDuringSql(date2during);
        outSqlWhere = "where b.docid=r.id";
	} else {
		/*
		backFields="id,docsubject,doccontent,doclastmoddate,doclastmodtime,doccreaterid,usertype,doccreatedate,doccreatetime,istop,topdate,toptime";
		fromSql="from DocDetail";
		sqlWhere="where id in (select distinct t1.id from DocDetail  t1, "
                    + ShareManager.getShareDetailTableByUserNew("doc", user) + " t2,DocDummyDetail  t3 where  t1.id=t2.sourceid  and t1.id=t3.docid and t3.catelogid in("+srcContent+") "
                    + andSql + ")";
		*/
		//outFields="a.id,a.docsubject,a.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid,a.usertype,a.doccreatedate,a.doccreatetime,a.istop,a.topdate,a.toptime";
		outFields="a.id,a.docsubject,a.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid,a.usertype,a.doccreatedate,a.doccreatetime,a.istop,a.topdate,a.toptime,isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=a.id and userid="+user.getUID()+"),0) as readCount";
		backFields = "t1.id,t1.doclastmoddate,t1.doccreaterid,t1.docsubject,t1.doccreatedate,t1.doccreatetime,t1.doclastmodtime,t1.istop,t1.topdate,t1.toptime";
		fromSql="from DocDetail  t1, "+ ShareManager.getShareDetailTableByUserNew("doc", user) + " t2,DocDummyDetail  t3";
		outFromSql = "DocDetail  a";
		if(!doccreatedatefrom.equals(""))
        {
			andSql+=" and doccreatedate>='"+doccreatedatefrom+"' ";
     	}
        if(!doccreatedateto.equals(""))
        {
        	andSql+=" and doccreatedate<='"+doccreatedateto+"' ";
        }
        if(!usertype.equals(""))
        {
        	andSql += " and t1.usertype=" + usertype;
        }
        if(!doccreaterid.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid;
        }
        if(!doccreaterid2.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid2;
        }
        
        if(!docno.equals(""))
        {
        	andSql += " and doccode like '%"+ Util.fromScreen2(docno, user.getLanguage()) + "%' ";
        }
        if(!keyword.equals(""))
        {
        	andSql += " and keyword like '%"+keyword+"%' ";
        }
		sqlWhere = " where  t1.id=t2.sourceid  and t1.id=t3.docid and t3.catelogid in("+srcContent+") "+ andSql;
		sqlWhere += dm.getDateDuringSql(date2during);
        outSqlWhere = "where a.id=r.id";
	}
} else if("4".equals(srcType)){ //指定文档
	ArrayList docids=Util.TokenizerString(srcContent,",");
	String newDocids="";
	for(int i=0;i<docids.size();i++)	newDocids+=","+dm.getNewDocid((String)docids.get(i));
	if(newDocids.length()>0) newDocids=newDocids.substring(1);
	andSql="  and (ishistory is null or ishistory = 0)  and id in("+newDocids+") "+strStatus;
	andSql += dm.getDateDuringSql(date2during);
	//dm.selectNewsDocInfo(andSql, user,perpage, 1);

}else if("5".equals(srcType)){ //搜索模板

}else if("6".equals(srcType)){ //搜索条件
//预留
}


if(!"3".equals(srcType)){
	if(isOralce){
		backFields="a.id,a.docsubject,b.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid, a.usertype,a.doccreatedate,a.doccreatetime,a.istop,a.topdate,a.toptime";
		fromSql="from DocDetail a, DocDetailContent b";
		sqlWhere=" where a.id in (select distinct t1.id from DocDetail t1, "+ ShareManager.getShareDetailTableByUserNew("doc", user) + " t2,DocDetailContent t3 where t1.id=t2.sourceid and t1.id = t3.docid " + andSql + ")  and a.id=b.docid";
		
		backFields = "t1.id,t1.docsubject,t1.doclastmoddate,t1.doclastmodtime,t1.doccreaterid, t1.usertype,t1.doccreatedate,t1.doccreatetime,t1.istop,t1.topdate,t1.toptime";
		outFields = "b.doccontent,nvl((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=r.id and userid="+user.getUID()+"),0) as readCount";
		fromSql = "from DocDetail  t1, "+ ShareManager.getShareDetailTableByUserNew("doc", user) + " t2";
		outFromSql = "DocDetailContent  b";
		if(!doccreatedatefrom.equals(""))
        {
			andSql+=" and doccreatedate>='"+doccreatedatefrom+"' ";
     	}
        if(!doccreatedateto.equals(""))
        {
        	andSql+=" and doccreatedate<='"+doccreatedateto+"' ";
        }
        if(!usertype.equals(""))
        {
        	andSql += " and t1.usertype=" + usertype;
        }
        if(!doccreaterid.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid;
        }
        if(!doccreaterid2.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid2;
        }
        
        if(!docno.equals(""))
        {
        	andSql += " and doccode like '%"+ Util.fromScreen2(docno, user.getLanguage()) + "%' ";
        }
        if(!keyword.equals(""))
        {
        	andSql += " and keyword like '%"+keyword+"%' ";
        }
        andSql += dm.getDateDuringSql(date2during);
        sqlWhere = " where " + "t1.id=t2.sourceid"+ andSql ;
        
        outSqlWhere = "where b.docid=r.id";
	} else {
		//backFields="id,docsubject,doccontent,doclastmoddate,doclastmodtime,doccreaterid,usertype,doccreatedate,doccreatetime,istop,topdate,toptime";
		//fromSql="from DocDetail";
		//sqlWhere="where id in (select distinct t1.id from DocDetail  t1, " + ShareManager.getShareDetailTableByUserNew("doc", user) + " t2 where " + "t1.id=t2.sourceid" + andSql + ")";
		
		backFields = "id,istop,topdate,toptime,doclastmoddate,doclastmodtime";
		backFields = "id,docsubject,doccreaterid,doccreatedate,doccreatetime,istop,topdate,toptime,doclastmoddate,doclastmodtime";
		outFields = "a.id,a.docsubject,a.doccontent,a.doclastmoddate,a.doclastmodtime,a.doccreaterid,a.usertype,a.doccreatedate,a.doccreatetime, isnull((select sum(readcount) from docReadTag where userType ="+user.getLogintype()+" and docid=a.id and userid="+user.getUID()+"),0) as readCount";
		fromSql = "from DocDetail  t1, "+ ShareManager.getShareDetailTableByUserNew("doc", user) + " t2";
		outFromSql = "DocDetail  a";
		if(!doccreatedatefrom.equals(""))
        {
			andSql+=" and doccreatedate>='"+doccreatedatefrom+"' ";
     	}
        if(!doccreatedateto.equals(""))
        {
        	andSql+=" and doccreatedate<='"+doccreatedateto+"' ";
        }
        if(!usertype.equals(""))
        {
        	andSql += " and t1.usertype=" + usertype;
        }
        if(!doccreaterid.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid;
        }
        if(!doccreaterid2.equals(""))
        {
        	andSql += " and t1.doccreaterid=" + doccreaterid2;
        }
        
        if(!docno.equals(""))
        {
        	andSql += " and doccode like '%"+ Util.fromScreen2(docno, user.getLanguage()) + "%' ";
        }
        if(!keyword.equals(""))
        {
        	andSql += " and keyword like '%"+keyword+"%' ";
        }
        andSql += dm.getDateDuringSql(date2during);
        sqlWhere = " where " + "t1.id=t2.sourceid"+ andSql ;
        
        outSqlWhere = "where a.id=r.id";
	}
}



String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19874,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<HTML>
  <HEAD>
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  </HEAD>
  <BODY>
    <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:onSearch(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		
		RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:onReSearch(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
		
        RCMenu += "{"+SystemEnv.getHtmlLabelName(18363,user.getLanguage())+",javascript:_table.firstPage(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:_table.prePage(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:_table.nextPage(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(18362,user.getLanguage())+",javascript:_table.lastPage(),_self}" ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top"> 
                <form name="DocMoreForHp" method="post" action="/docs/docs/DocMoreForHp.jsp" target="_self">
					<table class=ViewForm>
					    <colgroup><col width="15%"><col width="35%"><col width="15%"><col width="35%">            
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></td>
							<td class="field" >
							  <input class=InputStyle  type="text" name="docno" value="<%=docno %>">
							</td>							 
							<td><%=SystemEnv.getHtmlLabelName(2005,user.getLanguage())%></td>
							<td class="field" >
							  <input class=InputStyle  type="text" name="keyword" value="<%=keyword %>">
							</td>
						</tr>
						<tr style="height: 1px"><td class=Line colSpan=4></td></tr>					 
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
							<td align=left class="field">
								<button type="button" class=calendar id=SelectDate onClick="getDate(doccreatedatefromspan,doccreatedatefrom)"></button>&nbsp;
								<span id=doccreatedatefromspan><%=doccreatedatefrom %></span>-&nbsp;&nbsp;
								<button type="button" class=calendar id=SelectDate2 onClick="getDate(doccreatedatetospan,doccreatedateto)"></button>&nbsp;
								<span id=doccreatedatetospan><%=doccreatedateto %></span>
								<input type="hidden" name="doccreatedatefrom" value="<%=doccreatedatefrom %>">
							    <input type="hidden" name="doccreatedateto" value="<%=doccreatedateto %>">
							</td>
							<td height=22><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
							<td class="field">
							  <%=SystemEnv.getHtmlLabelName(362,user.getLanguage())%>:
							  <button type="button" class=Browser onClick="onShowResource('doccreateridspan','doccreaterid',1)"></button>
							  <span id=doccreateridspan>
							  <%if("1".equals(usertype) && !"".equals(doccreaterid)){%>
								 <%=Util.toScreen(ResourceComInfo.getResourcename(doccreaterid),user.getLanguage())%>
							  <%}%>
							  </span>
							  <input type="hidden" name="doccreaterid" value="<%=doccreaterid %>">
							  <br>
							  <%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>:
							  <button type="button" class=Browser id=SelectDeparment onClick="onShowParent('doccreaterid2span2','doccreaterid2',1)"></button>
							  <span id=doccreaterid2span2>
							  <%if("2".equals(usertype) && !"".equals(doccreaterid2)){%>
								 <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(doccreaterid2),user.getLanguage())%>
							  <%}%>
							  </span>
							  <input type="hidden" name="doccreaterid2" value="<%=doccreaterid2 %>">
							  <input type="hidden" name="usertype" value="<%=usertype %>">
							</td>
						 </tr>
						 <tr style="height: 1px"><td class=Line colSpan=4></td></tr>
						<%
						BaseBean baseBean = new BaseBean();
				     	String date2durings = "";
				     	try
				     	{
				     		date2durings = Util.null2String(baseBean.getPropValue("docdateduring", "date2during"));
				     	}
				     	catch(Exception e)
				     	{}
				     	String[] date2duringTokens = Util.TokenizerString2(date2durings,",");
						if(date2duringTokens.length>0)
						{ 
						%>
						 <tr>
	                        <td class="lable"><%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(446,user.getLanguage())%></td>
						    <td class="field">
						     <select class=inputstyle  size=1 id=date2during name=date2during style=width:40%>
						     	<option value="">&nbsp;</option>
						     	<%
						     	
						     	for(int i=0;i<date2duringTokens.length;i++)
						     	{
						     		int tempdate2during = Util.getIntValue(date2duringTokens[i],0);
						     		if(tempdate2during>36||tempdate2during<1)
						      		{
						      			continue;
						      		}
						     	%>
						     	<!-- 最近个月 -->
						     	<option value="<%=tempdate2during %>" <%if (date2during==tempdate2during) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(24515,user.getLanguage())%><%=tempdate2during %><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
						     	<%
						     	} 
						     	%>
						     	<!-- 全部 -->
  								<option value="38" <%if (date2during==38) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
						     </select>
						    </td>
                      </tr>
					  <TR style="height: 1px">
						<TD class=Line colSpan=4></TD>
					  </TR>
					  <%} %>
					</table>                
                    <!--列表部分-->
                          <%
                          	String userid=user.getUID()+"" ;
							String loginType = user.getLogintype() ;
                          	String userInfoForotherpara =loginType+"+"+userid;
                          	String sqlorderby = "doclastmoddate,doclastmodtime";
                          	String ebaseid = hpec.getEbaseid(eid);
                          	if(ebaseid.equals("7"))
                          	{
                          		if(isOralce)
                          			sqlorderby = "(case when istop is null then 0 else istop end),(case when topdate is null or istop is null then '1900-01-01' else topdate end),(case when toptime is null or istop is null then '00:00:00' else toptime end),doclastmoddate,doclastmodtime";
                          		else
                          			sqlorderby = "t1.istop,t1.topdate,t1.toptime,t1.doclastmoddate,t1.doclastmodtime";
                          	}
                            String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
                                       "<sql outfields=\""+Util.toHtmlForSplitPage(outFields)+"\" backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" outsqlform=\""+Util.toHtmlForSplitPage(outFromSql)+"\" sqlorderby=\""+Util.toHtmlForSplitPage(sqlorderby)+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" outsqlwhere=\""+Util.toHtmlForSplitPage(outSqlWhere)+"\" sqlisdistinct=\"true\" />"+
                                       "<head>"+
                                             "<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                             "<col name=\"id\" width=\"21%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocId\" otherpara=\""+userInfoForotherpara+"+column:docsubject+column:doccreaterid+column:readCount\" href=\"/docs/docs/DocDsp11.jsp\" linkkey=\"id\" />"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(271,user.getLanguage())+"\" column=\"doccreaterid\" orderkey=\"doccreaterid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"  otherpara=\"column:usertype\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>"+
											 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate,doccreatetime\"/>"+
                                       "</head>"+
                                       "</table>";                                             
                              %>
                                <TABLE  width="100%">		
                         <TR>
                             <TD valign="top">                
                                 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/> 
                             </TD>  
                         </TR>      
                     </TABLE>
                     <input type="hidden" id="eid"  name="eid" value="<%=eid %>">
                     <input type="hidden" id="tabid"  name="tabid" value="<%=tabid %>">
                </form>
        </td>
        
        </tr>
        </TABLE>
     </td>
     <td></td>
   </tr>
 </table>
</BODY>
<script type="text/javascript">
function onSearch()
{
    DocMoreForHp.submit();    
}
function onReSearch()
{
	DocMoreForHp.docno.value = "";
	DocMoreForHp.keyword.value = "";
	DocMoreForHp.doccreatedatefrom.value = "";
	DocMoreForHp.doccreatedateto.value = "";
	DocMoreForHp.doccreaterid.value = "";
	DocMoreForHp.doccreaterid2.value = "";
	DocMoreForHp.usertype.value = "";
	try
	{
		DocMoreForHp.date2during.value = "";
	}
	catch(e)
	{
	}
    DocMoreForHp.submit();    
}

function onShowResource(tdname, inputename, objtmp) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    if (data) {
	        if (data.id != "") {
	            document.all(tdname).innerHTML = data.name
	            //document.all(inputename).value=id(0)';
	            document.getElementsByName(inputename)[0].value = data.id
	            document.all("usertype").value = "1";
	
	            if (objtmp ==2) {
	
	            } else {
	            document.all("doccreaterid2span2").innerHTML = "";
	            document.all("doccreaterid2").value = "";
	        }
	
	    } else {
	        document.all(tdname).innerHTML = "";
	        document.getElementsByName(inputename)[0].value = "";
	        document.all("usertype").value = "";
	    }
	}
}

function onShowMutiDummy(input, span) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para=" + input.value + "_1");
    //alert("/systeminfo/BrowserMain.jsp?url=/docs/category/DocTreeDocFieldBrowserMulti.jsp?para="+input.value+"_1");
    if (data) {
        if (data.id != "") {;
            dummyidArray = data.id.split(",")
            dummynames = data.name.split(",")
           
			var sHtml="";
            for( var k = 0;k< dummyidArray.length;k++){
           		sHtml = sHtml + "<a href='/docs/docdummy/DocDummyList.jsp?dummyId=" + dummyidArray[k] + "'>" + dummynames[k] + "</a><br>";
            }
            if (sHtml != "") {
                sHtml = sHtml + "<input type=button value='<%=SystemEnv.getHtmlLabelName(20487,user.getLanguage())%> ' onclick='onImporting()'>";
            }

            input.value = data.id;
            span.innerHTML = sHtml;
        } else {
            input.value = "";
            span.innerHTML = "";
        }
    }
}
function onShowParent(tdname, inputename, objtmp) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp");
    if (data) {
        if (data.id != "") {
            document.all(tdname).innerHTML = data.name;
            document.all(inputename).value = data.id;
            document.all("usertype").value = "2"

            if (objtmp ==2) {} else {
	            document.all("doccreateridspan").innerHTML = "";
	            document.all("doccreaterid").value = "";
       	 	}

	    } else {
	        document.all(tdname).innerHTML = "";
	        document.all(inputename).value = "";
	        document.all("usertype").value = "";
	    }
	}
}
</script>

<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
 </HTML>
