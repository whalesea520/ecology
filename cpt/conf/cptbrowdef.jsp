<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<%

if(!HrmUserVarify.checkUserRight("CptMaint:CptBrowDef", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
String nameQuery = Util.null2String(request.getParameter("nameQuery"));
String rightStr = "";
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/cpt/js/validate_wev8.js"></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
</head>
<%
String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82704,user.getLanguage());
String needfav ="1";
String needhelp ="";
String needcheck="";
int rownum=1;
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(82704,user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=frmain name=frmain method=post action="/cpt/conf/cptbrowdefop.jsp"    >
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top"  onclick="submitData()"/>
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>		
<div class="advancedSearchDiv" id="advancedSearchDiv"></div>


<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item attributes="{'isTableList':'true'}">

<div id="detaildata" style="overflow:hidden">
			
<table class="thead ListStyle" style="position:fixed;z-index:99!important;margin-left: -15px!important;">
    <COLGROUP>
		<col width="20%">
 	  	<col width="40%">
 	  	<col width="40%">
<thead>
<tr class=header style=""> 
  <td >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></td>
  <td>&nbsp;&nbsp;&nbsp;
    <input type="checkbox"    name="IsconditionsAll" id="IsconditionsAll"
           onClick="" >
    <%=SystemEnv.getHtmlLabelName(82705,user.getLanguage())%>
  </td>
  <td>&nbsp;
    <input type="checkbox"    name="IstitleAll" id="IstitleAll" 
           onClick="">
    <%=SystemEnv.getHtmlLabelName(82706,user.getLanguage())%>
  </td>
</tr>        
</thead>
</table>

<table class="tbody ListStyle" id="oTable"  style="z-index:1!important;margin-top:35px!important;">
      <colgroup>
 	  	<col width="20%">
 	  	<col width="40%">
 	  	<col width="40%">
 	  </colgroup>
        <tbody>

<%
HashMap fieldlabelmap=new HashMap<String,String>();
String sql = "select t1.*,t2.fieldlabel,t2.fieldname from cpt_browdef t1,cptDefineField t2 where t1.fieldid=t2.id and t2.isopen='1' order by t1.displayorder,t2.dsporder  ";
rs.executeSql(sql);


while(rs.next()){
	String fieldname = Util.null2String(rs.getString("fieldid"));
	String istitle = Util.null2String(rs.getString("istitle"));
	String istitle_type = Util.null2String(rs.getString("istitle_type"));
	String isconditions = Util.null2String(rs.getString("iscondition"));
	String isconditions_type = Util.null2String(rs.getString("iscondition_type"));
	String displayorder = Util.null2String(rs.getString("displayorder"));
	
	int fieldlabel=Util.getIntValue(Util.null2String(rs.getString("fieldlabel")),0);
	//if(fieldlabel<=0) continue;
	
	%>
	<TR class="<%=rownum%2==0?"DataLight":"DataDark" %>" >
      <TD>
      <img moveimg src='/proj/img/move_wev8.png'   title='<%=SystemEnv.getHtmlLabelNames("82783",user.getLanguage())%>' />
      	 <%=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage())%>
		 <input name="fieldname_<%=(rownum)%>" type=hidden value="<%=fieldname %>">
      </TD>
      <td class=Field>
      	 <input type="checkbox" <%="1".equals( isconditions_type)?"readonly":"" %> name='isconditions_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',3,this)" value="1" <%if(isconditions.equals("1")){%>checked<%}%>>           
      </td>
      <td class=Field>
         <input type="checkbox"  <%="1".equals(istitle_type)?"readonly":"" %>   name='istitle_<%=(rownum)%>' onclick="changecheck('<%=(rownum)%>',2,this)" value="1" <%if(istitle.equals("1")){%>checked<%}%>>
         <input type="hidden" onKeyPress="ItemNum_KeyPress(this.name)" onclick="choosetitle('<%=(rownum)%>')" maxlength=5 name="displayorder_<%=rownum %>"  onblur="checknumber(this.name)" value="<%=rownum %>">
      </td>
    </TR>
	<%
	rownum++;
	
}


%>


          
        </tbody>
      </table>
      
      
</div>			
		</wea:item>
	</wea:group>
</wea:layout>


<input type="hidden" name="rownum" value="<%=rownum %>" />
</form>

<script language="javascript">
function submitData(){
	refreshDisplayIndex();
	$GetEle('frmain').submit();	
}
function refreshDisplayIndex(){
	$("#oTable").find("tr").each(function(i){
		$(this).find("input[name^=displayorder_]").val(i);
	});
}




$(function(){//checkbox的联动
	$("#IstitleAll").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'istitle_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'istitle_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
			$("[name ^= 'istitle_'][readonly]").attr("checked", true).next("span").addClass("jNiceChecked");
		}
		
	});
	$("#IsconditionsAll").bind("click",function(){
		if($(this).attr("checked")==true){
			$("[name ^= 'isconditions_']:checkbox").attr("checked", true).next("span").addClass("jNiceChecked");
		}else{
			$("[name ^= 'isconditions_']:checkbox").attr("checked", false).next("span").removeClass("jNiceChecked");
			$("[name ^= 'isconditions_'][readonly]").attr("checked", true).next("span").addClass("jNiceChecked");
			
		}
	});
	
	
	//高亮搜索
	$("#topTitle").topMenuTitle({});
});

function registerDragEvent(){
	 var fixHelper = function(e, ui) {
	    ui.children().each(function() {  
	      jQuery(this).width(jQuery(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了  
	      jQuery(this).height("30px");						//在CSS中定义为30px,目前不能动态获取
	    });  
	    return ui;  
  }; 
   jQuery(".ListStyle tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
       helper: fixHelper,                  //调用fixHelper  
       axis:"y",  
       start:function(e, ui){
       	 ui.helper.addClass("moveMousePoint");
         ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
         if(ui.item.hasClass("notMove")){
         	e.stopPropagation();
         }
         $(".hoverDiv").css("display","none");
         return ui;  
       },  
       stop:function(e, ui){
           //ui.item.removeClass("ui-state-highlight"); //释放鼠标时，要用ui.item才是释放的行  
           jQuery(ui.item).hover(function(){
          	jQuery(this).addClass("e8_hover_tr");
          },function(){
          	jQuery(this).removeClass("e8_hover_tr");
          	
          });
          jQuery(ui.item).removeClass("moveMousePoint");
          return ui;  
       }  
   });  
}


$(function(){
	$("#oTable").find("tr")
	.live("mouseover",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move-hot_wev8.png")})
	.live("mouseout",function(){$(this).find("img[moveimg]").attr("src","/proj/img/move_wev8.png")});
	
	registerDragEvent();
});
</script>

</BODY>
</HTML>

