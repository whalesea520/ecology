
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.general.SplitPageParaBean"%>
<%@page import="weaver.general.SplitPageUtil"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.TimeUtil"%> 
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil" scope="page"/>
<%	
    String userid=user.getUID()+"";
    String username=resourceComInfo.getLastname(userid);
    String viewType=Util.null2String(request.getParameter("viewType"));//查看类型
	String backfields="tasktype,taskid,taskName,creater,isnew,isfeedback,createdate,createtime";
    int index=0;
    String sql="";
    if(viewType.equals("mainlineset")){  //主线设置
		sql="select * from Task_mainline where principalid = " + userid;
	}else if(viewType.equals("labelset")){  //标签设置
		sql="select * from task_label,("
		      +" select distinct labelid from (select taskid as mtaskid,tasktype as mtasktype,labelid from Task_labelTask) t1,("
			  +" select "+backfields+" from "+taskUtil.getTaskSql(0,userid,"")
		      +" UNION ALL "
		      +" select "+backfields+" from "+taskUtil.getWorkflowSql(0,userid,"")
		      +" UNION ALL "
		      +" select "+backfields+" from "+taskUtil.getMeetingSql(0,userid)
		      +" UNION ALL "
		      +" select "+backfields+" from "+taskUtil.getDocSql(0,userid,"") 
		      +" UNION ALL "
		      +" select "+backfields+" from "+taskUtil.getCoworkSql(0,userid,"")
		      +" UNION ALL "
		      +" select "+backfields+" from "+taskUtil.getEmailSql(0,userid,"")
		      +" ) a WHERE  t1.mtasktype=a.tasktype AND t1.mtaskid=a.taskid " 
		      +") a"
		      +" WHERE id=a.labelid and createor = "+userid;
	}
    rs.execute(sql);
