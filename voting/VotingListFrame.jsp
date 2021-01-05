
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
<jsp:useBean id="VotingManager" class="weaver.voting.VotingManager" scope="page" />	


<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>
<%
String loginType=user.getLogintype();
//是否查看结果 1 为查看调查结果
int viewResult = Util.getIntValue(Util.null2String(request.getParameter("viewResult")),0);


String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = "";
if(viewResult == 1){
	titlename = SystemEnv.getHtmlLabelName(20042,user.getLanguage());
}else{
	titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
}
String needfav ="1";
String needhelp ="";



//1 表示模板。 无提交，批准等操作
int istemplate = Util.getIntValue(Util.null2String(request.getParameter("istemplate")),0);

//用户是否有删除权限
boolean canDelete = HrmUserVarify.checkUserRight("voting:delete", user);


String userid = user.getUID()+"";
String subject = Util.null2String(request.getParameter("subject"));

//创建人
String createrid =Util.null2String(request.getParameter("createrid"));
//votingtype 调查类型
String votingtype =Util.null2String(request.getParameter("votingtype"));
// 状态过滤
String status = Util.null2String(request.getParameter("status"));

//开始日期
String begindate = Util.null2String(request.getParameter("begindate"));
//截止日期
String enddate = Util.null2String(request.getParameter("enddate"));

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean canmaintview=canmaint;

boolean cancreate = false;
//boolean canapprove = false ;
RecordSet.executeSql("select id from votingmaintdetail where createrid="+userid+" or approverid="+userid);
if(RecordSet.next())  cancreate=true ;
if(canmaint)  cancreate=true ;

if(viewResult==1){
	canmaint = false;
	cancreate = false;
}

String pageId = "";
if(viewResult == 1){
	pageId = PageIdConst.Voting_VotingResultListTable;
}

if(istemplate == 1){
	pageId = PageIdConst.Voting_VotingTemplateListTable;
}

if(istemplate != 1 && viewResult != 1){
	pageId = PageIdConst.Voting_VotingListTable;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>



<script type="text/javascript">

		function onBtnSearchClick(){
			jQuery('#weavertop').submit();
		}
</script>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<FORM id=weavertop name=weavertop method=post action="VotingListFrame.jsp">

   <table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
			    <%if (cancreate) { %>
						<input type="button" name="newBtn" onclick="doAdd();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"/>
					<%} %>
				<%if(cancreate&&istemplate != 1) {%>
					<input type="button" name="newBtn" onclick="importTemplate();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(32385,user.getLanguage())%>"/>
		    <%}%>
				<%if(canDelete && viewResult != 1){ %>
					<input type=button class="e8_btn_top" onclick="doBatchDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
				<%} %>
				<input type="text" id="searchInput" name="subject" class="searchInput"  value="<%=subject %>"/>
				<input type="hidden" name="ids" />
				<input type="hidden" name="method" />
				<input type="hidden" name="viewResult" value="<%=viewResult %>" />
				<input type="hidden" name="istemplate" value="<%=istemplate %>" />
				<input type="hidden" name="pageId" id="pageId" value="<%=pageId %>"/>
				&nbsp;&nbsp;
				<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>&nbsp;&nbsp;
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"   class="cornerMenu"></span>
			</td>
		</tr>
	</table>
</form>
<script type="text/javascript">
function onCopy(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids==""){
		alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>!");
		return;
	}
    document.frmSubscribleHistory.ids.value = _xtable_CheckedCheckboxId();
    document.frmSubscribleHistory.action = "VotingCopyOperation.jsp";
    document.frmSubscribleHistory.submit();
}

