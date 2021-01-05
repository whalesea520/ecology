<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.io.*" %>
<%@ page import="oracle.sql.CLOB" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="CoMainTypeComInfo" class="weaver.cowork.CoMainTypeComInfo" scope="page"/>

<html>
    <head>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <script type="text/javascript" src="/cowork/js/coworkUtil_wev8.js"></script>
    </head>

<%
    String imagefilename = "/images/hdHRM_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(320,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17694,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
    
    String typename=Util.null2String(request.getParameter("typename"));
    String departmentid=Util.null2String(request.getParameter("departmentid"));
    departmentid = departmentid.equals("all")?"":departmentid;
    
    String isApproval=Util.null2String(request.getParameter("isApproval"));
    String isAnonymous=Util.null2String(request.getParameter("isAnonymous"));
    
    String tableString = "";
    int perpage=10;                                 
    String backfields = " id,id id_str,typename,departmentid,isApproval,isAnonymous ";
    String fromSql  = " cowork_types ";
    String sqlWhere = " 1=1 ";
    String orderby = " id ";
    
    if(!typename.equals(""))
    	sqlWhere=sqlWhere+" and typename like '%"+typename+"%' ";
    if(!departmentid.equals(""))
    	sqlWhere=sqlWhere+" and departmentid="+departmentid;
    if(!isApproval.equals(""))
    	sqlWhere=sqlWhere+" and isApproval="+isApproval;
    if(!isAnonymous.equals(""))
    	sqlWhere=sqlWhere+" and isAnonymous="+isAnonymous;
    
    tableString = " <table tabletype=\"checkbox\" pageId=\""+PageIdConst.Cowork_TypeList+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Cowork_TypeList,user.getUID(),PageIdConst.COWORK)+"\" >"+
    			  " <checkboxpopedom    popedompara=\"column:id\" showmethod=\"weaver.general.CoworkTransMethod.getTypeCheckBox\" />"+
    			  " <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\" />"+
                  " <head>"+
                  "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" orderkey=\"typename\" column=\"typename\" linkvaluecolumn=\"id\" href=\"javascript:editCoworkType('{0}')\"/>"+
                  "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(178,user.getLanguage())+"\" orderkey=\"departmentid\" column=\"departmentid\" transmethod=\"weaver.cowork.CoMainTypeComInfo.getCoMainTypename\"/>"+
                  "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(31449,user.getLanguage())+"\" orderkey=\"isApproval\" column=\"isApproval\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.CoworkTransMethod.getIsApproval\" />"+
                  "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(18576,user.getLanguage())+"\" orderkey=\"isAnonymous\" column=\"isAnonymous\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.general.CoworkTransMethod.getIsAnonymous\" />"+
                  "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("2097,68",user.getLanguage())+"\" column=\"id\" defaultLinkText=\""+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"\" linkvaluecolumn=\"id\" href=\"javascript:showShareEdit('{0}','manager')\"/>"+
                  "	<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelNames("882",user.getLanguage())+"\" column=\"id_str\" defaultLinkText=\""+SystemEnv.getHtmlLabelName(361,user.getLanguage())+"\" linkvaluecolumn=\"id\" href=\"javascript:showShareEdit('{0}','members')\"/>"+
                  "	</head>"+ 
                  " <operates width=\"15%\">"+
                  "     <popedom transmethod=\"weaver.general.CoworkTransMethod.getTypeOperates\"></popedom> "+
          		  "     <operate  href=\"javascript:editCoworkType()\"   text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\"    target=\"_self\"  index=\"0\"/>"+
          		  "     <operate  href=\"javascript:delCoworkType()\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\"  index=\"1\"/>"+
          		  " </operates>"+
                  "</table>";
