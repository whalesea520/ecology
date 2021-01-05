<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs_tabInfo" class="weaver.conn.RecordSet" scope="page" />

<!-- �ж�Ԫ���Ƿ���Զ�����ʾ��������ʽ -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<script type="text/javascript" src="/js/jquery/jquery.scrollTo_wev8.js"></script>
<script type="text/javascript">
function backMarqueeDiv7(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft - 100 + 'px')}, 500 );
}

function nextMarqueeDiv7(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft + 100 + 'px')}, 500 );
}
</script>

<style type="text/css" rel="STYLESHEET">
.picturebackhp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_left_wev8.gif) no-repeat 0 0;
}
.picturenexthp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_right_wev8.gif) no-repeat 0 0;
}
</style>
<%	

	ArrayList tabIdList = new ArrayList();
	ArrayList tabTitleList = new ArrayList();
	//ArrayList tabWhereList = new ArrayList();
   
   String tabSql="select tabId,tabTitle,sqlWhere from hpNewsTabInfo where eid="+eid+" order by orderNum ";
   rs_tabInfo.execute(tabSql);
   while(rs_tabInfo.next()){
	   tabIdList.add(rs_tabInfo.getString("tabId"));
	   tabTitleList.add(rs_tabInfo.getString("tabTitle"));
//	   tabWhereList.add(rs_tabInfo.getString("sqlWhere"));
  }
   
  String queryString = request.getQueryString();
  String url =ebc.getPath("news")+"NewsTabContentData.jsp";
  //校验当前tab信息
  tabSql="select tabId from hpNewsTabInfo where eid="+eid+" and tabid='"+currenttab+"'";
  rs_tabInfo.execute(tabSql);
  if(!rs_tabInfo.next()){
	   if(tabIdList.size()>0){
	       currenttab =(String)tabIdList.get(0);
	   }
  }

%>
<%
String display ="none";
if(tabIdList.size()>1){
	display = "";
}
int sumLength = 0;
String titleState = esc.getTitleState(styleid);	

%>
<div id="titleContainer_<%=eid%>" style="border:0px;width:100%;overflow: hidden;position: relative;display:<%=display%>">

<div id="tabnavprev_<%=eid%>" style="cursor:hand;position:relative;float:left;left:-5px;top:-5px;" class="picturebackhp" onclick="backMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>

<div id="tabContainer_<%=eid%>" class='tab2' style="width:100%;overflow:hidden;display:none;float:left;">
	<table height='32' width="<%=77*tabIdList.size() %>"  cellspacing='0' cellpadding='0' border='0' style="table-layout:fixed;">
		<tr>
			<%for(int i=0;i<tabIdList.size();i++){ 
				int length = 77;
				String alength = Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"));
				int lengthByte = alength.getBytes().length;
				if(lengthByte*8>77){
					length = lengthByte * 7;
				}
				length = 77;
				%>
				<%if(currenttab.equals(tabIdList.get(i))){%>
					<td style="padding-top:5px;vertical-align:top;" id="tab_<%=eid%>" tabId=<%=tabIdList.get(i) %> class='tab2selected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString%>',event)" title="<%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"))%>">
						<%-- <%=Util.getByteNumString(Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")),12) %> --%>
						<span class="ellipsis"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"))%></span>
					</td>
				<% }else{%>
					<td style="padding-top:5px;vertical-align:top;"  id="tab_<%=eid+"_"+tabIdList.get(i)%>" tabId=<%=tabIdList.get(i) %> class='tab2unselected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString%>',event)" title="<%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"))%>">
						<%-- <%=Util.getByteNumString(Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")),12) %> --%>
						<span class="ellipsis"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"))%></span>
					</td>
			<%	 }
				sumLength += length;
			 }
			 sumLength = sumLength + 36;%>
		</tr>
	</table>
</div>

