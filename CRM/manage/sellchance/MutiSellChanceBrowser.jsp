
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="SellstatusComInfo" class="weaver.crm.sellchance.SellstatusComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<%
	String subject = Util.fromScreen3(request.getParameter("subject"), user.getLanguage());
	String customerId = Util.fromScreen3(request.getParameter("customerId"), user.getLanguage());
	String sellstatusid = Util.fromScreen3(request.getParameter("sellstatusid"), user.getLanguage());
	String endtatusid = Util.fromScreen3(request.getParameter("endtatusid"), user.getLanguage());
	String selltype = Util.fromScreen3(request.getParameter("selltype"), user.getLanguage());
	int search = Util.getIntValue(request.getParameter("search"), 0);
	if(search==0) endtatusid = "0";
	
	String check_per = Util.null2String(request.getParameter("resourceids"));

	String resourceids ="";
	String resourcenames ="";

	if (!check_per.equals("")) {
		String strtmp = "select id,subject from CRM_SellChance  where id in ("+check_per+")";
		RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		while(RecordSet.next()){
			ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("subject")));
		}
		try{
			StringTokenizer st = new StringTokenizer(check_per,",");

			while(st.hasMoreTokens()){
				String s = st.nextToken();
				if(ht.containsKey(s)){
					resourceids +=","+s;
					resourcenames += ","+ht.get(s).toString();
				}
			}
		}catch(Exception e){
			resourceids ="";
			resourcenames ="";
		}
	}
	
	//找到用户能看到的所有客户
	String condition = "";
	//找到用户能看到的所有客户
	String userid = "" + user.getUID();
	//如果属于总部级的CRM管理员角色，则能查看到所有客户。
	String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid;
	rs.executeSql(sql);
	if (rs.next()) {
		condition = " (select id from CRM_CustomerInfo where deleted=0 or deleted is null) as customerIds ";
	} else {
		String leftjointable = CrmShareBase.getTempTable(userid);
		condition = " (select t1.id,t1.deleted "
			+ " from CRM_CustomerInfo t1 left join " + leftjointable + " t2 on t1.id = t2.relateditemid "
			+ " where t1.id = t2.relateditemid and (t1.deleted=0 or t1.deleted is null)) as customerIds";
	}
	String sqlWhere = "where 1=1 ";
	if (!subject.equals("")) {
		sqlWhere += " and t.subject like '%" + subject +"%'";
	}
	if (!customerId.equals("")) {
		sqlWhere += " and t.customerid = " + customerId;
	}
	if (!sellstatusid.equals("")) {
		sqlWhere += " and t.sellstatusid = " + sellstatusid;
	}
	if (!endtatusid.equals("")) {
		sqlWhere += " and t.endtatusid = " + endtatusid;
	}
	if (!selltype.equals("")) {
		sqlWhere += " and t.selltype = " + selltype;
	}

	int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
	int perpage = 50;
	RecordSet.executeSql("Select count(distinct t.id) RecordSetCounts from CRM_SellChance t join "+condition+" on t.customerId=customerIds.id "+ sqlWhere);
	boolean hasNextPage = false;
	int RecordSetCounts = 0;
	if (RecordSet.next()) {
		RecordSetCounts = RecordSet.getInt(1);
	}
	if (RecordSetCounts > pagenum * perpage) {
		hasNextPage = true;
	}
	String sqltemp="";
	int iTotal =RecordSetCounts;
	int iNextNum = pagenum * perpage;
	int ipageset = perpage;
	if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
	if(iTotal < perpage) ipageset = iTotal;

	sqltemp = "select top "+iNextNum+" t.id,t.subject,t.customerId,t.preyield,t.sellstatusid,t.endtatusid,t.selltype,t.createdate,t.createtime from CRM_SellChance t join "+condition+" on t.customerId=customerIds.id "+sqlWhere+" order by t.createdate desc,t.createtime desc";
	sqltemp = "select top " + ipageset +" t2.* from (" + sqltemp + ") t2 order by t2.createdate,t2.createtime";
	sqltemp = "select distinct top " + ipageset +" t3.* from (" + sqltemp + ") t3 order by t3.createdate desc,t3.createtime desc";
	//System.out.println("sqltemp:"+sqltemp);
	RecordSet.executeSql(sqltemp);
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<tr style="height: 10px;">
	<td height="10" colspan="3"></td>
