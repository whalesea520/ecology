
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

</head>
<%

String selectValue = Util.null2String(request.getParameter("selectValue"));

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
//System.out.println("selectValue:"+selectValue);
%>

<% 
	List depat_keys = new ArrayList();
	depat_keys.add("1");
	depat_keys.add("10");
	depat_keys.add("11");
	depat_keys.add("12");
	depat_keys.add("13");
	
	List depat_values = new ArrayList();
	depat_values.add(SystemEnv.getHtmlLabelName(21837,user.getLanguage()));
	depat_values.add(SystemEnv.getHtmlLabelName(15772,user.getLanguage()));
	depat_values.add(SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(15772,user.getLanguage()));
	depat_values.add(SystemEnv.getHtmlLabelName(17587,user.getLanguage()));
	depat_values.add(SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(17587,user.getLanguage()));
	
	
	List subcom_keys = new ArrayList();
	subcom_keys.add("2");
	subcom_keys.add("20");
	subcom_keys.add("21");
	subcom_keys.add("22");
	subcom_keys.add("23");
	
	List subcom_values = new ArrayList();
	subcom_values.add(SystemEnv.getHtmlLabelName(30792,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(22753,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(22753,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(17898,user.getLanguage()));
	subcom_values.add(SystemEnv.getHtmlLabelName(235,user.getLanguage())+SystemEnv.getHtmlLabelName(17898,user.getLanguage()));

%>
<script type="text/javascript">
jQuery(function(){
	try{
		//jQuery("#topTitle").topMenuTitle({searchFn:onSearch});
	}catch(e){}
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:null,
        objName:"<%=SystemEnv.getHtmlLabelName(713, user.getLanguage())%>",
        mouldID:"<%= MouldIDConst.getID("workflow")%>"
    });
 
 }); 
 
</script>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:save(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetData(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:cancel(),_self}" ;
	RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmain" method="post" action="rightAttributeDepat.jsp">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right; width:500px!important">
  			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="save()">
  			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="resetData()">
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<div class="e8_box">
      <div class="e8_boxhead">
         <div class="div_e8_xtree" id="div_e8_xtree"></div>
         <div class="e8_tablogo" id="e8_tablogo"></div>
         <div class="e8_ultab">
              <div class="e8_navtab" id="e8_navtab">
              <span id="objName"></span>
         </div>
         <div>
             <ul class="tab_menu">
               
        
           <li class="current" id="attrtab0">
            <a href="javascript:attrtabchange(0);" >
             <%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>
            </a>
           </li>
            <li id="attrtab1">
            <a href="javascript:attrtabchange(1);" >
             <%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%>
            </a>
           </li>
           
          </ul>
         <div id="rightBox" class="e8_rightBox">
         </div>
       </div>
     </div>
  </div>
   <div class="tab_box">
         <div style="">
            	<div id="attrDepatTab" style="">
				    <wea:layout type="2col">
					  <wea:group context='<%=SystemEnv.getHtmlLabelNames("124,713",user.getLanguage()) %>' attributes="{'groupDisplay':'none'}">
				          <wea:item attributes="{'isTableList':'true'}">
							<TABLE class=ListStyle cellspacing=0>
							<COLGROUP>
								<COL width="10">
								<COL width="*">
							</COLGROUP>
							<TR class="header">
								<TD><input type="checkbox" value="" id="depatAll" name="depatAll"/> </TD>
								<TD><nobr><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16510,user.getLanguage())%></TD>
							</TR>
							
						  <%
					      for(int i=0 ;i<depat_keys.size();i++){
					      	String key = depat_keys.get(i)+"";
					      	String value = depat_values.get(i)+"";
					       %>
				            <TR>
								<TD><input type="checkbox" value="<%=key %>" id="depat_<%=key %>" name="depat_<%=key %>"/> </TD>
								<TD> <span id="depat_<%=key %>_span"><%=value%></span></TD>
							</TR>	    
							<tr class='Spacing' style="height:1px!important;"><td colspan=2 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				          <%} %>
							
							</TABLE>		
						</wea:item>
				          
					  </wea:group>
					</wea:layout>
				
				
				</div>
				
				
				<div id="attrSubcomTab" style="display:none;">
				    <wea:layout type="2col">
					  <wea:group context='<%=SystemEnv.getHtmlLabelNames("141,713",user.getLanguage()) %>' attributes="{'groupDisplay':'none'}">
				          <wea:item attributes="{'isTableList':'true'}">
							<TABLE class=ListStyle cellspacing=0>
							<COLGROUP>
								<COL width="10">
								<COL width="*">
							</COLGROUP>
							<TR class="header">
								<TD><input type="checkbox" value="" id="subcomAll" name="subcomAll" /></TD>
								<TD><nobr><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(16510,user.getLanguage())%></TD>
							</TR>
							
						  <%
					       for(int i=0 ;i<subcom_keys.size();i++){
					      	String key = subcom_keys.get(i)+"";
					      	String value = subcom_values.get(i)+"";
					       %>
				            <TR>
								<TD><input type="checkbox" value="<%=key %>" id="subcom_<%=key %>" name="subcom_<%=key %>"/> </TD>
								<TD><span id="subcom_<%=key %>_span"><%=value%></TD>
							</TR>	    
							<tr class='Spacing' style="height:1px!important;"><td colspan=2 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				          <%} %>
							</TABLE>		
						</wea:item>
				          
				          
					  </wea:group>
					</wea:layout>
				    
				
				</div> 

         </div>
     </div>
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

</form>
<script language=javascript>
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);


