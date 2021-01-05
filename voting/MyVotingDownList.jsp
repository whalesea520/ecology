
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.systeminfo.setting.HrmUserSettingComInfo" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="UserDefaultManager" class="weaver.docs.tools.UserDefaultManager" scope="session" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />


<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";

String subject = Util.null2String(request.getParameter("subject"));


//votingtype 调查类型
String votingtype =Util.null2String(request.getParameter("votingtype"));
// 状态过滤
String status = Util.null2String(request.getParameter("status"));

//开始日期
String begindate = Util.null2String(request.getParameter("begindate"));
//截止日期
String enddate = Util.null2String(request.getParameter("enddate"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="../../js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="../../js/selectDateTime_wev8.js"></script>


<script type="text/javascript">

		function onBtnSearchClick(){
			jQuery('#weaver').submit();
		}
</script>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<FORM id=weaver name=weaver method=post action="MyVotingDownList.jsp">
<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Voting_VotingDoneListTable %>"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="30%"/>
		<col width="*"/>
	</colgroup>
	<tbody>
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			     <input type="text" id="searchInput" name ="subject" class="searchInput"  value="<%=subject %>"/>
				&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"   class="cornerMenu"></span>
		</td>
	</tr>
	</tbody>
</table>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    <div class="advancedSearchDiv" id="advancedSearchDiv"  >

	             
				  <wea:layout type="4col">
				      <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
				         //名称
				         <wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
				         <wea:item>
				              <input type="text" name="subject"  style='width:80%' value="<%=Util.null2String(request.getParameter("subject"))%>">
				         </wea:item>
				       
				         
				      
			             
			             //状态
				    	 <wea:item><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
				    	 <wea:item>
				    	    <select class=inputstyle name=status style='width:80%' size=1 >
								<option value=""></option>
								<option value="0" <%if("0".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(125, user.getLanguage()) %></option>
								<option value="1" <%if("1".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(18600, user.getLanguage()) %></option>
								<option value="2" <%if("2".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(405, user.getLanguage()) %></option>
						             
							</select>
				    	 </wea:item>
				    	 
				    	 //开始日期
				    	 <wea:item><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></wea:item>
				    	 <wea:item>
				    	    <BUTTON class=Calendar type="button" onclick="onShowVotingDate('BeginDatespan','begindate')"></BUTTON>
					    	<SPAN id=BeginDatespan><%=begindate%></SPAN>
					    	<input type="hidden" id="begindate" name="begindate" id="onFrmSubmit" value="<%=begindate%>">
				    	 </wea:item>
				    	 //结束日期
				    	 <wea:item><%=SystemEnv.getHtmlLabelName(741, user.getLanguage())%></wea:item>
				    	 <wea:item>
				    	    <BUTTON class=Calendar type="button" onclick="onShowDate1(EndDatespan,enddate)"></BUTTON>
					    	<SPAN id=EndDatespan><%=enddate%></SPAN>
					    	<input type="hidden" name="enddate" value="<%=enddate%>">
				    	 </wea:item>
				    </wea:group>
				    
				    <wea:group context="">
				    	<wea:item type="toolbar">
							<input type="submit" value="<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%>" class="e8_btn_submit"/>
								<span class="e8_sep_line">|</span>
							<input type="reset" name="reset" onclick="resetCondtion()"   value="<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%>" class="e8_btn_cancel" >
								<span class="e8_sep_line">|</span>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
				    	</wea:item>
				    </wea:group>
				</wea:layout>
    </div>
					
					
					
      <!--列表部分-->
   <%
    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
	String belongtoids = user.getBelongtoids();
	String account_type = user.getAccount_type();
         //得到pageNum 与 perpage
         int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;;
         int perpage = UserDefaultManager.getNumperpage();
         if(perpage <2) perpage=15;
		 String sqlWhere ="";
         
         //设置好搜索条件
         String backFields =" id,descr, subject,begindate,begintime,enddate,endtime,createrid,approverid,status,createdate ,createtime ";
         String fromSql = " voting ";
          if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
	         sqlWhere = " (id in (select votingid from VotingRemark where resourceid="+ userid+//已投过票的
			 			" union select votingid from VotingResourceRemark where resourceid="+userid+") )";
	          String[] votingshareids=Util.TokenizerString2(belongtoids,",");
		     		for(int i=0;i<votingshareids.length;i++){
			  			sqlWhere+="or (id in (select votingid from VotingRemark where resourceid="+ votingshareids[i]+//已投过票的
			 				" union select votingid from VotingResourceRemark where resourceid="+votingshareids[i]+") )";
			 			}
				  }else{
				  	sqlWhere = " id in (select votingid from VotingRemark where resourceid="+ userid+//已投过票的
				 		" union select votingid from VotingResourceRemark where resourceid="+userid+") ";
				  }
         if(!subject.equals("")){
         	sqlWhere += " and subject like '%"+subject+"%'";
         }
      
       //调查类型
         if(!votingtype.equals("")){
         	sqlWhere += " and votingtype in ("+votingtype+")";
         }
         //状态
         if(!status.equals("")){
         	sqlWhere += " and status in ("+status+")";
         }
       //开始日期
         if(!begindate.equals("")){
          	sqlWhere += " and begindate >= '"+begindate+"'";
          }
       //截止日期
         if(!enddate.equals("")){
          	sqlWhere += " and enddate <= '"+enddate+"'";
          }
         
        //System.out.println("sqlWhere==="+sqlWhere);
       
         String orderBy = " begindate ,begintime  ";

         
  
         

         String tableString = "<table pageId=\""+PageIdConst.Voting_VotingDoneListTable+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Voting_VotingDoneListTable,user.getUID(),PageIdConst.VOTING)+"\"  tabletype=\"checkbox\">";
         tableString +=
                "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
                "<head>"+
                "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" href=\"javascript:downVoting('{0}')\" linkkey=\"id\"/>"+
                "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" href=\"javascript:downVoting('{0}')\" linkkey=\"id\" linkvaluecolumn=\"id\" />"+
                      "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" orderkey=\"createrid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+
                      "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"begindate\" orderkey=\"begindate\" />"+
                      "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\" />"+
                      "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\"  orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.voting.VotingManager.getStatus\"/>"+
                "</head>"+
                "</table>";
       %>
                     <wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>

</FORM>
</BODY></HTML>
<script language="javaScript">
var dialog;
function downVoting(votingid){

	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 960;
	dialog.Height = 800;
	dialog.Modal = true;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15218,user.getLanguage())%>";
	<%
	  if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
	%>
    var testJson="";
	var vierid="";
	jQuery.post("/voting/surveydesign/pages/viewblons.jsp",{"votingid":votingid},function(data){			
		if(data!=""&&data!=null){
				 testJson = $.parseJSON(data);  
				 vierid=testJson.resourceid;            
                 dialog.URL = "/voting/surveydesign/pages/mysurveyinput.jsp?votingid="+votingid+"&f_weaver_belongto_userid="+vierid+"&f_weaver_belongto_usertype=<%=user.getType()%>";
	            dialog.show();
				
			}
		});		
	<%
	}else{	
	%>
	  dialog.URL = "/voting/surveydesign/pages/mysurveyinput.jsp?votingid="+votingid;
	  dialog.show();	 
	
	<%}%>

}


</SCRIPT>
