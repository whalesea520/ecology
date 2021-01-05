
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
RecordSet rs = new RecordSet();
rs.executeSql("select * FROM hpElement_slidesetting where eleid=" + eid + " order by cast(id as int) asc");
int rowcount = rs.getCounts();
int displaydesc = 1;
List<String> imgsrclist = new ArrayList<String>();
List<String> imgdesclist = new ArrayList<String>();
while (rs.next()) {
  	displaydesc = Util.getIntValue(Util.null2String(rs.getString("displaydesc")), 1);
 	imgdesclist.add(Util.null2String(rs.getString("imgdesc")));
 	String imgSrcString = Util.null2String(rs.getString("imgsrc"));
 	if(loginuser==null){
 		imgSrcString = imgSrcString.replaceAll("/weaver/weaver.file.FileDownload", "/weaver/weaver.homepage.HomepageCreateImage");
 	}
 	imgsrclist.add(imgSrcString);
}
//rs.beforFirst();
double cellwidth = 0;
if (rowcount != 0) {
	cellwidth = 100/rowcount;
}
%>

<script type="text/javascript">
try {
clearInterval(t_<%=eid%>);
} catch (e) {}
var t_<%=eid%> = n_<%=eid%> = 0, count_<%=eid%>;
//$(document).ready(function() {
function initSlide_<%=eid %>() {
	t_<%=eid%> = n_<%=eid%> = 0, count_<%=eid%>;
	count_<%=eid%> = $("#banner_list_<%=eid%> a").length;
	$("#banner_list_<%=eid%> a:not(:first-child)").hide();
	$("#banner_info_<%=eid%>").click(function() {
//		window.open($("#banner_list a:first-child").attr('href'), "_blank")
	});
	$("#banner_<%=eid%> li, #banner_info_<%=eid%> .slidebox_info_item").click(function(e) {
		var i = $(this).attr("_index") - 1; //
		n_<%=eid%> = i;
		if (i >= count_<%=eid%>) return;
//		$("#banner_info_<%=eid%>").html($("#banner_list a").eq(i).find("img").attr('alt'));
		$("#banner_info_<%=eid%>").unbind().click(function() {
			//window.open($("#banner_list a").eq(i).attr('href'), "_blank")
		})
		$("#banner_list_<%=eid%> a").filter(":visible").fadeOut(500).parent().children().eq(i).fadeIn(500);
		document.getElementById("banner_<%=eid%>").style.background = "";
		$("#banner_<%=eid%> li").eq(i).toggleClass("on");
		$("#banner_info_<%=eid%>").find(".slidebox_info_item").removeClass("slidebox_info_item_slt");
		$("#banner_info_<%=eid%>").find(".slidebox_info_item").eq(i).addClass("slidebox_info_item_slt");


		$(this).siblings().removeAttr("class");
		var event = $.event.fix(e);
		event.stopPropagation();
	});
	<%
	if (rowcount > 1) {
	%>
	t_<%=eid%> = setInterval("showAuto_<%=eid%>()", 4000);	
	<%
	}
	%>
	$("#banner_<%=eid%>").hover(function() {
		clearInterval(t_<%=eid%>)
		$("#settingico_<%=eid%>").parent().show();
	}, function() {
		<%
		if (rowcount > 1) {
		%>
		t_<%=eid%> = setInterval("showAuto_<%=eid%>()", 4000);
		<%
		}
		%>
		$("#settingico_<%=eid%>").parent().hide();
	});
	
	$("#settingico_<%=eid%>").hover(function () {
		$(this).attr("src", "/page/element/imgSlide/resource/image/ssetting_slt.png");	
	}, function () {
		$(this).attr("src", "/page/element/imgSlide/resource/image/ssetting.png");	
	});
	
	$("#settingico_<%=eid%>").bind("click", function () {
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = "/page/element/imgSlide/detailsetting.jsp?eid=<%=eid%>";
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(19342,language)%>";
		dialog.Width = 680;
		dialog.Height = 768;
		dialog.normalDialog = false;
		dialog.callbackfun = function (paramobj, id1) {
		
		};
		dialog.show();
	});
//})

}
$(document).ready(function() {
initSlide_<%=eid %>();
var mleft = '-<%=18*rowcount/2 %>px';
$('#banner_<%=eid%> ul').css('margin-left',mleft);
});
function showAuto_<%=eid %>() {
	n_<%=eid%> = n_<%=eid%> >= (count_<%=eid%> - 1) ? 0 : ++n_<%=eid%>;
	$("#banner_<%=eid%> li").eq(n_<%=eid%>).trigger('click');
}
</script>







