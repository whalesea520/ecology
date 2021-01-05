
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetN" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<%@ include file="/common/swfupload/uploader.jsp" %>
<%
String CustomerID = request.getParameter("CustomerID");
String chanceid = request.getParameter("chanceid");
String frombase =  Util.null2String(request.getParameter("frombase"));
RecordSet.executeProc("CRM_SellChance_SelectByID",chanceid);
RecordSet.next();
String subject= RecordSet.getString("subject");
String creater= RecordSet.getString("creater");
String customerid = Util.null2String( RecordSet.getString("customerid"));
String comefromid =Util.null2String(RecordSet.getString("comefromid"));
String sellstatusid =Util.null2String(RecordSet.getString("sellstatusid"));
String endtatusid =Util.null2String(RecordSet.getString("endtatusid"));
String preselldate =Util.null2String(RecordSet.getString("predate"));
String preyield =RecordSet.getString("preyield");
String currencyid =Util.null2String(RecordSet.getString("currencyid"));
String probability =Util.null2String(RecordSet.getString("probability"));
String createdate =RecordSet.getString("createdate");
String createtime =RecordSet.getString("createtime");
String Agent =Util.null2String(RecordSet.getString("content"));
String sufactorid =Util.null2String(RecordSet.getString("sufactor"));
String defactorid =Util.null2String(RecordSet.getString("defactor"));
String selltype =Util.null2String(RecordSet.getString("selltype"));
  
    String comfromname = "";
    if(!comefromid.equals("")){
    String sql="select name from WorkPlan where id = "+comefromid;
    RecordSetN.executeSql(sql);
    RecordSetN.next();
    comfromname = RecordSetN.getString("name");
    }

int rownum=0;
String needcheck="subject";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectSellChance()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<FORM id=weaver name=weaver action="/CRM/sellchance/SellChanceOperation.jsp" method=post  >
<DIV style="display:none">
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<BUTTON class=btnSave accessKey=S type=button id=myfun1 onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doCancel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON type="button" class=Btn id=myfun2 accessKey=C name=button1 onclick="doCancel()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:doDel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON type="button" class=btnDelete id=Delete accessKey=D onclick="doDel()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
    
</DIV>
  <input type="hidden" name="method" value="edit">
  <input type="hidden" name="chanceid" value="<%=chanceid%>">
	<input type="hidden" name="frombase" value="<%=frombase%>">
<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="49%">
	<COL width=10>
	<COL width="49%">
	<TBODY>
