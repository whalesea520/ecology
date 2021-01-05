<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@page import="weaver.cpcompanyinfo.ProTransMethod"%>
<%@page import="weaver.cpcompanyinfo.CompanyInfoTransMethod"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs02" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cu" class="weaver.company.CompanyUtil" scope="page" />
<%@page import="weaver.docs.docs.DocComInfo"%>
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
	parentWin = parent.getParentWindow(window);
	parentDialog = parent.parent.getDialog(parent);
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
</HEAD>

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
	
	String o4sql = " select * from mytrainaccessoriestype where accessoriesname='lmconstitution'";
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
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("30941",user.getLanguage())%>'/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="weaver" name="weaver">
<!--表头浮动层 start-->
<input type="hidden" id="constitutionid_zc"/>
<input type="hidden" id="method_zc"/>
<input type="hidden" id="isaddversion"/>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; ">
		<%
		if(maintFlag){
			%>
			<a id="bcVersions">
			<input type="button" id="saveConstitutionBtn" value="<%=SystemEnv.getHtmlLabelNames("31005",user.getLanguage())%>" class="e8_btn_top" onclick="saveDate()"/>
			</a>
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
		<wea:item><%=SystemEnv.getHtmlLabelName(1976,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="companyname_inzc" id="companyname_inzc" onfocus= "this.blur();"
						class="OInput3" style="width:339px;background-color:#F8F8F8;"  />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31133,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="registeraddress_inzc" id="registeraddress_inzc" onfocus= "this.blur();"
						class="OInput3" style="width:339px;background-color:#F8F8F8;" />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20668,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="registercapital_inzc" id="registercapital_inzc" onfocus= "this.blur();"
						class="OInput3 BoxW120" style="background-color:#F8F8F8;"/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31032,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="paiclupcapital_inzc" id="paiclupcapital_inzc" onfocus= "this.blur();"
						class="OInput3 BoxW120" style="background-color:#F8F8F8;"/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31038,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="aggregateinvest_zc" id="aggregateinvest_zc"
						class="OInput2 BoxW120"  onblur="displayimgNext(this)"/>
				<span>
						<img src="images/O_44_wev8.jpg"   absMiddle="absMiddle"  iswarn='warning'   id="aggregateinvest_zcimg"/>
				</span>
		</wea:item>
<%
String[] DefaultCurrency=new String[]{"",""};
boolean currencyCanEdit=true;
if(ProTransMethod.getDefaultCurrency()!=null&&ProTransMethod.getDefaultCurrency().indexOf(",")!=-1){
	DefaultCurrency=ProTransMethod.getDefaultCurrency().split(",");
}
%>		
		<wea:item><%=SystemEnv.getHtmlLabelName(406,user.getLanguage()) %></wea:item>
		<wea:item>
			<brow:browser viewType="0" name="currencyid_zc" browserValue='<%=DefaultCurrency[0]%>' browserSpanValue='<%=Util.null2String(DefaultCurrency[1])%>' 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp"
				hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='<%=maintFlag?"2":"0" %>'
				completeUrl="/data.jsp?type=12"  />
		</wea:item>
<%
				String boardshareholder = "";
				String gdhsql = " select boardshareholder from CPSHAREHOLDER where companyid= " + companyid;
				rs.execute(gdhsql);
				if(rs.next()){
					boardshareholder = Util.null2String(rs.getString("boardshareholder"));
				}
				
			 %>		
		<wea:item><%=SystemEnv.getHtmlLabelName(30944,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="boardshareholder" id="boardshareholder" value="<%=boardshareholder%>" onfocus= "this.blur();"
						class="OInput3" style="width:339px;background-color:#F8F8F8;" />
		</wea:item>
		<wea:item>
			<select id="isvisitors_zc" class="OSelect" <%=maintFlag?"":"disabled" %>>
					<option value="1">
						<%=SystemEnv.getHtmlLabelName(30936,user.getLanguage())%>
					</option>
					<option value="2">
						<%=SystemEnv.getHtmlLabelName(30997,user.getLanguage())%>
					</option>
				</select>
		</wea:item>
		<wea:item>
			<input type="text" name="theboard_zc" id="theboard_zc" onblur="displayimg(this)"
						class="OInput2" style="width:320px" /><img src="images/O_44_wev8.jpg" class="ML5" iswarn='warning' />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON  class="Clock"  type="button"    onclick="onShowDate(document.getElementById('stitubegindate_zc'),stitubegintime)"></BUTTON>
					<input type="hidden" id="stitubegintime" name="stitubegintime"/>
					<span id="stitubegindate_zc">
					<img src="images/O_44_wev8.jpg"   absMiddle="absMiddle"  iswarn='warning'/>
					</span>
					 - 
					<BUTTON class="Clock"  type="button"    onclick="onShowDate(document.getElementById('stituenddate_zc'),stituendtime)"></BUTTON>
					<input type="hidden" id="stituendtime"    name="stituendtime" />
					<span id="stituenddate_zc">
					<img src="images/O_44_wev8.jpg"  absMiddle="absMiddle"  iswarn='warning'/>
					</span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31041,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="boardvisitors_zc" id="boardvisitors_zc"
						class="OInput2" style="width:320px" onblur="displayimg(this)"/>
						<img src="images/O_44_wev8.jpg"  absMiddle="absMiddle" iswarn='warning' />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17697,user.getLanguage())%></wea:item>
		<wea:item>
			<!-- 起止时间 -->
					<BUTTON type="button" class=Clock  onclick="onShowDate(document.getElementById('visitbegindate_zc'),document.getElementById('visitbegintime'))"></BUTTON>
					<input type="hidden" name="visitbegintime"   id="visitbegintime" >
					<SPAN id="visitbegindate_zc">	
						<img src="images/O_44_wev8.jpg"   class="ML5"  iswarn='warning'  />
					</SPAN>
					 - 
					 <BUTTON type="button" class=Clock  onclick="onShowDate(document.getElementById('visitenddate_zc'),document.getElementById('visitendtime'))"></BUTTON>
					<input type="hidden" name="visitendtime"   id="visitendtime" >
					<SPAN id="visitenddate_zc">	
						<img src="images/O_44_wev8.jpg"   class="ML5"  iswarn='warning' />
					</SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31042,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="appointduetime_zc" id="appointduetime_zc"
						class="OInput2 BoxW60 " style="width:50px!important;" onblur="displayimg(this)" onkeyup="this.value=this.value.replace(/\D/g,'')" onafterpaste="this.value=this.value.replace(/\D/g,'')"  onpaste="javascript: return false;" /><img src="images/O_44_wev8.jpg" class="ML5" iswarn='warning' />
						<%=SystemEnv.getHtmlLabelName(26577,user.getLanguage())%>
						<input name="isreappoint_zc" id="isreappoint_zc" type="checkbox" class="MLeft8"/> <span><%=SystemEnv.getHtmlLabelName(31043,user.getLanguage())%></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(20696,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="text" name="generalmanager_zc" id="generalmanager_zc"  class="OInput2 "  style="width: 80px" onblur="displayimgNext(this)"/>
					<span >
								<img src="images/O_44_wev8.jpg"  iswarn='warning'   id="_genzc"/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(19548,user.getLanguage())%></wea:item>
		<wea:item>
			<BUTTON type="button" class=Clock  onclick="onShowDate(document.getElementById('effectbegindate_zc'),document.getElementById('effbegintime'))"></BUTTON>
						<input type="hidden" name="effbegintime"   id="effbegintime" >
						<SPAN id="effectbegindate_zc">	
						<img src="images/O_44_wev8.jpg"   class="ML5" />
					</SPAN>
						 - 
						 <BUTTON type="button" class=Clock  onclick="onShowDate(document.getElementById('effectenddate_zc'),document.getElementById('effendtime'))"></BUTTON>
						<input type="hidden" name="effendtime"   id="effendtime" >
							<SPAN id="effectenddate_zc">	
							<img src="images/O_44_wev8.jpg"   class="ML5" />
						</SPAN>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></wea:item>
		<wea:item>
			<%if(!CompanyInfoTransMethod.CheckPack("2")){out.println("<span style='color:red'>"+SystemEnv.getHtmlLabelName(31004,user.getLanguage())+"！</span>");}%>
					<div id="licenseAffixUpload"  >
					<input type="hidden" name="affixdoc" id="affixdoc">
						<span> 
							<span id='spanButtonPlaceHolder'></span><!--选取多个文件-->
						</span>
						&nbsp;&nbsp;
						<span style="color: #262626; cursor: hand; TEXT-DECORATION: none;<%if(!CompanyInfoTransMethod.CheckPack("2")){out.println("display: none;");}%>"
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
						
						<span  id="_fximg">
								<img src='/images/BacoError_wev8.gif' align=absMiddle  >
						 </span>
						 
					</div>
						<div id="affixcpdosDIV">
						<%
							int userid = user.getUID();
							String affixdoc = "";
							String affixsql = " select constituaffix from CPCONSTITUTION where companyid = " + companyid;
							rs.execute(affixsql);
							if(rs.next()){
								affixdoc = Util.null2String(rs.getString("constituaffix"));
							}
							String isdoc="";
							if(!"".equals(affixdoc))
							{
								
								DocComInfo dc=new DocComInfo();						
								String []slaves=affixdoc.split(",");
								for(int i=0;i<slaves.length;i++)
								{
									String tempid="asid"+slaves[i];
								
									out.println("<div id='imgfileDiv"+i+"' style='background-color: #F7F7F7;width:291px;height:20px;padding-left:4px;border: solid 1px #E8E8E8;padding: 4px;margin-bottom: 5px;'  class='progressWrapper'>");
								
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
									
									/* if(dc.getDocCreaterid(slaves[i]).equals(userid+""))//当前用户是文档的创建者
									{		
										//输出删除文档超链接												
										isdoc = "affixdoc"; */
										
									//}else
									//{
										//输出下载文档超链接									
										out.println("<a href='/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1'><img src='images/downLoadPic_wev8.gif'  title='"+SystemEnv.getHtmlLabelName(22629,user.getLanguage())+"'  ></a>");
										if(!"0".equals(showOrUpdate)){
											out.println("<a><img src='images/delwk_wev8.gif' onclick=delImg(imgfileDiv"+i+","+slaves[i]+") title='"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"'></a>");
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
	<wea:group context='<%=SystemEnv.getHtmlLabelName(31039,user.getLanguage())%>'>	
		<wea:item attributes="{'isTableList':'true'}">
			<table  border="0" cellpadding="0" cellspacing="1" id="gdtable"
				class="ListStyle">
				<colgroup>
					<col width="50%">
					<col width="30%">
					<col width="20%">
				</colgroup>
				<tr id="OTable2" class="header">
					<td  align="center">
						<%=SystemEnv.getHtmlLabelName(27336,user.getLanguage())%>
					</td>
					<td align="center">
						<%=SystemEnv.getHtmlLabelName(31040,user.getLanguage())%>
					</td>
					<td align="center">
						<%=SystemEnv.getHtmlLabelName(31108,user.getLanguage())%>
					</td>
				</tr>
				<%
					String sql = "select t2.* from CPSHAREHOLDER t1,CPSHAREOFFICERS t2 where t1.shareid = t2.shareid and t1.companyid = " + companyid;
					rs.execute(sql);
					while (rs.next()){
					String valuedate = "";
					if(!Util.null2String(rs.getString("aggregatedate")).equals(""))
					valuedate = rs.getString("aggregatedate").substring(0,4);
				 %>
				<tr class="DataLight" dbvalue="<%=valuedate%>">
					<td  align="center">
						<%=Util.null2String(rs.getString("officername")) %>
					</td>
					<td  align="center">
						<%=Util.null2String(rs.getString("aggregateinvest")) %>
					</td>
					<td  align="center">
						<%=Util.null2String(rs.getString("aggregatedate")) %>
					</td>
				</tr>
				<%
				}
				 %>
			</table>
		</wea:item>
	</wea:group>
</wea:layout>
<div style="height:100px"></div>


<!-- 证照弹出层 -->

<div style="clear:both;display:none" id="licenseDiv">
	<div id="wBox" style="top:80px;left:25%;"><!-- 定义层在什么位置上 -->
		<div class="wBox_popup">
    		<table>
    			<tbody>
    				<tr><td class="wBox_tl"/><td class="wBox_b"/><td class="wBox_tr"/></tr>
    				<tr><td class="wBox_b"></td>
    					<td>
		   					<div class="wBox_body">
		       					<table class="wBox_title">
		       						<tr>
		          						<td class="wBox_dragTitle"><div class="wBox_itemTitle"><%=SystemEnv.getHtmlLabelName(31006,user.getLanguage()) %></div></td>
		          						<td width="20px" title="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" onclick="javascript:onLicenseDivClose();"><div class="wBox_close"></div></td>
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

</form>






<script type="text/javascript">
	jQuery(document).ready(function(){
	
		/* jQuery("#stituenddate_zc").bind("propertychange", function() { 
				displayimg(this);
		}); 
		
		 $("#testa").bind("input", function(e) {
		 		//displayimg(this);
		 });    
		*/
		
		var o4params = {
			method:"get",
			companyid:"<%=companyid%>"
		}
		jQuery.post("/cpcompanyinfo/action/CPConstitutionOperate.jsp",o4params,function(data){
			var zc_add = data[0];
			jQuery("#method_zc").val(zc_add);
			if(zc_add=="add"){
				jQuery("#spanTitle_zc").html("<%=SystemEnv.getHtmlLabelName(31044,user.getLanguage()) %>");
				<%if("0".equals(showOrUpdate)){%>jQuery("#spanTitle_zc").html("<%=SystemEnv.getHtmlLabelName(31146,user.getLanguage()) %>");<%}%>
				jQuery(":text[id$='_zc']").val("");		//清空文本框文
				jQuery(".OSelect").val("1");	//选择框复原
			}else{
				
				jQuery("#spanTitle_zc").html("<%=SystemEnv.getHtmlLabelName(31045,user.getLanguage()) %>");
				<%if("0".equals(showOrUpdate)){%>jQuery("#spanTitle_zc").html("<%=SystemEnv.getHtmlLabelName(31146,user.getLanguage()) %>");<%}%>
				var class_cpConstitution = data[1];
				jQuery("#constitutionid_zc").val(class_cpConstitution["constitutionid"]);
				jQuery("#aggregateinvest_zc").val(class_cpConstitution["aggregateinvest"]);
				jQuery("#currencyid_zc").val(class_cpConstitution["currencyid"]);
				jQuery("#currencyid_zcspan").html(class_cpConstitution["currencyname"]);
				
				
				jQuery("#isvisitors_zc").val(class_cpConstitution["isvisitors"]);
				jQuery("#boardvisitors_zc").val(class_cpConstitution["boardvisitors"]);
				
				jQuery("#visitbegindate_zc").html(class_cpConstitution["visitbegindate"]);
				jQuery("#visitbegintime").val(class_cpConstitution["visitbegindate"]);
				
				
				jQuery("#visitenddate_zc").html(class_cpConstitution["visitenddate"]);
				jQuery("#visitendtime").val(class_cpConstitution["visitenddate"]);
				
				
				jQuery("#theboard_zc").val(class_cpConstitution["theboard"]);
				
				jQuery("#stitubegindate_zc").html(class_cpConstitution["stitubegindate"]);
				jQuery("#stituenddate_zc").html(class_cpConstitution["stituenddate"]);
				jQuery("#stitubegintime").val(class_cpConstitution["stitubegindate"]);
				jQuery("#stituendtime").val(class_cpConstitution["stituenddate"]);
				
				
				jQuery("#appointduetime_zc").val(class_cpConstitution["appointduetime"]);
				if(class_cpConstitution["isreappoint"]=="T")
				jQuery("#isreappoint_zc").attr("checked",true);
				else jQuery("#isreappoint_zc").attr("checked",false);
				jQuery("#generalmanager_zc").val(class_cpConstitution["generalmanager"]);
				jQuery("#effectbegindate_zc").html(class_cpConstitution["effectbegindate"]);
				jQuery("#effbegintime").val(class_cpConstitution["effectbegindate"]);
				
				
				jQuery("#effectenddate_zc").html(class_cpConstitution["effectenddate"]);
				jQuery("#effendtime").val(class_cpConstitution["effectenddate"]);
				
				
				jQuery("#affixdoc").val(class_cpConstitution["constituaffix"]);
				
				displayimg(jQuery("#theboard_zc"));
				displayimg(jQuery("#boardvisitors_zc"));
				displayimg(jQuery("#appointduetime_zc"));
				jQuery("img[iswarn='warning']").hide();
			}
			
		},"json");
		
		/*灰色、默认初始化值*/
		jQuery("#companyname_inzc").val("<%=companyname%>");
		jQuery("#registeraddress_inzc").val("<%=registeraddress%>");
		jQuery("#registercapital_inzc").val("<%=registercapital%>");
		jQuery("#paiclupcapital_inzc").val("<%=paiclupcapital%>");
		
		//保存按钮指向保存方法
		jQuery("#saveConstitutionBtn").attr("href","javascript:saveDate();");
		
		
		
		
		var now = new Date();
		var currentYear = now.getFullYear();
		var selectdateoptions = '';
		for(xx=0;xx<=currentYear-1990;xx++){
			selectdateoptions+= "<option value='"+(currentYear-xx)+"'>"+(currentYear-xx)+"</option>";
		}
		jQuery("#selectdate01").html(selectdateoptions);
		
			
		<%
		
			if("0".equals(showOrUpdate)){
		%>
			jQuery(".Clock").hide();
			jQuery(".Browser").hide();
			jQuery("#save_H").hide();
			jQuery("#isreappoint_zc").attr("disabled","disabled");  
			jQuery("#licenseAffixUpload").hide();
			jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
			jQuery("select").attr("disabled","disabled");  
		
		//	jQuery("#spanTitle_zc").html("查看章程");
		<%
			}
		%>
	});
	
	function searchzhzhdate(o4this){
		var obj = jQuery("#gdtable").find("tr");
		for(i=0;i<obj.size();i++){
			
			if(jQuery(o4this).val()==jQuery(obj[i]).attr("dbvalue"))
				jQuery(obj[i]).show();
			else
				jQuery(obj[i]).hide();
		}
	}
	
	function displayimg(obj){
		if(jQuery.trim(jQuery(obj).val())!=""){
			jQuery(obj).parent().find("img").css("display","none");
		}else{
			jQuery(obj).parent().find("img").css("display","");
		}
	}
	
	function displayimgNext(obj){
		if(jQuery.trim(jQuery(obj).val())!=""){
			jQuery(obj).next().find("img").css("display","none");
		}else{
			jQuery(obj).next().find("img").css("display","");
		}
	}
	
	/*保存 章程*/
	function saveConstitution() 
	{
		jQuery("#saveConstitutionBtn").attr("href","javascript:void(0);");	//不让保存重复点击
		if(checkForm("zc")){
			var isaachecked = "";
			if(jQuery("#isreappoint_zc").attr("checked"))isaachecked='T';
			else isaachecked = 'F';
			var o4params = {
				method:jQuery("#method_zc").val(),
				isaddversion:jQuery("#isaddversion").val(),
				companyid:"<%=companyid%>",
				constitutionid:encodeURI(jQuery("#constitutionid_zc").val()),
				aggregateinvest:encodeURI(jQuery("#aggregateinvest_zc").val()),
				currencyid:encodeURI(jQuery("#currencyid_zc").val()),
				isvisitors:encodeURI(jQuery("#isvisitors_zc").val()),
				theboard:encodeURI(jQuery("#theboard_zc").val()),
				stitubegindate:encodeURI(jQuery("#stitubegintime").val()),
				stituenddate:encodeURI(jQuery("#stituendtime").val()),
				boardvisitors:encodeURI(jQuery("#boardvisitors_zc").val()),
				visitbegindate:encodeURI(jQuery("#visitbegintime").val()),
				visitenddate:encodeURI(jQuery("#visitendtime").val()),
				appointduetime:encodeURI(jQuery("#appointduetime_zc").val()),
				isreappoint:encodeURI(isaachecked),
				generalmanager:encodeURI(jQuery("#generalmanager_zc").val()),
				effectbegindate:encodeURI(jQuery("#effbegintime").val()),
				effectenddate:encodeURI(jQuery("#effendtime").val()),
				affixdoc:encodeURI(jQuery("#affixdoc").val()),
				
				versionnum:encodeURI(jQuery("#versionnum").val()),
				versionname:encodeURI(jQuery("#versionname").val()),
				versionmemo:encodeURI(jQuery("#versionmemo").val()),
				versionaffix:"",
				date2Version:encodeURI(jQuery("#versionTime").val())
			};
			
			jQuery.post("/cpcompanyinfo/action/CPConstitutionOperate.jsp",o4params,function(data){
				if(jQuery.trim(data)!="0"){
							window.top.Dialog.alert(data);
				}else{
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83551",user.getLanguage())%>");
				}
				closeMaint4Win();
			});
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
		}
	}
	
	/*验证是否通过、通过后方保存*/
	function checkForm(typepage)
	{
		var ischecked = false;
		if(!jQuery.trim(jQuery("#theboard_zc").val())=="" && !jQuery.trim(jQuery("#boardvisitors_zc").val())=="" && !jQuery.trim(jQuery("#appointduetime_zc").val())=="" && !jQuery.trim(jQuery("#stitubegintime").val())=="" && !jQuery.trim(jQuery("#stituendtime").val())=="" ){
			ischecked = true;
		}
		if(!jQuery("#_fximg").is(":hidden")){
				ischecked=false;
		}
		if(jQuery("#visitbegintime").val()==""||jQuery("#visitendtime").val()==""||jQuery("#effbegintime").val()==""||jQuery("#effendtime").val()==""){
				ischecked=false;
				
		}
		
		
		if(!jQuery("#_genzc").is(":hidden")){
				ischecked=false;
		}		
		if(jQuery("#aggregateinvest_zcimg").css("display")!="none"){
				ischecked=false;
		}
		if(jQuery("#currencyid_zc").val()==""){
				ischecked=false;
		}
	
		
	
		
		return ischecked;
	}
	
	/* 关闭 已打开的面板 */
	function closeMaint4Win()
	{
		//jQuery("a[typepage='zc']").qtip('hide');
		//jQuery("a[typepage='zc']").qtip('destroy');
		parentDialog.close();
		//回调刷新界面数据
		parentWin.refsh();
	}
	
	
	//章程的版本编辑方法
	function editversionDate(versionid,oneMoudel){
			o4params ={
			method:"editversion",
			versionid:versionid,
			versionnum:encodeURI(jQuery("#versionnum").val()),
			versionname:encodeURI(jQuery("#versionname").val()),
			versionmemo:encodeURI(jQuery("#versionmemo").val()),
			versionaffix:"",
			date2Version:encodeURI(jQuery("#versionTime").val()),
			oneMoudel:oneMoudel
			};
			jQuery.post("/cpcompanyinfo/action/CPConstitutionOperate.jsp",o4params,function(){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31046,user.getLanguage()) %>!");
				onLicenseDivClose();
		});
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
	
		var begintime=jQuery.trim(jQuery("#stitubegintime").val());
		var endtime=jQuery.trim(jQuery("#stituendtime").val());
		if(""!=begintime&&""!=endtime){
			if(opinionStartTimeEndTime(begintime,endtime)==false){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())  %>!");
					return;
			}
		}
		
		var begintime02=jQuery.trim(jQuery("#visitbegintime").val());
		var endtime02=jQuery.trim(jQuery("#visitendtime").val());
		if(""!=begintime&&""!=endtime){
			if(opinionStartTimeEndTime(begintime02,endtime02)==false){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())  %>!");
					return;
			}
		}
		
		var begintime03=jQuery.trim(jQuery("#effbegintime").val());
		var endtime03=jQuery.trim(jQuery("#effendtime").val());
		if(""!=begintime&&""!=endtime){
			if(opinionStartTimeEndTime(begintime03,endtime03)==false){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31191,user.getLanguage())  %>!");
					return;
			}
		}
		
		jQuery("#saveConstitutionBtn").attr("href","javascript:void(0);");	//不让保存重复点击
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
					jQuery("#saveConstitutionBtn").attr("href","javascript:saveDate();");
				}
			}
		}
		else
		{
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
			jQuery("#saveConstitutionBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
		}
	} 
	
	/*打开版本管理页面*/
	function openVersionManage(){
		
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","130px").css("left","130px");
		jQuery("#wBoxContent").css("width","500px").css("height","250px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(19450,user.getLanguage()) %>");
		jQuery("#wBoxContent").load("/cpcompanyinfo/CompanyVersionManage.jsp?constitutionid="+jQuery("#constitutionid_zc").val()+"&oneMoudel=constitution&showOrUpdate=<%=showOrUpdate%>");
		//jQuery("#wBoxContent").load("/cpcompanyinfo/CompanyVersionMaint.jsp?constitutionid="+jQuery("#constitutionid_zc").val()+"&oneMoudel=constitution&companyid=<%=companyid%>");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		
		
	}
	
	/*打开版本新增DIV*/
	function onversionAddDivOpen(){
		jQuery("#wBoxContent").html("");
		jQuery("#wBox").css("top","130px").css("left","130px");
		jQuery("#wBoxContent").css("width","335px").css("height","225px");
		jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31011,user.getLanguage()) %>");
		jQuery("#wBoxContent").load("/cpcompanyinfo/CompanyVersionMaint.jsp?constitutionid="+jQuery("#constitutionid_zc").val()+"&oneMoudel=constitution&companyid=<%=companyid%>");
		jQuery("#wBox_overlay").removeClass("wBox_hide").addClass("wBox_overlayBG");
		jQuery("#licenseDiv").css("display","");
		
		//var url="/cpcompanyinfo/CompanyVersionMaint.jsp?constitutionid="+jQuery("#constitutionid_zc").val()+"&oneMoudel=constitution&companyid=<%=companyid%>&isdialog=1";
		//var title="创建版本";
		//openDialog(url,title,500,350,false,false);
	}
	
	/*关闭选择证照DIV*/
	function onLicenseDivClose() {
		jQuery("#wBox_overlay").removeClass("wBox_overlayBG").addClass("wBox_hide");
		jQuery("#licenseDiv").css("display","none");
		jQuery("#saveConstitutionBtn").attr("href","javascript:saveDate();");	//恢复保存按钮
	} 
	
	/*版本方法 开始*/
	
	
	function saveversionDate(){
		
		jQuery("#isaddversion").val("add");
		StartUploadAll();
		checkuploadcomplet();
	}
	
	/*打开币种DIV*/
	function onCurrOpen(obj){
		var tempid= window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/fna/maintenance/CurrencyBrowser.jsp");
		if(tempid){
			if(tempid.name){
				jQuery(obj).next().html(tempid.name);
				jQuery(obj).next().next().val(tempid.id);
				jQuery(obj).next().next().next().css("display","none");
			}else{
				jQuery(obj).next().html("");
				jQuery(obj).next().next().val("");
				jQuery(obj).next().next().next().css("display","");
			}
		}else{
			
		}
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
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>！");
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
			jQuery.post("/cpcompanyinfo/action/CPConstitutionOperate.jsp",o4params,function(){
				
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
		jQuery("#bcVersions").css("display","none");
		var versionids="";
		jQuery('#webTable2version tr').each(function(){
			if(jQuery(this).children('td').find("input[type=checkbox][inWhichPage='zhzhVersion']").attr("checked")==true)
			{
				versionids += jQuery(this).attr("versionid")+",";
			}
		});
		if(versionids.length == 0){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage()) %>！");
		}else  if(versionids.split(",").length>2){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31014,user.getLanguage()) %>！");
		}else{
			var o4params = {method:"viewVersion",versionids:versionids}
			jQuery.post("/cpcompanyinfo/action/CPConstitutionOperate.jsp",o4params,function(data){
				var class_cpConstitution = data[0];
				jQuery("#constitutionid_zc").val(class_cpConstitution["constitutionid"]);
				jQuery("#aggregateinvest_zc").val(class_cpConstitution["aggregateinvest"]);
				jQuery("#currencyid_zc").val(class_cpConstitution["currencyid_zc"]);
				jQuery("#currencyid_zcspan").html(class_cpConstitution["currencyname"]);
				
				
				jQuery("#isvisitors_zc").val(class_cpConstitution["isvisitors"]);
				jQuery("#boardvisitors_zc").val(class_cpConstitution["boardvisitors"]);
				jQuery("#visitbegindate_zc").html(class_cpConstitution["visitbegindate"]);
				jQuery("#visitbegintime").val(class_cpConstitution["visitbegindate"]);
				
				
				jQuery("#visitenddate_zc").html(class_cpConstitution["visitenddate"]);
				jQuery("#visitendtime").val(class_cpConstitution["visitenddate"]);
				
				
				jQuery("#theboard_zc").val(class_cpConstitution["theboard"]);
				jQuery("#stitubegindate_zc").html(class_cpConstitution["stitubegindate"]);
				jQuery("#stitubegintime").val(class_cpConstitution["stitubegindate"]);
				jQuery("#stituenddate_zc").html(class_cpConstitution["stituenddate"]);
				jQuery("#stituendtime").val(class_cpConstitution["stituenddate"]);
				
				
				
				jQuery("#appointduetime_zc").val(class_cpConstitution["appointduetime"]);
				if(class_cpConstitution["isreappoint"]=="T")
				jQuery("#isreappoint_zc").attr("checked",true);
				else jQuery("#isreappoint_zc").attr("checked",false);
				jQuery("#generalmanager_zc").val(class_cpConstitution["generalmanager"]);
				jQuery("#effectbegindate_zc").html(class_cpConstitution["effectbegindate"]);
				jQuery("#effbegintime").val(class_cpConstitution["effectbegindate"]);
				jQuery("#spanTitle_zc").html("");
				jQuery("#spanTitle_zc").html("<%=SystemEnv.getHtmlLabelName(31047,user.getLanguage()) %>["+data[1]+"]");
				
				jQuery("#effectenddate_zc").html(class_cpConstitution["effectenddate"]);
				jQuery("#effendtime").val(class_cpConstitution["effectenddate"]);
				
				
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
				jQuery(".Clock").hide();
				jQuery(".Browser").hide();
				jQuery("#save_H").hide();
				jQuery("#isreappoint_zc").attr("disabled","disabled");  
				jQuery("#licenseAffixUpload").hide();
				jQuery(".OInput2").removeClass("OInput2").addClass("OInput3").focus(function(){this.blur();});
				jQuery("select").attr("disabled","disabled");  
				
				jQuery("#affixcpdosDIV").html(html4doc);
				onLicenseDivClose();
			},"json");
		}
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
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31017,user.getLanguage()) %>！");
		}else{
			jQuery("#wBoxContent").html("");
			jQuery("#wBox").css("top","130px").css("left","130px");
			jQuery("#wBoxContent").css("width","335px").css("height","225px");
			jQuery(".wBox_itemTitle").html("<%=SystemEnv.getHtmlLabelName(31018,user.getLanguage()) %>");
			jQuery("#wBoxContent").load("CompanyVersionMaint.jsp?versionids="+versionids+"&oneMoudel=constitution&companyid=<%=companyid%>");
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
	       saveConstitution();
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
	button_height: <%if(!CompanyInfoTransMethod.CheckPack("2")){out.println("0");}else{out.println("18");}%>,//“上传”按钮的高度
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

var timer = setInterval(showmustinput , 400);
function showmustinput() {
			var _temp=0;
			var t_length=$(".progressWrapper").each(function(){
						//obj.css("display")=="none"
						if($(this).css("display")=="block"){
							_temp++;
						}
			});
			if(_temp>0){
				   $("#_fximg").hide();
			}else{
				   $("#_fximg").show();
			}
         /*  var sta = oUploader.getStats();
          if (sta.files_queued == 0) {
             $("#obj").html("<img src='/images/BacoError_wev8.gif' align=absMiddle>");
          } else {
             $("#obj").html("");
          } */
         
}
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
