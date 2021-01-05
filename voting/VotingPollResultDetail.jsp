
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.voting.bean.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="vcm" class="weaver.voting.VotingCollectManager" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(356,user.getLanguage());
String needfav ="1";
String needhelp ="";

//是否查看结果。1 为查看结果
String viewResult = Util.null2String(request.getParameter("viewResult"));

boolean islight=true ;
String userid=user.getUID()+"";
String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String questionid=Util.fromScreen(request.getParameter("questionid"),user.getLanguage());
String chiefType = Util.null2String(request.getParameter("chiefType"));
String rchiefId = Util.null2String(request.getParameter("chiefId"));
vcm.setVotingId(votingid);
vcm.setChiefType(chiefType);
vcm.setChiefId(rchiefId);
vcm.setQuestionid(questionid);
VotingBean vb = vcm.getVotingDetailBean();
String chiecfDetailSql = vcm.getChiecfDetailSql();
RecordSet.executeSql(chiecfDetailSql);
RecordSet.next();
String subject=RecordSet.getString("subject");
String createrid=RecordSet.getString("createrid");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String isanony=RecordSet.getString("isanony");
String docid=RecordSet.getString("docid");
String crmid=RecordSet.getString("crmid");
String projectid=RecordSet.getString("projid");
String requestid=RecordSet.getString("requestid");
int votingcount = Util.getIntValue(RecordSet.getString("votingcount"),0);
String status = RecordSet.getString("status");
String sql = "select v.* From Voting v where  v.id = "+votingid;
RecordSet.executeSql(sql);
RecordSet.next();
String detail = RecordSet.getString("detail");
if(null==subject||"".equals(subject))
	subject = RecordSet.getString("subject");
if(null==isanony||"".equals(isanony))
	isanony = RecordSet.getString("isanony");
if(0==votingcount)
	votingcount = Util.getIntValue(RecordSet.getString("votingcount"),0);

//获取问题名称 questionname
String questionname = "";
sql = "select * from votingquestion where id="+questionid;
RecordSet.executeSql(sql);
RecordSet.next();
questionname = RecordSet.getString("subject");

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>



<%if("1".equals(viewResult)){%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value='<%=questionname+"-"+ SystemEnv.getHtmlLabelName(2121,user.getLanguage())%>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>
<%} %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form name=frmmain action="VotingPollOperation.jsp" method=post>
<input type=hidden name=method value="polledit">
<input type=hidden name=votingid value="<%=votingid%>">
<TABLE class="LayoutTable" cellspacing="0" style="table-layout: fixed;margin-top:-5px !important;">
      <colgroup>
        <col width="0">
          <col width="100%">
            <col width="0">
              <tr>
                <td></td>
                <td valign="top">  
                <form name="frmSubscribleHistory" method="post" action="">
                  <TABLE  class="LayoutTable" >
                    <tr>
                      <td valign="top">

<table class="ListStyle" cellspacing="0" >
<col width=25%><col width=55%><col width=10%><col width=10%>
  <TR class=header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(18606,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%>&nbsp;<%=votingcount%>&nbsp;<%=SystemEnv.getHtmlLabelName(18608,user.getLanguage())%>)</TH>
  </TR>