var tabid = 0;
function attrtabchange(tabindex){
    tabid = tabindex;
    if(tabindex==0){
        jQuery("#attrDepatTab").css("display", "");
        //jQuery("#oTDtype_0").css("font-weight", "bold");
        //jQuery("#oTDtype_0").css("background", "url(/images/tab.active2_wev8.png) no-repeat");

        jQuery("#attrSubcomTab").css("display", "none");
        //jQuery("#oTDtype_1").css("font-weight", "normal");
        //jQuery("#oTDtype_1").css("background", "url(/images/tab2_wev8.png) no-repeat");
        jQuery("#attrtab0").addClass("current");
        jQuery("#attrtab1").removeClass("current");
        clearSubcomChk();
    }else if(tabindex==1){
        jQuery("#attrDepatTab").css("display", "none");
        //jQuery("#oTDtype_0").css("font-weight", "normal");
        //jQuery("#oTDtype_0").css("background", "url(/images/tab2_wev8.png) no-repeat");

        jQuery("#attrSubcomTab").css("display", "");
        //jQuery("#oTDtype_1").css("font-weight", "bold");
        //jQuery("#oTDtype_1").css("background", "url(/images/tab.active2_wev8.png) no-repeat");
       jQuery("#attrtab1").addClass("current");
       jQuery("#attrtab0").removeClass("current");
       clearDeptChk();
    }
    jQuery("body").jNice();
}

var selectValue = '<%=selectValue%>';

jQuery(document).ready(function(){
	jQuery("#depatAll").click(function(){
		if(jQuery(this).attr('checked')==false){
			jQuery("input[name^='depat_']").each(function(){
				jQuery(this).removeAttr("checked");
			});
		}else{
			jQuery("input[name^='depat_']").each(function(){
				jQuery(this).attr("checked","checked");
			});
		}
		
		if(jQuery(this).attr("checked")==true){
			jQuery("[name ^= 'depat_']:checkbox").attr("checked", true).trigger('change').next("span").addClass("jNiceChecked");
		}else{
			jQuery("[name ^= 'depat_']:checkbox").attr("checked", false).trigger('change').next("span").removeClass("jNiceChecked");
		}
		
		disabledDept();
	});
	
	jQuery("#subcomAll").click(function(){
		if(jQuery(this).attr('checked')==false){
			jQuery("input[name^='subcom_']").each(function(){
				jQuery(this).removeAttr("checked");
			});
		}else{
			jQuery("input[name^='subcom_']").each(function(){
				jQuery(this).attr("checked","checked");
			});
		}
		
		if(jQuery(this).attr("checked")==true){
			jQuery("[name ^= 'subcom_']:checkbox").attr("checked", true).trigger('change').next("span").addClass("jNiceChecked");
		}else{
			jQuery("[name ^= 'subcom_']:checkbox").attr("checked", false).trigger('change').next("span").removeClass("jNiceChecked");
		}
		disabledSubcom();
		
	});
	
	//所有上级部门  ，所有下级部门
	jQuery("#depat_11,#depat_13").click(function(){
		disabledDept();
	});
	//所有上级分部  ，所有下级分部
	jQuery("#subcom_21,#subcom_23").click(function(){
		disabledSubcom();
	});
	
	init();
	
	jQuery("body").jNice();
});

function init(){
	if(selectValue!=""){
		var sv = selectValue.split(",");
		for(var i=0;i<sv.length;i++){
			var s = sv[i];
			try{
				if(s.indexOf("2")!=0){
					jQuery("#depat_"+s).attr("checked","checked");
					jQuery("#depat_"+s).next("span").addClass("jNiceChecked");
				}
				else{
					 jQuery("#subcom_"+s).attr("checked","checked");
					 jQuery("#subcom_"+s).next("span").addClass("jNiceChecked");
					 if(i==0)attrtabchange(1);
				}
			}catch(e){}
		}
		
		disabledDept();
		disabledSubcom();
	}
}

