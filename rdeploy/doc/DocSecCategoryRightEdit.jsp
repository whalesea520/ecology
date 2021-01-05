<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util,weaver.systeminfo.SystemEnv,weaver.docs.docs.CustomFieldManager"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.general.IsGovProj"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.docs.category.security.*"%>
<%@ page import="weaver.docs.category.*"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ page import="weaver.file.Prop"%>
<%@ page import="weaver.docs.docs.ShareManageDocOperation"%>
<jsp:useBean id="SubCategoryComInfo"
	class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo"
	scope="page" />
<HTML>
	<HEAD>
		<%
		//编辑权限验证
		if(!HrmUserVarify.checkUserRight("homepage:Maint", user)){
		    response.sendRedirect("/notice/noright.jsp");
		    return;
		}
		    String isDialog = Util.null2String(request.getParameter("isdialog"));
			String kjfw="<input type='checkbox' name='chkboxall' id='chkboxall' onclick='selectAll(this,1)'/><span style='padding-left:16px;'>"+SystemEnv.getHtmlLabelName(83384, user.getLanguage())+SystemEnv.getHtmlLabelName(19467, user.getLanguage())+"</span>";
			String gxfw="<input type='checkbox' name='chkboxall2' id='chkboxall2' onclick='selectAll(this,2)'/><span style='padding-left:16px;'>"+SystemEnv.getHtmlLabelName(19910,user.getLanguage())+"</span>" ;
		%>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/weaver_wev8.js"></script>
		<script language="javascript"
			src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language="javascript"
			src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script language=javascript
			src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
		<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
		<style>
tr.groupHeadHide {
	height: 40px !important;
}

tr.groupHeadHide td.interval {
	background-color: #e9f2f2 !important;
	color: #667478 !important;
	padding-left: 24px !important;
}

.groupHeadHide span.groupbg {
	display: none;
}

.groupHeadHide span.hideBlockDiv {
	display: none;
}

.addbtn,.addbtn2 {
	background-image: url(/rdeploy/assets/img/doc/add.png) !important;
}

.delbtn,delbtn2 {
	background-image: url(/rdeploy/assets/img/doc/del.png) !important;
}

table.LayoutTable td.field {
	height: 45px !important;
	background-color: #fff !important;
}

tr.items tr:hover td.field,tr.items tr:hover td.fieldName {
	background-color: #fffcf0 !important;
}

tr.items tr:hover td.field div.delbtnSingle {
	display: block;
}

div.intervalDivClass {
	background-color: #e9f2f2 !important;
}

div.delbtnSingle {
	cursor: pointer;
	display: block;
	width: 16px;
	height: 16px;
	display: none;
	right: 20px;
	background-image: url(/rdeploy/assets/img/doc/delbtn.png);
}

div.ckmlxq {
	background-color: #a7c2e0;
	position: fixed;
	width: 100px;
	height: 35px;
	text-align: center;
	vertical-align: middle;
	right: 35px;
	bottom: 60px;
	border-radius: 5px;
	border: 1px solid #a7c2e0;
}

div.ckmlxq a {
	color: #fff !important;
	margin-top: 9px;
	display: inline-block;
}

