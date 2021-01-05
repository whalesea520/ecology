<!DOCTYPE html>
<%@page import="com.weaver.integration.util.IntegratedSapUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.lang.*" %>
<%@ page import="weaver.interfaces.workflow.browser.Browser" %>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<%@ page import="weaver.general.StaticObj" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.net.URLDecoder" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="browserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="SapBrowserComInfo" class="weaver.parseBrowser.SapBrowserComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css">
	select{
		width: 200px;
	}
	input[type='text']{
		width:200px!important;
	}
    .childItemDiv .e8_outScroll,.childItemDiv .e8_innerShowMust{
        display:none;
    }
</style>
</head>
<%
	int isFromMode = Util.getIntValue(request.getParameter("isFromMode"),0);
    String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String fromWFCode = Util.null2String(request.getParameter("fromWFCode"));
	int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
	int isbill=Util.getIntValue(Util.null2String(request.getParameter("isbill")),-1);
	
	String formRightStr = "FormManage:All";
	if(isFromMode==1){
		formRightStr = "FORMMODEFORM:ALL";
	}
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int operateLevel = UserWFOperateLevel.checkWfFormOperateLevel(detachable,user,formRightStr,formid,isbill);
	if (!HrmUserVarify.checkUserRight(formRightStr, user) || operateLevel < 1) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String isValue = Util.null2String(request.getParameter("isValue"));
	String fHtmlType = Util.null2String(request.getParameter("fieldHtmlType"));
	String fname = Util.null2String(request.getParameter("fieldname"));
	String lableid = Util.null2String(request.getParameter("lableid"));
	String idcode = "";
	String openrownum = Util.null2String(request.getParameter("openrownum"));
	String message = Util.null2String(request.getParameter("message"));
	
	DecimalFormat decimalFormat=new DecimalFormat("0.00");//使用系统默认的格式

	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17998,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	
	if(isclose.equals("1") && isValue.equals("2") && fHtmlType.equals("1") ){
		rs.executeSql("select id from workflow_billfield where billid="+formid+" and fieldname = '"+fname+"' and fieldlabel = '"+lableid+ "' and fieldHtmlType = "+fHtmlType);
		while(rs.next()){
			idcode = Util.null2String(rs.getString("id"));
			lableid = SystemEnv.getHtmlLabelName(Integer.parseInt(lableid), user.getLanguage());
		}
	}
	
	String maintable = "";
	rs.executeSql("select tablename from workflow_bill where id="+formid);
	if(rs.next()) maintable = Util.null2String(rs.getString("tablename"));
		
	String dbnamesForCompare_main = ",";
	
	rs.executeSql("select fieldname from workflow_billfield where viewtype=0 and billid="+formid);
	while(rs.next()){
		dbnamesForCompare_main += rs.getString("fieldname").toUpperCase()+",";
	}
	int dsporder = 0;
	ArrayList dbnamesForCompare_Detail_Arrays = new ArrayList();
	ArrayList detailname_Arrays = new ArrayList();
	rs.executeSql("select tablename from Workflow_billdetailtable where billid="+formid+" order by orderid");
	while(rs.next()){
		String dbnamesForCompare_Detail = ",";
		String detailTableName = Util.null2String(rs.getString("tablename"));
		detailname_Arrays.add(detailTableName);
		rs1.executeSql("select fieldname from workflow_billfield where viewtype=1 and billid="+formid+" and detailtable='"+detailTableName+"'");
		while(rs1.next()){
			dbnamesForCompare_Detail += Util.null2String(rs1.getString("fieldname")).toUpperCase()+",";
		}
		dbnamesForCompare_Detail_Arrays.add(dbnamesForCompare_Detail);
		%>
		<input type="hidden" value="<%=dbnamesForCompare_Detail%>" name="<%=detailTableName%>" id="<%=detailTableName%>">
		<%}	

String mainselect="FieldHtmlType.options[0]=new Option('"+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"',1);"+"\n"+
		          "FieldHtmlType.options[1]=new Option('"+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"',2);"+"\n"+
		          "FieldHtmlType.options[2]=new Option('"+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"',3);"+"\n"+
		          "FieldHtmlType.options[3]=new Option('"+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"',4);"+"\n"+
		          "FieldHtmlType.options[4]=new Option('"+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"',5);"+"\n";
        	 mainselect += "FieldHtmlType.options[5]=new Option('"+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"',6);"+"\n"+
					       "FieldHtmlType.options[6]=new Option('"+SystemEnv.getHtmlLabelName(21691,user.getLanguage())+"',7);"+"\n"+
					       "FieldHtmlType.options[7]=new Option('"+SystemEnv.getHtmlLabelName(125583,user.getLanguage())+"',9);"+"\n";

String detailselect="FieldHtmlType.options[0]=new Option('"+SystemEnv.getHtmlLabelName(688,user.getLanguage())+"',1);"+"\n"+
		            "FieldHtmlType.options[1]=new Option('"+SystemEnv.getHtmlLabelName(689,user.getLanguage())+"',2);"+"\n"+
		            "FieldHtmlType.options[2]=new Option('"+SystemEnv.getHtmlLabelName(695,user.getLanguage())+"',3);"+"\n"+
		            "FieldHtmlType.options[3]=new Option('"+SystemEnv.getHtmlLabelName(691,user.getLanguage())+"',4);"+"\n"+
		            "FieldHtmlType.options[4]=new Option('"+SystemEnv.getHtmlLabelName(690,user.getLanguage())+"',5);"+"\n"+
		            "FieldHtmlType.options[5]=new Option('"+SystemEnv.getHtmlLabelName(17616,user.getLanguage())+"',6);"+"\n";
String locationtype = "htmltypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(22981,user.getLanguage())+"',1);"+"\n"; //
String locatetype = "locatetypelist.options[0]=new Option('"+SystemEnv.getHtmlLabelName(125582,user.getLanguage())+"',1);"+"\n"+
		            					"locatetypelist.options[1]=new Option('"+SystemEnv.getHtmlLabelName(81855,user.getLanguage())+"',2);"+"\n"	;  //¶¨Î»ÀàÐÍ£¬°üÀ¨£ºÊÖ¶¯¡¢×Ô¶¯
		            
		            
		 String selectItemType = "";
		            
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancelDialog(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage()) %>"/>
</jsp:include>
<%}%>
<form name="form1" method="post" action="/workflow/form/form_operation.jsp" >
	<input type="hidden" value="addFieldSingle" name="src">
	<input type="hidden" value="" name="openrownum" id="openrownum">
	<input type="hidden" value="<%=formid%>" name="formid">
	<input type="hidden" value="<%=dbnamesForCompare_main%>" name="<%=maintable%>">
	<input type="hidden" value="0" name="choiceRows_rows">
    <input type="hidden" value="<%=isFromMode %>" name="isFromMode">
    <input type="hidden" value="<%=dialog %>" name="dialog">
    <input type="hidden" value="<%=fromWFCode %>" name="fromWFCode">
<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
    			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="submitData()">
				<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
