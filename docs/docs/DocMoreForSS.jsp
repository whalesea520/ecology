
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.homepage.style.HomepageStyleBean"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="hpec" class="weaver.homepage.cominfo.HomepageElementCominfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ShareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />

<%
String eid=Util.null2String(request.getParameter("eid"));
String sqlWhereKey =hpec.getStrsqlwhere(eid);

String setValue1 = "";
String setValue2 = "";
String setValue3 = "";
String setValue4 = "";
try 
{
	if(!"".equals(sqlWhereKey))
	{
		sqlWhereKey = Util.StringReplace(sqlWhereKey, "^,^"," & ");
	
		ArrayList newsSetList=Util.TokenizerString(sqlWhereKey,"&");
		if(newsSetList.size()>=2) 
		{
			setValue1=(String)newsSetList.get(0);
			setValue2=(String)newsSetList.get(1);
		}

		if(newsSetList.size()>=3) 
		{
			setValue3=(String)newsSetList.get(2);
		}
		if(newsSetList.size()>=4) 
		{
			setValue4=(String)newsSetList.get(3);
		}
	
	}
} 
catch (Exception e) 
{
	e.printStackTrace();
}
setValue1 = setValue1.trim();
setValue2 = setValue2.trim();
setValue3 = setValue3.trim();
setValue4 = setValue4.trim();

String backFields = "";
String sqlFrom="";
String sqlWhere="";

String srcContent="";

ArrayList docSrcList=Util.TokenizerString(setValue1, "|");
if(docSrcList!=null&&docSrcList.size()>=3)
{
	srcContent=(String)docSrcList.get(1);
}
int perpage = UserDefaultManager.getNumperpage();
if(perpage <2) perpage=10;
//订阅内容
String summarySql = "";

ArrayList docContentList = Util.TokenizerString(setValue2, " ");
if(docContentList!=null&&docContentList.size()>0)
{
	for(int i=0;i<docContentList.size();i++)
	{
		String doccontent = (String)docContentList.get(i);
		summarySql += summarySql.equals("")?" docsubject like '%"+doccontent+"%' ":" or docsubject like '%"+doccontent+"%' ";
	}
	if(!summarySql.equals(""))
	{
		summarySql =" and ("+summarySql+") ";
	}
}
//订阅期限
String summarydateSql = "";
if(!setValue3.equals(""))
{
	summarydateSql +=" and doccreatedate>='"+setValue3+"' ";
}
if(!setValue4.equals(""))
{
	summarydateSql +=" and doccreatedate<='"+setValue4+"' ";
}
//文档权限
String sharesql = ShareManager.getShareDetailTableByUser("doc",user);

//多文档目录
String secids=srcContent;
if(!secids.equals(""))
{
	if(",".equals(secids.substring(0,1)))
		secids=secids.substring(1);
}
else
{
	secids = "-1";
}
if ("oracle".equals(rs.getDBType())) 
{    
    sqlFrom=" (select * from (select distinct docsubject," +
    		"							doccreatedate," +
    		"							doclastmoddate," +
    		"							doclastmodtime," +
    		"							id," +
    		"							doccreatedate as startdate," +
    		"							doclastmoddate as enddate," +
    		"							doccreaterid," +
    		"							usertype " +
    		"					  from docdetail t1,"+sharesql+" t2   " +
    		"		     		  where docstatus in ('1','2','5')  and (t1.isreply!=1 or  t1.isreply is null) "+summarySql+summarydateSql+"  " +
    		"	   				    and maincategory!=0  " +
    		"	   					and subcategory!=0 " +
			"	   					and seccategory!=0 " +
			"      					and exists (select id from docseccategory where id = seccategory and id in ("+secids+")) " +
			"	   					and t1.id=t2.sourceid   " +
			"	  					and   t1.doccreaterid!="+user.getUID()+"" +
			"				) a ," +
			"				(select docid, max(operatedate) as operatedate,max(operatetime) as operatetime "+
			"				  from DocDetailLog "+
			"				 where operateuserid = "+user.getUID()+
			"				   and usertype=1" +
			"				 group by docid) b ";
    sqlWhere=" a.id=b.docid(+) and (a.doclastmoddate >b.operatedate or (a.doclastmoddate = b.operatedate and a.doclastmodtime >b.operatetime) or b.docid is null)) table1";
    backFields="table1.*";
} 
else 
{
    sqlFrom="from (select distinct docsubject," +
    		"			  doccreatedate," +
    		"			  doclastmoddate," +
    		"			  doclastmodtime," +
    		"			  id," +
    		"			  doccreatedate as startdate," +
    		"			  doclastmoddate as enddate," +
    		"			  doccreaterid," +
    		"			  usertype from docdetail t1,"+sharesql+" t2    " +
    		"	     where  docstatus in ('1','2','5')  and (t1.isreply!=1 or  t1.isreply is null) "+summarySql+summarydateSql+" " +
    		"		   and maincategory!=0  " +
    		"			and subcategory!=0 " +
    		"			and seccategory!=0  " +
    		"			and exists (select id from docseccategory where id = seccategory and id in ("+secids+")) " +
    		"			and t1.id=t2.sourceid  " +
    		" 			and  t1.doccreaterid!="+user.getUID()+") a " +
    		"	left outer join (select docid, max(operatedate) as operatedate,max(operatetime) as operatetime "+
			"				  		from DocDetailLog "+
			"				 	  where operateuserid = "+user.getUID()+
    		"			  		    and usertype=1" +
    		"					  group by docid) b " +
    		"	on a.id=b.docid ";
    sqlWhere="  (a.doclastmoddate >b.operatedate or (a.doclastmoddate = b.operatedate and a.doclastmodtime >b.operatetime)) or b.docid is null ";
    backFields="*";
}



String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = hpec.getTitle(eid);
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

		<TABLE width=100% height=100% border="0" cellspacing="0">
			<colgroup>
				<col width="10">
				<col width="">
				<col width="10">
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
			<tr>
				<td></td>
				<td valign="top">
					<form name="frmSubscribleHistory" method="post" action="">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<!--列表部分-->
									<%
                          	String userid=user.getUID()+"" ;
							String loginType = user.getLogintype() ;
                          	String userInfoForotherpara =loginType+"_"+userid;  
                            String tableString=""+
                                       "<table  pagesize=\""+perpage+"\" tabletype=\"none\">"+
                                       "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\"doclastmoddate,doclastmodtime\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\" />"+
                                       "<head>"+
                                             "<col width=\"3%\"  text=\" \" column=\"docid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIcon\"/>"+
                                             "<col name=\"id\" width=\"21%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocNameAndIsNewByDocIdSS\" otherpara=\""+userInfoForotherpara+"\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" />"+
                                             "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(271,user.getLanguage())+"\" column=\"doccreaterid\" orderkey=\"doccreaterid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\"  otherpara=\"column:usertype\"/>"+
                                             "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\"  column=\"doccreatedate\" orderkey=\"doccreatedate,doccreatetime\"/>"+
											 "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19521,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate,doclastmodtime\"/>"+
                                       "</head>"+
                                       "</table>";                                             
                              %>
									<TABLE width="100%">
										<TR>
											<TD valign="top">
												<wea:SplitPageTag tableString='<%=tableString%>' mode="run" />
											</TD>
										</TR>
									</TABLE>
								</td>
							</tr>
						</TABLE>
					</form>
				</td>
				<td></td>
			</tr>
			<tr>
				<td height="10" colspan="3"></td>
			</tr>
		</table>
	</BODY>
</HTML>
