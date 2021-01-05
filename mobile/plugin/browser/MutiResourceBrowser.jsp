
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="MobileInit.jsp"%>
<%
String resourceids=Util.null2String(request.getParameter("resourceids"));
    //页面传过来的自定义组id
String initgroupid=Util.null2String(request.getParameter("groupid"));
String coworkid=Util.null2String(request.getParameter("coworkid"));
String workID = Util.null2String(request.getParameter("workID"));
String cowtypeid = Util.null2String(request.getParameter("cowtypeid"));
String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
String status=Util.null2String(request.getParameter("status"));
   
String tabid="0";
%>
<HTML>
<HEAD>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <script src="/js/jquery/jquery_wev8.js" type="text/javascript"></script>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
*{font-size:12px;}
</STYLE>


</HEAD>
<body scroll="auto">



<TABLE class=form width=100% id=oTable1 height=100%>

  <TBODY>
  <tr>
  <td  height=30 colspan=3 background="images/bg1_wev8.gif" align=left style="padding: 0px;">
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="images/bg1_wev8.gif" width=15px height=100% align=center></td> 
  
  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="images/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(0)" ><b>按组织架构</b></td>
 
 <!--
  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="images/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(1)" ><b>按定义的组</b></td>
  -->
  <td nowrap name="oTDtype_2"  id="oTDtype_2" background="images/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='pointer'" onclick="resetbanner(2)" ><b>组合查询</b></td>

  <td nowrap name="oTDtype_3"  id="oTDtype_3" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=215>

<IFRAME name=frame1 id=frame1  width=100%  height="260px" frameborder=no scrolling=auto>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100% height=65%>

<IFRAME name=frame2 id=frame2 src="/mobile/plugin/browser/MutiResourceSelect.jsp?tabid=<%=tabid%>&resourceids=<%=resourceids%>&initgroupid=<%=initgroupid%>&coworkid=<%=coworkid%>&workID=<%=workID%>&cowtypeid=<%=cowtypeid%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" width=100%  height="250px" frameborder=no scrolling=auto>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
	function resetbanner(objid){
	    
		for(i=0;i<=2;i++){
			$("#oTDtype_"+i).attr("background","images/bgdark_wev8.gif");
		}
		$("#oTDtype_"+objid).attr("background","images/bglight_wev8.gif");
		var curDoc;
			if(document.all){
				curDoc=window.frames["frame2"].document
			}
			else{
				curDoc=document.getElementById("frame2").contentDocument	
			}
		if(objid == 0 ){		        
		        window.frame1.location="/mobile/plugin/browser/HrmOrgTreeBrowser.jsp?&browserType=resourceMulti&sqlwhere=<%=xssUtil.put(sqlwhere)%>";
		        try{
					$(curDoc).find("#btnsub").css("display","none");
		        }catch(err){}
		        }			
		else if(objid == 1){
			window.frame1.location="/mobile/plugin/browser/SearchByGroup.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>";
			try{
				$(curDoc).find("#btnsub").css("display","none");
			}catch(err){}
			}
		else if(objid == 2){
			window.frame1.location="/mobile/plugin/browser/MutiResourceSearch.jsp?status=<%=status%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>";
			try{
				$(curDoc).find("#btnsub").css("display","inline");
			}catch(err){}
			}
	}
	
function closeWindow(){
	window.parent.close();
}
resetbanner(<%=tabid%>);
</script>

</body>
</html>