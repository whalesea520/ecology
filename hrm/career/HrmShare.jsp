
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-04 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	int applyid = Util.getIntValue(request.getParameter("applyid"),0);
	String showpage = Util.null2String(request.getParameter("showpage"));
	String firstname="";
	String lastname="";
	String resourceid="";

	rs.executeProc("HrmCareerApply_SelectId",""+applyid);
	if(rs.next()){
		firstname=rs.getString("firstname");
		lastname=rs.getString("lastname");
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(1932,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())+
	"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+
	": "+Util.toScreen(lastname,user.getLanguage())+Util.toScreen(firstname,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.closeDialog();	
			}
		 	function doSave(){
		    	if(check_form(document.frmMain,'resourceid')){
				   	document.frmMain.submit();
		  		}
		 	}
		
			function doDel(id){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					var idArr = id.split(",");
					var ajaxNum = 0;
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"HrmShareOperation.jsp?method=delete&applyid=<%=applyid%>&resourceid="+idArr[i],
							type:"post",
							async:true,
							complete:function(xhr,status){
								ajaxNum--;
								if(ajaxNum==0){
									_table.reLoad();
								}
							}
						});
					}
				});
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(showpage.equals("1")){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%if(showpage.equals("1")){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="doSave();">
					<%}else if(showpage.equals("2")){%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage())%>" class="e8_btn_top" onclick="doDel();">
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%if(showpage.equals("1")){%>
		<FORM id=weaver name=frmMain action="HrmShareOperation.jsp" method=post >
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1932,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(119,user.getLanguage())%>'>
					<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
					<wea:item>
						<span>
							<brow:browser viewType="0" name="resourceid" browserValue='<%=resourceid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
								completeUrl="/data.jsp" width="80%" browserSpanValue='<%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%>'>
							</brow:browser>
						</span>
					</wea:item>
				</wea:group>
			</wea:layout>		
			<input type="hidden" name="method" value="add">
			<input type="hidden" name="applyid" value="<%=applyid%>">
			<input type=hidden name="firstname" value="<%=firstname%>">
			<input type=hidden name="lastname" value="<%=lastname%>">
		</form>
		<%}else if(showpage.equals("2")){
			String backFields = "a.hrmid,a.applyid";
			String sqlFrom = "from HrmShare a";
			String sqlWhere = "where a.applyid = "+applyid;
			String orderby = "" ;
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmCareerApply:Check", user)+"\"></popedom> ";
			operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="</operates>";
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_054+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_054,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.hrmid\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+                             
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(179,user.getLanguage())+"\"  column=\"hrmid\" orderkey=\"hrmid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\"/>"+ 
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		<%}%>
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
	</BODY>
</HTML>
