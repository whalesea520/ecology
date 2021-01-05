<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>


<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="BlogDao" class="weaver.blog.BlogDao" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
    String imagefilename = "/images/hdSystem_wev8.gif";
    String titlename =SystemEnv.getHtmlLabelName(28171,user.getLanguage()); //微博应用设置
    String needfav ="1";
    String needhelp ="";
    
    int userid=user.getUID();
    
    String tempName=Util.null2String(request.getParameter("tempName"));
    String tempDesc=Util.null2String(request.getParameter("tempDesc"));
    String isSystem=Util.null2String(request.getParameter("isSystem"));
    String sqlwhere = "";
    if(!tempName.equals("")){
    	sqlwhere+=" and t1.tempName like '%"+tempName+"%'";
    }
    if(!tempDesc.equals("")){
    	sqlwhere+=" and t1.tempName like '%"+tempDesc+"%'";
    }
    if(!isSystem.equals("")){
    	sqlwhere+=" and t1.isSystem = '"+isSystem+"'";
    }
    
    int defaultTemplateId = 0;
    rs.executeSql("SELECT * FROM blog_templateUser WHERE userId="+user.getUID());
    if(rs.next()){
    	defaultTemplateId = rs.getInt("templateId");
    }
%>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
    <script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
  </head>

 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:window.weaver.submit(),_top} " ;
	 RCMenuHeight += RCMenuHeightStep ;
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:addTemp(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
    String orderBy = "isSystem , id";
    String backFields = "id , tempName ,tempDesc, isUsed ,userId,isSystem,case isSystem when '1' then '"+ SystemEnv.getHtmlLabelName(83158,user.getLanguage()) +"' else '"+ SystemEnv.getHtmlLabelName(83159,user.getLanguage()) +"' END isSystem_str,"+
    		"CASE WHEN EXISTS(SELECT * FROM blog_templateUser WHERE templateId =t1.id and userId = "+user.getUID()+") THEN 1  ELSE 0 END AS defaultStatus ";
    String sqlFrom = "from blog_template t1 left join "+BlogDao.getTemplateTable(user.getUID()+"")+"t2 on t1.id = t2.tempid";
    sqlwhere = "((t1.id = t2.tempid and isUsed = 1) or (isSystem = 0 and userId = '"+user.getUID()+"'))"+sqlwhere;
    
    
    //System.out.println(backFields);
    //System.out.println(sqlFrom);
    //System.out.println(sqlwhere);
    
    String operateString= "<operates width=\"15%\">";
           operateString+=" <popedom transmethod=\"weaver.blog.BlogTransMethod.getBlogOpratePopedom\" otherpara=\"column:isSystem+"+userid+"+column:userId\"></popedom> ";
           operateString+="     <operate href=\"javascript:editTemp()\" text=\""+SystemEnv.getHtmlLabelName(26473,user.getLanguage())+"\" index=\"0\"/>";
           operateString+="     <operate href=\"javascript:showTemp()\" text=\""+SystemEnv.getHtmlLabelName(221,user.getLanguage())+"\" index=\"1\"/>";
           operateString+="     <operate href=\"javascript:templateShare()\" text=\""+SystemEnv.getHtmlLabelName(2112,user.getLanguage())+"\" index=\"2\"/>";
       	   operateString+="     <operate href=\"javascript:delTemp()\" target=\"_self\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"3\"/>";
           operateString+="</operates>";
    String tableString="<table  pageId=\""+PageIdConst.Blog_TemplatePerson+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Blog_TemplatePerson,user.getUID(),PageIdConst.BLOG)+"\" tabletype=\"checkbox\">";
           tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+Util.toHtmlForSplitPage(sqlFrom)+"\" sqlorderby=\""+orderBy+"\" sqlsortway=\"DESC\" sqlprimarykey=\"id\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlwhere)+"\"  />";
           tableString+="<checkboxpopedom showmethod=\"weaver.blog.BlogTransMethod.getTemplateCheckInfo\" popedompara=\"column:isSystem+column:userId+"+user.getUID()+"\"  />";
           tableString+="<head>";
           tableString+="<col width=\"25%\" transmethod=\"weaver.blog.BlogTransMethod.getBlogTemplateName\" "+
           			"text=\""+ SystemEnv.getHtmlLabelName(18151,user.getLanguage()) +"\" column=\"tempName\" orderkey=\"tempName\" otherpara=\"column:id\"/>";
           tableString+="<col width=\"30%\" text=\""+ SystemEnv.getHtmlLabelName(18627,user.getLanguage()) +"\" column=\"tempDesc\" orderkey=\"tempDesc\"/>";
      	   tableString+="<col width=\"18%\"  text=\""+ SystemEnv.getHtmlLabelName(602,user.getLanguage()) +"\" column=\"isUsed\" orderkey=\"isUsed\""+
      			 " otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.blog.BlogTransMethod.getCheckInfo\" />";
           tableString+="<col width=\"18%\"  text=\""+ SystemEnv.getHtmlLabelName(20622,user.getLanguage()) +"\" column=\"isSystem_str\" orderkey=\"isSystem_str\"/>";
           tableString+="<col width=\"10%\"  text=\""+ SystemEnv.getHtmlLabelName(149,user.getLanguage()) +"\" column=\"id\""+
           		" otherpara=\"column:defaultStatus\" transmethod=\"weaver.blog.BlogTransMethod.getTemplateDefaultInfo\"/>";
           tableString+="</head>"+operateString;
           tableString+="</table>";
