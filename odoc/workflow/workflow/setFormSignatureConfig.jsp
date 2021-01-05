<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.odoc.workflow.workflow.beans.FormSignatueConfigInfo" %>
<%@ page import="weaver.odoc.workflow.workflow.beans.ShortCutButtonConfigInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormSignatureConfigUtil" class="weaver.odoc.workflow.workflow.utils.FormSignatureConfigUtil" scope="page" />

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelNames("21750,68",user.getLanguage());
    String needfav = "";
    String needhelp = "";
    
    int workflowId = Util.getIntValue(request.getParameter("workflowId"),0);
    int nodeId = Util.getIntValue(request.getParameter("nodeId"),0);
    rs.writeLog("setFormSignatureConfig.jsp  workflowId="+workflowId+",nodeId="+nodeId);
    FormSignatueConfigInfo formSignatueConfig = FormSignatureConfigUtil.getFormSignatureConfig(workflowId,nodeId,user);
    List<ShortCutButtonConfigInfo> shortCutButtonConfigList = formSignatueConfig.getShortCutButtonConfig();
    String defaultFontName = "";
    if(formSignatueConfig.getDefaultFont() > 0) {
        rs.executeQuery("select f_name from fontinfo where id=?", formSignatueConfig.getDefaultFont());
        defaultFontName = rs.next() ? rs.getString("f_name") : "";
    }
    
%>

