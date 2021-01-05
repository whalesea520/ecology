
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="java.text.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String userid = user.getUID()+"";
	String sql = "select id from HrmRoleMembers where  roleid = 8 and rolelevel = 2 and resourceid = " + userid;
	rs.executeSql(sql);
	if(!rs.next()) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>预警关键词设置</title>
		<script language="javascript" src="../js/jquery-1.8.3.min_wev8.js"></script>
		<style type="text/css">
			html,body{margin:0px;}
			*{font-size: 12px;font-family: '微软雅黑' !important;}
			.main{width: 100%;}
			.main td{min-height: 26px;}
			.main td.data{border: 1px #D1D1D1 solid;}
			.itemtitle{background: #F7F7F7;line-height: 28px;width: 100%;border-bottom: 1px #D1D1D1 solid;font-weight: bold;}
			.title_txt{line-height: 28px;margin-left: 8px;font-weight: bold;}
			.blur_show{font-style: italic;color: #C8C8C8;}
			
			.tagitem{line-height:28px;margin-left: 10px;float: left;color: #000;padding-right: 12px;position: relative;}
			.tagdel{width:12px;height: 12px;background: url('../images/mainline_wev8.png') no-repeat -83px -130px;position: absolute;right: 0px;top: 8px;cursor: pointer;display: none;}
			
			.item_input{margin-top: 0px !important;}
			
			.keypanel{width: 100%;height:140px;position: relative;margin-top: 5px;}
			.tagpanel{position: absolute;width: 250px;height: 32px;background: #E0E0E0;bottom:10px;left: 10px;}
			.tagdiv{width: 98%;height: auto;margin: 0px auto;margin-top: 10px;}
			.addbtn{position: absolute;right: 5px;top: 5px;width: 50px;height: 22px;line-height: 22px;background: #E5A929;text-align: center;color: #fff;cursor: pointer;font-weight: bold;}
			.tagfloat{position: absolute;width: auto;line-height: 28px;display: none;color:#000;}
		</style>
		
		<!--[if IE]> 
		<style type="text/css">
			.item_input{margin-top: 1px !important;}
		</style>
		<![endif]-->
	</head>
	<body>
		<table class="main" cellpadding="0" cellspacing="14" border="0">
			<colgroup><col width="50%"/><col width="50%"/></colgroup>
			<tr>
				<td valign="top" class="data" style="position: relative;">
					<div class="itemtitle"><div class="title_txt">对手类</div></div>
					<div id="keypanel_1" class="keypanel">
						<div id="tagdiv_1" class="tagdiv">
						<%
							String keyid = "";
							String keyname = "";
							rs.executeSql("select id,keyname from CRM_WarnConfig where keytype=1");
							while(rs.next()){
								keyid = Util.null2String(rs.getString("id"));
								keyname = Util.null2String(rs.getString("keyname"));
							
						%>
							<div class="tagitem" title="<%=keyname %>">
								<%=keyname %>
								<div class="tagdel" onclick="doDelTag(<%=keyid %>,this)" title="删除"></div>
							</div>
						<%
							}
						%>
						</div>
						<div id="tagpanel_1" class="tagpanel">
							<div style="position: absolute;left: 5px;top: 5px;width: 180px;height: 22px;background: #fff;">
								<input type="text" id="addtag_1" _index="1" style="width: 100%;border: 0px;height: 22px;line-height: 22px;margin: 0px;padding: 0px;color: #5B5B5B;"/>
							</div>
								<div id="addtagbtn_1" class="addbtn" onclick="doSaveTag(1)">添加</div>
						</div>
						<div id="tagfloat_1" class="tagfloat"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top" class="data" style="position: relative;">
					<div class="itemtitle"><div class="title_txt">动作类</div></div>
					<div id="keypanel_2" class="keypanel">
						<div id="tagdiv_2" class="tagdiv">
						<%
							rs.executeSql("select id,keyname from CRM_WarnConfig where keytype=2");
							while(rs.next()){
								keyid = Util.null2String(rs.getString("id"));
								keyname = Util.null2String(rs.getString("keyname"));
							
						%>
							<div class="tagitem" title="<%=keyname %>">
								<%=keyname %>
								<div class="tagdel" onclick="doDelTag(<%=keyid %>,this)" title="删除"></div>
							</div>
						<%
							}
						%>
						</div>
						<div id="tagpanel_2" class="tagpanel">
							<div style="position: absolute;left: 5px;top: 5px;width: 180px;height: 22px;background: #fff;">
								<input type="text" id="addtag_2" _index="2" style="width: 100%;border: 0px;height: 22px;line-height: 22px;margin: 0px;padding: 0px;color: #5B5B5B;"/>
							</div>
								<div id="addtagbtn_2" class="addbtn" onclick="doSaveTag(2)">添加</div>
						</div>
						<div id="tagfloat_2" class="tagfloat"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td valign="top" class="data" style="position: relative;">
					<div class="itemtitle"><div class="title_txt">时间类</div></div>
					<div id="keypanel_3" class="keypanel">
						<div id="tagdiv_3" class="tagdiv">
						<%
							rs.executeSql("select id,keyname from CRM_WarnConfig where keytype=3");
							while(rs.next()){
								keyid = Util.null2String(rs.getString("id"));
								keyname = Util.null2String(rs.getString("keyname"));
							
						%>
							<div class="tagitem" title="<%=keyname %>">
								<%=keyname %>
								<div class="tagdel" onclick="doDelTag(<%=keyid %>,this)" title="删除"></div>
							</div>
						<%
							}
						%>
						</div>
						<div id="tagpanel_3" class="tagpanel">
							<div style="position: absolute;left: 5px;top: 5px;width: 180px;height: 22px;background: #fff;">
								<input type="text" id="addtag_3" _index="3" style="width: 100%;border: 0px;height: 22px;line-height: 22px;margin: 0px;padding: 0px;color: #5B5B5B;"/>
							</div>
								<div id="addtagbtn_3" class="addbtn" onclick="doSaveTag(3)">添加</div>
						</div>
						<div id="tagfloat_3" class="tagfloat"></div>
					</div>
				</td>
			</tr>
		</table>
		
		<script type="text/javascript">

			$(document).ready(function() {

				$("div.tagitem").live("mouseover",function(){
					$(this).find("div.tagdel").show();
				}).live("mouseout",function(){
					$(this).find("div.tagdel").hide();
				});

				$(document).bind("keydown",function(e){
					e = e ? e : event;   
				    if(e.keyCode == 13){
						var target=$.event.fix(e).target;
						if($(target).attr("id").indexOf("addtag")==0){
				    		$("#addtagbtn_"+$(target).attr("_index")).click();
				    	}
				    }
				});

			});

			function doSaveTag(index){
				var tagstr = $.trim($("#addtag_"+index).val());
				if(tagstr!=""){
					var hastag = false;
					$("#tagdiv_"+index).find("div.tagitem").each(function(){
						if($(this).attr("title")==tagstr){
							hastag = true;
							return;
						}
					});
					if(hastag){
						$("#addtag_"+index).val("");
						return;
					}
					$.ajax({
						type: "post",
					    url: "Operation.jsp",
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    data:{"operation":"save_key","keytype":index,"keyname":filter(encodeURI(tagstr))}, 
					    complete: function(data){ 
						    var txt = $.trim(data.responseText);
						    $("#addtag_"+index).val("");
						    $("#tagdiv_"+index).append(txt);
						    var t = $("#tagpanel_"+index).position().top;
						    var l = $("#tagpanel_"+index).position().left;

						    var _t = 0;
						    var _l = 0;
						    var last = $("#tagdiv_"+index).find("div.tagitem:last");
						    if(last.length>0){
							    _t = last.position().top;
								_l = last.position().left+8;
							}
						    $("#tagfloat_"+index).html(tagstr).css({top:t,left:l}).show().animate({ top:_t,left:_l},300,null,function(){
							    $(this).hide();
							    last.css({color:'#000'});
							});
						}
				    });
				}
			}
			function doDelTag(keyid,obj){
				if(keyid!=""){
					if(confirm("确定删除此标签?")){
						$.ajax({
							type: "post",
						    url: "Operation.jsp",
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    data:{"operation":"del_key","keyid":keyid}, 
						    complete: function(data){ 
							    var txt = $.trim(data.responseText);
							    $(obj).parent().remove();
							}
					    });
					}
				}
			}

			function filter(str){
				str = str.replace(/\+/g,"%2B");
		    	str = str.replace(/\&/g,"%26");
				return str;	
			}
		</script>
	</body>
</html>
<%!
/**
 * 对金额进行四舍五入
 * @param s 金额字符串
 * @param len 小数位数
 * @return
 */
public static String round(String s,int len){
	if (s == null || s.length() < 1) {
		return "";
	}
	NumberFormat formater = null;
	double num = Double.parseDouble(s);
	if (len == 0) {
		formater = new DecimalFormat("##0");
	} else {
		StringBuffer buff = new StringBuffer();
		buff.append("##0.");
		for (int i = 0; i < len; i++) {
			buff.append("0");
		}
		formater = new DecimalFormat(buff.toString());
	}
	return formater.format(num);
}
public String getHrm(String ids) throws Exception{
	String names = "";
	ResourceComInfo rc = new ResourceComInfo();
	if(ids != null && !"".equals(ids)){
		List idList = Util.TokenizerString(ids, ",");
		for (int i = 0; i < idList.size(); i++) {
			names += "<a href='/hrm/resource/HrmResource.jsp?id="+idList.get(i)+"' target='_blank'>"
				+ rc.getResourcename((String)idList.get(i))+ "</a> ";
		}
	}
	return names;
}
%>