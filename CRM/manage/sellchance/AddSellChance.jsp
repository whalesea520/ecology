
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/common/swfupload/uploader.jsp" %>
<%
String CustomerID = request.getParameter("CustomerID");
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String frombase =  Util.null2String(request.getParameter("frombase"));
if(!user.getLogintype().equals("2")){
	response.sendRedirect("/CRM/manage/sellchance/SellChanceAdd.jsp?CustomerID="+CustomerID);
	return;
}
int rownum=0;
String needcheck="subject";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY onbeforeunload="protectSellChance()">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(frombase.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:window.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location='/CRM/sellchance/ListSellChance.jsp?isfromtab="+isfromtab+"&CustomerID="+CustomerID+"',_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>


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
<FORM id=weaver name=weaver action="/CRM/sellchance/SellChanceOperation.jsp" method=post  >
	
<TABLE class=ViewForm>
		<COLGROUP>
		<COL width="49%">
		<COL width=10>
		<COL width="49%">
		</COLGROUP>
		<TBODY>
		<TR>

		<TD vAlign=top>

		<TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		</COLGROUP>
		<TBODY>
	
		<%if(!user.getLogintype().equals("2")) {%>	
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
		<TD class=Field>
	
		<INPUT  class=wuiBrowser _displayText="<a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>'><%=user.getUsername()%></a>" _required="yes" _displayTemplate="<A href='/hrm/resource/HrmResource.jsp?id=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" type=hidden name="Creater" value="<%=user.getUID()%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field>
		 
		<input class="wuiBrowser" _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp?sqlwhere=where t1.type in (3,4,11,12,13,14,15,16,17,18,20,21,25)" type=hidden name=Agent></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%} else {%>
		<INPUT type=hidden name=Creater value="<%=user.getManagerid()%>">
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field>
		<span text class=InputStyle id=Agentspan><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=user.getUID()%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+user.getUID()),user.getLanguage())%></a></span> 
		<input type=hidden name=Agent value="<%=user.getUID()%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>   

		<%}%>      
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>  </TD>

		<TD class=Field>
		<INPUT class=wuiBrowser _displayTemplate="<A href='/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}'>#b{name}</A>" _displayText="<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=CustomerID%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(CustomerID),user.getLanguage())%></a>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" type=hidden id="customer" name="customer" value="<%=CustomerID%>"></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%>  </TD>
		<TD class=Field>
		<input class="wuiBrowser" type=hidden _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactLogBrowser.jsp?CustomerID=<%=CustomerID%>" id="Comefrom" name="Comefrom" value="">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></TD>
		<TD class=Field>
		<select class=InputStyle id=sufactorid name=sufactorid style="width:75%">
		<option value="0"  > </option>
		<%  
		String theid_s="";
		String thename_s="";
		String sql_1="select * from CRM_Successfactor ";
		RecordSet.executeSql(sql_1);
		while(RecordSet.next()){
		theid_s = RecordSet.getString("id");
		thename_s = RecordSet.getString("fullname");
		if(!thename_s.equals("")){
		%>
		<option value=<%=theid_s%>  ><%=thename_s%></option>
		<%}
		}%>
		</select>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%></TD>
		<TD class=Field>
		<select class=InputStyle id=defactorid name=defactorid style="width:75%">
		<option value="0"  > </option>
		<%  
		String theid_f="";
		String thename_f="";
		String sql_2="select * from CRM_Failfactor ";
		RecordSet.executeSql(sql_2);
		while(RecordSet.next()){
		theid_f = RecordSet.getString("id");
		thename_f = RecordSet.getString("fullname");
		if(!thename_f.equals("")){
		%>
		<option value=<%=theid_f%>  ><%=thename_f%></option>
		<%}
		}%>
		</select>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!-- TR>
		<TD>归档状态</TD>
		<TD class=Field>
		<select text class=InputStyle id=endtatusid  name=endtatusid >
		<option value=1 selected > 成 功 </option>
		<option value=0  > 失 败 </option>
		</TD >
		</TR -->    
		</TBODY>
    </TABLE>
    </TD>

    <TD></TD>

    <TD vAlign=top>

	<TABLE class=ViewForm>
		<COLGROUP>
		<COL width="30%">
		<COL width="70%">
		</COLGROUP>
		<TBODY>
		<TR class=Title>
		<TH colSpan=2>&nbsp</TH>
		</TR>
		<TR class=Spacing style="height: 1px">
		<TD class=Line1 colSpan=2></TD></TR>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2247,user.getLanguage())%></TD>
		<TD class=Field>
		<BUTTON type="button" class=Calendar onclick="onShowDate_1(preselldatespan,preselldate)"></BUTTON> <SPAN id=preselldatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> <input type="hidden" name="preselldate">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=50 size=30 id="preyield" name="preyield"   onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("preyield")'>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%></TD>
		<TD class=Field><INPUT text class=InputStyle maxLength=10 size=7 name="probability" onchange='checkinput("probability","probabilityimage")'  onKeyPress="ItemNum_KeyPress()" onBlur='checknumber("probability");checkvalue()'>
		<SPAN id=probabilityimage ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%>   </TD>
		<TD class=Field>
		<select class=InputStyle id=sellstatusid name=sellstatusid style="width:80px">
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
		<option value=<%=theid%>  ><%=thename%></option>
		<%}
			}%>
		</select>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		
		<!-- 增加销售类型开始 QC16057 -->
		<TR>
		<TD>销售类型</TD>
		<TD class=Field>
			<select class=InputStyle id="selltype" name="selltype" onchange="changeType(this.value)">
				<option value="1">新签</option>
				<option value="2">二次</option>
			</select>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!-- 增加销售类型结束 -->
		
		<!--TR>
		<TD>创建日期</TD>
		<TD class=Field>
		<BUTTON class=Calendar onclick="onShowDate('CreateDatespan','createdate')"></BUTTON> <SPAN id=CreateDatespan ><IMG src='/images/BacoError_wev8.gif' align=absMiddle></SPAN> <input type="hidden" name="createdate">
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD>创建时间</TD>
		<TD class=Field><button class=Clock onclick="onShowTime('CreateTimespan','createtime')"></button><span id="CreateTimespan"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span><INPUT type=hidden name="createtime"></TD>
		</TR -->
		</TBODY>
	</TABLE>
    </TD>


    </TR></TBODY></TABLE>
    <br>
    <!-- 跟进信息开始 -->
    <div id="info" style="width:100%">
    <input class=inputstyle type="hidden" id="rownum1" name="rownum1" />
	<input class=inputstyle type="hidden" id="rownum2" name="rownum2" />
	<input class=inputstyle type="hidden" id="rownum3" name="rownum3" />
	<input class=inputstyle type="hidden" id="rownum4" name="rownum4" />
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
															int rownum1 = 0;
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
															int rownum2 = 0;
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
															int rownum3 = 0;
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
															int rownum4 = 0;
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
    <!-- 跟进信息结束 -->

	<br>
	<TABLE class=ViewForm cellpadding=1  cols=7 id="oTable">
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
	</TR><tr style="height: 1px"><td class=Line colspan=7></td></tr>
	</table>  	

	<!--TABLE class=ViewForm>
	<COLGROUP>
	<COL width="50%">
	<TR>
	<TD><B>描述</B></TD>
	</TR>
	<TR class=Spacing>
	<TD class=Line1 colSpan=1></TD></TR>
	<TR>
	<TD class=Field><TEXTAREA text class=InputStyle name="content" ROWS=4 STYLE="width:100%"></TEXTAREA></TD>
	</TR>
	</TABLE -->
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
rowindex = "<%=rownum%>";
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
				var sHtml =  "<button type='button' class=Browser onClick=onGetProduct(productname_"+rowindex+"span,productname_"+rowindex+",assetunitid_"+rowindex+"span,assetunitid_"+rowindex+",currencyid_"+rowindex+"Span,currencyid_"+rowindex+",salesprice_"+rowindex+",totelprice_"+rowindex+")></button> " + 
        					"<span text class=InputStyle id=productname_"+rowindex+"span></span> "+
        					"<input type='hidden' name='productname_"+rowindex+"'  id=productname_"+rowindex+">";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<span text class=InputStyle id=assetunitid_"+rowindex+"span></span> "+
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
				var sHtml = "<input type=text id='salesprice_"+rowindex+"'  name='salesprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;
			case 5: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  name='number_"+rowindex+"' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this);changenumber("+rowindex+")' size=10 value='1'>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;               
            case 6: 
				var oDiv = document.createElement("div"); 
				var sHtml = "<input type=text  id='totelprice_"+rowindex+"'  name='totelprice_"+rowindex+"' onKeyPress='ItemNum_KeyPress(this.id)' onBlur='checknumber1(this),sumpreyield()' size=25>";
				oDiv.innerHTML = sHtml;   
				oCell.appendChild(oDiv);  
				break;			
		}
	}
	rowindex = rowindex*1 +1;
 
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

