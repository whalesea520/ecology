
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="VotingReminiders" class="weaver.voting.VotingReminiders" scope="page"/> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17599,user.getLanguage());
String temptitlename = titlename;
String needfav ="1";
String needhelp ="";

boolean canmaint=HrmUserVarify.checkUserRight("Voting:Maint", user);
boolean canDelete = HrmUserVarify.checkUserRight("voting:delete", user);
boolean canedit=false ;
boolean canapprove=false ;
boolean canOption = false;

boolean islight=true ;
String userid=user.getUID()+"";

String votingid=Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
String nogoback=Util.null2String(request.getParameter("nogoback"));

RecordSet.executeProc("Voting_SelectByID",votingid);
RecordSet.next();
String subject=RecordSet.getString("subject");
String detail=RecordSet.getString("detail");
String createrid=RecordSet.getString("createrid");
String createdate=RecordSet.getString("createdate");
String createtime=RecordSet.getString("createtime");
String approverid=RecordSet.getString("approverid");
String approvedate=RecordSet.getString("approvedate");
String approvetime=RecordSet.getString("approvetime");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String isanony=RecordSet.getString("isanony");
String docid=RecordSet.getString("docid");
String crmid=RecordSet.getString("crmid");
String projectid=RecordSet.getString("projid");
String requestid=RecordSet.getString("requestid");
String votingcount = RecordSet.getString("votingcount");
String status = RecordSet.getString("status");
String isSeeResult = RecordSet.getString("isSeeResult");//投票后是否可以查看结果

int votingtype = Util.getIntValue(RecordSet.getString("votingtype"));//调查类型
String votingtypename = "";
RecordSet.executeSql("select typename from voting_type where id ="+votingtype);
if(RecordSet.next()) votingtypename = RecordSet.getString(1);

RecordSet.executeSql("select * from votingoption where votingid ="+votingid);
if(RecordSet.next()){
  canOption = true; 
}else{
   String isother = "";
   rs.executeSql("select * from votingQuestion where votingid ="+votingid);
   if(rs.next()) isother = rs.getString("isother");
   if("1".equals(isother)){
    canOption = true; 
   }
}

if(userid.equals(createrid) || userid.equals(approverid))
    canedit=true ;
if(userid.equals(approverid)) {
    canapprove=true ;   
}

if(canmaint){
    canedit=true ;
    canapprove=true ;
}

//提交权限begin
boolean cancreate = false;

if(HrmUserVarify.checkUserRight("Voting:Maint", user)){
	cancreate = true;
}
String sqlcreate = "select count(id) as recordid from votingmaintdetail where  createrid="+userid;
RecordSet.execute(sqlcreate);
while(RecordSet.next()){
		int recordid = RecordSet.getInt("recordid");
		if(recordid>0){
		  	cancreate = true;
		  }   
	}
	
String sqlcreate2 = "select count(id) as recordid from votingmaintdetail where  approverid="+userid;
RecordSet.execute(sqlcreate2);
while(RecordSet.next()){
		int recordid = RecordSet.getInt("recordid");
		if(recordid>0){
		
		  	canapprove = true;
		  }   
	}
if(userid.equals(createrid)) cancreate=true ;

/***流程查看网上调查权限开始**/
String isfromwf = Util.null2String(request.getParameter("isfromworkflow"));
boolean wfviewtmp = false;

if("1".equals(isfromwf)) {
	wfviewtmp = VotingReminiders.checkViewWfVoting(votingid,userid);
}

if(!canedit && !wfviewtmp){
    response.sendRedirect("/notice/noright.jsp");
    return ;
}

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
    <%
        
        if(status.equals("0") && cancreate){
        	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addViewer("+votingid+"),_top} " ;
            RCMenuHeight += RCMenuHeightStep ;
            
            RCMenu += "{"+ SystemEnv.getHtmlLabelName(32136, user.getLanguage())+ ",javascript:doDel(),_self} ";
        	RCMenuHeight += RCMenuHeightStep;
            
        }
        if(!"1".equals(nogoback)){
	        RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goback()',_top} " ;
	        RCMenuHeight += RCMenuHeightStep ;
	      }
    %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan">
			    <%if(status.equals("0") && cancreate){ %>
					<span title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
						<input class="e8_btn_top middle" onclick="addViewer(<%=votingid %>)" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage()) %>"/>
					</span>
					<span title="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
						<input class="e8_btn_top middle" onclick="doDel()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
					</span>
				<%} %>
			    <span title="<%=SystemEnv.getHtmlLabelName(33832, user.getLanguage())%>" style="font-size: 12px;cursor: pointer;">
					<input class="e8_btn_top middle" onclick="doUpdate()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(33832, user.getLanguage())%>"/>
				</span>
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>"   class="cornerMenu"></span>
			</td>
		</tr>
	</table>

