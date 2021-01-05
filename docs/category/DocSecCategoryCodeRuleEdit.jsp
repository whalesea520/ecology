
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.system.code.*"%>
<%@ page import="weaver.docs.category.security.MultiAclManager" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="scc" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docSearchInit_wev8.js"></script>
<script language=javascript src="/js/ecology8/docs/docExt_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>

<script type="text/javascript">

function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
</script>
<style type="text/css">
	.head{
		background-color:#eef8ff !important;
		padding:0 !important;
		border-right:1px solid #CAE7FC;
		text-align:center;
	}
	.nopadding{
		padding:0 !important;
	}
	tr#TR_doc1 table{
		height:100%;
	}
	table.caedfc{
		border:1px solid #CAE7FC;
		margin-bottom: 10px;
    	margin-left: 3px;
    	margin-top: 10px;
	}
	td.caedfc{
		border-right:1px solid #CAE7FC;
	}
	.e8_line{
		background-color:#CAE7FC !important;
		background-repeat:repeat-x;
		height:1px!important;
	}
</style>
</HEAD>

<%

	String id = Util.null2String(request.getParameter("id"));
	String titlename = "";
%>
<%
	//初始值
	int codeId = 0;
	RecordSet.executeSql("select id from codemain where secCategoryId="+id);
	while(RecordSet.next()){
		codeId = RecordSet.getInt("id");
	}
	if(codeId==0){
		RecordSet.executeSql("insert into codemain(titleImg,titleName,isUse,allowStr,secCategoryId) values('/images/sales_wev8.gif','81536','0','',"+id+")");
		RecordSet.executeSql("select max(id) from codemain where secCategoryId = "+id);
		if(RecordSet.next()){
			codeId = RecordSet.getInt(1);
		}
		if(codeId>0){
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'18807','3','',0)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'19921','4','0',1)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'81537','1','1',2)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'81538','1','1',3)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'81539','1','1',4)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'81540','1','0',5)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'445','1','1',6)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'6076','1','1',7)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'16889','1','1',8)");
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'18811','2','4',9)");
		}

	}else{
		RecordSet.executeSql("select max(id) from codemain where secCategoryId = "+id);
		if(RecordSet.next()){
			codeId = RecordSet.getInt(1);
		}
		RecordSet.executeSql("select 1 from codedetail where codemainid = "+codeId+" and showname="+81540);
		if(!RecordSet.next()){
			RecordSet.executeSql("insert into codedetail(codemainid,showname,showtype,value,codeorder) values("+codeId+",'81540','1','0',5)");
		}
	}
	
	CodeBuild cbuild = new CodeBuild(codeId); 
	CoderBean cbean = cbuild.getCBuild();

	ArrayList coderMemberList = cbean.getMemberList();
	ArrayList coderMemberList2 = cbean.getMemberList2();
	String titleImg = cbean.getImage();
	String titleName = cbean.getTitleName();
	String isUse =  cbean.getUserUse();
	String secDocCodeAlone = cbean.getSecDocCodeAlone();
	String secCategorySeqAlone = cbean.getSecCategorySeqAlone();
	String dateSeqAlone = cbean.getDateSeqAlone();
	String dateSeqSelect = cbean.getDateSeqSelect();
	String allowStr = cbean.getAllowStr();
    RecordSet.executeProc("Doc_SecCategory_SelectByID",id+"");
	RecordSet.next();
	String subcategoryid=RecordSet.getString("subcategoryid");
	int mainid = Util.getIntValue(SubCategoryComInfo.getMainCategoryid(subcategoryid),0);
	//初始值
    boolean hasSubManageRight = false;
	boolean hasSecManageRight = false;
	MultiAclManager am = new MultiAclManager();
	//hasSubManageRight = am.hasPermission(mainid, MultiAclManager.CATEGORYTYPE_MAIN, user, MultiAclManager.OPERATION_CREATEDIR);
	int parentId = Util.getIntValue(scc.getParentId(""+id));
	if(parentId>0){
		hasSecManageRight = am.hasPermission(parentId, MultiAclManager.CATEGORYTYPE_SEC, user, MultiAclManager.OPERATION_CREATEDIR);
	}

    boolean canEdit = false ;
	if (HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user) || hasSecManageRight) {
		canEdit = true ;
	}
	String postValueNullStr = "";
	 int detachable = ManageDetachComInfo.isUseDocManageDetach()?1:0;
  int operatelevel=0;
  if(detachable==1){
	   operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"DocSecCategoryEdit:Edit",Util.getIntValue(scc.getSubcompanyIdFQ(id+""),0));
  }else{
	   if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit", user) || hasSecManageRight)
	         operatelevel=2;
 }

