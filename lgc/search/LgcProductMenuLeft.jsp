
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link type="text/css" rel="stylesheet" href="/css/xtree_wev8.css">
	 <script type="text/javascript" src="/js/xtree_wev8.js"></script>
    <script type="text/javascript" src="/js/xloadtree_wev8.js"></script>


</HEAD>



<BODY scroll=no>
<FORM NAME=weaver STYLE="margin-bottom:0" action="/lgc/search/LgcProductList.jsp" method=post target="contentframe">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
<input type='hidden' name='ptype'/>
<input type='hidden' name='assortmentid'/>
<table cellspacing="0" cellpadding="0" class="flowsTable" style="width:100%;height:100%;"  >
	<tr>
		<td class="leftTypeSearch">
			<div>
				<span class="leftType"><%=SystemEnv.getHtmlLabelName(332 ,user.getLanguage())%><span id="totalDoc"></span></span>
				<span class="leftSearchSpan">
					<span id="searchblockspan">
						<span class="searchInputSpan" style="position:relative;">
							<input type="text" class="leftSearchInput searchInput" style="width: 110px; vertical-align: top;">
							<span class="middle searchImg" style="position: absolute; right: 0px;">
								<img class="middle" id="searchImg" style="vertical-align:top;margin-top:2px;" src="/images/ecology8/request/search-input_wev8.png">
							</span>
						</span>
					</span>
				</span>
			</div>
		</td>
	</tr>
	<tr>
		<td style="width:23%;" class="flowMenusTd">
			<div class="flowMenuDiv"  >
				<div style="overflow:hidden;height:300px;position:relative;" id="overFlowDiv">
					<div class="ulDiv" ></div>
				</div>
			</div>
		</td>
	</tr>
</table>
</FORM>


<script language="javascript">
	$(document).ready(function(){
		e8_initTree("/lgc/search/LgcProductMenuLeftManage.jsp");
	});
	
	function refreshTreeMain(id,parentId,needRefresh){
		if(needRefresh!=false)needRefresh=true;
		refreshTree(id,parentId,{
			needRefresh:needRefresh,
			url:"/lgc/search/LgcProductMenuLeftManage.jsp",
			fn:e8_initTree
		});
	}
	function refreshTreeNum(ids,isadd)
	{
		var id = ids.split("|");
		var rootval = $(".flowMenuDiv").find(".e8_num_xtree:first").text();
		if(isadd) rootval = ~~(rootval)+1;
		else rootval = ~~(rootval)-1;
		$(".flowMenuDiv").find("#num_root:first").text(rootval);
		for(var i=0;i<id.length;i++)
		{
			if(id[i] != "")
			{
				if($(".flowMenuDiv").find("#num_"+id[i]).length>0)
				{
					var tempval = $(".flowMenuDiv").find("#num_"+id[i]).text();
					if(isadd)
						tempval = ~~(tempval)+1;
					else
						tempval = ~~(tempval)-1;
					$(".flowMenuDiv").find("#num_"+id[i]).text(tempval);
					
				}
			}
		}
	}
	
	jQuery(function(){
		// alert(jQuery(".leftSearchInput").closest("span").find("img").length);
		jQuery("#searchImg").bind('click',function(){
			e8_initTree("/lgc/search/LgcProductMenuLeftManage.jsp?searchName="+encodeURI(encodeURI(jQuery(".leftSearchInput").val())));
		})
	
	});
</script>
</BODY>
</HTML>