</table>  
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(324,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=Inputstyle type="text" name="fieldname" size="40" maxlength="30" value=""	onBlur='checkinput_char_num("fieldname");checkinput("fieldname","fieldnamespan")'>
			<span id=fieldnamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
			<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(15441,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(19881,user.getLanguage())%>."id,requestId"(<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%>),"id,mainid"(<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%>)<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span>	
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15456,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=Inputstyle type="text" name="fieldlabelname" size="40" maxlength="30" value=""	onBlur='checkinput_char_num("fieldname");checkinput("fieldlabelname","fieldlabelnamespan")'>
			<span id=fieldlabelnamespan><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(17997	,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="updateTableName" name="updateTableName" onchange="OnChangeUpdateTableName(this)">
				<option value="<%=maintable%>"><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<%
				for(int i=0;i<detailname_Arrays.size();i++){
				%>
				<option value="<%=detailname_Arrays.get(i)%>"><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><%=i+1%></option>
				<%}%>
			</select>		
		</wea:item>
		
		
		<wea:item><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%></wea:item>
		<wea:item>
			<input class='InputStyle' type="text" size=10 maxlength=7 name="itemDspOrder" onKeyPress="ItemNum_KeyPress(this.name)" onblur="checknumber('itemDspOrder');checkDigit('itemDspOrder',15,2)" style="text-align:right;padding-right:1px;">
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(687,user.getLanguage())%></wea:item>  <!-- 表现形式 -->
		<wea:item>
			<div style="display:block;float:left;height:auto;width:172px;">
				<select class='InputStyle' id="FieldHtmlType" name="FieldHtmlType" onchange="OnChangeFieldHtmlType()" style="float: left;">
					<option value='1' ><%=SystemEnv.getHtmlLabelName(688,user.getLanguage())%></option>
					<option value='2' ><%=SystemEnv.getHtmlLabelName(689,user.getLanguage())%></option>
					<option value='3' ><%=SystemEnv.getHtmlLabelName(695,user.getLanguage())%></option>
					<option value='4' ><%=SystemEnv.getHtmlLabelName(691,user.getLanguage())%></option>
					<option value='5' ><%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%></option>
					<option value='6' ><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></option>
					<option value='7' ><%=SystemEnv.getHtmlLabelName(21691,user.getLanguage())%></option>
					<%if(isFromMode != 1) {%>
					<option value="9" ><%=SystemEnv.getHtmlLabelName(125583,user.getLanguage())%></option> <!-- 8公共选项在使用 -->
					<%} %>
				</select>
			</div>
			<div style="width:5px!important;height:3px;float:left;"></div>
			 
			<div id="div1" style="display:inline">
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>       <!-- 类型 -->
				<select class='InputStyle' id="DocumentType" name="DocumentType" onchange="OnChangeDocumentType()">
					<option value='1' ><%=SystemEnv.getHtmlLabelName(608,user.getLanguage())%></option>
					<option value='2' ><%=SystemEnv.getHtmlLabelName(696,user.getLanguage())%></option>
					<option value='3' ><%=SystemEnv.getHtmlLabelName(697,user.getLanguage())%></option>
					<option value='4' ><%=SystemEnv.getHtmlLabelName(18004,user.getLanguage())%></option>
					<option value='5' ><%=SystemEnv.getHtmlLabelName(22395,user.getLanguage())%></option>
				</select>
			</div>
			<div id="div1_1" style="display:inline">
				<%=SystemEnv.getHtmlLabelName(698,user.getLanguage())%>      <!-- 文本长度 -->
				<input class='InputStyle' type='text' size=3 maxlength=3 value='' id='itemFieldScale1' name='itemFieldScale1' onKeyPress='ItemPlusCount_KeyPress()' onblur="checkPlusnumber1(this),checklength('itemFieldScale1','itemFieldScale1span');checkcount1(itemFieldScale1)" style='text-align:right;padding-right:2px;'>
				<span id=itemFieldScale1span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
			</div>
			<div id="div1_3" style="display:none">
				<%=SystemEnv.getHtmlLabelName(15212,user.getLanguage())%>  <!-- 小数点位数 -->
				<select id="decimaldigits" name="decimaldigits">
					<option value="1" >1</option>
					<option value="2" selected>2</option>
					<option value="3" >3</option>
					<option value="4" >4</option>
				</select>
			</div>
			
			<div id="div9" style="display:none">
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>       <!-- 类型 -->
				<select class='InputStyle' style="width:120px" id="locationType" name="locationType" onchange="OnChangelocationType()">
					<option value='1' ><%=SystemEnv.getHtmlLabelName(22981,user.getLanguage())%></option>
				</select>
			</div>
			<%-- 
			<div id="div9_1" style="display:none">
				<%=SystemEnv.getHtmlLabelName(125581,user.getLanguage())%>  <!-- 定位方式 -->
				<select id="locateType" style="width:120px" name="locateType">
					<option value="1" selected><%=SystemEnv.getHtmlLabelName(125582,user.getLanguage()) %></option>
					<option value="2" ><%=SystemEnv.getHtmlLabelName(81855,user.getLanguage()) %></option>
				</select>
			</div>
			--%>
			<div id="div2" style="display:none">
				<%=SystemEnv.getHtmlLabelName(207,user.getLanguage())%>       <!-- 高度 -->
				<input class='InputStyle' type='text' size=4 maxlength=2 value='4' id='textheight' name='textheight' onKeyPress='ItemPlusCount_KeyPress()' onblur='checkPlusnumber1(this),checkcount1(textheight)' style='text-align:right;padding-right:1px;'>
				<%=SystemEnv.getHtmlLabelName(222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15449,user.getLanguage())%>
				<input type='checkbox' id="htmledit" name="htmledit" onclick="onfirmhtml()" value="1">
			</div>
			<div id="div3" style="display:none;float:left;">
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select notBeauty=true class='InputStyle' id="browsertype" name="browsertype" onchange="OnChangeBrowserType()">
					<option></option>
				<%
				String IsOpetype=IntegratedSapUtil.getIsOpenEcology70Sap();
				while(browserComInfo.next()){%>
				<%
				if(browserComInfo.getBrowserurl().equals("")){
					continue;
				}
				if("0".equals(IsOpetype)&&("224".equals(browserComInfo.getBrowserid()))||"225".equals(browserComInfo.getBrowserid())){
					continue;
				}
				if (browserComInfo.notCanSelect()) continue;
				%>
				<option match="<%=browserComInfo.getBrowserPY(user.getLanguage())%>" value="<%=browserComInfo.getBrowserid()%>"><%=SystemEnv.getHtmlLabelName(Util.getIntValue(browserComInfo.getBrowserlabelid(),0),user.getLanguage())%></option>
				<%}%>
				</select>
				<span id="selecthtmltypespan" style="display:none;">
					<img align="absMiddle" src="/images/BacoError_wev8.gif">
				</span>
				<script type="text/javascript">
					//browsertype 下拉框选项按照字母顺序排序
					function sortRule(a,b) {
						var x = a._text;
						var y = b._text;
						return x.localeCompare(y);
					}
					function op(){
						var _value;
						var _text;
					}
					function sortOption(){
						var obj = document.getElementById("browsertype");
						var tmp = new Array();
						for(var i=0;i<obj.options.length;i++){
							var ops = new op();
							ops._value = obj.options[i].value;
							ops._text = obj.options[i].text;
							ops._match = jQuery(obj.options[i]).attr('match');
							tmp.push(ops);
						}
						tmp.sort(sortRule);
						for(var j=0;j<tmp.length;j++){
							obj.options[j].value = tmp[j]._value;
							obj.options[j].text = tmp[j]._text;
							jQuery(obj.options[j]).attr('match', tmp[j]._match);
						}
					}
					sortOption();
				</script>
			</div>
			<div id="div3_4" style="display:none">
				<select class=inputstyle  name=sapbrowser id=sapbrowser onchange="OnChangeSapBroswerType()">
					<option value=""></option>
					<%
					List AllBrowserId=SapBrowserComInfo.getAllBrowserId();
					for(int j=0;j<AllBrowserId.size();j++){
					%>
					<option value=<%=AllBrowserId.get(j)%>><%=AllBrowserId.get(j)%></option>
					<%}%>
				</select>
			</div>
										
			<div id="div3_5" style="display:none">
				<button type="button" class="Browser browser" name=newsapbrowser id=newsapbrowser onclick="OnNewChangeSapBroswerType()"></button>
				<span id="showinner" name="showinner"></span>
				<span id="showimg" name="showimg">
				<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
				</span>
				<input id="showvalue" type="hidden" name="showvalue">
			</div>
								  									  		
			<div id="div3_1" style="display:none">
				<span><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
			</div>
			<div id="div3_2" style="display:none">
				<brow:browser width="150px" viewType="0" name="definebroswerType"
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/field/UserDefinedBrowserTypeBrowser.jsp"
					    completeUrl="/data.jsp"
						hasInput="false" isSingle="true"
						isMustInput="2"
						browserDialogWidth="550px"
						browserDialogHeight="650px"></brow:browser>
			</div>
			<div id="div3_3" style="display:none">
		  		<div style='float:left;'><%=SystemEnv.getHtmlLabelName(19340,user.getLanguage()) %></div>
			    <brow:browser width="105px" viewType="0" name="decentralizationbroswerType"
					browserValue="1"
				    browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/form/rightAttributeDepat.jsp?selectValue=#id#"
				    completeUrl="/data.jsp"
					hasInput="false" isSingle="true"
					isMustInput="2"
					browserDialogWidth="400px"
					browserDialogHeight="290px"
					browserSpanValue="本部门"></brow:browser>
		  	
		  	
		  	</div>
		  	
		  
			
			<div id="div3_7" style="display:none"><!-- 自定义树形单选 -->
				<brow:browser width="150px" viewType="0" name="defineTreeBroswerType"
					    browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/tree/treebrowser/TreeBrowser.jsp"
					    completeUrl="/data.jsp"
						hasInput="false" isSingle="true"
						isMustInput="2"
						browserDialogWidth="550px"
						browserDialogHeight="650px"></brow:browser>
				
			</div>
								  	
			<div id="div5" style="display:none;" >
				<div style="float: left;margin-left:2px;width:150px;">
				    <span style="float: left;margin-top:5px"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></span>
				    <select id="selectItemType" name="selectItemType" class=inputstyle style="width:100px" onchange="selectItemTypeChange('selectItemType')">
	                    <option value="0" <%if(selectItemType.equals("0")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124929,user.getLanguage())%></option>
	                    <option value="1" <%if(selectItemType.equals("1")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124930,user.getLanguage())%></option>
	                    <option value="2" <%if(selectItemType.equals("2")){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>
	                </select>
				</div>
				
				<div id="pubchoiceIdDIV" style="display:none; float: left;margin-left:10px;">
                	<brow:browser width="150px" viewType="0" name="pubchoiceId"
				    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemBrowser&url=/workflow/selectItem/selectItemBrowser.jsp"
				    completeUrl="/data.jsp?type=pubChoice"
					hasInput="true" isSingle="true"
					isMustInput="2"
					browserDialogWidth="550px"
					browserDialogHeight="650px" _callback="setPreviewPub"></brow:browser>
					
					<div style="margin-left:10px;margin-top:5px;float:left;">
						<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%>
					</div>
					
					<select id="previewPubchoiceId" name="previewPubchoiceId" >
						<option value="" ></option>
					</select>
                </div>
                
                <div id="pubchilchoiceIdDIV" style="display:none; float: left;margin-left:10px;">
                    <span style='float:left;padding-top:5px;'><%=SystemEnv.getHtmlLabelName(124957 ,user.getLanguage()) %></span>
                	<brow:browser width="150px" viewType="0" name="pubchilchoiceId"
				    browserUrl="/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&url=/workflow/selectItem/selectItemSupFieldBrowser.jsp"
				    completeUrl='<%="javascript:getcompleteurl()"%>'
					hasInput="true" isSingle="true"
					isMustInput="2"
					browserDialogWidth="550px"
					browserDialogHeight="650px" getBrowserUrlFn="onShowPubchilchoiceId"></brow:browser>
                </div>
                
                
				<div id="childfielddiv" style="float: left;margin-left:10px;">
					<span style="float: left;margin-top:5px;">
					<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage())%></span>
					<brow:browser name="childfieldid" viewType="0" hasBrowser="true" hasAdd="false" 
					                  isMustInput="1" isSingle="true" hasInput="true"
					        completeUrl="/data.jsp?type=fieldBrowser&isbill=0"   width="150px" browserValue="" browserSpanValue="" _callback="clearChildItem"  getBrowserUrlFn="onShowChildField_new"/>
					<span id="childfieldidSpan"></span>
					<input type="hidden" value="" name="childfieldid" id="childfieldid">
				</div>
				
			</div>
			<div id="div8" style="display:none" >
				<div >
					<%=SystemEnv.getHtmlLabelName(63,user.getLanguage()) %>    <!-- 类型 -->
					<input type='text' class='InputStyle' style='width:120px !important;padding-left:5px;' readonly='readonly' id='selectTypeSpan' name='selectTypeSpan' >
					<button type='button' class='Browser' style='margin-left:10px;' onClick=showModalDialogSelectItem(selectType,selectTypeSpan) id='selectItemBtn' name='selectItemBtn'></BUTTON>
					<input type='hidden' id='selectType' name='selectType' >
					&nbsp;&nbsp;
					<%=SystemEnv.getHtmlLabelName(22662,user.getLanguage()) %>   <!-- 关联子字段 -->
					<button type='button' class='Browser' onClick=onShowChildCommonSelectItem(childCommonItemSpan,childCommonItem) id='selectChildItem' name='selectChildItem'></BUTTON>
					<input type='hidden' id='childCommonItem' name='childCommonItem' value='' >
					<span id='childCommonItemSpan' name='childCommonItemSpan'></span>
				</div>
			</div>
			<div id="div6" style="display:none">
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select id=uploadtype name=uploadtype onchange=onuploadtype(this)>
					<option value="1"><%=SystemEnv.getHtmlLabelName(20798,user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(20001,user.getLanguage())%></option>
				</select>
			</div>
			<div id="div6_1" style="display:none">
			    <span id="div6_1_1">
				<%=SystemEnv.getHtmlLabelName(24030,user.getLanguage())%>
				<input type=input class="InputStyle" style="width: 100px;" name="strlength" value="5" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)">
				</span>
				<%=SystemEnv.getHtmlLabelName(22924,user.getLanguage())%>
				<input type=input class="InputStyle" style="width: 100px;" name="imgwidth" value="100" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)">
				<%=SystemEnv.getHtmlLabelName(22925,user.getLanguage())%>
				<input type=input class="InputStyle" style="width: 100px;" name="imgheight" value="100" onKeyPress="ItemPlusCount_KeyPress()" onblur="checkPlusnumber1(this)">
			</div>
			<div id="div7" style="display:none">
				<%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>
				<select id=specialfield name=specialfield onchange=specialtype(this)>
					<option value="1"><%=SystemEnv.getHtmlLabelName(21692,user.getLanguage())%></option>
					<option value="2"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%></option>
				</select>
			</div>
			<div id="div7_1" style="display:none">
			<div style="display:inline-block;">
				<%=SystemEnv.getHtmlLabelName(606,user.getLanguage())%><input class=inputstyle style="width: 100px;" type=text name=displayname  value="" maxlength=1000>　
				<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>　<input class=inputstyle style="width: 100px;" type=text name=linkaddress value="" maxlength=1000><%=SystemEnv.getHtmlLabelName(18391,user.getLanguage())%>
			</div>
			</div>
			<div id="div7_2" style="display:none"><table width="100%"><tr><td width="8%"><%=SystemEnv.getHtmlLabelName(21693,user.getLanguage())%>　</td><td><textarea class='inputstyle' style='width:60%;height:100px;resize:none;margin-top: 2px;margin-bottom: 2px;' name=descriptivetext></textarea></td></tr></table></div>
			<div style="clear:both;"></div> 		
		</wea:item>
		
	</wea:group>
</wea:layout>
<div id="choicediv" style="display:none;">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(124984,user.getLanguage())%>' >
		    <wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="addoTableRow()"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="submitClear()"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<table class=ListStyle cellspacing=0   cols=6 id="choiceTable0">
					<colgroup>
					<col width="5%">
					<col width="15%">
					<col width="5%">
					<col width="20%">
					<col width="8%">
					<col width="7%">
					</colgroup>  
					
					 <tr class="header notMove">
					    <td><input type="checkbox" name="selectall" id="selectall" onclick="SelAll(this)"></td>
		            	<td><%=SystemEnv.getHtmlLabelName(15442,user.getLanguage())%></td><!-- 可选择项文字 -->
		            	<td><%=SystemEnv.getHtmlLabelName(19206,user.getLanguage())%></td><!-- 默认值 -->
		            	<td><%=SystemEnv.getHtmlLabelName(19207,user.getLanguage())%></td><!-- 关联文档目录 -->
		            	<td><%=SystemEnv.getHtmlLabelName(22663,user.getLanguage())%></td><!-- 子选项 -->
		            	<td><%=SystemEnv.getHtmlLabelName(22151,user.getLanguage())%></td><!-- 封存 -->
					</tr>
					
				</table>
					
				<input type="hidden" id="needcheck" name="needcheck" value="">
				<input type="hidden" id="rowno" name="rowno" value="">
			</wea:item>
		</wea:group>
</wea:layout>
</div>

</form>
<%if("1".equals(dialog)){ %>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()" style="width: 60px!important;">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
</body>
</html>
<script language="JavaScript">

if("<%=dialog%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	function btn_cancle(){
		parentWin.closeDialog();
	}
}

if("<%=isclose%>"==1){
		var dialog = parent.getDialog(window);
		var parentWin = parent.getParentWindow(window);
		if("<%=isValue%>" == "1"){
			parentWin.location="/workflow/form/editformfield.jsp?formid="+<%=formid%>+"&ajax=0&isFromMode=<%=isFromMode%>";
			dialog.close();
		}
		if("<%=isValue%>" == "2" && "<%=fHtmlType%>" == "1"){
			var lableid = "<%=lableid%>";
			var idcode = "<%=idcode%>";
			var returnjson  = {lableid:lableid,idcode:idcode};
			try{
		        dialog.callback(returnjson);
		    }catch(e){}
			try{
		     	dialog.close(returnjson);
		 	}catch(e){}
		}
		if("<%=isValue%>" == "2" && "<%=fHtmlType%>" != "1"){
			dialog.close();
		}
		if("<%=isValue%>"=="3"){	//新表单设计器-添加字段-返回JSON
			var curfieldid="<%=Util.null2String(request.getParameter("curfieldid")) %>";
			var fieldlabelname = "<%=URLDecoder.decode(Util.null2String(request.getParameter("fieldlabelname")), "utf-8") %>";
			var tableIndex="<%=Util.null2String(request.getParameter("tableIndex")) %>";
			var returnjson={returnValue:"success",curfieldid:curfieldid,fieldlabelname:fieldlabelname,tableIndex:tableIndex};
			try{
		        dialog.callback(returnjson);
		    }catch(e){}
			try{
		     	dialog.close(returnjson);
		 	}catch(e){}
		}
		//parent.parentWin.closeDialog();
}

function showModalDialogSelectItem(objid,objSpanid){
	var url = "/formmode/setup/SelectItemBrowser.jsp";
	url = escape(url);
	var myid = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if(myid){
		if (wuiUtil.getJsonValueByIndex(myid,0) != "") {
            	var ids = wuiUtil.getJsonValueByIndex(myid,0);
				var names = wuiUtil.getJsonValueByIndex(myid, 1);
				jQuery(objid).val(ids);
				jQuery(objSpanid).val(jQuery(names).text());
            }else{
				jQuery(objid).val("");
				jQuery(objSpanid).val("");
            }
	}
}

function onShowChildCommonSelectItem(spanname, inputname, childstr) {
	var updateTableName = jQuery("#updateTableName").val();
    var isdetail = "0";
    var pfieldidsql = "";
    if(updateTableName.indexOf("_dt")>0){
    	isdetail = "1";
    	 pfieldidsql = " AND detailtable='" + updateTableName + "' ";
    }
	url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=8 and billid=<%=formid%>" + pfieldidsql + "&isdetail=" + isdetail + "&isbill=1");
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            inputname.value =wuiUtil.getJsonValueByIndex(id,0);
            spanname.innerHTML =wuiUtil.getJsonValueByIndex(id,1);
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
    }
}

function setSelectItemType(){
	$("#selectItemType option[value='2']").remove(); 
	
	var updateTableName = document.getElementById("updateTableName").value;
	var detailtable = "";
	if(updateTableName.indexOf("_dt") > -1){
		detailtable = updateTableName;
	}
    var isdetail = getIsDetail();
    
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=hasPubChoice&isdetail="+isdetail+"&formid=<%=formid%>&detailtable="+detailtable,
		    dataType: "text",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        var _data = data.trim();
		        if(_data=="true"){
					jQuery("#selectItemType").append("<option value='2'><%=SystemEnv.getHtmlLabelName(124931,user.getLanguage())%></option>");		        
		        }
		    	__jNiceNamespace__.reBeautySelect("#selectItemType");
		    } 
	}); 
}


