
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.formmode.service.AppInfoService"%>
<%@page import="weaver.formmode.service.RemindJobService"%>
<%@page import="weaver.formmode.task.TaskService"%>
<%@page import="com.weaver.formmodel.util.DateHelper"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />


<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET />
		<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
		<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
<style>
.remindwaySpan{
	padding: 10px;
}
.rlabel{
	cursor: pointer;
}
.theErrorMsg{
	color: red;
}
.loading{
    position:absolute;
    left:45%;
    background:#ffffff;
    top:40%;
    padding:8px;
    z-index:20001;
    height:auto;
    border:1px solid #ccc;
}
body{
    height: 160px;
    display: block;
    overflow: hidden;
    padding: 0px;
    margin: 0px;
}
</style>
	</HEAD>
<%
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(30063, user
			.getLanguage());
	String needfav = "1";
	String needhelp = "";

	String Customname = "";
	String Customdesc = "";
	String modename = "";
	String id = Util.null2String(request.getParameter("id"), "0");
	
	String sql = "update mode_remindjob set sqlwherejson='' where id="+id;
	RecordSet.executeSql(sql);
	sql = "select * from mode_remindjob where id="+id;
	RecordSet.executeSql(sql);
    int remindway=0;
    String formid="";
	if(RecordSet.next()){
	    remindway = Util.getIntValue(RecordSet.getString("remindway"),0);
	    formid = RecordSet.getString("formid");
	    //remindEmail = Util.getIntValue(RecordSet.getString("remindEmail"),0);
	    //remindWorkflow = Util.getIntValue(RecordSet.getString("remindWorkflow"),0);
	    //remindWeChat = Util.getIntValue(RecordSet.getString("remindWeChat"),0);
	    //remindEmobile = Util.getIntValue(RecordSet.getString("remindEmobile"),0);
	}
    int defaultType = 0;
    String dialogid = Util.null2String(request.getParameter("dialogid"), "0");
    String s="_DialogFrame_"+dialogid;
%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<div class="loading" >
			<span><img src="/images/loadingext_wev8.gif" align="absmiddle"></span>
			<span id="loading-msg"><%=SystemEnv.getHtmlLabelName(82253,user.getLanguage())%><!-- 请稍候... --></span>
		</div>

		<FORM id=weaver name=frmMain action="/formmode/setup/customPageSettingsAction.jsp" method=post>

			<TABLE class="e8_tblForm">
				<COLGROUP>
					<COL width="20%">
					<COL width="80%">
					<TBODY>
						<%
						if(remindway==2){
                            if(defaultType==0){defaultType = 1;}
                        }if(remindway==3){
                            if(defaultType==0){defaultType = 2;}
                        }if(remindway==4){
                            if(defaultType==0){defaultType = 3;}
                        }if(remindway==5){
                            if(defaultType==0){defaultType = 4;}
                        } if(remindway==6){
                            if(defaultType==0){defaultType = 5;}
                        }
						RemindJobService remindJobService = new RemindJobService();
						TaskService taskService = new TaskService();
						Map map = remindJobService.getRemindJobById(Util.getIntValue(id));
						String fieldname = "";
						if(defaultType==1){//短信
							fieldname = "isRemindSMS";
						}else if(defaultType==2){
							fieldname = "isRemindEmail";
						}else if(defaultType==3){
							fieldname = "isRemindWorkflow";
						}else if(defaultType==4){
							fieldname = "isRemindWeChat";
						}else if(defaultType==5){
							fieldname = "isRemindEmobile";
						}
						sql = taskService.getDqtxSqlwhere(map,fieldname);
						boolean isvirtualform = VirtualFormHandler.isVirtualForm(formid);
					    String vdatasource="";
					    boolean f=false;
					    if(isvirtualform){
					        Map<String, Object> vFormInfo = new HashMap<String, Object>();
					        vFormInfo = VirtualFormHandler.getVFormInfo(formid);
					        vdatasource = Util.null2String(vFormInfo.get("vdatasource")); // 虚拟表单数据源
					        f = rs.executeSql(sql,vdatasource);
					    }else{
					        f = rs.executeSql(sql);
					    }
						String errorMsg = "";
						int count = 0;
						int count1 = 0;
						if(f){
							count = rs.getCounts();
							String sql1 = "select 1 from mode_reminddata_all where lastdate='"+DateHelper.getCurrentDate()+"' and remindjobid="+id+" and "+fieldname+"=1";
							rs.execute(sql1);
							count1 = rs.getCounts();
						}else{
							errorMsg = SystemEnv.getHtmlLabelName(129564,user.getLanguage());
						}
						%>
						<TR  >
							<TD class="e8_tblForm_field">
								<div style="width: 100%; height: 125px;" id="sqlText" name="sqlText" class=Inputstyle readonly="readonly"><%=sql%></textarea>
							</TD>
						</TR>
						<TR id="msgTr">
							<TD class="e8_tblForm_field">
								<span class="theCountSpan" <%if(!errorMsg.equals("")){%>style="display: none;"<%} %>><%=SystemEnv.getHtmlLabelName(129909,user.getLanguage()) %>：<span  id="countSpan"><%=count %></span>,<%=SystemEnv.getHtmlLabelName(129910,user.getLanguage()) %>：<span id="count1Span"><%=count1 %></span></span>
								<span class="theErrorMsg" <%if(errorMsg.equals("")){%>style="display: none;"<%} %>><%=errorMsg %></span>
							</TD>
						</TR>
					</TBODY>
			</TABLE>


		</FORM>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<BR>
</BODY>
<script type="text/javascript">
var lastIndex = <%=defaultType%>;
jQuery(function($){
	$(".rlabel").bind("click",function(){
		var vindex = $(this).attr("vindex");
		if(lastIndex==vindex){
			return;
		}else{
			lastIndex =  vindex;
		}
		var box = $("#remindway"+vindex);
		var f = box.attr("checked");
		if(!f){
			box.trigger("checked",true);
			getSqlText(vindex);
		}
	});
	
	$(".loading").hide(); //隐藏加载图片
});

function onRadioClick(vindex){
	if(lastIndex==vindex){
		return;
	}else{
		lastIndex =  vindex;
	}
	getSqlText(vindex);
}

var arr = new Array();
function getSqlText(type){
	$(".loading").show(); 
	$.ajax({
	   type: "GET",
	   url: "/formmode/setup/RemindJobSettingsAction.jsp?operation=getSqlText",
	   dataType:"json",
	   data: "id=<%=id%>&type="+type+"&t="+new Date().getTime()+"&formid="+<%=formid%>,
	   success: function(json){
	     var errorMsg = json["errorMsg"];
	     var sql = json["sql"];
	     var count = json["count"];
	     var count1 = json["count1"];
	     if(errorMsg!=""){
	    	 $(".theCountSpan").hide();
	    	 $(".theErrorMsg").html(errorMsg).show();
	     }else {
	    	 $("#sqlText").text(sql);
	    	 $("#countSpan").html(count);
	    	 $("#count1Span").html(count1);
	    	 $(".theCountSpan").show();
	    	 $(".theErrorMsg").hide();
	     }
	     setTimeout(function(){
		     $(".loading").hide(); 
	     },100);
	   }
	});
}
</script>

</HTML>
