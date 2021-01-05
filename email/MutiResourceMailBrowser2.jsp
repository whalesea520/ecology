
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String resourceids=Util.null2String(request.getParameter("resourceids"));

int uid=user.getUID();
String resourcemulti=(String)session.getAttribute("resourcemulti");
        if(resourcemulti==null){
        Cookie[] cks= request.getCookies();
        
        for(int i=0;i<cks.length;i++){
        if(cks[i].getName().equals("resourcemulti"+uid)){
        resourcemulti=cks[i].getValue();
        break;
        }
        }
        }
String tabid="0";
if(resourcemulti!=null&&resourcemulti.length()>0){
String[] atts=Util.TokenizerString2(resourcemulti,"|");
tabid=atts[0];

}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<STYLE type=text/css>PRE {
}
A {
	COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
}
A:hover {
	COLOR:#56275D;TEXT-DECORATION: none
}
</STYLE>


</HEAD>
<body>



<TABLE class=form width=100% id=oTable1 height=100%>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  </colgroup>
  <TBODY>
  <tr>
  <td  height=30 colspan=3 background="/images/tab/bg1_wev8.gif" align=left>
  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  >
  <tr align="left">
  <td nowrap background="/images/tab/bg1_wev8.gif" width=15px height=100% align=center></td> 
  
  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0)" ><b>按组织架构</b></td>
 
  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1)" ><b>按定义的组</b></td>
 
  <td nowrap name="oTDtype_2"  id="oTDtype_2" background="/images/tab/bglight_wev8.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2)" ><b>组合查询</b></td>

  <td nowrap name="oTDtype_3"  id="oTDtype_3" height="100%" >&nbsp</td>
  </tr>
  </table>
  </td>
  </tr>
<tr>
<td  id=oTd1 name=oTd1 width=100% height=40%>

<IFRAME name=frame1 id=frame1  width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
<tr>
<td  id=oTd2 name=oTd2 width=100 height=60%>

<IFRAME name=frame2 id=frame2 src="/email/MultiSelect2.jsp?tabid=<%=tabid%>&resourceids=<%=resourceids%>" width=100%  height=100% frameborder=no scrolling=no>
浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。
</IFRAME>

</td>
</tr>
</TBODY>
</table>



<script language=javascript>
	function resetbanner(objid){

		for(i=0;i<=2;i++){
			document.all("oTDtype_"+i).background="/images/tab/bgdark_wev8.gif";
		}
		document.all("oTDtype_"+objid).background="/images/tab/bglight_wev8.gif";
		if(objid == 0 ){		        
		        window.frame1.location="/email/SearchByOrgan.jsp";
		        try{
		        window.frame2.btnsub.style.display="none"
		        }catch(err){}
		        }			
		else if(objid == 1){
			window.frame1.location="/email/SearchByGroup.jsp";
			try{
			window.frame2.btnsub.style.display="none"
			}catch(err){}
			}
		else if(objid == 2){
			window.frame1.location="/email/Search.jsp";
			try{
			window.frame2.btnsub.style.display="inline"
			}catch(err){}
			}
	}

resetbanner(<%=tabid%>);
</script>

</body>
</html>