function doSave(obj){
	window.onbeforeunload=null;
	if(check_form(document.weaver,'<%=needcheck%>,Creater,preselldate,probability')){
		var selltype = jQuery("#selltype").val();
		if(selltype==1){
			jQuery.post(
					"/CRM/sellchance/CheckType.jsp",
					{'customerId':jQuery("#customer").val()}, 
					function(data){
						data=jQuery.trim(data);
						if(data=="false"){
							alert("此客户已存在进行中的新签销售机会！");
							return;
						}else{
							obj.disabled=true;
							document.weaver.rownum.value = rowindex;
							//document.weaver.submit();
							doSaveAfterAccUpload();
						}
					}
			);
		}else{
			obj.disabled=true;
			document.weaver.rownum.value = rowindex;
			document.weaver.submit();
		}
	}
}

function protectSellChance(){
	if(!checkDataChange())//added by cyril on 2008-06-13 for TD:8828
		event.returnValue="<%=SystemEnv.getHtmlLabelName(19005,user.getLanguage())%>";
}

function toFloat(str , def) {
	if(isNaN(parseFloat(str))) return def ;
	else return str ;
}
function toInt(str , def) {
	if(isNaN(parseInt(str))) return def ;
	else return str ;
}


function checkvalue(){
    check_value=eval(toFloat($GetEle("probability").value,0));
    if(check_value>1){
        alert("<%=SystemEnv.getHtmlLabelName(15241,user.getLanguage())%>");
        $GetEle("probability").value=0;
    }
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
	<%}%>
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
</script>

</BODY>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<!-- added by cyril on 2008-06-13 for TD:8828 -->
<script language=javascript src="/js/checkData_wev8.js"></script>
<!-- end by cyril on 2008-06-13 for TD:8828 -->
</HTML>