function setPreviewPub(event,datas,name){
	var pubchoiceId = jQuery("#pubchoiceId").val()
	
	jQuery("#previewPubchoiceId").empty();
	jQuery.ajax({
			type: "POST",
			cache: false,
			url: "/workflow/selectItem/selectItemAjaxData.jsp?src=pubchoiceback&id="+pubchoiceId,
		    dataType: "json",  
		    async:false,
		    //contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(){
			},
		    error:function (XMLHttpRequest, textStatus, errorThrown) {
		    } , 
		    success : function (data, textStatus) {
		        jQuery("#previewPubchoiceId").append("<option value=''></option>");
		        var _data = data;
		    	for(var i=0;i<_data.length;i++){
		    	    var tt = _data[i];
		    	    var _id = tt.id;
		    	    var _name = tt.name;
		    		jQuery("#previewPubchoiceId").append("<option value='"+_id+"'>"+_name+"</option>");
		    	}
		    	//beautySelect("#previewPubchoiceId");
		    	__jNiceNamespace__.reBeautySelect("#previewPubchoiceId");
		    } 
	}); 
	
	
}

function eidtSelectItem(id){
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelName(124896,user.getLanguage())%>";
	url="/workflow/selectItem/selectItemMain.jsp?topage=selectItemEdit&src=edit&id="+id;
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function selectItemTypeChange(obj){
	var value = jQuery("#"+obj).val();
	if(value != 0){
		jQuery("#choicediv").hide();
		jQuery("#childfielddiv").hide();
	}else{
		jQuery("#choicediv").show();
		jQuery("#childfielddiv").show();
	}
	
	if(value==1){
		jQuery("#pubchoiceIdDIV").show();
	}else{
		jQuery("#pubchoiceIdDIV").hide();
	}
	
	if(value==2){
		jQuery("#pubchilchoiceIdDIV").show();
	}else{
		jQuery("#pubchilchoiceIdDIV").hide();
	}
	
	
}
	
function SelAll(obj){
	//$("input[type=checkbox]").attr("checked",obj.checked);
	var ckd = jQuery(obj).attr("checked");
	jQuery("input[id^='chkField_']").each(function(){
		if(ckd){
			jQuery(this).attr("checked",true);
			changeCheckboxStatus(this, true);
		}else{
			jQuery(this).attr("checked",false);
			changeCheckboxStatus(this, false);
		}
	});
}
	
jQuery(document).ready(function(){
	<%
	if(message.equals("pubchilchoiceId")){
	%>
	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130446,user.getLanguage())%>");
	try{
	    var parentWin = parent.getParentWindow(window);
	    parentWin._table.reLoad();
	}catch(e){}
	<%}%>
	
	registerDragEvent();
	jQuery("tr.notMove").bind("mousedown", function() {
		return false;
	});
});	
	
	
	