<TR>
<TD vAlign=top>	
	<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="20%">
	<COL width="80%">
	<TBODY>
	<TR class=Title>
	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
	</TR>
	<TR class=Spacing style="height: 1px">
	<TD class=Line1 colSpan=2></TD></TR>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=50 size=30 name="subject"  value="<%=subject%>" onchange='checkinput("subject","subjectimage")'><SPAN id=subjectimage>
		<%if(subject.equals("")){%>
		<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
		<%}%></SPAN></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%if(!user.getLogintype().equals("2")) {%>	
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
		<TD class=Field>
		
		<INPUT  class=wuiBrowser _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=creater%>'><%=ResourceComInfo.getResourcename(creater)%></a>" _required="yes" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name="Creater" value="<%=creater%>"></TD>
		
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field>
		
		<input class="wuiBrowser" _displayText="<a href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=Agent%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(Agent),user.getLanguage())%></a>" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)" type=hidden name=Agent value="<%=Agent %>"></TD>
		
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%} else {%>
		<INPUT type=hidden name=Creater value="<%=creater%>">
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field>
		<span text class=InputStyle id=Agentspan><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=Agent%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(Agent),user.getLanguage())%></a></span> 
		<input type=hidden name=Agent value="<%=Agent%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
		<%}%>      
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>  </TD>
		<TD class=Field>
		<INPUT class=wuiBrowser _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=CustomerID%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden name="customer" value="<%=CustomerID%>"></TD>
		
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%>  </TD>
		<TD class=Field>
		<input class="wuiBrowser" type=hidden _displayText="<%=comfromname%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactLogBrowser.jsp?CustomerID=<%=CustomerID%>" id="Comefrom" name="Comefrom" value="<%=comefromid%>">
		
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></TD>
		<TD class=Field>
		<select id=sufactorid 
		name=sufactorid>
		<option value="0" ></option>
		<%  
		String theid_s="";
		String thename_s="";
		String sql_s="select * from CRM_Successfactor ";
		RecordSet.executeSql(sql_s);
		while(RecordSet.next()){
		theid_s = RecordSet.getString("id");
		thename_s = RecordSet.getString("fullname");
		if(!thename_s.equals("")){
		%>
		<option value=<%=theid_s%> <%if(theid_s.equals(sufactorid)){%> selected <%}%> ><%=thename_s%></option>
		<%}
		}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%></TD>
		<TD class=Field>
		<select id=defactorid 
		name=defactorid>
		<option value="0" ></option>
		<%  
		String theid_f="";
		String thename_f="";
		String sql_f="select * from CRM_Failfactor ";
		RecordSet.executeSql(sql_f);
		while(RecordSet.next()){
		theid_f = RecordSet.getString("id");
		thename_f = RecordSet.getString("fullname");
		if(!thename_f.equals("")){
		%>
		<option value=<%=theid_f%> <%if(theid_f.equals(defactorid)){%> selected <%}%> ><%=thename_f%></option>
		<%}
		}%>
		</TD>
		</TR>
	</TBODY>
	</TABLE>
    </TD>

    <TD></TD>
    <TD vAlign=top>

	<TABLE class=ViewForm>
	<COLGROUP>
	<COL width="20%">
	<COL width="80%">
	<TBODY>
	<TR class=Title>
	<TH colSpan=2>&nbsp</TH>
	</TR>
	<TR class=Spacing style="height: 1px">
	<TD class=Line1 colSpan=2></TD></TR>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></TD>
		<TD class=Field>
		<BUTTON type="button" class=Calendar onclick="onShowDate_1('preselldatespan','preselldate')"></BUTTON> <SPAN id=preselldatespan >
		<%if(preselldate.equals("")){%>
		<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
		<%}%><%=preselldate%></SPAN> <input type="hidden" name="preselldate" value="<%=preselldate%>">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=50 size=30 name="preyield" onchange='checkinput("preyield","preyieldimage")'   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")' value="<%=preyield%>">
		<SPAN id=preyieldimage >
		<%if(preyield.equals("")){%>
		<IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN>
		<%}%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=10 size=7 name="probability" onchange='checkinput("probability","probabilityimage")'  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("probability");checkvalue("<%=probability%>")' value="<%=probability%>">
		<SPAN id=probabilityimage >
		<%if(probability.equals("")){%>
		<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
		<%}%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%>  </TD>
		<TD class=Field>
		<select id=sellstatusid 
		  name=sellstatusid>
		<%  
		String theid="";
		String thename="";
		String sql="select * from CRM_SellStatus ";
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			theid = RecordSet.getString("id");
			thename = RecordSet.getString("fullname");
			if(!thename.equals("")){
			%>
		<option value=<%=theid%> <%if(theid.equals(sellstatusid)){%> selected <%}%> ><%=thename%></option>
		<%}
				}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		
		<!-- 增加销售类型开始 QC16057 -->
		<TR>
		<TD>销售类型</TD>
		<TD class=Field>
			<select class=InputStyle id="selltype" name="selltype" onchange="changeType(this.value)">
				<option value="1" <%if("1".equals(selltype)){%> selected="selected" <%}%>>新签</option>
				<option value="2" <%if("2".equals(selltype)){%> selected="selected" <%}%>>二次</option>
			</select>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!-- 增加销售类型结束 -->
		
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></TD>
		<TD class=Field>
		<select id=endtatusid  name=endtatusid>
		<option value=0 <%if(endtatusid.equals("0")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%> </option>
		<option value=1 <%if(endtatusid.equals("1")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> </option>
		<option value=2 <%if(endtatusid.equals("2")){%> selected <%}%> > <%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> </option>
		</select>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr> 
		
		<!--TR>
		<TD>创建日期</TD>
		<TD class=Field>
		<BUTTON class=Calendar onclick="onShowDate('CreateDatespan','createdate')"></BUTTON> <SPAN id=CreateDatespan >
		<%if(createdate.equals("")){%>
		<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
		<%}%> <%=createdate%> </SPAN> <input type="hidden" name="createdate" value="<%=createdate%>">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD>创建时间</TD>
		<TD class=Field><button class=Clock onclick="onShowTime('CreateTimespan','createtime')"></button><span id="CreateTimespan">
		<%if(createtime.equals("")){%>
		<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
		<%}%><%=createtime%></span><INPUT type=hidden name="createtime" value="<%=createtime%>"></TD>
		</TR-->

	</TBODY>
	</TABLE>
    </TD>


    </TR></TBODY></TABLE>
    <br>
    <!-- 跟进信息开始 -->
    <%
	    String docIds1 = "";
		String docIds2 = "";
		String docIds3 = "";
		String docIds4 = "";
		String mainId = "";
		String subId = "";
		String secId = "";
		String maxsize = "";
		boolean hasPath = false;
		int rownum1 = 0;
		int rownum2 = 0;
		int rownum3 = 0;
		int rownum4 = 0;
		rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (11,22,33,44,111,222,333) order by id "); 
		while(rs.next()){
			if("11".equals(rs.getString("infotype"))) docIds1 = Util.null2String(rs.getString("item"));
			if("22".equals(rs.getString("infotype"))) docIds2 = Util.null2String(rs.getString("item"));
			if("33".equals(rs.getString("infotype"))) docIds3 = Util.null2String(rs.getString("item"));
			if("44".equals(rs.getString("infotype"))) docIds4 = Util.null2String(rs.getString("item"));
			if("111".equals(rs.getString("infotype"))) mainId = Util.null2String(rs.getString("item"));
			if("222".equals(rs.getString("infotype"))) subId = Util.null2String(rs.getString("item"));
			if("333".equals(rs.getString("infotype"))) secId = Util.null2String(rs.getString("item"));
		}
		if(!mainId.equals("")&&!subId.equals("")&&!secId.equals("")){
			hasPath = true;
			rs.executeSql("select maxUploadFileSize from DocSecCategory where id=" + secId);
			rs.next();
			maxsize = Util.null2String(rs.getString(1));
		}
    %>
    <input class=inputstyle type="hidden" id="rownum1" name="rownum1" />
	<input class=inputstyle type="hidden" id="rownum2" name="rownum2" />
	<input class=inputstyle type="hidden" id="rownum3" name="rownum3" />
	<input class=inputstyle type="hidden" id="rownum4" name="rownum4" />
    <%if(selltype.equals("2")){ %>
    <div id="info" style="width:100%;display: none;">
    <TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		</COLGROUP>
		<TBODY>
		<TR class=Title>
		<TH colSpan=2 style="padding-left:5px;">跟进信息</TH>
		</TR>
		<TR class=Spacing style="height: 1px">
		<TD class=Line1 colSpan=2></TD></TR>
		</TBODY>
	</TABLE>
    <table style="width:100%;margin-top:5px;" cellpadding="0" cellspacing="0" border="0">
							<colgroup>
								<col width="49%">
								<col width="2%">
								<col width="49%">
							</colgroup>
							<tr>
								<td valign="top">
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">
										<!-- 需求匹配开始 -->
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">需求匹配</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(1);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(1);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds1) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable1" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=1 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node1' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item1_<%=rownum1 %>' name='item1_<%=rownum1 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='desc1_<%=rownum1 %>' name='desc1_<%=rownum1 %>' value="" style="width:98%"/>
															</td>
														</TR>
														<%
															rownum1++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</table>
										<!-- 需求匹配结束 -->
										<br>
										<!-- 竞争优势分析开始 -->
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">	
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">竞争优势分析</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(2);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(2);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds2) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable2" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=2 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node2' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item2_<%=rownum2 %>' name='item2_<%=rownum2 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='desc2_<%=rownum2 %>' name='desc2_<%=rownum2 %>' value="" style="width:98%"/>
															</td>
														</TR>
														<%
															rownum2++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 竞争优势分析结束 -->
									</TABLE>
								</td>
								<td></td>
								<td valign="top">
									<!-- 信息化情况开始 -->
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">	
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">信息化情况</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(3);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(3);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds3) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable3" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=3 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node3' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item3_<%=rownum3 %>' name='item3_<%=rownum3 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='desc3_<%=rownum3 %>' name='desc3_<%=rownum3 %>' value="" style="width:98%"/>
															</td>
														</TR>
														<%
															rownum3++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</TABLE>
									<!-- 需求匹配结束 -->
									<br>	
									<!-- 专业度匹配开始 -->
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">	
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">专业度匹配</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(4);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(4);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds4) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable4" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>文件</td>
														</TR>
														<%
															rs.executeSql("select item from CRM_SellChance_Set where infotype=4 order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node4' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item4_<%=rownum4 %>' name='item4_<%=rownum4 %>' value="<%=Util.toScreen(rs.getString("item"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<div style="float: left;width: 100%">
																	<input type="hidden" id="relatedacc_<%=rownum4%>" name="relatedacc_<%=rownum4%>" value="">
																	<input type="hidden" id="delrelatedacc_<%=rownum4%>" name="delrelatedacc_<%=rownum4%>" value="">	
																<%if(hasPath){ %>
																	<div id="uploadDiv_<%=rownum4%>" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
																	<script language=javascript>bindUploaderDiv($("#uploadDiv_<%=rownum4%>"),"newrelatedacc_<%=rownum4%>");</script>
																<%}else{ %>
																	<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
																<%} %>
																</div>
															</td>
														</TR>
														<%
															rownum4++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 专业度匹配结束 -->
									</TABLE>
								</td>
							</tr>
						</table>
    </div>
    <%}else{ %>
    <div id="info" style="width:100%;">
    <TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		</COLGROUP>
		<TBODY>
		<TR class=Title>
		<TH colSpan=2 style="padding-left:5px;">跟进信息</TH>
		</TR>
		<TR class=Spacing style="height: 1px">
		<TD class=Line1 colSpan=2></TD></TR>
		</TBODY>
	</TABLE>
    <table style="width:100%;margin-top:5px;" cellpadding="0" cellspacing="0" border="0">
							<colgroup>
								<col width="49%">
								<col width="2%">
								<col width="49%">
							</colgroup>
							<tr>
								<td valign="top">
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">
										<!-- 需求匹配开始 -->
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">需求匹配</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(1);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(1);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds1) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable1" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_info where infotype=1 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node1' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item1_<%=rownum1 %>' name='item1_<%=rownum1 %>' value="<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='desc1_<%=rownum1 %>' name='desc1_<%=rownum1 %>' value="<%=Util.toScreen(rs.getString("description"),user.getLanguage()) %>" style="width:98%"/>
															</td>
														</TR>
														<%
															rownum1++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</table>
										<!-- 需求匹配结束 -->
										<br>
										<!-- 竞争优势分析开始 -->
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">	
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">竞争优势分析</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(2);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(2);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds2) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable2" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_info where infotype=2 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node2' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item2_<%=rownum2 %>' name='item2_<%=rownum2 %>' value="<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='desc2_<%=rownum2 %>' name='desc2_<%=rownum2 %>' value="<%=Util.toScreen(rs.getString("description"),user.getLanguage()) %>" style="width:98%"/>
															</td>
														</TR>
														<%
															rownum2++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 竞争优势分析结束 -->
									</TABLE>
								</td>
								<td></td>
								<td valign="top">
									<!-- 信息化情况开始 -->
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">	
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">信息化情况</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(3);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(3);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds3) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable3" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_info where infotype=3 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node3' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item3_<%=rownum3 %>' name='item3_<%=rownum3 %>' value="<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<input type="text" class="InputStyle" id='desc3_<%=rownum3 %>' name='desc3_<%=rownum3 %>' value="<%=Util.toScreen(rs.getString("description"),user.getLanguage()) %>" style="width:98%"/>
															</td>
														</TR>
														<%
															rownum3++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
									</TABLE>
									<!-- 需求匹配结束 -->
									<br>	
									<!-- 专业度匹配开始 -->
									<TABLE class=ViewForm style="border: 1px #D4E9E9 solid;">	
										<TR class=Title>
											<TH style="padding-left: 5px;">
												<span style="float: left">专业度匹配</span>
												<span style="float: right">
													<BUTTON type="button" class=btnNew accessKey=A onClick="addRow(4);">
														<U>A</U>-<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>
													</BUTTON>
													<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:if(isdel()){deleteRow(4);};">
														<U>D</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>
													</BUTTON>
												</span>
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds4) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE id="oTable4" cols=3 class=ListStyle cellspacing=1>
													<colgroup>
														<col width="5%">
														<col width="30%">
														<col width="65%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td></td>
															<td>标题</td>
															<td>文件</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_info where infotype=4 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<input type='checkbox' name='check_node4' value='0'>
															</td>
															<td>
																<input type="text" class="InputStyle" id='item4_<%=rownum4 %>' name='item4_<%=rownum4 %>' value="<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>" style="width:98%" maxlength='100'/>
															</td>
															<td>
																<div style="float: left;width: 100%">
																	<%
																		String fileIds = Util.toScreen(rs.getString("description"),user.getLanguage());
																		if(!"".equals(fileIds)){
																			int linknum = -1;
																			List fileIdList = Util.TokenizerString(fileIds,","); 
																			for(int i=0;i<fileIdList.size();i++){
																				linknum++;
																	%>
																	<%=cmutil.getDocName((String)fileIdList.get(i)) %>&nbsp;
																	<BUTTON t=1 class=btn accessKey=1  onclick='onDeleteAcc("<%=rownum4 %>","span_id_<%=rownum4%>_<%=linknum%>","<%=fileIdList.get(i)%>")'><U><%=linknum%></U>-删除
																		<span id="span_id_<%=rownum4%>_<%=linknum%>" name="span_id_<%=rownum4%>_<%=linknum%>" style="display: none">
																			<B><FONT COLOR="#FF0033">√</FONT></B>
																		</span>
																	</BUTTON>
																	<br>
																	<%
																			}
																		}
																	%>
																<%if(hasPath){ %>
																	<div id="uploadDiv_<%=rownum4%>" mainId="<%=mainId%>" subId="<%=subId%>" secId="<%=secId%>" maxsize="<%=maxsize%>"></div>
																	<script language=javascript>bindUploaderDiv($("#uploadDiv_<%=rownum4%>"),"newrelatedacc_<%=rownum4%>");</script>
																<%}else{ %>
																	<font color="red"><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>
																<%} %>
																	<input type="hidden" id="relatedacc_<%=rownum4%>" name="relatedacc_<%=rownum4%>" value="<%=fileIds %>">
																	<input type="hidden" id="delrelatedacc_<%=rownum4%>" name="delrelatedacc_<%=rownum4%>" value="">
																</div>
															</td>
														</TR>
														<%
															rownum4++;
														} 
														%>
													</TBODY>
												</TABLE>
											</TD>
										</TR>
										<!-- 专业度匹配结束 -->
									</TABLE>
								</td>
							</tr>
						</table>
    </div>
    
    <%} %>
    <!-- 跟进信息结束 -->

	<br>

<%

int rowindex = 0;
rs.executeProc("CRM_Product_SelectByID",chanceid);

%>

   <TABLE class=ViewForm cellspacing=1  cols=7 id="oTable">
     <input type="hidden" name="rownum" value="0">  
      <TR class=Title>
       <TH colspan=2><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></TH>
       <Td align=right colSpan=5>
	  <BUTTON class=btnNew type="button" accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15128,user.getLanguage())%></BUTTON>
	  <BUTTON class=btnDelete type="button" accessKey=D onClick="javascript:if(isdel()){deleteRow1()};"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
      </Td>       
      </TR>
        <TR class=Spacing style="height: 1px">
       <TD class=Line1 colSpan=7></TD></TR>
    	<tr class=header>
           <td class=Field></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(15129,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(649,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></td>
           <td class=Field><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></td>
    	   <td class=Field><%=SystemEnv.getHtmlLabelName(2019,user.getLanguage())%></td>
    	</tr>
<%while(rs.next()){
    String productid = rs.getString("productid");
    String assetunitid = rs.getString("assetunitid");
    String salesprice = rs.getString("salesprice");
    String salesnum = rs.getString("salesnum");
    String totelprice = rs.getString("totelprice"); 

    %>

        <tr>

            <TD class=Field width=10> 
              <input type='checkbox' name='check_node' value='0'>
            </td>
            <TD class=Field width=100> 
             <BUTTON class=Browser  type="button"  onclick='onGetProduct(productname_<%=rowindex%>span , productname_<%=rowindex%>,assetunitid_<%=rowindex%>span,assetunitid_<%=rowindex%>,currencyid_<%=rowindex%>Span,currencyid_<%=rowindex%>,salesprice_<%=rowindex%>,totelprice_<%=rowindex%>)' > </BUTTON>
             <span id=productname_<%=rowindex%>span> <A href="/lgc/asset/LgcAsset.jsp?paraid=<%=productid%>" >       <%=Util.toScreen(AssetComInfo.getAssetName(productid),user.getLanguage())%></a> </span> 
             <input type=hidden name=productname_<%=rowindex%>  id=productname_<%=rowindex%> value="<%=productid%>">
            </TD>
            <TD class=Field > 
             <span id=assetunitid_<%=rowindex%>span><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></span>         			
             <input type=hidden name=assetunitid_<%=rowindex%>  id=assetunitid_<%=rowindex%> value="<%=assetunitid%>" >
            </TD>

            <TD class=Field >
           
            <input type=hidden class="wuiBrowser" _displayText="<%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%>" _url="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp" name=currencyid_<%=rowindex%> id=currencyid_<%=rowindex%> value="<%=currencyid%>" >
            
            </TD class=Field >

            <TD class=Field >
                <input type=text class='InputStyle' id=salesprice_<%=rowindex%>  name=salesprice_<%=rowindex%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("<%=rowindex%>")' size=10 value="<%=salesprice%>">
            </TD> 
                
            <TD class=Field >
                <input type=text class='InputStyle' name=number_<%=rowindex%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("<%=rowindex%>")' size=10  value="<%=salesnum%>">
            </TD>
            <TD class=Field >
                <input type=text class='InputStyle' id=totelprice_<%=rowindex%>  name=totelprice_<%=rowindex%> onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this),sumpreyield()' size=25  value="<%=totelprice%>">
            </TD>
        </tr>
<%
 rowindex++;           
 }%>


       </table>  	

</FORM>



		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<script language=vbs>

sub onShowCreaterID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Createrspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	weaver.Creater.value=id(0)
	else 
	Createrspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	weaver.Creater.value=""
	end if
	end if
end sub
sub onShowCustomerID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	customerspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.customer.value=id(0)
	else 
	customerspan.innerHtml = ""
	weaver.customer.value=""
	end if
	end if
end sub

sub onGetProduct(spanname1,inputename1,spanname2,inputename2,spanname3,inputename3,inputename4,inputename5)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname1.innerHtml = "<A href='/lgc/asset/LgcAsset.jsp?paraid="&id(0)&"'>"&id(1)&"</A>"
	inputename1.value=id(0)
	spanname2.innerHtml = id(3)
	inputename2.value = id(2)
	spanname3.innerHtml = id(5)
	inputename3.value = id(4)
	inputename4.value = id(6)
	inputename5.value = id(6)
    sumpreyield()
	else 
	spanname1.innerHtml = ""
	inputename1.value = ""
	spanname2.innerHtml = ""
	inputename2.value = ""
	spanname3.innerHtml = ""
	inputename3.value = ""
	inputename4.value = ""
	inputename5.value = ""
	end if
	end if
end sub

sub onShowCurrencyID(spanname,inputename)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp")
	if NOT isempty(id) then
		if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputename.value=id(0)
		else
		spanname.innerHtml = ""
		inputename.value= ""
		end if
	end if
end sub

sub onShowComefrom(spanname,inputename,crmid)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactLogBrowser.jsp?CustomerID="&crmid)
	if NOT isempty(id) then
		if id(0)<> "" then
		spanname.innerHtml = id(1)
		inputename.value=id(0)
		else
		spanname.innerHtml = ""
		inputename.value= ""
		end if
	end if
end sub

sub onShowAgent()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4)")
	
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	Agentspan.innerHtml = "<A href='/CRM/data/ViewCustomer.jsp?CustomerID="&id(0)&"'>"&id(1)&"</A>"
	weaver.Agent.value=id(0)
	else 
	Agentspan.innerHtml = ""
	weaver.Agent.value=""
	end if
	end if
end sub
</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js">   
</script>  

<script language=javascript>
function onGetProduct(spanname1,inputename1,spanname2,inputename2,spanname3,inputename3,inputename4,inputename5){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;
	opts.top=iTop;
	opts.left=iLeft;
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/lgc/search/LgcProductBrowser.jsp",
			"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	
	if (data){
		if (data.id!=""){
			spanname1.innerHTML = "<A href='/lgc/asset/LgcAsset.jsp?paraid="+wuiUtil.getJsonValueByIndex(data,0)+"'>"+wuiUtil.getJsonValueByIndex(data,1)+"</A>"
			inputename1.value=wuiUtil.getJsonValueByIndex(data,0)
			spanname2.innerHTML = wuiUtil.getJsonValueByIndex(data,3)
			inputename2.value = wuiUtil.getJsonValueByIndex(data,2)
			spanname3.innerHTML = wuiUtil.getJsonValueByIndex(data,5)
			inputename3.value = wuiUtil.getJsonValueByIndex(data,4)
			inputename4.value = wuiUtil.getJsonValueByIndex(data,6)
			inputename5.value = wuiUtil.getJsonValueByIndex(data,6)
		}else{
			spanname1.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
			inputename1.value = ""
			spanname2.innerHTML = ""
			inputename2.value = ""
			spanname3.innerHTML = ""
			inputename3.value = ""
			inputename4.value = "0"
			inputename5.value = "0"
		}
	}
}
rowindex = "<%=rowindex%>";
var rowColor="" ;
function addRow()
{
	ncol = jQuery(oTable).attr("cols");
	oRow = oTable.insertRow(-1);
	rowColor = getRowBg();
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
                oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node' value='0' >"; 
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;			
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<button class=Browser type='button' onClick=onGetProduct(productname_"+rowindex+"span,productname_"+rowindex+",assetunitid_"+rowindex+"span,assetunitid_"+rowindex+",currencyid_"+rowindex+"Span,currencyid_"+rowindex+",salesprice_"+rowindex+",totelprice_"+rowindex+")></button> " + 
        					"<span id=productname_"+rowindex+"span></span> "+
        					"<input type='hidden' name='productname_"+rowindex+"'  id=productname_"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span id=assetunitid_"+rowindex+"span></span> "+
        					"<input type='hidden' name='assetunitid_"+rowindex+"'  id=assetunitid_"+rowindex+">";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;	
			case 3:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class='wuiBrowser' type='hidden' _url='/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp' name='currencyid_"+rowindex+"' id=currencyid_"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				jQuery(oDiv).find(".wuiBrowser").modalDialog();
				break;                
			case 4: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='salesprice_"+rowindex+"'  name='salesprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' name='number_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10 value='1'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;               
            case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text class='InputStyle' id='totelprice_"+rowindex+"'  name='totelprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this),sumpreyield()' size=25>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
		}
	}
	rowindex = rowindex*1 +1;

}