if(operatelevel>0){
	 canEdit = true;
	
}else{
	 canEdit = false;
	
}
%>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
  //菜单
  if (canEdit){
	  RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(this),_top} " ;
	  RCMenuHeight += RCMenuHeightStep ;
  }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

	<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<%if(canEdit){ %>
				<input type=button class="e8_btn_top" onclick="onSave(this);" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<%} %>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<FORM METHOD="POST" name="frmCodeRule" ACTION="DocSecCategoryCodeRuleOperation.jsp">
<INPUT TYPE="hidden" NAME="method">
<INPUT TYPE="hidden" NAME="postValue"><!--主文档传回的字符串-->
<INPUT TYPE="hidden" NAME="postValue2"><!--子文档传回的字符串-->
<INPUT TYPE="hidden" NAME="codemainid" value="<%=codeId%>">
<INPUT TYPE="hidden" NAME="id" value="<%=id%>">
	   <wea:layout attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(81536,user.getLanguage())%></wea:item>
				<wea:item>
					<input class="inputStyle" tzCheckbox="true" type="checkbox" name="useSecCodeRule" value="1" <%if ("1".equals(isUse)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(19416,user.getLanguage())%></wea:item>
				<wea:item>
					<input class="inputStyle" tzCheckbox="true" type="checkbox" id="secDocCodeAlone" name="secDocCodeAlone" value="1" <%if ("1".equals(secDocCodeAlone)) out.println("checked");%> onclick="javascrjpt:onCheckSecDoc()" <%if(!canEdit){%>disabled<%}%>>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<wea:layout needImportDefaultJsAndCss="false">
						<wea:group context="" attributes="{'groupDisplay':'none'}">
							<wea:item attributes="{'isTableList':'true'}">
								<wea:layout needImportDefaultJsAndCss="false" hasTRAttributes="true" type="3col" attributes="{'formTableId':'codeRule'}">
									<wea:group context="" attributes="{'groupDisplay':'none'}">
										 <%
							            for (int i=0;i<coderMemberList.size();i++){
							            	String[] codeMembers = (String[])coderMemberList.get(i);
							            	String codeMemberName = Util.null2String(codeMembers[0]);
							            	String codeMemberValue = codeMembers[1];
							            	String codeMemberType = codeMembers[2];
							            	//String str = "TR_"+i;
							            	if("2".equals(codeMemberType)||"3".equals(codeMemberType)){
							            		postValueNullStr += codeMemberName+"\u001b"+"[(*_*)]"+"\u001b"+ codeMemberType+"\u0007";
							            	}else{
							            		postValueNullStr += codeMemberName+"\u001b"+"0"+"\u001b"+ codeMemberType+"\u0007";
							            	}
							            	String attributes = "{'colspan':'full','trId':'TR_"+i+"','customer1':'member'}";
							            	String attrs = "{'codevalue':'"+codeMemberName+"'}";
							            %>
										<wea:item attributes='<%=attrs %>'>
										  <%if (canEdit){%>
					                       <a style="display:inline-block;padding-right:10px" href="#" onclick="return false;"><img id="img_up_<%=i%>" _moveimg name="img_up" src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%>' border=0></a>
					                       <%}%>
					                      <%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage()) %>
										</wea:item>
										<wea:item attributes='<%=attributes %>'>
											<%
						                         if ("1".equals(codeMemberType)){   //1:checkbox
						                        	 String _customId = "";
													 String onclick="";
					                        	   if(codeMemberName.equals("81537")){
					                        		   _customId="topParent";
					                        	   }
					                        	   if(codeMemberName.equals("81538")){
					                        		   _customId="parParent";
					                        	   }
					                        	   if(codeMemberName.equals("81540")){
					                        		   _customId="allParent";
					                        		   onclick="__setCheckBoxStatus(this);";
					                        	   }
						                           if ("1".equals(codeMemberValue)){
						                             if (canEdit){
						                              out.println("<input tzCheckbox=\"true\" _customId=\""+_customId+"\" type=checkbox name=1chk_"+i+" id=1chk_"+i+" class=inputstyle checked value=1  onclick=\"proView();"+onclick+"\">");
						                             } else {
						                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
						                             }
						                           } else {
						                              if (canEdit){
						                                out.println("<input  _customId=\""+_customId+"\" tzCheckbox=\"true\" type=checkbox name=1chk_"+i+" id=1chk_"+i+" class=inputstyle  value=1  onclick=\"proView();"+onclick+"\">");
						                               } else {
						                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
						                               }                              
						                           }
						                         } else if ("2".equals(codeMemberType)){   //2:input
						                              if (canEdit){
						                                 out.println("<input type=text name=2txt_"+i+" class=inputstyle onchange=proView() onKeyPress=ItemCount_KeyPress('2txt_"+i+"') onBlur=checknumber('2txt_"+i+"') value="+codeMemberValue+">");
						                               } else {
						                                  out.println("<div>"+codeMemberValue+"</div>");
						                               } 
						                         }  else if ("3".equals(codeMemberType)){   //3:input
						                              if (canEdit){
						                                 out.println("<input type=text name=3txt_"+i+" class=inputstyle onchange=proView() value="+codeMemberValue+">");
						                               } else {
						                                  out.println("<div>"+codeMemberValue+"</div>");
						                               } 
						                         }  else if ("4".equals(codeMemberType)){
						                           if ("1".equals(codeMemberValue)){
						                             if (canEdit){
						                              String output = "<input tzCheckbox=\"true\" type=checkbox name=4chk_md id=4chk_md class=inputstyle ";
						        
						                              output += "checked value=1 onclick=proView()>";
						                              out.println(output);
						                             } else {
						                              out.println("<div>"+SystemEnv.getHtmlLabelName(160,user.getLanguage())+"</div>");
						                             }
						                           } else {
						                             if (canEdit){
						                              String output = "<input tzCheckbox=\"true\" type=checkbox name=4chk_md id=4chk_md class=inputstyle ";
						
						                              output += "value=1 onclick=proView()>";
						                              out.println(output);
						                             } else {
						                                out.println("<div>"+SystemEnv.getHtmlLabelName(165,user.getLanguage())+"</div>");
						                             }                              
						                           }
						                         }   
						                    %>
										</wea:item>
										<%}%>
										<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(81541,user.getLanguage())%></wea:item>
										<wea:item attributes="{'colspan':'full','classTR':'notMove'}"><input class="inputStyle" tzCheckbox="true"  type="checkbox" name="secCategorySeqAlone" value="1" <%if ("1".equals(secCategorySeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>></wea:item>
										<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(19418,user.getLanguage())%></wea:item>
										<wea:item attributes="{'colspan':'full','classTR':'notMove'}">
											<input tzCheckbox="true" type="checkbox" name="dateSeqAlone" value="1" <%if ("1".equals(dateSeqAlone)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>>&nbsp;
											<input  type="radio" name="dateSeqSelect" value="1" checked <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%>&nbsp;&nbsp;
											<input  type="radio" name="dateSeqSelect" value="2" <%if ("2".equals(dateSeqSelect)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>&nbsp;&nbsp;
											<input type="radio" name="dateSeqSelect" value="3" <%if ("3".equals(dateSeqSelect)) out.println("checked");%> <%if(!canEdit){%>disabled<%}%>><%=SystemEnv.getHtmlLabelName(390,user.getLanguage())%>
										</wea:item>
										<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></wea:item>
										<wea:item attributes="{'trId':'TR_a','colspan':'full','classTR':'notMove'}">
											<table class='caedfc' cellspacing="0" cellpadding="0" style="display:none;">
												<tr id="TR_doc1" class="notMove"></tr>
											</table>
										</wea:item>
										<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(19921,user.getLanguage())%></wea:item>
										<wea:item attributes="{'classTR':'notMove'}">
											<table  style="display:none;" class='caedfc' cellspacing="0" cellpadding="0">
												<tr id="TR_doc2" class="notMove"></tr>
											</table>
										</wea:item>
										<wea:item attributes="{'trId':'TR_b','classTR':'notMove'}">
											<button type="button" class="e8_btn" name="setup" onclick="javascript:onSetUp(2)" <%if(!canEdit){%>disabled<%}%>accesskey="a">&nbsp;<u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></button>
											<button type="button" class="e8_btn" name="cancel" style="margin-top:8px;" onclick="javascript:onCancel(2)" <%if(!canEdit){%>disabled<%}%>accesskey="d">&nbsp;<u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
										</wea:item>
										<wea:item attributes="{'classTR':'notMove'}"><%=SystemEnv.getHtmlLabelName(19922,user.getLanguage())%></wea:item>
										<wea:item attributes="{'classTR':'notMove'}">
											<table style="display:<%="1".equals(secDocCodeAlone)?"":"none" %>;" class='caedfc' cellspacing="0" cellpadding="0">
												<tr id="TR_doc3" class="notMove"></tr>
											</table>
										</wea:item>
										<wea:item attributes="{'trId':'TR_c','classTR':'notMove'}">
											<button type="button" class="e8_btn" name="setup" onclick="javascript:onSetUp(3)" <%if(!canEdit){%>disabled<%}%>accesskey="a">&nbsp;<u>A</u>&nbsp;<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></button>
											<button type="button" class="e8_btn" name="cancel" style="margin-top:8px;" onclick="javascript:onCancel(3)" <%if(!canEdit){%>disabled<%}%>accesskey="d">&nbsp;<u>D</u>&nbsp;<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
										</wea:item>
									</wea:group>
								</wea:layout>
							</wea:item>
						</wea:group>
					</wea:layout>
				</wea:item>
			</wea:group>
	   </wea:layout>
</FORM>
</BODY>
<SCRIPT LANGUAGE="JavaScript">
<!--
//var colors= new Array ("#6633CC","#FF33CC","#666633","#CC00FF","#996666")  ;
var colors= new Array ("#048bee","#048bee","#048bee","#048bee","#048bee")  ;
function __setCheckBoxStatus(obj){
	var allParent = jQuery(obj);
	var topParent = jQuery("input[_customId='topParent']").eq(0);
	var parParent = jQuery("input[_customId='parParent']").eq(0);
	if(allParent.attr("checked")){
		changeSwitchStatus(topParent,false);
		changeSwitchStatus(parParent,false);
		disOrEnableSwitch(topParent,true);
		disOrEnableSwitch(parParent,true);
	}else{
		disOrEnableSwitch(topParent,false);
		disOrEnableSwitch(parParent,false);
	}
}
jQuery(document).ready(function(){
	var allParent = jQuery("input[_customId='allParent']").eq(0);
	__setCheckBoxStatus(allParent);
	load();
	<%if (canEdit){%>
		registerDragEvent();
		jQuery("tr.notMove").bind("mousedown",function(){
			return false;
		});
		jQuery("tr[customer1='member']").hover(function(){
			jQuery(this).find('img[_moveimg]').attr('src','/proj/img/move-hot_wev8.png');
		},function(){
			jQuery(this).find('img[_moveimg]').attr('src','/proj/img/move_wev8.png');
		});
	<%}%>
});



function registerDragEvent(){
    	 var fixHelper = function(e, ui) {
            ui.children().each(function() { 
                $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了
                $(this).height($(this).height());  
            });  
            return ui;  
        };
        
        var copyTR = null;
 		var startIdx = 0;
        
        jQuery("#codeRule tbody tr").bind("mousedown",function(e){
			copyTR = jQuery(this).next("tr.Spacing");
		});
        
         jQuery("#codeRule tbody").sortable({                //这里是talbe tbody，绑定 了sortable  
             helper: fixHelper,                  //调用fixHelper  
             axis:"y",  
             start:function(e, ui){
                 ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper  
                 if(ui.item.hasClass("notMove")){
                 	e.stopPropagation();
                 }
                 if(copyTR){
            		copyTR.hide();
            	}
            	startIdx = ui.item.get(0).rowIndex;
                 return ui;  
             },  
             stop:function(e, ui){
                 ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行  
                if(copyTR){
            	  if(ui.item.get(0).rowIndex>startIdx){
             	  	ui.item.before(copyTR.clone().show());
             	  }else{
             	  	ui.item.after(copyTR.clone().show());
             	  }
            	  copyTR.remove();
            	  copyTR = null;
            	}
                if(!frmCodeRule.secDocCodeAlone.checked)
  					load();
                return ui;  
             }  
         });  
    }


function load(){  //检查Imag的状态

  var img_ups = document.getElementsByName("img_up");
  for (var index_up=0;index_up<img_ups.length;index_up++)  {
    var img_up = img_ups[index_up];
    if (false && index_up==0)  {
    	img_up.style.visibility ='hidden';
    	img_up.parentNode.style.visibility ='hidden';
    }
    else  {
    	img_up.style.visibility ='visible';
    	img_up.parentNode.style.visibility ='visible';
    }
  }

  var img_downs = document.getElementsByName("img_down");
  for (var index_down=0;index_down<img_downs.length;index_down++)  {
    var img_down = img_downs[index_down];
    if (index_down==img_downs.length-1)  {
   	 	img_down.style.visibility ='hidden';
   	 	img_down.parentNode.style.visibility ='hidden';
    }
    else  {
    	img_down.style.visibility ='visible';
    	img_down.parentNode.style.visibility ='visible';
    }
  }

  if("<%=secDocCodeAlone%>"=="1"){
  	onSetUp(2);

  	var TR_doc = document.getElementById("TR_doc3");
  	var postValue2Str = "";
  	<%if(coderMemberList2.size()>0){%>
	  	<%for(int i=0;i<coderMemberList2.size();i++){
	  		String[] codeMembers2 = (String[])coderMemberList2.get(i);
	
			String codeMemberName = codeMembers2[0];
			String codeMemberValue = codeMembers2[1];
			String codeMemberType = codeMembers2[2];
			
			if ("1".equals(codeMemberType)&&"0".equals(codeMemberValue)){
	        	continue;
	        }else if (("2".equals(codeMemberType) || "3".equals(codeMemberType))&&"".equals(codeMemberValue)){
	        	continue;
	        }else if("19921".equals(codeMemberName)&&"0".equals(codeMemberValue)){
	        	continue;
	        }
		%>
			var index = <%=i%>;
			var codeTitle = "<%=SystemEnv.getHtmlLabelName(Util.getIntValue(codeMemberName),user.getLanguage())%>";
			var codeValue = "<%=codeMemberValue%>";
			var codeType = "<%=codeMemberType%>";
	
			postValue2Str += <%=codeMemberName%>+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";//子文档编码初始返回值

			var tempTd = document.createElement("TD");
			jQuery(tempTd).addClass("field").addClass("nopadding");
	        var tempTable = document.createElement("TABLE");
	        jQuery(tempTable).attr("cellspacing","0").attr("cellpadding","0");
	        var newRow = tempTable.insertRow();
	        var newRowMiddle = tempTable.insertRow();
	        var newRow1 = tempTable.insertRow();
	        jQuery(newRow).addClass("notMove");
	        jQuery(newRowMiddle).addClass("notMove");
	        jQuery(newRow1).addClass("notMove");
	        //newRowMiddle.style.height="1px!important;";
	        jQuery(newRowMiddle).css("height","1px");
		
	        var newCol = newRow.insertCell();
	        newCol.className = "head";
	        var newColMiddle=newRowMiddle.insertCell();
	        var newCol1 = newRow1.insertCell();
			jQuery(newCol1).addClass("caedfc").addClass("field");
	        jQuery(newColMiddle).addClass("e8_line");
	
	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";
	
	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        tempTd.appendChild(tempTable);
	        TR_doc.appendChild(tempTd);
	
	  	<%}%>
	  	postValue2Str = postValue2Str.substring(0,postValue2Str.length-1);

  	<%}%>
  	document.frmCodeRule.postValue2.value = postValue2Str;
  }else{

  	proView();
  }
}

function proView(){
	if(frmCodeRule.secDocCodeAlone.checked)
		return;
	
	/*document.getElementById("TR_a").style.display = '';
	document.getElementById("TR_a").nextSibling.style.display = '';
	document.getElementById("TR_b").style.display = 'none';
	document.getElementById("TR_b").nextSibling.style.display = 'none';
	document.getElementById("TR_c").style.display = 'none';
	document.getElementById("TR_c").nextSibling.style.display = 'none';*/
	jQuery("#TR_a").show();
	jQuery("#TR_a").find("table.caedfc").show();
	jQuery("#TR_a").next().show();
	jQuery("#TR_b").hide();
	jQuery("#TR_b").next().hide();
	jQuery("#TR_c").hide();
	jQuery("#TR_c").next().hide();

			
	//var TR_doc = document.getElementById("TR_doc1");
    //var TR_proChilds = TR_doc.childNodes;   

   
   
   // for (var i=TR_proChilds.length-1;i>=0;i--) TR_proChilds[i].removeNode(true);

    var TR_doc =  jQuery("#TR_doc1");
    jQuery(TR_doc).children("td").remove();

	
    jQuery("tr[customer1='member']").each(function(index,obj){
			
		  var codeTitle = $(obj).find("td::eq(0)").text()
		  codeTitle = jQuery.trim(codeTitle)
		  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
		  
		  var codeValue;

	      if (codeTypeTag=="INPUT") {
	        codeValue= $(obj).find("td::eq(1)").children(":first").val(); 

	        if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	           codeValue = $(obj).find("td::eq(1)").children(":first").val();
	        } else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	           codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	        }
	      }
	      else if (codeTypeTag=="DIV") codeValue = $(obj).find("td::eq(1)").children(":first").text();
	      
	      if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="<%=SystemEnv.getHtmlLabelName(82185,user.getLanguage())%>")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text"&&codeValue==""){ 
	                	return true;
	                }else if (trim(codeTitle)=="<%=SystemEnv.getHtmlLabelName(19921,user.getLanguage())%>"&&codeValue=="1"){
	                	document.getElementById("4chk_md").checked = false;
	                	return true;
	                }
	            }

	        var tempTd = document.createElement("TD");
	        jQuery(tempTd).addClass("field").addClass("nopadding");
	        var tempTable = document.createElement("TABLE");
	        jQuery(tempTable).attr("cellspacing","0").attr("cellpadding","0").css("height","100%");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);
			jQuery(newRow).addClass("notMove");
	        jQuery(newRowMiddle).addClass("notMove");
	        jQuery(newRow1).addClass("notMove");

	        var newCol = newRow.insertCell(-1);
	        newCol.className = "head";
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);
			jQuery(newCol1).addClass("caedfc").addClass("field");
	        jQuery(newRowMiddle).css("height","1px");
	        newColMiddle.className="e8_line";

	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        //tempTd.appendChild(tempTable);
	        jQuery(TR_doc).append(tempTd)
	        //TR_doc.appendChild(tempTd);
	      } 
    })
    
    
    
}