</tr>
<tr>
	
	<td valign="top">
		<!--########Shadow Table Start########-->
<TABLE class=Shadow>
		<tr>
		<td valign="top" colspan="2">

		<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="MutiSellChanceBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
		<input type="hidden" id="search" name="search" value="1">
		<input type="hidden" id="pagenum" name="pagenum" value=''>
		<input type="hidden" id="resourceids" name="resourceids" value="">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:doSearch(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON type="button" class=btnSearch accessKey=S id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>

			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage()) + ",javascript:btnok_onclick(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></BUTTON>

			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.close(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON type="button" class=btnReset accessKey=T id=reset onclick="reset_onclick()"><U>T</U>-<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%></BUTTON>


			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(311, user.getLanguage()) + ",javascript:btnclear_onclick(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON type="button" class=btn accessKey=C id=btnclear onclick="btnclear_onclick()"><U>2</U>-<%=SystemEnv.getHtmlLabelName(311, user.getLanguage())%></BUTTON>
			</DIV>
		<!--##############Right click context menu buttons END//####################-->
		<!--######## Search Table Start########-->
									<TABLE class=ViewForm>
										<COLGROUP>
											<COL width="15%">
											<COL width="35%">
											<COL width="15%">
											<COL width="35%">
										</COLGROUP>
										<TBODY>
											<TR>
												<TD><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%><!-- 主题 -->
												</TD>
												<TD class=Field>
													<input class=inputstyle type=text style="width: 98%" maxlength="30" name="subject" value="<%=subject %>"/>
												</TD>
												<TD><%=SystemEnv.getHtmlLabelName(24974, user.getLanguage())%><!-- 客户 -->
												</TD>
												<TD class=Field>
													<input class=wuiBrowser type=hidden id=customerId name=customerId value="<%=customerId%>"
													_displayTemplate="<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?CustomerID=#b{id}')>#b{name}</a>" 
													_displayText="<%=CustomerInfoComInfo.getCustomerInfoname(customerId) %>" 
													_url="/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp" />
												</TD>
											</TR>
											<tr style="height: 1px">
												<td class=Line colspan=4></td>
											</tr>
											<tr>
											  	<TD>商机类型</TD>
											  	<TD class=Field>
												    <select class=InputStyle name="selltype">
												    	<option value=""></option>
												    	<option value="1" <%if(endtatusid.equals("1")){%> selected <%}%> >终端客户商机</option>
												    	<option value="2" <%if(endtatusid.equals("2")){%> selected <%}%> >老客户二次商机</option>
												    	<option value="3" <%if(endtatusid.equals("3")){%> selected <%}%> >代理压货商机</option>
											    	</select>
											    </TD> 
											  	<!-- 
										   		<TD class=Field>
											    	<select class=InputStyle id=sellstatusid name=sellstatusid>
											      		<option value="" <%if(sellstatusid.equals("")){%> selected<%}%> ></option>
											    <%  
											    	SellstatusComInfo.setTofirstRow();
											    	while(SellstatusComInfo.next()){
											    %>
												    	<option value="<%=SellstatusComInfo.getSellStatusid()%>"  <%if(sellstatusid.equals(SellstatusComInfo.getSellStatusid())){%>selected="selected"<%}%>>
												    		<%=SellstatusComInfo.getSellStatusname()%>
												    	</option>
											    <%	} %>
											    	</select>
										    	</TD>
										    	 -->
											    <TD>商机状态</TD>
											    <TD class=Field>
												    <select class=InputStyle name="endtatusid">
												    	<option value=""></option>
												    	<option value="4" <%if(endtatusid.equals("4")){%> selected <%}%> >培育</option>
												    	<option value="0" <%if(endtatusid.equals("0")){%> selected <%}%> >紧跟</option>
												    	<option value="3" <%if(endtatusid.equals("3")){%> selected <%}%> >暂停</option>
												    	<option value="1" <%if(endtatusid.equals("1")){%> selected <%}%> >成功</option>
												    	<option value="2" <%if(endtatusid.equals("2")){%> selected <%}%> >失败</option>
											    	</select>
											    </TD> 
											</tr>
											<tr style="height: 1px">
												<td class=Line colspan=4></td>
											</tr>
										</TBODY>
									</TABLE>
<tr width="100%">
<td width="60%" valign="middle">
	<TABLE class=BroswerStyle width="100%" cellspacing="0" cellpadding="0">
		<TR class=DataHeader>
			<TH width=0% style="display:none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
			<TH width="32%"><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></TH>   
			<TH width="47%"><%=SystemEnv.getHtmlLabelName(24974, user.getLanguage())%></TH>        
			<!-- <TH width="13%">商机类型</TH> -->
			<TH width="20%">商机状态</TH>
		</tr>
		<tr>
		<td colspan="5" width="100%">
			<div style="overflow-y:scroll;width:100%;height:400px">
			<table width="100%" id="BrowseTable">
				<%
					int i = 0;
					String id_ = "";
					String subject_ = "";
					String customerName_ = "";
					String expectDate_ = "";
					String endtatusid_ = "";
					String endtatusname_ = "";
					String selltype_ = "";
					String selltypename_ = "";
					while (RecordSet.next()) {
						id_ = RecordSet.getString("id");
						subject_ = Util.null2String(RecordSet.getString("subject"));
						customerName_ = CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("customerid"));
						endtatusid_ = Util.null2String(RecordSet.getString("endtatusid"));
						if(endtatusid_.equals("4")) endtatusname_ = "培育";
						else if(endtatusid_.equals("0")) endtatusname_ = "紧跟";
						else if(endtatusid_.equals("3")) endtatusname_ = "暂停";
						else if(endtatusid_.equals("1")) endtatusname_ = "成功";
						else if(endtatusid_.equals("2")) endtatusname_ = "失败";
						
						selltype_ = Util.null2String(RecordSet.getString("selltype"));
						if(selltype_.equals("1")) selltypename_ = "终端客户商机";
						else if(selltype_.equals("2")) selltypename_ = "老客户二次商机";
						else if(selltype_.equals("3")) selltypename_ = "代理压货商机";
							if (i == 0) {
								i = 1;
				%>
				<TR class=DataLight>
				<%
							} else {
								i = 0;
				%>
				<TR class=DataDark>
				<%
							}
				%>
					<TD style="display:none"><A HREF=#><%=id_%></A></TD>
					<TD width="35%" style="word-break:break-all"><%=subject_%></TD>	
					<TD width="50%" style="word-break:break-all"><%=customerName_%></TD>
					<!-- <TD width="13%" style="word-break:break-all"><%=selltypename_%></TD>  -->
					<TD width="15%" style="word-break:break-all"><%=endtatusname_%></TD>
				</TR>
				<%
					}
					//RecordSet.executeSql("drop table "+temptable);
				%>
						</table>
						<table align=right style="display:none">
						<tr>
						   <td>&nbsp;</td>
						   <td>
							   <%
							   if (pagenum > 1) {
							   %>
						<%
								RCMenu += "{" + SystemEnv.getHtmlLabelName(1258, user.getLanguage()) + ",javascript:weaver.prepage.click(),_top} ";
								RCMenuHeight += RCMenuHeightStep;
						%>
									<button type=submit class=btn accessKey=P id=prepage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum - 1%>;"><U>P</U> - <%=SystemEnv.getHtmlLabelName(1258, user.getLanguage())%></button>
							   <%
							   }
							   %>
						   </td>
						   <td>
							   <%
							   if (hasNextPage) {
							   %>
						<%
								RCMenu += "{" + SystemEnv.getHtmlLabelName(1259, user.getLanguage()) + ",javascript:weaver.nextpage.click(),_top} ";
								RCMenuHeight += RCMenuHeightStep;
						%>
									<button type=submit class=btn accessKey=N  id=nextpage onclick="setResourceStr();document.all('pagenum').value=<%=pagenum + 1%>;"><U>N</U> - <%=SystemEnv.getHtmlLabelName(1259, user.getLanguage())%></button>
							   <%
							   }
							   %>
						   </td>
						   <td>&nbsp;</td>
						</tr>
						</table>
			</div>
		</td>
	</tr>
	</TABLE>
