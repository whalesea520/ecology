<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.cpcompanyinfo.CompanyInfoTransMethod"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@page import="weaver.docs.docs.DocComInfo"%>

<jsp:useBean id="jspUtil" class="weaver.cpcompanyinfo.JspUtil" scope="page" />

<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<jsp:useBean id="CpcDetailColUtil" class="weaver.cpc.util.CpcDetailColUtil" scope="page" />
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery = Util.null2String(request.getParameter("flowTitle"));


String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<link href="/js/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript">
var parentWin;
var parentDialog;
if("<%=isDialog %>"=="1"){
	var parentDialog = parent.parent.getDialog(parent);
	parentWin = parent.getParentWindow(window);
}
if("<%=isclose%>"=="1"){
	try{
		
		parentWin = parent.getParentWindow(window);
		parentDialog = parent.parent.getDialog(parent);
		parentDialog.close();
		parentWin._table.reLoad();
	}catch(e){}
		
}
</script>
<link rel="stylesheet" type="text/css" href="/cpcompanyinfo/style/wbox_wev8.css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<%

	String companyid = Util.null2String(request.getParameter("companyid"));
	boolean maintFlag = false;
	if(cu.canOperate(user,"2")||cu.canOperate(companyid,user,"2"))//后台维护权限
	{
		maintFlag = true;
	}	
	String companyname = Util.null2String(request.getParameter("companyname"));
	/*证照<一定是营业执照>*/
	String zz_isadd = "add";
	
	int licenseid = 0;
	String registeraddress = "";
	String registercapital = "";
	String paiclupcapital = "";
	int currencyid_zz = 0;
	String licensename = "";
	
	String corporation = "";
	String usefulbegindate = "";
	String usefulenddate = "";
	String usefulyear = "";
	
	String strzz = " select t1.licenseid, t1.registeraddress,t1.registercapital,t1.paiclupcapital,t1.currencyid,t2.licensename," +
	" t1.corporation,t1.usefulbegindate,t1.usefulenddate,t1.usefulyear " +
	" from CPBUSINESSLICENSE t1,CPLMLICENSEAFFIX t2 where t1.licenseaffixid = t2.licenseaffixid and t1.isdel='T'" +
	" and t2.licensetype='1' and companyid= " + companyid;
	//System.out.println(strzz);
	rs.execute(strzz);
	if(rs.next()){
		licenseid = rs.getInt("licenseid");
		registeraddress = rs.getString("registeraddress");
		registercapital = rs.getString("registercapital");
		paiclupcapital = rs.getString("paiclupcapital");
		currencyid_zz = rs.getInt("currencyid");
		licensename = rs.getString("licensename");
		corporation = rs.getString("corporation");
		usefulbegindate = rs.getString("usefulbegindate");
		usefulenddate = rs.getString("usefulenddate");
		usefulyear = rs.getString("usefulyear");
	}
	
	String o4sql = " select * from mytrainaccessoriestype where accessoriesname='lmdirectors'";
	rs.execute(o4sql);
	String mainId="0";
	String subId="0";
	String secId="0";
	if(rs.next()){
		mainId=rs.getString("mainId");//覆盖默认的0
	 	subId=rs.getString("subId");//覆盖默认的0
	 	secId=rs.getString("secId");//覆盖默认的0c
	}
		//很关键的一个变量，用于判断后续页面是否开发编辑权限
	//0--只有这个公司的查看权限，没有维护权限
	//1--拥有这个公司查看和维护全县
	String showOrUpdate = Util.null2String(request.getParameter("showOrUpdate"));
%>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="cpcompany"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("30936",user.getLanguage())%>'/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<!--表头浮动层 start-->
<input type="hidden" id="constitutionid_dsh"/>
<input type="hidden" id="method_dsh"/>
<input type="hidden" id="directorsid"/>
<input type="hidden" id="isaddversion"/>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
		<%
		if(maintFlag){
			%>
			<span  id="save_H">	
				<a id="saveBoardDirectorsBtn" href="javascript:void(0);" class="hover"> 
					<input type="button" id="saveBoa" value="<%=SystemEnv.getHtmlLabelNames("31005",user.getLanguage())%>" class="e8_btn_top" onclick="saveDate()"/>
				</a>
			</span>	
			<%
		}
		%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelNames("19450",user.getLanguage())%>" class="e8_btn_top" onclick="openVersionManage()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="advancedSearchDiv" style="display:none;" id="advancedSearchDiv"></div>