function onSave(obj){
	obj.disabled=true;
	if(!frmCodeRule.secDocCodeAlone.checked){//如果子文档单独编码没有启用的话，只返回主文档编码规则
		var postValueStr=getValue();
		document.frmCodeRule.postValue.value = postValueStr;
	}
	
	document.frmCodeRule.method.value="update";
	document.frmCodeRule.submit();
}
 
function onYearChkClick(obj,index){  
    document.getElementById("select_"+index).disabled=!obj.checked;
    proView();
}

jQuery.fn.swap = function(other) {
    $(this).replaceWith($(other).after($(this).clone(true)));
};

function imgUpOnclick(index){

  if(true)return;
  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  //alert(jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible"))
  var obj2 = jQuery(obj1).prevAll("tr[customer1='member']").filter("tr:visible:first");// obj1.previousSibling.previousSibling;
  
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

  //swapNode(obj1,obj2);
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  if(!frmCodeRule.secDocCodeAlone.checked)
  	load();
}


function imgDownOnclick(index){
	if(true)return;
  var checkbox1Stats = 0;
  var checkbox2Stats = 0;
  var obj1 = document.getElementById("TR_"+index);

  var checkbox1 =obj1.childNodes[1].firstChild;
  if (checkbox1.type=="checkbox") checkbox1Stats = checkbox1.checked;

  var obj2 =jQuery(obj1).nextAll("tr[customer1='member']").filter("tr:visible:first");// 
  var checkbox2 =$(obj2).find("td::eq(1)").children(":first");
  if (checkbox2.type=="checkbox") checkbox2Stats = checkbox2.checked;

 
  jQuery(obj1).swap(obj2);
  if (checkbox1Stats!=0) {
    checkbox1.checked=checkbox1Stats;
  }

   if (checkbox2Stats!=0) {
    checkbox2Stats.checked=checkbox2Stats;
  }
  if(!frmCodeRule.secDocCodeAlone.checked)
  	load();
}
function onCheckSecDoc(){
	var obj = document.getElementById("4chk_md").parentNode.parentNode;
	if(frmCodeRule.secDocCodeAlone.checked){
		obj.style.display="";
		$(obj).children(":first").children(":first").css("visibility","visible")
		//obj.firstChild.firstChild.style.visibility ='visible';
		obj = jQuery(obj).next();
		jQuery(obj).show();
		
    	document.getElementById("TR_a").style.display = 'none';
    	jQuery("#TR_a").next().hide();
    	//document.getElementById("TR_a").nextSibling.style.display = 'none';
		document.getElementById("TR_b").style.display = '';
		jQuery("#TR_b").next().show();
		//document.getElementById("TR_b").nextSibling.style.display = '';
		document.getElementById("TR_c").style.display = '';
		jQuery("#TR_c").next().show();
		//document.getElementById("TR_c").nextSibling.style.display = '';
		
		onSetUp(2);
	}else{
		obj.style.display="none";
		$(obj).children(":first").children(":first").attr("disable","true");
		//obj.firstChild.firstChild.disabled ='true';
		$(obj).children(":first").children(":first").next().next().attr("disable","true");
		//obj.firstChild.firstChild.nextSibling.nextSibling.disabled = 'true';
		obj = jQuery(obj).next();
		jQuery(obj).hide();
		
		document.getElementById("TR_a").style.display = '';
		jQuery("#TR_a").next().show();
		//document.getElementById("TR_a").nextSibling.style.display = '';
		document.getElementById("TR_b").style.display = 'none';
		jQuery("#TR_b").next().hide();
		//document.getElementById("TR_b").nextSibling.style.display = 'none';
		document.getElementById("TR_c").style.display = 'none';
		jQuery("#TR_c").next().hide();
		//document.getElementById("TR_c").nextSibling.style.display = 'none';
		
		proView();
	}
}
function getValue(){
  var TR_members= document.getElementsByTagName("TR");
  var postValueStr="";
  jQuery("tr[customer1='member']").each(function(index,obj){
	  var codeTitle = $(obj).find("td::eq(0)").attr("codevalue")
	  codeTitle = jQuery.trim(codeTitle)
	  var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
	  var codeValue;
	  var codeType;

	    if (codeTypeTag=="INPUT") {
	      codeValue= $(obj).find("td::eq(1)").children(":first").val();
	      if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
	         codeValue =  $(obj).find("td::eq(1)").children(":first").val();
	         if (codeValue=="") codeValue="[(*_*)]";
	         var name =  $(obj).find("td::eq(1)").children(":first").attr("name");
	         if(name.substring(0,1)==2)
	         	codeType = 2;
	         else if(name.substring(0,1)==3)
	         	codeType = 3;
	      } else if ( $(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
	         codeValue =  $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
	         var name =  $(obj).find("td::eq(1)").children(":first").attr("name");
	         if(name.substring(0,1)==1)
	         	codeType = 1;      
	         else if(name.substring(0,1)==4)
	         	codeType = 4;
	      }
	    }
	    postValueStr += codeTitle+"\u001b"+codeValue+"\u001b"+ codeType+"\u0007";
	})
  postValueStr = postValueStr.substring(0,postValueStr.length-1);
  return postValueStr;
}
function onSetUp(docindex){
	var TR_doc;
	if(frmCodeRule.secDocCodeAlone.checked){
    	document.getElementById("TR_a").style.display = 'none';
    	jQuery("#TR_a").next().hide();
    	//document.getElementById("TR_a").nextSibling.style.display = 'none';
		document.getElementById("TR_b").style.display = '';
		jQuery("#TR_b").next().show();
		//document.getElementById("TR_b").nextSibling.style.display = '';
		document.getElementById("TR_c").style.display = '';
		jQuery("#TR_c").next().show();
		//document.getElementById("TR_c").nextSibling.style.display = '';
    	TR_doc = document.getElementById("TR_doc"+docindex);
    }else{
		document.getElementById("TR_a").style.display = '';
		jQuery("#TR_a").next().show();
		//document.getElementById("TR_a").nextSibling.style.display = '';
		document.getElementById("TR_b").style.display = 'none';
		jQuery("#TR_b").next().hide();
		//document.getElementById("TR_b").nextSibling.style.display = 'none';
		document.getElementById("TR_c").style.display = 'none';
		jQuery("#TR_c").next().hide();
		document.getElementById("TR_c").nextSibling.style.display = 'none';
    	TR_doc = document.getElementById("TR_doc1");
    }
	
    jQuery(TR_doc).find("td").remove();
    
    jQuery(TR_doc).closest("table.caedfc").show();
	
	//return;
    jQuery("tr[customer1='member']").each(function(index,obj){

    	 var codeTitle = $(obj).find("td::eq(0)").text()
		 codeTitle = jQuery.trim(codeTitle)
		 var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
		  
		 var codeValue;
    	 if (codeTypeTag=="INPUT") {
 	        codeValue= $(obj).find("td::eq(1)").children(":first").val(); 

 	        if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text") {
 	           codeValue = $(obj).find("td::eq(1)").children(":first").val();
 	        } else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"){
 	           codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked")==true?"1":"0";
 	        }
 	      }
 	      else if (codeTypeTag=="DIV") codeValue = $(obj).find("td::eq(1)").children(":first").text();
    	 if (codeTypeTag=="INPUT"||codeTypeTag=="DIV"&&codeValue!="<%=SystemEnv.getHtmlLabelName(82185,user.getLanguage())%>")  { 
	            if (codeTypeTag=="INPUT") {
	                if ($(obj).find("td::eq(1)").children(":first").attr("type")=="checkbox"&&codeValue=="0"){ 
	                	return true;
	                }else if ($(obj).find("td::eq(1)").children(":first").attr("type")=="text"&&codeValue==""){ 
	                	return true;
	                }else if (trim(codeTitle)=="<%=SystemEnv.getHtmlLabelName(19921,user.getLanguage())%>"&&codeValue=="1"){
	                	document.getElementById("4chk_md").checked = false;
	                	return true;
	                }
	            }

	        var tempTd = document.createElement("TD");
	        jQuery(tempTd).addClass("field").addClass("nopadding");
	        var tempTable = document.createElement("TABLE");
	         jQuery(tempTable).attr("cellspacing","0").attr("cellpadding","0");
	        var newRow = tempTable.insertRow(-1);
	        var newRowMiddle = tempTable.insertRow(-1);
	        var newRow1 = tempTable.insertRow(-1);
			
			 jQuery(newRow).addClass("notMove");
	        jQuery(newRowMiddle).addClass("notMove");
	        jQuery(newRow1).addClass("notMove");
	        jQuery(newRowMiddle).css("height","1px");

	        var newCol = newRow.insertCell(-1);
	        var newColMiddle=newRowMiddle.insertCell(-1);
	        var newCol1 = newRow1.insertCell(-1);
	         newCol.className = "head";

	        jQuery(newCol1).addClass("caedfc").addClass("field");
	        jQuery(newColMiddle).addClass("e8_line");

	        newCol.innerHTML="<font color="+colors[index%5]+">"+codeTitle+"</font>";

	        if (codeValue=="1") {
	          codeValue="****";
	        } else if (codeValue=="0") {
	          codeValue="**";
	        }
	        newCol1.innerHTML="<font color="+colors[index%5]+">"+codeValue+"</font>";
	        jQuery(tempTd).append(tempTable);
	        //tempTd.appendChild(tempTable);
	        jQuery(TR_doc).append(tempTd)
	        //TR_doc.appendChild(tempTd);
	      }
    })
    
    if(docindex==3){//设置子文档编码传回的字符串
		var postValueStr=getValue();
		document.frmCodeRule.postValue2.value=postValueStr;
	}else{//设置主文档编码传回的字符串
		var postValueStr=getValue();
		document.frmCodeRule.postValue.value=postValueStr;
	}
}
function onCancel(docindex){
	TR_doc = document.getElementById("TR_doc"+docindex);
	jQuery(TR_doc).closest("table.caedfc").hide();
	var oItem = TR_doc.children;
	if (oItem!=null) {
		var length = oItem.length;
		for (i=0; i<length; i++)TR_doc.removeChild(oItem.item(0));
	}
	if(docindex==2){
		document.frmCodeRule.postValue.value = "<%=postValueNullStr%>";
	}else if(docindex==3){
		document.frmCodeRule.postValue2.value = "";
	}
}
</SCRIPT>
</HTML>
