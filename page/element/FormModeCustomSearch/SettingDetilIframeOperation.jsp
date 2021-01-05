<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
<%
String id = Util.null2String(request.getParameter("id"));
String searchtitle = Util.null2String(request.getParameter("searchtitle"));
String eid = Util.null2String(request.getParameter("eid"));
String reportId = Util.null2String(request.getParameter("reportId"));
String fields = Util.null2String(request.getParameter("fields"));
String fieldsWidth = Util.null2String(request.getParameter("fieldsWidth"));
String isshowunread = Util.null2String(request.getParameter("isshowunread"));
//System.out.println(isshowunread);
String disorder = Util.null2String(request.getParameter("disorder"));
String isautoomit = Util.null2String(request.getParameter("isautoomit"));
String isshowassingle = Util.null2String(request.getParameter("isshowassingle"));
String morehref = Util.null2String(request.getParameter("morehref"));
User user = HrmUserVarify.getUser (request , response) ;
RecordSet rs = new RecordSet();
boolean isAdd=false;
if(Util.getIntValue(id,0)>0){//编辑
	String sql="update formmodeelement set searchtitle='"+searchtitle+"',reportId='"+reportId
	+"',fields='"+fields+"',fieldsWidth='"+fieldsWidth+"',isshowunread='"+isshowunread+"',disorder="+disorder+",isautoomit='"+isautoomit+"'"
	+",morehref='"+morehref+"'"
	+" where id="+id+" and eid="+eid;
	rs.executeSql(sql);
	
}else{//新建
	String sql="insert into formmodeelement(eid,reportId,isshowunread,fields,fieldsWidth,disorder,searchtitle,isautoomit,morehref)"
	+"values("+eid+",'"+reportId+"','"+isshowunread+"','"+fields+"','"+fieldsWidth+"','"+disorder+"','"+searchtitle+"','"+isautoomit+"','"+morehref+"')";
	rs.executeSql(sql);
	isAdd = true;
	rs.executeSql("select max(id) as maxid from formmodeelement ");
	if(rs.next()){
		id=rs.getString("maxid");
	}
}
if(isAdd){%>
  <script type="text/javascript">
  	var str="<span id=\"searchid<%=id%>\"><%=searchtitle %>&nbsp;&nbsp;&nbsp;<a href=\"javascript:delDetil_<%=eid %>('<%=id%>')\" style=\"color: #0088d8\"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a>";
  	str+="&nbsp;<a href=\"javascript:addDetil_<%=eid%>('<%=id%>')\" style=\"color: #0088d8\"><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></a></br></span>";
  	var str1=jQuery("#searchdiv_<%=eid%>",parent.parentWin.document).html();
  	jQuery("#searchdiv_<%=eid%>",parent.parentWin.document).html(str1+str);
  	parent.dialog.closeByHand();
  </script>
<%}else{%>
	<script type="text/javascript">
		parent.dialog.closeByHand();
	</script>
<%}%>