
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="weaver.conn.RecordSet"  %>
<%@ page import="weaver.general.GCONST"  %>
<%@ page import="weaver.docs.category.*" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.file.Prop"  %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:include page="/systeminfo/init_wev8.jsp"></jsp:include>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />

<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type="text/css" />
<link href='/css/Weaver_wev8.css' type=text/css rel=stylesheet>
<script type='text/javascript' src='/js/weaver_wev8.js'></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>	

<style>
body   {   
  overflow-y   :   auto   ;   
  overflow-x   :   hidden   ;   
    
  }
  table.ListStyle td.line1
		{
			height:1px!important;
			
		}
		table.ListStyle tr.line
		{
			height:1px!important;
			padding:0px!important;;
			margin:0px!important;;
		}
		table.ListStyle tr.line td
		{
			height:1px!important;
			padding:0px!important;;
			margin:0px!important;;
		}
	.spanWidth {
		display:-moz-inline-box;
		display:inline-block;
		width:80px; 
	
	}
	#sourceSpan a.sbSelector {
		width:120px;
	}
	
</style>
<%
	String titlename = SystemEnv.getHtmlLabelName(19480,user.getLanguage());
	String eid = Util.null2String(request.getParameter("eid"));
	String tabId = Util.null2String(request.getParameter("tabId"));
	String method = Util.null2String(request.getParameter("method"));
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	String tabTitle="";
	String browserVal = "";
	String type = "1";//外部数据源的方式，默认为1（从数据集成中选择）
	String ids = "";
	String addresses = "";
	String names = "";
	
	String pattern = "";
	String source = "";
	String area = "";
	String dataKey = "";
	String showfield = "";
	String showfieldname =  "";
	String isshowname = "";
	String transql = "";
	String wsurl = "";
	String wsOperation = "";
	String wsPara = "";
	String href= "";
	String outsysDef = "";
	String hreftitle = SystemEnv.getHtmlLabelName(82994,user.getLanguage());
	String helptitle = SystemEnv.getHtmlLabelName(82995,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82996,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82997,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82998,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82999,user.getLanguage())+
						SystemEnv.getHtmlLabelName(83889,user.getLanguage());
	String helptitle2 = SystemEnv.getHtmlLabelName(82995,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82996,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82997,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82998,user.getLanguage())+
						SystemEnv.getHtmlLabelName(82999,user.getLanguage());
	String helptitle3 = SystemEnv.getHtmlLabelName(83894,user.getLanguage());
	String helptitle4 = SystemEnv.getHtmlLabelName(131015,user.getLanguage());
	//集成登录地址
	ArrayList sysList = new ArrayList();
	ArrayList sysNameList = new ArrayList();
	String selOutSys = "select sysid,name from outter_sys where 1=1";
	rs.executeSql(selOutSys);
	while(rs.next()) {
		sysList.add(rs.getString("sysid"));
		sysNameList.add(rs.getString("name"));
	}
	
	//如果是编辑状态，先给出值
	if("edit".equals(method)) {
		String selectStr = "select * from hpOutDataTabSetting where eid="+eid + " and tabId="+tabId;
		rs.executeSql(selectStr);
		if(rs.next()) {
			type = rs.getString("type");
			tabTitle = rs.getString("title");
			if("1".equals(type)) {//从外部数据集成中选择
			
				String selectStr2 = "select sourceid,address from hpOutDataSettingAddr where eid="
					+eid + " and tabid="+tabId +" order by pos";
				rs2.executeSql(selectStr2);
				while(rs2.next()) {
					
					int id = rs2.getInt("sourceid");
					ids = ids + id +",";
					String address = Util.null2String(rs2.getString("address"));
					addresses = addresses + address + ",";
					String selName = "select name from datashowset where id="+id;
					rs3.executeSql(selName);
					if(rs3.next()) {
						names = names + rs3.getString("name") + ",";
					}
					
				}
				browserVal = names;
			} else if("2".equals(type)) {
				String selectStr2 = "select * from hpOutDataSettingDef where eid="
					+eid + " and tabid="+tabId +" order by id";
				rs2.executeSql(selectStr2);
				if(rs2.next()) {
					pattern = rs2.getString("pattern");
					source =  rs2.getString("source");
					area =  rs2.getString("area");
					dataKey =  rs2.getString("dataKey");
					wsurl = rs2.getString("wsaddress");
					wsOperation = rs2.getString("wsmethod");
					wsPara = rs2.getString("wspara");
					href =  rs2.getString("href");
					outsysDef = rs2.getString("sysaddr");
				}
				
				String selectStr3 = "select showfield,showfieldname,isshowname,transql from hpOutDataSettingField where eid="
				+eid + " and tabid="+tabId +" order by id";
				rs2.executeSql(selectStr3);
				while(rs2.next()) {
					showfield = showfield + Util.null2String(rs2.getString("showfield")) + ",";
					showfieldname = showfieldname + Util.null2String(rs2.getString("showfieldname")) + ",";
					isshowname = isshowname +  Util.null2String(rs2.getString("isshowname")) + ",";
					transql =  transql + Util.null2String(rs2.getString("transql")) + ",";
				}
			}
			
		}
	}
%>
	
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(19480,user.getLanguage()) %>"/>  
		</jsp:include>
		
		  <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
  
	  <%
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:Submit(),_self} " ;
	  RCMenuHeight += RCMenuHeightStep ;
	
	  %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
	<table id="topTitle" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td width="160px">
					</td>
					<td class="rightSearchSpan"
						style="text-align: right; width: 500px !important">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top"
							onclick="Submit();" />
						&nbsp;&nbsp;&nbsp;
						<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