<wea:layout attributes="{'expandAllGroup':'true'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type="text" name="companyname_indsh" id="companyname_indsh" onfocus= "this.blur();"
						class="OInput3" style="width:339px;background-color:#F8F8F8;" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23797,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type="text" name="corporation_indsh" id="corporation_indsh" onfocus= "this.blur();"
						class="OInput3 BoxW120" style="background-color:#F8F8F8;"/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31029,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type="text" name="usefulbegindate_indsh" id="usefulbegindate_indsh" onfocus= "this.blur();"
				class="OInput3 BoxW90"  style="width:100px;background-color:#F8F8F8; "/> - 
			<input type="text" name="usefulenddate_indsh" id="usefulenddate_indsh" onfocus= "this.blur();"
				class="OInput3 BoxW90"  style="width:100px;background-color:#F8F8F8; "/>
			&nbsp;&nbsp;
			<%=SystemEnv.getHtmlLabelName(26852,user.getLanguage()) %>：<input type="text" name="usefulyear_indsh" id="usefulyear_indsh" onfocus= "this.blur();"
				class="OInput3 BoxW30"    style="width:50px;background-color:#F8F8F8; " /> <%=SystemEnv.getHtmlLabelName(26577,user.getLanguage()) %>
		</wea:item>
		<wea:item>
			<select id="ischairman_dsh" class="OSelect" <%=maintFlag?"":"disabled" %>>
				<option value="1">
					 <%=SystemEnv.getHtmlLabelName(30996,user.getLanguage()) %>
				</option>
				<option value="2">
					 <%=SystemEnv.getHtmlLabelName(30997,user.getLanguage()) %>
				</option>
			</select>
		</wea:item>
		<wea:item>
			<input type="text" name="chairman_dsh" id="chairman_dsh"
						class="OInput2 BoxW120" style="width:135px;" onblur="displayimg(this)"/><img src="images/O_44_wev8.jpg" class="ML5" style="margin-bottom: -3px;" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage()) %></wea:item>
		<wea:item>
			<BUTTON  class="Clock"  type="button"    onclick="onShowDate(document.getElementById('appointbegindate_dsh'),document.getElementById('appbegintime'))"></BUTTON>
					<input type="hidden" id="appbegintime" name="appbegintime"  />
					<span id="appointbegindate_dsh">
						<img src="images/O_44_wev8.jpg"   class="ML5" style="margin-bottom: -3px;" />
					</span>
					 -
					 <BUTTON  class="Clock"  type="button"    onclick="onShowDate(document.getElementById('appointenddate_dsh'),document.getElementById('appendtime'))"></BUTTON>
					<input type="hidden" id="appendtime" name="appendtime"  />
					<span id="appointenddate_dsh">
						<img src="images/O_44_wev8.jpg"   class="ML5" style="margin-bottom: -3px;" />
					</span>
					
					
					&nbsp;&nbsp;
					<%=SystemEnv.getHtmlLabelName(30995,user.getLanguage()) %>：<input type="text" name="appointduetime_dsh" id="appointduetime_dsh"
						class="OInput2 BoxW30" style="width:50px" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  onpaste="javascript: return false;" /> <%=SystemEnv.getHtmlLabelName(26577,user.getLanguage()) %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20696,user.getLanguage())  %></wea:item>
		<wea:item>
			<input type="text" name="generalmanager_dsh" id="generalmanager_dsh"
						class="OInput2 BoxW120" style="width:80px"/>
						&nbsp;
						<%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())  %>
						<BUTTON type="button" class=Clock  onclick="gettheDate(document.getElementById('manbegintime'),document.getElementById('managerbegindate_dsh'))"></BUTTON>
						<SPAN id=managerbegindate_dsh ></SPAN>
						<input type="hidden" name="manbegintime"   id="manbegintime" >
						-&nbsp;&nbsp;
						<BUTTON type="button" class=Clock   onclick="gettheDate(document.getElementById('manendtime'),document.getElementById('managerenddate_dsh'))"></BUTTON>
						<SPAN id=managerenddate_dsh ></SPAN>
						<input type="hidden" name="manendtime"  id="manendtime" ">
							&nbsp;&nbsp;
						<%=SystemEnv.getHtmlLabelName(30995,user.getLanguage())  %>：<input type="text" name="managerduetime_dsh" id="managerduetime_dsh"
						class="OInput2 BoxW30"  onkeyup="this.value=this.value.replace(/\D/g,'')" style="width:50px" onafterpaste="this.value=this.value.replace(/\D/g,'')"  onpaste="javascript: return false;" /> <%=SystemEnv.getHtmlLabelName(26577,user.getLanguage())  %>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())  %></wea:item>
		<wea:item>
			<%if(!CompanyInfoTransMethod.CheckPack("4")){out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(31004,user.getLanguage()) +"！</span>");}%>
					<div id="licenseAffixUpload" >
					<input type="hidden" name="affixdoc" id="affixdoc">
						<span> 
							<span id='spanButtonPlaceHolder'></span><!--选取多个文件-->
						</span>
						&nbsp;&nbsp;
						<span style="color: #262626; cursor: hand; TEXT-DECORATION: none;<%if(!CompanyInfoTransMethod.CheckPack("4")){out.println("display: none;");}%>"
							disabled id="btnCancel_upload">
							<span><img src="/js/swfupload/delete_wev8.gif" border="0" onClick="oUploader.cancelQueue()"> </span> <span
							style="height: 19px"> <font style="margin: 0 0 0 -1"><%=SystemEnv.getHtmlLabelName(21407,user.getLanguage()) %>
							(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage()) %>100<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage()) %>)
							</font> <!--清除所有--> </span> </span>
						<div id="divImgsAddContent" style="overflow: auto;">
							<div></div>
							<div class="fieldset flash" id="fsUploadProgress"></div>
							<div id="divStatus"></div>
						</div>
					</div>
						<div id="affixcpdosDIV">
						<%
							int userid = user.getUID();
							String affixdoc = "";
							String affixsql = " select drectorsaffix from CPBOARDDIRECTORS where companyid = " + companyid;
							rs.execute(affixsql);
							if(rs.next()){
								affixdoc = Util.null2String(rs.getString("drectorsaffix"));
							}
							String isdoc="";
							if(!"".equals(affixdoc))
							{
								
								DocComInfo dc=new DocComInfo();						
								String []slaves=affixdoc.split(",");
								for(int i=0;i<slaves.length;i++)
								{
									String tempid="asid"+slaves[i];
								
									out.println("<div id='imgfileDiv"+i+"' style='background-color: #F7F7F7;height:20px;padding-left:4px;border: solid 1px #E8E8E8;padding: 4px;margin-bottom: 5px;'>");
								
									String filename="";
									String fileid="";
									rs.execute("select imagefileid,imagefilename from imagefile where imagefileid = "+slaves[i]);
									if(rs.next()){
										filename = rs.getString("imagefilename");
										fileid= rs.getString("imagefileid");
									}
									out.println("<div style='width:80%;float:left;' >");
									String str="<A id='pdflinkid"+i+"' href='/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1' class='aContent0 FL'>"+filename+"</A>";
									//输出文档主题，提供下载
									out.println(str);
									out.println("</div>");
									
									//out.println("<div style='width:40%;float:left;'>");
									//输出文档创建时间
									//out.println(dc.getDocCreateTime(slaves));
									//out.println("</div>");
									
									
									out.println("<div style='padding-right:0px;float:right;padding-top:0px'>");
									
									//out.println("文档创建着id"+dc.getDocCreaterid(slaves[i]));
									//getDocOwnerid
									
									//if(dc.getDocCreaterid(slaves[i]).equals(userid+""))//当前用户是文档的创建者
								//	{		
										//输出删除文档超链接												
										//isdoc = "affixdoc";
										//out.println("<img src='images/delwk_wev8.gif' onclick=delImg(imgfileDiv"+i+","+slaves[i]+") title='删除'></a>");
									//}else
									//{
										//输出下载文档超链接									
									
										out.println("<a href='/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1'><img src='images/downLoadPic_wev8.gif'  title='"+SystemEnv.getHtmlLabelName(258,user.getLanguage())+"'  ></a>");
										if(!"0".equals(showOrUpdate)){
											out.println("<img src='images/delwk_wev8.gif' onclick=delImg(imgfileDiv"+i+","+slaves[i]+") title='"+SystemEnv.getHtmlLabelName(125426,user.getLanguage())+"'></a>");
										}
									//}
									
									out.println("</div>");					
									out.println("</div>");
								}
							}
									
				
						%>
						</div>
		
		</wea:item>
	</wea:group>
</wea:layout>


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("30998",user.getLanguage())%>' attributes="{'groupDisplay':''}">
		<wea:item type="groupHead">
		
    <div id="selectdate1" class="_box" style="float:right!important;margin-right:20px!important;margin-top:5px!important;">
			
			<select id="selectdate01" onchange="javascript:searchzhzhdate(this);" class="OSelect MT3 MLeft8" >
				<%
					int  year = new Date().getYear()+1900;
					for(int i = year;i >=1990 ; i--){
				%>	
					<option><%=i %></option>		
				
				<%
					}
				%>
			</select>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("445",user.getLanguage())%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	
<%
if(maintFlag){
	%>
      <input type="button" id="newDscyBtn" value="" class="addbtn" onclick="doadd_dsh()" /> 
      <input type="button" id="delDscyBtn" value="" class="delbtn" onclick="dodel_dsh()" /> 
	<%
}
%>      
    </div>			
			
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">


<table id="webTable2dsh"  border="0" cellpadding="0" cellspacing="1" class="ListStyle">

		<colgroup>
				<col width="8%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="20%">
				<col width="*">
		</colgroup>
	
	<tr id="OTable2" class="header">
		<td>
			<%
					if(!"0".equals(showOrUpdate)){
			%>
			<input type="checkbox" id="fileid" onclick="selectall_chk(this)"/>
			<%
				}
			 %>
		</td>
		
		<td >
			<%=SystemEnv.getHtmlLabelName(30999,user.getLanguage()) %>
		</td>
		<td>
			<%=SystemEnv.getHtmlLabelName(31000,user.getLanguage()) %>
		</td>
		<td>
			<%=SystemEnv.getHtmlLabelName(24978,user.getLanguage()) %>
		</td>
		<td >
			<%=SystemEnv.getHtmlLabelName(22326,user.getLanguage()) %>
		</td>
		<td >
			<%=SystemEnv.getHtmlLabelName(31001,user.getLanguage()) %>
		</td>
		<td >
			<%=SystemEnv.getHtmlLabelName(20820,user.getLanguage()) %>
		</td>
	</tr>
	
	
	<%
		String sql="select t2.* from CPBOARDDIRECTORS t1,CPBOARDOFFICER t2 where t1.directorsid = t2.directorsid and t1.companyid = " + companyid +" order by t2.isstop desc,t2.officebegindate asc";
		rs.execute(sql);
		int ix=1;
		while (rs.next()){
		String valuedate = "";
		if(!Util.null2String(rs.getString("officebegindate")).equals(""))
		valuedate = rs.getString("officebegindate").substring(0,4);
	 %>
	<tr dbvalue="<%=valuedate %>"  class='DataLight'>
		<td >
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<input type="checkbox" name="checkboxdsh"  inWhichPage="dsh" onclick="selectone_chk()"/>
			<%
				}
			%>
				
			
			
		</td>
		<td  >
			
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<!-- 董事会届数 -->
			<input type="text" value="<%=rs.getString("sessions") %>"   onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'   style="display: none;">
			</span>
			<%
				}else{
			%>
					<%=rs.getString("sessions") %>
			<% 
				}
			%>

		</td>
		<td >
			
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<!-- 董事姓名 -->
			<input type="text" value="<%=rs.getString("officename") %>" onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'   style="display: none;">
			</span>
			<%
				}else{
			%>
					<%=rs.getString("officename") %>
			<% 
				}
			%>
		</td>
		<td  >
			<!-- 开始时间 -->
				
				<BUTTON class=Clock   name="hidebegindate01"   type="button"  onclick="onShowDate(document.getElementById('officebegindate_span<%=ix%>'),document.getElementById('officebegindate_input<%=ix%>'));"></BUTTON>
				<INPUT  type=hidden value="<%=rs.getString("officebegindate") %>" id="officebegindate_input<%=ix%>">
				<span id="officebegindate_span<%=ix%>">
						<%=rs.getString("officebegindate") %>
				</span>
				
		</td>
		<td >
			<!-- 结束时间 -->
			
			<BUTTON class=Clock   name="hideenddate01"   type="button" onclick="onShowDate(document.getElementById('officeenddate_span<%=ix%>'),document.getElementById('officeenddate_input<%=ix%>'));"></BUTTON>
			<INPUT  type=hidden  value="<%=rs.getString("officeenddate") %>" id="officeenddate_input<%=ix%>">
			<span id="officeenddate_span<%=ix%>">
						<%=rs.getString("officeenddate") %>
			</span>
		</td>
		<td >
			<select style=" width:37px; height:26px;border:0px;" <%=maintFlag?"":"disabled" %>>
				<%=jspUtil.getOption("1,2",SystemEnv.getHtmlLabelName(126151,user.getLanguage())+","+SystemEnv.getHtmlLabelName(126152,user.getLanguage()),rs.getString("isstop")) %>
			</select>
		</td>
		<td >
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<input type="text" value="<%=rs.getString("remark") %>"  text-align:center;"></input>
			<%
				}else{
			%>
					<%=rs.getString("remark") %>
			<% 
				}
			%>
		</td>
	</tr>
	<%
		ix++;}
	 %>
