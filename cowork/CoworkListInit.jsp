
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CoworkTransMethod" class="weaver.general.CoworkTransMethod" scope="page" />
<%
int userid=user.getUID();

int index=Util.getIntValue(request.getParameter("index"));                 //下标 
int pagesize=Util.getIntValue(request.getParameter("pagesize"));           //每一次取多少
String disattention=Util.null2String(request.getParameter("disattention"));
String disdirect=Util.null2String(request.getParameter("disdirect"));
String layout=Util.null2String(request.getParameter("layout"));
   
int iTotal =Util.getIntValue(request.getParameter("total"),0);
int iNextNum =index;
int ipageset = pagesize;
if(iTotal - iNextNum + pagesize < pagesize) ipageset = iTotal - iNextNum + pagesize;
if(iTotal < pagesize) ipageset = iTotal;

SplitPageParaBean sppb = new SplitPageParaBean();
SplitPageUtil spu = new SplitPageUtil();

String backfields=Util.null2String(session.getAttribute("backfields"));
String sqlFrom=Util.null2String(session.getAttribute("sqlStr"));
String sqlWhere=Util.null2String(session.getAttribute("searchStr"));
String orderby=Util.null2String(session.getAttribute("orderby"));

int pageindex=Util.getIntValue(request.getParameter("pageindex"),1);

sppb.setBackFields(backfields);
sppb.setSqlFrom(sqlFrom);
sppb.setSqlWhere(" where "+sqlWhere);
sppb.setPrimaryKey("id");
sppb.setSortWay(sppb.DESC);
sppb.setSqlOrderBy(orderby);
spu.setSpp(sppb);

int recordCount = spu.getRecordCount();
RecordSet2 = spu.getCurrentPageRsNew(pageindex,pagesize);

if(RecordSet2.getCounts()>0){
	boolean dataLight=true;
    int flag=1;
    while(RecordSet2.next()){
    	String coworkid=RecordSet2.getString("id");
    	String coworkName=RecordSet2.getString("name");
    	String important=RecordSet2.getString("important");
    	String isnew=RecordSet2.getString("isnew");
    	String approvalAtatus=RecordSet2.getString("approvalAtatus");
    	String isTop=Util.null2String(RecordSet2.getString("isTop"),"0");
    	if(isTop == null || "".equals(isTop)) {
    		isTop = "0";
    	}
    	String unread="";
    	String read="";
    	String normal="";
    	String joinType=RecordSet2.getString("jointype");
		
		if(joinType.equals("1")&&flag!=0)
			flag=1;
		else if(flag!=2)
			flag=0;
    	if(joinType.equals("1")&&flag==1&&disdirect.equals("true")){
    		flag=0;
 %>
		<!-- 直接参与 -->
        <TR class="Header" style="background:#f5f5f5;border-bottom:1px solid #eaeaea">
           <th colspan="3" style="color:#242424;padding-left:5px;"><%=SystemEnv.getHtmlLabelName(17691,user.getLanguage())%></th>
           <script>disdirect=false;</script>
        </TR>
 <%   		
    	}
    	if(joinType.equals("0")&&flag==0&&disattention.equals("true")){
    		flag=2;
 %>
        <!-- 关注 -->
        <TR class="Header" style="background:#f5f5f5;border-bottom:1px solid #eaeaea">
           <th colspan="3" style="color:#242424;padding-left:5px;"><%=SystemEnv.getHtmlLabelName(17692,user.getLanguage())%></th>
           <script>disattention=false;</script>
        </TR>
 <%}%>
	<tr class="DataLight">
	  <td nowrap style="padding-left: 0px;padding-right: 0px;">
		 <input type="checkbox" id="" value=<%=coworkid%> name='check_node' unread="<%=unread %>"  read="<%=read %>" important="<%=important %>" normal="<%=normal %>">
	  </td>
	  <td  valign="middle" title="<%=coworkName%>" onclick='viewCowork(this)' _coworkid=<%=coworkid%> style="<%=(isnew.equals("1")?"font-weight:bold;":"")%>;word-break:break-all;cursor:pointer;">
	        <%=CoworkTransMethod.getCoworkName(coworkName,coworkid+"+"+isnew+"+"+userid+"+"+approvalAtatus+"+"+isTop+"+"+layout)%>
	  </td>
	  <td style="width:18px;">
	     <%=CoworkTransMethod.getImportant(important,coworkid)%>
	  </td>
	</tr>
 <% 
   }
}else{    
%>
	<tr class="DataLight">
  	<td align="center" colspan="3" style="text-align:center;border:0px;"><%=SystemEnv.getHtmlLabelName(22521,user.getLanguage())%></td>
  </tr>	
<%}%>
