
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page" />
<jsp:useBean id="SptmForHomepage" class="weaver.splitepage.transform.SptmForHomepage" scope="page" />
<jsp:useBean id="rs_doc" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page" />
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology7/skins/default/wui_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>

<SCRIPT language="javascript" src="/js/init_wev8.js"></script>
<%
String keyWord = Util.null2String(request.getParameter("keyword"));
String newsId = Util.null2String(request.getParameter("newsid"));
String newsTemplate = Util.null2String(request.getParameter("newstemplate"));
if("".equals(newsId)||"".equals(newsTemplate)){
	newsId=(String)valueList.get(nameList.indexOf("newsid"));
	newsTemplate=(String)valueList.get(nameList.indexOf("newstemplate"));
}
if("".equals(newsTemplate.trim())){
	newsTemplate=" ";
}else{
	rs_doc.executeQuery("select templatetype from pagenewstemplate where id=?",newsTemplate);
	if(!rs_doc.next()){
		newsTemplate = "";
		rs_doc.executeUpdate("update hpElementSetting set value ='' where name='newstemplate' and  eid=?",eid);
	}
}
//获取查询信息
String newslistclause="";
String sqlwhere="";
int pageindex = Util.getIntValue(request.getParameter("pageindex"),1);
int pageSize = Util.getIntValue(request.getParameter("pagesize"),15);
int totalindex=Util.getIntValue(request.getParameter("totalindex"));
int totalCount=Util.getIntValue(request.getParameter("totalcount"));
//
//判断是否已经封装过查询信息
if(newsId.equals("")||newsId.equals("0")){
	newslistclause="1!=1";
}else{
	dnm.setId(Util.getIntValue(newsId));
	dnm.getDocNewsInfoById();
	newslistclause=dnm.getNewsclause().trim();
}

if("".equals(newslistclause)){
	newslistclause="docpublishtype in ('2','3') and docstatus in('1','2')";
}else{
	newslistclause = newslistclause + " and docpublishtype in ('2','3') and docstatus in('1','2') ";
}
if(!keyWord.equals("")){
	sqlwhere = "docsubject like '%"+keyWord+"%'";
	sqlwhere  =sqlwhere+" and ( " +newslistclause+" )";
}else{
	sqlwhere  = newslistclause;
}

sppb.setBackFields("id,docsubject,doccreatedate");
sppb.setSqlFrom("from DocDetail");
sppb.setSqlWhere(sqlwhere);
sppb.setPrimaryKey("id");
sppb.setSqlOrderBy("doccreatedate");
sppb.setSortWay(sppb.DESC);
spu.setSpp(sppb);
if(totalindex==-1&&totalCount==-1){
	totalCount =spu.getRecordCount();
	if(totalCount%pageSize==0){
	        totalindex=totalCount/pageSize;
	}else{
		    totalindex=(totalCount/pageSize)+1;
	}
}
rs_doc=spu.getCurrentPageRs(pageindex,pageSize);	

%>
<form id="searchForm" name="searchForm" action="NewsSearchList.jsp">
	<input type="hidden" name="pageindex" id="pageindex" ></input>
	<input type="hidden" name="keyword" id="keyword" value="<%=keyWord %>" ></input>
	<input type="hidden" name="pagesize" id="pagesize" ></input>
	<input type="hidden" name="newstemplate" id="newstemplate" value="<%=newsTemplate%>"></input>
	<input type="hidden" name="newsid" id="newsid" value="<%=newsId%>" ></input>
	<input type="hidden" name="totalcount" id="totalcount" value="<%=totalCount%>" ></input>
	<input type="hidden" name="totalindex" id="totalindex" value="<%=totalindex%>"></input>
	<input type="hidden" name="eid" id="eid" value="<%=eid%>"></input>
</form>
<TABLE class=ListStyle cellspacing=1 width="100%">
   <TBODY>
   <TR class=DataLight align=right>
