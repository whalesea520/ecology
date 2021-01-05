
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-06-11 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	boolean isoracle = rs.getDBType().equals("oracle") ;
	boolean hasright = false;
	
	if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
	   hasright = true;
	}
	/*
	Add by Huang Yu FOR BUG 237 ON May 9th ,2004
	如果没有权限则判断是否和该招聘计划相关，即是否是通知人，负责人 或者是审核人
	*/
	String temptable1 ="";
	String sqlStr ="";
	if(!hasright){
	     temptable1 = "temptable"+Util.getNumberRandom();
	     if(isoracle) {
	         sqlStr = "CREATE TABLE "+temptable1+" AS SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate  From HrmCareerPlan t1 , HrmCareerInvite t2  , HrmCareerInviteStep t3 WHERE t1.ID = t2.CareerPlanID(+) and t2.ID = t3.InviteID(+) and (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
	     }
	     else{
	         sqlStr ="SELECT DISTINCT t1.id,t1.topic,t1.principalid,t1.informmanid,t1.startdate INTO "+temptable1+" From HrmCareerPlan t1 LEFT JOIN HrmCareerInvite t2 ON (t1.ID = t2.CareerPlanID) LEFT JOIN HrmCareerInviteStep t3 ON (t2.ID = t3.InviteID) WHERE (t1.principalid = "+user.getUID()+" or t1.informmanid = "+user.getUID()+" or t3.assessor = "+user.getUID()+")";
	     }
	
	     rs.executeSql(sqlStr);
	     rs.executeSql("Select count(*) as count From "+temptable1) ;
	     if(rs.next()){
			  if(rs.getInt("count") >0){
				 hasright = true;
			 }else{
				 rs.executeSql("drop table "+temptable1)    ;
			 }
		 }else{
				 rs.executeSql("drop table "+temptable1)    ;
		 }
	    
	}
	
	if(!hasright){
	     response.sendRedirect("/notice/noright.jsp");
	     return;
	}
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(6132,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String topic = Util.null2String(request.getParameter("topic"));
	String principalid = Util.null2String(request.getParameter("principalid"));
	String informmanid = Util.null2String(request.getParameter("informmanid"));
	String status = Util.null2String(request.getParameter("status"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
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
							url:"CareerPlanOperation.jsp?isdialog=1&operation=delete&id="+idArr[i],
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
			
			var dialog = null;
			var dWidth = 880;
			var dHeight = 500;
			var _status = "";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/career/careerplan/HrmCareerPlan.jsp?status="+_status;
			}
			
			function openDialog(id){
				if(window.top.Dialog){
					dialog = new window.top.Dialog();
				} else {
					dialog = new Dialog();
				}
				dialog.currentWindow = window;
				if(id==null){
					id="";
				}
				var url = "";
				if(!!id){
					dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,6132",user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCareerPlanEdit&isdialog=1&status=<%=status%>&id="+id;
					dialog.Width = dWidth;
					dialog.Height = dHeight;
					dialog.Modal = true;
					dialog.maxiumnable = true;
				}else{
					dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,6132",user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmCareerPlanAdd&isdialog=1&status=<%=status%>";
					dialog.Width = dHeight;
					dialog.Height = dHeight;
					dialog.Drag = true;
				}
				dialog.URL = url;
				dialog.show();
			}
			
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			
			function onLog(id){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				var url = "";
				if(id && id!=""){
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=70 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=70")%>";
				}
				dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
				dialog.Width = jQuery(window).width();
				dialog.Height = jQuery(window).height();
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			function doClose(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmCareerPlanEdit&method=finish&status=<%=status%>&id="+id,"<%=SystemEnv.getHtmlLabelNames("405,6132",user.getLanguage())%>");
			}
			function doInform(id){
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15782,user.getLanguage())%>",function(){
					document.location = "/hrm/career/careerplan/CareerPlanInformOperation.jsp?cmd=home&_status=<%=status%>&CareerPlanID="+id;
				});
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Delete", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("HrmCareerPlanAdd:Add", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%	
							}
							if(HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Delete", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
						<input type="hidden" name="status" value="<%=status%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="topic" name="topic" class="inputStyle" value='<%=topic%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="principalid" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp" width="80%" browserSpanValue="">
						        </brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15669,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="informmanid" browserValue="" 
					                browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
					                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
					                completeUrl="/data.jsp" width="80%" browserSpanValue="">
						        </brow:browser>
							</span>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = " a.id, a.topic, a.principalid, a.informmanid, a.startdate,a.enddate,a.advice "; 
			String fromSql  = " from ( select a.id, a.topic, a.principalid, a.informmanid, (case when (a.startdate is null or a.startdate = '') then '2299-12-31' else a.startdate end) as startdate,a.enddate, cast(a.advice as varchar(1000)) as advice from HrmCareerPlan a ) a ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.startdate, a.id " ;
			String tableString = "";
			
			if(topic.length() > 0){
				sqlWhere += " and a.topic like '%"+topic+"%' ";
			}else if(qname.length() > 0 ){
				sqlWhere += " and a.topic like '%"+qname+"%' ";
			}
			if(principalid.length() > 0){
				sqlWhere += " and a.principalid = "+principalid;
			}
			if(informmanid.length() > 0){
				sqlWhere += " and a.informmanid = "+informmanid;
			}
			if(status.length() > 0){
				if(status.equals("1")){
					if(isoracle) {
						sqlWhere += " and a.enddate is null ";	
					} else {
						sqlWhere += " and (a.enddate is null or a.enddate = '') ";	
					}
				}else if(status.equals("2")){
					if(isoracle) {
						sqlWhere += " and a.enddate is not null ";	
					} else {
						sqlWhere += " and (a.enddate is not null and a.enddate != '') ";
					}
				}
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"[HrmCareerPlan;+column:id+,+column:principalid+,"+user.getUID()+","+HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user)+"]:[HrmCareerPlan_canDelete;+column:id+,"+HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Delete", user)+"]:"+HrmUserVarify.checkUserRight("HrmCareerPlan:log", user)+":[HrmCareerPlan;+column:id+,+column:principalid+,"+user.getUID()+","+HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user)+"]:[HrmCareerPlan;+column:id+,+column:principalid+,"+user.getUID()+","+HrmUserVarify.checkUserRight("HrmCareerPlanEdit:Edit", user)+"]\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:onLog()\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="     <operate href=\"javascript:doClose()\" text=\""+SystemEnv.getHtmlLabelName(405,user.getLanguage())+"\" index=\"3\"/>";
 	       	operateString+="     <operate href=\"javascript:doInform()\" text=\""+SystemEnv.getHtmlLabelNames("15781,15761",user.getLanguage())+"\" index=\"4\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_052+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_052,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(344,user.getLanguage())+"\" column=\"topic\" orderkey=\"topic\" />"+
		    "		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(2097,user.getLanguage())+"\" column=\"principalid\" orderkey=\"principalid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
		    "		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(15669,user.getLanguage())+"\" column=\"informmanid\" orderkey=\"informmanid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" />"+
		    "		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(22168,user.getLanguage())+"\" column=\"startdate\" orderkey=\"startdate\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array[2299-12-31=null,default=+column:startdate+]}\"/>"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</BODY>
</HTML>
