
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/homepage/element/content/Common.jsp" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="oracle.sql.CLOB" %>
<%@ page import="java.io.BufferedReader,weaver.filter.*" %>
<%@ page import="weaver.workflow.request.*" %>
<%@page import="weaver.page.HPTypeEnum"%>
<jsp:useBean id="dnm" class="weaver.docs.news.DocNewsManager" scope="page"/>
<jsp:useBean id="dm" class="weaver.docs.docs.DocManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rsIn" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="sppb" class="weaver.general.SplitPageParaBean" scope="page"/>
<jsp:useBean id="spu" class="weaver.general.SplitPageUtil" scope="page"/>
<jsp:useBean id="HomepageFiled" class="weaver.homepage.HomepageFiled" scope="page"/>
<jsp:useBean id="WorkflowCount" class="weaver.page.element.WorkflowCount" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page"/>
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page"/>
<jsp:useBean id="HomepageSetting" class="weaver.homepage.HomepageSetting" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<script type="text/javascript" src="/js/jquery/jquery.scrollTo_wev8.js"></script>
<script type="text/javascript">
function backMarqueeDiv8(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft - 100 + 'px')}, 500 );
}

function nextMarqueeDiv8(eid)
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
	/*
		基本信息
		--------------------------------------
		hpid:表首页ID
		subCompanyId:首页所属分部的分部ID
		eid:元素ID
		ebaseid:基本元素ID
		styleid:样式ID
		
		条件信息
		--------------------------------------
		String strsqlwhere 格式为 条件1^,^条件2...
		int perpage  显示页数
		String linkmode 查看方式  1:当前页 2:弹出页
 
		
		字段信息
		--------------------------------------
		fieldIdList
		fieldColumnList
		fieldIsDate
		fieldTransMethodList
		fieldWidthList
		linkurlList
		strsqlwherecolumnList
		isLimitLengthList

		样式信息
		----------------------------------------
		String hpsb.getEsymbol() 列首图标
		String hpsb.getEsparatorimg()   行分隔线 
	*/

%>
<%	
	String wftypeSetting="";
	String wflowSetting="";
	String wfNodeSetting="";
	String viewType="1";
	String strSqlWf="";
	int isExclude=0;
	String languageId = "";
	if(user == null){
		languageId = "7";
	}else{
		languageId = ""+user.getLanguage();
	}
	ArrayList tabIdList = new ArrayList();
	ArrayList tabTitleList = new ArrayList();
	
	String titleState = esc.getTitleState(styleid);	


   if (!"".equals(strsqlwhere))  { //表示为老版本流程中心
		HomepageSetting.wfCenterUpgrade(strsqlwhere,Util.getIntValue(eid));
   } 
   
   String tabSql="select tabId,tabTitle from hpsetting_wfcenter where eid="+eid+" order by orderNum";
   rs.execute(tabSql);
   MultiLangFilter f = new MultiLangFilter();
   String tempTitle = "";
   while(rs.next()){
	   tabIdList.add(rs.getString("tabId"));
	   tempTitle = rs.getString("tabTitle");
	   try{
			tempTitle = f.processBody(tempTitle,languageId);
		}catch(Exception e){
			e.printStackTrace();
		}
	   tabTitleList.add(tempTitle);
  }
 //校验当前tab信息
   tabSql="select tabId from hpsetting_wfcenter where eid="+eid+" and tabId='"+currenttab+"'";
   rs.execute(tabSql);
   if(!rs.next()){
	   if(tabIdList.size()>0){
	       currenttab =(String)tabIdList.get(0);
	   }
   }
   
  String queryString = request.getQueryString();
  String url = "/page/element/compatible/WorkflowTabContentData.jsp";
  queryString = queryString+"&tabsize="+tabIdList.size();
  
  HashMap map = new HashMap();
  if (HPTypeEnum.HP_WORKFLOW_FORM.getName().equals(pagetype)) {
	map = (HashMap)WorkflowCount.getWorkflowCountByWorkflowForm(Util.getIntValue(request.getParameter("requestid"),-1), Util.getIntValue(hpid), fieldids, fieldvalues, eid, user);
  } else {
	map = (HashMap)WorkflowCount.getWorkflowCount(eid,user);
  }
%>
<%
String display ="none";
if(tabIdList.size()>1){
	display = "";
}
int sumLength = 0;
%>
<%
	if(titleState.equals("hidden")){
		
	}
%>
<div id="titleContainer_<%=eid%>"  style="border:0px;width:100%;overflow: hidden;position: relative;display:<%=display %>">

<div id="tabnavprev_<%=eid%>" style="cursor:hand;position:relative;float:left;left:-5px;top:-6px;" class="picturebackhp" onclick="backMarqueeDiv8('#tabContainer_<%=eid%>');">&nbsp;</div>


