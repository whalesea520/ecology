
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-08-06 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(19397,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(320,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String subid=Util.null2String(request.getParameter("subcompanyid"));
	String deptid=Util.null2String(request.getParameter("departmentid"));

	if(subid.equals("")){
		subid=DepartmentComInfo.getSubcompanyid1(deptid);
	}
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int operatelevel=-1;
	if(detachable==1){
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmScheduleMaintanceAdd:Add",Util.getIntValue(subid,0));
	}else{
		if(HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user))
			operatelevel=2;
	}
	if(operatelevel<0){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	boolean CanAdd = operatelevel>0;
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
					jQuery.ajax({
						url:"HrmScheduleMonthOperation.jsp?operation=delete&subcompanyid=<%=subid%>&departmentid=<%=deptid%>&ids="+id,
						type:"post",
						async:true,
						complete:function(xhr,status){
							_table.reLoad();
						}
					});
				});
			}
			
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			var subcompanyid = "";
			var departmentid = "";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location = "/hrm/schedule/HrmScheduleMonth.jsp?subcompanyid="+subcompanyid+"&departmentid="+departmentid;
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
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmScheduleMonth&method=HrmScheduleMonthAdd&isdialog=1&subcompanyid=<%=subid%>&departmentid=<%=deptid%>","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19397,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=HrmScheduleMonth&method=HrmScheduleMonthEdit&isdialog=1&subcompanyid=<%=subid%>&departmentid=<%=deptid%>&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(19397,user.getLanguage())%>");
			
			}
		</script>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(CanAdd) {
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
			RCMenuHeight += RCMenuHeightStep;
		}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name=subform method=post>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td>
					</td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(HrmUserVarify.checkUserRight("HrmScheduleMaintanceAdd:Add", user)){ %>
							<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
							<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%}%>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		</form>
		<%
			String orgtype = "";
			if(deptid.length()>0){
				orgtype = "dept";
			}else{
				orgtype = "com";
			}
			String backfields = ""; 
			String fromSql  = "";
			if(orgtype.equals("dept")){
				backfields = " * "; 
				fromSql =" (select a.theyear,a.themonth,b.departmentid,d.departmentname,row_number()over(order by a.theyear,a.themonth) as num from hrmschedulemonth a left join hrmresource b on a.hrmid = b.id left join HrmSubCompany c on b.subcompanyid1 = c.id left join HrmDepartment d on b.departmentid = d.id group by a.theyear,a.themonth,b.departmentid,d.departmentname ) a ";
			}else{
				backfields = " a.num,a.theyear,a.themonth,a.subcompanyid1,a.subcompanyname "; 
				fromSql =" (select a.theyear,a.themonth,b.subcompanyid1,c.subcompanyname,row_number()over(order by a.theyear,a.themonth) as num from hrmschedulemonth a left join hrmresource b on a.hrmid = b.id left join HrmSubCompany c on b.subcompanyid1 = c.id group by a.theyear,a.themonth,b.subcompanyid1,c.subcompanyname) a ";
			}
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.theyear,a.themonth " ;
			String tableString = "";
			
			if(!orgtype.equals("dept")&&subid.length() > 0){
				sqlWhere += " and a.subcompanyid1 = "+subid;
			}
			
			if(deptid.length() > 0){
				String deptids=SubCompanyComInfo.getDepartmentTreeStr(deptid);
				deptids=deptid+","+deptids;
				deptids=deptids.substring(0,deptids.length()-1);
				sqlWhere += " and a.departmentid in ("+deptids+")";
			}
			
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"true:true\"></popedom> ";
 	       	operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="</operates>";
			tableString =" <table pageId=\""+Constants.HRM_Z_061+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_061,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"true\" />"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.num\" sqlsortway=\"desc\" sqlisdistinct=\"false\"/>"+
		    operateString+
		    "	<head>"+
		    "		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(887,user.getLanguage())+"\" column=\"themonth\" orderkey=\"themonth\" />"+
		    "		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15933,user.getLanguage())+"\" column=\"theyear\" orderkey=\"theyear\" />";
				if(orgtype.equals("dept")){
					tableString += "		<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"departmentname\" orderkey=\"departmentname\" />";
				}else{
		    	tableString += "		<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyname\" orderkey=\"subcompanyname\" />";
		    }
		    tableString += "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
		<%--
<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
<%
int rownum=(l.size()+2)/3;
 	int needtd=rownum;
    Iterator iter=l.iterator();
     while(iter.hasNext()){
 		String theyear=(String)iter.next();
 	%>
 	<wea:group context='<%=theyear+SystemEnv.getHtmlLabelName(17138,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
      <%RecordSet.beforFirst();
      while(RecordSet.next()){
      	if(RecordSet.getString("theyear").equals(theyear)){%>
				<wea:item attributes="{'colspan':'2'}"><%if(CanAdd){%><a href="HrmScheduleMonthList.jsp?year=<%=theyear%>&month=<%=RecordSet.getString("themonth")%>&type=<%=orgtype%>&id=<%=orgid%>"><%}%>
				<%=RecordSet.getString("themonth")+SystemEnv.getHtmlLabelName(19398,user.getLanguage())%><%if(CanAdd){%></a><%}%></wea:item>
			<%
				}
    	}
			%>
	</wea:group>
	<%}%>
	<%if(l.size()==0){ %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33213,user.getLanguage())%>' attributes="{'groupOperDisplay':'none'}">
			<wea:item attributes="{'colspan':'2'}">SystemEnv.getHtmlLabelName(129260, user.getLanguage())</wea:item>
		</wea:group>
	<%} %>
	</wea:layout>
	--%>
	</body>
</html>
