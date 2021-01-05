<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user = HrmUserVarify.getUser (request , response) ;

if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

int pageSize = Util.getIntValue(request.getParameter("pageSize"), 10);
int pageIndex = Util.getIntValue(request.getParameter("pageIndex"), 1);
int maxPageIndex = Util.getIntValue(request.getParameter("maxPageIndex"), 0);
int rsAllCnt = Util.getIntValue(request.getParameter("rsAllCnt"), 0);
boolean editPageSize = 1==Util.getIntValue(request.getParameter("editPageSize"), 0);

List _pageIndexList = new ArrayList();
if(pageIndex-2 > 0){
	_pageIndexList.add((pageIndex-2)+"");
}
if(pageIndex-1 > 0){
	_pageIndexList.add((pageIndex-1)+"");
}
_pageIndexList.add(pageIndex+"");
if(pageIndex+1 <= maxPageIndex){
	_pageIndexList.add((pageIndex+1)+"");
}
if(pageIndex+2 <= maxPageIndex){
	_pageIndexList.add((pageIndex+2)+"");
}
%>

<%
if(editPageSize){
%>
	<link rel="stylesheet" href="/js/select/style/selectForK13_wev8.css">
	<script type="text/javascript" src="/js/select/script/selectForK13_wev8.js"></script>
<%
}
%>

<span class="e8_pageinfo">
<%
String _onclick = "";
if(pageIndex > 1){
	_onclick = "gotoPage(-1);";
}
%>
		<span class="e8_numberspan weaverTablePage" onclick="<%=_onclick %>">&lt;</span>
<%
if(!_pageIndexList.contains("1")){
%>
		<span onclick="jumpPage(<%=1 %>);" class="e8_numberspan"><%=1 %></span>
<%
	if(_pageIndexList.size() > 0 && Util.getIntValue((String)_pageIndexList.get(0), -1) != 2){
%>
		<span class="e8_numberspan">&nbsp;...&nbsp;</span>
<%
	}
}
for(int i=0;i<_pageIndexList.size();i++){
	int _pageIndex = Util.getIntValue((String)_pageIndexList.get(i), -1);
	String class_weaverTableCurrentPageBg = "";
	if(_pageIndex == pageIndex){
		class_weaverTableCurrentPageBg = "weaverTableCurrentPageBg";
	}
	
%>
		<span onclick="jumpPage(<%=_pageIndex %>);" class="e8_numberspan <%=class_weaverTableCurrentPageBg %>"><%=_pageIndex %></span>
<%
}
if(!_pageIndexList.contains(maxPageIndex+"")){
	if(_pageIndexList.size() > 0 && Util.getIntValue((String)_pageIndexList.get(_pageIndexList.size()-1), -1) != maxPageIndex-1){
%>
		<span class="e8_numberspan">&nbsp;...&nbsp;</span>
<%
	}
%>
		<span onclick="jumpPage(<%=maxPageIndex %>);" class="e8_numberspan"><%=maxPageIndex %></span>
<%
}
_onclick = "";
if(pageIndex < maxPageIndex){
	_onclick = "gotoPage(1);";
}
%>
	<span class="e8_numberspan weaverTablePage" onclick="<%=_onclick %>">&gt;</span>
	
	<span style="float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;"><%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%></span>
	<span id="-weaverTable-0_XTABLE_GOPAGE_buttom_go_page_wrap" style="float:left;display:inline-block;width:30px;height:20px;border:1px solid #FFF;margin:0px 1px;padding:0px;position:relative;left:0px;top:5px;">
		<span id="_weaverTable_0_XTABLE_GOPAGE_buttom_goPage_fna" 
			onclick="jumpPageIpt();" 
			style="float:left;cursor:pointer;width: 44px; height: 22px; line-height: 20px; padding: 0px; text-align: center; border: 0px; background-color: rgb(0, 99, 220); color: rgb(255, 255, 255); position: absolute; left: 0px; top: -1px; display: none;z-index:10000">
			<%=SystemEnv.getHtmlLabelName(30911,user.getLanguage())%>
		</span>
		<input id="_weaverTable_0_XTABLE_GOPAGE_buttom_fna" type="text" size="3" value="<%=pageIndex %>" 
			style="color: rgb(102, 102, 102); width: 30px; height: 18px; line-height: 18px; float: left; text-align: center; position: absolute; left: 0px; top: 0px; outline: none; border: 1px solid transparent;">
	</span>
	<span style="float:left;TEXT-DECORATION:none;height:30px;line-height:30px;color:#666666;padding-right:10px;"><%=SystemEnv.getHtmlLabelName(30642,user.getLanguage())%></span>
	<span class="e8_splitpageinfo">
		<span style="position:relative;TEXT-DECORATION:none;height:21px;padding-top:2px;">
			<%
			if(!editPageSize){
			%>
				<%=pageSize %>
			<%
			}else{
			%>
				<span style="width: 1px;">
					<select id="pagesize" style="display:none;">
						<option value="10">10</option>
						<option value="30">30</option>
						<option value="50">50</option>
						<option value="70">70</option>
						<option value="100">100</option>
					</select>
				</span>
			<%
			}
			%>
			<%=SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(30642,user.getLanguage())%>&nbsp;|&nbsp;<%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())+rsAllCnt+SystemEnv.getHtmlLabelName(18256,user.getLanguage())%>
		</span>
	</span>
</span>
<script language="javascript">
jQuery("#_weaverTable_0_XTABLE_GOPAGE_buttom_fna").bind("mouseout", function(e){
	jQuery(this).css('border','1px solid transparent');
});
jQuery("#_weaverTable_0_XTABLE_GOPAGE_buttom_fna").bind("mouseover", function(e){
	if(jQuery('#_weaverTable_0_XTABLE_GOPAGE_buttom_goPage_fna').css('display')=='none'){
		jQuery(this).css('border','1px solid #DDDDDD');
	}
});
jQuery("#_weaverTable_0_XTABLE_GOPAGE_buttom_fna").bind("blur", function(e){
	jumpPageIpt();
});
jQuery("#_weaverTable_0_XTABLE_GOPAGE_buttom_fna").bind("keypress", function(e){
	if(e.keyCode==13){
		jumpPageIpt();
	}
});
<%
if(editPageSize){
%>
	jQuery(function () {
		jQuery("#pagesize").selectForK13({
			"width":"40px",
			"pageSize":"<%=pageSize %>"
		});
		jQuery(".numberspan").bind("click", function(){
			jQuery(".numberspan").removeClass("currentNumberspan");
			jQuery(this).addClass("currentNumberspan");
		});

		jQuery(".K13_select_list").bind("click", function(e){
			reloadPageByPageSize(jQuery("._pageSizeInput").val());
		});
		
		jQuery("._pageSizeInput").bind("keypress", function(e){
			if(e.keyCode==13){
				reloadPageByPageSize(jQuery(this).val());
			}
		});
	});
<%
}
%>
</script>