</script>
<%

    if(cancreate) {
        if(istemplate != 1){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(32385,user.getLanguage())+",javascript:importTemplate(),_top} " ;
	        RCMenuHeight += RCMenuHeightStep ;
        }
    }

    if(canmaint && istemplate != 1) {
        RCMenu += "{"+SystemEnv.getHtmlLabelName(18599,user.getLanguage())+",javascript:location='/voting/VotingMaint.jsp',_top} " ;
        RCMenuHeight += RCMenuHeightStep ;
    }

    RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:window.history.go(-1),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<FORM id=weaver name=weaver method=post action="VotingListFrame.jsp">
    <div class="advancedSearchDiv" id="advancedSearchDiv"  >
	<input type="hidden" name="ids" />
	<input type="hidden" name="method" />
	<input type="hidden" name="viewResult" value="<%=viewResult %>" />
	<input type="hidden" name="istemplate" value="<%=istemplate %>" />
	<input type="hidden" name="pageId" id="pageId" value="<%=pageId %>"/>
	
	             
				  <wea:layout type="4col">
				      <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
				         //名称
				         <wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
				         <wea:item>
				              <input type="text" name="subject"  style='width:80%' value="<%=subject%>">
				         </wea:item>
				         //创建人
				        <wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
				    	<wea:item >
						   
					   	   <span id="createridselspan">
						   
			                   <brow:browser viewType="0" name="createrid" browserValue='<%= createrid+"" %>' browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" hasInput="true"  width="135px" isSingle="true" hasBrowser = "true" isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(createrid+""),user.getLanguage())%>'> 
							   </brow:browser> 
			
			                </span>
				    	</wea:item>
				         
				         //调查类型
				         <wea:item><%=SystemEnv.getHtmlLabelName(24111, user.getLanguage())%></wea:item>
				    	 <wea:item>
				    	    <select class=inputstyle name=votingtype style='width:80%' size=1 >
								<option value=""></option>
						             <% 
							          RecordSet.executeSql("select * from voting_type");
							          while(RecordSet.next()) {
							         %>
						               <option <%if(RecordSet.getString("id").equals(votingtype)){%>selected<%}%> value="<%=RecordSet.getString("id")%>"><%=RecordSet.getString("typename")%></option>
						             <%}%>
							</select>
				    	 </wea:item>
			             
			             //状态
				    	 <wea:item><%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%></wea:item>
				    	 <wea:item>
				    	    <select class=inputstyle name=status style='width:80%' size=1 >
								<option value=""></option>
								<option value="0" <%if("0".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("83443",user.getLanguage())%></option>
								<option value="3" <%if("3".equals(status)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(30835, user.getLanguage()) %></option>
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
				         <%
			               if(!canmaint&&!cancreate&&false){
			             %>  
					    	 <wea:item><%=SystemEnv.getHtmlLabelName(23143, user.getLanguage())%></wea:item>
					    	 <wea:item>
					    	    <select id="chiefType" name="chiefType" class=inputstyle size=1 style='width:80%' >
									<option value=""><%=SystemEnv.getHtmlLabelName(23144,user.getLanguage()) %></option>
									<option value="com" <%if("com".equals(Util.null2String(request.getParameter("chiefType")))){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(23145,user.getLanguage()) %></option>
									<option value="quarters" <%if("quarters".equals(Util.null2String(request.getParameter("chiefType")))){ %>selected <%} %>><%=SystemEnv.getHtmlLabelName(23146,user.getLanguage()) %></option>
								</select>
					    	 </wea:item>
					    	 <wea:item><%=SystemEnv.getHtmlLabelName(6086, user.getLanguage())%></wea:item>
					    	 <wea:item>
								  <brow:browser viewType="0" name="conidvalue" browserValue='<%= Util.null2String(request.getParameter("conidvalue")) %>' 
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?selectedids="
							      hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
							      completeUrl="/data.jsp?type=hrmjobtitles" width="165px"
							      browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(Util.null2String(request.getParameter("conidvalue")))%>'>
							      </brow:browser>		 
					    	 </wea:item>
					     <%
			               }
			             %>
				    	
				    	
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
         String belongtoshow = userSetting.getBelongtoshowByUserId(userid+""); 
	     String belongtoids = user.getBelongtoids();
     	 String account_type = user.getAccount_type();
         //设置好搜索条件
         String backFields =" id,descr, subject,begindate,begintime,enddate,endtime,createrid,approverid,status,createdate ,createtime,istemplate ";
         String fromSql = " voting ";
         String sqlWhere = "";
         if(canmaintview){
						sqlWhere = " where 1=1 ";
         } else if(cancreate){
						sqlWhere = " where (createrid="+userid+" or approverid="+userid+") ";
         } else {
						if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
			  			belongtoids+=","+userid;
			 				sqlWhere = " id in (";
							
							String[] votingshareids=Util.TokenizerString2(belongtoids,",");
				     	for(int i=0;i<votingshareids.length;i++){
				     		User tmptUser=VotingManager.getUser(Util.getIntValue(votingshareids[i]));
								String seclevel=tmptUser.getSeclevel();
								int subcompany1=tmptUser.getUserSubCompany1();
								int department=tmptUser.getUserDepartment();
								String  jobtitles=tmptUser.getJobtitle();
				     	
					  		String tmptsubcompanyid=subcompany1+"";
					  		String tmptdepartment=department+"";
					  		RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+tmptUser.getUID());
					  		while(RecordSet.next()){
					  			tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
					  			tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
					  		}
					  		
					  		sqlWhere +=" select votingid from VotingViewer t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or  (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) or   (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel<=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ) union ";
					  		sqlWhere +=" select votingid from VotingShare ta"+i+",voting tt"+i+" where ta"+i+".votingid=tt"+i+".id and (tt"+i+".isSeeResult='' or tt"+i+".isSeeResult is null) and ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or  (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=ta"+i+".roleid and rolelevel<=ta"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ) union ";	
					 		}
			 							
							sqlWhere +=" select id as votingid from voting where createrid in ("+belongtoids+") or approverid in ( "+belongtoids+") ";
							
							sqlWhere +=" ) ";
		   			}else{
		   				String seclevel=user.getSeclevel();
							int subcompany1=user.getUserSubCompany1();
							int department=user.getUserDepartment();
				  		    String  jobtitles=user.getJobtitle();
				  		String tmptsubcompanyid=subcompany1+"";
				  		String tmptdepartment=department+"";
				  		RecordSet.executeSql("select subcompanyid,departmentid from HrmResourceVirtual where resourceid="+user.getUID());
				  		while(RecordSet.next()){
				  			tmptsubcompanyid +=","+Util.null2String(RecordSet.getString("subcompanyid"));
				  			tmptdepartment +=","+Util.null2String(RecordSet.getString("departmentid"));
				  		}
		   				
		   				sqlWhere = " id in (select votingid from VotingViewer t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or  (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel<=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )" +//在查看结果范围
			        		 " union " +
			        		 " select id as votingid from voting where createrid="+userid+" or approverid = "+userid+//调查是 userid 创建或审批
			        		 " union " +
			        		 //以及调查设置了提交后可查看结果内的
			        		 " select votingid from VotingShare t,voting tt where t.votingid=tt.id and (tt.isSeeResult='' or tt.isSeeResult is null) and ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or  (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) ) or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel<=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ) "+
			        		 " ) ";
		   			}
		   			
		   			sqlWhere +=" and status in ('1','2') ";
         }
         
         if(istemplate == 1){
          	sqlWhere += " and istemplate = '1'";
          }else{
        	  sqlWhere += " and (istemplate <> '1' or istemplate is null)";  
          }
         
         //System.out.println("sqlWhere==="+sqlWhere);
         if(!subject.equals("")){
         	sqlWhere += " and subject like '%"+subject+"%'";
         }
       	 //创建人
         if(!createrid.equals("")){
         	sqlWhere += " and createrid in ("+createrid+")";
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
       
         String orderBy="id";
         if(canmaint){
						//orderBy = " createdate ,createtime  ";
         } else {
						//orderBy = " createdate ,createtime  ";
         }
         
         String linkstr="";
         String poptitle="";
         if(canmaint||cancreate){
             linkstr = "/voting/VotingView.jsp+column:id+"+istemplate;
             poptitle="17599,2121";
         } else {
             linkstr = "/voting/VotingPollResult.jsp+column:id+"+istemplate;
             poptitle="20042";
         }
         
         boolean statusdisplay = (istemplate==1)?false:true;
         String operatepopedompara = "column:id+column:status+"+cancreate+"+"+canDelete+"+"+String.valueOf(user.getUID())+"+column:createrid+column:approverid+"+istemplate;
         String checkboxpopedompara="column:status+"+canDelete;
         String statuspara = "column:status";
        String operateString = "";
        
        if(viewResult !=1){//非查看时
					operateString = " <operates>";
					operateString +=" <popedom column=\"id\" transmethod=\"weaver.voting.VotingManager.getVotingListOperation\"  otherpara=\""+operatepopedompara+"\" ></popedom> ";
					
						operateString +="     <operate otherpara=\"column:istemplate+1\" href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + "\"   index=\"0\"/>";
						operateString +="     <operate href=\"javascript:doDel();\" text=\"" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + "\"   index=\"1\"/>";
				   	operateString +="     <operate otherpara=\"column:status+"+cancreate+"\" href=\"javascript:doUpdate();\" text=\"" + SystemEnv.getHtmlLabelName(33832, user.getLanguage()) + "\" index=\"2\"/>";   
						operateString +="     <operate otherpara=\"column:istemplate+2\" href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelNames("430,19467", user.getLanguage())+ "\" index=\"3\"/>";   
				   	operateString +="     <operate otherpara=\"column:istemplate+3\" href=\"javascript:doEdit();\" text=\"" + SystemEnv.getHtmlLabelName(20043, user.getLanguage()) + "\" index=\"4\"/>";   
				   	
				   	operateString +="     <operate otherpara=\"column:istemplate+3\" href=\"javascript:copyVoting();\" text=\"" + SystemEnv.getHtmlLabelNames("77,15109", user.getLanguage()) + "\" index=\"5\"/>";
				   	operateString +="     <operate otherpara=\"column:istemplate+3\" href=\"javascript:saveAsTemplate();\" text=\"" + SystemEnv.getHtmlLabelName(19468, user.getLanguage()) + "\" index=\"6\"/>";
					
					operateString +=" </operates>";
				 }
         

         String tableString = "";
          tableString="<table pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),PageIdConst.VOTING)+"\" tabletype=\"checkbox\">";
          tableString +="<checkboxpopedom id=\"checkbox\" popedompara=\""+checkboxpopedompara+"\" showmethod=\"weaver.voting.VotingManager.getVotingListCheckBoxRight\" />";
          tableString +="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />";
          tableString +=  operateString;
          tableString += "<head>"+
                      "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" otherpara=\""+linkstr+"\" transmethod=\"weaver.voting.VotingManager.getVotingLink\"/>"+
                      "<col width=\"28%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" otherpara=\""+linkstr+"\" transmethod=\"weaver.voting.VotingManager.getVotingLink\"/>"+
          
                      "<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"createrid\" orderkey=\"createrid\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\""+loginType+"\" />"+
                      "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"begindate\" orderkey=\"begindate\" />"+
                      "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"enddate\" orderkey=\"enddate\" />"+
                      "<col width=\"12%\"  text=\""+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"\" column=\"status\" display=\""+statusdisplay+"\" orderkey=\"status\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.voting.VotingManager.getStatus\"/>"+
                "</head>"+
                "</table>";
       %>
                     <wea:SplitPageTag isShowTopInfo="true" tableString='<%=tableString%>'  mode="run"/>

</FORM>
</BODY></HTML>
<script language="javaScript">

//删除
function doDel(id){
	
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("82017",user.getLanguage())%>',function(){
        $.post("/voting/VotingOperation.jsp?method=delete&votingids="+id,{},function(){
				 _table.reLoad();	
		 })
   });
}

