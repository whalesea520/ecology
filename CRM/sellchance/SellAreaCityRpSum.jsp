<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<% 
String imagefilename = "/images/hdReport_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(6146,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(15114,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(493,user.getLanguage())+"-"+ "<a href='/CRM/sellchance/SellAreaProRpSum.jsp' >"+SystemEnv.getHtmlLabelName(800,user.getLanguage())+"</a>";
String needfav ="1";
String needhelp ="";

int linecolor=0;
int total=0;


int resource=Util.getIntValue(request.getParameter("viewer"),0);
String resourcename=ResourceComInfo.getResourcename(resource+"");
String fromdate=Util.fromScreen(request.getParameter("fromdate"),user.getLanguage());
String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
String sqlwhere="";
String sqlwhere_0="";

if(resource!=0){
	sqlwhere =" and t1.manager="+resource;
    sqlwhere_0 +=" and t1.manager="+resource;
}
if(!fromdate.equals("")){	
    sqlwhere_0 +=" and t3.startDate>='"+fromdate+"'";
}
if(!enddate.equals("")){
    sqlwhere_0 +=" and t3.startDate<='"+enddate+"'";
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


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

<form id=weaver name=frmmain method=post action="SellAreaCityRpSum.jsp">
<div style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:weaver.submit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<BUTTON class=btnRefresh type="submit" accesskey="R"><U>R</U>-<%=SystemEnv.getHtmlLabelName(354,user.getLanguage())%></BUTTON>
</div>

<table class=ViewForm>
<tbody>
<TR><TD class=Line1 colSpan=6></TD></TR>
<tr>
    <%if(!user.getLogintype().equals("2")){%>
    <td width=10%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    <td class=field ><button class=browser onClick="onShowResource()"></button>
    <span id=viewerspan><a href="/hrm/resource/HrmResource.jsp?id=<%=resource%>"><%=Util.toScreen(resourcename,user.getLanguage())%></a></span>
    <input type=hidden name=viewer value="<%=resource%>"></td>
    <%}%>

    <td width=15%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></td>
    <td class=field>
    <BUTTON class=calendar id=SelectDate onclick=getfromDate()></BUTTON>&nbsp;
    <SPAN id=fromdatespan ><%=Util.toScreen(fromdate,user.getLanguage())%></SPAN>
    <input type="hidden" name="fromdate" value=<%=fromdate%>>
    －<BUTTON class=calendar id=SelectDate onclick=getendDate()></BUTTON>&nbsp;
    <SPAN id=enddatespan ><%=Util.toScreen(enddate,user.getLanguage())%></SPAN>
    <input type="hidden" name="enddate" value=<%=enddate%>>  
    </td >
</TR><tr><td class=Line colspan=6></td></tr>
</tbody>
</table>


<TABLE class=ListStyle width="100%" cellspacing=1>
  <COLGROUP>
  <COL align=left width="30%">
  <COL align=left width="30%">
  <COL align=left width="10%">
  <COL align=left width="15%">
  <COL align=left width="15%">
  <TBODY>
    <TR class=header >
    <TH colspan=5><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>：<%=SystemEnv.getHtmlLabelName(15245,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(15246,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(352,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(363,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>)</TH>
    <TH><%=SystemEnv.getHtmlLabelName(15247,user.getLanguage())%></TH>
    <TH>%</TH>
    </TR>
<TR class=Line><TD colSpan=5></TD></TR>
<%
String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
    String sql_id ="";
    if(sqlwhere.equals("")){
        sql_id ="select  distinct t2.id conids from CRM_CustomerInfo t1,CRM_Contract t2  ,"+leftjointable+" t3 where  t2.crmId = t3.relateditemid and t2.crmId = t1.id and t1.city <> 0   and t2.status >=2";
    }else{
        sql_id ="select  distinct t2.id conids from CRM_CustomerInfo t1,CRM_Contract t2  ,"+leftjointable+" t3 where  t2.crmId = t3.relateditemid and t2.crmId = t1.id and t1.city <> 0   and t2.status >=2" +sqlwhere;
    }
    String C_ids="";
    RecordSet.executeSql(sql_id);

    while(RecordSet.next()){
        C_ids += "," + RecordSet.getString("conids");
     
    }
    if(!C_ids.equals("")) C_ids = C_ids.substring(1);  
  

    String sql_totel="select sum(price) totel  from CRM_Contract where id in ("+C_ids+")";
    RecordSet.executeSql(sql_totel);
    RecordSet.next();
    float totel= Util.getFloatValue(RecordSet.getString("totel"),0);//计算总业绩
	
if(totel!=0){
    String sqlstr = "";
    if(sqlwhere_0.equals("")){
	    sqlstr = "select t1.city   cityid,COUNT(distinct t1.id)   crmids,sum(t3.price) everysum   from CRM_CustomerInfo  t1,HrmCity  t2  ,CRM_Contract t3  ,"+leftjointable+" t4 where t3.crmId = t4.relateditemid and t1.city =t2.id  and t3.crmId=t1.id and t3.status>=2  group by t1.city order by crmids";
    }else{
        sqlstr = "select t1.city   cityid,COUNT(distinct t1.id)   crmids,sum(t3.price) everysum   from CRM_CustomerInfo  t1,HrmCity  t2  ,CRM_Contract t3  ,"+leftjointable+" t4 where t3.crmId = t4.relateditemid and t1.city =t2.id  and t3.crmId=t1.id and t3.status>=2 "+sqlwhere_0+" group by t1.city order by crmids";
    }

	
	RecordSet.executeSql(sqlstr);
        
    RecordSet.first();
	do{ 
        String cityid = RecordSet.getString("cityid");//某个城市
        String crmsum = RecordSet.getString("crmids"); //客户的个数
        String Display_sum = RecordSet.getString("everysum");
        float sum_every = Util.getFloatValue(RecordSet.getString("everysum"),0);//某个省份的客户的合同的金额的总和

       
        float per=sum_every/totel*100;
        per=(float)((int)(per*100))/(float)100;
						float resultpercentOfwidth=0;
						resultpercentOfwidth = per;
						if(resultpercentOfwidth<1&&resultpercentOfwidth>0) resultpercentOfwidth=1;

%>
  <%if(per!=0){%>
    <tr <%if(linecolor==0){%>class=datalight <%} else {%> class=datadark <%}%> >
        <td><%=Util.toScreen(CityComInfo.getCityname(cityid),user.getLanguage())%></td>
        <td height=100%>
            <TABLE height="100%" cellSpacing=0 
                <%if(per==100){%>
                class=redgraph 
                <%}else{%>
                class=greengraph 
                <%}%>
                width="<%=resultpercentOfwidth%>%">                       
            <TBODY>
            <TR>
              <TD width="100%" height="100%"><img src="/images/ArrowUpGreen_wev8.gif" width=1 height=1></td>
             </TR>
             </TBODY>
             </TABLE>
        
        </td>
        <td><%=crmsum%></td>
        <td><%=Display_sum%></td>
        <td><%=per%>%</td>
    </tr>
    <%}%>
    <%		if(linecolor==0) linecolor=1;
    		else	linecolor=0;
    		}while(RecordSet.next());
	} %>




  </TBODY></TABLE>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
  </BODY>
    </form>
	<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
    <SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
  <script language=vbs>  
sub onShowResource()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	viewerspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.viewer.value=id(0)
	else 
	viewerspan.innerHtml = ""
	frmmain.viewer.value=""
	end if
	end if
end sub

</script>
  </HTML>
 