function registerDragEvent() {
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
		    $(this).width($(this).width()); // 在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

		    $(this).height($(this).height());
		});
		return ui;
	};

	var copyTR = null;
	var startIdx = 0;

	var idStr = "#choiceTable0";
	jQuery(idStr + " tbody tr").bind("mousedown", function(e) {
		copyTR = jQuery(this).next("tr.Spacing");
	});
	
    jQuery(idStr + " tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
        helper: fixHelper, // 调用fixHelper
        axis: "y",
        start: function(e, ui) {
            ui.helper.addClass("e8_hover_tr") // 拖动时的行，要用ui.helper
            if(ui.item.hasClass("notMove")) {
            	e.stopPropagation && e.stopPropagation();
            	e.cancelBubble = true;
            }
            if(copyTR) {
       			copyTR.hide();
       		}
       		startIdx = ui.item.get(0).rowIndex;
            return ui;
        },
        stop: function(e, ui) {
            ui.item.removeClass("e8_hover_tr"); // 释放鼠标时，要用ui.item才是释放的行
        	if(ui.item.get(0).rowIndex < 1) { // 不能拖动到表头上方

                if(copyTR) {
           			copyTR.show();
           		}
        		return false;
        	}
           	if(copyTR) {
	       	  	/* if(ui.item.get(0).rowIndex > startIdx) {
	        	  	ui.item.before(copyTR.clone().show());
				}else {
	        	  	ui.item.after(copyTR.clone().show());
				} */
				if(ui.item.prev("tr").attr("class") == "Spacing") {
					ui.item.after(copyTR.clone().show());
				}else {
					ui.item.before(copyTR.clone().show());
				}
	       	  	copyTR.remove();
	       	  	copyTR = null;
       		}
           	return ui;
        }
    });
}