function doEdit(id,otherpara){
	var paraarr=otherpara.split("+");
	
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.maxiumnable=true;
	dlg.Width=1024;//定义长度
	dlg.Height=768;
	dlg.URL="/voting/VotingView.jsp?votingid="+id+"&goedit="+paraarr[1]+"&istemplate="+paraarr[0];
	dlg.Title="<%=SystemEnv.getHtmlLabelNames("17599,2121",user.getLanguage())%>";
	
	dlg.show();
}

function doAdd(){
	
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.currentWindow = window;
	dlg.Model=true;
	dlg.maxiumnable=true;
	dlg.Width=1024;//定义长度
	dlg.Height=768;
	dlg.URL="/voting/VotingAdd.jsp?istemplate=<%=istemplate %>"
	dlg.Title="<%=SystemEnv.getHtmlLabelNames("15110",user.getLanguage())%>";
	
	dlg.show();
}

function doUpdate(id,otherpara){
	var tmptarr=otherpara.split("+");
	
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.maxiumnable=true;
	dlg.Width=1024;//定义长度
	dlg.Height=768;
	if(tmptarr[0]=="0"&&tmptarr[1]=="true"){
		dlg.hideDraghandle = true;
		dlg.URL="/voting/surveydesign/pages/surveydesign.jsp?votingid="+id+"&istemplate=<%=istemplate%>";
	} else {
		dlg.URL="/voting/surveydesign/pages/surveypreview.jsp?votingid="+id+"&istemplate=<%=istemplate%>";
	}
	
	dlg.Title="<%=SystemEnv.getHtmlLabelNames("15109,83723",user.getLanguage())%>";
	dlg.show();
}

