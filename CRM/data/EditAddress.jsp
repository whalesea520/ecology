
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.crm.util.CrmFieldComInfo"%> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetT" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CountryComInfo" class="weaver.hrm.country.CountryComInfo" scope="page"/>
<jsp:useBean id="ProvinceComInfo" class="weaver.hrm.province.ProvinceComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="CrmUtil" class="weaver.crm.util.CrmUtil" scope="page" />
<jsp:useBean id="CityComInfo" class="weaver.hrm.city.CityComInfo" scope="page"/>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/CRM/data/uploader.jsp" %>
<%
String addressid = Util.null2String(request.getParameter("id"));
String parent = Util.null2String(request.getParameter("parent"));//parent 为detail表示是由viewaaddressDetail.jsp页面跳转过来的
rs.execute("select *  from CRM_CustomerAddress where id = "+addressid);
if(rs.getCounts()<=0){
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_EA2");
	return;
}

rs.first();

String CustomerID = Util.null2String(rs.getString("customerid"));
String TypeID = Util.null2String(rs.getString("typeid"));
String country = Util.null2String(rs.getString("country"));
String province = Util.null2String(rs.getString("province"));

char flag = 2;
RecordSetT.executeProc("CRM_AddressType_SelectByID",TypeID);
if(RecordSetT.getFlag()!=1){
	response.sendRedirect("/CRM/DBError.jsp?type=FindData_EA0");
	return;
}
RecordSetT.first();

RecordSetC.executeProc("CRM_CustomerInfo_SelectByID",CustomerID);
if(RecordSetC.getCounts()<=0){
	response.sendRedirect("/base/error/DBError.jsp?type=FindData_EA1");
	return;
}
RecordSetC.first();


/*权限判断－－Begin*/

String useridcheck=""+user.getUID();
String customerDepartment=""+RecordSetC.getString("department") ;
boolean canedit=false;
boolean isCustomerSelf=false;


int sharelevel = CrmShareBase.getRightLevelForCRM(""+user.getUID(),CustomerID);
if(sharelevel>1) canedit=true;

if(user.getLogintype().equals("2") && CustomerID.equals(useridcheck)){
isCustomerSelf = true ;
}
if(useridcheck.equals(RecordSetC.getString("agent"))){ 
	 canedit=true;
 }

if(RecordSetC.getInt("status")==7 || RecordSetC.getInt("status")==8){
	canedit=false;
}

/*权限判断－－End*/

if(!canedit && !isCustomerSelf) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

<SCRIPT language="javascript" src="/CRM/js/util_wev8.js"></script>
<link rel="stylesheet" href="/CRM/css/Base1_wev8.css"/>
<link rel="stylesheet" href="/CRM/css/Contact1_wev8.css" />

<SCRIPT language="javascript" src="/hrm/area/browser/areabrowser_wev8.js"></script>
<LINK href="/hrm/area/browser/areabrowser.css" type=text/css rel=STYLESHEET>

<style>
			
.sbHolder{
	display:none;
}

.e8_os{
	display:none;
	height:28px;
}
.browser{
	display:none;
	height:28px;
}
.calendar{
	display: none;
}
.e8_txt{
	height:28px;
	line-height:28px;
}
</style>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(110,user.getLanguage())+" - "+SystemEnv.getHtmlLabelName(136,user.getLanguage())+":<a href='/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+RecordSetC.getString("id")+"'>"+Util.toScreen(RecordSetC.getString("name"),user.getLanguage())+"</a>";

String temStr="";
temStr+=SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(63,user.getLanguage())+":"+Util.toScreen(RecordSetT.getString("fullname"),user.getLanguage());
titlename+="&nbsp;&nbsp;&nbsp;&nbsp;"+temStr;
String needfav ="1";
String needhelp ="";
%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