%>
        <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
        <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
        <%
            RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:doSearch(),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
            RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:batchDelete(),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
            RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:newCoworkType(),_self} " ;
            RCMenuHeight += RCMenuHeightStep ;
            
        %>
        <%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

    <body>
        <wea:layout attributes="{layoutTableId:topTitle}">
        	<wea:group context="" attributes="{groupDisplay:none}">
        		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
        			<input class="e8_btn_top middle" onclick="batchDelete()" type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>"/>
        			<input class="e8_btn_top middle" onclick="newCoworkType()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>"/>
        			<input type="text" class="searchInput"  id="searchtypename" name="searchtypename" 
        					value="<%=typename %>"/>
        			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(347,user.getLanguage()) %></span>
        			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
        		</wea:item>
        	</wea:group>
        </wea:layout>
    
        <div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >	
        <form id="mainfrom" action="CoworkTypeChild.jsp" method="post">
            <wea:layout type="4col">
            	<wea:group context="" attributes="{'groupDisplay':'none'}">
            		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
            		<wea:item>
            			<input class="inputstyle" type="text" name="typename" id="typename" value="<%=typename%>" style="width:150px;" maxlength=25 onkeydown="if(window.event.keyCode==13) return false;">      
            		</wea:item> 
            		
            		<wea:item><%=SystemEnv.getHtmlLabelName(178,user.getLanguage())%></wea:item>
            		<wea:item>
            			<select name=departmentid id=departmentid style="width: 120px;">
            				<option value="">&nbsp;&nbsp;&nbsp;&nbsp;</option>
            			    <%while(CoMainTypeComInfo.next()){%>
            			    <option value="<%=CoMainTypeComInfo.getCoMainTypeid()%>" <%=CoMainTypeComInfo.getCoMainTypeid().equals(departmentid)?"selected=selected":""%>><%=CoMainTypeComInfo.getCoMainTypename()%></option>
            			    <%}%>
            			</select>      
            		</wea:item>
            		
            		<wea:item><%=SystemEnv.getHtmlLabelName(31449,user.getLanguage())%></wea:item>
            		<wea:item>
            			<select style="width: 120px;" name="isApproval" id="isApproval">
            			   <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            			   <option value="1" <%=isApproval.equals("1")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
            			   <option value="0" <%=isApproval.equals("0")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
            			</select>      
            		</wea:item> 
            		
            		<wea:item><%=SystemEnv.getHtmlLabelName(18576,user.getLanguage())%></wea:item>
            		<wea:item>
            			<select style="width: 120px;" name="isAnonymous" id="isAnonymous">
            			   <option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
            			   <option value="1" <%=isAnonymous.equals("1")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(82677,user.getLanguage())%></option>
            			   <option value="0" <%=isAnonymous.equals("0")?"selected=selected":""%>><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
            			</select>      
            		</wea:item>
            	</wea:group>
            	
            	<wea:group context="" attributes="{'Display':'none'}">
            		<wea:item type="toolbar">
            			<input type="submit" class="e8_btn_submit" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" id="searchBtn"/>
            			<span class="e8_sep_line">|</span>
            			<input type="button" name="reset" onclick="resetCondtion()" value="<%=SystemEnv.getHtmlLabelName(2022 ,user.getLanguage()) %>" class="e8_btn_cancel"/>
            			<span class="e8_sep_line">|</span>
            			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
            		</wea:item>
            	</wea:group>
            </wea:layout>
        </form>	
    </div>
    <input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Cowork_TypeList%>">
    <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
    
    <script>
        var diag ;
        function callback(){
        	if(diag){
        		diag.close();
        	}
        	_table.reLoad();
        	//parent.parent.refreshTree();
        }
        
        function doSearch(){
        	jQuery("#mainfrom").submit();
        }
        
        function newCoworkType(){
        	diag=getCoworkDialog("<%=SystemEnv.getHtmlLabelNames("82,83209",user.getLanguage()) %>",400,280);
        	diag.URL = "/cowork/type/CoworkTypeAdd.jsp";
        	diag.show();
        	document.body.click();
        } 
        
        function editCoworkType(id){
        	diag=getCoworkDialog("<%=SystemEnv.getHtmlLabelNames("83209,68",user.getLanguage()) %>",400,280);
        	diag.URL = "/cowork/type/CoworkTypeEdit.jsp?id="+id;
        	diag.show();
        	document.body.click();
        }
        
        function delCoworkType(id){
        	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>",function(){
        		$.post("TypeOperation.jsp?operation=delete&ids="+id,{},function(){
        			 _table.reLoad();
        			 //parent.parent.refreshTree();	
        		 })
        	});
        }
         
        function batchDelete(){
        	var ids = _xtable_CheckedCheckboxId();
        	
        	if("" == ids){
        		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22000,user.getLanguage())%>");
        		return;
        	}
        	ids = ids.substring(0 ,ids.length - 1);
        	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage()) %>",function(){
        		$.post("TypeOperation.jsp?operation=delete&ids="+ids,{},function(){
        			_table.reLoad();
        			//parent.parent.refreshTree();	
        		});
        	});
        
        }
        
        function showShareEdit(id,settype){
            var title="<%=SystemEnv.getHtmlLabelNames("17694,68",user.getLanguage())%>:";
            title+=settype=="manager"?"<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage())%>":"<%=SystemEnv.getHtmlLabelName(271,user.getLanguage())%>";
        	diag=getCoworkDialog(title,600,500);
        	diag.URL = "/cowork/type/CoworkTypeShareEditFrame.jsp?cotypeid="+id+"&settype="+settype;
        	diag.show();
        	document.body.click();
        } 
         
         function getCoworkDialog(title,width,height){
            diag =new window.top.Dialog();
            diag.currentWindow = window; 
            diag.Modal = true;
            diag.Drag=true;
        	diag.Width =width?width:680;
        	diag.Height =height?height:420;
        	diag.ShowButtonRow=false;
        	diag.Title = title;
        	diag.Left=($(window.top).width()-235-width)/2+235;
        	return diag;
        }
        
        $(document).ready(function(){
        	jQuery("#topTitle").topMenuTitle({searchFn:searchTypeName});
        	jQuery("#hoverBtnSpan").hoverBtn();
        });
         
        function searchTypeName(){
        	var searchtypename = jQuery("#searchtypename").val();
        	window.mainfrom.action = "/cowork/type/CoworkTypeChild.jsp?typename="+searchtypename;
        	window.mainfrom.submit();
        } 
        </script>
    </body>
</html>