function deleteRow1()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+2);	
			}
			rowsum1 -=1;
		}	
	}	
       sumpreyield();
}


function changenumber(rowval){
	
	
	count_total = 0 ;
    count_number = 0;
    count_preyield =0;

    count_total = eval(toFloat($GetEle("salesprice_"+rowval).value,0));
	count_number = eval(toFloat($GetEle("number_"+rowval).value,0));
    
    count_total = toFloat(count_total) * toFloat(count_number);

    $GetEle("totelprice_"+rowval).value = toPrecision(count_total,4) ; 

    sumpreyield();
	//alert(count_preyield);
}


function checkvalue(prevalue){
    check_value=eval(toFloat($GetEle("probability").value,0));
    if(check_value>1 ){
        alert("<%=SystemEnv.getHtmlLabelName(15241,user.getLanguage())%>");
        $GetEle("probability").value=prevalue;
    }
}


function sumpreyield(){
    
    count_sum=0;
    for(i=0;i<rowindex;i++){
        if($GetEle("totelprice_"+i) != null){
            count_sum += eval(toFloat($GetEle("totelprice_"+i).value,0));
        }
        
    }
   document.weaver.preyield.value = toPrecision(count_sum,2);
}
function toPrecision(aNumber,precision){
	var temp1 = Math.pow(10,precision);
	var temp2 = new Number(aNumber);

	return isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1 ;
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}

