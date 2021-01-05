
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 

<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="weaver.general.Util" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportTypeComInfo" class="weaver.workflow.report.ReportTypeComInfo" scope="page" />
<jsp:useBean id="formComInfo" class="weaver.workflow.form.FormComInfo" scope="page" />
<jsp:useBean id="billComInfo" class="weaver.workflow.workflow.BillComInfo" scope="page" />
<jsp:useBean id="workflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />


<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></SCRIPT>
	</HEAD>
<%

	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdHRMCard_wev8.gif";
	//自定义查询:编辑
    String titlename = SystemEnv.getHtmlLabelName(20773,user.getLanguage())+ ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	
	String formID = "";	
	String isBill = "1";
    String Customname = "";
	String modeid = "";
	String modename = "";
    String Customdesc = "";
	String formName = "";
	String defaultsql = "";
	String disQuickSearch = "";
	String norightlist = "";
	int opentype = 0;//打开方式
	
	String id = Util.null2String(request.getParameter("id"));
	String sql = "select a.modeid,a.customname,a.customdesc,b.modename,b.formid,a.defaultsql,a.disQuickSearch,a.norightlist,a.opentype from mode_customsearch a,modeinfo b where a.modeid = b.id and a.id="+id;
	RecordSet.executeSql(sql);
	if(RecordSet.next()){
		formID = Util.null2String(RecordSet.getString("formid"));	
		isBill = "1";
	    Customname = Util.toScreen(RecordSet.getString("Customname"),user.getLanguage()) ;
		modeid = Util.null2String(RecordSet.getString("modeid"));
		modename = Util.null2String(RecordSet.getString("modename"));
	    Customdesc = Util.toScreenToEdit(RecordSet.getString("Customdesc"),user.getLanguage());
	    defaultsql = Util.toScreenToEdit(RecordSet.getString("defaultsql"),user.getLanguage());
	    disQuickSearch = Util.toScreenToEdit(RecordSet.getString("disQuickSearch"),user.getLanguage());
		formName = SystemEnv.getHtmlLabelName(Util.getIntValue(billComInfo.getBillLabel(formID)), user.getLanguage());
		norightlist = Util.null2String(RecordSet.getString("norightlist"));
		opentype = Util.getIntValue(RecordSet.getString("opentype"),0);
	}