%>	
		    
			<%
			while(rs.next()){
			    String name=rs.getString("name");
			    String id=rs.getString("id");
			    String creator=rs.getString("createor");
			    String creatorName=resourceComInfo.getLastname(creator);
		   %>
			<tr class="item_tr">
				<td width="23px" class='td_move'><div>&nbsp;</div></td>
				<td width="18px"></td>
				<td width="18px"></td>
				<td width="18px"></td>
				<td class='item_td'><input readonly onfocus="doClickItem1(this)" onblur='doAddOrUpdate1(this)' _itemType="mainline" class="disinput" type="text" name="" id="<%=id%>" title="<%=name%>"  value="<%=name%>" _index="<%=index++ %>"/></td>
				<td width="60px" class='item_count'></td>
				<td width="45px"></td>
				<td width="40px" class='item_hrm' title='<%=creatorName%>'><%=creatorName%></td>
			</tr>
		  <%}%>
			<tr class='item_tr tr_select'>
				<td width='23px' class='td_move'><div>&nbsp;</div></td>
				<td width='18px'></td>
				<td width='18px'></td>
				<td width='18px'></td>
				 <%if (viewType.equals("mainlineset")) {%>
				<td class='item_td'><input  onfocus='doClickItem1(this)' onblur='doAddOrUpdate1(this)'   _itemType='mainline' class='disinput addinput definput'  type='text' name='' id='' title=''  value='新建主线' _index=""/></td>
				<%}else{ %>
				<td class='item_td'><input  onfocus='doClickItem1(this)' onblur='doAddOrUpdate1(this)'   _itemType='mainline' class='disinput addinput definput'  type='text' name='' id='' title=''  value='新建标签' _index=""/></td>
				<%} %>				
				<td width='60px' class='item_count'></td>
				<td width='45px'></td>
				<td width='40px' class='item_hrm' title=''></td>
			</tr>
		<script language="javascript" src="/express/js/jquery-1.8.3.min_wev8.js"></script>
		<script type="text/javascript">
			document.onkeydown=keyListener;
			var isLast="";
			var isExit = "";
			function keyListener(e){
			    e = e ? e : event;   
			    if(e.keyCode == 13){
			    	var viewType ="<%=viewType%>";
			    	var userName ="<%=username%>";
			    	var target=$.event.fix(e).target;
			    	var targetTr=$(target).parent().parent();
			    	if($(targetTr).next().hasClass("item_tr")){
			    		isLast = "0";
			    	}else{
			    		isLast="1";
			    	}
			    	var name = $(target).val();
			    	if(name=="新建主线"||name=="新建标签"){
			    		return;
			    	}
			    	if(name == ""){
			    		return;
			    	}else{
			    		$.post("/express/TaskOperation.jsp?operation=checkMainName&name="+name+"&type="+viewType,function(data){
			    			if(data == "1"){
			    					if(viewType == "mainlineset"){
			    						$.post("/express/TaskOperation.jsp?operation=addMain&labei_name="+name,function(data){
				    					$(target).attr("id",data);
				    					$(target).parent().parent().children().last().html(userName);
				    					refreshDetail(viewType,data)
			    				});
				  	 		}
				   	 				if(viewType == "labelset"){
			    						$.post("/express/TaskOperation.jsp?operation=addLabel&labei_name="+name,function(data){
			    							$(target).attr("id",data);
			    							$(target).parent().parent().children().last().html(userName);
			    							refreshDetail(viewType,data)
			    				});
				   			}	
			    		}
				   			if(data=="0" && $(target).attr("id")==""){
				   				alert("已存在");
				   				return false;
				   	}
				   	
				   		//列表标题回车事件
			    	if($(target).hasClass("disinput")){
						if($(target).attr("id")=="" || typeof($(target).attr("id"))=="undefined"){
							if($(target).val()==""){
								return;
							}
							if($(target).hasClass("definput")){
								addItem1(1,1,isLast);
							}else{
								addItem1(0,1,isLast);
							}
						}else{
							addItem1(0,1,isLast);
						}
			    	} 
			    	//明细内容回车事件
			    		});
				   	}
			    } 
			}
			//新建任务
			function addItem1(def,focus,isLast){
				if(foucsobj==null){
					$("table.datalist").first().find("input.definput").focus();
					return;
				}else{
					var newtr = $("<tr class='item_tr'>"+
									"<td width='23px' class='td_move'><div>&nbsp;</div></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td class='item_td'><input id=''  _itemType='mainline' onfocus='doClickItem1(this)' onblur='doAddOrUpdate1(this)' class='disinput addinput ' type='text' name=''  title=''  value='' _index='<%=index++ %>'/></td>"+
									"<td width='60px' class='item_count'></td>"+
									"<td width='45px'></td>"+
									"<td width='40px' class='item_hrm' title=''></td>"+"</tr>");
					$(foucsobj).parent().parent().after(newtr);
					setIndex();
				}
				if(focus==1) newtr.click().find("input.disinput").focus();
			}
			
			function setIndex(){
			$("table.datalist").each(function(){
				var index=1;
				$(this).find(".td_move").each(function(){
					if($(this).parent().css("display")!="none"){
						$(this).children().html(index);
					    $("table.datalist").children().children().last().children().first().children().html("");
					    index++;
					}
				});
				});
			}
			
			 function stopBubble(e)
			 {
			     if (e && e.stopPropagation){
			         e.stopPropagation()
			     }else{
			         window.event.cancelBubble = true
			     }
			}
			function doClickItem1(obj){
				$(obj).removeClass("newinput").removeClass("fbinput");
				var objcount = $(obj).parent().nextAll("td.item_count");
				var _fbcount = objcount.attr("_fbcount");
				if(parseInt(_fbcount)>0){
					objcount.removeClass("item_count_new").attr("title",_fbcount+"条反馈");
				}
				if($(foucsobj).attr("id")==$(obj).attr("id") && $(obj).attr("id")!="" && typeof($(obj).attr("id"))!="undefined") return;//重复点击时不会加载
				foucsobj = obj;
				if($(obj).attr("id")=="" || typeof($(obj).attr("id"))=="undefined"){
					$(obj).removeClass("addinput").val("");
				}else{
				    var itemType=$(obj).attr("_itemType") //数据项类型
				    beforeLoading();
				    if(itemType == "label"){
				    }
				    if(itemType=="mainline"){
						var mainlineid=$(obj).attr("id")
						var viewType = $("#viewType").attr("value");
						if(viewType == "labelset"){
							$("#detailFrame").attr("src","/express/DetailLabel.jsp?labelid="+mainlineid);
						}else{
							$("#detailFrame").attr("src","DetailMainline.jsp?mainlineid="+mainlineid);
						}
					}else{
						var taskType=$(obj).attr("_taskType");
						var taskid=$(obj).attr("_taskid");
						var creater=$(obj).parents("tr:first").attr("_creater");
						$("#detailFrame").attr("src","TaskView.jsp?operation=view&taskType="+taskType+"&taskid="+taskid+"&creater="+creater);
					}
				}
			}
			
			function doAddOrUpdate1(obj,enter){
				var taskid = $(obj).attr("id");
				var viewType = $("#viewType").attr("value");
				var taskname = encodeURI($(obj).val());
				var obj1 = $("#datalist0").children().children().last();
				var v = $(obj1).children().eq(4).children().attr("value");
				if(v == ""){
					$(obj1).remove();
					if(viewType == "mainlineset"){
						var newtr = $("<tr class='item_tr'>"+
									"<td width='23px' class='td_move'><div>&nbsp;</div></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td class='item_td'><input id=''  _itemType='mainline' onfocus='doClickItem1(this)' onblur='doAddOrUpdate1(this)' class='disinput addinput definput' type='text' name=''  title=''  value='新建主线' _index='<%=index++ %>'/></td>"+
									"<td width='60px' class='item_count'></td>"+
									"<td width='45px'></td>"+
									"<td width='40px' class='item_hrm' title=''></td>"+"</tr>");
					}else{
					var newtr = $("<tr class='item_tr'>"+
									"<td width='23px' class='td_move'><div>&nbsp;</div></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td class='item_td'><input id=''  _itemType='mainline' onfocus='doClickItem1(this)' onblur='doAddOrUpdate1(this)' class='disinput addinput definput' type='text' name=''  title=''  value='新建标签' _index='<%=index++ %>'/></td>"+
									"<td width='60px' class='item_count'></td>"+
									"<td width='45px'></td>"+
									"<td width='40px' class='item_hrm' title=''></td>"+"</tr>");
					}
					$("#datalist0").children().last().after(newtr);
					var lastTr = $("#datalist0").children().last();
					$(lastTr).addClass("tr_select");
					if(isLast == "1"){
						$(".disinput").last().focus();
						isLast="";
					}
					
				}
				if(taskid=="" || typeof(taskid)=="undefined"){//新建
					if($(obj).val()=="" || $(obj).val()=="新建主线" ||$(obj).val()=="新建标签"){
						if($(obj).hasClass("definput")){
							if(viewType == "mainlineset"){
								$(obj).addClass("addinput").val("新建主线");
							}else{
								$(obj).addClass("addinput").val("新建标签");
							}
						}else{
							$(obj).parent().parent().remove();
							foucsobj = null;
						}
					}
				}
			}
			
			function refreshDetail(type,id){
				if(type == "mainlineset"){
					$("#detailFrame").attr("src","DetailMainline.jsp?mainlineid="+id);
				}
				if(type == "labelset"){
					$("#detailFrame").attr("src","DetailLabel.jsp?labelid="+id);
				}
			}
			
			$(document).ready(function(){
				$(".disinput").each(function(){
					if($(this).attr("value") == ""){
						$(this).focus();
					}
				});
			});
		</script>	