div.ckmlxq:hover {
	background-color: #7e9ed0;
	border-color: #7e9ed0;
}
</style>
	</head>
	<%
	    int operationcode = MultiAclManager.OPERATION_CREATEDOC;
	    int categorytype = MultiAclManager.CATEGORYTYPE_SEC;
	    String titlename = "";
	    int id = Util.getIntValue(request.getParameter("id"), 0);
	    int messageid = Util.getIntValue(request.getParameter("message"), 0);
	    int errorcode = Util.getIntValue(request.getParameter("errorcode"), 0);
	    //是否可以添加，暂时没有特别用处
	    boolean canAdd = false;
	    boolean hasSecManageRight = false;
	    if (HrmUserVarify.checkUserRight("DocSecCategoryAdd:add", user) || hasSecManageRight) {
	        canAdd = true;
	    }
	%>

	<BODY>
		<div class="zDialog_div_content">
			<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>

			<%
			    if (messageid != 0) {
			%>
			<DIV>
				<font color="#FF0000"><%=SystemEnv.getHtmlNoteName(messageid, user.getLanguage())%></font>
			</DIV>
			<%
			    }
			%>
			<%
			    if (errorcode == 10) {
			%>
			<div>
				<font color="red"><%=SystemEnv.getHtmlLabelName(21999, user.getLanguage())%></font>
			</div>
			<%
			    }
			%>
			<FORM id=weaver name=weaver action="SecCategoryOperation.jsp"
				method=post>
				<input type=hidden name="operation">
				<input type=hidden name="id" value="<%=id%>">
				<input type=hidden name="fromtab" value="1">
				<input type=hidden name="fromSecSet" value="right">
			
				<wea:layout type="3col"
					attributes="{'cw1':'10%','cw2':'85%','cw3':'5%'}">
					<wea:group
						context="<%=kjfw%>"> <!-- 83384 可见19467范围 -->
						<%
						    if (canAdd) {
						%>
						<wea:item type="groupHead">
							<input type=button class="addbtn" onclick="openDialog(3);"
								title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
							<input type=button class="delbtn"
								onclick="onPermissionDelShare();"
								title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
						</wea:item>
						<%
						  //  }
						%>
						<!--创建文档权限设置-->
						<%
						
						
						    String sql = "select * from DirAccessControlList where ((permissiontype=4 and usertype=0 ) or permissiontype=5) and  dirid=" + id + " and dirtype=" + categorytype + " and operationcode=" + operationcode + " order by mainid";
						RecordSet.executeSql(sql);
						            while (RecordSet.next()) {
						                int mainId = RecordSet.getInt("mainid");
						                int permissionType = Util.getIntValue(RecordSet.getString("permissiontype"));
						                int userType = Util.getIntValue(RecordSet.getString("usertype"));
						                int userId = Util.getIntValue(RecordSet.getString("userid"));
						                
						%>
						<wea:item>
							<input type="checkbox" name="chkbox" id="chkbox2<%=mainId%>"
								value="<%=mainId%>" >
						</wea:item>
						<wea:item>
							<%=permissionType == 4 ? SystemEnv.getHtmlLabelName(1340,user.getLanguage()) : ResourceComInfo.getLastname("" + userId)%> <!-- 1340 所有人 -->
						</wea:item>
						<wea:item>
							<%
							    if (canAdd) {
							%>
							<div onclick="onPermissionDelShare(<%=mainId%>)"
								class="delbtnSingle" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div> <!-- 91 删除 -->
							<%
							    }
							%>
						</wea:item>
						<%
						    }
						        }
						%>
					</wea:group>
					<wea:group
						context="<%=gxfw%>"><!-- 19910 共享范围-->
						<%
						    if (canAdd) {
						%>
						<wea:item type="groupHead">
							<input type=button class="addbtn" onclick="openDialog(4);"
								title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage())%>"></input>
							<input type=button class="delbtn" onclick="onDelShare();"
								title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>"></input>
						</wea:item>

						<!--创建文档目录权限设置-->
						<%
						
						    String sql = "select * from DocSecCategoryShare where  seccategoryid=" + id + " and ((operategroup=3 and sharetype in (1,5)) or (operategroup=1 and sharetype in (1,2))) order by isolddate,operategroup";
						            RecordSet.executeSql(sql);
						            while (RecordSet.next()) {
						                int mainId = RecordSet.getInt("id");
						                int shareType = Util.getIntValue(RecordSet.getString("sharetype"));
						                int userId = Util.getIntValue(RecordSet.getString("userid"));
						                int operategroup = Util.getIntValue(RecordSet.getString("operategroup"));
						                String name = "";
						                if (operategroup == 3) {
						                    if (shareType == 5) {
						                        name = SystemEnv.getHtmlLabelName(1340,user.getLanguage()); // 1340:所有人
						                    } else {
						                        name = ResourceComInfo.getLastname("" + userId);
						                    }
						                } else {
						                    if (shareType == 1) {
						                        name = SystemEnv.getHtmlLabelName(15079,user.getLanguage()); //15079:创建人本人
						                    } else {
						                        name = SystemEnv.getHtmlLabelName(18583,user.getLanguage());  // 18583 : 创建人直接上级
						                    }
						                }
						%>
						<wea:item>
							<%
							    if (operategroup == 3) {
							%><input type="checkbox" name="chkbox2" id="chkbox2<%=mainId%>"
								value="<%=mainId%>">
							<%
							    }
							%>
						</wea:item>
						<wea:item><%=name%></wea:item>
						<wea:item>
							<%
							    if (operategroup == 3 && canAdd) {
							%>
							<div onclick="onDelShare(<%=mainId%>)" class="delbtnSingle"
								title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"></div> <!-- 91:删除 -->
							<%
							    }
							%>
						</wea:item>
						<%
						    }}
						%>
					</wea:group>
				</wea:layout>
				

				<SCRIPT language="javaScript">

		var dialog = null;


		function openDialog(type){
			dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.isIframe = false;
			var url = "/rdeploy/doc/AddCategoryPermission.jsp?categoryid=<%=id%>&categorytype=<%=categorytype%>&operationcode=<%=operationcode%>";
			if(type==4){
				url = "/rdeploy/doc/AddCategoryShare.jsp?categoryid=<%=id%>&categorytype=<%=categorytype%>&operationcode=<%=operationcode%>";
			}
			dialog.Title = "<%= SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>";   //83476 添加
			dialog.normalDialog = false;
			dialog.Width = 600;
			dialog.isIframe = false;
			dialog.Height = 180;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.show();
		}


		function selectAll(obj,index){
			var name = "";
			if(index==1){
				name = "chkbox";
			}else if(index==2){
				name="chkbox2";
			}
			if(!jQuery(obj).attr("checked")){
				jQuery("input[name='"+name+"']").each(function(){
					jQuery(this).trigger("checked",false);
				});
			}else{
				jQuery("input[name='"+name+"']").each(function(){
					jQuery(this).trigger("checked",true);
				});
			}
		}
		
   </SCRIPT>
			</form>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>
			<script language="javascript">

