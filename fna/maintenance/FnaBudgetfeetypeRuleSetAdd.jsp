<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.fna.maintenance.BudgetfeeTypeComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
boolean canEdit = HrmUserVarify.checkUserRight("FnaLedgerAdd:Add",user) || HrmUserVarify.checkUserRight("FnaLedgerEdit:Edit",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String ids = Util.null2String(request.getParameter("ids")).trim();


String name = "";
String roleid = "0";
String rolename = "";
StringBuffer depids = new StringBuffer();
StringBuffer depnames = new StringBuffer();
boolean allowZb = true;
StringBuffer fbids = new StringBuffer();
StringBuffer fbnames = new StringBuffer();
StringBuffer fccids = new StringBuffer();
StringBuffer fccnames = new StringBuffer();

if(ids.split(",").length == 1){
	int idx;
	String sql = "";
	int feelevel = 0;
	DepartmentComInfo dci = new DepartmentComInfo();
	SubCompanyComInfo scci=new SubCompanyComInfo();
	
	rs1.executeSql("select * from fnabudgetfeetype where id=" + ids);
	if(rs1.next()){
		feelevel = Util.getIntValue(rs1.getString("feelevel"),3);
	}
	
	if(feelevel == 3){
		sql = "select * from FnabudgetfeetypeRuleSet where type=0 and  mainid=" + ids;
		rs.executeSql(sql);
		if(rs.next()){
			int type0 = rs.getInt("orgId");
			if(type0 == 0){
				allowZb = false;
			}
		}
		idx = 0;
		sql = "select * from FnabudgetfeetypeRuleSet where type=1 and mainid=" + ids + " order by id";
		rs.executeSql(sql);
		while(rs.next()){
			String showid = Util.null2String(rs.getString("orgId")).trim();
			if(idx > 0){
				fbids.append(",");
				fbnames.append(", ");
			}
			fbids.append(showid);
			fbnames.append(scci.getSubCompanyname(showid+""));
			idx++;
		}
		idx = 0;
		rs.executeSql("select * from FnabudgetfeetypeRuleSet where type=2 and mainid = "+ids+" order by id");
		while(rs.next()){
			String showid = Util.null2String(rs.getString("orgId")).trim();
			if(idx > 0){
				depids.append(",");
				depnames.append(", ");
			}
			depids.append(showid);
			depnames.append(dci.getDepartmentname(showid+""));
			idx++;
		}
		idx = 0;
		rs.executeSql("select a.*, b.name "+
			" from FnabudgetfeetypeRuleSet a "+
			" join FnaCostCenter b on a.orgId = b.id "+
			" where a.type=" + FnaCostCenter.ORGANIZATION_TYPE + " and a.mainid = "+ids+" order by b.name");
		while(rs.next()){
			String showid = Util.null2String(rs.getString("orgid")).trim();
			String fccname = Util.null2String(rs.getString("name")).trim();
			if(idx > 0){
				fccids.append(",");
				fccnames.append(", ");
			}
			fccids.append(showid);
			fccnames.append(fccname);
			idx++;
		}
	}
}


%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doEdit(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	
		
	RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
			+ ",javascript:doClose(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
String navName = SystemEnv.getHtmlLabelNames("33511,19374",user.getLanguage());
%>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=navName %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
		    		<input class="e8_btn_top" type="button" id="btnSave" onclick="doEdit();" 
		    			value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"/><!-- 保存 -->
		    		<input class="e8_btn_top" type="button" id="btnDel" onclick="doClose();" 
		    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 删除 -->
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<form name="form2" method="post" action="/fna/budget/FnaLeftRuleSet/ruleSetAdd.jsp">
<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(16484,user.getLanguage())%>'><!-- 应用范围 -->
		<wea:item><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></wea:item><!-- 总部 -->
		<wea:item>
	  			<input id="allowZb" name="allowZb" value="1" type="checkbox" tzCheckbox="true" <%=(allowZb?"checked":"") %> />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item><!-- 分部 -->
		<wea:item>
	        <brow:browser viewType="0" name="field6341" browserValue='<%=fbids.toString() %>' 
	                browserUrl='<%=new BrowserComInfo().getBrowserurl("194")+"%3Fshow_virtual_org=-1%26selectedids=#id#" %>'
	                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=194"  temptitle='<%= SystemEnv.getHtmlLabelName(141,user.getLanguage())%>'
	                browserSpanValue='<%=fbnames.toString() %>' width="80%" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item><!-- 部门 -->
		<wea:item>
	        <brow:browser viewType="0" name="field6855" browserValue='<%=depids.toString() %>' 
	                browserUrl='<%=new BrowserComInfo().getBrowserurl("57")+"%3Fshow_virtual_org=-1%26resourceids=#id#" %>'
	                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
	                completeUrl="/data.jsp?show_virtual_org=-1&type=57"  temptitle='<%= SystemEnv.getHtmlLabelName(124,user.getLanguage())%>'
	                browserSpanValue='<%=depnames.toString() %>' width="80%" >
	        </brow:browser>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(515,user.getLanguage())%></wea:item><!-- 成本中心 -->
		<wea:item>
	        <brow:browser viewType="0" name="fccids" browserValue='<%=fccids.toString() %>' 
	                browserUrl="/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp%3Fselectids=#id#"
	                hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
	                completeUrl="/data.jsp?type=FnaCostCenter"  temptitle='<%= SystemEnv.getHtmlLabelName(515,user.getLanguage())%>'
	                browserSpanValue='<%=fccnames.toString() %>' width="80%" >
	        </brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" id="btnClose" onclick="doClose();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<Script language=javascript>
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...
function doClose(){
	var dialog = parent.getDialog(window);	
	dialog.closeByHand();
}
function doEdit(){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage())%>",
			function(){doEdit2();}, 
			function(){}
	);
}
//保存
function doEdit2(){
	hideRightMenuIframe();
	 try{
			var ids = "<%=ids%>";
			var feetypeRuleSetZb = jQuery("#allowZb").attr("checked")?"1":"0";
			var feetypeRuleSetFb = null2String(jQuery("#field6341").val());
			var feetypeRuleSetBm = null2String(jQuery("#field6855").val());
			var feetypeRuleSetCbzx = null2String(jQuery("#fccids").val());
			
		
			var _data = "operation=ruleSetOp&ids="+ids+
				"&feetypeRuleSetZb="+feetypeRuleSetZb+"&feetypeRuleSetFb="+feetypeRuleSetFb+
				"&feetypeRuleSetBm="+feetypeRuleSetBm+"&feetypeRuleSetCbzx="+feetypeRuleSetCbzx;
			
			openNewDiv_FnaBudgetViewInner1(_Label33574);
			jQuery.ajax({
				url : "/fna/maintenance/FnaBudgetfeeTypeOperation.jsp",
				type : "post",
				cache : false,
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(_json){
				    try{
						try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
						if(_json.flag){
							top.Dialog.alert(_json.msg);
							parent.parent.leftframe.do_reAsyncChildNodes((fnaRound(feelevel,0)-1)+"_"+supsubject, (fnaRound(feelevel,0)-1)+"_"+supsubject);
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
</script>
</BODY>
</HTML>
