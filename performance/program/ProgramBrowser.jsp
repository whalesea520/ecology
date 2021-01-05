<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.gp.util.TransUtil" scope="page" />
<%
	String currentUserId = user.getUID()+"";
	String sqlwhere1 = Util.null2String(request.getParameter("sqlwhere"));
	String programtype = Util.getIntValue(request.getParameter("programtype"),0)+"";
	String programname = Util.fromScreen3(request.getParameter("programname"),user.getLanguage());
	String status = Util.fromScreen3(request.getParameter("status"),user.getLanguage());
	String noid = Util.fromScreen3(request.getParameter("noid"),user.getLanguage());
	String param = Util.null2String(request.getParameter("param"));
	if(!param.equals("")){
		String[] ps = param.split("_");
		if(ps.length>0){
			programtype = ps[0];
		}
		if(ps.length>1){
			noid = ps[1];
		}
	}
	
	String sqlWhere = "where t.userid=h.id "
		+" and (h.id="+currentUserId+" or h.managerstr like '%,"+currentUserId+",%'"
		+" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.subcompanyid1 and bs.resourcetype=2 and (bs.programcreate like '%,"+currentUserId+",%' or bs.programaudit like '%,"+currentUserId+",%'))"
		+" or exists(select 1 from GP_BaseSetting bs where bs.resourceid=h.departmentid and bs.resourcetype=3 and (bs.programcreate like '%,"+currentUserId+",%' or bs.programaudit like '%,"+currentUserId+",%'))"
		+")";
	if(!noid.equals("")){
		sqlWhere += " and t.id <>"+noid;
	}
	if(!programtype.equals("0")){
		sqlWhere += " and t.programtype ="+programtype;
	}
	if(!programname.equals("")){
		sqlWhere += " and t.programname like '%"+programname+"%'";
	}
	if(!status.equals("")){
		sqlWhere += " and t.status ="+status;
	}

	int pagenum=Util.getIntValue(request.getParameter("pagenum"),1);
	int	perpage=50;
	RecordSet.executeSql("Select count(distinct t.id) RecordSetCounts from GP_AccessProgram t,HrmResource h "+sqlWhere);
	boolean hasNextPage=false;
	int RecordSetCounts = 0;
	if(RecordSet.next()){
		RecordSetCounts = RecordSet.getInt("RecordSetCounts");
	}
	if(RecordSetCounts>pagenum*perpage){
		hasNextPage=true;
	}
	int iTotal =RecordSetCounts;
	int iNextNum = pagenum * perpage;
	int ipageset = perpage;
	if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
	if(iTotal < perpage) ipageset = iTotal;
	String querysql = "t.id,t.programname,t.startdate,t.programtype,t.status from GP_AccessProgram t,HrmResource h "+sqlWhere;
	/**
	sqltemp="select distinct top "+iNextNum
		+" t.id,t.programname,t.startdate,t.programtype,t.status from GP_AccessProgram t,HrmResource h "+sqlWhere+" order by t.id desc";
	sqltemp = "select top " + ipageset +" t2.* from (" + sqltemp + ") t2 order by t2.id asc";
	sqltemp = "select top " + ipageset +" t3.* from (" + sqltemp + ") t3 order by t3.id desc";
	*/
	String sql = "";
	if("oracle".equals(RecordSet.getDBType())){
		sql = "select " + querysql + " order by t.id desc";
		sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum);
		sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum - perpage);
	}else{
		sql = "select top " + ipageset +" t2.* from (select distinct top " + iNextNum + querysql + " order by t.id desc) t2 order by t2.id asc";
		sql = "select top " + ipageset +" t3.* from (" + sql + ") t3 order by t3.id desc";
	}
	
	//System.out.println("sqltemp:"+sqltemp);
	RecordSet.executeSql(sql);
	String titlename = "执行力-引用方案";