<TD width="100%" colspan ="2">
 <SPAN style="HEIGHT: 21px; TEXT-DECORATION: none; PADDING-TOP: 2px">
    <%=SystemEnv.getHtmlLabelName(18609, 7)%><%=totalCount%><%=SystemEnv.getHtmlLabelName(24683, 7)%>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(265, 7)%><%=pageSize%><%=SystemEnv.getHtmlLabelName(18256, 7)%>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18609, 7)%><%=totalindex%><%=SystemEnv.getHtmlLabelName(23161, 7)%>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(524, 7)%><%=SystemEnv.getHtmlLabelName(15323, 7)%><%=pageindex%><%=SystemEnv.getHtmlLabelName(23161, 7)%></SPAN>&nbsp;&nbsp;
    <SPAN style="WIDTH: 21px; DISPLAY: inline-block; HEIGHT: 21px; CURSOR: pointer; MARGIN-RIGHT: 5px; TEXT-DECORATION: none"  class=weaverTablePrevPage onclick="previousPage()">&nbsp;</SPAN>
    <SPAN style="WIDTH: 21px; DISPLAY: inline-block; HEIGHT: 21px; CURSOR: pointer; MARGIN-RIGHT: 5px; TEXT-DECORATION: none" id=-weaverTable-0-next class=weaverTableNextPage onclick="nextPage()">&nbsp;</SPAN>
    <SPAN style="LINE-HEIGHT: 21px; HEIGHT: 21px; TEXT-DECORATION: none"><%=SystemEnv.getHtmlLabelName(15323, 7)%>&nbsp;</SPAN><INPUT style="BORDER-BOTTOM: #6ec8ff 1px solid; TEXT-ALIGN: right; BORDER-LEFT: #6ec8ff 1px solid; LINE-HEIGHT: 20px; PADDING-RIGHT: 2px; BACKGROUND: none transparent scroll repeat 0% 0%; HEIGHT: 20px; BORDER-TOP: #6ec8ff 1px solid; MARGIN-RIGHT: 5px; BORDER-RIGHT: #6ec8ff 1px solid; widht: 30px" id=topinputtext class=text onmouseover=this.select()  size=3><SPAN style="LINE-HEIGHT: 21px; HEIGHT: 21px; TEXT-DECORATION: none"><%=SystemEnv.getHtmlLabelName(23161, 7)%></SPAN>&nbsp;<SPAN style="BORDER-BOTTOM: medium none; TEXT-ALIGN: center; BORDER-LEFT: medium none; LINE-HEIGHT: 21px; WIDTH: 38px; DISPLAY: inline-block; BACKGROUND: url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat; HEIGHT: 21px; BORDER-TOP: medium none; CURSOR: pointer; MARGIN-RIGHT: 5px; BORDER-RIGHT: medium none" id=-weaverTable-0-goPage onclick="gotopindex()">GO</SPAN>
</TD>
</TR>

  <TR class=header>
          <TD width="70%"><%=SystemEnv.getHtmlLabelName(16242, 7)%></TD>
          
          <TD width="30%"><%=SystemEnv.getHtmlLabelName(1339, 7)%></TD>          
  </TR>
  
  <TR class=Line><TD  colspan="2" style="padding: 0"></TD></TR> 
<% 
while(rs_doc.next()){
	String otherpara = rs_doc.getString("id")+"+"+newsTemplate+"+"+newsId+"+";
%>
  <TR class=DataLight>
   		   <TD width="50%"><%=SptmForHomepage.getHpNewsSearchSubject(rs_doc.getString("docsubject"),otherpara)%></TD> 
           <TD width="6%"><%=rs_doc.getString("doccreatedate") %></TD>
  </TR>
<%
} 
%>
 </TBODY>
 
 
