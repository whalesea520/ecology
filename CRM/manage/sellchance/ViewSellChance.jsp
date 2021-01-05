
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetN" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="AssetComInfo" class="weaver.lgc.asset.AssetComInfo" scope="page"/>
<jsp:useBean id="CurrencyComInfo" class="weaver.fna.maintenance.CurrencyComInfo" scope="page"/>
<jsp:useBean id="AssetUnitComInfo" class="weaver.lgc.maintenance.AssetUnitComInfo" scope="page"/>
<jsp:useBean id="RecordSetS" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetEX" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.cs.util.CommonTransUtil" scope="page" />
<%
    String chanceid = Util.null2String(request.getParameter("id"));
	String frombase =  Util.null2String(request.getParameter("frombase"));
	if(!user.getLogintype().equals("2")){
		response.sendRedirect("/CRM/manage/sellchance/SellChanceView.jsp?id="+chanceid);
		return;
	}
    String CustomerID = "";
		RecordSet2.executeSql("select customerid from CRM_SellChance where id="+chanceid);
		if(RecordSet2.next()){
			CustomerID = RecordSet2.getString("customerid");
		}
    
/*check right begin*/
RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0)
{
	response.sendRedirect("/base/error/DBError.jsp?type=FindDataVCL");
	return;
}
RecordSetC.first();
String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;

boolean canview=false;
boolean canedit=false;
boolean canviewlog=false;
boolean canmailmerge=false;
boolean canapprove=false;

//String ViewSql="select * from CrmShareDetail where crmid="+CustomerID+" and usertype=1 and userid="+user.getUID();

//RecordSetV.executeSql(ViewSql);

//if(RecordSetV.next())
//{
//	 canview=true;
//	 canviewlog=true;
//	 canmailmerge=true;
//	 if(RecordSetV.getString("sharelevel").equals("2")){
//		canedit=true;	  
//	 }else if (RecordSetV.getString("sharelevel").equals("3") || RecordSetV.getString("sharelevel").equals("4")){
//		canedit=true;	
//		canapprove=true;		
//	 }
//}

