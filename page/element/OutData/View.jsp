
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"></jsp:useBean>
<script type="text/javascript">
function backMarqueeDiv7(eid){
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft - 100 + 'px')}, 500 );
}

function nextMarqueeDiv7(eid){
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft + 100 + 'px')}, 500 );
}


</script>

<%	
	ArrayList tabIdList = new ArrayList();
	ArrayList tabTitleList = new ArrayList();
	String tabSql="select tabid,title from hpOutDataTabSetting where eid="+eid+" order by tabid";
    rs.execute(tabSql);
    while(rs.next()){
	    tabIdList.add(rs.getString("tabid"));
	    tabTitleList.add(rs.getString("title"));
    }
    String display ="none";
	if(tabIdList.size()>1){
		display = "";
	}
	String url ="/page/element/OutData/tabContentData.jsp";
	String outdataCurrentTab = Util.null2String((String)session.getAttribute("outdataCurrentTab"));
	if(tabIdList.size()>0 && outdataCurrentTab.equals("")){
		outdataCurrentTab =(String)tabIdList.get(0);
	}
%>
<div id="tabnavprev_<%=eid%>" style="cursor:pointer;position:relative;*position:absolute;float:left;left:0px;top:-6px;*top:0px;" class="picturebackhp" onclick="backMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>
<div id="tabnavnext_<%=eid%>" style="cursor:pointer;position:relative;*position:absolute;float:right;right:0px;top:-6px;*top:0px;" class="picturenexthp" onclick="nextMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>
<div id="tabContainer_<%=eid%>" class='tab2' style="overflow:hidden;display:<%=display%>">
	<table height='32' width="<%=77*tabIdList.size() %>"  cellspacing='0' cellpadding='0' border='0' style='fixed-layout:fixed;'>
		<tr>
			<%
			int sumLength = 0;
			for(int i=0;i<tabIdList.size();i++){ 
				int length = 77;
				String alength = Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"));
				int lengthByte = alength.getBytes().length;
				if(lengthByte*8>77){
					length = lengthByte * 7;
				}
				length = 77;
				%>
				<%if(outdataCurrentTab.equals(tabIdList.get(i))){ %>
					<td id="tab_<%=eid%>" style="width: <%=length %>px;cursor:pointer;text-align:center;" tabId=<%=tabIdList.get(i) %>  title="<%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %>"  class='tab2selected'  
					onclick="loadContent('<%=eid%>','<%=url%>','eid=<%=eid%>&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>',event)">
							<span class="ellipsis" style="max-width:77px;"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></span>
					</td>
				<% }else{%>
					<td id="tab_<%=eid+"_"+tabIdList.get(i)%>" style="width: <%=length %>px;padding-top:0px;cursor:pointer;text-align:center;" title="<%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %>"  tabId=<%=tabIdList.get(i) %> class='tab2unselected' 
					onclick="loadContent('<%=eid%>','<%=url%>','eid=<%=eid%>&subCompanyId=<%=subCompanyId%>&hpid=<%=hpid%>',event)">
							<span class="ellipsis" style="max-width:77px;"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></span>
					</td>
			<%	 }
				sumLength += length;
			 } 
			 sumLength = sumLength + 36; 
			 %>
		</tr>
	</table>
</div>
<div id="tabContant_<%=eid%>">
<%
if(tabIdList.size()>0){
%>
<jsp:include page="<%=url%>" flush="true" >
			<jsp:param name="tabId" value="<%=outdataCurrentTab%>"/>	

			<jsp:param name="ebaseid" value='<%=request.getParameter("ebaseid")%>'/>
			<jsp:param name="eid" value="<%=eid%>"/>
			<jsp:param name="styleid" value='<%=request.getParameter("styleid")%>'/>
			<jsp:param name="hpid" value='<%=request.getParameter("hpid")%>'/>
			
	</jsp:include>
<%} %>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	var divWidth = "<%=sumLength%>";
	var hpWidth = $("#content_"+<%=eid%>).width();
	
	if(parseFloat(divWidth) > parseFloat(hpWidth)) {
		$("#tabnavprev_<%=eid%>").css("display","block");
		$("#tabnavnext_<%=eid%>").css("display","block");
		
		<%if(tabIdList.size()!=1){%>
		$("#tabContainer_<%=eid%>").css("width", $("#content_<%=eid%>").width() - 36);
		$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "18px");
		$("#tabContainer_<%=eid%>").css("margin-right", "18px"); 
		<%}else{
		%>
		$("#tabnavprev_<%=eid%>").css("display","none");
		$("#tabnavnext_<%=eid%>").css("display","none");
		$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		}%>
	}else{
		$("#tabnavprev_<%=eid%>").css("display","none");
		$("#tabnavnext_<%=eid%>").css("display","none");
	
		<%if(tabIdList.size()!=1){%>
		$("#tabContainer_<%=eid%>").css("width", $("#content_<%=eid%>").width() );
		//$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "0");
		$("#tabContainer_<%=eid%>").css("margin-right", "0"); 
		<%}else{
		%>
		$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		}%>
	}
})
</script>