function clearDeptChk(){
	jQuery("#depatAll").removeAttr("checked");
	jQuery("#depatAll").next("span").removeClass("jNiceChecked");
	jQuery("input[name^='depat_']").each(function(){
		jQuery(this).removeAttr("checked");
		jQuery(this).next("span").removeClass("jNiceChecked");
	});
	disabledDept();
}

function clearSubcomChk(){
	jQuery("#subcomAll").removeAttr("checked");
	jQuery("#subcomAll").next("span").removeClass("jNiceChecked");
	jQuery("input[name^='subcom_']").each(function(){
		jQuery(this).removeAttr("checked");
		jQuery(this).next("span").removeClass("jNiceChecked");
	});
	disabledSubcom();
}

function disabledDept(){
	if(jQuery("#depat_11").attr("checked")==true){ //所有上级部门
		jQuery("#depat_10").removeAttr("checked"); //上级部门
		jQuery("#depat_10").attr("disabled","disabled");
		jQuery("#depat_10").next("span").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
	}else{
		jQuery("#depat_10").removeAttr("disabled");
		jQuery("#depat_10").next("span").removeClass("jNiceCheckbox_disabled");
	}
	
	if(jQuery("#depat_13").attr("checked")==true){ //所有下级部门
		jQuery("#depat_12").removeAttr("checked"); //下级部门
		jQuery("#depat_12").attr("disabled","disabled");
		jQuery("#depat_12").next("span").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
	}else{
		jQuery("#depat_12").removeAttr("disabled");
		jQuery("#depat_12").next("span").removeClass("jNiceCheckbox_disabled");
	}
}

function disabledSubcom(){
	if(jQuery("#subcom_21").attr("checked")==true){ //所有上级分部
		jQuery("#subcom_20").removeAttr("checked"); //上级分部
		jQuery("#subcom_20").attr("disabled","disabled");
		jQuery("#subcom_20").next("span").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
	}else{
		jQuery("#subcom_20").removeAttr("disabled");
		jQuery("#subcom_20").next("span").removeClass("jNiceCheckbox_disabled");
	}
	
	if(jQuery("#subcom_23").attr("checked")==true){ //所有下级分部
		jQuery("#subcom_22").removeAttr("checked"); //下级分部
		jQuery("#subcom_22").attr("disabled","disabled");
		jQuery("#subcom_22").next("span").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
	}else{
		jQuery("#subcom_22").removeAttr("disabled");
		jQuery("#subcom_22").next("span").removeClass("jNiceCheckbox_disabled");
	}
}

function save(){
	var id = "";
	var name = "";
	
	jQuery("input[name^='depat_']").each(function(){
		if(jQuery(this).attr("checked")==true){
			id += ","+jQuery(this).val();
		
			var spanid = jQuery(this).attr("id");
			name += ","+jQuery("#"+spanid+"_span").text();
		}
	});
	
	jQuery("input[name^='subcom_']").each(function(){
	    if(jQuery(this).attr("checked")==true){
			id += ","+jQuery(this).val();
			
			var spanid = jQuery(this).attr("id");
			name += ","+jQuery("#"+spanid+"_span").text();
		}
	});
	
	if(id!=""){
		id = id.substring(1);
		name = name.substring(1);
	}
	//alert(id+":"+name);
	var returnjson = {id:""+id, name:""+name};
    if(dialog){
	    dialog.callback(returnjson);
	}else{  
	    window.parent.returnValue  = returnjson;
	    window.parent.close();
	}
}

function resetData(){
	clearDeptChk();
	clearSubcomChk();
	
	if(selectValue!=""){
		var sv = selectValue.split(",");
		for(var i=0;i<sv.length;i++){
			var s = sv[i];
			try{
				if(s.indexOf("2")!=0 && tabid==0){
					jQuery("#depat_"+s).attr("checked","checked");
					jQuery("#depat_"+s).next("span").addClass("jNiceChecked");
				}
				
				if(s.indexOf("2")==0 && tabid==1){
					jQuery("#subcom_"+s).attr("checked","checked");
					jQuery("#subcom_"+s).next("span").addClass("jNiceChecked");
				}
			}catch(e){}
		}
		
		disabledDept();
		disabledSubcom();
	}
}

function cancel(){
	if(dialog){
    	dialog.close()
    }else{
	    window.parent.close();
	}
}
</script>

</body>

</html>