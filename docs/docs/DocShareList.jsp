
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %> 
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="page" />
<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>

<HTML>
	<HEAD>
	    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	</HEAD>
 
<%
   
    String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(58,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(356,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

    //接收值
    int sharetype = Util.getIntValue(request.getParameter("sharetype"),0) ;
    int doccreaterid = Util.getIntValue(request.getParameter("doccreaterid"),0) ;
    int usertype = Util.getIntValue(request.getParameter("usertype"),0) ;   
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(364,user.getLanguage())+",javascript:location.href='../search/DocSearch.jsp',_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<COLGROUP>
<COL width="10">
<COL width="">
<COL width="10">
<TR>
    <TD height="10" colspan="3"></TD>
</TR>
<TR>
    <TD></TD>
    <TD valign="top">
         <TABLE class=Shadow>
            <TR>
                <TD valign="top">
                    <%      //分页         
                           int perpage = UserDefaultManager.getNumperpage();
                           
                           if(perpage <2) perpage=10;      
                           String sqlFrom =""; 
                           String sqlWhere =""; 
                           String backfields ="t1.id,t1.docextendname, t1.docsubject,t1.doccreaterid,t1.doccreatedate,t1.doclastmoddate,t1.replaydoccount,t1.accessorycount,t1.docpublishtype";
                           switch (sharetype) {
                               case 1 :   //分享给别人的文档数量
                                   sqlFrom="from DocDetail  t1 ";
                                   sqlWhere ="where id in (select distinct id from DocDetail  t1, "+tables+"  t2 where t1.docstatus in ('1','2','5') and (t1.ishistory is null or t1.ishistory = 0) and t1.id=t2.sourceid and t1.ownerid="+doccreaterid+" and t1.usertype='"+usertype+"')";
                                   break ;
                               case 2 :   //分享别人的文档数量
                                    sqlFrom=" from DocDetail  t1 ";
                                    sqlWhere=" where id in (select distinct id from DocDetail  t1, "+tables+"  t2 where t1.docstatus in ('1','2','5') and (t1.ishistory is null or t1.ishistory = 0) and t1.id=t2.sourceid and t1.doccreaterid!="+doccreaterid+")";
                                   break ;
                               case 3 :  //  回复的别人文档主题共计
                                    sqlFrom="  from DocDetail t1";
                                    sqlWhere=" where docstatus in ('1','2','5') and (ishistory is null or ishistory = 0) and ownerid="+doccreaterid+" and usertype="+usertype+" and isreply='1' and not exists (select * from docdetail where id=t1.replydocid and ownerid=t1.ownerid and usertype=t1.usertype)";
                                    break ;
                               case 4 :  //  回复的文档数量
                                    sqlFrom=" from DocDetail t1";
                                    sqlWhere=" where docstatus in ('1','2','5') and (ishistory is null or ishistory = 0) and ownerid="+doccreaterid+" and usertype="+usertype+" and isreply='1'";
                                    break ;
                            } 

                            String tableString =" <table instanceid=\"DocShareListTable\" tabletype=\"none\" pagesize=\""+perpage+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+sqlFrom+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\"doclastmoddate\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "              <col width=\"3%\"   text=\" \" column=\"docextendname\" orderkey=\"docextendname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocIconByExtendName\"/>"+
                                                 "				<col name=\"id\" width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(58,user.getLanguage())+"\" column=\"id\" orderkey=\"docsubject\" target=\"_fullwindow\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocName\" href=\"/docs/docs/DocDsp.jsp\" linkkey=\"id\" />"+
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(79,user.getLanguage())+"\" column=\"doccreaterid\" orderkey=\"doccreaterid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getHrmname\" href =\"/hrm/resource/HrmResource.jsp\"  linkkey=\"id\" target=\"_fullwindow\"/>"+
                                                 "				<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"doccreatedate\" orderkey=\"doccreatedate\"/>"+
                                                 "				<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(723,user.getLanguage())+"\" column=\"doclastmoddate\" orderkey=\"doclastmoddate\"/>"+
                                                 "				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(18470,user.getLanguage())+"\" column=\"replaydoccount\" orderkey=\"replaydoccount\"/>"+
                                                  "				<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(2002,user.getLanguage())+"\" column=\"accessorycount\" orderkey=\"accessorycount\"/>"+
                                                 "			    <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(19789,user.getLanguage())+"\" column=\"docpublishtype\" orderkey=\"docpublishtype\"  transmethod=\"weaver.splitepage.transform.SptmForDoc.getDocPublicType\" otherpara=\""+user.getLanguage()+"\"/>"+
                                                 "			</head>"+   			
                                                 "</table>"; 
                          %>
                          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>   
                </TD>
            </TR>            
         </TABLE>
    </TD>
    <TD></TD>
</TR>
<TR>
    <TD height="10" colspan="3"></TD>
</TR>
</BODY>
</HTML>