</td>
<!--##########Browser Table END//#############-->
<td width="40%" valign="middle">
	<!--########Select Table Start########-->
	<table  cellspacing="1" align="left" width="100%">
		<tr>
			<td align="center" valign="top" width="30%">
				<img src="/images/arrow_u_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15084, user.getLanguage())%>" onclick="javascript:upFromList();">
				<br><br>
					<img src="/images/arrow_all_wev8.gif" style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(17025, user.getLanguage())%>" onClick="javascript:addAllToList()">
				<br><br>
				<img src="/images/arrow_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="javascript:deleteFromList();">
				<br><br>
				<img src="/images/arrow_all_out_wev8.gif"  style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(16335, user.getLanguage())%>" onclick="javascript:deleteAllFromList();">
				<br><br>
				<img src="/images/arrow_d_wev8.gif"   style="cursor:hand" title="<%=SystemEnv.getHtmlLabelName(15085, user.getLanguage())%>" onclick="javascript:downFromList();">
			</td>
			<td align="center" valign="top" width="70%">
				<select size="15" name="srcList" multiple="true" style="width:100%;word-wrap:break-word" >
					
					
				</select>
			</td>
		</tr>
		
	</table>
	<!--########//Select Table End########-->

</td>
</tr>

	</FORM>

		</td>
		</tr>
		</TABLE>
		<!--##############Shadow Table END//######################-->
	</td>
	<td></td>
