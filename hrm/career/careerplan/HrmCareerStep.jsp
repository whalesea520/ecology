<%@ page import="weaver.general.Util,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CareerPlanComInfo" class="weaver.hrm.career.CareerPlanComInfo" scope="page" />
<!-- modified by wcd 2014-06-13 [E7 to E8] -->
<%
	String id = request.getParameter("id");
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String planStartDate = "";
	String datesql ="select startdate from HrmCareerPlan where id = "+id;
	rs.executeSql(datesql);
	while(rs.next()){
		planStartDate = rs.getString("startdate");
	}
	boolean isFin = CareerPlanComInfo.isFinish(id);
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
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
		if(!isFin){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(!isFin){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<FORM id=weaver name=frmMain action="CareerPlanOperation.jsp" method=post >
			<div id="careerPlan" class="groupmain" style="width:100%"></div>
			<%
				String sql = "select * from HrmCareerPlanStep where planid = "+id +" order by id ";
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
				{width:"51%",tdclass:"desclass",colname:"<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%>",itemhtml:"<input class=inputstyle type=text style='width:98%' name='stepname'>"},
				{width:"22%",colname:"<%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>",itemhtml:"<BUTTON class=Calendar type=button onclick='getDate(this)'></BUTTON><SPAN name='showdate' class='weadate'><img src='/images/BacoError_wev8.gif' align='absmiddle'></SPAN><input class=inputstyle type=hidden name='stepstartdate'>"},
				{width:"22%",colname:"<%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%>",itemhtml:"<BUTTON class=Calendar type=button onclick='getDate(this)'></BUTTON><SPAN name='showdate' class='weadate'><img src='/images/BacoError_wev8.gif' align='absmiddle'></SPAN><input class=inputstyle type=hidden name='stependdate'>"}];
				var option= {
					openindex:true,
					navcolor:"#003399",
					basictitle:"<%=SystemEnv.getHtmlLabelName(15745,user.getLanguage())%>",
					toolbarshow:true,
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
		   </script>
			<input class="inputstyle" type="hidden" name="operation" value="step">
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
			var common = new MFCommon();
			function doSave(){
				try{
					var startDate = "<%=planStartDate%>";
					var array = group.getTableSeriaData().split("&");
					var $suffix;
					var $stepname;
					for(var i=0; i<array.length; i++){
						if(array[i].indexOf("stepname") < 0) continue;
						
						$suffix = array[i].split("=")[0].split("_")[1];
						$stepname = unescape(array[i].split("=")[1]);
						
						for(var j=0; j<array.length; j++){
							if(array[j].indexOf("stepstartdate") >= 0 && array[j+1].indexOf("stependdate") >= 0){
								if(array[j].split("=")[0].split("_")[1] != $suffix) continue;
								var $startdate = array[j].split("=")[1];
								var $enddate = array[j+1].split("=")[1];
								if(common.compareDate($startdate,startDate)<= 0){
									window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83454,user.getLanguage())%> '"+$stepname+"' <%=SystemEnv.getHtmlLabelName(83455,user.getLanguage())%>");
									return false;
								}
								if(common.compareDate($startdate,$enddate)> 0) {
									window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83454,user.getLanguage())%> '"+$stepname+"' <%=SystemEnv.getHtmlLabelName(83456,user.getLanguage())%>")
									return false;
								}
							}
						}
					}
				}catch(e){}
				document.frmMain.rownum.value = group.count;
				document.frmMain.submit();
			}
		</script>
	</BODY>
</HTML>