int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>0){
     canview=true;
     canviewlog=true;
     canmailmerge=true;
     if(sharelevel==2) canedit=true;
     if(sharelevel==3||sharelevel==4){
         canedit=true;
         canapprove=true;
     }
}

 if( useridcheck.equals(RecordSetC.getString("agent")) ) {
	 canview=true;
	 canedit=true;
	 canviewlog=true;
	 canmailmerge=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

/*check right end*/

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

    
%>


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2227,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
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

<%if(canedit){%>
    <%if(endtatusid.equals("0")){%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doClick2(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON type="button" class=Btn id=myfun2 accessKey=C name=button1 onclick="doClick2()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></BUTTON>
   <%}%>  
   <%if(!(frombase.equals("1"))){%> 
   <%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:doClick1(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
	<%} %>
    <BUTTON type="button" class=Btn id=myfun1 accessKey=C name=button1 onclick="doClick1()"><U>C</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></BUTTON>
    <%if(!(endtatusid.equals("0"))){%>  
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(244,user.getLanguage())+",javascript:doClick3(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
    <BUTTON class=Btn accessKey=R type=button id=myfun3  onclick="location='/CRM/sellchance/SellChanceOperation.jsp?chanceid=<%=chanceid%>&method=reopen&customer=<%=CustomerID%>&frombase=<%=frombase %>'"><U>R</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></BUTTON>
    <%}%>
<%}%>    
</DIV>

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
	<COL width="20%">
	<COL width="80%">
	</COLGROUP>
	<TBODY>
	<TR class=Title>
	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(61,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(87,user.getLanguage())%></TH>
	</TR>
	<TR class=Spacing style="height: 1px">
	<TD class=Line1 colSpan=2></TD></TR>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
		<TD class=Field><%=subject%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%if(!user.getLogintype().equals("2")) {%>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></TD>
		<TD class=Field><a href="/hrm/resource/HrmResource.jsp?id=<%=creater%>">
		<%=ResourceComInfo.getResourcename(creater)%></a>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<%}%>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15239,user.getLanguage())%></TD>
		<TD class=Field><a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=Agent%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(Agent),user.getLanguage())%></a>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>   </TD>
		<TD class=Field>
		<a href="/CRM/data/ViewCustomer.jsp?log=n&CustomerID=<%=customerid%>"><%=CustomerInfoComInfo.getCustomerInfoname(customerid)%></a> 
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15240,user.getLanguage())%>   </TD>
		<TD class=Field>
		<%if(!comefromid.equals("")){
		String sql="select name from WorkPlan where id = "+comefromid;
		RecordSetN.executeSql(sql);
		RecordSetN.next();
		String comfromname = RecordSetN.getString("name");
		%>
		<%=comfromname%>
		<%}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15103,user.getLanguage())%></TD>
		<TD class=Field>
		<%if(!sufactorid.equals("0")){%>                    
		<%             
		String thename_s="";
		String sql_s="select fullname from CRM_Successfactor where id="+sufactorid ;
		RecordSetN.executeSql(sql_s);
		RecordSetN.next();
		thename_s = RecordSetN.getString("fullname");
		%>
		<%=thename_s%>
		<%}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15104,user.getLanguage())%></TD>
		<TD class=Field>
		<%if(!defactorid.equals("0")){%> 
		<%              
		String thename_f="";
		String sql_f="select fullname from CRM_Failfactor where id="+defactorid ;
		RecordSetN.executeSql(sql_f);
		RecordSetN.next();
		thename_f = RecordSetN.getString("fullname");
		%>
		<%=thename_f%>
		<%}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

	</TBODY>
	</TABLE>
    </TD>
    <TD></TD>
    <TD vAlign=top>

	<TABLE class=ViewForm>
		<COLGROUP>
		<COL width="20%">
		<COL width="80%">
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
		<%=preselldate%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2248,user.getLanguage())%></TD>
		<TD class=Field><%=preyield%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2249,user.getLanguage())%></TD>
		<TD class=Field><%=probability%></TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>

		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(2250,user.getLanguage())%> </TD>
		<TD class=Field>
		<%              
		String thename="";
		if (!sellstatusid.equals("")) {
			String sql="select fullname from CRM_SellStatus where id="+sellstatusid ;
			RecordSetN.executeSql(sql);
			RecordSetN.next();
			thename = RecordSetN.getString("fullname");
		%>
		<%=thename%>
		<%}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></TD>
		<TD class=Field><%=createdate%> <%=createtime%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!-- 增加销售类型开始 QC16057 -->
		<TR>
		<TD>销售类型</TD>
		<TD class=Field>
			<%if(selltype.equals("1")){%>新签<%}%>
			<%if(selltype.equals("2")){%>二次<%}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>
		<!-- 增加销售类型结束 -->
		<TR>
		<TD><%=SystemEnv.getHtmlLabelName(15112,user.getLanguage())%></TD>
		<TD class=Field>
		<%if(endtatusid.equals("0")){%><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%><%}%>
		<%if(endtatusid.equals("1")){%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%> <%}%>
		<%if(endtatusid.equals("2")){%><%=SystemEnv.getHtmlLabelName(498,user.getLanguage())%> <%}%>
		</TD>
		</TR><tr  style="height: 1px"><td class=Line colspan=2></td></tr>           
		</TBODY>					
	</TABLE>
    </TD>


    </TR></TBODY></TABLE>
    <%if(selltype.equals("1")){ %>
    <br>
    <!-- 跟进信息开始 -->
    <div id="info" style="width:100%">
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
		rs.executeSql("select infotype,item from CRM_SellChance_Set where infotype in (11,22,33,44) order by id "); 
		while(rs.next()){
			if("11".equals(rs.getString("infotype"))) docIds1 = Util.null2String(rs.getString("item"));
			if("22".equals(rs.getString("infotype"))) docIds2 = Util.null2String(rs.getString("item"));
			if("33".equals(rs.getString("infotype"))) docIds3 = Util.null2String(rs.getString("item"));
			if("44".equals(rs.getString("infotype"))) docIds4 = Util.null2String(rs.getString("item"));
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
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds1) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE class=ListStyle cellspacing=1>
													<colgroup>
														<col width="30%">
														<col width="70%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_Info where infotype=1 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>
															</td>
															<td>
																<%=Util.toScreen(rs.getString("description"),user.getLanguage()) %>
															</td>
														</TR>
														<%
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
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds2) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE class=ListStyle cellspacing=1>
													<colgroup>
														<col width="30%">
														<col width="70%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_Info where infotype=2 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>
															</td>
															<td>
																<%=Util.toScreen(rs.getString("description"),user.getLanguage()) %>
															</td>
														</TR>
														<%
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
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds3) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE class=ListStyle cellspacing=1>
													<colgroup>
														<col width="30%">
														<col width="70%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_Info where infotype=3 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>
															</td>
															<td>
																<%=Util.toScreen(rs.getString("description"),user.getLanguage()) %>
															</td>
														</TR>
														<%
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
											</th>
										</TR>
										<TR class=spacing style="height: 1px;"><TD class=line1></TD></TR>
										<tr>
											<td>参考文档：<%=cmutil.getDocName(docIds4) %></td>
										</tr>
										<TR>
											<TD vAlign=top style="padding-right: 5px;">
												<TABLE class=ListStyle cellspacing=1>
													<colgroup>
														<col width="30%">
														<col width="70%">
													</colgroup>
													<TBODY>
														<TR class="header">
															<td>标题</td>
															<td>描述</td>
														</TR>
														<%
															rs.executeSql("select name,description from CRM_SellChance_Info where infotype=4 and sellchanceId="+chanceid+" order by id "); 
															while(rs.next()){
														%>
														<TR>
															<td>
																<%=Util.toScreen(rs.getString("name"),user.getLanguage()) %>
															</td>
															<td>
																<%=cmutil.getDocName(Util.null2String(rs.getString("description"))) %>
															</td>
														</TR>
														<%
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
<%} %>
	<br>

   <TABLE class=ViewForm cellpadding=1  cols=7 id="oTable">
      <TR class=Title>
       <TH colspan=2><%=SystemEnv.getHtmlLabelName(15115,user.getLanguage())%></TH>
       <Td align=right colSpan=5>
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

        <%
        rs.executeProc("CRM_Product_SelectByID",chanceid);
        while(rs.next()){
            String productid = rs.getString("productid");
            String assetunitid = rs.getString("assetunitid");
            String salesprice = rs.getString("salesprice");
            String salesnum = rs.getString("salesnum");
            String totelprice = rs.getString("totelprice");        
            %>
           <tr>
           <td class=Field></td>
    	   <td class=Field>
             <A href="/lgc/asset/LgcAsset.jsp?paraid=<%=productid%>" >       <%=Util.toScreen(AssetComInfo.getAssetName(productid),user.getLanguage())%></a> </td>
    	   <td class=Field><%=Util.toScreen(AssetUnitComInfo.getAssetUnitname(assetunitid),user.getLanguage())%></td>
    	   <td class=Field><%=Util.toScreen(CurrencyComInfo.getCurrencyname(currencyid),user.getLanguage())%></td>
    	   <td class=Field><%=salesprice%></td>
           <td class=Field><%=salesnum%></td>
    	   <td class=Field><%=totelprice%></td> 
           </tr>
        <%}%>
       </table>  	