</table>



		</wea:item>
	</wea:group>
</wea:layout>


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("31002",user.getLanguage())%>' attributes="{'groupDisplay':''}">
		<wea:item type="groupHead">
		
    <div id="selectdate2" class="_box" style="float:right!important;margin-right:20px!important;margin-top:5px!important;">
			<select id="selectdate03" onchange="javascript:searchzhzhdate2js(this);" class="OSelect MT3 MLeft8">
				<%
					int  year = new Date().getYear()+1900;
					for(int i = year;i >=1990 ; i--){
				%>	
					<option><%=i %></option>		
				
				<%
					}
				%>
			</select>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("445",user.getLanguage())%>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
if(maintFlag){
	%>
      <input type="button" id="newDscy2jsBtn" value="" class="addbtn" onclick="doadd_jsh()" /> 
      <input type="button" id="delDscy2jsBtn" value="" class="delbtn" onclick="dodel_jsh()" /> 
	<%
}
%>      
    </div>			
			
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
		


<table id="webTable2jsh" width="614" border="0" cellpadding="0" cellspacing="1" class="ListStyle">

	<colgroup>
				<col width="8%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="20%">
				<col width="*">
	</colgroup>
	
	<tr id="OTable2" class="header">
		<td>
			<%
					if(!"0".equals(showOrUpdate)){
			%>
			<input type="checkbox" id="fileid2js" onclick="selectall_chk2js(this)"/>
			<%
				}
			 %>
		</td>
		<td >
			<%=SystemEnv.getHtmlLabelName(30999,user.getLanguage()) %>
		</td>
		<td>
			<%=SystemEnv.getHtmlLabelName(31003,user.getLanguage()) %>
		</td>
		<td>
			<%=SystemEnv.getHtmlLabelName(24978,user.getLanguage()) %>
		</td>
		<td>
			<%=SystemEnv.getHtmlLabelName(22326,user.getLanguage()) %>
		</td>
		<td >
			<%=SystemEnv.getHtmlLabelName(31001,user.getLanguage()) %>
		</td>
		<td >
			<%=SystemEnv.getHtmlLabelName(26408,user.getLanguage()) %>
		</td>
	</tr>
	
	
	<%
		String jssql="select t2.* from CPBOARDDIRECTORS t1,CPBOARDSUPER t2 where t1.directorsid = t2.directorsid and t1.companyid = " + companyid +" order by t2.isstop desc,t2.SUPERBEGINDATE asc";
		rs.execute(jssql);
		int jsix=1;
		while (rs.next()){
		//System.out.println(Util.null2String(rs.getString("officebegindate")).substring(0,4));
		String valuedate = "";
		if(!Util.null2String(rs.getString("SUPERBEGINDATE")).equals(""))
		valuedate = rs.getString("SUPERBEGINDATE").substring(0,4);
	 %>
	<tr dbvalue="<%=valuedate %>" class="DataLight">
		<td >
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<input type="checkbox" name="checkboxjsh" inWhichPage="jsh" onclick="selectone_chk2js()"/>
			<%
				}
			 %>
		</td>
		<td>
			
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<input type="text" value="<%=rs.getString("sessions") %>"   text-align:center;" onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'   style="display: none;">
			</span>
			<%
				}else{
			%>
				<%=rs.getString("sessions") %>
			<%
				}
			 %>
		</td>
		<td >
				
				<%
				if(!"0".equals(showOrUpdate)){
			%>
			<input type="text" value="<%=rs.getString("SUPERNAME") %>"    background-image:none; text-align:center;" onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'   style="display: none;">
			</span>
			<%
				}else{
			%>
				<%=rs.getString("SUPERNAME") %>
			<%
				}
			 %>
			
		</td>
		<td>
				<!-- 开始时间 -->
				
				<BUTTON class=Clock   name="hidebegindate02"   type="button" onclick="onShowDate(document.getElementById('superbegindate_span<%=jsix%>'),document.getElementById('superbegindate_input<%=jsix%>'));"></BUTTON>
				<INPUT  type=hidden value="<%=rs.getString("SUPERBEGINDATE") %>"  id="superbegindate_input<%=jsix%>">
				<span  id="superbegindate_span<%=jsix%>">
						<%=rs.getString("SUPERBEGINDATE") %>
				</span>
		</td>
		<td  >
				<!-- 结束时间 -->
				
				<BUTTON class=Clock   name="hideenddate02"   type="button"  onclick="onShowDate(document.getElementById('superenddate_span<%=jsix%>'),document.getElementById('superenddate_input<%=jsix%>'));"></BUTTON>
				<INPUT  type=hidden  value="<%=rs.getString("SUPERENDDATE") %>"  id=superenddate_input<%=jsix%>>
				<span  id=superenddate_span<%=jsix%>>
						<%=rs.getString("SUPERENDDATE") %>
				</span>
		</td>
		<td >
			<select style=" width:37px; height:26px;border:0px;" <%=maintFlag?"":"disabled" %>>
			
				<%=jspUtil.getOption("1,2",""+SystemEnv.getHtmlLabelName(30586,user.getLanguage()) +","+SystemEnv.getHtmlLabelName(30587,user.getLanguage()) +"",rs.getString("isstop")) %>
			</select>
		</td>
		<td >
			<%
				if(!"0".equals(showOrUpdate)){
			%>
			<input type="text" value="<%=rs.getString("remark") %>"  background-image:none; text-align:center;"></input>
			<%
				}else{
			%>
				<%=rs.getString("remark") %>
			<%
				}
			 %>
		</td>
	</tr>
	<%
		jsix++;}
	 %>
</table>
		
		</wea:item>
	</wea:group>
</wea:layout>

<div style="height:100px">
	
</div>

<!--表头浮动层 end-->

<div id="hiddenTrInDIV" style="display:none">

		<span _calss="show">
			<input type="checkbox" name="checkboxdsh" inWhichPage="dsh" onclick="selectone_chk()"/>
		</span>
		
		<span _calss="show">
			<input type="text"  onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
			</span>
		</span>
		
		<span _calss="show">
			<input type="text"  onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
			</span>
		</span>
		
		<span _calss="show">
			<!-- 开始时间 -->
			<BUTTON class=Clock   name="hidebegindate01"   type="button"></BUTTON>
			<INPUT  type=hidden>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
			</span>
		</span>
		<span _calss="show">
			<!-- 结束时间 -->
			
			<BUTTON class=Clock   name="hideenddate01"   type="button"></BUTTON>
			<INPUT  type=hidden>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
			</span>
		</span>
		
		<span _calss="show">
			<select class="_needBeauty" notBeauty=true <%=maintFlag?"":"disabled" %>>
				<option value="2"><%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())  %></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())  %></option>
			</select>
		</span>
		
		<span _calss="show">
			<input type="text"   text-align:center;"></input>
		</span>
		