<form action="tabOperation.jsp" id="form1" name="form1">
	<input type="hidden" name="tabId" value="<%=tabId %>"></input>
	<input type="hidden" name="eid" value="<%=eid %>"></input>
	<input type="hidden" name="method" value="<%=method %>"></input>
	<input type="hidden" name="tid" id="tid"></input>		
	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\",'samePair':'SetInfo','groupOperDisplay':'none'}">
			<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
	      <wea:item>
	      <!-- QC299099 [80][90]外部数据元素-标题带有特殊字符保存后，再次打开数据丢失问题 start -->
	      	<input  class=inputStyle id='tabTitle_<%=eid %>' type='text' name="tabTitle" value="<%=tabTitle %>" onblur="isExist('<%=tabTitle %>','<%=eid %>')"  onchange='checkinput("tabTitle_<%=eid %>","tabTitleSpan_<%=eid %>")' /><SPAN id='tabTitleSpan_<%=eid %>'>
		  <!-- QC299099 [80][90]外部数据元素-标题带有特殊字符保存后，再次打开数据丢失问题 end -->
			<%
			if(tabTitle.equals("")){
				%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%
			}
			%>
			</SPAN>
		    </wea:item>
		    

		   <wea:item>
		   		<%if(type.equals("1")) {%>
		   			<input type="radio" name="type" id="1" value="1" onclick="showDiv(this.id)" checked="checked"></input>&nbsp;<%=SystemEnv.getHtmlLabelName(81511,user.getLanguage())%> 
		   		<%} else {%>
		   			<input type="radio" name="type" id="1" value="1" onclick="showDiv(this.id)"></input>&nbsp;<%=SystemEnv.getHtmlLabelName(81511,user.getLanguage())%>
		   		<%} %>
		   		
		   </wea:item>
		   <wea:item>
		   <div class="div1">
		   		<%String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/page/element/OutData/dataBrowser.jsp?selectedids=";%>
			   	<brow:browser viewType="0" name="outdatas" 
			           browserUrl='<%= browserUrl %>' width="340px;"
			           isSingle="false" hasBrowser = "true" isMustInput='1' isAutoComplete='false'
			           afterDelCallback='deleteElement'   
			            _callback="clickBrowser" browserValue='<%= ids%>' browserSpanValue='<%= browserVal%>' hasInput="true">
			   	</brow:browser><span id="outdatasSpan">
			   	<%if(ids.equals("")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%}%>
			   	</span>
   				
		   </div>
		   </wea:item>
		    
		   <wea:item></wea:item>
		   <wea:item>
		   		<div class="div1" id="selectedOutDatas"></div>
		   </wea:item>
		  
		  	
		   <wea:item>
		   <%if(type.equals("2")) {%>
		   	 <input type="radio" name="type" id="2" value="2" onclick="showDiv(this.id)" checked="checked"></input>
		   	 <%=SystemEnv.getHtmlLabelName(32219,user.getLanguage())%>
		   	<%} else { %>
		   		 <input type="radio" name="type" id="2" value="2" onclick="showDiv(this.id)"></input>
		   	 	<%=SystemEnv.getHtmlLabelName(32219,user.getLanguage())%>
		   	<%} %>
		   </wea:item>
		   <wea:item>
		   <div class="div2">
		   
		   <span class="spanWidth"><%=SystemEnv.getHtmlLabelName(28006,user.getLanguage())%>:</span>
		   <select id="selector1" class=InputStyle style="width: 120px" onchange="showSelector(this);">
					<option value="1" <%if("1".equals(pattern)){ %>selected<%}%>><%=SystemEnv.getHtmlLabelName(15024, user.getLanguage()) %></option>
					<option value="2" <%if("2".equals(pattern)){ %>selected<%}%>>WebService</option>
					<option value="3" <%if("3".equals(pattern)){ %>selected<%}%>><%=SystemEnv.getHtmlLabelName(129993,user.getLanguage())%></option>
			</select>
			&nbsp;&nbsp;
			<span id="sourceSpan">
			
				<span style="display:-moz-inline-box;display:inline-block;width:50px;"><%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>:</span>
				<span><select id="sourceSelector" class=InputStyle name="sourceSelector" style='width:120px' onchange="changeSpan(this.id);">
						<option></option>
						<%
						    List datasourceList = DataSourceXML.getPointArrayList();
							for (int i = 0; i < datasourceList.size(); i++) {
								String pointid = Util.null2String((String) datasourceList.get(i));
								
						%>
						<option value="datasource.<%=pointid%>" <%if(("datasource."+pointid).equals(source)){ %>selected<%} %>><%=pointid%></option>
						<%
							}
						%>
				</select></span><span id="sourceSelectorSpan">
					<!-- 
					 <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
					 -->
				</span>
			
			</span>
			
			</div></wea:item>
			
		 <wea:item></wea:item>
		 <wea:item>
		 <div class="div2">
		 		<div id="webServiceMP">
		 		
				<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(110, user.getLanguage()) %>:</span>
				<input class=inputStyle id="webServiceAddr" name="webServiceAddr" onchange="checkinput('webServiceAddr','webServiceAddrSpan')">
				</input><span id="webServiceAddrSpan">
				<%if(wsurl.equals("")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%} %>
				</span>
				<br></br>
		 		<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(604, user.getLanguage()) %>:</span><!-- WebService方法名 -->
		 		<input  class=inputStyle id="webServiceMethod" name="webServiceMethod" onchange="checkinput('webServiceMethod','webServiceMethodSpan')">
		 		</input><span id="webServiceMethodSpan">
		 		<%if(wsOperation.equals("")) {%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%} %>
				</span>
		 		<br></br>
		 		<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(561, user.getLanguage()) %>:</span><!-- 参数名 -->
		 		<input class=inputStyle id="webServicePara" name="webServicePara" ></input>
		 		
		 		<%--  <span id="webServiceParaSpan">
		 		<%if(wsPara.equals("")) {%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%} %>
				</span> --%><SPAN style="CURSOR: hand" id=remind2 title="<%=helptitle3 %>"><IMG id=ext-gen124 title="<%=helptitle3 %>" align=absMiddle src="/images/remind_wev8.png"></SPAN>
		 		
		 		<br></br>
		 		</div>
		 		
		 		<div id="areaDiv">
				<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(33368,user.getLanguage())%>:</span>
				<textarea rows="3" id="area" name="area" onchange="checkinput('area','areaSpan')"></textarea>
				<span id="areaSpan">
				<%if(area.equals("")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%}%>
				</span>
				
				<SPAN style="CURSOR: hand" id=remind1 title="<%=hreftitle%><%=helptitle2 %>"><IMG id=ext-gen124 title="<%=hreftitle%><%=helptitle2 %>" align=absMiddle src="/images/remind_wev8.png"></SPAN>
				
				<br></br>
				</div>
				<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(21027,user.getLanguage())%>:</span>
				<input class=inputStyle id="dataKey" name="dataKey" onchange="checkinput('dataKey','dataKeySpan')"></input>
				<span id="dataKeySpan">
				<%if(dataKey.equals("")){%>
					<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
				<%}%>
				</span>
				<br></br>
				<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>:</span>
				<input class=inputStyle id="href" name="href" style="width:300px!important;"></input>
				<SPAN style="CURSOR: hand" id=remind2 title="<%=helptitle %>"><IMG id=ext-gen124 title="<%=helptitle %>" align=absMiddle src="/images/remind_wev8.png"></SPAN>
				<br></br>
				<span class="spanWidth"><%=SystemEnv.getHtmlLabelName(20961,user.getLanguage())%>:</span>
				<select id="outsysDef" name="outsysDef" style="width:270px!important;" value="<%=outsysDef %>">
						<option value=""></option>
					<%for(int i = 0; i < sysList.size(); i++) { 
						if(outsysDef.equals(sysList.get(i))) {%>
						<option  value="<%=sysList.get(i) %>" selected><%=sysNameList.get(i) %></option>
						<%} else {%>
							<option value="<%=sysList.get(i) %>"><%=sysNameList.get(i) %></option>
						<%}%>
					<%} %>
				</select>
				
		</div>
		</wea:item>
		
	    </wea:group>
    </wea:layout>
    
    <div id="fieldsetting">
    <wea:layout>
    	<wea:group context='<%=SystemEnv.getHtmlLabelName(21903,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\",'samePair':'SetInfo','groupOperDisplay':'none'}">
	    <wea:item>
		   <a href="#"><%=SystemEnv.getHtmlLabelName(32317, user.getLanguage())%></a><!-- 显示字段设置 -->
	  </wea:item>
	  <wea:item>
	  	<div style="float:right;">
				<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow2()" class="addbtn"/>
				<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="removeRow(2)" class="delbtn"/>
		</div>
	  </wea:item>
	  <wea:item attributes="{'samePair':'listparams listparams2 listparam','colspan':'2','isTableList':'true'}">
                 <TABLE class="ListStyle" id="oTable2" name="oTable2">
                   	<COLGROUP>
                     <COL width="6%">
                     <COL width="17%">
                     <COL width="17%">
                     <COL width="6%">
                     <COL width="20%">
                     <TR class="header">
                         <TD><INPUT type="checkbox" name="chkAll" id="chkAll" onClick="chkAllClick(this,2)"></TD>
                         <TD><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></TD><!-- 字段显示名 -->
                         <TD><%=SystemEnv.getHtmlLabelName(32320, user.getLanguage())%></TD><!-- 显示字段/XML路径 -->
                         <TD><%=SystemEnv.getHtmlLabelName(22965, user.getLanguage())%></TD><!-- 标题栏 -->
				<TD><%=SystemEnv.getHtmlLabelName(32321, user.getLanguage())%><SPAN style="CURSOR: hand" id=remind4 title="<%=helptitle4 %>"><IMG id=ext-gen124 title="<%=helptitle4 %>" align=absMiddle src="/images/remind_wev8.png"></SPAN></TD><!-- 转换方法 -->
                     </TR>
                     <TR style="height:1px;" class=line>
                      	<TD ColSpan=5 style="height:1px;"></TD>
                    	</TR>   		
                 </TABLE>
	  </wea:item>
	  <wea:item></wea:item>
	  <wea:item></wea:item>
	  <wea:item></wea:item>
	  <wea:item></wea:item>
    </wea:group>
    </wea:layout>
	</div>
	</form>	
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(128845,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
	    </wea:item>
	</wea:group>
	</wea:layout>
	</div>		
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
	
 	
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19480",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->SettingBrowser.jsp");
	}
	var dialog = null;
	try{
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
</script>
<script type="text/javascript">
	var needcheck = "";
	var browserData = "";
	$(document).ready(function(){
		
		if("add" == "<%=method%>") {
			showDiv("1");
			
		} else if("edit" == "<%=method%>") {
			if("<%=type%>" == "1") {
				showDiv("1");
				initAddr('<%=ids%>', '<%=names%>', '<%=addresses%>');
				
			} else {
				//document.getElementsByName("type")[0].value = "2";
				showDiv("2");
				init("2");
				
			}
		}
	});
	
	
	
	function showDiv(id) {
		var divID = "div"+id;
		$("."+divID).show();//显示一个div
		var otherDivID = "div";
		if(id == "1") {
			otherDivID = otherDivID+"2";
			$("#fieldsetting").hide();
		} else {
			
			otherDivID = otherDivID+"1";
			//默认选择SQL的方式，所以webservice的地址、参数默认隐藏
			//$("#webServiceSpan").hide();
			if($("#selector1").val() == "2") {
				$("#webServiceMP").show();
			} else {
				$("#webServiceMP").hide();
			}
			if($("#selector1").val() == "3") {
				$("#remind1").show();
			} else {
				$("#remind1").hide();
			}
			
			$("#fieldsetting").show();
		}
		$("."+otherDivID).hide();//隐藏另一个div
	
	}
	
	function showSelector(obj) {
		var prev = "<%=pattern%>";
		var v = $("#selector1  option:selected").val();
		//在切换模式的时候清空值
		$("#webServiceAddr").val("");
		$("#webServiceMethod").val("");
		$("#webServicePara").val("");
		$("#dataKey").val("");
		$("#area").val("");
		$("#sourceSelector").val("");
		$("#href").val("");
		
		if(v == "1") {
			$("#sourceSpan").show();
			$("#sourceSelector").val("");
		} else {
			$("#sourceSelector").val("");//清空值
			$("#sourceSpan").hide();
		}
		
		if(v == "2") {
			$("#areaDiv").hide();
			$("#webServiceMP").show();
		} else {
			$("#areaDiv").show();
			$("#webServiceMP").hide();
		}
		if(v == "3") {
			$("#remind1").show();
		} else {
			$("#remind1").hide();
		}
		if(prev == v) {
			 initVal();
		}
		//重新验证必填项
		checkinput('webServiceAddr','webServiceAddrSpan');
		checkinput('webServiceMethod','webServiceMethodSpan');
		//checkinput('webServicePara','webServiceParaSpan');
		checkinput('dataKey','dataKeySpan');
		checkinput('area','areaSpan');
		//checkinput('href','hrefSpan');
	}
	
	function addRow2() {
    	var order = "2";
    	var rownum = document.getElementById("oTable"+order).rows.length;
        var oRow = document.getElementById("oTable"+order).insertRow(rownum);
        var oRowIndex = oRow.rowIndex;

        if (0 == oRowIndex % 2)
        {
            oRow.className = "DataLight";
        }
        else
        {
            oRow.className = "DataDark";
        }
		
		/*============ 选择 ============*/
        var oCell = oRow.insertCell(0);
        var oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='paramids_"+order+"' value='-1'><INPUT type='hidden' name='type' value='"+order+"'>";
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();

        oCell = oRow.insertCell(1);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='fielnameSearchId_" + oRowIndex + "' name='fieldname2' onblur=\"checkinput('fielnameSearchId_" + oRowIndex + "','fieldnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%' value='' maxlength=50><span id='fieldnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
        oCell.appendChild(oDiv);

        oCell = oRow.insertCell(2);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='searchnameSearchId_" + oRowIndex + "' name='searchname2' _noMultiLang='true' value='' maxlength=200 onblur=\"checkinput('searchnameSearchId_" + oRowIndex + "','searchnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%'><span id='searchnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'><img src='/images/BacoError_wev8.gif' align='absmiddle'></span>";
        oCell.appendChild(oDiv);
        
        oCell = oRow.insertCell(3);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='' onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='0'>";                     
        oCell.appendChild(oDiv);
        jQuery(oCell).jNice();
        
        oCell = oRow.insertCell(4);
        oDiv = document.createElement("div");
        oDiv.innerHTML="<textarea class=\"InputStyle\" temptitle=\"<%=SystemEnv.getHtmlLabelName(32322, user.getLanguage())%>\" id=\"transql\" name=\"transql\" rows=\"3\" style=\"width:90%\"></textarea>";
        oCell.appendChild(oDiv);
       
  	}
    function removeRow(order)
    {
	    
	    var count = 0;//删除数据选中个数
		jQuery("input[name='paramid_"+order+"']").each(function(){
			if($(this).is(':checked')){
				count++;
			}
		});
	    
	    if(count==0){
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage()) %>");
		}else{
	    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
	        var chks = document.getElementsByName("paramid_"+order);
	       
	        for (var i = chks.length - 1; i >= 0; i--)
	        {
	            var chk = chks[i];
	            //alert(chk.parentElement.parentElement.parentElement.rowIndex);
	            if (chk.checked)
	            {
	                document.getElementById("oTable"+order).deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex)
	            }
	        }
	        var chk = document.getElementById("chkAll");
	        chk.checked = false
           	try
           	{
           		if(chk.checked)
           			jQuery(chk.nextSibling).addClass("jNiceChecked");
           		else
           			jQuery(chk.nextSibling).removeClass("jNiceChecked");
           	}
           	catch(e)
           	{
           	}
	    }, function () {}, 320, 90);
		}
    }
    
    function chkAllClick(obj,order)
    {
        var chks = document.getElementsByName("paramid_"+order);
        
        for (var i = 0; i < chks.length; i++)
        {
            var chk = chks[i];
            
            if(false == chk.disabled)
            {
            	chk.checked = obj.checked;
            	try
            	{
            		if(chk.checked)
            			jQuery(chk.nextSibling).addClass("jNiceChecked");
            		else
            			jQuery(chk.nextSibling).removeClass("jNiceChecked");
            	}
            	catch(e)
            	{
            	}
            }
        }
    }
    
    function initVal() {
    	var pattern = "<%=pattern%>";
		var source = "<%=source%>";
		var wsurl = "<%=wsurl%>";
		var wsOperation = "<%=wsOperation%>";
		var wsPara = "<%=wsPara%>";
		var area = "<%=area%>";
		var dataKey = "<%=dataKey%>";
		var href = "<%=href%>";
		 //初始化
        $("#selector1").val(pattern);
        $("#sourceSelector").val(source);
        $("#webServiceAddr").val(wsurl);
        $("#webServiceMethod").val(wsOperation);
        $("#webServicePara").val(wsPara);
        $("#area").text(area);
        $("#dataKey").val(dataKey);
        $("#href").val(href);
    }
    
    function init(order) {
    	var pattern = "<%=pattern%>";
		var source = "<%=source%>";
		var wsurl = "<%=wsurl%>";
		var wsOperation = "<%=wsOperation%>";
		var wsPara = "<%=wsPara%>";
		var area = "<%=area%>";
		var dataKey = "<%=dataKey%>";
		var href = "<%=href%>";
		 //初始化
        $("#selector1").val(pattern);
        $("#sourceSelector").val(source);
        $("#webServiceAddr").val(wsurl);
        $("#webServiceMethod").val(wsOperation);
        $("#webServicePara").val(wsPara);
        $("#area").text(area);
        $("#dataKey").val(dataKey);
        $("#href").val(href); 
        
       
		var showfield = "<%=showfield%>";
		var showfieldname =  "<%=showfieldname%>";
		var isshowname = "<%=isshowname%>";
		var transql = "<%=transql.replace("\n"," ")%>"; 
		var showfields = showfield.split(",");//字段
		var showfieldnames = showfieldname.split(",");//字段显示名
		var isshownames = isshowname.split(",");//是否标题
		var transqls = transql.split(",");//转换
       
        if(pattern != "1") {
        	$("#sourceSpan").hide();//数据库选择项隐藏
        }
        if(pattern == "2") {
        	$("#webServiceMP").show();
        	$("#areaDiv").hide();
        }
        //隐藏必填项的图标
        if(source != "") {
        	$("#sourceSelectorSpan").hide();
        }
        
        
        for(var i = 0; i < showfields.length && ""!=showfields[i]; i++) {
        	var rownum = document.getElementById("oTable"+order).rows.length;
			var oRow = document.getElementById("oTable"+order).insertRow(rownum);
	        var oRowIndex = oRow.rowIndex;
	        if (0 == oRowIndex % 2){
	            oRow.className = "DataLight";
	        }
	        else{
	            oRow.className = "DataDark";
	        }
        	var oCell = oRow.insertCell(0);
	        var oDiv = document.createElement("div");
	        oDiv.innerHTML="<INPUT type='checkbox' name='paramid_"+order+"'><INPUT type='hidden' name='paramids_"+order+"' value='-1'><INPUT type='hidden' name='type' value='"+order+"'>";
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();

            oCell = oRow.insertCell(1);
            oDiv = document.createElement("div");
            oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='fielnameSearchId_" + oRowIndex + "' name='fieldname2' value='"+showfieldnames[i]+"' onblur=\"checkinput('fielnameSearchId_" + oRowIndex + "','fieldnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%' value='' maxlength=50><span id='fieldnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'></span>";
            oCell.appendChild(oDiv);



            oCell = oRow.insertCell(2);
            oDiv = document.createElement("div");
            oDiv.innerHTML="<INPUT class='InputStyle' type='text' id='searchnameSearchId_" + oRowIndex + "' name='searchname2' _noMultiLang='true' value='"+showfields[i]+"' maxlength=200 onblur=\"checkinput('searchnameSearchId_" + oRowIndex + "','searchnamespan" + oRowIndex + "',this.getAttribute('viewtype'))\" style='width:80%'><span id='searchnamespan" + oRowIndex + "' style='word-break:break-all;word-wrap:break-word'></span>";
            oCell.appendChild(oDiv);
	        
	        oCell = oRow.insertCell(3);
	        oDiv = document.createElement("div");
	        if("1"== isshownames[i]) {
	        	oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='' checked onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='"+isshownames[i]+"'>";            
	        } else {
	        	oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='' onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='"+isshownames[i]+"'>"; 
	        }
	        
	       <%--  //oDiv.innerHTML="<INPUT type='checkbox' class='tempisshowname' name='tempisshowname' value='"+<%if("1".equals(isshownames[i])){%>checked<%}%>+"' onclick='changeShowname(this);'><INPUT type='hidden' class='isshowname' name='isshowname' value='"+isshownames[i]+"'>";  --%>                    
	        oCell.appendChild(oDiv);
	        jQuery(oCell).jNice();
	        
	        oCell = oRow.insertCell(4);
	        oDiv = document.createElement("div");
	        oDiv.innerHTML="<textarea class=\"InputStyle\" temptitle=\"<%=SystemEnv.getHtmlLabelName(32322, user.getLanguage())%>\" id=\"transql\" name=\"transql\" rows=\"2\" style=\"width:90%\">"+transqls[i]+"</textarea>";
	        oCell.appendChild(oDiv);
        }
	
		/*============ 选择 ============*/
       
	}
	
	function onCancel(){
		var dialog = parent.getDialog(window);	
		dialog.close();
	}
	function changeShowname(obj){
		changeCheckboxStatus(jQuery(".tempisshowname"),false);
		//jQuery(".tempisshowname").attr("checked",false);
	    jQuery(".isshowname").val("0");
		changeCheckboxStatus(jQuery(obj),true);
		if(obj.checked)
		{
			obj.parentElement.nextSibling.value=1;
			jQuery(obj.nextSibling).addClass("jNiceChecked");
		}
		else
		{
			obj.parentElement.nextSibling.value=0;
		}
	}
	function initAddr(id, name, address) {
		var ids = id.split(",");
		var names = name.split(",");
		var addresses = address.split(",");
		var sys ="<%=sysList%>".replace("[", "").replace("]", "").replace(/\s/g,'');
		var sysList = sys.split(",");
		var sysName = "<%=sysNameList%>".replace("[", "").replace("]", "").replace(/\s/g,'');
		var sysNameList = sysName.split(",");
		var cont = "<table class='ListStyle'><tr><th style='text-align:center;'>"+"<%=SystemEnv.getHtmlLabelName(30231, user.getLanguage())%>"+"</th><th style='text-align:center;width: 300px'>"+"<%=SystemEnv.getHtmlLabelName(20961, user.getLanguage())%>"+"</th></tr>";
		
		for(var i=0; i<ids.length; i++) {
			if(ids[i] != "" && ids[i] != undefined) {
				cont = cont + "<tr  id='"+trim(names[i])+"'><td style='text-align:center;'><input name=\"addrId\" type=\"hidden\"  value='"+ids[i]+"'></input>"
			    cont = cont + trim(names[i]) + "</td><td style=\"width: 200px\">"
			    cont = cont + "<select class=\"sbHolder  weatable_sourceSelector\" name=\"addrUrl\" style=\"width: 200px\" value='"+ addresses[i] + "'><option></option>";
			    for(var j = 0;j < sysList.length; j++) {
			    			var v = sysList[j];
					    	if(v == addresses[i]) {
					    		cont = cont +"<option value='"+sysList[j]+"' selected>"+sysNameList[j]+"</option>";
					    	} else {
					    		cont = cont +"<option value='"+sysList[j]+"'>"+sysNameList[j]+"</option>";
					    	}
			    	
			  	}
			     cont = cont + "</select></td></tr>";
				//cont = cont +  "<input class=\"InputStyle\" type=\"text\" name=\"addrUrl\" style=\"width: 300px\" value='"+ addresses[i] + "'></input></td></tr>";
			}
		} 
		cont = cont + "</table>";
		
		$("#selectedOutDatas").html(cont);
		$("#selectedOutDatas").find("select").selectbox("detach");
        $("#selectedOutDatas").find("select").selectbox();
		
	}
	function clickBrowser(event,datas,name,_callbackParams) {
		browserData = datas;
		var sys ="<%=sysList%>".replace("[", "").replace("]", "").replace(/\s/g,'');
		var sysList = sys.split(",");
		var sysName = "<%=sysNameList%>".replace("[", "").replace("]", "").replace(/\s/g,'');
		var sysNameList = sysName.split(",");
		checkinput('outdatas','outdatasSpan');
		var ids = datas.id.split(",");
		
		var names = datas.name.split(",");
		var cont = "<table class='ListStyle'><tr><th style='text-align:center;'>"+"<%=SystemEnv.getHtmlLabelName(30231, user.getLanguage())%>"+"</th><th style='text-align:center;width: 300px'>"+"<%=SystemEnv.getHtmlLabelName(20961, user.getLanguage())%>"+"</th></tr>";
		//重新设置之前先判断之前的是否有值,有值的话之前的值保留不变

		var urlArr = document.getElementsByName("addrUrl");
		var idArr = document.getElementsByName("addrId");
		
		for(var i=0; i<ids.length; i++) {
			if(ids[i] != "" && ids[i] != undefined) {
				var flage = true;
				for(var k = 0; k < idArr.length; k++) {
					if((idArr[k].value==ids[i])&&urlArr[k]) {
						cont = cont + "<tr id='"+trim(names[i])+"'><td style='text-align:center;'><input name=\"addrId\" type=\"hidden\" value='"+idArr[k].value+"'></input>";
			    		cont = cont + trim(names[i]) + "</td><td style=\"width: 200px\">";
			    		cont = cont + "<select class=\"InputStyle\" name=\"addrUrl\" style=\"width: 200px\" value='"+ urlArr[k].value + "'><option></option>";
			    		for(var j = 0;j < sysList.length; j++) {
			    			var v = sysList[j];
			    			if(urlArr[k].value == v) {
			    				cont = cont +"<option value='"+sysList[j]+"' selected>"+sysNameList[j]+"</option>";
			    			} else {
			    				cont = cont +"<option value='"+sysList[j]+"'>"+sysNameList[j]+"</option>";
			    			}
					    	
			  			}
			     		cont = cont + "</select></td></tr>";
						//cont = cont +  "<input class=\"InputStyle\" type=\"text\" name=\"addrUrl\" style=\"width: 300px\" value='"+ urlArr[k].value + "'></input></td></tr>";
						flage = false;
					}
				}
				if(flage) {
					cont = cont + "<tr id='"+trim(names[i])+"'><td style='text-align:center;'><input name=\"addrId\" type=\"hidden\" value='"+ids[i]+"'></input>"
			   		cont = cont + names[i] + "</td><td style=\"width: 200px\">"
			   		cont = cont + "<select class=\"InputStyle\" name=\"addrUrl\" style=\"width: 200px\" value=''><option></option>";
			    		for(var j = 0;j < sysList.length; j++) {
			    			cont = cont +"<option value='"+sysList[j]+"'>"+sysNameList[j]+"</option>";
			  			}
			     		cont = cont + "</select></td></tr>";
					//cont = cont +  "<input class=\"InputStyle\" type=\"text\" name=\"addrUrl\" style=\"width: 150px\" value='"+ "" + "'></input></td></tr>";
				}
				
			}
		} 
		cont = cont + "</table>"
		$("#selectedOutDatas").html(cont);
		$("#selectedOutDatas").find("select").selectbox("detach");
        $("#selectedOutDatas").find("select").selectbox();
		return;
	}
	//禁止对已选择的内容进行删除
	function deleteElement(ext,fieldid,params) {
	
		/* alert(ext);
		alert(params); */
		//vat te = $("#"+ext).parent();
		//验证是否有值
		checkinput('outdatas','outdatasSpan');
		var tr = document.getElementById(''+ext);
		tr.parentNode.removeChild(tr); 
		return true;
		//alert(jQuery("input[value='"+ext+"']").parent().parent().id);
		
	}
	
	//删除左右两端的空格
	function trim(str){ 
	    return str.replace(/(^\s*)|(\s*$)/g, "");
	}
	//select框无法调用span自动隐藏的方式
	function changeSpan(tid) {
		var v = $("#"+tid).val();
		if(v == "") {
			$("#"+tid+"Span").show();
		} else {
			$("#"+tid+"Span").hide();
		}
	}
	
	function Submit() {
        var fieldNames2 = jQuery("input[name='fieldname2']");
        var hasNullFieldNames2 = false;
        jQuery.each(fieldNames2, function() {
             //QC277688  [80][90]外部数据元素-设置显示字段,输入空格能进行保存的问题
            if ($.trim($(this).val()) == "") {
                hasNullFieldNames2 = true;
            }
        });
        var searchNames2 = jQuery("input[name='searchname2']");
        var hasNullSearchNames2 = false;
        jQuery.each(searchNames2, function() {
             //QC277688  [80][90]外部数据元素-设置显示字段,输入空格能进行保存的问题
            if ($.trim($(this).val()) == "") {
                hasNullFieldNames2 = true;
            }
        });
        if(hasNullFieldNames2 || hasNullSearchNames2){
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82992,user.getLanguage())%>!");
            displayAllmenu();
            return;
        }

		needcheck = "tabTitle";//必填项验证
		var para = "";
		if($('input:radio[name="type"]:checked').val() == "1") {
			
			var urls = document.getElementsByName("addrUrl");
			var ids = document.getElementsByName("addrId");
			var urlString = "";
			var idString = "";
			
			for(var i = 0; i < ids.length; i++) {
				urlString = urlString + urls[i].value+"#";
				idString = idString + ids[i].value + "#";
			}
			
			para = {
				"tabId" :"<%=tabId %>",
				"eid" : "<%=eid %>",
				"method" : "<%=method%>",
				"addrUrl" : ""+urlString,
				"addrId" : ""+idString,
				"tabTitle" : ""+document.getElementsByName("tabTitle")[0].value,
				"type" : "1"//1表示选择外部数据源的方式
			};
			needcheck = needcheck + ",outdatas";
		
		} else if($('input:radio[name="type"]:checked').val() == "2") {//选择自定义的方式
			//判断显示字段与标题
			var oRow = document.getElementById("oTable2");
			var oRowIndex = oRow.rows.length;
			//alert("oRowIndex : "+oRowIndex);
			if(oRowIndex<3)
			{
				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82992,user.getLanguage())%>!");
				return;
			}
			var hasshowname = false;
		    var isshownames = jQuery("input[name='isshowname']");
			jQuery.each(isshownames, function(j, n){
		      //alert( "Item #" + i + ": " + n );
		      //alert("i : "+i+"    " +$(this).attr("checked"));
		      if($(this).val()=="1")
		      {
		        hasshowname = true;
		      }
		    });
		    if(!hasshowname)
		    {
		    	top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82993, user.getLanguage()) %>!");
		      	return;
		    }
		
			var pattern = $("#selector1  option:selected").val();
			var source = ""+$("#sourceSelector option:selected").val();
			var sysAddr = ""+$("#outsysDef option:selected").val();
			var transql = document.getElementsByName("transql");
			var fieldnames = document.getElementsByName("fieldname2");
			var searchnames = document.getElementsByName("searchname2");
			var isshownames = document.getElementsByName("isshowname");
			//webservice相关参数获取
			var wsAddr = $("#webServiceAddr").val();
			var wsMethod = $("#webServiceMethod").val();
			var wsPara = $("#webServicePara").val();
			var href = $("#href").val();
			var fieldnameStr = "";
			var searchnameStr = "";
			var isshownameStr = "";
			var transqlStr = "";
			for(var i = 0; i < fieldnames.length; i++) {
				fieldnameStr = fieldnameStr + fieldnames[i].value+"#";
				searchnameStr = searchnameStr + $.trim(searchnames[i].value) + "#";
				isshownameStr = isshownameStr + isshownames[i].value + "#";
				transqlStr = transqlStr + transql[i].value + "#";
			}
			
			para = {
				"tabId" : "<%=tabId %>",
				"eid" : "<%=eid %>",
				"method" : "<%=method%>",
				"tabTitle" : ""+document.getElementsByName("tabTitle")[0].value,
				"type" : "2",//2表示选择自定义的方式
			 	"pattern" : ""+pattern,
				"source" : ""+source,
				"area" : ""+$("#area").val().replace(/\n|\r\n/g," "),
				"dataKey" : ""+$.trim($("#dataKey").val()),
				"fieldname" : ""+fieldnameStr,
				"searchname" : ""+searchnameStr,
				"isshowname" : ""+isshownameStr,
				"transql" : ""+transqlStr,
				"wsAddr" : ""+wsAddr,
				"wsMethod" : ""+wsMethod,
				"wsPara" : ""+wsPara,
				"href" :""+href,
				"sysAddr" : ""+sysAddr//集成登录设置
			};
			
			needcheck = needcheck + ",dataKey";
			if(pattern == "1") {
				needcheck = needcheck + ",area";
			}
			if(pattern == "2") {
				needcheck = needcheck + ",webServiceAddr,webServiceMethod";
			} else {
				needcheck = needcheck + ",area";
			}
		}
		//验证必填项是否填写
		if(!check_form(form1,needcheck)){
	    	return;
	    }
	    
	    var sign = "0";
	    // 解析SQL语句
		if($('input:radio[name="type"]:checked').val() == "2") {// 自定义方式
			var pattern = $("#selector1  option:selected").val();
			if(pattern == "1") {// 数据库
				var sqltext = $("#area").val();
				var dataKey = $.trim($("#dataKey").val());
				var searchnames = document.getElementsByName("searchname2");
				var searchnameStr = "";
				for(var i = 0; i < searchnames.length; i++) {
					searchnameStr = searchnameStr + $.trim(searchnames[i].value) + "#";
				}
				var params = {method:"checkSQL",sqltext:sqltext,dataKey:dataKey,searchname:searchnameStr};
				jQuery.ajax({
			        type: "POST",
			        url: "tabOperation.jsp",
			        async: false,// 必须设置
			        data: params,
			        success: function(msg) {
			        	if($.trim(msg) == "1") {
			        		sign = "1";
			        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129564,user.getLanguage()) %>");
			        	} else if($.trim(msg) == "2") {
			        		sign = "2";
			        		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129567,user.getLanguage()) %>");
			        	}
			        }
				});
			}
		}
	    
		//关闭弹出框
		var dialog = parent.getDialog(window);
		var parentWin = dialog.currentWindow;
		
		var re = parentWin.doTabSave2('<%=eid %>','OutData','<%=tabId %>',para,sign);
	}
	
	
	