var choicerowindex = 1;
	function checklength(elementname,spanid){
		tmpvalue = $G(elementname).value;
		while(tmpvalue.indexOf(" ") == 0)
			tmpvalue = tmpvalue.substring(1,tmpvalue.length);
		if(tmpvalue!=""&&tmpvalue!=0){
			 $G(spanid).innerHTML='';
		}
		else{
		 $G(spanid).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		 $G(elementname).value = "";
		}
	}
	function addoTableRow(){
	  rowColor1 = "";
	  obj = document.getElementById("choiceTable0");
		ncol=obj.rows[0].cells.length;
		oRow = obj.insertRow(-1);
		jQuery(oRow).addClass("DataDark");
		for(i=0; i<ncol; i++){
			oCell1 = oRow.insertCell(i);
			switch(i){
				case 0:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<input type='checkbox' id='chkField_"+choicerowindex+"' name='chkField' index='"+choicerowindex+"' value='1'>"+
					             "<input class='Inputstyle' type='hidden' size='4' value = '0.00' id='field_count_name_"+choicerowindex+"' name='field_count_name_"+choicerowindex+"' > "+
					             "&nbsp;<img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>' />";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 1:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<input class='Inputstyle' type='text' id='field_name_"+choicerowindex+"' name='field_name_"+choicerowindex+"' "+
									" onchange=checkinput('field_name_"+choicerowindex+"','field_span_"+choicerowindex+"')>"+
								 " <span id='field_span_"+choicerowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;

				case 2:
					var oDiv1 = document.createElement("div");
					var sHtml1 = " <input type='checkbox' name='field_checked_name_"+choicerowindex+"' onclick='if(this.checked){this.value=1;}else{this.value=0}'>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
				case 3:

                var oDiv1 = document.createElement("div");
				var sHtml1 = "<input type='checkbox' id='isAccordToSubCom"+choicerowindex+"' name='isAccordToSubCom"+choicerowindex+"' value='1' ><%=SystemEnv.getHtmlLabelName(22878,user.getLanguage())%>&nbsp;&nbsp;"
							+ "<input type='hidden' id='selectvalue"+choicerowindex+"' name='selectvalu"+choicerowindex+"' value='' />"
							+ "<span  id='maincategory_"+choicerowindex+"' name='maincategory_"+choicerowindex+"' ></span>"
						    + "<input type=hidden id='pathcategory_"+choicerowindex+"' name='pathcategory_"+choicerowindex+"' value=''>";
						   

				oDiv1.innerHTML = sHtml1;
				oCell1.appendChild(oDiv1);
				 jQuery("#maincategory_"+choicerowindex).e8Browser({
                 name:"maincategory_"+choicerowindex,
                 viewType:"0",
                 browserValue:"",
                 isMustInput:"1",
                 browserSpanValue:"",
                 hasInput:true,
                 linkUrl:"#",
                 isSingle:true,
                 completeUrl:"/data.jsp?type=categoryBrowser&onlySec=true",
				 getBrowserUrlFn:'onShowCatalog',
				 getBrowserUrlFnParams:''+choicerowindex,
				 _callback:"afterSelect",
				 _callbackParams:choicerowindex,
         
                 width:"60%",
                 hasAdd:false,
                 isSingle:true
                 });

				
				break;

					
				case 4:
                	/*
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<BUTTON type='button' class=\"Browser\" onClick=\"onShowChildSelectItem('childItemSpan"+choicerowindex+"', 'childItem"+choicerowindex+"')\" id=\"selectChildItem"+choicerowindex+"\" name=\"selectChildItem"+choicerowindex+"\"></BUTTON>"
								+ "<input type=\"hidden\" id=\"childItem"+choicerowindex+"\" name=\"childItem"+choicerowindex+"\" value=\"\" >"
								+ "<span id=\"childItemSpan"+choicerowindex+"\" name=\"childItemSpan"+choicerowindex+"\"></span>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
	                */
	                var oDiv = document.createElement("div");
	                var sHtml = "<div style='float:left; display:inline;width:25px;' class='childItemDiv'>"
	                            + "\r\n<span  id='childItem"+choicerowindex+"' name='childItem"+choicerowindex+"' ></span>"
	                            + "\r\n</div><span id=\"childItemSpan"+choicerowindex+"\" class=\"childItemSpan\" name=\"childItemSpan"+choicerowindex+"\"></span>";
	                oDiv.innerHTML = sHtml;
	                oCell1.appendChild(oDiv);
	                jQuery("#childItem"+choicerowindex).e8Browser({
	                   name:"childItem"+choicerowindex,
	                   viewType:"0",
	                   browserValue:"",
	                   isMustInput:"1",
	                   browserSpanValue:"",
	                   getBrowserUrlFn:"showChildSelectItem",
	                   getBrowserUrlFnParams:''+choicerowindex,
	                   _callback:"selectChildSelectItem",
	                   _callbackParams:choicerowindex,
	                   hasInput:false,
	                   isSingle:false,
	                   hasBrowser:true,
	                   width:"25px",
	                   hasAdd:false
	                   });
					break;
				case 5:
					var oDiv1 = document.createElement("div");
					var sHtml1 = "<input type='checkbox' name='field_cancel_"+choicerowindex+"' id='field_cancel_"+choicerowindex+"' value='1'>";
					oDiv1.innerHTML = sHtml1;
					oCell1.appendChild(oDiv1);
					break;
			}		
		}
		//var tr_spacing = jQuery("<tr class='Spacing' style='height:1px!important;'><td colspan=6 class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>");
		//jQuery("#choiceTable0").append(tr_spacing);
		choicerowindex++;
		jQuery("#choiceTable0").jNice();
	}

		
	function submitClear(){
		//检查是否选中要删除的数据项
		var flag = false;
		var col = document.getElementsByName("chkField");
		for(var i = 0; i<col.length; i++){
			if(col[i] && col[i].checked){
				flag = true;
				break;
			}
		}
		if(flag){
			//if (isdel()){
			//	deleteRow1();
			//}
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				deleteRow1();
			}, function () {}, 320, 90,true);
			
		} else {
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>");
			return false;
		}
	}
	function deleteRow1(){
		$("input[name=chkField]").each(function(){
			if($(this).attr("checked")){
				$(this).closest("tr").remove();
			}
		});
	}
function onShowCatalog(choicerowindex){
    var url="";
	var isAccordToSubCom=0;	
	if(document.getElementById("isAccordToSubCom"+choicerowindex)!=null){
		if(document.getElementById("isAccordToSubCom"+choicerowindex).checked){
			isAccordToSubCom=1;
		}
	}
	if(isAccordToSubCom==1){
		url=onShowCatalogSubCom(choicerowindex);
	}else{
		url=onShowCatalogHis(choicerowindex);
	}
	return url;
}
function afterSelect(e,rt,name,choicerowindex){
var docsec=rt.mainid+","+rt.subid+","+rt.id ;
    jQuery("input[name=maincategory_"+choicerowindex+"]").val(docsec);		
jQuery("input[name=pathcategory_"+choicerowindex+"]").val(jQuery("span[name=maincategory_"+choicerowindex+"span]").text() );   

}
function onShowCatalogHis(choicerowindex) {	
	   
	 return "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";   





}

