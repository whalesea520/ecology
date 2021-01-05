<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.general.FnaSplitPageTransmethod"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.fna.maintenance.FnaBudgetInfoComInfo"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("BudgetCostCenter:maintenance",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

BaseBean bb = new BaseBean();
boolean enableCrm = "1".equals(bb.getPropValue("module", "crm.status"));
boolean enablePrj = "1".equals(bb.getPropValue("module", "proj.status"));

FnaSplitPageTransmethod fnaSplitPageTransmethod = new FnaSplitPageTransmethod();
BudgetfeeTypeComInfo budgetfeeTypeComInfo = new BudgetfeeTypeComInfo();

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(332,user.getLanguage());//全部
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

int fccId = Util.getIntValue(request.getParameter("id"),0);

int supFccId = 0;
int type = 0;
String name = "";
String code = "";
int archive = 0;
String description = "";

String sql = "select * from FnaCostCenter a where a.id = "+fccId;
rs.executeSql(sql);
if(rs.next()){
	supFccId = Util.getIntValue(rs.getString("supFccId"), 0);
	type = Util.getIntValue(rs.getString("type"), 0);
	name = Util.null2String(rs.getString("name")).trim();
	code = Util.null2String(rs.getString("code")).trim();
	archive = Util.getIntValue(rs.getString("archive"), 0);
	description = Util.null2String(rs.getString("description")).trim();
}

String supClassName = "";
if(supFccId > 0){
	sql = "select name from FnaCostCenter a where a.id = "+supFccId;
	rs.executeSql(sql);
	if(rs.next()){
		supClassName = Util.null2String(rs.getString("name")).trim();
	}
}

String _titleName = SystemEnv.getHtmlLabelName(515,user.getLanguage());
if(type==0){
	_titleName = SystemEnv.getHtmlLabelName(178,user.getLanguage());
}

StringBuffer subId = new StringBuffer();
StringBuffer shownameSub = new StringBuffer();
StringBuffer depId = new StringBuffer();
StringBuffer shownameDep = new StringBuffer();
StringBuffer hrmId = new StringBuffer();
StringBuffer shownameHrm = new StringBuffer();
StringBuffer crmId = new StringBuffer();
StringBuffer shownameCrm = new StringBuffer();
StringBuffer prjId = new StringBuffer();
StringBuffer shownamePrj = new StringBuffer();
if(type==1){
	fnaSplitPageTransmethod.getSubNames(fccId+"", shownameSub, subId);
	fnaSplitPageTransmethod.getDepNames(fccId+"", shownameDep, depId);
	fnaSplitPageTransmethod.getResNames(fccId+"", shownameHrm, hrmId);
	fnaSplitPageTransmethod.getCrmNames(fccId+"", shownameCrm, crmId);
	fnaSplitPageTransmethod.getPrjNames(fccId+"", shownamePrj, prjId);
}

FnaFccDimensionHelp fnaFccDimensionHelp = new FnaFccDimensionHelp();
List<FnaFccDimension> fnaFccDimension_list = fnaFccDimensionHelp.queryAllFnaFccDimension();
int fnaFccDimension_list_len = fnaFccDimension_list.size();
fnaFccDimensionHelp.loadFnaFccDimension_fccSelectedId_list(fccId, fnaFccDimension_list);
%>

<%@page import="weaver.fna.maintenance.FnaFccDimensionHelp"%>
<%@page import="weaver.fna.maintenance.FnaFccDimension"%>
<%@page import="weaver.interfaces.workflow.browser.Browser"%><HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doEdit(),_TOP} ";//保存
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=_titleName %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
	    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doEdit();" 
	    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
