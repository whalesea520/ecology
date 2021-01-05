<%@ page import="weaver.general.Util,java.sql.Timestamp,java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.common.util.string.StringUtil"%> 
<%@page import="weaver.conn.RecordSet"%> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<link rel="stylesheet" href="/css/frame_wev8.css" type="text/css">
<link rel="stylesheet" href="/portal/css/customerportal.css" type="text/css">
<style type="text/css">body{color:#000}</style>
<%
// RecordSet.executeProc("Sys_Slogan_Select","");
// RecordSet.next();
String username = user.getUsername() ;
String logintype = Util.null2String(user.getLogintype()) ;
String Customertype = Util.null2String(""+user.getType()) ;

Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentyear = (timestamp.toString()).substring(0,4) ;
String currentmonth = ""+Util.getIntValue((timestamp.toString()).substring(5,7)) ;
String currentdate = ""+Util.getIntValue((timestamp.toString()).substring(8,10));
String currenthour = (timestamp.toString()).substring(11,13) ;
/**合同管理的开关*/
boolean contractFlag = false;
RecordSet rs = new RecordSet();
RecordSet rsQiyuesuo = new RecordSet();
rs.executeSql("select moduleName from SystemModule where moduleName='合同管理'");
rs.next();
if(!"".equals(rs.getString("moduleName")) && null != rs.getString("moduleName")){
	rsQiyuesuo.execute("select id from uf_contract_config where type = 0 and flag = 0");
	if(rsQiyuesuo.getCounts()>0){
		contractFlag = true;
	}
}
%>
<script language="javascript">
function clearVal(obj){
    if(obj.value=='请输入关键词搜索'){
        obj.value="";
    }
}

function recoverVal(obj){
    if(obj.value==''||obj.value==null){
        obj.value="请输入关键词搜索";
    }
}

function goUrl(url){
	parent.document.getElementById("mainFrame").src = url;
}

//修改客户密码
function editPassword(){
	main_div_warp.mainFrame.location.href="/CRM/data/ManagerUpdatePassword.jsp?crmid=<%=user.getUID()%>&type=customer";
}

function addclass(obj,type){
	$(".crm_menuitem").removeClass("crm_menuitem_click");
	$(obj).addClass("crm_menuitem_click");
	//main_div_warp.getOuterLanguage();
	
	if(type==0)
        main_div_warp.leftFrame.location.href="left_homePage.jsp";
    else if(type==1)
        main_div_warp.leftFrame.location.href="left_crmInfo.jsp";
    else if(type==2)
        main_div_warp.leftFrame.location.href="left_workFlow.jsp";
    else if(type==3)
        main_div_warp.leftFrame.location.href="left_docInfo.jsp";
    else if(type==4)
        main_div_warp.leftFrame.location.href="left_prjInfo.jsp";
    else if(type==5)
        main_div_warp.leftFrame.location.href="left_customer.jsp";
    else if(type==6){
    	main_div_warp.leftFrame.location.href="left_contract.jsp";
    }    
}	
</script>
<table width="100%" border="0"  cellpadding="0" cellspacing="0" height="50">
<tr>
<td width="180" height="50" align="center">
<img src="/portal/images/LOGO.png" height="100%" width="100%"/>
</td>
<!-- <td width="76" valign="top"><img src="/images_frame/portal/portal_top1_wev8.gif" style="margin-top:3px;"></td> -->
<td valign="top" style="background:#0070c1;line-height:39px">
 <table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <!-- 
  <tr>
    <td background="/images_frame/portal/portal_bg1_wev8.gif" height="40" align="left" valign="bottom">
     <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=5,0,0,0" width="500" height="40">
              <param name=movie value="/images_frame/portal/mission.swf">
              <param name=quality value=high>
              <embed src="/images_frame/portal/mission.swf" quality=high pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="500" height="40">
              </embed> 
    </object> 
    </td>
  </tr>
  <tr>
    <td height="4" bgcolor="555553"></td>
  </tr>
   -->
   <!-- <td width='200' >
               <%if(user.getLanguage()==7||user.getLanguage()==9){%>
		        <%=username%> 
		        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
		            <%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("12") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("14") <= 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("18") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		        <%}%>
		            ! <%=SystemEnv.getHtmlLabelName(16645,user.getLanguage())%><%=currentyear%>/<%=currentmonth%>/<%=currentdate%>
		    <%}else{%>
		        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
		            <%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("12") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("14") <= 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("18") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		        <%}%>
		            !<%=username%> 
		    <%}%>
             </td> -->
  <tr>
    <td height="50" background="">
      <table width="100%" border="0" cellpadding="0" cellspacing="0" height="100%">
	    <form name="form1" method="post" action="/system/QuickSearchOperation.jsp" target="mainFrame">
        <tr> 
            <td width='10' align="left"></td>
            <%if(Customertype.equals("3") || Customertype.equals("4")){%>
            	<td width='450' align="left">
             <%}else{%>
             <td width='400' align="left">
              <%}%>
				<div class="crm_menudiv"><div class="crm_menuitem crm_menuitem_click" onclick="addclass(this,0)">首页</div></div>
				<div class="crm_menudiv"><div class="crm_menuitem" onclick="addclass(this,1)">个人</div></div>
				<div class="crm_menudiv"><div class="crm_menuitem" onclick="addclass(this,2)">流程</div></div>
				<div class="crm_menudiv"><div class="crm_menuitem" onclick="addclass(this,3)">知识</div></div>
				<div class="crm_menudiv"><div class="crm_menuitem" onclick="addclass(this,4)">项目</div></div>
				<%if(Customertype.equals("3")||Customertype.equals("4")||!logintype.equals("2")){%>
				<div class="crm_menudiv"><div class="crm_menuitem" onclick="addclass(this,5)">客户</div></div>
				<%}%>
				<%if(contractFlag){ %>
				<div class="crm_menudiv"><div class="crm_menuitem" onclick="addclass(this,6)">合同</div></div>
				<%} %>
			</td>
	        <td width="68" align="left" >
	          <input name="searchtype" id="searchtype"  type="text" value="5" style="display:none">
	              <div class="searchtype">
	                   <div id="sample" class="dropdown" style="float:left;position:absolute;width:100%;">
                            <div class="selectTile">
                                <a href="#" class="selectTileBefo">
                                    <span style="height:35px;line-height:35px;float:left;text-align:center;width:40px;display:block;overflow:hidden;text-overflow:ellipsis;color:#fff;padding:0;" class="searchTxt"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></span>
                                    <div class="e8_dropdown"></div>
                                    <!--background: url(/wui/theme/ecology8/skins/default/page/ecologyShellImg_wev8.png);background-repeat: no-repeat; background-position: -262px  -62px;-->
                                    <div style="float:right;display: block; width:8px;height:18px;*height:18px;margin-top: -2px;color: #fff;opacity: 0.5;filter: alpha(opacity=50); -moz-opacity: 0.5;" class="searchTxt searchTxtSplit">|</div>
                                </a>
                            </div>
                            <div class="selectContent" style="">
                                <ul id="searchBlockUl" style="display: none">
                                <li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/wls_wev8.png"><span searchtype="5"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></span></a></li>
                                   <%if(!logintype.equals("2")){%>  
				                    <li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/hrs_wev8.png"><span searchtype="2"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></span></a></li>           
				                    <%}%>
				                    <%if(Customertype.equals("3") || Customertype.equals("4") || !logintype.equals("2") ){%>  
				                     <li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/crm_wev8.png"><span searchtype="3"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></span></a></li>  
				                    <%}%>
				                    <%if(!logintype.equals("2")){%> 
				                     <li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/docs_wev8.png"><span searchtype="4"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></span></a></li>
				                    <%}%>
				                   
				                    <li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/docs_wev8.png"><span searchtype="1"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></span></a></li>
				                    <li><a href="#"><img src="/wui/theme/ecology8/page/images/toolbar/p_wev8.png"><span searchtype="6"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></span></a></li>
				                    
                                </ul>
                            </div>
                        </div>
	              </div>
	          </td>
	          <td width="130" align="center" style="color#fff;">
	           <input type="text" id="searchvalue"  name="searchvalue" onfocus="clearVal(this);" onblur="recoverVal(this);" class="submit" value="请输入关键词搜索"   size="12" style="border:none;background-color:#027cda;color:#fff;width: 100%;height:35px;line-height:35px;padding-left:4px;"/>
	        </td>
		      <td width="30" align="center" >
		        <p class="search_btn_p" onclick="clearVal(document.getElementById('searchvalue'));form1.submit()" style="height:35px;line-height:35px">
		        <img style="margin-top:10px;cursor: pointer;" src="/wui/theme/ecology8/skins/default/page/search_wev8.png">
		        </p>
		      </td>         
			<td></td>
			<td align="right" style="color:#fff">
               <%if(user.getLanguage()==7||user.getLanguage()==9){%>
		        <%=username%> 
		        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
		            <%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("12") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("14") <= 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("18") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		        <%}%>
		            ! <%=SystemEnv.getHtmlLabelName(16645,user.getLanguage())%><%=currentyear%>/<%=currentmonth%>/<%=currentdate%>
		    <%}else{%>
		        <% if(currenthour.compareTo("05") < 0 || currenthour.compareTo("18") >= 0) {%>
		            <%=SystemEnv.getHtmlLabelName(1201,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("12") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1202,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("14") <= 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1203,user.getLanguage())%>
		        <%} else if(currenthour.compareTo("18") < 0 ) {%>
		            <%=SystemEnv.getHtmlLabelName(1204,user.getLanguage())%>
		        <%}%>
		            !<%=username%> 
		    <%}%>
             </td>
             <td width="10"></td>
		  <!-- 密码 -->
          <td  width="30" align="right" nowrap><a class=zlm1 style="cursor: pointer;" onclick="editPassword()" target="_top" title="<%=SystemEnv.getHtmlLabelName(409,user.getLanguage())%>"><img style="padding-top:16px;" src="/portal/images/psd.png"/></a></td><!-- <i  class="iconfont icon_button">&#xe63d;</i> -->
          <!-- 退出 -->
          <td  width="50" align="center" nowrap><a class=zlm1 href="/login/Logout.jsp" title="<%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%>"><img style="padding-top:16px;" src="/wui/theme/ecology8/page/images/menuicon/bright/logout_wev8.png"/></a></td><!-- <i  class="iconfont icon_out">&#xe687;</i> -->
          <td width="15" align="center"></td>
          <td width=20>
			&nbsp;
          </td>  
        </tr>
		</form>
      </table>
    </td>
  </tr>