function onShowCatalogSubCom(index) {

if (jQuery( "#selectvalue"+index).length>0)  {
	jQuery("#openrownum").val(index);
	submitData();
}
	
}

	var dbnamesForCompare = "<%=dbnamesForCompare_main%>";
	function submitData(){
		if(check_form(form1,"fieldname,fieldlabelname")){
			fieldhtmltype = $G("FieldHtmlType").value;
			documentType = $G("DocumentType").value;
			if(fieldhtmltype==1&&documentType==1&&$G("itemFieldScale1").value==""){//单行文本框——文本时，文本长度必填。
				top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
				return;
			}
			
						
			if(fieldhtmltype==5){
			
			    var selectItemType = jQuery("#selectItemType").val();
			    if(selectItemType==0){
			    	for(var tempchoiceRows=1; tempchoiceRows<=choicerowindex; tempchoiceRows++){
						if($G("field_name_"+tempchoiceRows)&&$G("field_name_"+tempchoiceRows).value==""){//选择框的可选项文字必填
							top.Dialog.alert("<%=SystemEnv.getHtmlNoteName(14,user.getLanguage())%>");
							return;
						}
					}
					if(document.getElementById("choiceTable0")){
						$G("choiceRows_rows").value=choicerowindex;
						
						var disorder = 0;
						jQuery("input[name^=field_count_name_]").each(function(){
							jQuery(this).val(disorder);
							disorder++;
						});
					}
			    }else if(selectItemType==1){
			    	if(!check_form(form1,"pubchoiceId")){
			    		return;
			    	}
			    }else if(selectItemType==2){
			    	if(!check_form(form1,"pubchilchoiceId")){
			    		return;
			    	}
			    }
				
			}
			if(fieldhtmltype==3){
				if(document.getElementById("browsertype").value==''){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    return;
				}
				if(document.getElementById("browsertype").value==161||document.getElementById("browsertype").value==162){
					if(document.getElementById("definebroswerType").value==""){
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
					}
				}
				if(document.getElementById("browsertype").value==256||document.getElementById("browsertype").value==257){
					if(document.getElementById("defineTreeBroswerType").value==""){
						top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
					}
				}
			    if(document.getElementById("browsertype").value==224){
			    	if(document.getElementById("sapbrowser").value==""){
			    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
			    	}
				}
				//必要信息不完整
				if(document.getElementById("browsertype").value==226||document.getElementById("browsertype").value==227){
			    	if(document.getElementById("showvalue").value==""){
			    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
			    	}
				}
				
				if(document.getElementById("browsertype").value==165||document.getElementById("browsertype").value==166||document.getElementById("browsertype").value==167||document.getElementById("browsertype").value==168){
			    	if(document.getElementById("decentralizationbroswerType").value==""){
			    		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				    	return;
			    	}
				}				
				
			}
			var fieldname = $G("fieldname").value;
			fieldnamenew = fieldname.toUpperCase();
			if (!checkKey())  return false;
			var updateTableName = $G("updateTableName").value;
			if(updateTableName.indexOf("_dt")>0){
				if(fieldnamenew=="ID"||fieldnamenew=="MAINID"){
					top.Dialog.alert(fieldname+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("fieldname").select();
					return;
				}
			}else{
				if(fieldnamenew=="ID"||fieldnamenew=="REQUESTID"){
					top.Dialog.alert(fieldname+"<%=SystemEnv.getHtmlLabelName(21810,user.getLanguage())%>");
					$G("fieldname").select();
					return;
				}
			}
			if(updateTableName.indexOf("_dt")<0 && dbnamesForCompare.indexOf(","+fieldname.toUpperCase()+",")>=0){
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
				return;
			}else if(updateTableName.indexOf("_dt")>0){
				var dbnamesForCompareDetail = document.getElementById(updateTableName).value;
				if(dbnamesForCompareDetail.indexOf(","+fieldname.toUpperCase()+",")>=0){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15024,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18082,user.getLanguage())%>");
				return;
				}
			}
			
			//对选择框中的欧元符号进行特殊处理
			if(fieldhtmltype==5){
				for(var i=1; i<=choicerowindex; i++){
					var myObj = document.getElementById("field_name_" + i);
					if(myObj){
						myObj.value = dealSpecial(myObj.value);
					}
				}
			}
			form1.submit();
		}
	}

	//对特殊符号进行处理
	function dealSpecial(val){
		//本字符串是欧元符号的unicode码, GBK编辑中不支持欧元符号(需更改为UTF-8), 故只能使用unicode码
		var euro = "\u20AC";
		//本字符串是欧元符号在HTML中的特别表现形式
		var symbol = "&euro;";
		var reg = new RegExp(euro);
		while(val.indexOf(euro) != -1){
			val = val.replace(reg, symbol);
		}  
		return val;
	}
	
	function checkKey()
	{
	var keys=",PERCENT,PLAN,PRECISION,PRIMARY,PRINT,PROC,PROCEDURE,PUBLIC,RAISERROR,READ,READTEXT,RECONFIGURE,REFERENCES,REPLICATION,RESTORE,RESTRICT,RETURN,REVOKE,RIGHT,ROLLBACK,ROWCOUNT,ROWGUIDCOL,RULE,SAVE,SCHEMA,SELECT,SESSION_USER,SET,SETUSER,SHUTDOWN,SOME,STATISTICS,SYSTEM_USER,TABLE,TEXTSIZE,THEN,TO,TOP,TRAN,TRANSACTION,TRIGGER,TRUNCATE,TSEQUAL,UNION,UNIQUE,UPDATE,UPDATETEXT,USE,USER,VALUES,VARYING,VIEW,WAITFOR,WHEN,WHERE,WHILE,WITH,WRITETEXT,EXCEPT,EXEC,EXECUTE,EXISTS,EXIT,FETCH,FILE,FILLFACTOR,FOR,FOREIGN,FREETEXT,FREETEXTTABLE,FROM,FULL,FUNCTION,GOTO,GRANT,GROUP,HAVING,HOLDLOCK,IDENTITY,IDENTITY_INSERT,IDENTITYCOL,IF,IN,INDEX,INNER,INSERT,INTERSECT,INTO,IS,JOIN,KEY,KILL,LEFT,LIKE,LINENO,LOAD,NATIONAL,NOCHECK,NONCLUSTERED,NOT,NULL,NULLIF,OF,OFF,OFFSETS,ON,OPEN,OPENDATASOURCE,OPENQUERY,OPENROWSET,OPENXML,OPTION,OR,ORDER,OUTER,OVER,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUTHORIZATION,BACKUP,BEGIN,BETWEEN,BREAK,BROWSE,BULK,BY,CASCADE,CASE,CHECK,CHECKPOINT,CLOSE,CLUSTERED,COALESCE,COLLATE,COLUMN,COMMIT,COMPUTE,CONSTRAINT,CONTAINS,CONTAINSTABLE,CONTINUE,CONVERT,CREATE,CROSS,CURRENT,CURRENT_DATE,CURRENT_TIME,CURRENT_TIMESTAMP,CURRENT_USER,CURSOR,DATABASE,DBCC,DEALLOCATE,DECLARE,DEFAULT,DELETE,DENY,DESC,DISK,DISTINCT,DISTRIBUTED,DOUBLE,DROP,DUMMY,DUMP,ELSE,END,ERRLVL,ESCAPE,";
	//以下for oracle.update by cyril on 2008-12-08 td:9722
	keys+="ACCESS,ADD,ALL,ALTER,AND,ANY,AS,ASC,AUDIT,BETWEEN,BY,CHAR,"; 
	keys+="CHECK,CLUSTER,COLUMN,COMMENT,COMPRESS,CONNECT,CREATE,CURRENT,";
	keys+="DATE,DECIMAL,DEFAULT,DELETE,DESC,DISTINCT,DROP,ELSE,EXCLUSIVE,";
	keys+="EXISTS,FILE,FLOAT,FOR,FROM,GRANT,GROUP,HAVING,IDENTIFIED,";
	keys+="IMMEDIATE,IN,INCREMENT,INDEX,INITIAL,INSERT,INTEGER,INTERSECT,";
	keys+="INTO,IS,LEVEL,LIKE,LOCK,LONG,MAXEXTENTS,MINUS,MLSLABEL,MODE,";
	keys+="MODIFY,NOAUDIT,NOCOMPRESS,NOT,NOWAIT,NULL,NUMBER,OF,OFFLINE,ON,";
	keys+="ONLINE,OPTION,OR,ORDER,PCTFREE,PRIOR,PRIVILEGES,PUBLIC,RAW,";
	keys+="RENAME,RESOURCE,REVOKE,ROW,ROWID,ROWNUM,ROWS,SELECT,SESSION,";
	keys+="SET,SHARE,SIZE,SMALLINT,START,SUCCESSFUL,SYNONYM,SYSDATE,TABLE,";
	keys+="THEN,TO,TRIGGER,UID,UNION,UNIQUE,UPDATE,USER,VALIDATE,VALUES,";
	keys+="VARCHAR,VARCHAR2,VIEW,WHENEVER,WHERE,WITH,";
    var fname=window.document.forms[0].fieldname.value;
	if (fname!="")
		{fname=","+fname.toUpperCase()+",";
	if (keys.indexOf(fname)>0)
		{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(19946,user.getLanguage())%>');
		window.document.forms[0].fieldname.focus();
        return false;
	    }
		}
	return true;
	}
	function deleteData(){
		if (isdel()){
			$G("src").value="deleteField";
			form1.submit();
		}
	}
	function OnChangeFieldHtmlType(){
		var fieldHtmlType = $G("FieldHtmlType").value;
		jQuery("#choicediv").hide();
		if(fieldHtmlType==1){
			document.getElementById("div1").style.display="inline";
			document.getElementById("div1_1").style.display="inline";
			document.getElementById('DocumentType').selectedIndex=0;
			jQuery("#DocumentType").selectbox("detach");
			jQuery("#DocumentType").selectbox("attach");
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==2){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="inline";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==3){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="inline";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		   	document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		    if(document.getElementById("browsertype").value==224){
		    	document.getElementById("div3_4").style.display="inline";
		    	if(document.getElementById("sapbrowser").value==""){
		    		document.getElementById("div3_1").style.display="inline";
		    	}
			}
			if(document.getElementById("browsertype").value==226||document.getElementById("browsertype").value==227){
		    	document.getElementById("div3_5").style.display="inline";
		    	document.getElementById("div3_1").style.display="none";
		    	if(document.getElementById("showvalue").value==""){
		    		document.getElementById("showimg").style.display="inline";
		    	}
			}
			jQuery('#div3 select').autoSelect();
			OnChangeBrowserType();
		}
		if(fieldHtmlType==4){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==5){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="inline";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		    
		    setSelectItemType();
		    
		    var selectItemType =jQuery("#selectItemType").val();
		    if(selectItemType==0){
		    	jQuery("#choicediv").show();
		    }		    
		}
		if(fieldHtmlType==8){//公共选择项
			jQuery("#selectType").val("");
			jQuery("#selectTypeSpan").val("");
			jQuery("#childCommonItem").val("");
			jQuery("#childCommonItemSpan").html("");
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="inline";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		}
		if(fieldHtmlType==6){
            //document.getElementById("strlength").value='5';
            //document.getElementById("imgwidth").value='100';
            //document.getElementById("imgheight").value='100';
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="inline";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
		    $("#uploadtype").selectbox("detach");
            document.getElementById("uploadtype").options[0].selected=true;
		    $("#uploadtype").selectbox("attach");
		}
		if(fieldHtmlType==7){
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none"
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="inline";
		    document.getElementById("div7_1").style.display="";
		    document.getElementById("div7_2").style.display="none";
		    document.getElementById("div9").style.display="none";
		    //document.getElementById("div9_1").style.display="none";
            document.getElementById("specialfield").options[0].selected=true;
		}
		if(fieldHtmlType==9){
			document.getElementById("div9").style.display="inline";
			//document.getElementById("div9_1").style.display="inline";
			document.getElementById('DocumentType').selectedIndex=0;
			jQuery("#DocumentType").selectbox("detach");
			jQuery("#DocumentType").selectbox("attach");
			document.getElementById("div1").style.display="none";
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
			document.getElementById("div2").style.display="none";
			document.getElementById("div3").style.display="none";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="none";
			document.getElementById("div5").style.display="none";
			document.getElementById("div8").style.display="none";
            document.getElementById("div6").style.display="none";
		    document.getElementById("div6_1").style.display="none";
		    document.getElementById("div7").style.display="none";
		    document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="none";
		}
		
	}
	
	
	
    function onuploadtype(obj){
        if(obj.value==1){
            document.getElementById("div6_1").style.display="none";
        }else{
            document.getElementById("div6_1").style.display="";
        }
    }
    function specialtype(obj){
        if(obj.value==1){
            document.getElementById("div7_1").style.display="";
		    document.getElementById("div7_2").style.display="none";
        }else{
            document.getElementById("div7_1").style.display="none";
		    document.getElementById("div7_2").style.display="";
        }
    }
	function OnChangeDocumentType(){
		var documentType = document.getElementById("DocumentType").value;
		if(documentType==1){
			document.getElementById("div1_1").style.display="inline";
			document.getElementById("div1_3").style.display="none";
		}else if(documentType==3){
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="inline";
		}else if(documentType==5){
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="inline";
		}
		else{
			document.getElementById("div1_1").style.display="none";
			document.getElementById("div1_3").style.display="none";
		}
	}
	function OnChangelocationType(){
/*		var locationType = document.getElementById("locationType").value;
		if(locationType == 1){
			document.getElementById("div9_1").style.display = "inline";
		}*/
	}
	function OnChangeBrowserType(){
		var browserType = $G("browsertype").value;
		document.getElementById("div3_7").style.display="none";
		if(browserType==161||browserType==162){
			document.getElementById("div3_2").style.display="inline";
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}else if(browserType==256||browserType==257){
		    document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
			document.getElementById("div3_7").style.display="inline";
		}else if(browserType==224||browserType==225){
				document.getElementById("div3_4").style.display="inline"
				document.getElementById("div3_5").style.display="none";
				var sapbrowserOptionValue = document.getElementById("sapbrowser").value;
				if(sapbrowserOptionValue==''||sapbrowserOptionValue==0){
				    document.getElementById("div3_1").style.display="inline";
				}else{
				    document.getElementById("div3_1").style.display="none";
				}
				document.getElementById("div3_2").style.display="none";
				document.getElementById("div3_3").style.display="none";
		}else if(browserType==226||browserType==227){
				document.getElementById("div3_4").style.display="none";
				document.getElementById("div3_5").style.display="inline";
				var sapbrowserOptionValue = document.getElementById("showvalue").value;
				if(sapbrowserOptionValue==''){
				    document.getElementById("showimg").style.display="inline";
				}else{
				    document.getElementById("showimg").style.display="none";
				}
				document.getElementById("div3_1").style.display="none";
				document.getElementById("div3_2").style.display="none";
				document.getElementById("div3_3").style.display="none";
		}
		else if(browserType==165||browserType==166||browserType==167||browserType==168){
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="inline";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}else{
			document.getElementById("div3_1").style.display="none";
			document.getElementById("div3_2").style.display="none";
			document.getElementById("div3_3").style.display="none";
			document.getElementById("div3_4").style.display="none";
			document.getElementById("div3_5").style.display="none";
		}
		if (browserType == '') {
       		jQuery('#div3 #selecthtmltypespan').show();
       	} else {
       		jQuery('#div3 #selecthtmltypespan').hide();
       	}
       	BTCOpen();
	}
	
	
	 function BTCOpen(){
	        var btcspan = $("#browsertype_autoSelect");
	        btcspan.attr("id","browsertype_autoSelect2");
	        btcspan = $("#browsertype_autoSelect2");
	        btcspan.attr("name","browsertype_autoSelect2");
            //清空已有BTC对象
            var btc = new BTC();

            var tempBtc;
            while(tempBtc = BTCArray.shift()){
              btcspan.find(".sbToggle").removeClass("sbToggle-btc-reverse")
              tempBtc.remove();
            }
            <%
            if (HrmUserVarify.checkUserRight("SysadminRight:Maintenance", user)){ 
            %>
            btcspan.next(".btc_type_edit").remove();
            btcspan.after("<img onclick='setBTC()' style='cursor:pointer;' class='btc_type_edit' src='/images/ecology8/workflow/setting_wev8.png'>");
    	    <%}%>
    	    
    	    //浏览框类型选择框处理
            btcspan.find(".sbToggle").addClass("sbToggle-btc");
            btcspan.find(".sbToggle").unbind("click");
            btcspan.find(".sbSelector").unbind("focus");
            btcspan.find(".sbSelector").unbind("click"); 
            btcspan.find(".sbSelector").unbind("blur");  
            btcspan.find(".sbSelector").css("font-size","12px");  
            btcspan.find(".sbSelector").css("text-indent","0");     
            btcspan.find(".sbSelector").bind("focus",function(){
				    if(btcspan.find(".sbToggle").hasClass("sbToggle-btc-reverse")){
				       if(BTCArray.length>0){
				       	btcspan.find(".sbToggle").trigger("click");
				       }
				    };
			});
			
			btcspan.find(".sbToggle").bind("click",function(){
			   if(btcspan.find(".sbToggle").hasClass("sbToggle-btc-reverse")){
               	  btc.remove();
			   }else{
			   	  btc.init({
				  renderTo:btcspan,
			      headerURL:"/workflow/field/BTCAjax.jsp?action=queryHead",
				  contentURL:"/workflow/field/BTCAjax.jsp?action=queryContent&isFromMode=<%=isFromMode%>",
				  contentHandler:function(value){
					    $("#browsertype").val(value);
					    $("#browsertype").trigger("change");
					    btc.remove();
					    $(".sbToggle-btc-reverse").removeClass("sbToggle-btc-reverse");
				  }
			  	  });  
			  	  try{
			   	  	 $("#e8_autocomplete_div").hide();			
		          }catch(e){}
			   }
			   btcspan.find(".sbToggle").toggleClass("sbToggle-btc-reverse");
			});
			btcspan.attr("id","browsertype_autoSelect3");
    }    
    function setBTC(){
            var url = "/systeminfo/BrowserMain.jsp?url=/workflow/field/browsertypesetting.jsp?isFromMode=<%=isFromMode%>";
            var dlg=new window.top.Dialog();//定义Dialog对象
			var title = "<%=SystemEnv.getHtmlLabelName(125117, user.getLanguage())%>";
			dlg.Width=550;//定义长度
			dlg.Height=600;
			dlg.URL=url;
			dlg.Title=title;
			dlg.show();
    }
    
	function onfirmhtml(){
		if ($G("htmledit").checked==true){
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(20867,user.getLanguage())%>');
			$G("htmledit").value=2;
		}
	}
	function OnChangeDefineTreeBroswerType(id){
		if ($G(id).value==""){
			document.getElementById("div3_1").style.display="inline";
		}else{
			document.getElementById("div3_1").style.display="none";
		}
	}
	function OnChangeSapBroswerType(){
		if ($G("sapbrowser").value==""){
			document.getElementById("div3_1").style.display="inline"
		}else{
			document.getElementById("div3_1").style.display="none"
		}
	}
	
	function cancelDialog(){
		dialog.close();
	}
	
	function OnNewChangeSapBroswerTypeCallback(temp){
		
		if(temp){
			
			document.getElementById("showimg").style.display="none"
			$G("showvalue").value=temp;
			$G("showinner").innerHTML=temp;
		}
	}
	
	function OnNewChangeSapBroswerType(){
	
		var updateTableName=$G("updateTableName").value;//得到主表或明细表的名字
		var browsertype=$G("browsertype").value;
		var mark=$G("showinner").innerHTML;
		var left = Math.ceil((screen.width - 1086) / 2);   //实现居中
	    var top = Math.ceil((screen.height - 600) / 2);  //实现居中
		var tempstatus = "dialogWidth:1086px;dialogHeight:600px;dialogLeft:"+left+";dialogTop:"+top;+"scroll:yes;status:no;";
		var urls = "/integration/browse/integrationBrowerMain.jsp?browsertype="+browsertype+"&mark="+mark+"&formid=<%=formid%>&updateTableName="+updateTableName;
		
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "SAP";
	    dialog.URL = urls;
		
		dialog.maxiumnable = true;
		dialog.DefaultMax=true;
		dialog.callbackfun=OnNewChangeSapBroswerTypeCallback;
		//dialog.callbackfunParam={obj:obj};
		dialog.textAlign = "center";
		dialog.show();
		
	}
	
	function OnChangeUploadField(val){
		if(val == "0"){
			document.getElementById("div6_1_1").style.display="inline";
			$G("imgwidth").value = "100";
			$G("imgheight").value = "100";
		}else{
		    document.getElementById("div6_1_1").style.display="none";
		    $G("imgwidth").value = "50";
			$G("imgheight").value = "50";
		}
	}
	
	function OnChangeUpdateTableName(obj){
        FieldHtmlType = document.getElementById("FieldHtmlType");
        //主表
        if(obj.value=="<%=maintable%>"){
           for(var count = FieldHtmlType.options.length - 1; count >= 0; count--){
	           FieldHtmlType.options[count] = null;
           }
           <%=mainselect%>
           
           OnChangeUploadField("0");
           
           $(FieldHtmlType).selectbox("detach");
           $(FieldHtmlType).selectbox("attach");
           $("li a[title='<%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%>']").parent().show(); 
           $("li a[title='<%=SystemEnv.getHtmlLabelName(21691, user.getLanguage())%>']").parent().show();            
           $G("FieldHtmlType").value = "1";
           OnChangeFieldHtmlType(); 
           $G("DocumentType").value = "1";
           OnChangeDocumentType();
           //明细表中的多行文本框字段html格式可用
           $GetEle("htmledit").disabled = false;
        //明细表
        }else{
           for(var count = FieldHtmlType.options.length - 1; count >= 0; count--){
	           FieldHtmlType.options[count] = null;
           }
           <%=detailselect%>    
           
           OnChangeUploadField("1");
           $(FieldHtmlType).selectbox("detach");
           $(FieldHtmlType).selectbox("attach");
           $("li a[title='<%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%>']").parent().show(); 
           $("li a[title='<%=SystemEnv.getHtmlLabelName(21691, user.getLanguage())%>']").parent().hide();     
           $G("FieldHtmlType").value = "1";
           OnChangeFieldHtmlType();
           $G("DocumentType").value = "1";
           OnChangeDocumentType();
           //明细表中的多行文本框字段html格式不可用
           $GetEle("htmledit").disabled = true;
        }
                        
        var updateTableName = $G("updateTableName").value;
		dbnamesForCompare = $G(updateTableName).value;
	}
	/*
	p（精度）
	指定小数点左边和右边可以存储的十进制数字的最大个数。精度必须是从 1 到最大精度之间的值。最大精度为 38。
	
	s（小数位数）
	指定小数点右边可以存储的十进制数字的最大个数。小数位数必须是从 0 到 p 之间的值。默认小数位数是 0，因而 0 <= s <= p。最大存储大小基于精度而变化。
	*/
	function checkDigit(elementName,p,s){
		tmpvalue = document.getElementById(elementName).value;
	
	    var len = -1;
	    if(elementName){
			len = tmpvalue.length;
	    }
	
		var integerCount=0;
		var afterDotCount=0;
		var hasDot=false;
	
	    var newIntValue="";
		var newDecValue="";
	    for(i = 0; i < len; i++){
			if(tmpvalue.charAt(i) == "."){ 
				hasDot=true;
			}else{
				if(hasDot==false){
					integerCount++;
					if(integerCount<=p-s){
						newIntValue+=tmpvalue.charAt(i);
					}
				}else{
					afterDotCount++;
					if(afterDotCount<=s){
						newDecValue+=tmpvalue.charAt(i);
					}
				}
			}		
	    }
	
	    var newValue="";
		if(newDecValue==""){
			newValue=newIntValue;
		}else{
			newValue=newIntValue+"."+newDecValue;
		}
	    document.getElementById(elementName).value=newValue;
	}
	function getIsDetail(){
		var updateTableName = document.getElementById("updateTableName").value;
		var isdetail = "0";
		if(updateTableName.indexOf("_dt") > -1){
			isdetail = "1";
		}
		return isdetail;
	}
	function getDetailTableSql(){
		var updateTableName = document.getElementById("updateTableName").value;
		var detailTableSql = "";
		if(updateTableName.indexOf("_dt") > -1){
			detailTableSql = " and detailtable='"+updateTableName+"' ";
		}
		return detailTableSql;
	}
	function onChangeChildField(){
		var rownum = parseInt(choicerowindex);
		for(var i=0; i<rownum; i++){
			var inputObj = $G("childItem"+i);
			var spanObj = $G("childItemSpan"+i);
			try{
				if(inputObj!=null && spanObj!=null){
					inputObj.value = "";
					spanObj.innerHTML = "";
				}
			}catch(e){}
		}
	}
	