function showVotingResult(urlval){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.Model=true;
	dlg.maxiumnable=true;
	dlg.Width=1024;//定义长度
	dlg.Height=768;
	dlg.URL=urlval+"&nogoback=1";
	dlg.Title="<%=SystemEnv.getHtmlLabelNames(poptitle, user.getLanguage())%>";
	dlg.show();		
}

 function doBatchDel(){
	 var ids=_xtable_CheckedCheckboxId();
	 if(ids.length==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("32568",user.getLanguage())%>");
	 }else{
		 ids=ids.substr(0,ids.length-1);		 
		 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("82017",user.getLanguage())%>',function(){
	       $.post("/voting/VotingOperation.jsp?method=delete&votingids="+ids,{},function(){
				 _table.reLoad();	
		   })
	   });
	 }
	 
 }

function copyVoting(id){
    document.weaver.action = "VotingCopyOperation.jsp?ids="+id;
    document.weaver.submit();
}


function saveAsTemplate(id){
    document.weaver.action = "VotingCopyOperation.jsp?ids="+id+"&istempatea=1";
    document.weaver.submit();
}

var dialog = null;
function importTemplate(){

	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(15109,user.getLanguage())+SystemEnv.getHtmlLabelName(33144,user.getLanguage())%>";
	dialog.URL = "/voting/VotingTemplatesBrowser.jsp";
	dialog.Width = 600;
	dialog.Height = 460;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}