</FORM>
<BR>
	<FORM id=Exchange name=Exchange action="/discuss/ExchangeOperation.jsp" method=post>
	 <input type="hidden" name="method1" value="add">
     <input type="hidden" name="types" value="CS">
	<input type="hidden" name="CustomerID" value="<%=CustomerID%>">
	 <input type="hidden" name="sortid" value="<%=chanceid%>">
   <TABLE class=ListStyle cellspacing=1  >
      <TR class=header>
       <TH ><%=SystemEnv.getHtmlLabelName(15153,user.getLanguage())%></TH>
       <Td align=right >
		<BUTTON class=Btn type="button" accessKey=S onclick="doSave1()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></BUTTON>
      </Td>       
      </TR>
	   <TR >
    	  <TD class=Field colSpan="2">
		  <TEXTAREA text class=InputStyle NAME=ExchangeInfo ROWS=3 STYLE="width:100%"></TEXTAREA>
		 </TD>
	   </TR>
	 </TABLE>
<TABLE class=ViewForm>
       <TR class=title>
        <COLGROUP>
        <COL width="10%">
        <COL width="90%">
          <TD><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></TD>
          <TD class=field style="word-break: break-all;" >
			<INPUT class="wuiBrowser" _displayTemplate="<a href=/docs/docs/DocDsp.jsp?id=#b{id}>#b{name}</a>&nbsp" 
        	_url="/systeminfo/BrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp" _param="documentids" type=hidden name=docids value="">
             <span id="docidsspan"></span> 
		  </TD>
        
        </TR>
	 </TABLE>
	</FORM>
  <TABLE class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="20%">
  		<COL width="20%">
  		<COL width="60%">
     
        <TBODY>
	    <TR class=Header>
	      <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
	      <th><%=SystemEnv.getHtmlLabelName(616,user.getLanguage())%></th>
         
	    </TR>