</tr>
<tr style="height: 10px;">
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript">
	function setUrl(data,e){
		jQuery("#contacterId").attr("_url","/systeminfo/BrowserMain.jsp?url=/CRM/data/ContactBrowser.jsp?customer="+(data.name).replace(/(^\s*)|(\s*$)/g, ""));
	}
	function setContentName(){
		jQuery("#contactContentNames_input").val(jQuery("#contactContentIdsSpan").html());
	}

	jQuery(document).ready(function(){
		jQuery("#BrowseTable").bind("click",BrowseTable_onclick);
		jQuery("#BrowseTable").bind("mouseover",BrowseTable_onmouseover);
		jQuery("#BrowseTable").bind("mouseout",BrowseTable_onmouseout);
	});

	var resourceids = "<%=resourceids%>"
	var resourcenames = "<%=resourcenames%>"
	function btnclear_onclick(){
	     window.parent.returnValue ={id:"",name:""};
	     window.parent.close();
	}
	function btnok_onclick(){
		setResourceStr();
		window.parent.returnValue = {id:resourceids,name:resourcenames};
		window.parent.close();
	}
	function btnsub_onclick(){
		setResourceStr();
		document.SearchForm.resourceids.value = resourceids;
		document.SearchForm.submit();
	}
	function BrowseTable_onclick(e){
		var target =  e.srcElement||e.target ;
		try{
			if(target.nodeName == "TD" || target.nodeName == "A"){
				var newEntry = $($(target).parents("tr")[0].cells[0]).text()+"~"+jQuery.trim($($(target).parents("tr")[0].cells[1]).text()) ;
				if(!isExistEntry(newEntry,resourceArray)){
					addObjectToSelect($("select[name=srcList]")[0],newEntry);
					reloadResourceArray();
				}
			}
		}catch (en) {
			alert(en.message);
		}
	}
	function BrowseTable_onmouseover(e){
		var e=e||event;
	   var target=e.srcElement||e.target;
	   if("TD"==target.nodeName){
			jQuery(target).parents("tr")[0].className = "Selected";
	   }else if("A"==target.nodeName){
			jQuery(target).parents("tr")[0].className = "Selected";
	   }
	}
	function BrowseTable_onmouseout(e){
		var e=e||event;
	   var target=e.srcElement||e.target;
	   var p;
		if(target.nodeName == "TD" || target.nodeName == "A" ){
	      p=jQuery(target).parents("tr")[0];
	      if( p.rowIndex % 2 ==0){
	         p.className = "DataDark";
	      }else{
	         p.className = "DataLight";
	      }
	   }
	}