</table>


</td>
</tr>
</table>
<script language="javascript">
    $('.searchtype').toggle(function(){
        $('#searchBlockUl').show();
        $('.selectTile >a').addClass('selectTileClick');
        $('.selectTile >a span').css({'color':"#666"});
        $('.selectTile >a>div').eq(0).removeClass('e8_dropdown').addClass('e8_dropdownSelected');
    },function(){
         $('#searchBlockUl').hide();
         $('.selectTile >a').removeClass('selectTileClick');
        $('.selectTile >a span').css({'color':"#fff"});
        $('.selectTile >a>div').eq(0).removeClass('e8_dropdownSelected').addClass('e8_dropdown');
    });
    /*列表鼠标移入移出*/
    $("#searchBlockUl li a").hover(
	  function () {
	     var a =$(this).children('img').attr('src');
	        var b = a.split('_');
	        var c = b[0]+"_sel_wev8.png";
	        $(this).children('img').attr('src',c);
	  },
	  function () {
	     var a =$(this).children('img').attr('src');
        var b = a.split('_sel');
        var c = b[0]+"_wev8.png";
        $(this).children('img').attr('src',c);
	  }
	);
    /*切换*/
     $("#searchBlockUl li a").bind('click',function(){
           var select = $(this).children('span').text();
           var selectid = $(this).children('span').attr('searchtype')
           $('.selectTile >a span').text(select);
           $('#searchtype').val(selectid);
     })
      $("body").bind('click',function(){
            $('#searchBlockUl').hide();
             $('.selectTile >a').removeClass('selectTileClick');
        $('.selectTile >a span').css({'color':"#fff"});
        $('.selectTile >a>div').eq(0).removeClass('e8_dropdownSelected').addClass('e8_dropdown');
     })
</script>