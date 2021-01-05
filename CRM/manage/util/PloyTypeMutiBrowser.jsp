
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js" ></script>
	</HEAD>
<%
	
	String name = Util.null2String(request.getParameter("name"));

	String sqlWhere = " where infotype=7";
	String orderby = " order by id desc";
	
	if (!name.equals("")) {
		sqlWhere += " and item like '%" + Util.fromScreen2(name, 7) + "%'";
	}
	
	String check_per = Util.fromScreen3(request.getParameter("ids"), user.getLanguage());
	String resourceids ="";
	String resourcenames ="";

	if (!check_per.equals("")) {
		String strtmp = "select id,item from CRM_SellChance_Set where infotype=7 and id in ("+check_per+")";
		RecordSet.executeSql(strtmp);
		Hashtable ht = new Hashtable();
		while(RecordSet.next()){
			ht.put( Util.null2String(RecordSet.getString("id")), Util.null2String(RecordSet.getString("item")));
		}
		try{
			StringTokenizer st = new StringTokenizer(check_per,",");
			while(st.hasMoreTokens()){
				String s = st.nextToken().trim();
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
	//System.out.println("resourceids:"+resourceids);

	int pagenum = Util.getIntValue(request.getParameter("pagenum"), 1);
	//int perpage=Util.getIntValue(request.getParameter("perpage"),0);
	int perpage = 50;
	RecordSet.executeSql("Select count(id) RecordSetCounts from CRM_SellChance_Set " + sqlWhere);
	boolean hasNextPage = false;
	int RecordSetCounts = 0;
	if (RecordSet.next()) {
		RecordSetCounts = RecordSet.getInt(1);
	}
	if (RecordSetCounts > pagenum * perpage) {
		hasNextPage = true;
	}
	String sqltemp="";
	if(RecordSet.getDBType().equals("oracle")){
		sqltemp = "select id,item from CRM_SellChance_Set "
			+ sqlWhere
			+ " and rownum< "
			+ (RecordSetCounts - (pagenum - 1) * perpage + 1)
			+ orderby;
	} else if (RecordSet.getDBType().equals("db2")) {
		sqltemp = "select id,item from CRM_SellChance_Set "
				+ sqlWhere
				+ orderby
				+ " fetch first "
				+ (RecordSetCounts - (pagenum - 1) * perpage + 1)
				+ " rows only";
	} else {
		sqltemp = "select top "
				+ (RecordSetCounts - (pagenum - 1) * perpage)
				+ " id,item from CRM_SellChance_Set"
				+ sqlWhere + orderby;
	}
	RecordSet.executeSql(sqltemp);
	//System.out.println("recordBrowserWhere:"+sqlWhere);
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

		<FORM id=weaver NAME=SearchForm STYLE="margin-bottom:0" action="SysVersionMutiBrowser.jsp" method=post>
		<input type="hidden" name="sqlwhere" value='<%=xssUtil.put(Util.null2String(request.getParameter("sqlwhere")))%>'>
		<input type="hidden" name="pagenum" value=''>
		<input type="hidden" name="resourceids" value="">
		<!--##############Right click context menu buttons START####################-->
			<DIV align=right style="display:none">
			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(197, user.getLanguage()) + ",javascript:btnsub_onclick(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON type="button" class=btnSearch accessKey=S id=btnsub onclick="btnsub_onclick()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(197, user.getLanguage())%></BUTTON>


			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(826, user.getLanguage()) + ",javascript:btnok_onclick(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			%>
			<BUTTON type="button" class=btn accessKey=O id=btnok onclick="btnok_onclick()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%></BUTTON>

			<%
				RCMenu += "{" + SystemEnv.getHtmlLabelName(201, user.getLanguage()) + ",javascript:window.parent.close(),_self} ";
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
											<COL width="30%">
											<COL width="70%">
										</COLGROUP>
										<TR class=Spacing style="height: 1px">
											<TD class=Line1 colspan=4></TD>
										</TR>
										<TR>
												<TD width=30%><%=SystemEnv.getHtmlLabelName(460, user.getLanguage())%></TD>
												<TD width=70% class=field>
													<input class=inputstyle name=name value="<%=name%>">
												</TD>
										</TR>
										<tr style="height: 1px">
											<td class=Line colspan=4></td>
										</tr>
										<tr height="10">
											<td colspan=4>&nbsp;</td>
										</tr>
										<TR class=Spacing style="height: 1px">
											<TD class=Line1 colspan=4></TD>
										</TR>
									</TABLE>
<tr width="100%">
<td width="60%">
	<TABLE class=BroswerStyle cellspacing="0" cellpadding="0" style="width: 100%">
		<TR class=DataHeader>
			<TH width=0% style="display: none"><%=SystemEnv.getHtmlLabelName(84, user.getLanguage())%></TH>
			<TH width="100%"><%=SystemEnv.getHtmlLabelName(460, user.getLanguage())%></TH>
		</tr>

		<tr>
		<td colspan="2" width="100%">
			<div style="overflow-y:scroll;width:100%;height:400px">
			<table width="100%" id="BrowseTable">
				<%
					int i = 0;
					int totalline = 1;
					if (RecordSet.last()) {
						do {
							String id_ = Util.null2String(RecordSet.getString("id")).trim();
							String item_ = Util.toScreen(RecordSet.getString("item"),user.getLanguage());
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
					<TD style="display: none"><A HREF=#><%=id_ %></A></TD>
					<TD width="100%" style=""><%=item_ %></TD>
				</TR>
				<%
						if (hasNextPage) {
						totalline += 1;
						if (totalline > perpage)
							break;
							}
						} while (RecordSet.previous());
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
<td width="40%" valign="top">
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
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<script type="text/javascript">
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
		$("input[name=resourceids]").val( resourceids.substring(1));
	}

	function doSearch()
	{
		setResourceStr();
		$("input[name=resourceids]").val(resourceids.substring(1)) ;
	    document.SearchForm.submit();
	}
</script>
</BODY>
</HTML>