<HTML>
	
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<script type="text/javascript" src="/js/weaver_wev8.js" />
        <script type="text/javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
        <link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel="stylesheet">
        <script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
        <!--For Color Picker -->
        <link rel="stylesheet" href="/js/jquery/plugins/farbtastic/farbtastic_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/jquery/plugins/farbtastic/farbtastic_wev8.js"></script>	
        <link rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css" type="text/css" />
        <script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>
        <script type="text/javascript" src="/js/odoc/common/colorPickerUtil.js"></script>
        
        <link rel="stylesheet" type="text/css" href="/css/xpSpin_wev8.css">
        <SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>
        <script type="text/javascript" src="/js/odoc/common/numberPickerUtil.js"></script>
        
        <link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
        <script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
        
        <script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
        <script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
        <script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
        <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
        <link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
        <script type="text/javascript" src="/js/odoc/common/commonjs.js"></script>
        <script type="text/javascript">
            jQuery(document).ready(function(){
                try {
                    registerDragEvent();
                } catch(e) {}
                
                $("#btnTable").find("tr")
                    .live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
                    .live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
                
                initColor("#defaultColor");
                bindSpinEvent("#defaultFontSize");
                jQuery("#formSignatureWidth").blur(function () {
                    if(!this.value) {
                        this.value = "512";
                        jQuery("#formSignatureWidthImage").html("");
                    }
                });
                jQuery("#formSignatureHeight").blur(function () {
                    if(!this.value) {
                        this.value = "200";
                        jQuery("#formSignatureHeightImage").html("");
                    }
                });
            });
            
            function doFontback(json,tempid){
                jQuery(json.targetObj).val(tempid.id);
                var showSpanId = jQuery(json.targetObj).attr("showspanid");
                jQuery("#"+showSpanId).html(tempid.name);
            }
            
            function setFont(obj, targetObj){
                var dialog = new window.top.Dialog();
                dialog.currentWindow = window;   //传入当前window
                dialog.Width = 560;
                dialog.Height = 300;
                dialog.maxiumnable=true;
                dialog.callbackfun=doFontback;
                dialog.callbackfunParam={
                    obj : obj,
                    targetObj : targetObj
                };
                dialog.Modal = true;
                dialog.Title = "<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%>"; 
                dialog.URL = "/systeminfo/BrowserMain.jsp?url=/page/maint/style/FontSelect.jsp?isDialog=1";
                dialog.show();
            }
            
            function sucSaveConfig(paramsObj,msg) {
                if(msg.res) {
                    // alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>");
                    closeWindow();
                } else {
                    alert("<%=SystemEnv.getHtmlLabelName(21809,user.getLanguage()) %>");
                }
            }
            function errSaveConfig(paramsObj, textStatus, XMLHttpRequest) {}
            
            function saveConfig() {
                // console.log(JSON.stringify(getConfigData()));
                var config = getConfigData();
                config.url = "/odoc/workflow/workflow/formSignatureConfigOperation.jsp";
                queryData(config, sucSaveConfig, errSaveConfig);
                
            }
            
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
                
                jQuery("#btnTable tbody tr").bind("mousedown", function(e) {
                    copyTR = jQuery(this).next("tr.Spacing");
                });
                    
                jQuery("#btnTable tbody").sortable({ // 这里是talbe tbody，绑定 了sortable
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
            
            function getConfigData() {
                var shortCutButtonConfigArr = [];
                jQuery("#btnTable tbody").find("tr.btnConfig").each(function(index,item) {
                    shortCutButtonConfigArr.push({
                        "id":jQuery(item).find("input.btnConfigId").val(),
                        "orderNum":index+1,
                        "buttonName":jQuery(item).find("td.buttonName").html(),
                        "open":jQuery(item).find("input.btnOpenOrNot").next("span").hasClass("jNiceChecked")
                    });
                });
                return {
                    "id":jQuery("#id").val(),
                    "workflowId":jQuery("#workflowId").val(),
                    "nodeId":jQuery("#nodeId").val(),
                    "synchAllNodes":jQuery("#synchAllNodes").is(":checked"),
                    "formSignatureWidth":jQuery("#formSignatureWidth").val(),
                    "formSignatureHeight":jQuery("#formSignatureHeight").val(),
                    "autoResizeSignImage":jQuery("#autoResizeSignImage").next("span").hasClass("checked"),
                    "defaultSignType":jQuery("#defaultSignType").val(),
                    "defaultOpenSignType":jQuery("#defaultOpenSignType").val(),
                    "defaultColor":jQuery("#defaultColor").html(),
                    "defaultFontWidth":jQuery("#defaultFontWidth").val(),
                    "defaultFont":jQuery("#defaultFont").val(),
                    "defaultFontSize":jQuery("#defaultFontSize").val(),
                    "defaultSignSource":jQuery("#defaultSignSource").val(),
                    "shortCutButtonConfig":JSON.stringify(shortCutButtonConfigArr)
                };
            }
            
            function getDialog() {
                //在被打开的页面中，使用如下语句获取父窗口对象：
                var parentWin = parent.getParentWindow(window);
                //在被打开的页面中，使用如下语句获取Dialog对象：
                return parent.getDialog(window);
            }
            function closeWindow(){
                getDialog().close();
            }
            
        </script>
    </HEAD>
	<BODY>
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveConfig(),_self}";
		RCMenuHeight += RCMenuHeightStep; 
	%>

	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
    
    <jsp:include page="/systeminfo/commonTabHead.jsp">
       <jsp:param name="mouldID" value="workflow"/>
       <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelNames("21750,68",user.getLanguage()) %>'/>
    </jsp:include>

    <table id="topTitle" cellpadding="0" cellspacing="0">
        <tr>
            <td></td>
            <td class="rightSearchSpan" style="text-align:right; width:500px!important">
                <input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="qr_btn_submit" class="e8_btn_top" onclick="saveConfig()">
                <span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
            </td>
        </tr>
    </table> 
    
	<form name="formSignatureCfg" method="post" action="" >
		<INPUT TYPE="hidden" id="workflowId"name="workflowId" VALUE="<%=workflowId %>" />  
		<INPUT TYPE="hidden" id="nodeId" name="nodeId" VALUE="<%=nodeId %>" />
		<INPUT TYPE="hidden" id="id" name="id" VALUE="<%=formSignatueConfig.getId() %>" />

		<wea:layout attributes="{'expandAllGroup':'true','layoutTableId':'layoutElement'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage())%>'>
                <!-- 同步到所有节点 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
                <wea:item>
                    <input class="inputstyle" type="checkbox" id="synchAllNodes" name="synchAllNodes" value="1" />
                </wea:item>
                <!-- 表单签章宽度 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(21830, user.getLanguage())%></wea:item>
                <wea:item>
                    <input class="inputstyle" id="formSignatureWidth" name="formSignatureWidth" value="<%=formSignatueConfig.getFormSignatureWidth() %>" maxlength="4"
                                 size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("formSignatureWidth");checkinput("formSignatureWidth","formSignatureWidthImage")' />
                    <span id="formSignatureWidthImage"></span>
                </wea:item>
                <!-- 表单签章高度 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(21831, user.getLanguage())%></wea:item>
                <wea:item>
                    <input class="inputstyle" id="formSignatureHeight" name="formSignatureHeight" value="<%=formSignatueConfig.getFormSignatureHeight() %>" maxlength="4"
                           size="4" onKeyPress="ItemCount_KeyPress()" onChange='checknumber("formSignatureHeight");checkinput("formSignatureHeight","formSignatureHeightImage")' />
                    <span id="formSignatureHeightImage"></span>		
                </wea:item>
                <!-- 签章图片大小根据内容自适应 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131869,user.getLanguage())%></wea:item>
                <wea:item>
                    <input class="inputstyle" type="checkbox" tzCheckbox="true" id="autoResizeSignImage" name="autoResizeSignImage" value="1" <% if(formSignatueConfig.isAutoResizeSignImage()) { %> checked <% } %> />
                    <span class="e8tips" title="此开关关闭，则生成的签章图片大小固定为表单签章宽度*表单签章高度；此开关开启，则签章内容占多大区域，生成的签章图片就多大，最大不超过表单签章宽度*表单签章高度"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                </wea:item>
                <!-- 默认签章类型 -->
                <wea:item><%=SystemEnv.getHtmlLabelNames("149,127436",user.getLanguage()) %></wea:item>
                <wea:item>
                    <select class="inputstyle" id="defaultSignType" name="defaultSignType">
                        <option value="1" <% if("1".equals(formSignatueConfig.getDefaultSignType())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(25349,user.getLanguage())%></option>
                        <option value="2" <% if("2".equals(formSignatueConfig.getDefaultSignType())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(21441,user.getLanguage())%></option>
                    </select>
                </wea:item>
                <!-- 打开签章后默认页签 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131871,user.getLanguage()) %></wea:item>
                <wea:item>
                    <select class="inputstyle" id="defaultOpenSignType" name="defaultOpenSignType">
                        <option value="1" <% if("1".equals(formSignatueConfig.getDefaultOpenSignType())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(30490,user.getLanguage())%></option>
                        <option value="2" <% if("2".equals(formSignatueConfig.getDefaultOpenSignType())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(25349,user.getLanguage())%></option>
                        <option value="3" <% if("3".equals(formSignatueConfig.getDefaultOpenSignType())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(21441,user.getLanguage())%></option>
                    </select>
                </wea:item>
                <!-- 默认颜色 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131872,user.getLanguage()) %></wea:item>
                <wea:item>
                    <span class='right2'>
                        <span id='defaultColor' name="defaultColor" class='colorblock' defaultcolor="<%=formSignatueConfig.getDefaultColor() %>"></span>
                    </span>
                </wea:item>
                <!-- 默认笔宽 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131874,user.getLanguage())%></wea:item>
                <wea:item>
                    <select class="inputstyle" id="defaultFontWidth" name="defaultFontWidth">
                        <option value="1" <% if("1".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >1</option>
                        <option value="2" <% if("2".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >2</option>
                        <option value="3" <% if("3".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >3</option>
                        <option value="4" <% if("4".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >4</option>
                        <option value="5" <% if("5".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >5</option>
                        <option value="6" <% if("6".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >6</option>
                        <option value="7" <% if("7".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >7</option>
                        <option value="8" <% if("8".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >8</option>
                        <option value="9" <% if("9".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >9</option>
                        <option value="10" <% if("10".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >10</option>
                        <option value="11" <% if("11".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >11</option>
                        <option value="12" <% if("12".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >12</option>
                        <option value="13" <% if("13".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >13</option>
                        <option value="14" <% if("14".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >14</option>
                        <option value="15" <% if("15".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >15</option>
                        <option value="16" <% if("16".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >16</option>
                        <option value="17" <% if("17".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >17</option>
                        <option value="18" <% if("18".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >18</option>
                        <option value="19" <% if("19".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >19</option>
                        <option value="20" <% if("20".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >20</option>
                        <option value="21" <% if("21".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >21</option>
                        <option value="22" <% if("22".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >22</option>
                        <option value="23" <% if("23".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >23</option>
                        <option value="24" <% if("24".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >24</option>
                        <option value="25" <% if("25".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >25</option>
                        <option value="26" <% if("26".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >26</option>
                        <option value="27" <% if("27".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >27</option>
                        <option value="28" <% if("28".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >28</option>
                        <option value="29" <% if("29".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >29</option>
                        <option value="30" <% if("30".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >30</option>
                        <option value="31" <% if("31".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >31</option>
                        <option value="32" <% if("32".equals(formSignatueConfig.getDefaultFontWidth())) {%> selected <% } %> >32</option>
                    </select>
                </wea:item>
                <!-- 默认字体 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131873,user.getLanguage())%></wea:item>
                <wea:item>
                    <brow:browser name="defaultFont" viewType="0" hasBrowser="true" hasAdd="false" browserUrl="/systeminfo/BrowserMain.jsp?url=/page/maint/style/FontSelect.jsp?resourceids=&isDialog=1" isAutoComplete="true" 
                        isMustInput="1" completeUrl="/data.jsp?type=odoc_font" browserSpanValue="<%=defaultFontName %>" browserValue='<%=""+formSignatueConfig.getDefaultFont() %>' isSingle="true" hasInput="true" width="300px" />
                </wea:item>
                <!-- 默认字号 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131875,user.getLanguage())%></wea:item>
                <wea:item>
                    <span class='right2'><input id="defaultFontSize" class='spin height' maxnum="59" minnum="0" value="<%=formSignatueConfig.getDefaultFontSize() %>" /></span>
                </wea:item>
                <!-- 默认签章来源 -->
                <wea:item><%=SystemEnv.getHtmlLabelName(131876,user.getLanguage())%></wea:item>
                <wea:item>
                    <select class="inputstyle" id="defaultSignSource" name="defaultSignSource">
                        <option value="1" <% if("1".equals(formSignatueConfig.getDefaultSignatureSource())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(131877,user.getLanguage())%></option>
                        <option value="2" <% if("2".equals(formSignatueConfig.getDefaultSignatureSource())) {%> selected <% } %> ><%=SystemEnv.getHtmlLabelName(131879,user.getLanguage())%></option>
                    </select>
                </wea:item>
			</wea:group>
            <wea:group context='<%=SystemEnv.getHtmlLabelName(131880,user.getLanguage())%>'>
                <wea:item attributes="{'isTableList':'true'}">
                    <table class="ListStyle" cellspacing="0" cols="3" id="btnTable">
                        <colgroup>
                            <col width="5%">
                            <col width="45%">
                            <col width="50%">
                        </colgroup>
                        <tr class="header notMove">
                            <td>&nbsp;</td>
                            <td><%=SystemEnv.getHtmlLabelName(125138,user.getLanguage()) %></td>
                            <td><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage()) %></td>
                        </tr>
                        
                        <tr class='Spacing' style="height:1px!important;"><td colspan="3" class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>
                        <tbody>
<% for(ShortCutButtonConfigInfo cfg : shortCutButtonConfigList) { %>
                        <tr class="btnConfig">
                            <td height="23">
                                &nbsp;
                                <img moveimg src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783,user.getLanguage())%>' />
                                <input type="hidden" class="btnConfigId" value="<%=cfg.getId() %>" />
                                <input type="hidden" class="btnOrderNum" value="<%=cfg.getOrderNum() %>" />
                            </td>
                            <td height="23" class="buttonName"><%=cfg.getButtonName() %></td>
                            <td height="23">
                                <input type="checkbox" class="inputstyle btnOpenOrNot" value="1" <% if(cfg.isOpen()) { %> checked <% } %> />
                            </td>
                        </tr>
                        <tr class='Spacing' style="height:1px!important;"><td colspan="3" class='paddingLeft18'><div class='intervalDivClass'></div></td></tr>        
<% } %>
                    </tbody>
                    </table>
                </wea:item>
            </wea:group>
			
			
		</wea:layout>
	</FORM>
    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
        <wea:layout needImportDefaultJsAndCss="false">
            <wea:group context="" attributes="{groupDisplay:none}">
                <wea:item type="toolbar">
                    <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWindow();">
            </wea:item>
            </wea:group>
        </wea:layout>
    </div>	
	</BODY>

</HTML>
