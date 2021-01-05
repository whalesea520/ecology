
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-11-04 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CostcenterComInfo" class="weaver.hrm.company.CostCenterComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="JobActivitiesComInfo" class="weaver.hrm.job.JobActivitiesComInfo" scope="page" />
<jsp:useBean id="HrmSearchComInfo" class="weaver.hrm.search.HrmSearchComInfo" scope="session" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String from = Util.null2String(request.getParameter("from"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String nothrmids = Util.null2String(request.getParameter("nothrmids"));  //经过选择排除的邮件发送人
	String sqlwhere = HrmSearchComInfo.FormatSQLSearch();
	String tempsearchsql = HrmSearchComInfo.FormatSQLSearch();
	String jobtitleid = Util.null2String(HrmSearchComInfo.getJobtitle());
	String departmentid = Util.null2String(HrmSearchComInfo.getDepartment());
	String costcenterid = Util.null2String(HrmSearchComInfo.getCostcenter());
	String resourcetype = Util.null2String(HrmSearchComInfo.getResourcetype());
	String empstatus = Util.null2String(HrmSearchComInfo.getStatus());
	String orderby = Util.null2String(HrmSearchComInfo.getOrderby());

	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(1226,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(172,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentDialog = parent.parent.getDialog(parent);
			var nothrmids = "<%=nothrmids%>";
			
			function closeDialog(){
				if(parentDialog)
					parentDialog.close();
			}

			function changeCheck(obj){
				if(!obj.status){
					var rep = new RegExp("|"+obj.value,"g");
					nothrmids = nothrmids.replace(rep,"");
					nothrmids +="|"+obj.value;
				}else{
					var rep = new RegExp("|"+obj.value,"g");
					nothrmids = nothrmids.replace(rep,"");
				}
			}

			function changeValue(){
				jQuery("#costcenterSpan").html("");
				jQuery("input[name=costcenter]").val("");
			}

			function changePageSubmit(pageStr){
				location=pageStr+"&nothrmids="+nothrmids;
			}
			
			function shareNext(id){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				$GetEle("rid").value = id;
				
				var flag = true;
				var idss = id.split(",");
				var pattern =  /^(?:[a-z\d]+[_\-\+\.]?)*[a-z\d]+@(?:([a-z\d]+\-?)*[a-z\d]+\.)+([a-z]{2,})+$/i;
				for(var i=0;i<idss.length;i++){
					var objchk = jQuery("input[checkboxid="+idss[i]+"]").parent().parent().parent();
					var emailT = jQuery.trim(objchk.children("td").eq(5).text());
					if(emailT == "" || !pattern.test(emailT)){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125018,user.getLanguage())%>");
						flag = false;
						break;
					}
				}
				
				if(flag) {
					frmMain.action="HrmMailMerge.jsp?isDialog=<%=isDialog%>&issearch=1&nothrmids="+nothrmids;
					frmMain.submit();
				}
			}
		</script>
	</HEAD>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(1402,user.getLanguage())+",javascript:shareNext(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<FORM id=weaver name=frmMain action="HrmChoice.jsp" method=post>
			<input class=inputstyle type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>" >
			<input class=inputstyle type=hidden name="rid" value="" >
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("HrmMailMerge:Merge", user)){
						%>
								<input type=button class="e8_btn_top" onclick="shareNext();" value="<%=SystemEnv.getHtmlLabelName(1402,user.getLanguage())%>"></input>
						<%
							}
						%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div id=oDiv style="display:<%=from.equals("hrmorg")?"block":"none"%>">
			<TABLE class=ListStyle cellspacing=1  WIDTH=100%>
			<TR><TH COLSPAN=8 ALIGN=LEFT><%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%></TH></TR>
			</TABLE>
			<TABLE CLASS=VIEWForm>
			<COL WIDTH=15%>
			<COL WIDTH=27%>
			<COL WIDTH=5%>
			<COL WIDTH=*%>
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
				<TD class=Field>

				  <input class="wuiBrowser" id=department type=hidden name=department value="<%=departmentid%>"
				  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
				  _displayText="<%=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage())%>"
				  _callback="changeValue">
				 </TD>
				<TD></TD>
				<TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
				<TD CLASS=Field colspan=5>
				<%
				String ischecked = "";
				if(resourcetype.equals("2"))
					ischecked = " checked";
				%>
					<INPUT class=inputstyle TYPE=radio VALUE="2" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(131,user.getLanguage())%>
				<%
				ischecked = "";
				if(resourcetype.equals("1"))
					ischecked = " checked";
				%>
					<INPUT class=inputstyle TYPE=radio VALUE="1" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(130,user.getLanguage())%>
				<%
				ischecked = "";
				if(resourcetype.equals("3"))
					ischecked = " checked";
				%>	<INPUT class=inputstyle TYPE=radio VALUE="3" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(134,user.getLanguage())%>
				<%
				ischecked = "";
				if(resourcetype.equals("4"))
					ischecked = " checked";
				%>	<INPUT class=inputstyle TYPE=radio VALUE="4" name=resourcetype <%=ischecked%>><%=SystemEnv.getHtmlLabelName(480,user.getLanguage())%>
				<%
				ischecked = "";
				if(resourcetype.equals(""))
					ischecked = " checked";
				%>	<INPUT class=inputstyle TYPE=radio VALUE="" name=resourcetype <%=ischecked%>>
				<%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%>
				</TD>
			</TR>
			 <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
			<TR><TD><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></TD>
				 <TD class=Field>
				 
				  <input class="wuiBrowser" id=costcenter type=hidden name=costcenter value="<%=costcenterid%>"
				  _url="/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp"
				  _displayText="<%=Util.toScreen(CostcenterComInfo.getCostCentername(costcenterid),user.getLanguage())%>">
				 </TD><TD></TD>
				<TD><%=SystemEnv.getHtmlLabelName(169,user.getLanguage())%></TD>

					<TD CLASS=Field colspan=4>
					<SELECT CLASS=INPUTSTYLE Name=status >
					<%
				ischecked = "";
				if(empstatus.equals("0"))
					ischecked = " selected";
				%>
						<OPTION VALUE="0" <%=ischecked%>>
				<%
				ischecked = "";
				if(empstatus.equals("1"))
					ischecked = " selected";
				%>
						<OPTION VALUE="1" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(155,user.getLanguage())%>
				<%
				ischecked = "";
				if(empstatus.equals("2"))
					ischecked = " selected";
				%>
						<OPTION VALUE="2" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(415,user.getLanguage())%>
				</TD>
			</TR>
			<TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
			<TR>
				<TD><%=SystemEnv.getHtmlLabelName(338,user.getLanguage())%></TD>
				<TD CLASS=Field><SELECT class=inputstyle Name=orderby >
				<%
				ischecked = "";
				if(orderby.equals("id"))
					ischecked = " selected";
				%>
						<OPTION VALUE="id" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("firstname"))
					ischecked = " selected";
				%>	<OPTION VALUE="firstname" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(460,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("lastname"))
					ischecked = " selected";
				%>	<OPTION VALUE="lastname" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(461,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("birthday"))
					ischecked = " selected";
				%>	<OPTION VALUE="birthday" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(464,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("jobtitle"))
					ischecked = " selected";
				%>	<OPTION VALUE="jobtitle" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(357,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("countryid"))
					ischecked = " selected";
				%>	<OPTION VALUE="countryid" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("nationality"))
					ischecked = " selected";
				%>	<OPTION VALUE="nationality" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(465,user.getLanguage())%>
				<%
				ischecked = "";
				if(orderby.equals("costcenterid"))
					ischecked = " selected";
				%>	<OPTION VALUE="costcenterid" <%=ischecked%>><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%>
					</SELECT></TD>
					<TD></TD>
					<TD></TD>
					<TD></TD>
			 </TR>
			 <TR style="height:1px"><TD class=Line colSpan=6></TD></TR>
			 </TABLE>
			</div>
		</FORM>
		<%
			String pageId = HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)?PageIdConst.HRM_ResourceSearchResultByManager:PageIdConst.HRM_ResourceSearchResult;
			String backFields = " HrmResource.*,b.jobactivityid,b.jobtitlename,c.jobactivityname "; 
			String sqlFrom  = " HrmResource left join HrmJobTitles b on HrmResource.jobtitle = b.id left join HrmJobActivities c on b.jobactivityid = c.id ";
			String sqlWhere = tempsearchsql;
			int orderByIndex = sqlWhere.indexOf("order by");
			if(orderByIndex != -1){
				sqlWhere = sqlWhere.substring(0,orderByIndex);
			}
			String _orderby = Tools.vString(orderby);
			if(_orderby.length() > 0){
				if(_orderby.startsWith("order by")){
					_orderby = _orderby.substring("order by".length()+1); 
				}
				if(_orderby.equals("id")){
					_orderby = "";
				} else {
					_orderby = "HrmResource." +_orderby;
				}
			}
			rs.executeSql("select"+backFields+sqlFrom+sqlWhere+" "+_orderby);
			StringBuffer selectedstrs = new StringBuffer();
			int _index = 0;
			while(rs.next()){
				selectedstrs .append (_index==0 ? "" : ",").append(rs.getString("id"));
				_index++;
			}
			String tableString = 
				"<table pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"HrmResource.id\" sqlorderby=\""+_orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					"<head>"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(714,user.getLanguage())+"\" column=\"workcode\" orderkey=\"workcode\" />"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(460,user.getLanguage())+"\" column=\"firstname\" orderkey=\"firstname\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:append[+ +column:lastname+]}\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_blank\"/>"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkkey=\"id\" linkvaluecolumn=\"departmentid\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp\" target=\"_blank\"/>"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(378,user.getLanguage())+"\" column=\"locationid\" orderkey=\"locationid\" transmethod=\"weaver.hrm.location.LocationComInfo.getLocationname\" linkkey=\"id\" linkvaluecolumn=\"locationid\" href=\"/hrm/location/HrmLocationEdit.jsp\" target=\"_blank\"/>"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(477,user.getLanguage())+"\" column=\"email\" orderkey=\"email\" />"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(547,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.hrm.resource.ResourceComInfo.isOnline\" />"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(421,user.getLanguage())+"\" column=\"telephone\" orderkey=\"telephone\" />"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\" linkkey=\"id\" linkvaluecolumn=\"jobtitle\" href=\"/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit\" target=\"_blank\"/>"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(357,user.getLanguage())+"\" column=\"jobactivityname\" orderkey=\"jobactivityname\" linkkey=\"id\" linkvaluecolumn=\"jobactivityid\" href=\"/hrm/HrmDialogTab.jsp?_fromURL=HrmJobActivitiesEdit\" target=\"_blank\"/>"+
						"<col width=\"9%\"  text=\""+SystemEnv.getHtmlLabelName(2120,user.getLanguage())+"\" column=\"managerid\" orderkey=\"managerid\" transmethod=\"weaver.hrm.resource.ResourceComInfo.getResourcename\" linkkey=\"id\" linkvaluecolumn=\"managerid\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_blank\"/>"+
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs.toString()%>" mode="run" />
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
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
		<script language=vbs>
			sub onShowDepartment()
				id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&frmMain.department.value)
				if Not isempty(id) then
				if id(0)<> 0 then
				departmentspan.innerHtml = id(1)
				frmMain.department.value=id(0)
				costcenterspan.innerHtml = ""
				frmMain.costcenter.value=""
				else
				departmentspan.innerHtml = ""
				frmMain.department.value=""
				end if
				end if
			end sub
			sub onShowCostCenter()
				id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/CostcenterBrowser.jsp?sqlwhere= where departmentid="&frmMain.department.value)
				if Not isempty(id) then
				if id(0)<> 0 then
				costcenterspan.innerHtml = id(1)
				frmMain.costcenter.value=id(0)
				else
				costcenterspan.innerHtml = ""
				frmMain.costcenter.value=""
				end if
				end if
			end sub
		</script>
	</BODY>
</HTML>