</div>

<div id="hiddenTrInDIV2js" style="display:none">
		<span _calss="show">
 				<input type="checkbox" name="checkboxjsh" inWhichPage="jsh" onclick="selectone_chk2js()"/>
 		</span>
		<span _calss="show">
			<input type="text"   onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
			</span>
		 </span>
		 <span _calss="show">
			<input type="text"  onblur="displayimg(this)"></input>
			<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
			</span>
		 </span>
		<span _calss="show">
				<!-- 开始时间 -->
				<BUTTON class=Clock   name="hidebegindate02"   type="button"></BUTTON>
				<INPUT  type=hidden>
				<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
				</span>
		 </span>
		<span _calss="show">
				<!-- 结束时间 -->
				<BUTTON class=Clock   name="hideenddate02"   type="button"></BUTTON>
				<INPUT  type=hidden>
				<span>
					<IMG align=absMiddle src='/images/BacoError_wev8.gif'>
				</span>
		 </span>
		 <span _calss="show">
			<select class="_needBeauty" notBeauty=true <%=maintFlag?"":"disabled" %>>
				<option value="2"><%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())  %></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())  %></option>
			</select>
		 </span>
		<span _calss="show">
			<input type="text"  ></input>
		 </span>
		
</div>

<!-- 证照弹出层 -->

<div style="clear:both;display:none" id="licenseDiv">
	<div id="wBox" style="top:80px;left:400px;"><!-- 定义层在什么位置上 -->
		<div class="wBox_popup">
    		<table>
    			<tbody>
    				<tr><td class="wBox_tl"/><td class="wBox_b"/><td class="wBox_tr"/></tr>
    				<tr><td class="wBox_b"></td>
    					<td>
		   					<div class="wBox_body">
		       					<table class="wBox_title">
		       						<tr>
		          						<td class="wBox_dragTitle"><div class="wBox_itemTitle"><%=SystemEnv.getHtmlLabelName(31006,user.getLanguage())  %></div></td>
		          						<td width="20px" title="<%=SystemEnv.getHtmlLabelNames("309",user.getLanguage())%>" onclick="javascript:onLicenseDivClose();"><div class="wBox_close"></div></td>
		       						</tr>
		     					</table>
		     					<div class="wBox_content" id="wBoxContent" style="width:335px;height:325px;overflow-y:auto;">
		      					<!-- 定义层里面的内容 -->
		     					</div>
		   					</div>
        				</td>
        				<td class="wBox_b"></td></tr>
        			<tr><td class="wBox_bl"></td><td class="wBox_b"></td><td class="wBox_br"></td></tr>
        		</tbody>
        	</table>
   		</div>
	</div>
</div> 
 <!-- 遮罩层 start -->
<div id='wBox_overlay' class='wBox_hide' style="clear:both;"></div>
<!-- 遮罩层 end --> 