function MainCallback(){
    if(dialog != null){
        dialog.close();
    }
	_table.reLoad();
}


function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}
function forwardVotingResult(link)
{
	if(link=="")
	{
		return false;
	}
	var chiefType = document.getElementById("chiefType");
	var conidvalue = document.getElementById("conidvalue");
	//加上 是否 viewResult 参数
	link = link + "&viewResult=<%=viewResult%>&istemplate=<%=istemplate%>"
	if(chiefType)
	{
		chiefType = chiefType.value;
		if(chiefType=="com")
		{
			link =link+"&chiefType=com";
		}
		else if(chiefType=="quarters")
		{
			if(conidvalue)
			{
				conidvalue = conidvalue.value;
				if(""==conidvalue)
				{
					reply=confirm("<%=SystemEnv.getHtmlLabelName(23147,user.getLanguage()) %>")
					if(reply==true)
					{
					  	link =link+"&chiefType=quarters";
					}
					else
					{
						return false;
					}
				}
				else
				{
					link =link+"&chiefType=quarters&chiefId="+conidvalue;
				}
			}
		}
	}
  	window.open(link,"mainFrame","") ;
}
</script>
<SCRIPT language="javascript">
function btnok_onclick(){
	document.all("haspost").value="1"
     document.SearchForm.submit();
}

function btnclear_onclick(){
     document.all("isclear").value="1"
     document.SearchForm.submit()
}
function titleBrowerBeforeShow(opts){
	opts._url=opts._url+$('#conidvalue').val();
}

function onShowBrowser(){
	var results=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?jobtitles="+$GetEle("conidvalue").value);
	if(results){
	   if(wuiUtil.getJsonValueByIndex(results,0)!=""){
	      jQuery("#convaluespan").html(doReturnSpanHtml(wuiUtil.getJsonValueByIndex(results,1)));
	      $GetEle("conidvalue").value=wuiUtil.getJsonValueByIndex(results,0);
	   }else{
	      jQuery("#convaluespan").html("");
		  $GetEle("conidvalue").value=""
	   }
	}
}

</SCRIPT>
