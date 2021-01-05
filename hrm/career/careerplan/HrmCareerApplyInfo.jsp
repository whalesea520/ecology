<%@ page import="weaver.general.Util,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<jsp:useBean id="CareerApplyComInfo" class="weaver.hrm.career.HrmCareerApplyComInfo" scope="page"/>
<!-- modified by wcd 2014-07-31 [E7 to E8] -->
<%
	String id = request.getParameter("planid");
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	boolean isFin = CareerPlanComInfo.isFinish(id);
	boolean isInformer = CareerPlanComInfo.isInformer(id,user.getUID());
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
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
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(isInformer){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!isFin && isInformer){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
			<div id="careerPlan" class="groupmain" style="width:100%"></div>
			<%
				String sql = "select a.id,a.jobtitle,c.jobtitlename,a.lastname,a.isinform from HrmCareerApply a left join HrmCareerInvite b on a.jobtitle = b.id left join HrmJobTitles c on b.careername = c.id where b.careerplanid = "+id+" order by a.createdate desc,a.id desc ";
				rs.executeSql(sql);
				StringBuilder datas = new StringBuilder();
				int sIndex = 0;
				while(rs.next()){
					String applyid = Util.null2String(rs.getString("id"));
					String lastname = Util.null2String(rs.getString("lastname"));
					String jobtitlename = Util.null2String(rs.getString("jobtitlename"));
					int status = CareerApplyComInfo.getStatus(applyid);
					String stepname = CareerApplyComInfo.getStepname(applyid);
					String isinform = Util.null2String(rs.getString("isinform"));
					
					datas.append("[")
					.append("{name:'applyid',value:'").append(applyid).append("',iseditable:true,type:'input'},")
					.append("{name:'lastname',value:'").append(lastname).append("',iseditable:false,type:'input'},")
					.append("{name:'jobtitlename',value:'").append(jobtitlename).append("',iseditable:false,type:'input'},")
					.append("{name:'stepname',value:'").append(stepname).append("',iseditable:false,type:'input'},")
					.append("{name:'isinform',value:'").append(isinform).append("',iseditable:"+String.valueOf(isInformer)+",type:'checkbox'}")
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
				function getDate(obj){
					var spanname = jQuery(obj).parent().find("span[name=showdate]");
					var inputname = jQuery(obj).parent().find("input").attr('name');
					WdatePicker({
						lang:languageStr,
						el:inputname,
						onpicked:function(dp){
							jQuery(spanname).html(dp.cal.getDateStr())
						},
						oncleared:function(dp){
							jQuery(spanname).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
						}
					});
				}
				var sIndex = "<%=sIndex%>";
				var items=[
				{width:"0%",colname:"",itemhtml:"<input class=inputstyle type=hidden style='width:98%' name='applyid'>"},
				{width:"25%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='lastname'>"},
				{width:"25%",colname:"<%=SystemEnv.getHtmlLabelName(15671,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='jobtitlename'>"},
				{width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='stepname'>"},
				{width:"25%",colname:"<%=SystemEnv.getHtmlLabelName(15705,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=checkbox name='isinform' <%=isInformer?"":"readonly"%>>"}];
				var option= {
					openindex:true,
					navcolor:"#003399",
					basictitle:"<%=SystemEnv.getHtmlLabelNames("1863,33292",user.getLanguage())%>",
					toolbarshow:false,
					colItems:items,
					usesimpledata: true,
					initdatas:eval("<%=ajaxData%>"),
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
				
				var isinform;
				for(var i=0; i<"<%=sIndex%>"; i++){
					isinform = $GetEle("isinform_"+i);
					if(isinform.value == "1"){
						changeCheckboxStatus(isinform,true);
					}
				}
		   </script>
			<input class="inputstyle" type="hidden" name="operation" value="applyinfo">
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
			<input class="inputstyle" type="hidden" name="rownum">
		</form>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
		    	<wea:group context="">
			    	<wea:item type="toolbar">
			    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.closeByHand();">
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
			function doSave(){
				document.frmMain.rownum.value = group.count;
				document.frmMain.submit();
			}
		</script>
	</BODY>
</HTML>