function doDel(){
	if(isdel()){onDelete();}
}
function doCancel(){
	location='/CRM/sellchance/ViewSellChance.jsp?id=<%=chanceid%>&CustomerID=<%=CustomerID%>&frombase=<%=frombase%>';
}
function doSave(obj){
	window.onbeforeunload=null;
	if(check_form(document.weaver,'<%=needcheck%>,Creater,preselldate,')){
		var selltype = jQuery("#selltype").val();
		if(selltype==1 && jQuery("#endtatusid").val()==0){
			jQuery.post(
					"/CRM/sellchance/CheckType.jsp",
					{'customerId':'<%=CustomerID%>','sellchanceId':'<%=chanceid%>'}, 
					function(data){
						data=jQuery.trim(data);
						if(data=="false"){
							alert("此客户已存在进行中的新签销售机会！");
							return;
						}else{
							document.weaver.rownum.value = rowindex;
							obj.disabled=true;
							//document.weaver.submit();
							doSaveAfterAccUpload();
						}
					}
			);
		}else{
			document.weaver.rownum.value = rowindex;
			obj.disabled=true;
			document.weaver.submit();
		}
	}
}
function onDelete(){
	window.onbeforeunload=null;
	window.location="/CRM/sellchance/SellChanceOperation.jsp?chanceid=<%=chanceid%>&method=del&customer=<%=CustomerID%>&frombase=<%=frombase%>";
}
function protectSellChance(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19005,user.getLanguage())%>";
}
jQuery("#rownum1").val(<%=rownum1%>);
jQuery("#rownum2").val(<%=rownum2%>);
jQuery("#rownum3").val(<%=rownum3%>);
jQuery("#rownum4").val(<%=rownum4%>);
function addRow(index)
{
	rowindex = jQuery("#rownum"+index).val();
	var table = $G("oTable"+index);
	var ncol = jQuery("#oTable"+index).attr("cols");
	var oRow = table.insertRow(-1);
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell(-1);
		oCell.style.height=24;
		switch(j) {
			case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node"+index+"' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 1:
            	var oDiv = document.createElement("div");
				var sHtml = "<input type='text' class='InputStyle' maxlength='100' id='item"+index+"_"+rowindex+"' name='item"+index+"_"+rowindex+"' style='width:98%'/>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
            case 2:
            	var oDiv = document.createElement("div");
            	var sHtml = "";
				if(index==4){
					sHtml = "<input type='hidden' id='relatedacc_"+rowindex+"' name='relatedacc_"+rowindex+"' value='' />"
						+ "<input type='hidden' id='delrelatedacc_"+rowindex+"' name='delrelatedacc_"+rowindex+"' value='' />";
					<%if(hasPath){ %>
					sHtml += "<div id='uploadDiv_"+rowindex+"' mainId='<%=mainId%>' subId='<%=subId%>' secId='<%=secId%>' maxsize='<%=maxsize%>'></div>";
					<%}else{ %>
					sHtml += "<font color='red'><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())+SystemEnv.getHtmlLabelName(92,user.getLanguage())+SystemEnv.getHtmlLabelName(15808,user.getLanguage())%>!</font>";
					<%} %>
    			}else{
        			sHtml = "<input type='text' class='InputStyle' id='desc"+index+"_"+rowindex+"' name='desc"+index+"_"+rowindex+"' style='width:98%'/>";
    			}
    			oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	<%if(hasPath){ %>
	if(index==4){bindUploaderDiv($("#uploadDiv_"+rowindex),"newrelatedacc_"+rowindex);}
	<%} %>
	rowindex = rowindex*1 +1;
	jQuery("#rownum"+index).val(rowindex);
}
function deleteRow(index)
{
	var table = $G("oTable"+index);
	var len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 1;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name==('check_node'+index))
			rowsum1 += 1;
	}

	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name==('check_node'+index)){
			if(document.forms[0].elements[i].checked==true) {
				table.deleteRow(rowsum1-1);
			}
			rowsum1 -=1;
		}
	}
}
function changeType(val){
	if(val==1){
		jQuery("#info").show();
	}else{
		jQuery("#info").hide();
	}
}
var index = -1;
function doSaveAfterAccUpload() {
	index++;
	if(index == (jQuery("#rownum4").val()+1)){
		document.weaver.submit();
	}else{
		try{
			var oUploader=window[document.getElementById("uploadDiv_"+index).oUploaderIndex];
			if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
				doSaveAfterAccUpload();  //提交
			else 
				oUploader.startUpload();
		}catch(e) {
			doSaveAfterAccUpload();
	  	}
	}
	
}
//附件删除
function onDeleteAcc(rows,delspan,delid){
	    var delrelatedacc=jQuery("#delrelatedacc_"+rows).val();
        var relatedacc=jQuery("#relatedacc_"+rows).val();
	    relatedacc=","+relatedacc;
	    delrelatedacc=","+delrelatedacc;
	    if(jQuery("#"+delspan).is(":hidden")){
			delrelatedacc=delrelatedacc+delid+",";
			var index=relatedacc.indexOf(","+delid+",");
			relatedacc=relatedacc.substr(0,index+1)+relatedacc.substr(index+delid.length+2);
			jQuery("#"+delspan).show();    
		}else{
			var index=delrelatedacc.indexOf(","+delid+",");
			delrelatedacc=delrelatedacc.substr(0,index+1)+delrelatedacc.substr(index+delid.length+2);
			         
			relatedacc=relatedacc+delid+",";
			         
			jQuery("#"+delspan).hide(); 
		}
		jQuery("#relatedacc_"+rows).val(relatedacc.substr(1,relatedacc.length));
		jQuery("#delrelatedacc_"+rows).val(delrelatedacc.substr(1,delrelatedacc.length));
}
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
</BODY>
</HTML>