<script type="text/javascript">
	jQuery(document).ready(function(){
		var o4params = {
			method:"get",
			companyid:"<%=companyid%>"
		}
		
		jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",o4params,function(data){
			var dsh_add = data[0];
			jQuery("#method_dsh").val(dsh_add);
			if(dsh_add=="add"){
				jQuery("#spanTitle_dsh").html("<%=SystemEnv.getHtmlLabelName(31007,user.getLanguage())  %>");
				<%if("0".equals(showOrUpdate)){%>jQuery("#spanTitle_dsh").html("<%=SystemEnv.getHtmlLabelName(31148,user.getLanguage()) %>");<%}%>
				jQuery(":text[id$='_dsh']").val("");		//清空文本框文
				jQuery(".OSelect").val("1");	//选择框复原
			}else{
				jQuery("#spanTitle_dsh").html("<%=SystemEnv.getHtmlLabelName(31008,user.getLanguage())  %>");
				<%if("0".equals(showOrUpdate)){%>jQuery("#spanTitle_dsh").html("<%=SystemEnv.getHtmlLabelName(31148,user.getLanguage()) %>");<%}%>
				jQuery("#directorsid").val(data[1]["directorsid"]);
				jQuery("#chairman_dsh").val(data[1]["chairman"]);
				
				jQuery("#appointbegindate_dsh").html(data[1]["appointbegindate"]);
				jQuery("#appbegintime").val(data[1]["appointbegindate"]);
				jQuery("#appointenddate_dsh").html(data[1]["appointenddate"]);
				jQuery("#appendtime").val(data[1]["appointenddate"]);
				
				jQuery("#appointduetime_dsh").val(data[1]["appointduetime"]);
				jQuery("#supervisor_dsh").val(data[1]["supervisor"]);
				jQuery("#generalmanager_dsh").val(data[1]["generalmanager"]);
				jQuery("#ischairman_dsh").val(data[1]["ischairman"]);
				jQuery("#affixdoc").val(data[1]["drectorsaffix"]);
				
				jQuery("#managerbegindate_dsh").html(data[1]["managerbegindate"]);
				jQuery("#manbegintime").val(data[1]["managerbegindate"]);
				
				jQuery("#managerenddate_dsh").html(data[1]["managerenddate"]);
				jQuery("#manendtime").val(data[1]["managerenddate"]);
				
				
				
				jQuery("#managerduetime_dsh").val(data[1]["managerduetime"]);
				displayimg(jQuery("#chairman_dsh"));
			}
		},"json");
		
		/*灰色、默认初始化值*/
		jQuery("#companyname_indsh").val("<%=companyname%>");
		jQuery("#corporation_indsh").val("<%=corporation%>");
		jQuery("#usefulbegindate_indsh").val("<%=usefulbegindate%>");
		jQuery("#usefulenddate_indsh").val("<%=usefulenddate%>");
		jQuery("#usefulyear_indsh").val("<%=usefulyear%>");
		
		//保存按钮指向保存方法
		//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:saveDate();");
		
		var now = new Date();
		var currentYear = now.getFullYear();
		var selectdateoptions = '';
		for(xx=0;xx<=currentYear-1990;xx++){
			selectdateoptions+= "<option value='"+(currentYear-xx)+"'>"+(currentYear-xx)+"</option>";
		}
		jQuery("#selectdate01").html(selectdateoptions);
		jQuery("#selectdate03").html(selectdateoptions);
		<%
		
			if("0".equals(showOrUpdate)){
		%>
				jQuery(".Clock").hide();
				jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
				jQuery("select").attr("disabled","disabled");  
				jQuery("#save_H").hide();
				jQuery("#webTable2dsh").attr("disabled","disabled");  
				jQuery("#webTable2jsh").attr("disabled","disabled");  
				jQuery("#licenseAffixUpload").hide();
		<%
			}
		%>
		
	});
	
	function searchzhzhdate(o4this){
		var obj = jQuery("#webTable2dsh").find("tr");
		for(i=1;i<obj.size();i++){
			
			if(jQuery(o4this).val()==jQuery(obj[i]).attr("dbvalue"))
				jQuery(obj[i]).show();
			else
				jQuery(obj[i]).hide();
		}
	}
	
	function searchzhzhdate2js(o4this){
		var obj = jQuery("#webTable2jsh").find("tr");
		for(i=1;i<obj.size();i++){
			
			if(jQuery(o4this).val()==jQuery(obj[i]).attr("dbvalue"))
				jQuery(obj[i]).show();
			else
				jQuery(obj[i]).hide();
		}
	}
	
	/*保存 董事会*/
	function saveBoardDirectors() 
	{
		
		//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:void(0);");	//不让保存重复点击
		var trsize2dsh = jQuery("#webTable2dsh tr").length;
		var Alist2dsh = new Array();
		var strjsonArr="";
		
		
		jQuery('#webTable2dsh tr').each(function (i) { 
				var Blist2dsh = new Array();
				var sessions="";
				var officename="";
				var officebegindate="";
				var officeenddate="";
				var isstop="";
				var remark="";
				jQuery(this).children('td').each(function (j){
						if(j==1){
							sessions=jQuery(this).find("input").val();
						}else if(j==2){
							officename=jQuery(this).find("input").val();
						}else if(j==3){
							officebegindate=jQuery(this).find("input").val();
						}else if(j==4){
							officeenddate=jQuery(this).find("input").val();
						}else if(j==5){
							isstop=jQuery(this).find("select").val();
						}else if(j==6){
							remark=jQuery(this).find("input").val();
						}
				});
				Blist2dsh[0] = "";
				Blist2dsh[1] = sessions;
				Blist2dsh[2] = officename;
				Blist2dsh[3] = officebegindate;
				Blist2dsh[4] = officeenddate;
				Blist2dsh[5] = isstop;
				Blist2dsh[6] = remark;
				Alist2dsh[i] = Blist2dsh;
           	});
           	//组装json数组字符串
           	
			if(Alist2dsh.length>0){
			
			strjsonArr="{";
			for(var x=0;x<trsize2dsh;x++){
				strjsonArr+="'tr"+x+"':{";
				strjsonArr+="'sessions':'"+Alist2dsh[x][1]+"',";
				strjsonArr+="'officename':'"+Alist2dsh[x][2]+"',";
				strjsonArr+="'officebegindate':'"+Alist2dsh[x][3]+"',";
				strjsonArr+="'officeenddate':'"+Alist2dsh[x][4]+"',";
				strjsonArr+="'isstop':'"+Alist2dsh[x][5]+"',";
				strjsonArr+="'remark':'"+Alist2dsh[x][6]+"'";
				if(x==trsize2dsh-1)strjsonArr+="}";
				else strjsonArr+="},";
			}
			strjsonArr+="}";
		}
		
		
		
		var trsize2jsh = jQuery("#webTable2jsh tr").length;
		var Alist2jsh = new Array();
		var strjsonArr2js="";
		jQuery('#webTable2jsh tr').each(function (i) { 
			var Blist2jsh = new Array();
			var sessions="";
			var supername="";
			var superbegindate="";
			var superenddate="";
			var isstop="";
			var remark="";
				
			jQuery(this).children('td').each(function (j){
					if(j==1){
								sessions=jQuery(this).find("input").val();
					}else if(j==2){
						supername=jQuery(this).find("input").val();
					}else if(j==3){
						superbegindate=jQuery(this).find("input").val();
					}else if(j==4){
						superenddate=jQuery(this).find("input").val();
					}else if(j==5){
						isstop=jQuery(this).find("select").val();
					}else if(j==6){
						remark=jQuery(this).find("input").val();
					}
				
			});
				Blist2jsh[0] = "";
				Blist2jsh[1] = sessions;
				Blist2jsh[2] = supername;
				Blist2jsh[3] = superbegindate;
				Blist2jsh[4] = superenddate;
				Blist2jsh[5] = isstop;
				Blist2jsh[6] = remark;
				
               	Alist2jsh[i] = Blist2jsh;
           	});
           	//组装json数组字符串
			
			if(Alist2jsh.length>0){
			strjsonArr2js="{";
			for(var x=0;x<trsize2jsh;x++){
				strjsonArr2js+="'tr"+x+"':{";
				strjsonArr2js+="'sessions':'"+Alist2jsh[x][1]+"',";
				strjsonArr2js+="'supername':'"+Alist2jsh[x][2]+"',";
				strjsonArr2js+="'superbegindate':'"+Alist2jsh[x][3]+"',";
				strjsonArr2js+="'superenddate':'"+Alist2jsh[x][4]+"',";
				strjsonArr2js+="'isstop':'"+Alist2jsh[x][5]+"',";
				strjsonArr2js+="'remark':'"+Alist2jsh[x][6]+"'";
				if(x==trsize2jsh-1)strjsonArr2js+="}";
				else strjsonArr2js+="},";
			}
			strjsonArr2js+="}";
		}
		
		var o4params = {
			method:jQuery("#method_dsh").val(),
			isaddversion:jQuery("#isaddversion").val(),
			companyid:"<%=companyid%>",
			directorsid:jQuery("#directorsid").val(),
			chairman:encodeURI(jQuery("#chairman_dsh").val()),
			appointbegindate:encodeURI(jQuery("#appbegintime").val()),
			appointenddate:encodeURI(jQuery("#appendtime").val()),
			appointduetime:encodeURI(jQuery("#appointduetime_dsh").val()),
			supervisor:encodeURI(jQuery("#supervisor_dsh").val()),
			generalmanager:encodeURI(jQuery("#generalmanager_dsh").val()),
			ischairman:encodeURI(jQuery("#ischairman_dsh").val()),
			data:encodeURI(strjsonArr),
			data2js:encodeURI(strjsonArr2js),
			affixdoc:encodeURI(jQuery("#affixdoc").val()),
			
			versionnum:encodeURI(jQuery("#versionnum").val()),
			versionname:encodeURI(jQuery("#versionname").val()),
			versionmemo:encodeURI(jQuery("#versionmemo").val()),
			versionaffix:"",
			date2Version:encodeURI(jQuery("#versionTime").val()),
			managerbegindate:encodeURI(jQuery("#manbegintime").val()),
			managerenddate:encodeURI(jQuery("#manendtime").val()),
			managerduetime:encodeURI(jQuery("#managerduetime_dsh").val())
		}
	 	jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",o4params,function(data){
					if(jQuery.trim(data)!="0"){
							alert(data);
					}
					closeMaint4Win();
		}); 
	}
	function displayimg(obj){
		if(jQuery.trim(jQuery(obj).val())!=""){
			jQuery(obj).parent().find("img").css("display","none");
		}else{
			jQuery(obj).parent().find("img").css("display","");
		}
	}
	/*验证是否通过、通过后方保存*/
	function checkForm(typepage)
	{
		var ischecked = false;
		if(!jQuery.trim(jQuery("#chairman_dsh").val())=="" && !jQuery.trim(jQuery("#appbegintime").val())==""  && !jQuery.trim(jQuery("#appendtime").val())==""){
			ischecked = true;
		}
		jQuery("#webTable2dsh").find("img[align='absMiddle'][display!='none']").each(function (){
			if(!$(this).is(":hidden")){
				ischecked=false;
			}
		})
		jQuery("#webTable2jsh").find("img[align='absMiddle'][display!='none']").each(function (){
			if(!$(this).is(":hidden")){
				ischecked=false;
			}
		})
		return ischecked;
	}
	
	/* 关闭 已打开的面板 */
	function closeMaint4Win()
	{
		//jQuery("a[typepage='dsh']").qtip('hide');
		//jQuery("a[typepage='dsh']").qtip('destroy');
		parentDialog.close();
		//回调刷新界面数据
		parentWin.refsh();
	}
	
	//全部选择操作，复选框
	function selectall_chk(Tcheck){
	   if(Tcheck.checked==true){
	      $("input[type=checkbox][inWhichPage='dsh']").each(function(){
				 $(this).attr("checked",true);
				 $(this).next("span").attr("class","jNiceCheckbox jNiceChecked"); 
		  });
	   }else{
		  $("input[type=checkbox][inWhichPage='dsh']").each(function(){
				 $(this).attr("checked",false);
				 $(this).next("span").attr("class","jNiceCheckbox"); 
		  });
	   }
	}
	//全部选择操作，复选框
	function selectall_chk2js(Tcheck){
	   if(Tcheck.checked==true){
	      $("input[type=checkbox][inWhichPage='jsh']").each(function(){
				 $(this).attr("checked",true);
				  $(this).next("span").attr("class","jNiceCheckbox jNiceChecked"); 
		  });
	   }else{
		  $("input[type=checkbox][inWhichPage='jsh']").each(function(){
				 $(this).attr("checked",false);
				  $(this).next("span").attr("class","jNiceCheckbox"); 
		  });
	   }
	}
	 
	 
	//选中其中的一个
	function selectone_chk(){
	    jQuery("#fileid").attr("checked",false); 
	}
	//选中其中的一个
	function selectone_chk2js(){
	    jQuery("#fileid2js").attr("checked",false); 
	}
	/*增加一行tr*/
	function doadd_dsh(){
	
		var trhrml="<tr  class='DataLight'>";
		jQuery("#hiddenTrInDIV").find("span[_calss='show']").each(function(i){
						var temp=jQuery(this).html();
						if(i==0){
							trhrml+="<td>";
						}else if(i==1){
							trhrml+="<td>";
						}else if(i==2){
							trhrml+="<td>";
						}else if(i==3){
							trhrml+="<td>";
						}else if(i==4){
							trhrml+="<td>";
						}else if(i==5){
							trhrml+="<td>";
						}else if(i==6){
							trhrml+="<td>";
						}
						trhrml+=temp;
						trhrml+="</td>";
		})
		trhrml+="</tr>";
		
		jQuery("#webTable2dsh").append(trhrml);
		
		jQuery("#webTable2dsh").find("select[notBeauty]").removeAttr("notBeauty");
		beautySelect("select._needBeauty");
		
		jQuery("#webTable2dsh").find("tr").last().find("span.jNiceCheckbox").bind("click",function(){
					jQuery(this).toggleClass("jNiceChecked");
					var pe=jQuery(this).prev();
					if(pe&&pe.attr("checked")==true){
						pe.removeAttr("checked");
					}else{
						pe.attr("checked","true");
					}
				});
		
		jQuery("#webTable2dsh").find("tr").find("td").find("button[name='hidebegindate01']").each(function(){
				$(this).attr("name","");//给name赋值，防止下次循环又找到他
				$(this).click(function (){
						//gettheDate这个方法只接受普通对象，不能把jquery对象传进去
						onShowDate($(this).next().next()[0],$(this).next()[0]);
				})
		});
		jQuery("#webTable2dsh").find("tr").find("td").find("button[name='hideenddate01']").each(function(){
				$(this).attr("name","");//给name赋值，防止下次循环又找到他
				$(this).click(function (){
						//gettheDate这个方法只接受普通对象，不能把jquery对象传进去
						onShowDate($(this).next().next()[0],$(this).next()[0]);
				})
		});
		
		
	}
	/*增加一行tr*/
	function doadd_jsh(){
	
		var trhrml="<tr  class='DataLight'>";
		jQuery("#hiddenTrInDIV2js").find("span[_calss='show']").each(function(i){
						var temp=jQuery(this).html();
						if(i==0){
							trhrml+="<td>";
						}else if(i==1){
							trhrml+="<td>";
						}else if(i==2){
							trhrml+="<td>";
						}else if(i==3){
							trhrml+="<td>";
						}else if(i==4){
							trhrml+="<td>";
						}else if(i==5){
							trhrml+="<td>";
						}else if(i==6){
							trhrml+="<td>";
						}
						trhrml+=temp;
						trhrml+="</td>";
		})
		trhrml+="</tr>";
		
		jQuery("#webTable2jsh").append(trhrml);
		
		jQuery("#webTable2jsh").find("select[notBeauty]").removeAttr("notBeauty");
		beautySelect("select._needBeauty");
		
		jQuery("#webTable2jsh").find("tr").last().find("span.jNiceCheckbox").bind("click",function(){
					jQuery(this).toggleClass("jNiceChecked");
					var pe=jQuery(this).prev();
					if(pe&&pe.attr("checked")==true){
						pe.removeAttr("checked");
					}else{
						pe.attr("checked","true");
					}
				});
		
		jQuery("#webTable2jsh").find("tr").find("td").find("button[name='hidebegindate02']").each(function(){
				$(this).attr("name","");//给name赋值，防止下次循环又找到他
				$(this).click(function (){
						//gettheDate这个方法只接受普通对象，不能把jquery对象传进去
						onShowDate($(this).next().next()[0],$(this).next()[0]);
				})
		});
		jQuery("#webTable2jsh").find("tr").find("td").find("button[name='hideenddate02']").each(function(){
				$(this).attr("name","");//给name赋值，防止下次循环又找到他
				$(this).click(function (){
						//gettheDate这个方法只接受普通对象，不能把jquery对象传进去
						onShowDate($(this).next().next()[0],$(this).next()[0]);
				})
		});
	}
	/*删除一行或多行*/
	function dodel_dsh(){
	
		var _temp=0;
			jQuery('#webTable2dsh tr').each(function(){
			if(jQuery(this).children('td').find("input[name=checkboxdsh]").attr("checked")==true){
				_temp++;
			}
		});
		
		if(_temp<=0){
				alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>!");
		}else {
					var truth4Told = window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>?"); 
					if(truth4Told){
								jQuery('#webTable2dsh tr').each(function(){
							if(jQuery(this).children('td').find("input[name=checkboxdsh]").attr("checked")==true){
								jQuery(this).remove();
							}
						});
						jQuery("#fileid").next("span").attr("class","jNiceCheckbox"); 
						jQuery("#hiddenTrInDIV input[name=checkboxdsh]").next("span").attr("class","jNiceCheckbox");
					}else{
						
					}
		}
	}
	
	
	/*删除一行或多行*/
	function dodel_jsh(){
		var _temp=0;
			jQuery('#webTable2jsh tr').each(function(){
			if(jQuery(this).children('td').find("input[name=checkboxjsh]").attr("checked")==true){
				_temp++;
			}
		});
		if(_temp<=0){
				alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>!");
		}else {
					var truth4Told = window.confirm("<%=SystemEnv.getHtmlLabelName(30695,user.getLanguage()) %>?"); 
					if(truth4Told){
							jQuery('#webTable2jsh tr').each(function(){
							if(jQuery(this).children('td').find("input[name=checkboxjsh]").attr("checked")==true){
								jQuery(this).remove();
							}
						});
						jQuery("#fileid2js").next("span").attr("class","jNiceCheckbox"); 
						jQuery("#hiddenTrInDIV2js input[name=checkboxjsh]").next("span").attr("class","jNiceCheckbox");
					}else{
					
					}
		}
		
	}
	function opinionStartTimeEndTime( stratTime , endTime ){
	      var strat = stratTime.split( "-" );
	      var end = endTime.split( "-" );
	      var sdate=new Date(strat[0],strat[1],strat[2]);
	      var edate=new Date(end[0],end[1],end[2]);
	      if(sdate.getTime()>edate.getTime()){
	        return false;
	      }
	      return true;
    }
    
	function saveDate(){
	
		var begintime=jQuery.trim(jQuery("#appbegintime").val());
		var endtime=jQuery.trim(jQuery("#appendtime").val());
		if(""!=begintime&&""!=endtime){
			if(opinionStartTimeEndTime(begintime,endtime)==false){
					alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())  %>!");
					return;
			}
		}
		
		var begintime02=jQuery.trim(jQuery("#manbegintime").val());
		var endtime02=jQuery.trim(jQuery("#manendtime").val());
		if(""!=begintime02&&""!=endtime02){
			if(opinionStartTimeEndTime(begintime02,endtime02)==false){
					alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())  %>!");
					return;
			}
		}
		
		
		var check=0;
		jQuery('#webTable2dsh tr:eq(1)').each(function (i) { 
			 var $td = jQuery(this).children('td');
			 var atime=$td.eq(3).find("input[type=hidden]").val(); //第一个td的内容
			 var btime=$td.eq(4).find("input[type=hidden]").val();  //第一个td的内容
			 if(""!=atime&&""!=btime){
				 if(opinionStartTimeEndTime(atime,btime)==false){
					check++;
				 }
			}
		});
		if(check>0){
					alert("<%=SystemEnv.getHtmlLabelName(31189,user.getLanguage())%>!");
					return;
		}
		
		var check02=0;
		jQuery('#webTable2jsh tr:eq(1)').each(function (i) { 
			 var $td = jQuery(this).children('td');
			 var atime=$td.eq(3).find("input[type=hidden]").val(); //第一个td的内容
			 var btime=$td.eq(4).find("input[type=hidden]").val();  //第一个td的内容
			 if(""!=atime&&""!=btime){
					 if(opinionStartTimeEndTime(atime,btime)==false){
						check02++;
					  }
			  }
		});
		if(check02>0){
					alert("<%=SystemEnv.getHtmlLabelName(31190,user.getLanguage())%>!");
					return;
		}
		
				
				
		//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:void(0);");	//不让保存重复点击
		if(checkForm()){
			var truthBeTold = window.confirm("<%=SystemEnv.getHtmlLabelName(31009,user.getLanguage()) %>！"); 
			if (truthBeTold) { 
				onversionAddDivOpen();
			} else {
				var truth4Told = window.confirm("<%=SystemEnv.getHtmlLabelName(31010,user.getLanguage()) %>？"); 
				if(truth4Told){
					StartUploadAll();
					checkuploadcomplet();
				}else{
					//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
				}
			}
		}
		else
		{
			alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
		}
	} 
	
	
	/*打开版本管理页面*/
	function openVersionManage(){
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","130px").css("left","150px");
		jQuery("#wBoxContent").css("width","488px").css("height","260px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(19450,user.getLanguage()) %>");
		jQuery("#wBoxContent").load("/cpcompanyinfo/CompanyVersionManage.jsp?directorsid="+jQuery("#directorsid").val()+"&oneMoudel=director&showOrUpdate=<%=showOrUpdate%>");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
	}
	
	/*打开版本新增DIV*/
	function onversionAddDivOpen(){
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","130px").css("left","330px");
		jQuery("#wBoxContent").css("width","335px").css("height","225px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31011,user.getLanguage()) %>");
		jQuery("#wBoxContent").load("CompanyVersionMaint.jsp?directorsid="+jQuery("#directorsid").val()+"&oneMoudel=director&companyid=<%=companyid%>");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
	}
	
	/*关闭选择证照DIV*/
	function onLicenseDivClose() {
		jQuery("#wBox_overlay").removeClass("wBox_overlayBG").addClass("wBox_hide");
		jQuery("#licenseDiv").css("display","none");
		//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
	} 
	
	function onLicenseDivCloseNoSave(){
		jQuery("#wBox_overlay").removeClass("wBox_overlayBG").addClass("wBox_hide");
		jQuery("#licenseDiv").css("display","none");
	}
	
	/*版本方法 开始*/
	
	
	
	//董事会保存“董事会的所有信息”
	function saveversionDate(){
		jQuery("#isaddversion").val("add");
		StartUploadAll();
		checkuploadcomplet();
	}
	
	function editversionDate(versionid){
		o4params ={
		method:"editversion",
		versionid:versionid,
		versionnum:encodeURI(jQuery("#versionnum").val()),
		versionname:encodeURI(jQuery("#versionname").val()),
		versionmemo:encodeURI(jQuery("#versionmemo").val()),
		versionaffix:"",
		date2Version:encodeURI(jQuery("#versionTime").val())
		};
		jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",o4params,function(){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31012,user.getLanguage()) %>!");
			onLicenseDivClose();	
		});
	}
	
	
	/*删除一行或多行*/
	function dodel_gd(){
		var versionids="";
		var _versionnum="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
				_versionnum+= jQuery(this).attr("_versionnum")+",";
			}
		});
		if(versionids.length == 0){
			alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>！");
			return;
		}
		var truthBeTold = window.confirm("<%=SystemEnv.getHtmlLabelName(31013,user.getLanguage()) %>？"); 
		if (truthBeTold) { 
			jQuery('#webTable2version tr').each(function(){
				if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
				{
					jQuery(this).remove();
				}
			});


			var o4params={method:"delVersion",versionids:versionids,_versionnum:_versionnum}
			jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",o4params,function(){
				
			});
		}
	}
	
	function delImg(imgfileDiv,docid){
		var affix123doc = jQuery("#affixdoc").val().split(",");
		var tempdocid = "";
		for(i=0;i<affix123doc.length-1;i++){
			if(affix123doc[i]!=docid){
				tempdocid+=affix123doc[i]+",";
			}
		}
		jQuery("#affixdoc").val(tempdocid);
		jQuery(imgfileDiv).css("display","none");
		jQuery("#source").find("img").attr("src","images/nopic_wev8.jpg");
		jQuery("#_s2uiContent").css("display","none");
	}
	
	function viewVersion(){
		var versionids="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
			}
		});
		if(versionids.length == 0){
				alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage()) %>！");
		}else  if(versionids.split(",").length>2){
			alert("<%=SystemEnv.getHtmlLabelName(31014,user.getLanguage()) %>！");
		}else{
			jQuery("#saveBoardDirectorsBtn").css("display","none");
			jQuery("#selectdate1").hide();
			jQuery("#selectdate2").hide();
			var o4params = {method:"viewVersion",versionids:versionids}
			jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",o4params,function(data){
				jQuery("#directorsid").val(data[0]["directorsid"]);
				jQuery("#chairman_dsh").val(data[0]["chairman"]);
				jQuery("#appointbegindate_dsh").html(data[0]["appointbegindate"]);
				jQuery("#appbegintime").val(data[0]["appointbegindate"]);
				jQuery("#appointenddate_dsh").html(data[0]["appointenddate"]);
				jQuery("#appendtime").val(data[0]["appointbegindate"]);
				
				jQuery("#appointduetime_dsh").val(data[0]["appointduetime"]);
				jQuery("#supervisor_dsh").val(data[0]["supervisor"]);
				jQuery("#generalmanager_dsh").val(data[0]["generalmanager"]);
				jQuery("#ischairman_dsh").val(data[0]["ischairman"]);
				
				jQuery("#managerbegindate_dsh").html(data[0]["managerbegindate"]);
				jQuery("#manbegintime").val(data[0]["managerbegindate"]);
				jQuery("#managerenddate_dsh").html(data[0]["managerenddate"]);
				jQuery("#manendtime").val(data[0]["managerbegindate"]);
				
				
				jQuery("#newDscyBtn").css("display","none");
				jQuery("#delDscyBtn").css("display","none");
				jQuery("#newDscy2jsBtn").css("display","none");
				jQuery("#delDscy2jsBtn").css("display","none");
				jQuery("#webTable2dsh").html("");
				//jQuery("#saveBoardDirectorsBtn").attr("href","javascript:nosaveAgain();");	//恢复保存按钮
				jQuery("#spanTitle_dsh").html("<%=SystemEnv.getHtmlLabelName(31015,user.getLanguage()) %>["+data[1]+"]");
				jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",{method:"viewOffersVersion",versionnum:data[1],directorsid:data[0]["directorsid"]},function(data1){
					var htmlheaderds = "<colgroup><col width='20%'><col width='10%'><col width='10%'><col width='12%'>"+
					"<col width='16%'><col width='20%'></colgroup><tr class='header'><th><%=SystemEnv.getHtmlLabelNames("30999",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("31000",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("740",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("22326",user.getLanguage())%></th>"+
					"<th><%=SystemEnv.getHtmlLabelNames("31001",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("454",user.getLanguage())%></th></tr>"
					jQuery("#webTable2dsh").html(htmlheaderds+jQuery.trim(data1));
				});
				jQuery.post("/cpcompanyinfo/action/CPBoardDirectorsOperate.jsp",{method:"viewSupersVersion",versionnum:data[1],directorsid:data[0]["directorsid"]},function(data2){
					var htmlheaderjs = "<colgroup><col width='20%'><col width='10%'><col width='10%'><col width='12%'>"+
					"<col width='16%'><col width='20%'></colgroup><tr class='header'><th><%=SystemEnv.getHtmlLabelNames("30999",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("31003",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("740",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("22326",user.getLanguage())%></th>"+
					"<th><%=SystemEnv.getHtmlLabelNames("31001",user.getLanguage())%></th><th><%=SystemEnv.getHtmlLabelNames("454",user.getLanguage())%></th></tr>"
					jQuery("#webTable2jsh").html(htmlheaderjs+jQuery.trim(data2));
				});
				
				var imgid4db = data[0]["imgid"].split("|");
				var imgname4db = data[0]["imgname"].split("|");
				if(jQuery("#affixcpdosDIV").find("div").length/3>0){
					jQuery("#affixcpdosDIV").html("");
				}
				var html4doc="";
				for(i=0;i<imgid4db.length - 1;i++){
					html4doc += "<div id='imgfileDiv"+i+"' style='background-color: #F7F7F7;width:291px;height:20px;padding-left:4px;border: solid 1px #E8E8E8;padding: 4px;margin-bottom: 5px;'>";
					html4doc+="<div style='width:80%;float:left;' >";
					html4doc+="<A id='pdflinkid"+i+"' href='/weaver/weaver.file.FileDownload?fileid="+imgid4db[i]+"&download=1' class='aContent0 FL'>"+imgname4db[i]+"</A>";
					html4doc+="</div>";
					html4doc+="<div style='padding-right:0px;float:right;padding-top:0px'>";
					html4doc+="<a href='/weaver/weaver.file.FileDownload?fileid="+imgid4db[i]+"&download=1'><img src='images/downLoadPic_wev8.gif'  title='<%=SystemEnv.getHtmlLabelName(22629,user.getLanguage()) %>'  ></a>";
					html4doc+="</div>";
					html4doc+="</div>";
				}
				jQuery("#affixcpdosDIV").html(html4doc);
				
				jQuery(".Clock").hide();
				jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
				jQuery("select").attr("disabled","disabled");  
				jQuery("#save_H").hide();
				jQuery("#webTable2dsh").attr("disabled","disabled");  
				jQuery("#webTable2jsh").attr("disabled","disabled");  
				jQuery("#licenseAffixUpload").hide();
				
				onLicenseDivCloseNoSave();
			},"json");
		}
	}
	
	function nosaveAgain(){
		alert("<%=SystemEnv.getHtmlLabelName(31016,user.getLanguage()) %>！")
	}
	
	function getVersion(){
		var versionids="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
			}
		});
		if(versionids.split(",").length>2 || versionids.length == 0){
			alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage()) %>！");
		}else{
			//licenseid='' and companyid=''
			jQuery("#wBoxContent").html("");
			jQuery("#wBox").css("top","130px").css("left","330px");
			jQuery("#wBoxContent").css("width","335px").css("height","225px");
			jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31018,user.getLanguage()) %>");
			jQuery("#wBoxContent").load("CompanyVersionMaint.jsp?versionids="+versionids+"&oneMoudel=director&companyid=<%=companyid%>");
			jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
			jQuery("#licenseDiv").css("display","");
			
		}
	}
	
	/*版本方法 结束*/
	var tempnumFilesUploaded = 0;
	/*flash上传需要的方法*/
	function StartUploadAll() {  
        eval("SWFUpload.instances.SWFUpload_0.startUpload()");
        // files_queued当前上传队列中存在的文件数量        
        tempnumFilesUploaded = eval("upfilesnum+=SWFUpload.instances.SWFUpload_0.getStats().files_queued"); 
	}
	function checkuploadcomplet(){	
	    if(upfilesnum>0){    	
	        setTimeout("checkuploadcomplet()",1000);       	
	    }else{
	       saveBoardDirectors();
	    }
	}
	function flashChecker() {
		var hasFlash = 0; //是否安装了flash
		var flashVersion = 0; //flash版本
		var isIE = /*@cc_on!@*/0; //是否IE浏览器
		if (isIE) {
			var swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
			if (swf) {
				hasFlash = 1;
				VSwf = swf.GetVariable("$version");
				flashVersion = parseInt(VSwf.split(" ")[1].split(",")[0]);
			}
		} else {
			if (navigator.plugins && navigator.plugins.length > 0) {
				var swf = navigator.plugins["Shockwave Flash"];
				if (swf) {
					hasFlash = 1;
					var words = swf.description.split(" ");
					for ( var i = 0; i < words.length; ++i) {
						if (isNaN(parseInt(words[i])))
							continue;
						flashVersion = parseInt(words[i]);
					}
				}
			}
		}
		return {
			f :hasFlash,
			v :flashVersion
		};
	}
	/*上传空间判断是否安装了flash控件*/
	var fls = flashChecker();
	var flashversion = 0;
	if (fls.f)
		flashversion = fls.v;
	if (flashversion < 9)
		document.getElementById("fsUploadProgress").innerHTML = "<br>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("31512",user.getLanguage())%>:<br><br><a target='_blank' href='http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=shockwaveFlash'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("31510",user.getLanguage())%><a>	<br><br><a href='/resource/install_flash9_player.exe' target='_blank'>&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("31511",user.getLanguage())%></a>";	
	