function onShowChildSelectItem(spanname, inputname){
	var cfid = $G("childfieldid").value;
	var resourceids = $G(inputname).value;
	var isdetail = getIsDetail();
	var url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
	var id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		if (rid != "") {
			var resourceids = rid.substr(1);
			var resourcenames = rname.substr(1);
			if(resourcenames.length > 8){
				resourcenames = resourcenames.substr(0,8)+"...";
			}
			
			$G(inputname).value = resourceids;
			$G(spanname).innerHTML = resourcenames;
		} else {
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}	

function onShowChildField(spanname, inputname) {
    oldvalue = inputname.value;
    isdetail = getIsDetail();
    detailTableSql = getDetailTableSql();
    url = escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>" + detailTableSql + "&isdetail=" + isdetail + "&isbill=1");
    id = showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (id) {
        if (wuiUtil.getJsonValueByIndex(id,0)!= "") {
            inputname.value =wuiUtil.getJsonValueByIndex(id,0);
            spanname.innerHTML =wuiUtil.getJsonValueByIndex(id,1);
        } else {
            inputname.value = "";
            spanname.innerHTML = "";
        }
    }
    if (oldvalue != inputname.value) {
        onChangeChildField();
    }
}

var childfield_oldvalue = "";

function onShowChildField_new() {
    childfield_oldvalue = jQuery("#childfieldid").val();
    
    isdetail = getIsDetail();
    detailTableSql = getDetailTableSql();
    url = "/systeminfo/BrowserMain.jsp?url= " + escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>" + detailTableSql + "&isdetail=" + isdetail + "&isbill=1");
    return url;
}

function clearChildItem(){
    var childfield_value = jQuery("#childfieldid").val();
	if (childfield_oldvalue != childfield_value) {
        jQuery("input[name^='childItem']").each(function(){
        	jQuery(this).val("");
        });
        jQuery("span[name^='childItemSpan']").each(function(){
        	jQuery(this).html("");
        });
    }
}


function getDetailTableStr(){
	var updateTableName = document.getElementById("updateTableName").value;
	var detailTableStr = "";
	if(updateTableName.indexOf("_dt") > -1){
		detailTableStr = " &detailtable="+updateTableName+" ";
	}
	return detailTableStr;
}
	
function onShowPubchilchoiceId() {
    isdetail = getIsDetail();
    var detailtable = getDetailTableStr();
    url = "/workflow/selectItem/selectItemMain.jsp?topage=selectItemSupFieldBrowser&fieldhtmltype=5&billid=<%=formid%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1";
    return url;
}

function getcompleteurl(){
    isdetail = getIsDetail();
    var detailtable = getDetailTableStr();
    url = "/data.jsp?type=pubChoice&pubchild=1&fieldhtmltype=5&billid=<%=formid%>" + detailtable + "&isdetail=" + isdetail + "&isbill=1";
    return url;
}


function showChildSelectItem(choicerowindex){
    
    var cfid = $G("childfieldid").value;
    var resourceids = jQuery("#childItem" + choicerowindex).val();
    var isdetail = getIsDetail();
    var url= "/systeminfo/BrowserMain.jsp?url=" + escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail=" + isdetail + "&childfieldid=" + cfid + "&resourceids=" + resourceids);
    
    return url;
}
function selectChildSelectItem(e,rt,name,choicerowindex){

    if (rt != null) {
        var rid = rt.id;
        var rname = rt.name;
        if (rid != "") {
            var resourceids = rid.substr(1);
            var resourcenames = rname.substr(1);
            jQuery("#childItem" + choicerowindex).val(resourceids);  
            jQuery("#childItemSpan" + choicerowindex).html(resourcenames);  
            jQuery("#childItemSpan" + choicerowindex).attr("title",resourcenames);
        } else {
            jQuery("#childItem" + choicerowindex).val("");  
            jQuery("#childItemSpan" + choicerowindex).html("");  
            jQuery("#childItemSpan" + choicerowindex).removeAttr("title");
        }
    }

}
</script>
<script language="javascript" src="/js/browsertypechooser/btc_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/browsertypechooser/browserTypeChooser_wev8.css">
<script language="VBScript">
sub onShowChildField1(spanname, inputname)
	oldvalue = inputname.value
	isdetail = getIsDetail()
	detailTableSql = getDetailTableSql()
	url=escape("/workflow/workflow/fieldBrowser.jsp?sqlwhere=where fieldhtmltype=5 and billid=<%=formid%>"+detailTableSql+"&isdetail="+isdetail+"&isbill=1")
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			inputname.value = id(0)
			spanname.innerHtml = id(1)
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if
	if oldvalue <> inputname.value then
		onChangeChildField
	end if
end sub

sub onShowChildSelectItem1(spanname, inputname)
	cfid = form1.childfieldid.value
	resourceids = inputname.value
	isdetail = getIsDetail()
	url=escape("/workflow/field/SelectItemBrowser.jsp?isbill=1&isdetail="+isdetail+"&childfieldid="&cfid&"&resourceids="&resourceids)
	id = showModalDialog("/systeminfo/BrowserMain.jsp?url="&url)
	if Not isempty(id) then
		if id(0) <> "" then
			resourceids = id(0)
			resourcenames = id(1)
			resourceids = Mid(resourceids, 2, len(resourceids))
			resourcenames = Mid(resourcenames, 2, len(resourcenames))
			inputname.value = resourceids
			spanname.innerHtml = resourcenames
		else
			inputname.value = ""
			spanname.innerHtml = ""
		end if
	end if

end sub
</script>
