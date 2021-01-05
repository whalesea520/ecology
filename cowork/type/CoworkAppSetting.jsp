
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.cowork.po.CoworkAppComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%

if (!HrmUserVarify.checkUserRight("collaborationtype:edit", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(26761,user.getLanguage()); //微博应用设置
String needfav ="1";
String needhelp ="";

//协作附件目录参数
String pathcategory = "";
String maincategory = "";
String subcategory = "";
String seccategory = "";
String seccategoryattributes = "{samePair:'seccategory'}";

int userid=user.getUID();

String operation=Util.null2String(request.getParameter("operation"));

RecordSet1.executeSql("select * from CoworkAccessory");
if(RecordSet1.next()){
  maincategory = Util.null2String(RecordSet1.getString(2));
  subcategory = Util.null2String(RecordSet1.getString(3));
  seccategory = Util.null2String(RecordSet1.getString(4));
  pathcategory =CategoryUtil.getCategoryPath(Util.getIntValue(seccategory));
}

%>
<html>
  <head>
  	<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
	<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
  </head>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="collaboration"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(31811,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form action="CoworkAppSettingOperation.jsp" method="post"  id="mainform" enctype="multipart/form-data">
<input type="hidden" value="editApp" name="operation"/> 
<input type=hidden id='pathcategory' name='pathcategory' value="<%=pathcategory%>">
<input type=hidden id='maincategory' name='maincategory' value="<%=maincategory%>">
<INPUT type=hidden id='subcategory' name='subcategory' value="<%=subcategory%>">
<INPUT type=hidden id='seccategory' name='seccategory' value="<%=seccategory%>">



<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>  
  <COL width="20%">
  <COL width="80%">
  <TBODY>
  <TR class=HeaderForXtalbe>
	  <th><%=SystemEnv.getHtmlLabelName(25432,user.getLanguage())%></th>
	  <th><%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%></th>
  </tr>
</TBODY>
</TABLE>  
<wea:layout>
    <wea:group context='<%=SystemEnv.getHtmlLabelName(16261,user.getLanguage()) %>' attributes="{groupDisplay:none}">
	<%
		CoworkAppComInfo coworkAppComInfo = new CoworkAppComInfo();
	coworkAppComInfo.setTofirstRow();
	   while(coworkAppComInfo.next()){
		  String appid = coworkAppComInfo.getId();
	      String appName = coworkAppComInfo.getName();
	      String appType = coworkAppComInfo.getApptype();
	      String isActive = coworkAppComInfo.getIsactive();
	      appName = !appType.equals("custom") ? SystemEnv.getHtmlLabelName(Integer.parseInt(appName),user.getLanguage()):appName;
	  %>
		  <wea:item><%=appName%></wea:item>
          <wea:item>
		    <input type="hidden" value="<%=appid%>" name="appid">
            <%
            if("6".equals(appid)){
            %>    
                <input type="checkbox" tzCheckbox="true" id="accessory" name="isActive_<%=appid%>" <%=isActive.equals("1")?"checked=checked":""%>  value="1" onclick="showCategory(this)"  class="inputstyle"/>   
            <%
            }else{
            %>
			    <input type="checkbox" tzCheckbox="true" name="isActive_<%=appid%>" <%=isActive.equals("1")?"checked=checked":""%>  value="1"  class="inputstyle"/>
            <% 
            }
            %>
          </wea:item>
	<%}%>


        <wea:item attributes='<%=seccategoryattributes %>'><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(92,user.getLanguage())%></wea:item>
        <wea:item attributes='<%=seccategoryattributes %>'>
            <brow:browser viewType="0" name="seccategory"
             browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
             browserValue='<%=seccategory+""%>' idKey="id" nameKey="path"
             browserSpanValue = '<%=CategoryUtil.getCategoryPath(Util.getIntValue(seccategory))%>'
             isSingle="true" hasBrowser="true"  hasInput="true" isMustInput="1" 
             completeUrl="/data.jsp?type=categoryBrowser" width="50%" ></brow:browser>
        </wea:item>
    </wea:group>
</wea:layout>
</form>  
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
 <script type="text/javascript">
  function doSave(){
     jQuery("#mainform").submit();
  }
  
  function doEdit(){
    window.location.href="BlogAppSetting.jsp?operation=editApp";
  }
  
    
jQuery(document).ready(function(){
	 jQuery("input[type=checkbox]").each(function(){
		  if(jQuery(this).attr("tzCheckbox")=="true"){
		   		jQuery(this).tzCheckbox({labels:['','']});
		  }
	 });
     
     //默认根据附件选中情况展示附件目录
      var $autoReceive = jQuery("#accessory");
        if($autoReceive.is(":checked")){
            $autoReceive.attr("value","1");
            showEle("seccategory");
        }else{
            $autoReceive.attr("value","0");
            hideEle("seccategory");
        }
     
});

function showCategory(obj){
    var $obj = jQuery(obj);
        if($obj.is(":checked")){
            jQuery(obj).attr("value","1");
            showEle("seccategory");
        }else{
            jQuery(obj).attr("value","0");
            hideEle("seccategory");
        }
}
 </script>
</html>