<div id="tabContainer_<%=eid%>" class='tab2' style="width:100%;overflow:hidden;display:none;float:left;">
	<table height='32' width="<%=77*tabIdList.size()%>" cellspacing='0' cellpadding='0' border='0' style="table-layout:fixed;">
		<tr>
			<%for(int i=0;i<tabIdList.size();i++){
				int length = 77;
				String showCount = (String)map.get(String.valueOf(tabIdList.get(i)));
				int count = Util.getIntValue(showCount.split(",")[0],0);
				String flag = Util.null2o(showCount.split(",")[1]);
				//int count = Util.getIntValue((String)map.get(String.valueOf(tabIdList.get(i))),0);
				if(count>=100) count = 99;
				String alength = Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;"));
				int lengthByte = alength.getBytes().length;
				if(lengthByte*8>77){
					length = lengthByte * 7;
				}
				length = 77;
				%>
				<%if(currenttab.equals(tabIdList.get(i))){ %>
					<td style="padding-top:5px;vertical-align:top;" title="<%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %>"  id="tab_<%=eid%>" tabId=<%=tabIdList.get(i) %> class='tab2selected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString%>',event)">
					<span class="ellipsis"><%=Util.toHtml2(((String) tabTitleList.get(i)).replaceAll("&", "&amp;")) %></span>
					<%if("1".equals(flag)){%>
					<font id='<%=eid%>_<%=tabIdList.get(i)%>'>(<%=count%>)</font><%}%>
					</td>
				<% }else{%>
					<td style="padding-top:5px;vertical-align:top;"  title="<%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %>"  id="tab_<%=eid+"_"+tabIdList.get(i)%>" tabId=<%=tabIdList.get(i) %> class='tab2unselected' onclick="loadContent('<%=eid%>','<%=url%>','<%=queryString%>',event)">
						<span class="ellipsis"><%=Util.toHtml2(((String)tabTitleList.get(i)).replaceAll("&","&amp;")) %></span>
					<%if("1".equals(flag)){%>
					<font id='<%=eid%>_<%=tabIdList.get(i)%>'>(<%=count%>)</font><%}%>
					</td>
			<%	 }
				sumLength += length;
			 }
			 sumLength = sumLength + 36;  %>
		</tr>
	</table>
</div>


<% if(titleState.equals("hidden")){ %>
    <div id="tabnavnext_<%=eid%>" style="cursor:hand;position:relative;float:left;right:-6px;top:-6px;" class="picturenexthp" onclick="nextMarqueeDiv8('#tabContainer_<%=eid%>');">&nbsp;</div>
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
			   toolbaritem.find("li").css("margin-right","4px");
			   if(bgitem!=='' && bgitem!=='none')
			    $("#titleContainer_<%=eid%>").css("background-image",bgitem);
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
    <div id="tabnavnext_<%=eid%>" style="cursor:hand;position:relative;float:right;right:0;top:-6px;" class="picturenexthp" onclick="nextMarqueeDiv8('#tabContainer_<%=eid%>');">&nbsp;</div>
<%} %>



</div>

<div id="tabContant_<%=eid%>">
    <%
	if(tabIdList.size()>0){
	%>
	<jsp:include page="<%=url%>" flush="true" >
			<jsp:param name="tabId" value="<%=currenttab%>"/>
			<jsp:param name="tabsize" value="<%=tabIdList.size()%>"/>
			<jsp:param name="ebaseid" value='<%=request.getParameter("ebaseid")%>'/>
			<jsp:param name="eid" value='<%=request.getParameter("eid")%>'/>
			<jsp:param name="styleid" value='<%=request.getParameter("styleid")%>'/>
			<jsp:param name="hpid" value='<%=request.getParameter("hpid")%>'/>
			<jsp:param name="subCompanyId" value='<%=request.getParameter("subCompanyId")%>'/>
	</jsp:include>
	<%
	}
	%>
</div>


<script type="text/javascript">


	var divWidth = "<%=sumLength%>";
	var hpWidth = $("#content_"+<%=eid%>).width();
	
	//元素独立显示时，获取宽度方法
	if ("true" == "<%=indie%>") {
		hpWidth = $("#tabContant_"+<%=eid%>).width();
	}
	
	<% if(titleState.equals("hidden")){ %>
	  //alert(divWidth + "===hpWidth="+hpWidth);
	  hpWidth = hpWidth - $("#content_"+<%=eid%>).find(".optoolbar").width();
	<%}%>
	
	var issetting=$("input[name='ispagesetting']").val();
	if(hpWidth < 200 && <%=Util.getIntValue(hpid)<0 %>){
	   hpWidth = 382;//临时处理，出现小于 200 情况，基本是不正常，一般是 属于协同元素。协同元素宽度固定
	}
	
	if(parseFloat(divWidth) > parseFloat(hpWidth)) {
		$("#tabnavprev_<%=eid%>").css("display","block");
		$("#tabnavnext_<%=eid%>").css("display","block");
		
		<%if(tabIdList.size()>1){%>
		   <% if(titleState.equals("hidden")){ %>
			   if(issetting!=='true'){
			     $("#tabContainer_<%=eid%>").css("width", hpWidth - 50);
		       }else
                 $("#tabContainer_<%=eid%>").css("width", hpWidth - 55);
		   <%}else{%>
		       $("#tabContainer_<%=eid%>").css("width", hpWidth - 55);
		   <%}%>
			$("#tabContainer_<%=eid%>").css("display", ""); 
			$("#tabContainer_<%=eid%>").css("margin-left", "0px");
			$("#tabContainer_<%=eid%>").css("margin-right", "0px"); 
		<%
		  }else{
		%>
			$("#tabnavprev_<%=eid%>").css("display","none");
			$("#tabnavnext_<%=eid%>").css("display","none");
			$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		  }
	    %>
	}else{
		$("#tabnavprev_<%=eid%>").css("display","none");
		$("#tabnavnext_<%=eid%>").css("display","none");
	
		<%if(tabIdList.size()>1){%>
			 
			  <% if(titleState.equals("hidden")){ %>
				   if(issetting!=='true')
			 		 $("#tabContainer_<%=eid%>").css("width", hpWidth-50 );
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