<%
List votingQuestions = vb.getVotingQuestions();
Map votingOptions = vb.getVotingOptions();
List votingPersons = vb.getVotingPerson();
List otherVotingPersons = vb.getOtherVotingPerson();
Map allVotingOptions = vb.getAllVotingOptions();
if(votingQuestions!=null&&votingQuestions.size()>0)
{
	for(Iterator i = votingQuestions.iterator();i.hasNext();)
	{
		VotingQuestionBean vqb = (VotingQuestionBean)i.next();
		String q_subject = vqb.getSubject();
		String q_description = vqb.getDescription();
		String q_ismulti = vqb.getIsmulti();
		String q_isother = vqb.getIsother();
		int q_count = vqb.getCount();
%>
  <tr class=header>
    <td colspan=4><b><%=q_subject%></b><%if(!q_description.equals("")){%>(<%=q_description%>)<%}%></td>
  </tr>
<%
		List voList = (List)allVotingOptions.get(questionid);
		if(null!=voList&&voList.size()>0)
		{
			int count = 1;
			for(Iterator k = voList.iterator();k.hasNext();)
			{
				VotingOptionBean vob = (VotingOptionBean)k.next();
				String tquestionid = vob.getQuestionid();
				String optionid = vob.getOptionid();
				String o_desc = vob.getOptiondesc();
				int o_count = 0;
				String tchiefid = vob.getChiefId();
				List votingOptionList = (List)votingOptions.get(questionid);
				if(null!=votingOptionList&&votingOptionList.size()>0)
				{
					for(Iterator l = votingOptionList.iterator();l.hasNext();)
					{
						VotingOptionBean lvob = (VotingOptionBean)l.next();
						String lquestionid = lvob.getQuestionid();
						String loptionid = lvob.getOptionid();
						if(!loptionid.equals(optionid))
						{
							continue;
						}
						String lo_desc = lvob.getOptiondesc();
						int lo_count = lvob.getOptioncount();
						String ltchiefid = lvob.getChiefId();
						if(loptionid.equals(optionid))
						{
							o_count = lo_count;
						}
					}
				}
		        
		        float percent=0;
		        if (votingcount!=0){
		            percent = (float)((o_count*1000)/votingcount)/10 ;
		        } else {
		            percent = 0;
		        }        
		        String classgraph = "";
		        if((count%4)==1) classgraph = "/images/BDStatRed_wev8.jpg";
		        if((count%4)==2) classgraph = "/images/BDStatBlue_wev8.jpg";
		        if((count%4)==3) classgraph = "/images/BDStatGreen_wev8.jpg";
		        if((count%4)==0) classgraph = "/images/BDStatYellow_wev8.jpg";
%>
  <tr class=datalight>  
    <td>  
    <%=count%>.<%=o_desc%>
    </td>
    <td>
        <%if(percent>0){%>
        <TABLE height="100%" cellSpacing=0 width="100%"><TBODY>
        <TR>
          <TD <%if(percent<=1){%>width="1%"<%}else{%>width="<%=percent%>%" <%}%>>
          <img src="<%=classgraph%>" height="15" align=center border=0 width="<%=percent%>%"></TD>
          <TD>&nbsp;</TD>
        </TR>
        </TBODY></TABLE>
        <%} else {%>
        &nbsp;
        <%}%>
    </td>
    <td><%=percent%>%</td>
    <td><%=o_count%>&nbsp;<%=SystemEnv.getHtmlLabelName(18607,user.getLanguage())%></td>
  </tr>     
  <tr class=datadark>
    <td colspan=4 style="background: #ECFDEA;">&nbsp;&nbsp;&nbsp;&nbsp;<img border=0 src="/images/ArrowRightBlue_wev8.gif"></img><%=SystemEnv.getHtmlLabelName(18610,user.getLanguage())%>：   
<%
			if (Util.getIntValue(isanony, 0) != 1)
			{
				if(null!=votingPersons&&votingPersons.size()>0)
				{
					for(Iterator m = votingPersons.iterator();m.hasNext();)
					{
						VotingUserBean vub = (VotingUserBean)m.next();
						String tmpuserid =	vub.getUserid();
						String tmpanony = vub.getUseranony();
						String ooptionid = vub.getOptionid();
						if(!optionid.equals(ooptionid))
						{
							continue;
						}
%>
  
  <%if(tmpanony.equals("1")){%><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%>,
  <%}else{%><a href="VotingPollResultUser.jsp?hrmid=<%=tmpuserid%>&votingid=<%=votingid%>" target="_blank"><%=ResourceComInfo.getResourcename(tmpuserid)%></a>,<%}%>
<%            
        	}
		}
    } else {
%><%=SystemEnv.getHtmlLabelName(18612,user.getLanguage())%><%    
    }        
%>
    </td>  
  </tr>
<%        
		        count++;
		    }    
		}
if(q_isother.equals("1")){
%>
  <tr class=datalight>
    <td colspan=4><font color=red><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></font></td>
  </tr>  
<%
if(otherVotingPersons!=null&&otherVotingPersons.size()>0)
{
	for(Iterator m = otherVotingPersons.iterator();m.hasNext();)
	{
		VotingUserBean vub = (VotingUserBean)m.next();
		String resourceid = vub.getUserid();
		String useranony = vub.getUseranony();
		String otherinput = vub.getOtherinput();
		String operatedate = vub.getOperatedate();
		String operatetime = vub.getOperatedate();
%>
  <tr class=datadark>
    <td style="background: #ECFDEA;"><%if(useranony.equals("1")){%><%=SystemEnv.getHtmlLabelName(18611,user.getLanguage())%><%}else{%><%=ResourceComInfo.getResourcename(resourceid)%><%}%>
    <br><%=operatedate%>  <%=operatetime%></td>
    <td colspan=3 style="background: #ECFDEA;"><%=Util.toScreen(otherinput,user.getLanguage())%></td>
  </tr>  
<%        
				}
			}
		}
	}
}
%> 
</table>
                     </td>
                    </tr>
                  </TABLE>  
                  </form>
                </td>
                <td></td>
              </tr>
              <tr>
                <td height="5" colspan="3"></td>
              </tr>
            </table>
</form>
</body>
</html>