if("detail".equals(parent)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(110,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height: 445px;">
<FORM id=weaver name=weaver action="/CRM/data/AddressOperation.jsp" method=post onsubmit='return check_form(this,"Address1")'>
<input type="hidden" name="method" value="edit">
<wea:layout attributes="{'expandAllGroup':'true'}">
	<%
		CrmFieldComInfo comInfo = new CrmFieldComInfo() ;
		rst.execute("select t1.*,t2.* from CRM_CustomerDefinFieldGroup t1 left join "+
				"(select groupid,count(groupid) groupcount from CRM_CustomerDefinField where isopen=1 and usetable = 'CRM_CustomerAddress' group by groupid) t2 on t1.id=t2.groupid "+
				"where t1.usetable = 'CRM_CustomerAddress' and t2.groupid is not null order by t1.dsporder asc");
		while(rst.next()){
			String groupid = rst.getString("id");
			int groupcount = Util.getIntValue(rst.getString("groupcount"),0);
			if(0 == groupcount && !groupid.equals("6")){
				continue;
			}
		%>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(rst.getInt("grouplabel"),user.getLanguage())%>'>
				
				<%while(comInfo.next()){
					if("CRM_CustomerAddress".equals(comInfo.getUsetable())&&groupid.equals(comInfo.getGroupid().toString())){
				%>
					<%if(comInfo.getFieldname().equals("city")){ 
						String city = Util.toScreenToEdit(rs.getString("city"),user.getLanguage());
						int cityIsmust = Util.getIntValue(comInfo.getIsmust(),0);
						%>
						<wea:item><%=SystemEnv.getHtmlLabelName(493,user.getLanguage())%></wea:item>
						<wea:item>
							<%if(canedit){ %>
								<div areaType="city" areaName="city" areaValue="<%=city%>" 
									areaSpanValue="<%=CityComInfo.getCityname(city)%>"  areaMustInput="<%=cityIsmust %>"  areaCallback="areaCallBackUpdate"  class="_areaselect" id="_areaselect_cityid"></div>																	
					  		<%}else{ %>
					  			<div class="e8_txt" id="txtdiv_city">
									<%if(!city.equals("0") && !city.equals("")){ %>
										<%=CityComInfo.getCityname(city)%>
									<%} %>
								</div>
					  		<%}%>
						</wea:item>	
					<%}else{%>
						<wea:item><%=CrmUtil.getHtmlLableName(comInfo , user)%></wea:item>
						<wea:item>
							<%if(canedit){%>
								<%=CrmUtil.getHtmlElementSetting(comInfo ,rs.getString(comInfo.getFieldname()) ,user , "edit")%>
							<%}%>
							<%=CrmUtil.getHmtlElementInfo(comInfo ,rs.getString(comInfo.getFieldname()) ,user , canedit?"edit":"info")%>
						</wea:item>
					<%}%>
				<%}} %>
				<%if(groupid.equals("8")){ %>
					<wea:item><%=SystemEnv.getHtmlLabelName(377,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(canedit){ %>
							<div areaType="country" areaName="country" areaValue="<%=country%>" 
								areaSpanValue="<%=CountryComInfo.getCountryname(country)%>"  areaMustInput="1"  areaCallback="areaCallBackUpdate"  class="_areaselect" id="_areaselect_countryid"></div>
				  		<%}else{%>
			  			<div class="e8_txt" id="txtdiv_country">
							<%if(!country.equals("0") && !country.equals("")){ %>
								<%=CountryComInfo.getCountryname(country)%>
							<%} %>
						</div>
						<%} %>
					</wea:item>
				
				
					<wea:item><%=SystemEnv.getHtmlLabelName(800,user.getLanguage())%></wea:item>
					<wea:item>
						<%if(canedit){ %>
							<div areaType="province" areaName="province" areaValue="<%=province%>" 
								areaSpanValue="<%=ProvinceComInfo.getProvincename(province)%>"  areaMustInput="1"  areaCallback="areaCallBackUpdate"  class="_areaselect" id="_areaselect_provinceid"></div>																	
				  		<%}else{%>
			  			<div class="e8_txt" id="txtdiv_province">
							<%if(!province.equals("0") && !province.equals("")){ %>
								<%=ProvinceComInfo.getProvincename(province)%>
							<%} %>
						</div>
						<%} %>
					</wea:item>
				<%} %>
			</wea:group>
	<%} %>
</wea:layout>
</FORM>	
<!-- 提示信息 -->
<div id="warn">
	<div class="title"></div>
</div>
</div>		
		
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWin()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript"><!--

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
var updateFlag = false;
function closeWin(){
	if(updateFlag){
		parentWin.callback();
	}else{
		dialog.close();
	}
}

var tempval = "";
$(document).ready(function(){
		areromancedivs();
		//绑定附件上传功能
		jQuery("div[name=uploadDiv]").each(function(){
	        bindUploaderDiv($(this),"<%=addressid%>"); 
	        jQuery(this).find("#uploadspan").append($(this).attr("checkinputImage"));
	        if(jQuery(this).attr("ismust")== 1 && jQuery(this).parent("td").find(".txtlink").length != 0){
    			jQuery("#"+$(this).attr("fieldNameSpan")).html("");
    		}
    	});
    	
    	//绑定checkbox事件
		jQuery(".item_checkbox").bind("click",function(){
			exeUpdate(jQuery(this).attr("name"),jQuery(this).is(":checked")?"1":"0","num");
		});
		
		jQuery("#objName").css("font-size","16px");
		
		<%if(canedit){%>
			
			$(".item_input").bind("focus",function(){
				
				$(this).addClass("item_input_focus");
				var _selectid = getVal($(this).attr("_selectid"));
				if(_selectid!=""){
					if($(this).attr("id")=="projectrole"){
						var selectids = $(this).val();
						var ids = selectids.split(",");
						$("div.roletype").removeClass("roletype_select");
						for(var i=0;i<ids.length;i++){
							if(ids[i]!=""){
								$("#roleitem_"+ids[i]).addClass("roletype_select");
							}
						}
					}
					var _top = $(this).offset().top + 26;
					var _left = $(this).offset().left;
					$("#"+_selectid).css({"top":_top,"left":_left}).show();
					$(this).width(100);
				}
				if(this.id=="experience" || this.id=="remark"){
					$(this).height(70);
				}
				tempval = $(this).val();
				foucsobj2 = this;
			}).bind("blur",function(){
				$(this).removeClass("item_input_focus");
				if(this.id=="experience" || this.id=="remark"){
					setRemarkHeight(this.id);
				}
				if(!$(this).hasClass("input_select")){
					doUpdate(this,1);
				}
			});
	
			
			//表格行背景效果及操作按钮控制绑定
			$("table.LayoutTable").find("td.field").bind("click mouseenter",function(){
				$(".btn_add").hide();$(".btn_browser").hide();
				$(this).addClass("td_hover").prev("td.title").addClass("td_hover");
				$(this).find(".item_input").addClass("item_input_hover");
				//$(this).find(".item_num").width(100);
				
				$(this).find("span.browser").show();
				$(this).find("div.e8_os").show();
				$(this).find(".calendar").show();
				$(this).find("div.e8_txt").hide();
				
				//对select框进行处理
				$(this).find(".sbHolder").parent().show();
				$(this).find("div.e8_select_txt").hide();
				
				if($(this).find("input.add_input2").css("display")=="none"){
					$(this).find("div.btn_add").show();
					$(this).find("div.btn_browser").show();
				}
				$(this).find("div.btn_add2").show();
				$(this).find("div.btn_browser2").show();
	
				if($(this).attr("id")=="imcodetd") $("#imcodelink").show();
				//$(this).find("div.upload").show();
			}).bind("mouseleave",function(){
				$(this).removeClass("td_hover").prev("td.title").removeClass("td_hover");
				$(this).find(".item_input").removeClass("item_input_hover");
				//$(this).find(".item_num").width(40);
				
				$(this).find("span.browser").hide();
				$(this).find("div.e8_os").hide();
				$(this).find(".calendar").hide();
				$(this).find("div.e8_txt").show();
				
				//对select框进行处理
				if($(this).find(".sbHolder").length>0){
					var sb=$(this).find("select").attr("sb");
					var e=event?event:window.event;
					if($("#sbOptions_"+sb).parent().is(":hidden")){
						$(this).find(".sbHolder").parent().hide();
						$(this).find("div.e8_select_txt").show();
					}	
				}
				
				if($(this).find("input.add_input2").css("display")=="none"){
					$(this).find("div.btn_add").hide();
					$(this).find("div.btn_browser").hide();
				}
				$(this).find("div.btn_add2").hide();
				$(this).find("div.btn_browser2").hide();
				if($(this).attr("id")=="imcodetd") $("#imcodelink").hide();
				//$(this).find("div.upload").hide();
			});
			
			$(".sbHolder").parent().hide();
	
			//联想输入框事件绑定
			$("input.add_input2").bind("focus",function(){
				if($(this).attr("_init")==1){
					$(this).FuzzyQuery({
						url:"/CRM/manage/util/GetData.jsp",
						record_num:5,
						filed_name:"name",
						searchtype:$(this).attr("_searchtype"),
						divwidth: $(this).attr("_searchwidth"),
						updatename:$(this).attr("id"),
						operate:"select",
						updatetype:"str"
					});
					$(this).attr("_init",0);
				}
				foucsobj2 = this;
			}).bind("blur",function(e){
				$(this).val("");
				$(this).hide();
				$(this).nextAll("div.btn_add").show();
				$(this).nextAll("div.btn_browser").show();
				$(this).prevAll("div.showcon").show();
			});
	
			$("div.datamore").live("mouseover",function(){
				$(this).addClass("datamore_hover");
			}).live("mouseout",function(){
				$(this).removeClass("datamore_hover");
			});
	
			$("#leftdiv").scroll(function(){
				$(".item_select").hide();
			});
	
	
			//页面点击及回车事件绑定
			$(document).bind("click",function(e){
				var target=$.event.fix(e).target;
				if(!$(target).hasClass("item_select")){
					$("div.item_select").hide();
					if($(target).hasClass("input_select")){
						var _selectid = $(target).attr("_selectid");
						$("#"+_selectid).show();
					}
				}
				if($(target).attr("id")!="projectrole" && $(target).parent().attr("id") != "pr_select"){
					$("#pr_select").hide();
			    }
			}).bind("keydown",function(e){
				e = e ? e : event;   
			    if(e.keyCode == 13){
					var target=$.event.fix(e).target;
					if($(target).hasClass("item_input") && $(target).attr("id")!="experience" && $(target).attr("id")!="remark"){
			    		$(foucsobj2).blur();  
			    		$("div.item_select").hide();
			    		$("#pr_select").hide();
			    	}
			    }
			});
		<%}%>
});

<%if(canedit){%>
function onShowDate1(spanname,inputname,mand){
  tempval = $ele4p(inputname).value;
  var fieldName = jQuery($ele4p(inputname)).parent("td").find("input").attr("name");
  var oncleaingFun = function(){
	    if(mand == 1){
		 	$ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}else{
		  	$ele4p(spanname).innerHTML = '';
		}
		$ele4p(inputname).value = '';
  }
  WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		$dp.$(inputname).value = dp.cal.getDateStr();
		$dp.$(spanname).innerHTML = dp.cal.getDateStr();
	   	if($ele4p(inputname).value!=tempval){
	   		exeUpdate(fieldName,$ele4p(inputname).value,"str");
	   	}
		
 },oncleared:function(){
 	exeUpdate(fieldName,"","str");
 }});
   
   
   
   if(mand == 1){
     var hidename = $ele4p(inputname).value;
	 if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	 }else{
	   $ele4p(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	 }
   }
}

//输入框保存方法
function doUpdate(obj,type){
	
	var fieldname = $(obj).attr("id");
	var fieldtype = getVal($(obj).attr("_type"));
	if(fieldtype=="") fieldtype="str";
	var fieldvalue = "";
	if(type==1){
		if($(obj).val()==tempval) return;
		fieldvalue = $(obj).val();
	}
	if(fieldname=="email"){
		var emailStr = fieldvalue.replace(" ","");
		if (!checkEmail(emailStr)) {
			$(obj).val(tempval);
			return;
		}
	}
	
	if(obj.nodeName=="SELECT"){
		$("#txtdiv_"+fieldname).html($(obj).find("option[value="+fieldvalue+"]").text()).show();
		var sb=$(obj).attr("sb");
		$("#sbHolderSpan_"+sb).hide();
	}
	
	exeUpdate(fieldname,fieldvalue,fieldtype);
}

function areaCallBackUpdate(data){
	doSelectUpdate(data.areaname,data.id,data.name,"");
}

function callBackSelectUpdate(event,data,fieldid,oldid){
	
	if(jQuery("#"+fieldid).data("oldid")){//为true表示不是第一次进行数据修改，获取oldid作为变更前的值
		oldid = jQuery("#"+fieldid).data("oldid");
	}
	
	// 防止多浏览框，每次动态添加
	var name = "";
	var id = jQuery("#"+fieldid).val();
	
	jQuery("#"+fieldid+"span").find("a").each(function(){
		name += jQuery(this).html()+",";
	});
	if("" != name){
		name = name.substring(0,name.length-1);
	}
	
	doSelectUpdate(fieldid,id,name,oldid);
}
			
function callBackSelectDelete(text,fieldid,oldid){
	
	if(jQuery("#"+fieldid).data("oldid")){//为true表示不是第一次进行数据修改，获取oldid作为变更前的值
		oldid = jQuery("#"+fieldid).data("oldid");
	}
	
	var name = "";
	var id = jQuery("#"+fieldid).val();
	jQuery("#"+fieldid+"span").find("a").each(function(){
		if(-1 != (","+id+",").indexOf(","+jQuery(this).next("span").attr("id")+",")){
			name += jQuery(this).html()+",";
		}
	});
	if("" != name){
		name = name.substring(0,name.length-1);
	}
	doSelectUpdate(fieldid,id,name,oldid);
}

//选择内容后执行更新
function doSelectUpdate(fieldname,id,name,oldid){

	var addtxt = "";
	var fieldtype = "num";

	if(fieldname=="principalIds"){
		var sumids = "";
		var addids = "";
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if((","+vals+",").indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += "," + ids[i];
				addtxt += doTransName(fieldname,ids[i],names[i]);
			}
		}
		if(addids==""){
			return;
		}else{
			addids = addids.substring(1);
			sumids = addids;
			if(vals!="") sumids = vals+","+addids;
			$("#"+fieldname).before(addtxt);
			$("#"+fieldname+"_val").val(sumids);
			exeUpdate(fieldname,sumids,"","",addids);
		}
	}else{
		tempval = oldid;
		if(tempval==id) return;

		$("#txtdiv_"+fieldname).html(name);
		//addtxt = doTransName(fieldname,id,name);
		//$("#"+fieldname).prev("div.txtlink").remove();
		//$("#"+fieldname).before(addtxt);

		exeUpdate(fieldname,id,"num");
	}
	$("#txtdiv_"+fieldname).html(name);
	jQuery("#"+fieldname).data("oldid",id);
}
//执行编辑
function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue,setid){
	if(fieldtype == "attachment"){
		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
   		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 1){
   			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage())%>");
   			return;
   		}
	}
	
	var _tempval = tempval;
	if(typeof(delvalue)=="undefined") delvalue = "";
	if(typeof(addvalue)=="undefined") addvalue = "";
	
	$.ajax({
		type: "post",
	    url: "AddressOperation.jsp",
	    data:{"method":"edit_address_field","addressid":<%=addressid%>,"setid":setid,"fieldname":filter(encodeURI(fieldname)),"oldvalue":filter(encodeURI(tempval)),"newvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    //var txt = $.trim(data.responseText);
		    setLastUpdate();
		    
		    if(fieldtype == "attachment"){
	    		jQuery(".txtlink"+delvalue).remove();
	    		var ismust = jQuery("div[fieldName='"+fieldname+"']").attr("ismust");
	    		if(ismust==1 && jQuery("div[fieldName='"+fieldname+"']").parent("td").find(".txtlink").length == 0){
	    			var fieldNameSpan = jQuery("div[fieldName='"+fieldname+"']").attr("fieldNameSpan");
	    			jQuery("#"+fieldNameSpan).html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
	    		}
	    	}
		}
    });
	tempval = fieldvalue;
}

//显示删除按钮
function showdel(obj){
	$(obj).find("div.btn_del").show();
	$(obj).find("div.btn_wh").hide();
}
//隐藏删除按钮
function hidedel(obj){
	$(obj).find("div.btn_del").hide();
	$(obj).find("div.btn_wh").show();
}

function setLastUpdate(){
	updateFlag = true;			
	var currentdate = new Date();
	datestr = currentdate.format("yyyy-MM-dd hh:mm:ss");
	$("#lastupdate").html("由 <a href='/hrm/resource/HrmResource.jsp?id=<%=user.getUID()%>' target='_blank'><%=ResourceComInfo.getLastname(user.getUID()+"")%></a> 于 "+datestr+" 最后修改");
	
	showMsg();
}
			
//消息提醒
function showMsg(msg){
  
	jQuery("#warn").find(".title").html("操作成功！");
	jQuery("#warn").css("display","block");
	setTimeout(function (){
		jQuery("#warn").css("display","none");
	},1500);
}		
<%}%>			
</script>
</BODY>

</HTML>