//Load
var resourceArray = new Array();
for(var i =1;i<resourceids.split(",").length;i++){
	
	resourceArray[i-1] = resourceids.split(",")[i]+"~"+resourcenames.split(",")[i];
	//alert(resourceArray[i-1]);
}

loadToList();
function loadToList(){
	var selectObj = $("select[name=srcList]")[0];
	for(var i=0;i<resourceArray.length;i++){
		addObjectToSelect(selectObj,resourceArray[i]);
	}
	
}
function addObjectToSelect(obj,str){
	//alert(obj.tagName+"-"+str);
	
	if(obj.tagName != "SELECT") return;
	var oOption = document.createElement("OPTION");
	obj.options.add(oOption);
	oOption.value = str.split("~")[0];
	$(oOption).text(str.split("~")[1]);
	
}

function isExistEntry(entry,arrayObj){
	
	for(var i=0;i<arrayObj.length;i++){
		
		if(entry == arrayObj[i].toString()){
			return true;
		}
	}
	return false;
}

function upFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = 0; i <= (len-1); i++) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i>0 && destList.options[i-1] != null){
				fromtext = destList.options[i-1].text;
				fromvalue = destList.options[i-1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i-1] = new Option(totext,tovalue);
				destList.options[i-1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
function addAllToList(){
	var table =$("#BrowseTable");
	$("#BrowseTable").find("tr").each(function(){
		var str=$($(this)[0].cells[0]).text()+"~"+$($(this)[0].cells[1]).text().trim();
		if(!isExistEntry(str,resourceArray))
			addObjectToSelect($("select[name=srcList]")[0],str);
	});
	reloadResourceArray();
}

function deleteFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function deleteAllFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
	if (destList.options[i] != null) {
	destList.options[i] = null;
		  }
	}
	reloadResourceArray();
}
function downFromList(){
	var destList  = $("select[name=srcList]")[0];
	var len = destList.options.length;
	for(var i = (len-1); i >= 0; i--) {
		if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
			if(i<(len-1) && destList.options[i+1] != null){
				fromtext = destList.options[i+1].text;
				fromvalue = destList.options[i+1].value;
				totext = destList.options[i].text;
				tovalue = destList.options[i].value;
				destList.options[i+1] = new Option(totext,tovalue);
				destList.options[i+1].selected = true;
				destList.options[i] = new Option(fromtext,fromvalue);		
			}
      }
   }
   reloadResourceArray();
}
//reload resource Array from the List
function reloadResourceArray(){
	resourceArray = new Array();
	var destList =$("select[name=srcList]")[0];
	for(var i=0;i<destList.options.length;i++){
		resourceArray[i] = destList.options[i].value+"~"+jQuery.trim(destList.options[i].text) ;
	}
	//alert(resourceArray.length);
}
function setResourceStr(){
	
	resourceids ="";
	resourcenames = "";
	for(var i=0;i<resourceArray.length;i++){
		resourceids += ","+resourceArray[i].split("~")[0] ;
		resourcenames += ","+resourceArray[i].split("~")[1] ;
	}
	//alert(resourceids+"--"+resourcenames);
	//$("input[name=resourceids]").val( resourceids.substring(1));
	$("#resourceids").val( resourceids.substring(1)+"_"+$("#customerId").val());
	//alert($("#resourceids").val());
}

function doSearch()
{
	setResourceStr();
	//$("input[name=resourceids]").val(resourceids.substring(1)) ;
    document.SearchForm.submit();
}
</script>
</BODY>
</HTML>