<form id="form2" name="form2" method="post">
<input type="hidden" id="fccId" name="fccId" value="<%=fccId %>" />
<input type="hidden" id="type" name="type" value="<%=type %>" />

		
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'><!-- 基本信息 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item><!-- 名称 -->
			<wea:item>
				<wea:required id="nameSpan" required="true">
        			<input class="inputstyle" id="name" name="name" maxlength="200" style="width: 150px;" 
        				onchange='checkinput("name","nameSpan");' value="<%=FnaCommon.escapeHtml(name) %>" />
				</wea:required>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></wea:item><!-- 编码 -->
			<wea:item>
       			<input class="inputstyle" id="code" name="code" maxlength="30" style="width: 150px;" 
       				value="<%=FnaCommon.escapeHtml(code) %>"  _noMultiLang="true" />
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item><!-- 状态 -->
			<wea:item>
	            <select class="inputstyle" id="archive" name="archive" style="width: 80px;">
	              <option value="0" <% if(archive == 0) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(25456,user.getLanguage())%></option>
	              <option value="1" <% if(archive == 1) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(22205,user.getLanguage())%></option>
	            </select>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(81535,user.getLanguage())%></wea:item><!-- 所属类别 -->
			<wea:item>
			 	<%
					String browserUrl = "/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/singleType/FccBrowser.jsp%3Fselectedid="+fccId+"%26fcctype="+type;
					String completeUrl = "/data.jsp?show_virtual_org=-1&type=FnaCostCenterType&selectedid="+fccId+"&fcctype="+type;
				%>
			 	<brow:browser viewType="0" id="supFccId" name="supFccId" browserValue='<%=supFccId+"" %>' 
		                browserUrl='<%=browserUrl %>'
		                hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="1"
		                completeUrl="<%=completeUrl %>"  temptitle='<%= SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>'
		                browserSpanValue='<%=FnaCommon.escapeHtml(supClassName) %>' width="180px"
		                >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></wea:item><!-- 描述 -->
			<wea:item>
				<textarea class=inputstyle id="description" name="description" cols="60" rows=4><%=FnaCommon.escapeHtml(description) %></textarea>
        	</wea:item>
		</wea:group>
<%
	if(type==1){
%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(24664,user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}"><!-- 关联对象 -->
			<wea:item><%=SystemEnv.getHtmlLabelNames("141",user.getLanguage())%></wea:item><!-- 分部 -->
			<wea:item>
		        <brow:browser viewType="0" name="subId" browserValue='<%=subId.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
		                browserSpanValue='<%=FnaCommon.escapeHtml(shownameSub.toString()) %>' width="70%" 
		                >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("124",user.getLanguage())%></wea:item><!-- 部门 -->
			<wea:item>
		        <brow:browser viewType="0" name="depId" browserValue='<%=depId.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
		                browserSpanValue='<%=FnaCommon.escapeHtml(shownameDep.toString()) %>' width="70%" 
		                >
		        </brow:browser>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelNames("1867",user.getLanguage())%></wea:item><!-- 人员 -->
			<wea:item>
		        <brow:browser viewType="0" name="hrmId" browserValue='<%=hrmId.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("17")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?show_virtual_org=-1&type=17"  temptitle='<%= SystemEnv.getHtmlLabelName(6087,user.getLanguage())%>'
		                browserSpanValue='<%=FnaCommon.escapeHtml(shownameHrm.toString()) %>' width="70%" 
		                >
		        </brow:browser>
			</wea:item>
		<%if(enableCrm){ %>
			<wea:item><%=SystemEnv.getHtmlLabelNames("136",user.getLanguage())%></wea:item><!-- 客户 -->
			<wea:item>
		        <brow:browser viewType="0" name="crmId" browserValue='<%=crmId.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("18")+"%3FCustomerID=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=18"  temptitle='<%= SystemEnv.getHtmlLabelName(136,user.getLanguage())%>'
		                browserSpanValue='<%=FnaCommon.escapeHtml(shownameCrm.toString()) %>' width="70%" 
		                >
		        </brow:browser>
			</wea:item>
		<%} %>
		<%if(enablePrj){ %>
			<wea:item><%=SystemEnv.getHtmlLabelNames("101",user.getLanguage())%></wea:item><!-- 项目 -->
			<wea:item>
		        <brow:browser viewType="0" name="prjId" browserValue='<%=prjId.toString() %>' 
		                browserUrl='<%=new BrowserComInfo().getBrowserurl("135")+"%3FProjID=#id#" %>'
		                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
		                completeUrl="/data.jsp?type=135"  temptitle='<%= SystemEnv.getHtmlLabelName(101,user.getLanguage())%>'
		                browserSpanValue='<%=FnaCommon.escapeHtml(shownamePrj.toString()) %>' width="70%" 
		                >
		        </brow:browser>
			</wea:item>
		<%} %>
		<%
		for(int i=0;i<fnaFccDimension_list_len;i++){
			FnaFccDimension fccDimension = fnaFccDimension_list.get(i);
		%>
			<wea:item><%=FnaCommon.escapeHtml(fccDimension.getName())%></wea:item><!-- 项目 -->
			<wea:item>
			<% 
			String browserName = "fnaFccDimension_"+fccDimension.getId();
			String browserUrl = "";
			if("162".equals(fccDimension.getType())){
				browserUrl = new BrowserComInfo().getBrowserurl(fccDimension.getType())+"%3Ftype="+fccDimension.getFielddbtype()+"%26selectedids=#id#";
			}else if("257".equals(fccDimension.getType())){
				browserUrl = new BrowserComInfo().getBrowserurl(fccDimension.getType())+"%3Ftype="+fccDimension.getFielddbtype()+"_257%26selectedids=#id#";
			}
			%>
		        <brow:browser viewType="0" name="<%=browserName %>" browserValue='<%=fccDimension.getFccSelectedIds() %>' 
		                browserUrl='<%=browserUrl %>'
		                hasInput="false" isSingle="false" hasBrowser = "true" isMustInput="1"
		                browserSpanValue='<%=FnaCommon.escapeHtml(fccDimension.getFccSelectedNames()) %>' width="70%" 
		                >
		        </brow:browser>
			</wea:item>
		<%
		}
		%>
	    </wea:group>
<%
	}