<TR class=DataLight align=right>
<TD width="100%" colspan ="2">
 <SPAN style="HEIGHT: 21px; TEXT-DECORATION: none; PADDING-TOP: 2px">
    <%=SystemEnv.getHtmlLabelName(18609, 7)%><%=totalCount%><%=SystemEnv.getHtmlLabelName(24683, 7)%>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(265, 7)%><%=pageSize%><%=SystemEnv.getHtmlLabelName(18256, 7)%>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(18609, 7)%><%=totalindex%><%=SystemEnv.getHtmlLabelName(23161, 7)%>&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(524, 7)%><%=SystemEnv.getHtmlLabelName(15323, 7)%><%=pageindex%><%=SystemEnv.getHtmlLabelName(23161, 7)%></SPAN>&nbsp;&nbsp;
    <SPAN style="WIDTH: 21px; DISPLAY: inline-block; HEIGHT: 21px; CURSOR: pointer; MARGIN-RIGHT: 5px; TEXT-DECORATION: none"  class=weaverTablePrevPage onclick="previousPage()">&nbsp;</SPAN>
    
    <SPAN style="WIDTH: 21px; DISPLAY: inline-block; HEIGHT: 21px; CURSOR: pointer; MARGIN-RIGHT: 5px; TEXT-DECORATION: none" id=-weaverTable-0-next class=weaverTableNextPage  onclick="nextPage()">&nbsp;</SPAN>
    <SPAN style="LINE-HEIGHT: 21px; HEIGHT: 21px; TEXT-DECORATION: none"><%=SystemEnv.getHtmlLabelName(15323, 7)%>&nbsp;</SPAN><INPUT style="BORDER-BOTTOM: #6ec8ff 1px solid; TEXT-ALIGN: right; BORDER-LEFT: #6ec8ff 1px solid; LINE-HEIGHT: 20px; PADDING-RIGHT: 2px; BACKGROUND: none transparent scroll repeat 0% 0%; HEIGHT: 20px; BORDER-TOP: #6ec8ff 1px solid; MARGIN-RIGHT: 5px; BORDER-RIGHT: #6ec8ff 1px solid; widht: 30px" id=bottominputtext class=text onmouseover=this.select() size=3><SPAN style="LINE-HEIGHT: 21px; HEIGHT: 21px; TEXT-DECORATION: none"><%=SystemEnv.getHtmlLabelName(23161, 7)%></SPAN>&nbsp;<SPAN style="BORDER-BOTTOM: medium none; TEXT-ALIGN: center; BORDER-LEFT: medium none; LINE-HEIGHT: 21px; WIDTH: 38px; DISPLAY: inline-block; BACKGROUND: url(/wui/theme/ecology7/skins/default/table/jump_wev8.png) no-repeat; HEIGHT: 21px; BORDER-TOP: medium none; CURSOR: pointer; MARGIN-RIGHT: 5px; BORDER-RIGHT: medium none" id=-weaverTable-0-goPage onclick="gobottomindex()">GO</SPAN>
</TD>

</TR>


 </TABLE>
<style>
<!--
a {
	text-decoration: none;
}
-->
</style>
<script type="text/javascript">
var pageindex=<%=pageindex%>;
var totalindex=<%=totalindex%>;
$(document).ready(function(){
	$(".text").val(pageindex);
	if(pageindex==1){
		$(".weaverTablePrevPage").addClass("weaverTablePrevPageOfDisabled");	
	}
	if(pageindex>=totalindex){
		$(".weaverTableNextPage").addClass("weaverTableNextPageOfDisabled");
	}
});
function previousPage(){
	if(pageindex==1){
        return;
    }else{
        document.getElementById("pageindex").value=pageindex-1;
        document.getElementById("searchForm").submit();
    }
}
function nextPage(){
	if(pageindex>=totalindex){	
             return;
    }else{
    	document.getElementById("pageindex").value=pageindex+1;
    	document.getElementById("searchForm").submit();
    }
}
function gotopindex(){
  var inputindex=$("#topinputtext").val();
  if(inputindex<1){
      inputindex=1;
  }
  if(inputindex>totalindex){
      inputindex=totalindex;
  }
    $("#pageindex").val(inputindex);
	$("#searchForm").submit();
}
function gobottomindex(){
	  var inputindex=$("#bottominputtext").val();
	  if(inputindex<1){
	      inputindex=1;
	  }
	  if(inputindex>totalindex){
	      inputindex=totalindex;
	  }
	  $("#pageindex").val(inputindex);
	  $("#searchForm").submit();
}
function openFullWindowForXtable(url){
	  var redirectUrl = url ;
	  var width = screen.width ;
	  var height = screen.height ;
	  var szFeatures = "top=100," ; 
	  szFeatures +="left=400," ;
	  szFeatures +="width="+width/2+"," ;
	  szFeatures +="height="+height/2+"," ; 
	  szFeatures +="directories=no," ;
	  szFeatures +="status=yes," ;
	  szFeatures +="menubar=no," ;
	  szFeatures +="scrollbars=yes," ;
	  szFeatures +="resizable=yes" ;
	  window.open(redirectUrl,"",szFeatures) ;
}	
</script>
