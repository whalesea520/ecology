
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.docs.category.CategoryUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ page import="weaver.Constants" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="MainCCI" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="SecCCI" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="SubCCI" class="weaver.docs.category.SubCategoryComInfo" scope="page" />

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%
if(!HrmUserVarify.checkUserRight("WorktaskManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>

<script language=javascript src="/js/weaver_wev8.js"></script>

<html>
<%
	String message = "";
	int error = Util.getIntValue(request.getParameter("error"), 0); 
	int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
	//System.out.println("wtid============="+wtid);
	if(error == 1){
		message = SystemEnv.getHtmlLabelName(21943, user.getLanguage());
	}else if(error == 2){
		message = SystemEnv.getHtmlLabelName(22213, user.getLanguage());
	}
	int canDel = 0;//0，能删除；1，系统级，不可删除；2，被引用，不可删除
	int orderid = 0;
	String name = "";
	int isvalid = 1;
	int autotoplan = 0;
	int workplantypeid = 0;
	int annexmaincategory = 0;
	int annexsubcategory = 0;
	int annexseccategory = 0;
	int issystem = 0;
	if(wtid != 0){
		rs.execute("select * from worktask_base where id="+wtid);
		if(rs.next()){
			name = Util.null2String(rs.getString("name"));
			orderid = Util.getIntValue(rs.getString("orderid"), 0);
			isvalid = Util.getIntValue(rs.getString("isvalid"), 0);
			autotoplan = Util.getIntValue(rs.getString("autotoplan"), 0);
			workplantypeid = Util.getIntValue(rs.getString("workplantypeid"), 0);
			annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
			annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
			annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
			issystem = Util.getIntValue(rs.getString("issystem"), 0);
		}
		if(issystem == 0){//判断该类型的计划任务是否被引用过
			rs.execute("select requestid from worktask_requestbase where taskid="+wtid);
			if(rs.next()){
				canDel = 2;
			}
		}else{
			canDel = 1;
		}
	}
	String displayStr = "";
	if(autotoplan != 1){
		displayStr = " none ";
	}
	String annexdocPath = "";
	String annexdocPathValue="";
	if(annexseccategory!=0){
		annexdocPathValue=annexmaincategory+","+annexsubcategory+","+annexseccategory;
		annexdocPath = SecCCI.getAllParentName(""+annexseccategory,true);
	}

%>

<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>

</head>

<body>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(wtid == 0){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    //RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:history.back(-1),_self} " ;
    //RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveData(this),_self} " ;    
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(21930, user.getLanguage())+",javascript:newworktask(),_self}" ;
	RCMenuHeight += RCMenuHeightStep;
	if(canDel == 0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:doDel(),_self}" ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="<%=wtid == 0?"submitData(this)":"saveData(this)" %>" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="weaver" id="weaver" method="post" action="wt_Operation.jsp">
<input type="hidden" name="src" value="" >
<input type="hidden" name="wtid" value="<%=wtid%>" >
<input type="hidden" id="annexmaincategory" name="annexmaincategory" value="<%=annexmaincategory%>">
<input type="hidden" id="annexsubcategory" name="annexsubcategory" value="<%=annexsubcategory%>">
<input type="hidden" id="annexseccategory" name="annexseccategory" value="<%=annexseccategory%>">


 <wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
	      <wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
 
	         <wea:item><%=SystemEnv.getHtmlLabelName(15795, user.getLanguage())%></wea:item>
	         <wea:item>
	              <wea:required id="nameimage" required="true">
	                 <input class=inputstyle type="text"  style="width: 300px"  name="name" size="40" onchange='checkinput("name","nameimage")'  maxlength="25" value="<%=Util.forHtml(name)%>">
			      </wea:required>
	         </wea:item>
 
	         <wea:item><%=SystemEnv.getHtmlLabelName(18624, user.getLanguage())%></wea:item>
	         <wea:item>
	              <INPUT type="checkbox" name="isvalid" value="1" <%if(isvalid == 1){%>checked<%}%> >
	         </wea:item>
 
	        <wea:item><%=SystemEnv.getHtmlLabelName(22001,user.getLanguage())%></wea:item>
          	<wea:item>
          		<INPUT type="checkbox" name="autotoplan" onclick="changeAutotoplan(this);" value="1" <%if(autotoplan == 1){%>checked<%}%> >
          		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          		<span id="workplantypeidspan"  style="display:<%=autotoplan == 1?"":"none"%>;" >
	          		<SELECT name="workplantypeid" id="workplantypeid" style="width: 120px">
							<%
								rs.execute("SELECT * FROM WorkPlanType " + Constants.WorkPlan_Type_Query_By_Menu);
								while(rs.next()){
									int workplantypeid_tmp = Util.getIntValue(rs.getString("workPlanTypeID"), 0);
									String workplantypename_tmp = Util.null2String(rs.getString("workPlanTypeName"));
									String selectStr = "";
									if(workplantypeid == workplantypeid_tmp){
										selectStr = " selected ";
									}
									out.println("<OPTION value=\""+workplantypeid_tmp+"\" "+selectStr+">"+workplantypename_tmp+"</OPTION>");
								}
							%>
					 </SELECT>
				</span>
            </wea:item>
 
	  
          
 
	         <wea:item><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	    <input class=Inputstyle type="text" style="width: 200px" name="orderid" size="6" onchange="checkint('orderid')" maxlength="2" value="<%=orderid%>" >
	    	 </wea:item>
	      
 
	         <wea:item><%=SystemEnv.getHtmlLabelName(22210, user.getLanguage())%></wea:item>
	    	 <wea:item>
	    	     <span>
			      <brow:browser viewType="0" name="pathbrowser"
					browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp"
					hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1' _callback="afterBackCatalogData" afterDelCallback="showCalaogAftCallBk"
					completeUrl="/data.jsp?type=categoryBrowser&onlySec=true" 
					browserValue='<%=annexdocPathValue%>' browserSpanValue='<%=annexdocPath %>'  width="50%">
			       </brow:browser> 	
			     </span>
	    	 </wea:item>
	   
	    </wea:group>

	</wea:layout>

</form>

<script language=javascript>


jQuery(document).ready(function(){

    checkinput("name","nameimage");
});

function doDel(){
	
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(21939,user.getLanguage())%>',function(){
	    weaver.src.value="delwt";
		weaver.submit();
		enableAllmenu();
	});
}
function submitData(obj){
	if (check_form(weaver, 'name')){
		weaver.src.value="addwt";
		weaver.submit();
		enableAllmenu();
	}
}
function saveData(obj){
	if (check_form(weaver, 'name')){
		weaver.src.value="editwt";
		if(weaver.pathbrowser.value == ""){
		     jQuery("#annexmaincategory").val("");
			jQuery("#annexsubcategory").val("");
			jQuery("#annexseccategory").val("");
		}
		weaver.submit();
		enableAllmenu();
	}
}
function ItemCount_KeyPress_self(){
	if(!((window.event.keyCode>=48) && (window.event.keyCode<=57))){
		window.event.keyCode=0;
	}
}

userCallBack(_event,datas,fieldid,params,_target)

function afterBackCatalogData(event,datas,name){
	if (datas) {
        if (datas.tag>0)  {
        	jQuery("#pathbrowserspan").html("<a href='#"+datas.id+"'>" + datas.path + "</a>&nbsp;" );
           	jQuery("#annexmaincategory").val(datas.mainid);
			jQuery("#annexsubcategory").val(datas.subid);
			jQuery("#annexseccategory").val(datas.id);
        }else{
        	if(datas.id!=''&&datas.name!=''){
        		var mainid="-1";
        		var subid="-1";
        		var secid="-1";
        		if(datas.id.indexOf(",")>-1){
        			ids =datas.id.split(",");
        			if(ids.length==3){
        				mainid=ids[0];
        				subid=ids[1];
        				secid=ids[2];
        			};
        		}else{
        			secid=datas.id;
        			if(datas.subid){
        				subid=datas.subid;
        			}
        			if(datas.mainid){
        				mainid=datas.mainid;
        			}
        		}
        		jQuery("#annexmaincategory").val(mainid);
				jQuery("#annexsubcategory").val(subid);
				jQuery("#annexseccategory").val(secid);
        	}else{
	            jQuery("#annexmaincategory").val("");
				jQuery("#annexsubcategory").val("");
				jQuery("#annexseccategory").val("");
        	}
           	
        }
    }
}

function showCalaogAftCallBk(datas,name,ismand){
	jQuery("#"+name).val("");
}

function newworktask(){
	parent.location.href = "worktaskAdd.jsp?isnew=1";
}
function onShowAnnexCatalog(spanName) {
	//tag:"1",id:""+id, path:""+path, mainid:""+mainid, subid:""+subid,path2:""+parth2
	var result = showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp");
	if (result != null) {
		if (result.tag > 0)  {
			jQuery(spanName).html(result.path);
			jQuery("#annexmaincategory").val(result.mainid);
			jQuery("#annexsubcategory").val(result.subid);
			jQuery("#annexseccategory").val(result.id);
		}else{
			jQuery(spanName).html("");
			jQuery("#annexmaincategory").val("");
			jQuery("#annexsubcategory").val("");
			jQuery("#annexseccategory").val("");
		}
	}
}
function changeAutotoplan(obj){
	var playType = "";
	if(obj.checked == false){
		playType = "none";
	}
	workplantypeidspan.style.display = playType;
	//alert();
}
</script>
</body>
</html>
