
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.systemright.CheckSubCompanyRight" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String id =Util.null2String(request.getParameter("id"));	
String menutype= Util.null2String(request.getParameter("menutype"));
String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93,user.getLanguage());//新建: 编辑 
String needfav ="1";
String needhelp ="";
String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址
String menuaddress = Util.null2String((String)session.getAttribute(user.getUID()+"_"+menuflag+"_menuaddress"));//表单建模新增菜单地址
//out.println(menuaddress);

boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  
boolean hasRight = false;
if(HeadMenuhasRight || SubMenuRight)
	hasRight = true;
/*CheckSubCompanyRight cscr=new CheckSubCompanyRight();
int opreateLevel=cscr.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",Util.getIntValue(subCompanyId));
hasRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);
/*if(user.getUID()==1||opreateLevel>0){
	hasRight = true;
}*/
if(!hasRight){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%  
   	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_self} " ;//保存
   	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDel(),_self} " ;//删除
   	RCMenuHeight += RCMenuHeightStep ;
	
%>

<%
boolean isUsed =false; // 该菜单是否被使用
rs.execute("select id from hpelementsetting where name = 'menuIds' and value='"+id+"'");
if(rs.next()){
	isUsed = true;
}
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<html>
  <head>
    <link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/jquery/jquery_wev8.js"></script>
	<SCRIPT type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>
  </head>
<body>
	<TABLE width=100% height=100% border="0" cellspacing="0">
    <colgroup>
    <col width="10">
    <col width="">
    <col width="10">
    <tr>
      <td height="10" colspan="3"></td>
    </tr>
    <tr>
        <td></td>
        <td valign="top">
       		<%
				rs.executeSql("select * from menucenter where id='"+id+"'");
				rs.next();
				String menuname=rs.getString("menuname");
			%>
			<form method="post" action="MenuOperate.jsp" name="frmEdit">
			<input type="hidden" name="method" id="method" value="edit">
			<input type="hidden" name="menuid" value="<%=id%>">
			<input type="hidden" name="subCompanyId" value="<%=subCompanyId %>">
			<input type="hidden" name="isUsed" id="isUsed" value="<%=isUsed %>">
			<textarea id='txtNodes' name='txtNodes' style="width:100%;height:300px;display:none"></textarea>
			<input type="hidden" name="menutype" value="<%=menutype %>" >
			
			<table class="Shadow">
				<colgroup>
					<col width="1">
					<col width="">
					<col width="10">
				</colgroup>
				<tr>
					<TD></td>		
					<td valign="top">
					
						<table class="viewForm" style="width: 100%;"> 							
							<tr>
								<td width="50px"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题--></td>
								<td  class="field">
									<input type="text" class="inputstyle" name="menuname" id="menuname"  value="<%=rs.getString("menuname")%>" onChange="checkinput('menuname','menunameSpan')">
									<span id=menunameSpan name=menunameSpan></span>
									<span id="checkTitleName" style="color: red;display: none;">(<%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(24943,user.getLanguage())%>)</span><!-- 标题已经存在 -->
								</td>
							</tr>
							<tr style="height:1px;"><td class="line" colspan=2></td></tr>
							<tr>
								<td><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%><!--描述--></td>
								<td class="field"><input  type="text"  style="width:50%"  value="<%=rs.getString("menudesc")%>" class="inputstyle" name="menudesc"></td>
							</tr>		
							<tr style="height:1px;"><td class="line" colspan=2></td></tr>					
							<tr>
								<td valign="top">
									<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%><!--内容-->
								</td>
								<td>
									<div id="divTree" style="height:600px;;width:50%"></div>
								</td>
							</tr>
							<tr style="height:1px;"><td class="line" colspan=2></td></tr>
							

						</table>						
					</td>
					<td></td>		
				</tr>			
			</table>
			</form>
	    </td>
		<td></td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
</TABLE>