<form name=frmmain action="VotingOperation.jsp" method=post onsubmit="return check_form(this,'subject,creater,begindate')">


<div class="advancedSearchDiv" id="advancedSearchDiv"  >
<wea:layout type="4col">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(32905,user.getLanguage())%>'>
				         //名称
				         <wea:item><%=SystemEnv.getHtmlLabelName(33439, user.getLanguage())%></wea:item>
				         <wea:item>
				              <input type="text" name="subject"  style='width:80%' value="<%=Util.null2String(request.getParameter("subject"))%>">
				         </wea:item>
				         //创建人
				        <wea:item ><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></wea:item>
				    	
	</wea:group>
 </wea:layout>
		  
</div>

<input type=hidden name=votingid value="<%=votingid%>">
<input type=hidden name=createrid value="<%=createrid%>">
<input type=hidden name="method" value="finish">

		<%
			
			String sqlWhere = "1=1";
			if(!votingid.equals("")){
				sqlWhere = "  votingid = "+votingid+"";
			}
			
			//当前记录是否可删除
			String votingViewerDel = cancreate+"+"+status;
			//判断当前分享类型
			String votingViewerTypeLink = "column:sharetype+column:resourceid+column:subcompanyid+column:departmentid+column:roleid+column:seclevel+column:rolelevel+column:foralluser+"+user.getLanguage()+"+column:jobtitles+column:joblevel+column:jobsubcompany+column:jobdepartment";			
			//获取分享类型名称
			String votingViewerTypeName = "column:sharetype+"+user.getLanguage();
			//获取安全级别名称
			String votingSeclevelName = "column:sharetype+column:seclevel+column:seclevelmax+"+user.getLanguage();
			
			String tableString=""+
			   "<table instanceid=\"docMouldTable\" pagesize=\"10\" tabletype=\"checkbox\">"+
			   " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.voting.VotingManager.getVotingViewerDel\"  popedompara=\""+votingViewerDel+"\" />"+
			   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"votingviewer\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />";
			   
			String operateString = "";
	  	if(true){
				operateString += "<operates width=\"20%\">";
				operateString+=" <popedom column=\"id\" otherpara=\""+status+"\"  transmethod=\"weaver.voting.VotingManager.getVotingOperateRight\"></popedom> ";
				operateString+="     <operate otherpara=\"column:id\" href=\"javascript:doDel()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
				operateString+="</operates>";
	  	}
	  	tableString += operateString;   
			   
			   tableString +="<head>"+							 
			   "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"resourceid\" orderkey=\"resourceid\" otherpara=\""+votingViewerTypeName+"\" transmethod=\"weaver.voting.VotingManager.votingShareTypeName\"/>"+
			   "<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(25734,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+votingViewerTypeLink+"\" transmethod=\"weaver.voting.VotingManager.votingShareTypeLink\"/>"+
			   "<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevelmax\" otherpara=\""+votingSeclevelName+"\" transmethod=\"weaver.voting.VotingManager.votingSeclevelName\" />"+
			   "</head>"+
			   "</table>";
		%> <wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />

</form>
<script type="text/javascript">
var dialog = null;
function addViewer(votingid){
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "<%=SystemEnv.getHtmlLabelNames("611,20043", user.getLanguage())%>";
	dialog.URL = "/voting/VotingViewerAdd.jsp?votingid="+votingid;
	dialog.Width = 576;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.show();
}

function MainCallback(){
	dialog.close();
	_table.reLoad();
}

function goback(){
  window.open('VotingList.jsp','mainFrame','') ;
}

 function doDel(id,otherpara){
	 var ids=_xtable_CheckedCheckboxId();
	 if(id) ids=id;
	 
	 if(ids.length==0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
	 }else{
			window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
				$.post("/voting/VotingViewerOperation.jsp?method=delete&shareid="+ids+"&votingid=<%=votingid%>",{},function(){
					_table.reLoad();	
				})
	    });
	 }
	 
 }
  
//编辑操作
function doUpdate(){
      
   var dlg=new window.top.Dialog();//定义Dialog对象
　　　dlg.Model=true;
     dlg.maxiumnable=true;
　　　dlg.Width=1024;//定义长度
　　　dlg.Height=800;
     <%if(status.equals("0") && cancreate){ %>
       dlg.hideDraghandle = true;
       dlg.URL="/voting/surveydesign/pages/surveydesign.jsp?votingid=<%=votingid%>";  
     <%}else{ %>
       dlg.URL="/voting/surveydesign/pages/surveypreview.jsp?votingid=<%=votingid%>";    
     <%}%>
　　　dlg.Title="<%=SystemEnv.getHtmlLabelNames("15109,83723",user.getLanguage())%>";
　　　dlg.show();
}
</script>

</body>
</html>
