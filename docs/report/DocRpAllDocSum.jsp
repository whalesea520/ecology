<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SplitPageUtil" class="weaver.general.SplitPageUtil" scope="page" />
<jsp:useBean id="SplitPageParaBean" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
//System.out.println("***********************************************************************");
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16244,user.getLanguage());
String needfav ="1";
String needhelp ="";
int prepage = 10 ;

int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;

char separator = Util.getSeparator() ;
String fromdate=request.getParameter("fromdate");
String todate=request.getParameter("todate");
int userid=user.getUID();

if(fromdate == null){
    if(session.getAttribute("DocRpAllDocSum_fromdate")==null){
        session.setAttribute("DocRpAllDocSum_fromdate","");
        fromdate = "";
    }else{
        fromdate = session.getAttribute("DocRpAllDocSum_fromdate").toString();
    }
}

if(todate == null){
    if(session.getAttribute("DocRpAllDocSum_todate")==null){
        session.setAttribute("DocRpAllDocSum_todate","");
        todate = "";
    }else{
        todate = session.getAttribute("DocRpAllDocSum_todate").toString();
    }
}
if(fromdate.equals(""))	fromdate="0000-00-00";
session.setAttribute("DocRpAllDocSum_fromdate",fromdate);

if(todate.equals(""))	todate="9999-99-99";
session.setAttribute("DocRpAllDocSum_todate",todate);
//String optional="customersize";
int linecolor=0;
int total=0;
float resultpercent=0;
//System.out.println("fromdate:"+fromdate);
//System.out.println("todate:"+todate);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/docs/common.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:document.report.submit(),_top} " ;
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

<form id=report name=report method=post action="DocRpAllDocSum.jsp" >

<TABLE class=ViewForm width="100%">
  <COLGROUP>
  <COL align=left width="15%">
  <COL align=left width="33%">
  <COL align=left width="5">
  <COL align=left width="15%">
  <COL align=left width="33%">
  <TBODY>
  <TR class=Title>
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH>
  </TR>
  <TR class=Spacing  style="height:2px">
    <TD class=Line1 colspan=5></TD></TR>
  <tr>
     <td><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></td>
     <TD class=field><BUTTON type="button" class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
      <SPAN id=fromdatespan ><%if(!fromdate.equals("0000-00-00")){%><%=fromdate%><%}%></SPAN>
      -&nbsp;&nbsp;<BUTTON  type="button" class=calendar id=SelectDate2 onclick="gettoDate()"></BUTTON>&nbsp;
      <SPAN id=todatespan><%if(!todate.equals("9999-99-99")){%><%=todate%><%}%></SPAN>
	  <input type="hidden" name="fromdate" value="<%=fromdate%>">
	  <input type="hidden" name="todate" value="<%=todate%>">
      <%//out.print(fromdate) ;
        //out.print(todate);%>
    </TD>
    <td>&nbsp;</td>
    <td colspan=2>&nbsp;</td>
  </tr>
  <TR style="height:2px"><TD class=Line colSpan=5></TD></TR>
  </tbody>
</table>

<table class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL align=left width="20%">
  <COL align=left width="15%">
  <COL align=left width="12%">
  <COL align=left width="8%">
  <COL align=left width="40%">
  <COL align=left width="5%">
  <tbody>
  <TR class=header>
    <TH colspan=6><%=SystemEnv.getHtmlLabelName(356,user.getLanguage())%></TH>
  </TR>
  <tr class=Header>
    <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>  <!--主题 -->
    <td><%=SystemEnv.getHtmlLabelName(65,user.getLanguage())%></td>   <!--主目录 -->
    <td><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>   <!--部门 -->
    <td><%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%></td>    <!--创建者 -->
    <td colspan=2><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%></td> <!--计数 -->
  </tr>

  <TR class=Line><TD colSpan=6></TD></TR>
<%

SplitPageParaBean.setBackFields("docid, SUM(readCount) AS COUNT ");
SplitPageParaBean.setSqlFrom("docReadTag");

if (fromdate.equals("0000-00-00") && todate.equals("9999-99-99")) {
	SplitPageParaBean.setSqlWhere("where docid in (select t1.id from docdetail t1,"+tables+" t2 where t1.id=t2.sourceid  )");
} else {
   SplitPageParaBean.setSqlWhere("where docid in (select t1.id from docdetail t1,"+tables+" t2 where doccreatedate >='" + fromdate + "' AND doccreatedate <='" + todate + "' and t1.id=t2.sourceid  and docid in (SELECT docid     FROM DocDetailLog ))");
}