<TR class=Line><TD colSpan=3 style="padding: 0px"></TD></TR>
<%
boolean isLight = false;
char flag=2;
int nLogCount=0;
RecordSetEX.executeProc("ExchangeInfo_SelectBID",chanceid+flag+"CS");
while(RecordSetEX.next())
{
nLogCount++;
if (nLogCount==4) {
%>
</tbody></table>
<div  id=WorkFlowDiv style="display:none">
    <table class=ListStyle cellspacing=1>
           <COLGROUP>
		<COL width="20%">
  		<COL width="20%">
  		<COL width="60%">
    <tbody> 
<%}
		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
	  <TD><%=RecordSetEX.getString("createDate")%></TD>
	  <TD><%=RecordSetEX.getString("createTime")%></TD>
	  <TD>
		<%if(Util.getIntValue(RecordSetEX.getString("creater"))>0){%>
		<a href="/hrm/resource/HrmResource.jsp?id=<%=RecordSetEX.getString("creater")%>"><%=Util.toScreen(ResourceComInfo.getResourcename(RecordSetEX.getString("creater")),user.getLanguage())%></a>
		<%}else{%>
		<A href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSetEX.getString("creater").substring(1)%>'><%=CustomerInfoComInfo.getCustomerInfoname(""+RecordSetEX.getString("creater").substring(1))%></a>
		<%}%>
	  </TD>
      </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
          <TD colSpan=3><%=Util.toScreen(RecordSetEX.getString("remark"),user.getLanguage())%></TD>
        </TR>
<%		if(isLight)
		{%>	
	<TR CLASS=DataLight>
<%		}else{%>
	<TR CLASS=DataDark>
<%		}%>
<%
        String docids_0=  Util.null2String(RecordSetEX.getString("docids"));
        String docsname="";
        if(!docids_0.equals("")){

            ArrayList docs_muti = Util.TokenizerString(docids_0,",");
            int docsnum = docs_muti.size();            
            for(int i=0;i<docsnum;i++){
                docsname= docsname+"<a href=/docs/docs/DocDsp.jsp?id="+docs_muti.get(i)+">"+Util.toScreen(DocComInfo.getDocname(""+docs_muti.get(i)),user.getLanguage())+"</a><br>" +" "; 
            }
        }
        
 %>
    <td ><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>: </td> <td  colSpan=2> <%=docsname%></td>
         </TR>
<%
	isLight = !isLight;
}
%>	  </TBODY>
	  </TABLE>
<% if (nLogCount>=4) { %> </div> <%}%>
        <table class=ListStyle cellspacing=1>
        <COLGROUP>
		<COL width="30%">
  		<COL width="30%">
  		<COL width="40%">
          <tbody> 
          <tr> 

            <% if (nLogCount>=4) { %>
            <td align=right colspan=3><SPAN id=WorkFlowspan><a href='#' onClick="displaydiv_1()"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a></span></td>
            <%}%>
          </tr>
         </tbody> 
        </table>

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

<script language=javascript>
function doClick1(){
	location='/CRM/sellchance/ListSellChance.jsp?CustomerID=<%=customerid%>';
}

function doClick2(){
	location='/CRM/sellchance/EditSellChance.jsp?CustomerID=<%=customerid%>&chanceid=<%=chanceid%>&frombase=<%=frombase%>';
}

function doClick3(){
	<%if("1".equals(selltype)){%>
	jQuery.post(
			"/CRM/sellchance/CheckType.jsp",
			{'customerId':'<%=customerid%>','sellchanceId':'<%=chanceid%>'}, 
			function(data){
				data=jQuery.trim(data);
				if(data=="false"){
					alert("此客户已存在进行中的新签销售机会！");
					return;
				}else{
					location='/CRM/sellchance/SellChanceOperation.jsp?chanceid=<%=chanceid%>&method=reopen&customer=<%=CustomerID%>&frombase=<%=frombase%>';
				}
			}
	);
	<%}else{%>
		location='/CRM/sellchance/SellChanceOperation.jsp?chanceid=<%=chanceid%>&method=reopen&customer=<%=CustomerID%>&frombase=<%=frombase%>';
	<%}%>
}
function doSave1(){
	if(check_form(document.Exchange,"ExchangeInfo")){
		document.Exchange.submit();
	}
}

function displaydiv_1()
	{
		if(WorkFlowDiv.style.display == ""){
			WorkFlowDiv.style.display = "none";
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		}
		else{
			WorkFlowspan.innerHTML = "<a href='#' onClick=displaydiv_1()><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
			WorkFlowDiv.style.display = "";
		}
	}
</script>

</BODY>
</HTML>

