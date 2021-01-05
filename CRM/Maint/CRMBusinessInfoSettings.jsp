
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerTypeComInfo"
	class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<!DOCTYPE html>
<%
    if (!HrmUserVarify.checkUserRight("Customer:Settings", user)) {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>
<%@ include file="/workflow/request/CommonUtils.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%
    RCMenu += "{" + $label(86, user.getLanguage()) + ",javascript:doSave(),_top} ";
    RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

<%
    RecordSet.executeSql("select * from crm_busniessinfosettings where id=1");

    boolean bl = RecordSet.first();
    String isopen = "";
    String appkey = "";
    String crmtype = "";
    String iscache = "";
    String cacheday = "30";
    String serviceurl = "";
    if (bl) {
        isopen = Util.null2String(RecordSet.getString("isopen"));
        appkey = Util.null2String(RecordSet.getString("appkey"));
        crmtype = Util.null2String(RecordSet.getString("crmtype"));
        iscache = Util.null2String(RecordSet.getString("iscache"));
        cacheday = Util.null2String(RecordSet.getString("cacheday"));
        serviceurl = Util.null2String(RecordSet.getString("serviceurl"));
    }
%>
<%
	String title_key="";
	title_key+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title_key+= "<li>"+"apply for the secret key on the official website(http://www.qixin.com)."+"</li>";
	}else if(user.getLanguage()==9){
		title_key+= "<li>"+"填寫在啟信寶官方網站（http://www.qixin.com）申請的秘鑰"+"</li>";
	}else{
		title_key+= "<li>"+"填写在启信宝官方网站（http://www.qixin.com）申请的秘钥"+"</li>";
	}
	title_key+= "</ul>";
	
	String title_url="";
	title_url+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title_url+= "<li>"+"apply for the interface address from the official website(http://www.qixin.com)."+"</li>";
	}else if(user.getLanguage()==9){
		title_url+= "<li>"+"填寫在啟信寶官方網站（http://www.qixin.com）申請的接口地址"+"</li>";
	}else{
		title_url+= "<li>"+"填写在启信宝官方网站（http://www.qixin.com）申请的接口地址"+"</li>";
	}
	title_url+= "</ul>";
	
	String title = "";
	title+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title+= "<li>"+"1,cached datas will be saved for 30 days by default."+"</li>";
		title+= "<li>"+"2,according to a recent query enterprise business information cache data date, if the current date from the cache date exceeds the number of days, then re call prices sunbell query service, otherwise the default access data in the local cache.."+"</li>";
	}else if(user.getLanguage()==9){
		title+= "<li>"+"1、默認保存緩存數據30天"+"</li>";
		title+= "<li>"+"2、根據最近一次査詢企業工商資訊緩存數據的日期，如果當前日期距離緩存數據的日期超過該天數，則重新調用企信寶査詢服務，否則默認取本地緩存的數據。"+"</li>";
	}else{
		title+= "<li>"+"1、默认保存缓存数据30天。"+"</li>";
		title+= "<li>"+"2、根据最近一次查询企业工商信息缓存数据的日期，如果当前日期距离缓存数据的日期超过该天数，则重新调用企信宝查询服务，否则默认取本地缓存的数据。"+"</li>";
	}
	title+= "</ul>";
	
	String title_iscache = "";
	title_iscache+= "<ul style='padding-left:15px;'>";
	if(user.getLanguage()==8){
		title_iscache+= "<li>"+"if it is opened, the datas will be saved to the local cache table when the interface called."+"</li>";
	}else if(user.getLanguage()==9){
		title_iscache+= "<li>"+"如果開啟，則調用企信寶介面時，會保存數據到本地緩存錶中。"+"</li>";
	}else{
		title_iscache+= "<li>"+"如果开启，则调用企信宝接口时，会保存数据到本地缓存表中。"+"</li>";
	}
	title_iscache+= "</ul>";
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="stylesheet">
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/proj/js/common_wev8.js"></script>
		<script language=javascript src="/js/checkData_wev8.js"></script>
	</head>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="customer" />
			<jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(130788,user.getLanguage())%>" />
		</jsp:include>
		<wea:layout attributes="{layoutTableId:topTitle}">
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
					<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
						<input class="e8_btn_top middle" onclick="doSave()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
					</span>
					<span title="SystemEnv.getHtmlLabelName(23036,user.getLanguage())" class="cornerMenu"></span>
				</wea:item>
			</wea:group>
		</wea:layout>
		
		<form id="weaver" name="frmmain"
			action="/CRM/Maint/CRMBusinessInfoSettingsOperation.jsp?method=settings"
			method="post">
			<wea:layout type="twoCol" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=$label(31811, user.getLanguage())%>'
					attributes="{'class':'e8_title e8_title_1'}">

					<!-- 是否开启 -->
					<wea:item>
                        <%=SystemEnv.getHtmlLabelName(32165,user.getLanguage())%>
                    </wea:item>
					<wea:item>
						<script>
                           $(function(){
                            checkImgStatus()
                           });
                           function checkImgStatus(){
                              if($("#isopen").is(":checked")){
                                showEle("noImg");
                                $("#signbtn").show();
                                if($("#iscache").is(":checked")){
                                	showEle("cachedayNoImg");
                                }
                              }else{
                                hideEle("noImg");
                                $("#signbtn").hide();
                                if($("#iscache").is(":checked")){
                                	hideEle("cachedayNoImg");
                                }
                              }
                           }
                        </script>
						<input type="checkbox" id="isopen" name="isopen" onclick="checkImgStatus()"  <%if(null != isopen&&isopen.equals("1")){%> checked <%}%> value="1" tzCheckbox="true">
					</wea:item>
                    <!-- 信息来源 -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(25542,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<select id='' name="">
							<option value="1" selected>
								启信宝
							</option>
						</select>
					</wea:item>
					<!-- 接口地址 -->
                    <wea:item attributes="{'samePair':'noImg'}">
                        接口地址
                    </wea:item>
                    <wea:item attributes="{'samePair':'noImg'}">
                        <input class=InputStyle id="serviceurl" name="serviceurl" value="<%=serviceurl%>" onchange='checkinput("serviceurl","serviceurlimage")' onblur='checkinput("serviceurl","serviceurlimage")'>
                    	<SPAN ID=serviceurlimage></SPAN>
                    	<span class="help" title="<%=title_url %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
                    </wea:item>
					<!-- APPKEY -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(130789,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<input class=InputStyle id="appkey" name="appkey" value="<%=appkey%>" onchange='checkinput("appkey","appkeyimage")' onblur='checkinput("appkey","appkeyimage")'>
						<SPAN ID=appkeyimage></SPAN>
						<span class="help" title="<%=title_key %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
                    <!-- 适用客户类型 -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(130790,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<%
						    int num = 0;
						                while (CustomerTypeComInfo.next()) {
						                    num++;
						                    if (num == 9) {
						%>
						</br>
						<%
						    num = 0;
						                    }
						%>
		                     &nbsp;<%=CustomerTypeComInfo.getCustomerTypename()%>
						<input id="crmtype" name="crmtype" type="checkbox" class="ckbox"
							value="<%=CustomerTypeComInfo.getCustomerTypeid()%>"
							<%
							if(crmtype.contains(",")) {
							    String ct[] = crmtype.split(",");
							    for(int i=0;i<ct.length;i++) {
							        if(ct[i].equals(CustomerTypeComInfo.getCustomerTypeid())) {
	                                     %>
	                                checked="checked"
	                                <%
	                                 }  
							    }
							}else {
							    if(crmtype.equals(CustomerTypeComInfo.getCustomerTypeid())) {
	                                 %>
	                            checked="checked"
	                            <%
	                             } 
							}
							
		                     %> />
						<%
						    }
						%>

					</wea:item>
                    <!-- 是否缓存数据 -->
					<wea:item attributes="{'samePair':'noImg'}">
                        <%=SystemEnv.getHtmlLabelName(130791,user.getLanguage())%>
                    </wea:item>
					<wea:item attributes="{'samePair':'noImg'}">
						<script>
                           $(function(){
                            checkIsopenImgStatus()
                           });
                           function checkIsopenImgStatus(){
                              if($("#iscache").is(":checked")&&$("#isopen").is(":checked")){
                                showEle("cachedayNoImg");
                                $("#signbtn").show();
                              }else{
                                hideEle("cachedayNoImg");
                                $("#signbtn").hide();
                              }
                           }
                        </script>
						<input type="checkbox" id='iscache' name="iscache" onclick="checkIsopenImgStatus()" <%if(null != iscache&&iscache.equals("1")){%> checked <%}%> value="1" tzCheckbox="true">
					   <span class="help" title="<%=title_iscache %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
                    <!-- 缓存保存天数 -->
					<wea:item  attributes="{'samePair':'cachedayNoImg'}">
                       <%=SystemEnv.getHtmlLabelName(130792,user.getLanguage())%>
                    </wea:item>
					<wea:item  attributes="{'samePair':'cachedayNoImg'}">
						<input class="InputStyle" onkeypress="ItemNum_KeyPress()"
							onblur="validateCacheday(this)" style="width: 80px !important;"
							maxlength="8" size="10" id="cacheday" name="cacheday" value="<%=cacheday%>" onblur='checkinput("cacheday","cachedayspan")' onchange='checkinput("cacheday","cachedayspan")'>
						<SPAN ID=cachedayspan></SPAN>
						<span class="help" title="<%=title %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
		</div>
		<script>
			function doSave(){
				//是否启用，启用时则才调用，否则不调用验证
				if($('#isopen').is(':checked')) {
					var serviceurl = $("#serviceurl").val();
					var appkey = $("#appkey").val();
					//接口地址和key必填
					if(""==serviceurl||""==appkey){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
						return;
					}
					//缓存数据选中时，天数必填
					if($('#iscache').is(':checked')) {
						var cacheday = $("#cacheday").val();
						if(""==cacheday){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
							return;
						}
					}
					//至少选中一个客户类型
					if($(".jNiceChecked").length==0){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18214,1282",user.getLanguage())%>");
						return;
					}
				}
				$('#weaver').submit();
			}
			
			//缓存天数必须是正整数
			function validateCacheday(objectname){
			    valuechar = objectname.value.split("") ;
			    isnumber = false ;
			    for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)) isnumber = true ;}
			    if(isnumber) objectname.value = "30" ;
			}
			
			//初始化
			$(function(){
				checkinput("serviceurl","serviceurlimage");
				checkinput("appkey","appkeyimage");
				$(".help").wTooltip({html:true});
			});
		</script>
	</body>
</html>