SplitPageParaBean.setPrimaryKey("id");
SplitPageParaBean.setSortWay(SplitPageParaBean.DESC);
SplitPageParaBean.setSqlOrderBy("COUNT,docid");
SplitPageParaBean.setSqlGroupBy(" GROUP BY docid ");

SplitPageUtil.setSpp(SplitPageParaBean);
total=SplitPageUtil.getRecordCount();
rs=SplitPageUtil.getCurrentPageRs(pagenum,prepage);


/***************************此处取出各记录按每篇文档被阅读次数的总和来求********************************/
   String count_read =" " ;
   String docid_read =" ";
   String docSubject_name = " ";
   int maincategory_id = -1;
   int docdepartment_id = -1;
   int doccreater_id = -1;
   
        int i=1;
            while (rs.next()) {
                i++;
            docid_read = Util.null2String(rs.getString("docid")) ;
            docid_read = docid_read.trim() ;
            count_read = Util.null2String(rs.getString("COUNT") ) ;
            rs1.executeProc("docDetail_QueryByDocid",""+ docid_read) ;
            if (rs1.next()) {
                docSubject_name = Util.null2String(rs1.getString("docSubject")) ;
                maincategory_id = rs1.getInt("maincategory") ;
                docdepartment_id = rs1.getInt("docdepartmentid") ;
                doccreater_id= rs1.getInt("doccreaterid") ;
            }

            String maincategory_name = MainCategoryComInfo.getMainCategoryname(""+maincategory_id) ;
            String docdepartment_name = DepartmentComInfo.getDepartmentname(""+docdepartment_id) ;
            String doccreater_name= ResourceComInfo.getResourcename(""+doccreater_id) ;
            resultpercent=(float)Util.getIntValue(count_read)*100/(float)total;
            resultpercent=(float)((int)(resultpercent*100))/(float)100;



            //System.out.println("  ");
            //System.out.println("docid_read is " +docid_read);
            //System.out.println("count_read is " +count_read);
            //System.out.println("docSubject_name is " +docSubject_name);
            //System.out.println("maincategory_id is " +maincategory_id);
            //System.out.println("docdepartment_id is " +docdepartment_id);
            //System.out.println("doccreater_id is " +doccreater_id);
            //System.out.println("maincategory_name is" +maincategory_name);
            //System.out.println("doccreater_name is" +doccreater_name);
            //System.out.println("resultpercent is" +resultpercent);

            %>
                <%if(i%2==0){%>
                <tr class=dataLight>
                <%}else{%>
                <tr class=dataDark>
                <%}%>
            <TD>
            <%if(docid_read.equals("")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
            <a href="/docs/docs/DocDsp.jsp?id=<%=docid_read%>"><%=docSubject_name%></a><%}%></TD>

            <TD>
            <%if(maincategory_name.equals("")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%> <%=maincategory_name%><%}%></TD>

            <TD>
            <%if(docdepartment_name.equals("")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
            <%=docdepartment_name%><%}%> </TD>

            <TD>
            <%if(doccreater_name.equals("")){%><%=SystemEnv.getHtmlLabelName(557,user.getLanguage())%><%} else {%>
            <a href="javaScript:openhrm(<%=doccreater_id%>);" onclick='pointerXY(event);'><%=doccreater_name%></a><%}%></TD>
            <TD>
              <TABLE height="100%" cellSpacing=0 width="100%">
                <TBODY>
                <TR>
                <% float resultpercent1 =resultpercent ;
                if(resultpercent<1)	resultpercent=1;%>
                  <TD class=redgraph width="<%=resultpercent%>%"></TD>
                  <td><%=resultpercent1%>%</td>
                </tr></tbody></table>
            </td>

            <td><%if(count_read!=""){%><a href="/docs/report/DocReadRp.jsp?flag=1&sqlwhere=<%=xssUtil.put(java.net.URLEncoder.encode("where docid="+docid_read))%>"><%=count_read%></a>
            <%} else {%><%=count_read%><%}%></td>
            </TR>
            <%	if(linecolor==0) linecolor=1;
                 else linecolor=0;
      }
         %>
  </TBODY></TABLE>
</form>
<TABLE width="100%" border=0>
  <TBODY>
  <TR>
    <TD noWrap>
    <%  out.println(Util.makeNavbar2(pagenum, total , prepage, "DocRpAllDocSum.jsp"));%>
    </TD>
  </TR>
  </TBODY>
</TABLE>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<br>
</BODY>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
<%// System.out.println("***********************************************************************");%>