<%
	String heightValue = "260px";//(String)valueList.get(nameList.indexOf("height"));
	String widthValue = (String)valueList.get(nameList.indexOf("width"));
	String qualityValue = (String)valueList.get(nameList.indexOf("quality"));
	String autoPlayValue = (String)valueList.get(nameList.indexOf("autoPlay"));
	String fullScreenValue = (String)valueList.get(nameList.indexOf("fullScreen"));
	String videoSrcValue = (String)valueList.get(nameList.indexOf("videoSrc"));
	
	boolean isSystemer=false;
	String esharelevel="";
	if(loginuser!=null){
		if( HrmUserVarify.checkUserRight("homepage:Maint", loginuser)) {
			isSystemer=true;
		}
		if (pc.getIsLocked(hpid).equals("1")) {//门户锁定，重新取下用户id
			userid=pu.getHpUserId(hpid,""+subCompanyId,loginuser);
			usertype=pu.getHpUserType(hpid,""+subCompanyId,loginuser);
		}
		strSql="select perpage,linkmode,showfield,sharelevel from hpElementSettingDetail where eid="+eid+" and userid="+userid+" and usertype="+usertype;	
		RecordSet rs_common = new RecordSet();
		rs_common.executeSql(strSql);
		if(!rs_common.next()){
			int _sharelevel = 1;
			if(isSystemer){
					_sharelevel = 2;
			}
			String insertSql = "insert into hpElementSettingDetail (userid,usertype,eid,linkmode,perpage,showfield,sharelevel,hpid) select "+userid+", "+usertype+", "+eid+", linkmode,perpage,showfield,"+_sharelevel+","+hpid+" from hpElementSettingDetail where id = (select Min(id) from hpElementSettingDetail where eid="+eid+" and userid=1 group by userid,eid)";
			rs_common.executeSql(insertSql);
		
			rs_common.executeSql(strSql);
		}else{
			rs_common.beforFirst();
		}
		
		if(rs_common.next()){
			esharelevel=Util.null2String(rs_common.getString("sharelevel"));  //1:为查看 2:为编辑
		}
	}
%>

<div id="imgSlide_<%=eid%>" style="width:100%;height:<%=heightValue%>">
    <div id="banner_<%=eid%>" class="slidebox_block" style="height:100%">
    	<%
    	
    	
    	if (loginuser!=null && isSystemer || "2".equals(esharelevel)) {// 
    	%>
    	<div style="position:absolute;height:28px;width:28px;z-index:999;top:10px;right:10px;cursor:pointer;display:none; ">
			<img src="/page/element/imgSlide/resource/image/ssetting.png" height="28px" width="28px" style="" id="settingico_<%=eid%>" title="<%=SystemEnv.getHtmlLabelName(68,language)%>">
		</div>
		
		<%
    	}
		%>
        <!-- <div id="banner_bg" class="slidebox_btbg">
        </div>
        -->
        <div id="banner_info_<%=eid%>" class="slidebox_info" style="font-family:'微软雅黑';<%=displaydesc!=1?"display:none;":"" %>">
            <table width="100%" height="100%" cellpadding="0" cellspacing="0">
                <colgroup>
                	<%
                	for (int j=0; j<rowcount-1; j++) {
                	%>
                    <col width="<%=cellwidth %>%">
                    <col width="1px">
                    <%
                	}
                    %>
                    <col width="*">
                </colgroup>
                <tr>
                	<%
                	for (int i=0; i<imgdesclist.size(); i++) {
                	%>
                    <td>
                        <div class="slidebox_info_item <%=i==0?"slidebox_info_item_slt":"" %>" _index="<%=i+1 %>">
                            <%=imgdesclist.get(i) %>
                        </div>
                    </td>
                    <%
                    	if (i<imgdesclist.size() - 1) {
                    	    %>
                    	    <td style="">
                    	    	<span style="display:block;height:100%;width:1px!important;background-color: #343434;filter: Alpha(Opacity=20);opacity: 0.2;"></span>
		                    </td>
                    	    <%
                    	}
                	}
                    %>
                </tr>
            </table>
        </div>
        <!---->
        <ul style="<%=displaydesc==1?"display:none;":"" %>">
        	<%
           	for (int i=0; i<imgdesclist.size(); i++) {
           	%>
            <li class="<%=i==0 ? "on" : "" %>" _index="<%=i+1 %>">
            </li>
            <%
           	}
            %>
        </ul>
        <div id="banner_list_<%=eid%>" class="slidebox_list" style="height:100%">
        	<%
        	for (int i=0; i<imgsrclist.size(); i++) {
        	%>
            <a >
                <div class="slidebox_list_item" style="background:url('<%=imgsrclist.get(i) %>') center center no-repeat;background-size:100% 100%;filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<%=imgsrclist.get(i) %>', sizingMethod='scale')\9;  height:100%">
                </div>
            </a>
            <%
        	}
            %>
        </div>
    </div>
</div>

