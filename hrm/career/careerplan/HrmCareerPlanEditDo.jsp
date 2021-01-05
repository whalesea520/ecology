<%@ page import="weaver.general.Util,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-06-11 [E7 to E8] -->
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="MailMouldComInfo" class="weaver.docs.mail.MailMouldComInfo" scope="page" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<jsp:useBean id="BudgetfeeTypeComInfo" class="weaver.fna.maintenance.BudgetfeeTypeComInfo" scope="page" />
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.onBtnSearchClick();
				parentWin.closeDialog();	
			}
		</script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<!--checkbox组件-->
		<link href="/js/ecology8/jNice/jNice/jNice_wev8.css" type=text/css rel=stylesheet>
		<script language=javascript src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
		<!-- 下拉框美化组件-->
		<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
		<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>

		<!-- 泛微可编辑表格组件-->
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
	</head>
	<%
		Date newdate = new Date() ;
		long datetime = newdate.getTime() ;
		Timestamp timestamp = new Timestamp(datetime) ;
		String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);

		String id = request.getParameter("id");

		boolean isFin = CareerPlanComInfo.isFinish(id);
		boolean canDelete = CareerPlanComInfo.canDelete(id);

		String topic = "";
		String principalid = "";
		String informmanid = "";
		String startdate = "";
		String budgettype = "";
		String budget = "";
		String emailmould = "";
		String memo = "";

		String sql = "select * from HrmCareerPlan where id ="+id;
		rs.executeSql(sql); 
		while(rs.next()){
		  topic = Util.null2String(rs.getString("topic"));
		  principalid = Util.null2String(rs.getString("principalid"));
		  budgettype = Util.null2String(rs.getString("budgettype"));
		  informmanid = Util.null2String(rs.getString("informmanid"));  
		  startdate = Util.null2String(rs.getString("startdate"));
		  budget = Util.null2String(rs.getString("budget"));
		  emailmould = Util.null2String(rs.getString("emailmould"));
		  memo = Util.toScreenToEdit(rs.getString("memo"),user.getLanguage());
		}

		boolean isPrincipal = false;
		if(principalid.equals(""+user.getUID()))
			isPrincipal = true;
	%>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(!isFin){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doedit(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		/*if(HrmUserVarify.checkUserRight("HrmCareerPlanDelete:Delete", user)&&!isFin&&canDelete){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}*/
		/**
		 * Modified By Charoes Huang On May 19 ,2004, 非负责人不能查看日志信息
		 */
		/*if(isPrincipal){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+70+" and relatedid="+id+",_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/career/careerplan/HrmCareerPlanEdit.jsp?id="+id+",_self} " ;
		RCMenuHeight += RCMenuHeightStep ;*/
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="doedit();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(6132,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="namespan" required='<%=topic.length()==0%>'>
				  			<input class=inputstyle type=text size=30 name="topic" value="<%=topic%>" onchange="checkinput('topic','namespan')">
						</wea:required>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="principalid" browserValue='<%=principalid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="120px" browserSpanValue='<%=ResourceComInfo.getResourcename(principalid)%>'>
							</brow:browser>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<span>
							<brow:browser viewType="0" name="informmanid" browserValue='<%=informmanid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp" width="120px" browserSpanValue='<%=ResourceComInfo.getResourcename(informmanid)%>'>
							</brow:browser>
						</span>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(15744,user.getLanguage())%></wea:item>
				  	<wea:item>
						<wea:required id="selectdatespan" required="false">
							<BUTTON class=Calendar type="button" id=selectdate onclick="getDate(datespan,startdate)"></BUTTON> 
				            <SPAN id=datespan ><%=startdate%></SPAN> 
				            <input class=inputstyle type="hidden" id="startdate" name="startdate" value="<%=startdate%>"> 
						</wea:required>
					</wea:item>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<wea:required id="memospan" required="false">
				  			<textarea class=inputstyle cols=50 rows=4 name="memo" ><%=memo%></textarea>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
			<div id="careerPlan" class="groupmain" style="width:100%"></div>
			<%
				sql = "select * from HrmCareerPlanStep where planid = "+id +" order by id ";
				rs.executeSql(sql);
				StringBuilder datas = new StringBuilder();
				int sIndex = 0;
				while(rs.next()){
					String stepstartdate = Util.null2String(rs.getString("stepstartdate"));
					String stependdate = Util.null2String(rs.getString("stependdate"));
					String stepname = Util.null2String(rs.getString("stepname"));	
					
					datas.append("[")
					.append("{name:'stepname',value:'").append(stepname).append("',iseditable:true,type:'input'},")
					.append("{name:'stepstartdate',value:'").append(stepstartdate).append("',iseditable:true,type:'date'},")
					.append("{name:'stependdate',value:'").append(stependdate).append("',iseditable:true,type:'date'}")
					.append("],");
					
					sIndex++;
				}
				String ajaxData = datas.toString();
				if(ajaxData.length() > 0){
					ajaxData = ajaxData.substring(0,ajaxData.length()-1);
				}
				ajaxData = "["+ajaxData+"]";
			%>
			<script>
				var sIndex = "<%=sIndex%>";
				var items=[
				{width:"51%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='stepname'>"},
				{width:"22%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<BUTTON class=Calendar type=button onclick='getRSDate1(this)'></BUTTON><SPAN name='showdate' class='weadate'></SPAN><input class=inputstyle type=hidden name='stepstartdate'>"},
				{width:"22%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<BUTTON class=Calendar type=button onclick='getRSDate1(this)'></BUTTON><SPAN name='showdate' class='weadate'></SPAN><input class=inputstyle type=hidden name='stependdate'>"}];
				var option= {
					openindex:true,
					navcolor:"#003399",
					basictitle:"<%=SystemEnv.getHtmlLabelName(15745,user.getLanguage())%>",
					toolbarshow:true,
					colItems:items,
					usesimpledata: true,
					initdatas:"<%=ajaxData%>",
					addrowCallBack:function() {
						sIndex = this.count;
					},
					copyrowsCallBack:function() {
						sIndex = this.count;
					},
					configCheckBox:true,
					checkBoxItem:{"itemhtml":'<input name="check_node" class="groupselectbox" type="checkbox" >',width:"5%"}
				};
			   var group=new WeaverEditTable(option);
			   $("#careerPlan").append(group.getContainer());
		   </script>
			<input class="inputstyle" type="hidden" name="operation" value="edit">
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
			<input class=inputstyle type=hidden name=oldprincipalid value="<%=principalid%>">
			<input class=inputstyle type=hidden name=oldinformmanid value="<%=informmanid%>">
			<input class="inputstyle" type="hidden" name="rownum">
		</form>
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
		<script language=javascript>
			function doedit(){
				if(check_form(document.frmMain,'topic')){
					if(checkDateValidity()){
						document.frmMain.rownum.value = group.count;
						//alert(group.getTableSeriaData());
						document.frmMain.operation.value="edit";
						document.frmMain.submit();
					}
				}
			}
 function dodelete(){
   if(confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>")){
     document.frmMain.operation.value="delete";
     document.frmMain.submit();
   }
 }
 function doclose(){
   location="HrmCareerPlanFinish.jsp?id=<%=id%>";
 }

/**
 *Added By Huang Yu On April 28,2004
 *Description : 检查日期的完整性
 *              招聘步骤的 开始时间 >= 招聘计划的 招聘时间
 *              招聘步骤的 开始时间 <= 结束时间
 *              招聘步骤的 前一步的开始时间 <=后一步的 开始时间
 *
*/
function checkDateValidity() {
    var currentDate ="<%=CurrentDate%>";
    var startDate = frmMain.startdate.value;
    //alert(startDate);
    /*
    if(compareDate(startDate,currentDate)== -1){
        alert("招聘计划的开始日期必须在当前日期之后");
        return false;
    }
    */
    /*var stepStartDate = new Array();
    var stepEndDate = new Array();
    var stepName = new Array();
    for(var i=3;i<oTable.rows.length;i++){
        var rowObj = oTable.rows.item(i);
        stepName[i-3] = rowObj.cells.item(1).children(0).children(0).value; //步骤名称
        stepStartDate[i-3] = rowObj.cells.item(2).innerText;    //步骤开始日期
        stepEndDate[i-3] = rowObj.cells.item(3).innerText;      //步骤结束日期
    }
    for(var i=0;i<stepName.length;i++){
        //alert(compareDate(stepStartDate[i],startDate));
        if(compareDate(stepStartDate[i],startDate)== -1){
            alert("步骤 '"+stepName[i]+"' 的开始日期必须在招聘计划的招聘时间之后！");
            return false;
            break;
        }
        if(compareDate(stepStartDate[i],stepEndDate[i]) == 1) {
            alert("步骤 '"+stepName[i]+"' 的开始日期必须在其结束日期之前或等于结束日期！")
            return false;
            break;
        }

        //检察步骤之间的开始时间是否有效
        for(var j=i+1;j<stepName.length;j++){
               if(compareDate(stepStartDate[i],stepStartDate[j]) == 1){
                 alert("步骤'"+stepName[i]+"'的开始日期必须小于或等于 步骤'"+stepName[j]+"'的开始日期！");
                 return false;
                 break;
               }
        }
    }*/
    return true;
}

/**
 *Author: Charoes Huang
 *compare two date string ,the date format is: yyyy-mm-dd hh:mm
 *return 0 if date1==date2
 *       1 if date1>date2
 *       -1 if date1<date2
*/
function compareDate(date1,date2){
	//format the date format to "mm-dd-yyyy hh:mm"
	var ss1 = date1.split("-",3);
	var ss2 = date2.split("-",3);

	date1 = ss1[1]+"-"+ss1[2]+"-"+ss1[0];
	date2 = ss2[1]+"-"+ss2[2]+"-"+ss2[0];

	var t1,t2;
	t1 = Date.parse(date1);
	t2 = Date.parse(date2);
	if(t1==t2) return 0;
	if(t1>t2) return 1;
	if(t1<t2) return -1;

    return 0;
}
</script>
</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
</HTML>