function onDelShare(id){
	if(id)
		id = ""+id;
	if(!id){
		var chkbox2 = jQuery("input[name='chkbox2']:checked");
		chkbox2.each(function(){
			if(!id){
				id = jQuery(this).val();
			}else{
				id = id + ","+jQuery(this).val();
			}
		});
	}
	if(!id){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568, user.getLanguage())%>");
		return;
	}
	if(id.match(/,$/)){
		id = id.substring(0,id.length-1);
	}
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435, user.getLanguage())%>",function(){ 
	    document.weaver.action="ShareOperation.jsp?secid=<%=id%>&method=delMShare&shareids="+id;
	    document.weaver.submit();
	});
    
}

function onPermissionDelShare(mainids){
	if(mainids)
		mainids = ""+mainids;
    if(!mainids){
    	var chkbox = jQuery("input[name='chkbox']:checked");
		chkbox.each(function(){
			if(!mainids){
				mainids = jQuery(this).val();
			}else{
				mainids = mainids + ","+jQuery(this).val();
			}
		});
    }
    if(!mainids)
    {
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568, user.getLanguage())%>");  
    	return;
    }
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(33435, user.getLanguage())%>",function(){ 
    	window.location = "/rdeploy/doc/PermissionOperation.jsp?isdialog=<%=isDialog%>&operationcode=<%=operationcode%>&method=delete&mainids="+mainids+"&categoryid=<%=id%>&categorytype=<%=categorytype%>";
    });
}
</script>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle"
							onclick="parentDialog.close();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</BODY>
</HTML>