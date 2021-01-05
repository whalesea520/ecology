<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.*,weaver.systeminfo.*" %>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%

String itemtypeid = Util.null2String(request.getParameter("itemtypeid"));
String itemtypename = Util.null2String(request.getParameter("itemtypename"));
byte[] bt = null;   
try{   
	sun.misc.BASE64Decoder decoder = new sun.misc.BASE64Decoder();
	bt = decoder.decodeBuffer(itemtypename);
	itemtypename = new String(bt);
}catch(Exception e){   
	itemtypename = "";
}   

int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
%>

  <table class=liststyle cellspacing=1 >
  <colgroup>
  <col width="25%">
  <col width="25%">
  <col width="10%">
  <col width="15%">
  <col width="20%">
  <col width="5%">
    <tbody>
	<tr class=header> 
      <td colspan=6><a href="InputReportItemtypeEdit.jsp?itemtypeid=<%=itemtypeid%>"><%=itemtypename%></a></td>
    </tr>
    <tr class=Header> 
      <td><%=SystemEnv.getHtmlLabelName(15207,languageid)%></td>
      <td><%=SystemEnv.getHtmlLabelName(15209,languageid)%></td>
	  <td><%=SystemEnv.getHtmlLabelName(20826,languageid)%></td>
	  <td><%=SystemEnv.getHtmlLabelName(20790,languageid)%></td>
      <td><%=SystemEnv.getHtmlLabelName(15828,languageid)%></td>
      <td><%=SystemEnv.getHtmlLabelName(88,languageid)%></td>
    </tr>
	<tr class=Line><td colspan="6" style="padding: 0px"></td></tr> 
    <%
	int i = 0 ;
	rs1.executeProc("T_IRItem_SelectByItemtypeid",""+itemtypeid);
	while(rs1.next()) {
        String itemid = Util.null2String(rs1.getString("itemid")) ;
		String itemdspname = Util.toScreen(rs1.getString("itemdspname"),languageid) ;
		String itemfieldname = Util.null2String(rs1.getString("itemfieldname")) ;
		String itemfieldtype = Util.null2String(rs1.getString("itemfieldtype")) ;
		String itemexcelsheet = Util.toScreen(rs1.getString("itemexcelsheet"),languageid) ;
		String itemexcelrow = Util.null2String(rs1.getString("itemexcelrow")) ;
		String itemexcelcolumn = Util.null2String(rs1.getString("itemexcelcolumn")) ;
        String dsporder = Util.null2String(rs1.getString("dsporder")) ;
        String itemgongsi = Util.null2String(rs1.getString("itemgongsi")) ;
        String inputablefact = Util.null2String(rs1.getString("inputablefact")) ; // 实际是否可输入
        String inputablebudg = Util.null2String(rs1.getString("inputablebudg")) ; // 预算是否可输入
        String inputablefore = Util.null2String(rs1.getString("inputablefore")) ; // 预测是否可输入
  	
    if(i==0){
  		i=1;
  	%>
    <tr class=datalight> 
      <%}else{
  		i=0;
  	%>
    <tr class=datadark> 
    <% }%>
      <td><a href="InputReportItemEdit.jsp?itemid=<%=itemid%>"><%=itemdspname%></a></td>
      <td><%=itemfieldname%></td>
	  <td>
	    <% if(itemfieldtype.equals("1")) { %><%=SystemEnv.getHtmlLabelName(15201,languageid)%>
		<%} else if(itemfieldtype.equals("2")) { %><%=SystemEnv.getHtmlLabelName(15202,languageid)%>
		<%} else if(itemfieldtype.equals("3")) { %><%=SystemEnv.getHtmlLabelName(15203,languageid)%>
		<%} else if(itemfieldtype.equals("4")) { %><%=SystemEnv.getHtmlLabelName(20791,languageid)%>
        <%} else if(itemfieldtype.equals("5")) { %><%=SystemEnv.getHtmlLabelName(20792,languageid)%>
        <%} else if(itemfieldtype.equals("6")) { %><%=SystemEnv.getHtmlLabelName(15206,languageid)%><%}%>
	  </td>
	  <td> <%=SystemEnv.getHtmlLabelName(18620,languageid)%>：<%=itemexcelrow%> <%=SystemEnv.getHtmlLabelName(18621,languageid)%>：<%=itemexcelcolumn%> 
      </td>
      <td>
        <% if(itemfieldtype.equals("5")) { %>
        <%=itemgongsi%><br>
        <%}%>
	  </td>
      <td><%=dsporder%></td>
    </tr>
	<%}%>
    </tbody>
  </table>