%>
<body>
    <wea:layout attributes="{layoutTableId:topTitle}">
    	<wea:group context="" attributes="{groupDisplay:none}">
    		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
    			<input class="e8_btn_top middle" onclick="doSubmit()" type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
    			<input class="e8_btn_top middle" onclick="addTemp()" type="button"  value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
    			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
    			<input type="text" class="searchInput"  id="searchName" name="searchName" value="<%=tempName%>" />
    			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage()) %></span>
    			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
    		</wea:item>
    	</wea:group>
    </wea:layout>

    <form action="BlogTemplatePersonSetting.jsp" method="post" name="weaver">
        <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
        	<wea:layout type="4Col">
        		<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
        			<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
        			<wea:item><input class="InputStyle" name="tempName" id="tempName" value='<%=tempName%>' style="width: 180px;"></wea:item>
        			<wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
        			<wea:item>
        				<input class="InputStyle" name="tempDesc" value="<%=tempDesc%>" style="width: 180px;">
        			</wea:item>
        			
        			<wea:item><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></wea:item>
        			<wea:item>
        				<select name="isSystem" style="width: 150px;">
        					<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
        					<option value="1" <%if(isSystem.equals("1")){ %>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(83158,user.getLanguage()) %></option>
        					<option value="0" <%if(isSystem.equals("0")){ %>selected="selected"<%} %>><%=SystemEnv.getHtmlLabelName(83159,user.getLanguage()) %></option>
        				</select>
        			</wea:item>
        		</wea:group>
        		
        		<wea:group context="" attributes="{'Display':'none'}">
        			<wea:item type="toolbar">
        				<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>" id="searchBtn"/>
        				<span class="e8_sep_line">|</span>
        				<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>" class="e8_btn_cancel" onclick="resetCondition()"/>
        				<span class="e8_sep_line">|</span>
        				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" class="e8_btn_cancel" id="cancel"/>
        			</wea:item>
        		</wea:group>
        	</wea:layout>
        </div>
    </form>
    
    <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Blog_TemplatePerson%>">
    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run"/>
        
    <script type="text/javascript">
        var diag = null;
        $(document).ready(function(){
            jQuery("#topTitle").topMenuTitle({searchFn:searchName});
            jQuery("#hoverBtnSpan").hoverBtn();
        });
     
        function getDialog(title,width,height){
            diag = new window.top.Dialog();
            diag.currentWindow = window; 
            diag.Modal = true;
            diag.Drag = true;
        	diag.Width =width;
        	diag.Height =height;
        	diag.Title = title;
        	return diag;
        }
    	
    	function callback(){
    		if(diag){
    			diag.close();
    		}
    		_table.reLoad();
    	}
      
        function addTemp(){
            diag = getDialog("<%=SystemEnv.getHtmlLabelName(16388,user.getLanguage())%>", 800 ,600);
            diag.URL = "/blog/addBlogTemplate.jsp?operation=editApp&isSystem=0";
            diag.show();
            document.body.click();
        }
      
        function editTemp(id){
            diag = getDialog("<%=SystemEnv.getHtmlLabelName(16449,user.getLanguage())%>", 800 ,600);
            diag.URL = "/blog/addBlogTemplate.jsp?operation=editApp&tempid="+id+"&isSystem=0";
            diag.show();
            document.body.click();
        }
        
        function showTemp(id){
            diag = getDialog("<%=SystemEnv.getHtmlLabelName(33025,user.getLanguage())%>", 800 ,600);
            diag.URL = "/blog/viewBlogTemplate.jsp?tempid="+id;
            diag.show();
            document.body.click();
        }
        
        function delTemp(tempid){
        window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(23069,user.getLanguage())%>",function(){
        	 jQuery.post("/blog/BlogSettingOperation.jsp?operation=deleteTemp&tempid="+tempid,function(){
             	_table. reLoad();
             });
        });  
        }
        
        function batchDelete(){
            var id = _xtable_CheckedCheckboxId();
            if(!id){
        	    window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage()) %>!");
        		return;
        	}
        	id = id.substring(0,id.length-1);
        	delTemp(id);
        }
        
        function preViw(tempid){
        	diag = getDialog("<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage())%>", 600 ,420);
            diag.URL = "/blog/blogTemplateView.jsp?tempid="+tempid;
            diag.show();
            document.body.click();
        }
        
        function templateShare(id){
            diag = getDialog("<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>", 600 ,420);
          	diag.URL = "/blog/blogTemplateShare.jsp?isSystem=false&tempid="+id;
          	diag.show();
          	document.body.click();
        }
        
        function searchName(){
        	var searchName = jQuery("#searchName").val();
        	jQuery("#tempName").val(searchName);
        	window.weaver.submit();
        }
          
        var defaultId = "<%=defaultTemplateId%>";
        var isClear = false;
        
        function detectRadioStatus(obj){
        	if(defaultId == obj.value && !isClear){
        		isClear = true;
        		clearRadioSelected();	
        	} else {
        		isClear = false;
        		defaultId = obj.value;
        		changeRadioStatus(obj, true);
        	}
        }
        
        function clearRadioSelected(){
            var radios = document.getElementsByName("isDefault");
            for(var i=0; i < radios.length; i++){
                changeRadioStatus(radios[i], false);
            }
        }
        
        function doSubmit(){
        	if(jQuery(":radio:checked").length !=0) {
        		jQuery.post("/blog/BlogSettingOperation.jsp",
        			{"operation":"default","isclear":isClear?"1":"0","defaultTemplateId":jQuery(":radio:checked").val()},
                    function(){
        				_table.reLoad();
        			});
        	}
        }
     </script>
</body>
</html>
