<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	boolean canEdit = false;
	if(HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){
	    canEdit = true;
	}
   int isSaveSuccess = Util.getIntValue(request.getParameter("isSaveSuccess"),0);   
%>
<HTML>
	<HEAD>
    <style type="text/css">
       .listTable{
		    table-layout: fixed;
		}
		.listTable td{
		    padding: 6px 6px 6px 12px;
		    border-bottom:1px solid #ECECEC;
		    height:36px;
		    line-height:24px;
		    word-break: keep-all;
		    white-space: nowrap;
		    overflow: hidden;
		    text-overflow: ellipsis;
		}
		.listTable thead td{
		    color: #4f6b72;
		    border: 1px solid #c1dad7;
		    letter-spacing: 2px;
		    text-transform: uppercase;
		    text-align: center;
		    padding: 6px 6px 6px 12px;
		    background:#cae8ea;
		}
		.btnOper{
	        background:#f6f6f6;
	        width: 50px;
	        float: right;
	        line-height:24px;
	        margin: 0 5px 0 3px;
	        text-align:center;
	        cursor:pointer;
	    }
        .btnOperHover{
	        background:#0080C0;
	        color:#fff;
	    }
	    .item_input {
		    width: 90%;
		    height: 24px;
		    border: 1px #fff solid;
		    border-radius: 3px;
		    -moz-border-radius: 3px;
		    -webkit-border-radius: 3px;
		    padding-left: 3px;
		    resize: none;
		}
		
		.item_input_hover {
		    border: 1px #CCCCCC solid;
		    box-shadow: 0px 0px 1px #fff;
		    -moz-box-shadow: 0px 0px 1px #fff;
		    -webkit-box-shadow: 0px 0px 1px #fff;
		}
		
		.item_input_focus {
		    border: 1px #1A8CFF solid;
		    box-shadow: 0px 0px 1px #1A8CFF;
		    -moz-box-shadow: 0px 0px 1px #1A8CFF;
		    -webkit-box-shadow: 0px 0px 1px #1A8CFF;
		    /**resize: both;*/
		}
    </style>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<%

	%>
	<BODY style="overflow: auto;padding:10px;">
		<form id="scoreForm" name="scoreForm" action="ScoreSettingOperation.jsp" method="post">
		    <input id="ids" name="ids" type="hidden"/>
		    <%if(canEdit){ %>
		    <div>
                <div id="btn_delContacter" class="btnOper" onclick="doDeleteProdct()">删除</div>
                <div id="btn_addContacter" class="btnOper" onclick="doAddProdct()">添加</div>
		        <div id="btn_saveContacter" class="btnOper" onclick="doSaveProdct()">保存</div>
		    </div>
		    <%} %>
			<table class="listTable" width=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="35px" style="text-align:center;">
					<col style="text-align:left;">
					<col width="15%" style="text-align:center;">
					<col width="15%" style="text-align:center;">
					<col width="15%" style="text-align:center;">
					<col width="15%" style="text-align:center;">
					<col width="10%" style="text-align:center;">
				</colgroup>
				<thead>
					<tr>
					    <td style="padding:0;"><input type='checkbox' id="checkall" name='check_node'/></td>
						<td>分段名称</td>
						<td>开始值符号</td>
						<td>开始值</td>
						<td>结束值符号</td>
						<td>结束值</td>
						<td>显示顺序</td>
					</tr>
				</thead>
				<tbody>
				    <%
				    String sql = "SELECT id , "+
							     "       gardename , "+
							     "       beginSymbol , "+
							     "       beginscore , "+
							     "       endSymbol , "+
							     "       endscore , "+
							     "       rank "+
							     "FROM   GP_ScoreSetting "+
							     "ORDER  BY rank";
				    rs.execute(sql);
				    String id = null;
				    String gardename = null;
				    String beginSymbol = null;
				    String beginscore = null;
				    String endSymbol = null;
				    String endscore = null;
				    String rank = null;
				    int rowindex = 0;
				    while(rs.next()){
					    id = Util.null2String(rs.getString("id"));
					    gardename = Util.null2String(rs.getString("gardename"));
					    beginSymbol = Util.null2String(rs.getString("beginSymbol"));
					    beginscore = Util.null2String(rs.getString("beginscore"));
					    endSymbol = Util.null2String(rs.getString("endSymbol"));
					    endscore = Util.null2String(rs.getString("endscore"));
					    rank = Util.null2String(rs.getString("rank"));
					    %>
					    <tr>
					    	<td style="padding:0;"><input type='checkbox' value='<%=rowindex%>'/></td>
					    	<td>
					    	    <input class="item_input" name="gardename_<%=rowindex%>" id="gardename_<%=rowindex%>" value="<%=gardename %>" onblur="checkinput('gardename_<%=rowindex%>','gardenameSpan_<%=rowindex%>')"/>
					    	    <SPAN id="gardenameSpan_<%=rowindex%>" name="gardenameSpan_<%=rowindex%>">
			                    </SPAN>
					    	</td>
					    	<td>
					    	    <select name="beginSymbol_<%=rowindex%>">
						    	    <option <%if("1".equals(beginSymbol)){%>selected="selected"<%}%> value="1">大于</option>
						    	    <option <%if("2".equals(beginSymbol)){%>selected="selected"<%}%> value="2">大于等于</option>
						    	    <option <%if("3".equals(beginSymbol)){%>selected="selected"<%}%> value="3">小于</option>
						    	    <option <%if("4".equals(beginSymbol)){%>selected="selected"<%}%> value="4">小于等于</option>
					    	    </select>
					    	</td>
					    	<td>
					    	    <input class="item_input" name="beginscore_<%=rowindex%>" onkeyup="clearNoNum(this)" value="<%=beginscore %>" onblur="checkinput('beginscore_<%=rowindex%>','beginscoreSpan_<%=rowindex%>')"/>
					    	    <SPAN id="beginscoreSpan_<%=rowindex%>" name="beginscoreSpan_<%=rowindex%>">
                                </SPAN>
					    	</td>
					    	<td>
					    	    <select name="endSymbol_<%=rowindex%>">
                                    <option <%if("1".equals(endSymbol)){%>selected="selected"<%}%> value="1">大于</option>
                                    <option <%if("2".equals(endSymbol)){%>selected="selected"<%}%> value="2">大于等于</option>
                                    <option <%if("3".equals(endSymbol)){%>selected="selected"<%}%> value="3">小于</option>
                                    <option <%if("4".equals(endSymbol)){%>selected="selected"<%}%> value="4">小于等于</option>
                                </select>
                            </td>
					    	<td>
					    	    <input class="item_input" name="endscore_<%=rowindex%>" id="endscore_<%=rowindex%>" value="<%=endscore %>" onblur="checkinput('endscore_<%=rowindex%>','endscoreSpan_<%=rowindex%>')"/>
                                <SPAN id="endscoreSpan_<%=rowindex%>" name="endscoreSpan_<%=rowindex%>">
                                </SPAN>
                            </td>
					    	<td><input class="item_input" name="rank_<%=rowindex%>" value="<%=rank %>"/></td>
				    	</tr>
			        <%
			            rowindex++;
				    }%>
				</tbody>
			</table>
		</form>
		<table>
		<tr id="templeTr" style="display:none;">
             <td style="padding:0;"><input type='checkbox' value=''/></td>
             <td>
                <input class="item_input" name="gardename" id="gardename" value=""/>
                <SPAN id="gardenameSpan_">
                    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                </SPAN>
             </td>
             <td>
                <select name="beginSymbol" notBeauty=true>
                    <option selected="selected" value="1">大于</option>
                    <option value="2">大于等于</option>
                    <option value="3">小于</option>
                    <option value="4">小于等于</option>
                </select>
             </td>
             <td>
                 <input class="item_input" name="beginscore" id="beginscore" onkeyup="clearNoNum(this)" value=""/>
                 <SPAN id="beginscoreSpan_">
                    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                 </SPAN>
             </td>
             <td>
                <select name="endSymbol" notBeauty=true>
                    <option value="1">大于</option>
                    <option value="2">大于等于</option>
                    <option value="3">小于</option>
                    <option selected="selected" value="4">小于等于</option>
                </select>
             </td>
             <td>
                 <input class="item_input" name="endscore" id="endscore" onkeyup="clearNoNum(this)" value=""/>
                 <SPAN id="endscoreSpan_">
                    <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
                 </SPAN>
             </td>
             <td><input class="item_input" name="rank" value=""/></td>
         </tr>
         </table>
         <div id="msg" style="position: absolute;width: 270px;line-height: 30px;text-align:center;left:100px;top:50px;background:#FBFDFF;color:#808080;font-size:14px;font-family:'微软雅黑';display:none;
            border: 1px #1A8CFF solid;box-shadow:0px 0px 1px #1A8CFF;-moz-box-shadow:0px 0px 1px #1A8CFF;-webkit-box-shadow:0px 0px 1px #1A8CFF;
            border-radius: 2px;-moz-border-radius: 2px;-webkit-border-radius: 2px;">操作成功！</div> 
         
	<script type="text/javascript" defer="defer">
	    var rowindex = <%=rowindex%>;
		$(".btnOper").bind("mouseover",function(){
            $(this).addClass("btnOperHover");
        }).bind("mouseout",function(){
            $(this).removeClass("btnOperHover");
        });
		$("#checkall").change(function(){
			if($(this).attr("checked")){
				$("input:checkbox").attr("checked","checked");
			}else{
				$("input:checkbox").attr("checked",false);
			}
		});
		$(".item_input").bind("focus",function(){
            $(this).addClass("item_input_focus");
		}).bind("blur",function(){
            $(this).removeClass("item_input_focus");
        });
		
		//表格行背景效果及操作按钮控制绑定
        $(".listTable tbody tr").bind("mouseenter",function(){
            $(this).find(".item_input").addClass("item_input_hover");
        }).bind("mouseleave",function(){
            $(this).find(".item_input").removeClass("item_input_hover");
        });
		
        /**
         * 删除记录
         */
        function doDeleteProdct(){
            var rownum = $(".listTable tbody tr").size();
            var num=0;
            for(var i=rownum-1; i>=0; i--){
                var ischecked = $(".listTable tbody tr").eq(i).find("input:checkbox").attr("checked");
                if(ischecked){
                    $(".listTable tbody tr").eq(i).remove();
                }
            }
        }
        /**
         * 添加产品
         */
        function doAddProdct(){
            var tr = $("<tr></tr>");
            tr.html($("#templeTr").html());
            rowindex++;
            tr.find("input[name=rank]").val(rowindex);
            tr.find("input:checkbox").val(rowindex);
            tr.find("select,input").each(function(){
            	var name = $(this).attr("name")+"_"+rowindex
            	$(this).attr("name",name);
            });
            
            bindCheckinput(tr,rowindex);
            
            $(".listTable tbody").append(tr);
            tr.bind("mouseenter",function(){
                $(this).find(".item_input").addClass("item_input_hover");
            }).bind("mouseleave",function(){
                $(this).find(".item_input").removeClass("item_input_hover");
            });
        }
        
        function bindCheckinput(tr,rowindex){
        	tr.find("input[name^=gardename]").attr("id",tr.find("input[name^=gardename]").attr("id")+rowindex);
            tr.find("span[id^=gardenameSpan]").attr("id",tr.find("span[id^=gardenameSpan]").attr("id")+rowindex);
            tr.find("input[name^=gardename]").blur(function(){
                checkinput($(this).attr("id"),"gardenameSpan_"+rowindex);
            });
            tr.find("input[name^=beginscore]").attr("id",tr.find("input[name^=beginscore]").attr("id")+rowindex);
            tr.find("span[id^=beginscoreSpan]").attr("id",tr.find("span[id^=beginscoreSpan]").attr("id")+rowindex);
            tr.find("input[name^=beginscore]").blur(function(){
                checkinput($(this).attr("id"),"beginscoreSpan_"+rowindex);
            });
            tr.find("input[name^=endscore]").attr("id",tr.find("input[name^=endscore]").attr("id")+rowindex);
            tr.find("span[id^=endscoreSpan]").attr("id",tr.find("span[id^=endscoreSpan]").attr("id")+rowindex);
            tr.find("input[name^=endscore]").blur(function(){
                checkinput($(this).attr("id"),"endscoreSpan_"+rowindex);
            });
        }
        /**
         * 保存产品
         */
        function doSaveProdct(){
        	var ids = "";
            var isValid=true;
        	$(".listTable tbody input[name^=gardename]").each(function(){
        		if($.trim($(this).val()).length == 0){
        			alert("分段名称不能为空");
        			isValid=false;
        			return false;
        		}
        	});
        	if(!isValid){
                return;
            }
        	$(".listTable tbody input[name^=beginscore]").each(function(){
                if($.trim($(this).val()).length == 0){
                    alert("开始值不能为空");
                    isValid=false;
                    return false;
                }
            });
        	if(!isValid){
                return;
            }
        	$(".listTable tbody input[name^=endscore]").each(function(){
                if($.trim($(this).val()).length == 0){
                    alert("结束值不能为空");
                    isValid=false;
                    return false;
                }
            });
        	if(!isValid){
        		return;
        	}
            $(".listTable tbody :checkbox").each(function(){
            	ids +="," + $(this).val();
            });
            if(ids.length > 0){
            	ids = ids.substring(1);
            }
            $("#ids").val(ids);
            $("#scoreForm").submit();
        }
        /**
         * 清除非数字字符
         */
        function clearNoNum(obj){
        	//先把非数字的都替换掉，除了数字和.     
        	obj.value = obj.value.replace(/[^\d.]/g,"");        
        	//必须保证第一个为数字而不是.        
        	obj.value = obj.value.replace(/^\./g,"");       
        	//保证只有出现一个.而没有多个.       
        	obj.value = obj.value.replace(/\.{2,}/g,".");       
        	//保证.只出现一次，而不能出现两次以上       
        	obj.value = obj.value.replace(".","$#$").replace(/\./g,"").replace("$#$",".");  
        }
        $(document).ready(function(){
        	if(<%=isSaveSuccess%>){
        		 var _left = Math.round(($(window).width()-$("#msg").width())/2);
                 $("#msg").css({"left":_left,"top":60}).show().animate({top:30},500,null,function(){
                     $(this).fadeOut(800);
                 });
        	}
        	if(<%=!canEdit%>){
        		$("input").attr("readOnly","true");
        		$("select").attr("disabled","disabled");
        	}
        });
	</script>
	</BODY>
</HTML>