%>

	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;//保存
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} " ;//删除
			RCMenuHeight += RCMenuHeightStep;
			
			//共享
			RCMenu += "{"+SystemEnv.getHtmlLabelName(119,user.getLanguage())+",javascript:doCustomSearchBatchSet(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			//编辑自定义查询
			RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(20773,user.getLanguage())+",javascript:onAddField(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			//批量
			RCMenu += "{"+SystemEnv.getHtmlLabelName(27244,user.getLanguage())+",javascript:doBatchSet(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			
			//返回
			RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doback(),_self} " ;
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30247,user.getLanguage())+",javascript:createmenu(),_self} " ;//创建查询菜单
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30248,user.getLanguage())+",javascript:viewmenu(),_self} " ;//查看查询菜单地址
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30245,user.getLanguage())+",javascript:createmenu1(),_self} " ;//创建监控菜单
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{"+SystemEnv.getHtmlLabelName(30246,user.getLanguage())+",javascript:viewmenu1(),_self} " ;//查看监控菜单地址
			RCMenuHeight += RCMenuHeightStep;
		%>

		<FORM id=weaver name=frmMain action="/formmode/search/CustomSearchOperation.jsp" method=post>
			<TABLE width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<COLGROUP>
					<COL width="10">
					<COL width="">
					<COL width="10">
				<TR>
					<TD height="10" colspan="3"></TD>
				</TR>
				<TR>
					<TD ></TD>
					<TD valign="top">
						<TABLE class=Shadow>
							<TR>
								<TD valign="top">
									<TABLE class="viewform">
										<COLGROUP>
											<COL width="20%">
											<COL width="80%">
									  	<TBODY>
			        						        
									        <TR class="Spacing" style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD><!-- 名称 -->
									          	<TD class=Field>
									        		<INPUT type=text class=Inputstyle size=30 name="Customname" maxlength="50" onchange='checkinput("Customname","Customnameimage")' value="<%=Customname%>">
									          		<SPAN id=Customnameimage></SPAN>
									          	</TD>
									        </TR>
									        <TR style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									  		<TR>									          
									      		<TD><%=SystemEnv.getHtmlLabelName(15451,user.getLanguage())%></TD><!-- 表单名称 -->
									      		<TD class=Field>
									      			<%= formName %>
									            	<INPUT type=hidden name=formID id=formID value=<%=formID%>>
									            	<INPUT type=hidden name=isBill id=isBill value=<%=isBill%>>
									            </TD>
									        </TR>
									        
									        <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
									    	<TR>
									      		<TD><%=SystemEnv.getHtmlLabelName(28485,user.getLanguage())%></TD><!-- 模块名称 -->
									      		<TD class=Field >
									      		<!-- 
                                                 <BUTTON type=button class=Browser onclick="onShowModeSelect(modeid, modeidspan)"></BUTTON>
                                                  -->
                                                    <SPAN id=modeidspan><%=modename%></SPAN>
                                                    <INPUT type=hidden name=modeid id=modeid value="<%=modeid%>">
									            </TD>
									        </TR>
									        <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD><!-- 描述 -->
                                              <TD class=Field>
                                                  <textarea rows="4" style="width:80%" name="Customdesc" onchange="this.value = this.value.substring(0, 2000)" maxlength="2000" class=Inputstyle><%=Customdesc%></textarea>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(81366,user.getLanguage())%></TD><!-- 固定查询条件 -->
                                              <TD class=Field>
                                                  <textarea rows="4" style="width:80%" name="defaultsql" onchange="this.value = this.value.substring(0, 2000)" maxlength="2000" class=Inputstyle><%=defaultsql%></textarea>
                                                  <br>
                                                  <%=SystemEnv.getHtmlLabelName(81388,user.getLanguage())%><!-- 表单主表表名的别名为t1，查询条件的格式为: t1.a = '1' and t1.b = '3' and t1.c like '%22%' -->
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(81367,user.getLanguage())%></TD><!-- 隐藏快捷搜索 -->
                                              <TD class=Field>
                                                  <INPUT type="checkbox" class=Inputstyle size=30 name="disQuickSearch" value="1" <%if(disQuickSearch.equals("1")){out.println("checked");} %>>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(81476,user.getLanguage())%></TD><!-- 无权限列表 -->
                                              <TD class=Field>
                                                  <INPUT type="checkbox" class=Inputstyle size=30 name="norightlist" value="1" <%if(norightlist.equals("1")){out.println("checked");} %>>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
									    	
                                            <TR>
                                              <TD><%=SystemEnv.getHtmlLabelName(30847,user.getLanguage())%></TD><!-- 数据打开方式 -->
                                              <TD class=Field>
                                              	<select id="opentype" name="opentype">
													<option value="0" <%if(opentype==0)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%></option><!-- 弹出窗口 -->
													<option value="1" <%if(opentype==1)out.println("selected"); %>><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%></option><!-- 默认窗口 -->                                              	
                                              	</select>
                                              </TD>
                                            </TR>  
                                            <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>
									    	
									        <input type="hidden" name=operation value=customedit>
											<input type="hidden" name=id value=<%=id%>>
									 	</TBODY>
									</TABLE>
	
  							</FORM>						
  									<BR>
  		
  									<!--================== 自定义字段显示项 ==================-->
									<TABLE>  
										<TR > 
										    <TD width="80%" colspan=2><%=SystemEnv.getHtmlLabelName(20773,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19495,user.getLanguage())%></TD><!-- 自定义查询、显示字段 -->
										</TR>
										    <TR class="Spacing"  style="height:1px;">
									    		<TD class="Line1" colSpan=2 ></TD>
									    	</TR>  
									</TABLE>

									<TABLE class=liststyle cellspacing=1  >
										<COLGROUP> 
											<COL width="15%"> 
											<COL width="10%"> 
											<COL width="10%">
											<COL width="10%">
											<COL width="10%">
											<COL width="10%">
                                            <COL width="10%">
											<COL width="10%">
											<COL width="10%">
									  	<TBODY> 																		
									  	<TR class=Header> 
										    <TD><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></TD><!-- 字段名称 -->
										    <TD><%=SystemEnv.getHtmlLabelName(20779,user.getLanguage())%></TD><!-- 表头 -->
										    <TD><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></TD><!-- 标题字段 -->
                                            <TD><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD><!-- 标题显示顺序 -->
										    <TD><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%><span id="sumcolwidthspan"></span></TD><!-- 列宽 -->
										    <TD><%=SystemEnv.getHtmlLabelName(15512,user.getLanguage())%></TD><!-- 排序字段 -->
										    <TD><%=SystemEnv.getHtmlLabelName(20778,user.getLanguage())%></TD><!-- 是否作为查询条件 -->
                                            <TD><%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></TD><!-- 查询显示顺序 -->
											 <TD><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></TD><!-- 删除 -->
									  	</TR>
									    <TR  class="Line"  style="height:1px;"> 
									    	<TD colspan=8 style="padding:0;"></TD>
									  	</TR>
									
										<%
											String theid = "";
											String fieldname = "";
											String dsporder = "";
											String isquery = "";
											String isshow = "";
                                            String queryorder="";
                                            String istitle="";
                                            String colwidth="";
											int i=0;
											int dbordercount = 0 ;
											double sumcolwidth = 0;
											int isorder=-1;
											
											RecordSet.executeSql("select * from mode_CustomDspField where customid = " + id + "  and fieldid>-10 and fieldid<0 order by showorder ");
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("id")) ;
												if("-2".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(882,user.getLanguage());//创建人
												}
												else if("-1".equals(RecordSet.getString("fieldid")))
												{
													fieldname = SystemEnv.getHtmlLabelName(722,user.getLanguage());//创建日期
												}
												
											
												dsporder = Util.null2String(RecordSet.getString("showorder")) ;
												isquery = Util.null2String(RecordSet.getString("isquery")) ;
												isshow = Util.null2String(RecordSet.getString("isshow")) ;
												queryorder = Util.null2String(RecordSet.getString("queryorder")) ;
												istitle = Util.null2String(RecordSet.getString("istitle")) ;
												colwidth = Util.null2String(RecordSet.getString("colwidth")) ;
												sumcolwidth += Util.getDoubleValue(colwidth,0);
												isorder =  Util.getIntValue(RecordSet.getInt("isorder")+"",0);
												
												if(!colwidth.equals("")){
													colwidth = String.format("%.2f", Util.getDoubleValue(colwidth,0)) + "%";
												}
												
										
												if(i==0)
												{
													i=1;
										%>
										<TR class=DataLight> 
										    
										<%
												}
												else
												{
													i=0;
										%>
										<TR class=DataDark> 
										<%
												}
										%>
										    <TD><%=fieldname%></TD>
											<TD ><%if(isshow.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
											<TD ><%if(istitle.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
                                            <TD><%=dsporder%></TD>
                                            <TD><%=colwidth%></TD>
                                            <TD ><%if(isorder==1) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
										    <TD ><%if(isquery.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
										    <TD><%=queryorder%></TD>
										    <TD><a href="#" onclick="javascript:ondeletefield('/formmode/search/CustomSearchOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete_wev8.gif"></a></TD>
										</TR>
										<%
											}
										%>
										
										<%
										sql = "SELECT colwidth,reportDspField.ID, htmlLabelInfo.labelName, reportDspField.showorder,reportDspField.isshow, reportDspField.isquery,reportDspField.queryorder,reportDspField.istitle,reportDspField.isorder FROM mode_CustomDspField reportDspField, workflow_billfield billField, mode_customsearch report, HtmlLabelInfo htmlLabelInfo WHERE report.ID = reportDspField.customid AND reportDspField.fieldID= billField.ID AND billField.fieldLabel = htmlLabelInfo.indexID AND report.ID = " + id + " AND htmlLabelInfo.languageID = " + user.getLanguage() + " ORDER BY reportDspField.showorder,reportDspField.id";  
											//out.println(sql);
											RecordSet.execute(sql);
											while(RecordSet.next()) 
											{
												theid = Util.null2String(RecordSet.getString("ID")) ;
												fieldname = Util.toScreen(RecordSet.getString("labelName"),user.getLanguage()) ;
												dsporder = Util.null2String(RecordSet.getString("showorder")) ;
												isquery = Util.null2String(RecordSet.getString("isquery")) ;
												isshow = Util.null2String(RecordSet.getString("isshow")) ;
												queryorder = Util.null2String(RecordSet.getString("queryorder")) ;
												istitle = Util.null2String(RecordSet.getString("istitle")) ;
												colwidth = Util.null2String(RecordSet.getString("colwidth")) ;
												sumcolwidth += Util.getDoubleValue(colwidth,0);
												if(!colwidth.equals("")){
													colwidth = String.format("%.2f", Util.getDoubleValue(colwidth,0)) + "%";
												}
												isorder =  Util.getIntValue(RecordSet.getInt("isorder")+"",0);
											
												if(i==0)
												{
													i=1;
										%>
										<TR class=DataLight> 
										<%
												}
												else
												{
													i=0;
										%>
										<TR class=DataDark> 
										<%
												}
										%>
											<TD><%=fieldname%></TD>
										    <TD ><%if(isshow.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
										    <TD ><%if(istitle.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
                                            <TD><%=dsporder%></TD>
                                            <TD><%=colwidth%></TD>
                                            <TD ><%if(isorder==1) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
											<TD ><%if(isquery.equals("1")) {%><img src="/images/BacoCheck_wev8.gif"><%} %></TD>
										    <TD><%=queryorder%></TD>
										    <TD><a href="#" onclick="javascript:ondeletefield('/formmode/search/CustomSearchOperation.jsp?operation=deletefield&theid=<%=theid%>&id=<%=id%>')" ><img border=0 src="/images/icon_delete_wev8.gif"></a></TD>
										</TR>
										<%
											}
										%>
										</TBODY>
									</TABLE>
								</TD>
							</TR>
						</TABLE>
					</TD>
					<TD></TD>
				</TR>
				<TR>
					<TD height="10" colspan="3"></TD>
				</TR>
			</TABLE>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<BR>

<script>
function onDelete(){
	if(isdel()) {
		enableAllmenu();
		document.frmMain.action="/formmode/search/CustomSearchOperation.jsp";
		document.frmMain.operation.value="customdelete";
		document.frmMain.submit();
	}
}
function ondeletefield(src){
    if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
        enableAllmenu();
        document.frmMain.action=src;
		document.frmMain.submit();
    }
}
function onAddField(){
    enableAllmenu();
    location.href="/formmode/search/CustomSearchFieldAdd.jsp?id=<%=id%>&isBill=<%=isBill %>&formID=<%= formID %>&dbordercount=<%=dbordercount%>" ;
}
function createmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

function createmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	window.open("/formmode/menu/CreateMenu.jsp?menuaddress="+escape(url));
}
function viewmenu1(){
	var url = "/formmode/search/CustomSearchBySimple.jsp?customid=<%=id%>&viewtype=3";
	prompt("<%=SystemEnv.getHtmlLabelName(28624,user.getLanguage())%>",url);//查看菜单地址
}

</script>

<script language="javascript">
function submitData()
{
	var checkfields = "";
    	checkfields = 'Customname,formID';
	if (check_form(frmMain,checkfields)){
        enableAllmenu();
		frmMain.submit();
    }
}
function doback(){
	enableAllmenu();
	location.href="/formmode/search/CustomSearch.jsp?modeid=<%=modeid%>";
}
function onShowModeSelect(inputName, spanName){
	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
	if (datas){
	    if(datas.id!=""){
		    $(inputName).val(datas.id);
			if ($(inputName).val()==datas.id){
		    	$(spanName).html(datas.name);
			}
	    }else{
		    $(inputName).val("");
			$(spanName).html("");
		}
	} 
}

function doCustomSearchBatchSet(){
    //enableAllmenu();
    if(confirm("<%=SystemEnv.getHtmlLabelName(31851,user.getLanguage())%>")){//在此页面设置查看或监控权限后，模块中设置的共享或监控权限将不能访问对应的菜单页面
    	location.href="/formmode/search/CustomSearchShare.jsp?id=<%=id%>";
    }
    
}

function doBatchSet(){
    enableAllmenu();
    location.href="/formmode/batchoperate/ModeBatchSet.jsp?id=<%=id%>";
}
jQuery(document).ready(function(){
	var sumcolwidth = "<%=sumcolwidth%>" * 1.0;
	jQuery("#sumcolwidthspan").html(" (" + sumcolwidth.toFixed(2) + "%)");
})
</script>
</BODY></HTML>