<% if(titleState.equals("hidden")){ %>
    <div id="tabnavnext_<%=eid%>" style="cursor:hand;position:relative;float:left;right:-3px;top:-6px;" class="picturenexthp" onclick="nextMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>
	<div class='optoolbar'  style="cursor:hand;position: absolute;float: right;top: 0px;bottom:0;right: 0;display:none;padding-top: 6px;">
	</div>
	<script>
         var issetting=$("input[name='ispagesetting']").val();
	     var stateitem='<%=titleState%>';
		 var bgitem='',tds;
		 if(issetting!=='true' && stateitem==='hidden'){
			   tds=$("#tabContainer_<%=eid%>").find("td");
			   bgitem=$("#tabContainer_<%=eid%>").css("background-image");
			   var itemcurrent=$("#item_<%=eid%>");
			   var optoolbar=itemcurrent.find(".optoolbar");
		       var toolbaritem=itemcurrent.find(".header .toolbar ul").clone();
			   toolbaritem.css("list-style","none");
			   toolbaritem.css("overflow","hidden");
			   toolbaritem.find("li").css("overflow","hidden");
			   toolbaritem.find("li").css("float","left");
			   toolbaritem.find("li").css("margin-right","5px");
			   if(bgitem!=='' && bgitem!=='none'){
			    //alert(bgitem);
			    $("#titleContainer_<%=eid%>").css("background-image",bgitem);
			   }
			   itemcurrent.find(".header .toolbar ul").remove();
		       optoolbar.append(toolbaritem);
			   optoolbar.show();
		 }
	</script>
	
<%}else{ %>
    <script>
	   var bgitem='';
	   bgitem=$("#tabContainer_<%=eid%>").css("background-image");
	   if(bgitem!=='' && bgitem!=='none'){
	    $("#titleContainer_<%=eid%>").css("background-image",bgitem);
	   }
	</script>
    <div id="tabnavnext_<%=eid%>" style="cursor:hand;position:relative;float:right;right:0;top:-6px;" class="picturenexthp" onclick="nextMarqueeDiv7('#tabContainer_<%=eid%>');">&nbsp;</div>
<%} %>


</div>
<div id="tabContant_<%=eid%>">
<%
if(tabIdList.size()>0){
%>
<jsp:include page="<%=url%>" flush="true" >
			<jsp:param name="tabId" value="<%=currenttab%>"/>
			<jsp:param name="tabWhere" value=""/>	

			<jsp:param name="ebaseid" value='<%=request.getParameter("ebaseid")%>'/>
			<jsp:param name="eid" value='<%=request.getParameter("eid")%>'/>
			<jsp:param name="styleid" value='<%=Util.getIntValue(request.getParameter("styleid"),-1)+""%>'/>
			<jsp:param name="hpid" value='<%=request.getParameter("hpid")%>'/>
			<jsp:param name="subCompanyId" value='<%=request.getParameter("subCompanyId")%>'/>
	</jsp:include>
<%} %>
</div>
<script type="text/javascript">
	var divWidth = "<%=sumLength%>";
	var hpWidth = $("#content_"+<%=eid%>).width();
	
	<% if(titleState.equals("hidden")){ %>
	  //alert(divWidth + "===hpWidth="+hpWidth);
	  hpWidth = hpWidth - $("#content_"+<%=eid%>).find(".optoolbar").width();
	<%}%>
	
	var issetting=$("input[name='ispagesetting']").val();
	if(hpWidth < 200){
	   //hpWidth = 382;
	}
	
	if(parseFloat(divWidth) > parseFloat(hpWidth)) {
		$("#tabnavprev_<%=eid%>").css("display","block");
		$("#tabnavnext_<%=eid%>").css("display","block");
		
		<%if(tabIdList.size()>1){%>
	    	 <% if(titleState.equals("hidden")){ %>
			   if(issetting!=='true'){
				 $("#tabContainer_<%=eid%>").css("width", hpWidth -65);
			   }else{
				 $("#tabContainer_<%=eid%>").css("width",  hpWidth -55);
			   }
			   <%}else{%>
			      $("#tabContainer_<%=eid%>").css("width",  hpWidth -50);
	      <%}%>
		$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "0px");
		$("#tabContainer_<%=eid%>").css("margin-right", "0px"); 
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
	
		<%if(tabIdList.size()>1){%>
		   <% if(titleState.equals("hidden")){ %>
			   if(issetting!=='true')
				 $("#tabContainer_<%=eid%>").css("width", hpWidth-55 );
			   else
				 $("#tabContainer_<%=eid%>").css("width", hpWidth); 
		   <%}else{%>
			   $("#tabContainer_<%=eid%>").css("width", hpWidth);
		   <%}%>
		$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "0");
		$("#tabContainer_<%=eid%>").css("margin-right", "0"); 
		<%}else{
		%>
		$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		}%>
	}
</script>