</script>

<script language="javascript">

var upfilesnum=0;//计数器
var oUploader;//一个SWFUpload 实例
var mode="add";//当期模式

var settings = {   
	
	flash_url : "/js/swfupload/swfupload.swf",     
	upload_url: "/cpcompanyinfo/action/uploaderOperate.jsp",
	post_params: {
                "mainId": <%=mainId%>,
                "subId":<%=subId%>,
                "secId":<%=secId%>
            },
	file_size_limit :"100MB",							//单个文件大小
	file_types : "*.*", 	//过滤文件类型
	file_types_description : "All Files",					//描述，会添加在类型前面
	file_upload_limit : "50",							//一次性上传几个文件
	file_queue_limit : "0",								
	//customSettings属性是一个空的JavaScript对象，它被用来存储跟SWFUpload实例相关联的数据。
	//它的内容可以使用设置对象中的custom_settings属性来初始化
	custom_settings : {
		progressTarget : "fsUploadProgress",
		cancelButtonId : "btnCancel_upload"
	},
	debug: false,
	
	button_image_url : "/js/swfupload/add_wev8.png",	// Relative to the SWF file
	button_placeholder_id : "spanButtonPlaceHolder",
	
	button_width: 100,//“上传"按钮的宽度
	button_height: <%if(!CompanyInfoTransMethod.CheckPack("4")){out.println("0");}else{out.println("18");}%>,//“上传”按钮的高度
	button_text : '<span class="button">'+"<%=SystemEnv.getHtmlLabelName(75,user.getLanguage())%>"+'</span>',//“上传”按钮的文字
	button_text_style : '.button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt; } .buttonSmall { font-size: 10pt; }',
	button_text_top_padding: 0,//“上传"按钮的top_padding
	button_text_left_padding: 18,//“上传"按钮的left_padding
		
	button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
	button_cursor: SWFUpload.CURSOR.HAND,//“上传"按钮的鼠标悬浮样式
	
	file_queued_handler : fileQueued,
	file_queue_error_handler : fileQueueError,
	
	file_dialog_complete_handler : function(){	//设置事件回调函数,file_dialog_complete_handler为类对象的属性		
		//让按钮失效
		//document.getElementById("btnCancel_upload").disabled = true;
		//alert("按钮细小");
		//fileDialogComplete				
	},
	//设置事件回调函数,upload_start_handler为类对象的属性,在文件往服务端上传之前触发此事件，可以在这里完成上传前的最后验证以及其他你需要的操作，例如添加、修改、删除post数据等。
	//在完成最后的操作以后，如果函数返回false，那么这个上传不会被启动，并且触发uploadError事件（code为ERROR_CODE_FILE_VALIDATION_FAILED），
	//如果返回true或者无返回，那么将正式启动上传
	upload_start_handler : uploadStart,	
	upload_progress_handler : uploadProgress,//设置事件回调函数,upload_progress_handler为类对象的属性
	upload_error_handler : uploadError,//设置事件回调函数,upload_error_handler为类对象的属性
	queue_complete_handler : queueComplete,//设置事件回调函数,queue_complete_handler为类对象的属性

	//文件上传成功，调用下面的方法
	upload_success_handler : function (file, server_data) {	//设置事件回调函数,upload_success_handler为类对象的属性
		if(mode=="add"){
			var imageid=server_data.replace(/(^\s*)|(\s*$)/g, "");			
			//得到文档id,得到文件的名字	
			document.getElementById("affixdoc").value+=imageid+",";
		}

	},	
	//文件上传成功，调用下面的方法			
	upload_complete_handler : function(){	
		upfilesnum=upfilesnum-1;//计数器减减
	}
	
};	
function queueComplete(numFilesUploaded) {
	var status = document.getElementById("divStatus");
	status.innerHTML = tempnumFilesUploaded + " file" + (tempnumFilesUploaded === 1 ? "" : "s") + " uploaded.";
}
try{
	oUploader = new SWFUpload(settings);//返回:一个SWFUpload 实例
	
} catch(e){alert(e)}
</script>

<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentDialog.closeByHand();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</HTML>