/**
 * 单击浏览按钮后的回调方法  重写该方法  否则在IE下，保存后无法关闭dialog无法支持
 * @return
 */
function __callback(id,fieldid,isMustInput,hasInput,options){
	var spans = jQuery("span[name='"+fieldid+"span']");
	options = jQuery.extend({needHidden:true},options);
	spans.each(function(){
	    var spanObj = jQuery(this);
		var a = jQuery(this).children("a:not(:empty)");
		var isSingle = true;
		var innerDiv = jQuery(this).closest("div.e8_innerShow");
		var input = innerDiv.find("input[type=text]");
		if(!input.length){
			isSingle = false;
		}
		var maxWidth = getMaxWidth(innerDiv,isSingle);
		if(a.length>0){
			jQuery(this).closest("div.e8_os").children("div.e8_innerShowMust").children("span").html("");
		}else if(jQuery(this).children().length==0 && !jQuery(this).html()){
			if(isMustInput==2){
				jQuery(this).closest("div.e8_os").children("div.e8_innerShowMust").children("span").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
			}else{
				jQuery(this).html("");
			}
		}else if(jQuery(this).html()){
			
		}else{
			var formatAs = spanObj.find("span.e8_showNameClass a:not(:empty)");
			formatAs.each(function(){
				if(!!isSingle){
					jQuery(this).css("max-width",maxWidth/formatAs.length-2);
				}else{
					jQuery(this).css("max-width",maxWidth);
				}
				jQuery(this).attr("title",jQuery(this).text());
			});
			if(!!isSingle){
				setInputWidth(innerDiv,input,"#"+fieldid+"span");
			}
		}	
		a.each(function(){
			var href = jQuery(this).attr("href");
			jQuery(this).css("max-width",maxWidth);
			jQuery(this).attr("title",jQuery(this).text());
			var value='';
			if(!!href){
				if(href.toLowerCase().indexOf("javascript:")>-1 || href.toLowerCase().indexOf("#")>-1){
					if(href.toLowerCase().indexOf("#")>-1){
						value = href.replace(/#/g,"");
					}else{
						value = href.replace(/\D/g,"");
					}
				}else{
					var x = href.toLowerCase().match(/id=\d+/);
					if(!!x){
						value = x.toString().replace(/\D/g,"");
					}else{
						value = "";
					}
				}
			}else{
				value = jQuery(this).attr("_id");
			}
			if(true || !!value){
				//var closeSpan = jQuery("\n<span id=\""+value+"\" class='e8_delClass' onclick='del(event,this,"+isMustInput+","+options.needHidden+","+stringify(options)+");'>&nbsp;x&nbsp;</span>\n");
				var closeSpan = jQuery("<span>",{
					id:value
				}).addClass("e8_delClass").bind("click",function(e){
							del(e,this,isMustInput,options.needHidden,options);
				}).html("&nbsp;x&nbsp;");
				var showNameSpan =jQuery( "<span class='e8_showNameClass'></span>");
				showNameSpan.append(jQuery(this));
				if(hasInput && !!value){
					showNameSpan.append(closeSpan);
				}
				hoverShowNameSpan(showNameSpan);
				spanObj.append(showNameSpan);
				if(!!isSingle){
					//setInputWidth(innerDiv,input,"#"+fieldid+"span");
				}
			}
		});	
	});
	//重写该方法  否则在IE下无法支持
	try{
		jQuery("#"+fieldid).closest("#innerContent"+fieldid+"div").perfectScrollbar("update");
	} catch(e) {
		
	}
	//触发onpropertychange事件
	try {
		eval(jQuery("#"+ fieldid).attr('onpropertychange'));
	} catch (e) {
	}
	try {
		eval(jQuery("#"+ fieldid + "__").attr('onpropertychange'));
	} catch (e) {
	}
}
/*QC299099 [80][90]外部数据元素-标题带有特殊字符保存后，再次打开数据丢失问题 start*/
    function isExist(oldvalue,object){
/*QC299099 [80][90]外部数据元素-标题带有特殊字符保存后，再次打开数据丢失问题 end*/  
        var customename = document.getElementById("tabTitle_<%=eid %>").value;
        newvalue = $.trim(customename);
        document.getElementById("tabTitle_<%=eid %>").value = newvalue;
/*QC299099 [80][90]外部数据元素-标题带有特殊字符保存后，再次打开数据丢失问题 start*/        
	    if(isSpecialChar(newvalue)){
			//外部数据标题不能为特殊字符
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132004,user.getLanguage())%>");
	        document.getElementById("tabTitle_"+object).value=oldvalue;
	        if(document.getElementById("tabTitle_"+object).value==""){
	           document.getElementById("tabTitleSpan_"+object).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	        }
	        return false;
		}
		if(isFullwidthChar(newvalue)){
			//外部数据标题不能为全角字符
			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(132005,user.getLanguage())%>");
	        document.getElementById("tabTitle_"+object).value=oldvalue;
	        if(document.getElementById("tabTitle_"+object).value==""){
	           document.getElementById("tabTitleSpan_"+object).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	        }
	        return false;
		}
        
        return true;
    }
    
    //是否包含特殊字段
	function isSpecialChar(str){
		var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
		return reg.test(str);
	}
	//是否含有全角符号的函数
	function isFullwidthChar(str){
	   var reg = /[\uFF00-\uFFEF]/;
	   return reg.test(str);
	}
/*QC299099 [80][90]外部数据元素-标题带有特殊字符保存后，再次打开数据丢失问题 end*/    
	</script>

<span id="encodeHTML" style="display:none"></span> 