<div id='divNode' style='display:none'>
	<form id="frmInfo" name='frmInfo'>
	<input type="hidden" name="type" value="<%=id%>">
	<table class="viewForm" style="padding:10px;width: 100%;" > 							
		<tr>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%><!--标题--></td>
			<td width="80%" class="field">
				<input type="text" id="name" name="name"  class='inputstyle' value="" style="width:90%;" onChange="checkinput('name','nameSpan')">
				<span id=nameSpan name=nameSpan>
					<IMG src='/images/BacoError_wev8.gif' align=absMiddle>
				</span>
			</td>
		</tr>
		<tr style="height:1px;"><td class="line" colspan=2></td></tr>			
		
		<input type="hidden" id="icon"  name="icon" class='inputstyle' value="/js/extjs/resources/images/default/tree/leaf_wev8.gif" style="width:90%;" onChange="checkinput('icon','iconSpan')">
		<tr>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%><!--链接--></td>
			<td width="80%"  class="field">
				<input type="text" id="href" name="href" class='inputstyle' value="" style="width:78%;" onChange="checkinput('href','hrefSpan')">
				<button type="button"   class=Browser onclick="onShowLoginPages('href','hrefSpan','')"></BUTTON>
				<span id=hrefSpan name=hrefSpan></span>
			</td>
		</tr>
		<tr style="height:1px;"><td class="line" colspan=2></td></tr>	
		<tr>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(20235,user.getLanguage())%><!--位置--></td>
			<td width="80%"  class="field">
				<select name="target"  id="target">
					<option value='mainFrame'><%=SystemEnv.getHtmlLabelName(20597,user.getLanguage())%><!--默认窗口--></option>
					<option value='_blank'><%=SystemEnv.getHtmlLabelName(18717,user.getLanguage())%><!--弹出窗口--></option>
					<option value='_parent'><%=SystemEnv.getHtmlLabelName(25491,user.getLanguage())%><!--父窗口--></option>
				</select>
			</td>
		</tr>

		<tr style='display:none;height:1px;'><td class="line" colspan=2></td></tr>	
		<tr style='display:none'>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(60,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%><!--维护权限--></td>
			<td width="80%"  class="field">
				<button type="button"  class=Browser style="display:''"  onClick="onShowResource('menurightvalueid','menurightvalue')" name=showresource></BUTTON>
				<INPUT type=hidden name=menurightvalueid  id="menurightvalueid" value="">
                <span id=menurightvalue name=menurightvalue></span>                        
				
			</td>
		</tr>
		
		<%if("2".equals(menutype)){ %>
		<tr style="height:1px;"><td class="line" colspan=2></td></tr>	
		<tr>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(18932,user.getLanguage())%><!--查看权限--></td>
			<td width="80%"  class="field">
			  	<SELECT class=InputStyle  name=sharetype id="sharetype" onchange="onChangeSharetype(this,sharevalue,sharetext)" >   
	                     <option value="1" ><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
	                     <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
	                     <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
	                     <option value="6"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
	                     <option value="7"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></option><!-- 安全级别 -->
	                     <option value="5" selected><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%></option><!-- 所有人 -->
	                 </SELECT>
	                 &nbsp;&nbsp;
					<button type="button"  class=Browser id="btnHrm" style="display:''" onClick="onShowResource('sharevalue','sharetext')" name="btnHrm"></BUTTON> 
					<button type="button"  class=Browser id="btnSubcompany" style="display:none"  onClick="onShowSubcompany('sharevalue','sharetext')" name="btnSubcompany"></BUTTON> 
					<button type="button"  class=Browser id="btnDepartment" style="display:none"  onClick="onShowDepartment('sharevalue','sharetext')" name="btnDepartment"></BUTTON>
					<button type="button"  class=Browser id="btnRole" style="display:none"  onClick="onShowRole('sharevalue','sharetext')" name="btnDepartment"></BUTTON>
					
					<INPUT type=hidden name=sharevalue  id="sharevalue" value="">
	                <span id=sharetext name=sharetext></span>   
	                </td>
		</tr>
		<tr style="display:none;height:1px;" ><td class="line" colspan=2></td></tr>
		<tr id='roletype_tr' style='display:none'>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td><!-- 角色级别 -->
			<td width="80%" class="field">
				<SELECT class=InputStyle  name=roletype id="roletype">
					<option value='2'><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
					<option value='1'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
					<option selected value='0'><%=SystemEnv.getHtmlLabelName(18939,user.getLanguage())%></option><!-- 部门 -->
				</SELECT>
			</td>
		</tr>
		<tr style='display:none;height:1px'><td class="line" colspan=2></td></tr>
		<tr id='securitylevel_tr' style='display:none'>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><!-- 安全级别 -->
			<td width="80%" class="field">
			<select class="InputStyle" name="operate" id="operate">
				<option value="0">>=</option>
				<option value="1"><=</option>
			</select>
			<input id='securitylevel' name='securitylevel' type='text' size='3' class='inputstyle' value='10' onChange='checkinput("securitylevel","securitylevelspan")'>
			 	<span id=securitylevelspan name=securitylevelspan >
					
				</span>
			 </td>
		</tr>
		<tr style="height:1px;"><td class="line" colspan=2></td></tr>
		<tr>
			<td width="20%"></td>
			<td width="80%" class="field">
			<a href="javascript:addPurview()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%><!-- 添加 --></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:removePurview()"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><!-- 删除 --></a>
			</td>
		</tr>
		<tr style="height:1px;"><td class="line" colspan=2></td></tr>
		
		<tr id='purviewList'>
			<td width="20%"><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(320,user.getLanguage())%></td><!-- 权限列表 -->
			<td width="80%" class="field">
			<table id="purviewContent" maxid=0>
			</table>
			</td>
		</tr>
		<%} %>
		<tr style="height:1px;"><td class="line" colspan=2></td></tr>
		
	</table>
	</form>
</div>

<%@ include file="/docs/docs/DocCommExt.jsp"%>

<SCRIPT LANGUAGE="JavaScript">
<!--
	var root;
	
	//添加一条权限
	function addPurview(){
		if($("#securitylevel").is(":hidden")){
			if(!check_form(document.frmInfo,'name,sharevalue')){
				return;
			}
		}else{
			if(!check_form(document.frmInfo,'name,sharevalue,securitylevel')){
				return;
			}
		}
		var valueString = getShareValueString();
		$("#purviewContent").append(valueString);
		
	}
	
	//删除所选权限
	function removePurview(){
		$(":checkbox[checked=true]").each(function(){
			$("#tr_"+this.id).remove();
		});
		
	}
	
	function getShareText(){
		var sharetext="";
		$(":checkbox").each(function(){
			sharetext+=$("#tr_"+this.id+" td:last-child").html()+"$"
		});
		
		if(sharetext!=""){
			sharetext = sharetext.substring(0,sharetext.length-1);
		}else{
			sharetext = $("#sharetype option[value=5]").text();
		}
		
		return sharetext;
	}
	
	function getShareValueString(){
		
		var sharetype=$("#sharetype").val();
		var maxid = $("#purviewContent").attr("maxid");
		maxid++;
		$("#purviewContent").attr("maxid",maxid)
		
		var sharevalue;
		var sharevalueString;
		switch(parseInt(sharetype)){
			case 1:
				sharevalue=$("#sharevalue").val();
				sharevalueString="<td>"+$("#sharetype option:selected").text()+"</td><td width=10></td><td>"+$("#sharetext").html()+"</td>"
				break;
			case 2:
				sharevalue=$("#sharevalue").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString="<td>"+$("#sharetype option:selected").text()+"+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+$("#sharetext").html()+""+"+"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
			case 3:
				sharevalue=$("#sharevalue").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString="<td>"+$("#sharetype option:selected").text()+"+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+$("#sharetext").html()+""+"+"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
			case 5:
				sharevalue=1;
				sharevalueString="<td>"+$("#sharetype option:selected").text()+"</td><td width=10></td><td>"+$("#sharetype option:selected").text()+"</td>";
				break;
			case 6:
				sharevalue=$("#sharevalue").val()+"_"+$("#roletype").val()+"_"+$("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString="<td>"+$("#sharetype option:selected").text()+"+<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+$("#sharetext").html()+"+"+$("#roletype option:selected").text()+"+"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
			case 7:
				sharevalue =  $("#operate").val()+"_"+$("#securitylevel").val()
				sharevalueString = "<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+$("#operate option:selected").text()+$("#securitylevel").val()+"</td>";
				break;
		}
		
		sharevalueString = "<tr id='tr_"+maxid+"' sharetype="+sharetype+" sharevalue='"+sharevalue+"'><td><input type=checkbox id="+maxid+"></td>"+sharevalueString+"</tr>";
	
		return sharevalueString;
	}
	
	
	function showShareValueList(sharetype,sharevalue,sharetext){
		//alert(sharevalue)
		$("#purviewContent").empty();
		showShareButton(5,1);
		$("#sharetext").html("");
		var valueList = sharevalue.split("$");
		var textList = sharetext.split("$");
		var typeList = sharetype.split("$");
		var shareValueString="";
		for(i=0; i<valueList.length;i++){
			var tmpList = valueList[i].split("_");
			shareValueString="";
			switch(parseInt(typeList[i])){
				case 1:
					shareValueString="<td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"</td><td width=10></td><td>"+textList[i]+"</td>";
					break;
				case 2:
					shareValueString="<td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+textList[i]+"+"+$("#operate option[value="+tmpList[tmpList.length-2]+"]").text()+tmpList[tmpList.length-1]+"</td>";
					break;
				case 3:
					shareValueString="<td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+textList[i]+"+"+$("#operate option[value="+tmpList[tmpList.length-2]+"]").text()+tmpList[tmpList.length-1]+"</td>";
					break;
				case 5:
					shareValueString="<td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"</td><td width=10></td><td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"</td>";
					break;
				case 6:
					shareValueString="<td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"+<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>+<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td width=10></td><td>"+textList[i]+"+"+$("#roletype option[value="+tmpList[1]+"]").text()+"+"+$("#operate option[value="+tmpList[tmpList.length-2]+"]").text()+tmpList[tmpList.length-1]+"</td>";
					break;
				case 7:
					shareValueString="<td>"+$("#sharetype option[value="+typeList[i]+"]").text()+"</td><td width=10></td><td>"+$("#operate option[value="+tmpList[0]+"]").text()+tmpList[1]+"</td>";
					break;
			}
			shareValueString = "<tr id='tr_"+i+"' sharetype="+typeList[i]+" sharevalue='"+valueList[i]+"'><td><input type=checkbox id="+i+"></td>"+shareValueString+"</tr>";
			$("#purviewContent").append(shareValueString);
		}
		$("#purviewContent").attr("maxid",valueList.length);
	}
	
	function genrateSubNode(node){
		//alert(node.childNodes.length)
		//var nodeList=node.childNodes;
		//for (i in nodeList){ 
		//	var n=nodeList[i];
		//alert("node.childNodes:"+node.childNodes.length)
		$.each(node.childNodes,function(i,n){
			var s=n.text;	
			//alert(s)
			s=s.replace(new RegExp("<font id='fontmenuname_.*?'>", 'g'),'')
			s=s.replace(new RegExp("</font>$", 'g'),'')
			var menusharevalue="";
			
			var sql="{id:'"+n.attributes.id+"',name:'"+s+"',menuicon:'"+n.attributes.icon+"',menuhref:'"+n.attributes.href+"',menutarget:'"+n.attributes.target+"',menuparentid:'"+n.parentNode.attributes.id+"',menurighttype:'0',menurightvalue:'"+n.attributes.rightvalue+"',sharevalue:'"+n.attributes.sharevalue+"',sharetype:'"+n.attributes.sharetype+"'}";
			$("#txtNodes").val($("#txtNodes").val()+","+sql)			
			
			genrateSubNode(n);
			
		})
	}
	function onSave(obj){		
		if(check_form(document.frmEdit,'menuname')){
		    var menuname=$("#menuname").val();
		    if(menuname!="<%=menuname%>"){
		       //验证标题是否存在
		       $.post("MenuOperate.jsp?menuflag=<%=menuflag%>&method=checkMenuName&subCompanyId=<%=subCompanyId %>&menutype=<%=menutype%>&menuname="+menuname,{},function(data){
			     if($.trim(data)=="false"){ //不存在
			        saveMenu(obj);
			        $("#checkTitleName").hide();
			     }
			     else
				    $("#checkTitleName").show();
		       });
		    }else
		         saveMenu(obj);
		}
	}

    function saveMenu(obj){
            root.getOwnerTree().expandAll();
			genrateSubNode(root);
			
			var value= $("#txtNodes").val();
			if(value!="") value=value.substring(1);
			//alert(value)
			$("#txtNodes").val("["+value+"]");
			if(obj){
				obj.disabled=true;
			}
			frmEdit.submit();
    }

	function onDel(){	
		if(isdel()){
			if($("#isUsed").val()=="true"){
				alert("<%=SystemEnv.getHtmlLabelName(22688,user.getLanguage())%>");//已经被引用，无法删除
				return;
			}
			$("#method").val("del");
			frmEdit.submit();		
		}	
		
	}
	
	function onGoBack(){
	    if(confirm("<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%>？"))//确定返回？
		  parent.location.href="/formmode/menu/MenuCenter.jsp?menuflag=<%=menuflag%>&menutype=<%=menutype%>&subCompanyId=<%=subCompanyId%>"
	}
	var win;
	Ext.onReady(function(){
		
		var Tree = Ext.tree;
		var sm= new Ext.tree.DefaultSelectionModel({handleMouseDown: Ext.emptyFn});
		var tree = new Tree.TreePanel({
			el:'divTree',
			
			autoScroll:false,
			animate:false,
			//rootVisible:false,
			containerScroll: true, 
			enableDD:true,
			selModel:sm,
			loader: new Tree.TreeLoader({
				dataUrl:'MenuTreeGet.jsp?menuflag=<%=menuflag%>&typeid=<%=id%>&userid=<%=user.getUID()%>&subCompanyId=<%=subCompanyId%>&hasRight=<%=hasRight%>'
			})
		});

		tree.on('contextmenu', onContextShow, this);  

		// set the root node
		root = new Tree.AsyncTreeNode({			
			text: '<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>',//内容
			draggable:<%=hasRight%>,
			allowDrop:<%=hasRight%>,
			allowDrag:<%=hasRight%>,
			allowChildren:<%=hasRight%>,
			hasright:<%=hasRight%>,
			id:'-1'
		});
		tree.setRootNode(root);

		// render the tree
		tree.render();
		//root.expand();
		tree.expandAll();

		Ext.get('loading').fadeOut();

		 var nodeAddIndex=0;
		 var nodeOpType="add";
		 var win = new Ext.Window({
				layout: 'fit',
				width: 500,
				autoHeight: true,
				closeAction: 'hide',
				plain: true,
				shadow:false,
				autoScroll:true,
				modal: true,
				title:'<%=SystemEnv.getHtmlLabelName(20604,user.getLanguage())%>',//添加子菜单
				items: new Ext.Panel({ 
				   id:'divNode',         
				   autoHeight :true,       
				   contentEl:'divNode'
				}),
				
				buttons: [{
					text: wmsg.base.submit,// '确定',
					handler: function(){  
						if(nodeOpType=="add"){
							if($("#securitylevel").is(":hidden")){
								if(!check_form(document.frmInfo,'name,sharevalue')){
									return;
								}
							}else{
								if(!check_form(document.frmInfo,'name,sharevalue,securitylevel')){
									return;
								}
							}
							cNode.appendChild(new Ext.tree.TreeNode({
								id:'add_'+nodeAddIndex,
								text:"<font id='fontmenuname_add_"+nodeAddIndex+"'>"+$("#name").val()+"</font>",
								draggable:true,
								hasright:true,
								icon:$("#icon").val(),
								leaf:true,
								target:$("#target").val(),
								href:$("#href").val(),
								righttype:'0',
								rightvalue:'',
								righttext:'',
								sharetype:getShareType(),
								sharetext:getShareText(),
								sharevalue:getShareValue()
							}));
							cNode.attributes.icon="/js/extjs/resources/images/default/tree/folder_wev8.gif";
							cNode.expand();
						} else if(nodeOpType=="edit") {
							
							if($("#securitylevel").is(":hidden")){	
								if(!check_form(document.frmInfo,'name,sharevalue')){
									return;
								}
							}else{
								if(!check_form(document.frmInfo,'name,sharevalue,securitylevel')){
									return;
								}
							}
							var tempObj=$("#fontmenuname_"+cNode.attributes.id).parent().parent().parent().children(".x-tree-node-icon");
							var pos=tempObj.attr("src").lastIndexOf("/");
							if($("#icon").val()!=""){
								if(tempObj.attr("src").substring(pos+1)=="s_wev8.gif"){
									tempObj.css("background-image","url('"+$("#icon").val()+"')");
								} else {
									tempObj.attr("src",$("#icon").val());
								}
							}

							cNode.setText("<font id='fontmenuname_"+cNode.attributes.id+"'>"+$("#name").val()+"</font>"),
							cNode.attributes.icon=$("#icon").val();
							cNode.attributes.target=$("#target").val();
							cNode.attributes.href=$("#href").val();
							cNode.attributes.rightvalue=$("#menurightvalueid").val()
							cNode.attributes.righttext=$("#menurightvalue").html();
							cNode.attributes.sharetype=getShareType();
							cNode.attributes.sharetext=getShareText();
							cNode.attributes.sharevalue=getShareValue();
							
						}
						win.hide();
					}
				}, {
					text: wmsg.base.cancel,// '取消',
					handler: function(){
						win.hide();
					}
				}]
			});

	/**
	*获取菜单共享信息
	*/
	function getShareValue(){
		//var sharetype=$("#sharetype").val();
		var sharevalue="";
		/*switch(parseInt(sharetype)){
			case 1:
				sharevalue=$("#sharevalue").val();
				break;
			case 2:
				sharevalue=$("#sharevalue").val()+"_"+$("#securitylevel").val()
				break;
			case 3:
				sharevalue=$("#sharevalue").val()+"_"+$("#securitylevel").val()
				break;
			case 5:
				sharevalue=1;
				break;
			case 6:
				sharevalue=$("#sharevalue").val()+"_"+$("#roletype").val()+"_"+$("#securitylevel").val()
				break;
			case 7:
				sharevalue =  $("#securitylevel").val()
				break;
		}*/
		$(":checkbox").each(function(){
			sharevalue+=$("#tr_"+this.id).attr("sharevalue")+"$"
		})
		if(sharevalue!=""){
			sharevalue = sharevalue.substring(0,sharevalue.length-1);
		}else{
			sharevalue = "1";
		}
		return sharevalue;
	}
	
	function getShareType(){
		var sharetype="";
		$(":checkbox").each(function(){
			sharetype+=$("#tr_"+this.id).attr("sharetype")+"$"
		})
		if(sharetype!=""){
			sharetype = sharetype.substring(0,sharetype.length-1);
		}else{
			sharetype = "5"
		}
		return sharetype;
	}
	

	function onAddNode() {  
			$("#divNode").css("display","inline");
			$("#nameSpan").html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			nodeAddIndex++;
			nodeOpType="add";
			$("#name").val("");
			//$("#icon").val("");
			$("#target").val("mainFrame");
			$("#href").val("<%=menuaddress%>");
			$("#hrefSpan").text("");
			$("#menurightvalueid").val("");
			$("#menurightvalue").val("");
			$("#sharetype").val(5);
			$("#sharevalue").val("1");
			$("#sharevalue").val("1");
			$("#sharetext").html("");
			$("#btnHrm").hide();
			$("#btnSubcompany").hide();
			$("#btnDepartment").hide();
			
			$("#btnRole").hide();
			$("#roletype_tr").hide();
			$("#roletype_tr").prev().hide();
			$("#securitylevel_tr").hide();
			$("#securitylevel_tr").prev().hide();
			$("#roletype").val(0);
			$("#securitylevel").val(10);
			$("#operate").val(0);
			$("#purviewContent").empty();
            win.show(null);
	 }  
   
     // 开始修改项目名称  
     function onUpdateNode() {
		nodeOpType="edit";
		$("#divNode").css("display","inline");
		var s=cNode.attributes.text;
		s=s.replace(new RegExp("<font id='fontmenuname_.*?'>", 'g'),'')
		s=s.replace(new RegExp("</font>$", 'g'),'')
		$("#nameSpan").children().hide();
		$("#name").val(s);
		$("#icon").val(cNode.attributes.icon);
		$("#target").val(cNode.attributes.target);
		$("#href").val(cNode.attributes.href);
		$("#hrefSpan").text("");
		$("#menurightvalueid").val(cNode.attributes.rightvalue);
		$("#menurightvalue").text('');
		$("#menurightvalue").append(cNode.attributes.righttext);
		//$("#sharetext").html(cNode.attributes.sharetext);
		//showShareButton(cNode.attributes.sharetype,cNode.attributes.sharevalue);
		showShareValueList(cNode.attributes.sharetype,cNode.attributes.sharevalue,cNode.attributes.sharetext);
        win.show(null);
     }  
   
     // 删除
     function onDeleteNode() {  		
		
		if(isdel()){
			 cNode.remove();
		}  
	 }
	  // 创建上下文菜单  
	 var ctx;
	 var cNode;
     function createContextMenu(nodeId) {  
   		 if(nodeId=='-1'){
   		 	ctx = new Ext.menu.Menu( {  
             id : 'project-ctx',  
             items : [ {  
						 text : '<%=SystemEnv.getHtmlLabelName(20604,user.getLanguage())%>',  //添加子菜单
						 scope : this,  
						 handler :onAddNode
					 }]  
         	});
   		 }else{
   		 	
   		 	ctx= null;
   		 	ctx = new Ext.menu.Menu( {  
             id : 'project-ctx',  
             items : [ {  
						 text : '<%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%>',  //修改
						 scope : this,  
						 handler :  onUpdateNode    
					 },{  
						 text : '<%=SystemEnv.getHtmlLabelName(20604,user.getLanguage())%>',  //添加子菜单
						 scope : this,  
						 handler :onAddNode
					 }, '-', {  
						 text : '<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>',  //删除
						 scope : this,  
						 handler : onDeleteNode  
					 }]  
         	});
   		 }
           
         ctx.on('hide', onContextHide, this);  
     }  
	  // 右击树节点时  
     function onContextShow(node, e) {
		if(node.attributes.hasright){  	 
			createContextMenu(node.attributes.id);  
			ctx.showAt(e.getXY());
			cNode=node;
			sm.select(node);
		}
		e.stopEvent();
     }  
   
     // 隐藏上下文菜单时  
     function onContextHide(){  
        ctx.destroy();
     }
	});
	

	$(document).ready(function(){
		/*$('#icon').filetree({
				file:this.value,
				call:function(src){
					
				}
			});*/
	});
//-->
function onChangeSharetype(seleObj,txtObj,spanObj){
	var thisvalue=seleObj.value;	
    var strAlert= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	
	if(thisvalue==1){  //人员
 		document.getElementById("btnHrm").style.display='';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide()
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;
		txtObj.value="";		
		spanObj.innerHTML=strAlert;	
	} else if (thisvalue==2)	{ //分部
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==3)	{ //部门
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;	
	}else if (thisvalue==5)	{ //所有人
		document.getElementById("btnHrm").style.display='none';
		document.getElementById("btnSubcompany").style.display='none';
		document.getElementById("btnDepartment").style.display='none';
		$("#btnRole").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").hide();
		$("#securitylevel_tr").prev().hide();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#operate").val(0);
		txtObj.value="1";
		spanObj.innerHTML="";
	}else if (thisvalue==6){
		$("#btnRole").show();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").show();
		$("#roletype_tr").prev().show();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#operate").val(0);
		txtObj.value="";
		spanObj.innerHTML=strAlert;
	}else if (thisvalue==7){
		$("#btnRole").hide();
		$("#btnHrm").hide();
		$("#btnSubcompany").hide();
		$("#btnDepartment").hide();
		$("#roletype_tr").hide();
		$("#roletype_tr").prev().hide();
		$("#securitylevel_tr").show();
		$("#securitylevel_tr").prev().show();
		txtObj.value=$("#securitylevel").val();
		$("#roletype").val(0);
		$("#securitylevel").val(10);
		$("#operate").val(0);
		spanObj.innerHTML="";
	}
	
}



function showShareButton(sharetype,sharevalue){
	
	
	
	
	
	switch(parseInt(sharetype)){
		case 1:
			$("#btnHrm").show();
			$("#btnSubcompany").hide();
			$("#btnDepartment").hide();
			$("#btnRolw").hide();
			$("#sharetype").val(sharetype);
			$("#sharevalue").val(sharevalue);
			$("#roletype_tr").hide();
			$("#roletype_tr").prev().hide();
			$("#securitylevel_tr").hide();
			$("#securitylevel_tr").prev().hide();
			break;
		case 2:
			$("#btnHrm").hide();
			$("#btnSubcompany").show();
			$("#btnDepartment").hide();
			$("#btnRole").hide();
			$("#sharetype").val(sharetype);
			var temp = new Array(); temp = sharevalue.split("_");
			$("#sharevalue").val(temp[0]);
			$("#securitylevel").val(temp[1]);
			$("#securitylevel_tr").show();
			$("#roletype_tr").hide();
			$("#roletype_tr").prev().hide();
		
			break;
		case 3:
			
			$("#btnHrm").hide();
			$("#btnSubcompany").hide();
			$("#btnDepartment").show();
			$("#btnRole").hide();
			$("#sharetype").val(sharetype);
			
			var temp = new Array(); temp = sharevalue.split("_");
			$("#sharevalue").val(temp[0]);
			$("#securitylevel").val(temp[1]);
			$("#securitylevel_tr").show();
			$("#roletype_tr").hide();
			$("#roletype_tr").prev().hide();
			break;
		case 5:
			$("#btnHrm").hide();
			$("#btnSubcompany").hide();
			$("#btnDepartment").hide();
			$("#btnRole").hide();
			$("#sharetype").val(sharetype);
			$("#sharevalue").val(sharevalue);
			$("#roletype_tr").hide();
			$("#roletype_tr").prev().hide();
			$("#securitylevel_tr").hide();
			$("#securitylevel_tr").prev().hide();
			
			break;
		case 7:
			$("#btnHrm").hide();
			$("#btnSubcompany").hide();
			$("#btnDepartment").hide();
			$("#btnRole").hide();
			$("#sharetype").val(sharetype);
			$("#sharevalue").val(sharevalue);
			$("#securitylevel").val(sharevalue);
			$("#securitylevel_tr").show();
			$("#roletype_tr").hide();
			$("#roletype_tr").prev().hide();
			$("#securitylevel_tr").show();
			$("#securitylevel_tr").prev().show();
			break;
		case 6:
			$("#btnHrm").hide();
			$("#btnSubcompany").hide();
			$("#btnDepartment").hide();
			$("#btnRole").show();
		
			$("#sharetype").val(sharetype);
			var temp = new Array(); temp = sharevalue.split("_");
			$("#sharevalue").val(temp[0]);
			$("#roletype").val(temp[1])
			$("#roletype_tr").show();
			$("#roletype_tr").prev().show();
			$("#securitylevel").val(temp[2]);
			$("#securitylevel_tr").show();
			$("#securitylevel_tr").prev().show();
			break;
	}
}

function onShowLoginPages(input,span,eid){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/menu/LoginPageBrowser.jsp?menutype=<%=rs.getString("menutype")%>&menuId=<%=id%>","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if (datas){
		mtype = "<%=rs.getString("menutype")%>"
		if (mtype==1){
			if (datas.id!="") {
				$($G(span)).html("<a href='/homepage/LoginHomepage.jsp?hpid="+datas.name+"' target='_blank'>" + datas.id + "</a>");
				$($G(input)).val("/homepage/LoginHomepage.jsp?hpid="+datas.name);
			}else {
				$($G(span)).html();
				$($G(input)).val();
			}
		}else{
			if (datas.id!="") {
				if(datas.id.length>4){
                    datas.id=datas.id.substring(0,4)+"...";
			    }
				$($G(span)).html("<a href='" + datas.name + "' target='_blank'>" + datas.id + "</a>");
				$($G(input)).val(datas.name);
			}
			else{
				$($G(span)).html();
				$($G(input)).val();
			}
		}
		}
}
</SCRIPT>
<script type="text/javascript">
function onShowSubcompany(inputname,spanname)  {
		linkurl="/hrm/company/HrmSubCompanyDsp.jsp?id=";
	    datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
	    		"","dialogHeight=550px;dialogWidth=550px;");
	   if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
function onShowDepartment(inputname,spanname){
	linkurl="/hrm/company/HrmDepartmentDsp.jsp?id=";
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$("input[name="+inputname+"]").val()+"&selectedDepartmentIds="+$("input[name="+inputname+"]").val(),
			"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	 if (datas) {
	    if (datas.id!= "") {
	        ids = datas.id.split(",");
		    names =datas.name.split(",");
		    sHtml = "";
		    for( var i=0;i<ids.length;i++){
			    if(ids[i]!=""){
			    	sHtml = sHtml+"<a href='"+linkurl+ids[i]+"'  >"+names[i]+"</a>&nbsp";
			    }
		    }
		    $("#"+spanname).html(sHtml);
		    $("input[name="+inputname+"]").val(datas.id);
	    }
	    else	{
    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputname+"]").val("");
	    }
	}
}


function onShowRole(inputename,tdname){
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	
	if (datas){
	    if (datas.id!="") {
		    $("#"+tdname).html(datas.name);
		    $("input[name="+inputename+"]").val(datas.id);
	    }else{
		    	$("#"+tdname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    $("input[name="+inputename+"]").val("");
	    }
	}
}
function onShowResource(inputname,spanname){
	 linkurl="javaScript:openhrm(";
	 var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
		var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
   datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp","","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
  if (datas) {
		    if (datas.id!= "") {
		        ids = datas.id.split(",");
			    names =datas.name.split(",");
			    sHtml = "";
			    for( var i=0;i<ids.length;i++){
				    if(ids[i]!=""){
				    	sHtml = sHtml+"<a href="+linkurl+ids[i]+")  onclick='pointerXY(event);'>"+names[i]+"</a>&nbsp";
				    }
			    }
			    $("#"+spanname).html(sHtml);
			    $("input[name="+inputname+"]").val(datas.id);
		    }
		    else	{
	    	     $("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
			    $("input[name="+inputname+"]").val("");
		    }
		}
}
	jQuery(function(){
		$("#menuname").get(0).focus();
	});
</script>