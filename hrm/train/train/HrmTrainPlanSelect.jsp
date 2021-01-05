<%@ page import="weaver.general.Util,
                 java.text.SimpleDateFormat" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="TrainLayoutComInfo" class="weaver.hrm.train.TrainLayoutComInfo" scope="page" />
<jsp:useBean id="TrainPlanComInfo" class="weaver.hrm.train.TrainPlanComInfo" scope="page" />
<%
//if(!HrmUserVarify.checkUserRight("HrmTrainAdd:Add", user)){
//    		response.sendRedirect("/notice/noright.jsp");
//    		return;
//	}
%>	
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
int userid = user.getUID();

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String nowdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(82,user.getLanguage())+
":"+ SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(678,user.getLanguage())+ ":"+SystemEnv.getHtmlLabelName(172,user.getLanguage())+SystemEnv.getHtmlLabelName(532,user.getLanguage())+SystemEnv.getHtmlLabelName(6103,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/train/train/HrmTrain.jsp,_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
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

<FORM id=weaver name=frmMain action="HrmTrainPlamSelect.jsp" method=post>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="50%">
  <COL width="50%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(6128,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(6156,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="2" ></TD></TR> 
<%
    /**
     * Modified By Charoes Huang
     * 只能选择未结束的，当前用户为操作者或者创建者的培训计划
     */
    String currentDate ="";
    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd") ;
    currentDate = format.format(Calendar.getInstance().getTime());
    String sql = "select * from HrmTrainPlan WHERE (','+planorganizer+',' like '%,"+userid+",%' or createrid = "+userid+") and (planenddate>='"+currentDate+"' or planenddate='')  order by layoutid DESC,planstartdate desc";
   
	if(rs.getDBType().equals("oracle")){
		sql = "SELECT * FROM HrmTrainPlan WHERE (concat(concat(',',planorganizer),',') like '%,"+userid+",%' or createrid = "+userid+") and (planenddate>='"+currentDate+"' or planenddate is null)";
	}
	rs.executeSql(sql);
    
    int needchange=0;
    int isfirst = 1;
    int flag = 0;
    while(rs.next()){
      String id = Util.null2String(rs.getString("id"));
      String layoutid = Util.null2String(rs.getString("layoutid"));      
      //if(!TrainPlanComInfo.isOperator(id,userid)) continue;
      String name = Util.null2String(rs.getString("planname"));       
      if(flag != Util.getIntValue(layoutid)){
        isfirst = 1;
        flag = Util.getIntValue(layoutid);
      }
      if(needchange%2==0){
%>
  <TR class=datalight>  
<%
      }else{
%>  
   <TR class=datadark>  
<%
      }
%>
    <TD>
<%
  if(isfirst == 1){
    isfirst = 0;
%>    
      <%=TrainLayoutComInfo.getLayoutname(layoutid)%>
<%
  }
%>      
    </TD>
    <TD><a href="/hrm/train/train/HrmTrainAdd.jsp?planid=<%=id%>"><%=name%></a></TD>    
  </TR>
<%   
    needchange++;
    }	
%>  


</TBODY>
</TABLE>
<BR>
</form>
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
</BODY>
</HTML>