%>
<HTML>
	<HEAD>
	<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

	<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
		<colgroup>
			<col width="10">
			<col width="">
			<col width="10">
		</colgroup>
		<tr>
			<td height="10" colspan="3"></td>
		</tr>
		<tr>
			<td ></td>
			<td valign="top">
				<TABLE class=Shadow>
					<tr>
						<td valign="top">
	
							<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="ProgramBrowser.jsp" method=post>
								<input class=inputstyle type=hidden name=sqlwhere value="<%=sqlwhere1%>">
								<input type="hidden" name="pagenum" value=''>
								<DIV align=right style="display:none">
									<%
									RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:SearchForm.submit(),_self} " ;
									RCMenuHeight += RCMenuHeightStep ;
									%>
									<BUTTON class=btnSearch accessKey=S type=submit><U>S</U>-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></BUTTON>
									<%
									RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:SearchForm.reset(),_self} " ;
									RCMenuHeight += RCMenuHeightStep ;
									%>
									<BUTTON class=btnReset accessKey=T type=reset><U>T</U>-<%=SystemEnv.getHtmlLabelName(199,user.getLanguage())%></BUTTON>
									<%
									RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:closeDialog(),_self} " ;
									RCMenuHeight += RCMenuHeightStep ;
									%>
									<BUTTON class=btn accessKey=1 onclick="closeDialog();"><U>1</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
									<%
									RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
									RCMenuHeight += RCMenuHeightStep ;
									%>	
									<BUTTON class=btn accessKey=2 id=btnclear><U>2</U>-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%></BUTTON>
								</DIV>
								<table width=100% class=ViewForm>
									<COLGROUP>
										<COL width="11%"/>
										<COL width="22%"/>
										<COL width="11%"/>
										<COL width="22%"/>
										<COL width="12%"/>
										<COL width="22%"/>
									</COLGROUP>
									<TBODY>
										<TR>
											<TD class="title">名称</TD>
											<TD class="Field">
												<INPUT class=inputstyle type=text name="programname" value="<%=programname%>" style="width:95%" maxlength="50"/>
											</TD>
											
											<TD class="title">类型</TD>
											<TD class="Field">
												<select name="programtype">
													<option value=""></option>
													<option value="1" <%if(programtype.equals("1")){ %> selected="selected" <%} %>>月度</option>
													<option value="2" <%if(programtype.equals("2")){ %> selected="selected" <%} %>>季度</option>
													<option value="3" <%if(programtype.equals("3")){ %> selected="selected" <%} %>>半年</option>
													<option value="4" <%if(programtype.equals("4")){ %> selected="selected" <%} %>>年度</option>
												</select>
											</TD>
											
											<TD class="title">状态</TD>
											<TD class="Field">
												<select name="status">
													<option value=""></option>
													<option value="0" <%if(status.equals("0")){ %> selected="selected" <%} %>>草稿</option>
													<option value="1" <%if(status.equals("1")){ %> selected="selected" <%} %>>审批中</option>
													<option value="2" <%if(status.equals("2")){ %> selected="selected" <%} %>>退回</option>
													<option value="3" <%if(status.equals("3")){ %> selected="selected" <%} %>>已通过</option>
												</select>
											</TD>
										</TR>
										<tr style="height: 1px">
											<td class=Line colspan=6></td>
										</tr>
										<TR class=Spacing style="height: 1px"><TD class=Line1 colspan=6></TD></TR>
									</TBODY>
								</table>
								<TABLE ID=BrowseTable class="BroswerStyle" width="100%" cellspacing="1" STYLE="margin-top:0">
										<COLGROUP>
											<COL width="50%">
											<COL width="15%">
											<COL width="15%">
											<COL width="20%">
										</COLGROUP>
										<TBODY>
											<TR class=DataHeader>
												<TH>
													名称
												</TH> 
												<TH>
													类型
												</TH>
												<TH>
													状态
												</TH>
												<TH>
													生效日期
												</TH>
											</tr>
											<TR class=Line><TH colspan="4" ></TH></TR>

											<%
												int i=0;
												while(RecordSet.next()){
													if(i==0){
														i=1;
											%>
													<TR class=DataLight>
											<%
												}else{
													i=0;
											%>
													<TR class=DataDark>
											<%
												}
											%>
												<TD style="display:none"><%=RecordSet.getString("id")%></TD>
												<TD><%=RecordSet.getString("programname")%></TD>
												<td><%=cmutil.getType1(RecordSet.getString("programtype")) %></td>
												<td><%=cmutil.getProgramStatus(RecordSet.getString("status")) %></td>
												<td><%=RecordSet.getString("startdate") %></td>
											</TR>
											<%}%>
										</TBODY>
									</TABLE>

									<table align=right>
									<tr style="display:none">
									   <td>&nbsp;</td>
									   <td>
										   <%if(pagenum>1){%>
									<%
									RCMenu += "{"+SystemEnv.getHtmlLabelName(1258,user.getLanguage())+",javascript:weaver.prepage.click(),_top} " ;
									RCMenuHeight += RCMenuHeightStep ;
									%>
												<button type=submit class=btn accessKey=P id=prepage onclick="document.all('pagenum').value=<%=pagenum-1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258,user.getLanguage())%></button>
										   <%}%>
									   </td>
									   <td>
										   <%if(hasNextPage){%>
									<%
									RCMenu += "{"+SystemEnv.getHtmlLabelName(1259,user.getLanguage())+",javascript:weaver.nextpage.click(),_top} " ;
									RCMenuHeight += RCMenuHeightStep ;
									%>
												<button type=submit class=btn accessKey=N  id=nextpage onclick="document.all('pagenum').value=<%=pagenum+1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259,user.getLanguage())%></button>
										   <%}%>
									   </td>
									   <td>&nbsp;</td>
									</tr>
									</table>
								</FORM>
							</td>
						</tr>
					</TABLE>
				</td>
				<td></td>
			</tr>
			<tr style="height: 10px;">
				<td height="10" colspan="3"></td>
			</tr>
		</table>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<script type="text/javascript">
			var dialog;
			try{
				dialog = parent.parent.getDialog(parent);
			}catch(e){}
			
			jQuery(document).ready(function(){
				//alert(jQuery("#BrowseTable").find("tr").length)
				jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("click",function(){
						selectData($(this).find("td:first").text(),$(this).find("td:eq(0)").next().text());
					})
				jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseover",function(){
						$(this).addClass("Selected")
					})
					jQuery("#BrowseTable").find("tr[class^='Data'][class!='DataHeader']").bind("mouseout",function(){
						$(this).removeClass("Selected")
					})
			
			});
			
			function submitClear()
			{
				if(dialog){
				  try {
						var returnjson ={id:"0",name:""};
						dialog.callback(returnjson);
					} catch(e) {}
				  
				  try {
						dialog.close();
					} catch(e) {}
				}else{
				   window.parent.returnValue = {id:"0",name:""};
				   window.parent.close();
				}
			}
			function closeDialog(){
			   if(dialog){
				  try {
						dialog.close();
					} catch(e) {}
				}else{
				   window.parent.close();
				}
			}
			function selectData(id, name) {
				var returnjson = {id: id,name: name};
				if(dialog){
					try {
						dialog.callback(returnjson);
					} catch(e) {}
			
					try {
						dialog.close(returnjson);
					} catch(e) {}
				}else{
					window.parent.returnValue = returnjson;
					window.parent.close();
				}
			}
		</script>
	</BODY>
</HTML>