%>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
	    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="doClose();" 
	    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
	    	</wea:item>
	    </wea:group>
</wea:layout>
</div>

<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

jQuery(document).ready(function(){
	resizeDialog(document);
	checkinput("name","nameSpan");
});

//关闭
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}

//关闭
function doClose2(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

//快速（高级）搜索事件
function onBtnSearchClick(from_advSubmit){
}

//保存
function doEdit2(){
	if(jQuery("#name").val()==""){
		alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>");
		return;
	}
	
	hideRightMenuIframe();
  try{
		var id = null2String(jQuery("#fccId").val());
		var supFccId = null2String(jQuery("#supFccId").val());
		var _data = "operation=edit&id="+id+getPostDataByForm("form2");

		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/costCenter/CostCenterOperation.jsp",
			type : "post",
			cache : false,
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(_json){
			    try{
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
					if(_json.flag){
						var parentWin = parent.getParentWindow(window);
						var dialog = parent.getDialog(parentWin);
				    	
						parentWin.parent.parent.leftframe.do_reAsyncChildNodes(0+"_"+supFccId, 0+"_"+supFccId);
						parentWin._table.reLoad();
						parentWin.closeDialog();
					}else{
						top.Dialog.alert(_json.msg);
					}
			    	showRightMenuIframe();
			    }catch(e1){
			    	showRightMenuIframe();
			    }
			}
		});	
  }catch(e1){
  	showRightMenuIframe();
  }
}

//封存检查，并保存
function doEdit(){
	if(jQuery("#name").val()==""){
		alert("<%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18019,user.getLanguage())%>");
		return;
	}
	
	hideRightMenuIframe();
	try{
		var id = null2String(jQuery("#fccId").val());
		var archive = null2String(jQuery("#archive").val());
		var _data = "checkid="+id;
		if(archive=="1"){
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/costCenter/CostCenterViewAjax.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "html",
				success: function do4Success(_html){
					try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			    	_html = jQuery.trim(_html);
					if(_html=="1"){
						top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(126350,user.getLanguage())%>",
							function(){
								doEdit2();
							},
							function(){
							  	showRightMenuIframe();
							},
							360
						);
					}else{
						doEdit2();
					}
				}
			});	
		}else{
			doEdit2();
		}
	}catch(e1){
		showRightMenuIframe();
	}
}


</script>
</BODY>
</HTML>
