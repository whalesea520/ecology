
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.PageManagerUtil " %>
<%@ page import="java.sql.Timestamp" %>
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

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(33831,user.getLanguage());
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";

boolean isSys=true;
RecordSet.executeSql("select 1 from hrmresource where id="+user.getUID());
if(RecordSet.next()){
	isSys=false;
}	

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
			return false;
		}
</script>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>




<FORM id=weaver name=weaver method=post action="VotingListFrame.jsp">
    <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Voting_VotingUnDoListTable %>"/>
					
					
      <!--列表部分-->
   <%

   
Date votingnewdate = new Date() ;
long votingdatetime = votingnewdate.getTime() ;
Timestamp votingtimestamp = new Timestamp(votingdatetime) ;
String votingCurrentDate = (votingtimestamp.toString()).substring(0,4) + "-" + (votingtimestamp.toString()).substring(5,7) + "-" +(votingtimestamp.toString()).substring(8,10);
String votingCurrentTime = (votingtimestamp.toString()).substring(11,13) + ":" + (votingtimestamp.toString()).substring(14,16);

    HrmUserSettingComInfo userSetting=new HrmUserSettingComInfo();
    String belongtoshow = userSetting.getBelongtoshowByUserId(user.getUID()+""); 
		String belongtoids = user.getBelongtoids();
		String account_type = user.getAccount_type();

         //得到pageNum 与 perpage
         int pagenum = 20;
         int perpage = 20;
         
         //设置好搜索条件
         String backFields =" * ";
         String fromSql = " voting ";
         String sqlWhere = "";
      
      
      if(belongtoshow.equals("1")&&account_type.equals("0")&&!belongtoids.equals("")){
				
				belongtoids +=","+user.getUID();
				
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
		  		
		  		sqlWhere += " or (( id not in (select votingid from VotingRemark where resourceid="+tmptUser.getUID()+")" +
	  			" and id in(select votingid from VotingShare t"+i+" where ((sharetype=1 and resourceid="+tmptUser.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) )   or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t"+i+".roleid and rolelevel>=t"+i+".rolelevel and resourceid="+tmptUser.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) )) ))";	
		  		
		 		}
		 		
		 		sqlWhere=sqlWhere.substring(3);
		 		sqlWhere="("+sqlWhere+")";
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
	  		
	  		sqlWhere = " id not in (select votingid from VotingRemark where resourceid="+userid+")" +
	  		" and id in(select votingid from VotingShare t where ((sharetype=1 and resourceid="+user.getUID()+") or (sharetype=2 and subcompanyid in("+tmptsubcompanyid+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=3 and departmentid in("+tmptdepartment+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) or (sharetype=5 and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+"))  or (sharetype=6 and ( (joblevel=0 and jobtitles="+jobtitles+" ) or (joblevel=1 and jobtitles="+jobtitles+" and jobsubcompany in("+tmptsubcompanyid+")) or (joblevel=2 and jobtitles="+jobtitles+" and jobdepartment in("+tmptdepartment+") )) )   or (sharetype=4 and exists(select 1 from HrmRoleMembers where roleid=t.roleid and rolelevel>=t.rolelevel and resourceid="+user.getUID()+") and seclevel<="+seclevel+" and (seclevelmax is null or seclevelmax>="+seclevel+")) ))";
	  	}
      
      sqlWhere += " and (istemplate <> '1' or istemplate is null) and status in ('1')  and (beginDate<'"+votingCurrentDate+"' or (beginDate='"+votingCurrentDate+"' and (beginTime is null or beginTime='' or beginTime<='"+votingCurrentTime+"'))) ";
      if(isSys){
				sqlWhere =" 1=2";
			}   
			//System.out.println("sql==="+sqlWhere);
			//RecordSet.executeSql("###hell:"+sqlWhere);
         

         String tableString = "<table  pageId=\""+PageIdConst.Voting_VotingUnDoListTable+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Voting_VotingUnDoListTable,user.getUID(),PageIdConst.VOTING)+"\" tabletype=\"checkbox\">";

          tableString +=
                "<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlorderby=\"begindate ,begintime \"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" />"+
                "<head>"+
                      "<col width=\"8%\"  text=\""+SystemEnv.getHtmlLabelName(15486,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" href=\"javascript:doVoting('{0}')\" linkkey=\"id\"/>"+
                      "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"subject\" orderkey=\"subject\" href=\"javascript:doVoting('{0}')\" linkkey=\"id\" linkvaluecolumn=\"id\" />"+
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

<SCRIPT language="javascript">
var dialog;
function doVoting(votingid){
	$.ajax({
         data: {votingid:votingid,method:"getVotingInfo"},
         type: "POST",
         url: "/voting/VotingInfoOperation.jsp",
         timeout: 20000,
         dataType: 'json',
         success: function (data) {
             if(data) {
                dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				dialog.Width = 960;
				dialog.Height = 800;
				dialog.Modal = true;
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(17599,user.getLanguage())%>";
				dialog.URL = "/voting/VotingPoll.jsp?votingid="+votingid+"&freshparent=1";
				if(data.forcevote){//强制调查
				  dialog.ShowCloseButton=false; 
				}
				dialog.show();
             }else {
                 top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83701,user.getLanguage())%>');
             }
         }, fail: function () {
             top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83701,user.getLanguage())%>');
         }
     });
}

</SCRIPT>
