<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.file.FileUpload" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ page import="weaver.workflow.workflow.WFOpinionInfo" %>
<%@ page import="weaver.workflow.request.RequestOpinionBrowserInfo" %>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="RequestOpinionFieldManager" class="weaver.workflow.request.RequestOpinionFieldManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />

<LINK href="/css/remark_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
var REMARK = new Object();
REMARK.NODEDATA = new Array();
REMARK.CURRENTTYPE = null;
REMARK.MAXROWS = 4;
REMARK.ROWS_CONTAINER_HEIGHT = 247;
REMARK.SKIPEMPTY = true;
REMARK.DATA = new Object();
REMARK.TYPE = new Object();
REMARK.TYPE.HANDED = 1;
REMARK.TYPE.NOHANDED = 0;
REMARK.TYPE.ALL = 'all';
REMARK.HEIGHT = new Object();
REMARK.HEIGHT.TWOROW = 33.5;
REMARK.IMG = new Object();
REMARK.IMG.VIEWMORE_NORMAL = '<img src="/images/remark/viewmore_normal_wev8.png" />';
REMARK.IMG.VIEWMORE_HOVER = '<img src="/images/remark/viewmore_hover_wev8.png" />';

function initNodeData(allNodes) {
	for (var i = 0; i < allNodes.length; i++) {
		REMARK.NODEDATA.push(allNodes[i]);
	}
}

function initItemData(allitems) {
	if (!!allitems) {
		REMARK.DATA = {};
		for (var i = 0; i < allitems.length; i++) {
			var item = allitems[i];
			var data = REMARK.DATA[item['nodeid']];
			if (!!!data) {
				data = {};
				data['nodeid'] = item['nodeid'];
				data['nodename'] = item['nodename'];
				REMARK.DATA[item['nodeid']] = data;
			}
			var userdata = data['data'];
			if (!!!userdata) {
				userdata = {};
				userdata[REMARK.TYPE.HANDED] = '';
				userdata[REMARK.TYPE.NOHANDED] = '';				
				data['data'] = userdata;
			}
			if (!!userdata[item['handed']]) {
				userdata[item['handed']] += ' ' + item['data'];
			} else {
				userdata[item['handed']] = item['data'];
			}
		}
	}
}

function showOrHideBtnOnClick(flag) {
	var allItems = jQuery('#allItems');
	if ((allItems.css('display') == 'none' || 'true' == flag) && 'false' != flag) {
		allItems.css('display', '');
		if (REMARK.CURRENTTYPE == null) {
			handedBtnOnClick();
		}
	} else {
		allItems.css('display', 'none');
	}
}

function getUserDatas(data, type) {
	if (type != null) {
		if (REMARK.TYPE.ALL == type) {
			var userDatas = data[REMARK.TYPE.HANDED];
			if (!!userDatas) {
				userDatas += ' ' + data[REMARK.TYPE.NOHANDED];
			} else {
				userDatas = data[REMARK.TYPE.NOHANDED];
			}
			return userDatas;
		} else {
			return data[type];
		}
	}
	return '';
}

function initItems(type) {
	goBack();
	if (type != null) {
		if (type == REMARK.CURRENTTYPE) {
			return;
		}
		REMARK.CURRENTTYPE = type;
		var container = jQuery('#allItems #items');
		container.empty();
		container.height(REMARK.ROWS_CONTAINER_HEIGHT);
		var rows = 0;
		for (var index = 0; index < REMARK.NODEDATA.length; index++) {
			var nodeid = REMARK.NODEDATA[index]['id'];
			var data = REMARK.DATA[nodeid];
			if (data == null) {
				continue;
			}
			var userDatas = getUserDatas(data['data'], type);
			if (REMARK.SKIPEMPTY && userDatas === '') {
				continue;
			}
			var item = jQuery(jQuery('#item').html());
			item.css('top', 61 * rows);
			var nodename = item.find('#nodename');
			nodename.text(data['nodename']);
			nodename.attr('title', data['nodename']);
			var opnames = item.find('#opnames');
			opnames.text(userDatas);
			var select = item.find('#select').removeAttr('notbeauty');
			select.val(nodeid);
			item.jNice();
			container.append(item);
			var opnamesHeight = opnames.height();
			if (opnamesHeight > REMARK.HEIGHT.TWOROW) {
				opnames.parent().height(REMARK.HEIGHT.TWOROW);
				item.find('.ax_viewmorebtn').show();
			}
			rows++;
		}
		if (rows <= 0) {
			container.html(jQuery(jQuery('#defaultitem').html()));
			rows = 1;
		}
		jQuery('#allItems input[type="checkbox"][name="select"]').click(selectBtnOnClick);
	}
}

function allBtnOnClick() {
	jQuery('#allItems #u18').removeClass('ax_selected');
	jQuery('#allItems #u20').removeClass('ax_selected');
	jQuery('#allItems #u16').addClass('ax_selected');
	initItems(REMARK.TYPE.ALL);
	selectBtnOnClick();
}

function handedBtnOnClick() {
	jQuery('#allItems #u16').removeClass('ax_selected');
	jQuery('#allItems #u20').removeClass('ax_selected');
	jQuery('#allItems #u18').addClass('ax_selected');
	initItems(REMARK.TYPE.HANDED);
	selectBtnOnClick();
}

function nohandedBtnOnClick() {
	jQuery('#allItems #u16').removeClass('ax_selected');
	jQuery('#allItems #u18').removeClass('ax_selected');
	jQuery('#allItems #u20').addClass('ax_selected');
	initItems(REMARK.TYPE.NOHANDED);
	selectBtnOnClick();
}

function getOpt() {
	if (REMARK.CURRENTTYPE == REMARK.TYPE.HANDED) {
		return true;
	}
	if (REMARK.CURRENTTYPE == REMARK.TYPE.NOHANDED) {
		return false;
	}
	return null;
}

function okBtnOnClick() {
	var selects = jQuery('#allItems #select:checked');
	showOrHideBtnOnClick('false');
	for (var i = 0; i < selects.length; i++) {
		transtorbynode(jQuery(selects[i]).val(), getOpt());
	}
	REMARK.CURRENTTYPE = null;
}

function selectBtnOnClick() {
	var rowLength = jQuery('#allItems input[type="checkbox"][name="select"]').length;
	if (rowLength > 0) {
		changeCheckboxStatus('#allItems #selectAll', rowLength == jQuery('#allItems input[type="checkbox"][name="select"]:checked').length ? true : false);
	} else {
		changeCheckboxStatus('#allItems #selectAll', false);
	}
}

function selectAllBtnOnClick() {
	if (jQuery('#allItems #selectAll').is(':checked')) {
		jQuery("#items .opitem").each(function(){
		     jQuery(this).find("input[type=checkbox]").attr("checked","true");
			 jQuery(this).find("input[type=checkbox]").next(".jNiceCheckbox").addClass("jNiceChecked");
		});
	} else {
		jQuery("#allItems input[type='checkbox'][name='select']").each(function(){
			changeCheckboxStatus(jQuery(this), false);
		});
    }
}

function viewMore(viewMoreEle) {
	var item = jQuery(viewMoreEle).parent().parent().parent().parent();
	var opnames = item.find('#opnames').text();
	jQuery('#allItems .ax_viewmore_names').remove();
	var viewmore = jQuery('#allItems #viewmore');
	var viewmoreNames = jQuery('<div class="ax_viewmore_names"></div>');
	viewmoreNames.text(opnames);
	viewmoreNames.perfectScrollbar({horizrailenabled:false,zindex:1005});
	viewmore.append(viewmoreNames);
	viewmore.fadeIn();
	jQuery('#allItems #items').fadeOut();
}

function goBack() {
	jQuery('#allItems #items').show();
	jQuery('#allItems #viewmore').fadeOut();
}

jQuery(function() {
	jQuery('#allItems #items').perfectScrollbar({horizrailenabled:false,zindex:1000});
	jQuery("html").live('mousedown', function(e) {
		if (e.which != 1 || jQuery(e.target).parents('.remarkAllItem').length <= 0) {
			showOrHideBtnOnClick('false');
		} else {
			e.stopPropagation();
		}
	});
});
</script>
<%//调整位置请调整外部jsp的div定位， 不要调整内部位置%>

<div style="left: 0px;top: 0px;position: absolute;outline: none;z-index:1000;" class="remarkAllItem">
	<div id="allItems" style="display:none;border:1px solid #cccccc;">
		<div id="u7" style="visibility: visible;">
        	<div class="panel_state" id="u7_state0" style="width: 380px;">
				<div class="panel_state_content" id="u7_state0_content">

		            <div class="ax_xz ax_title">
		              <div class="text" id="u9">
		                <p><span>选择节点参与人作为转发对象</span></p>
		              </div>
		            </div>

		            <div class="ax_xz ax_control">
		              <div class="text" id="u11"></div>
		            </div>
		
		            <div class="ax_pic" id="u12" style="">
		              <img src="/images/remark/u68_wev8.png" class="img " id="u12_img">
		            </div>

		            <div class="ax_all ax_noselected" id="u16" style="color: #242424;">
		            	<span style="cursor: pointer;" onclick="allBtnOnClick()"><b>全部</b></span>
		            </div>

					<div class="ax_all_next">
		              <div class="text">
		                <p><span>|</span></p>
		              </div>
		            </div>

		            <div class="ax_handed ax_noselected" id="u18" style="color: #242424;">
		            	<span style="cursor: pointer;" onclick="handedBtnOnClick()"><b>已操作</b></span>
		            </div>

	            	<div class="ax_handed_next">
		              <div class="text">
		                <p><span>|</span></p>
		              </div>
		            </div>

		            <div class="ax_nohanded ax_noselected" id="u20" style="color: #242424;">
		            	<span style="cursor: pointer;" onclick="nohandedBtnOnClick()"><b>未操作</b></span>
		            </div>

		            <div class="ax_selectall_checkbox" tabindex="0" style="cursor: pointer;">
		              <div class="panel_state" id="u88_state0" style="width: 14px; height: 14px;">
		                <div class="panel_state_content" id="u88_state0_content">
		                  <div class="ax_pic" id="u89" style="">
		                    <input type="checkbox" id="selectAll" name="selectAll" onclick="selectAllBtnOnClick()" />
		                    <div class="text" id="u90"></div>
		                  </div>
		                </div>
		              </div>
		            </div>

		            <div class="ax_ok" style="z-index:1010;">
						<table width="100%" height="100%">
							<tbody>
								<tr>
									<td style="text-align:center;vertical-align: middle;">
										<input class="zd_btn_submit" type="button" onclick="okBtnOnClick();" value="<%=SystemEnv.getHtmlLabelName(83446,user.getLanguage())%>" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>

		            <div class="ax_selectall">
		            	<span><b><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%></b></span>
		            </div>

		            <div id="items" class="opitems">		            		
		            </div>

		            <div id="viewmore" class="ax_viewmore" style="z-index:1005;display:none;">
		            	<div class="ax_goback" title="<%=SystemEnv.getHtmlLabelName(83823,user.getLanguage())%>" onclick="goBack();"></div>	            		
		            </div>
				</div>
			</div>
		</div>			
	</div>

	<div id="item" style="display: none;">
		<div class="opitem">
			<div class="ax_xz ax_row">
				<table>
					<tr>
						<td>
							<div class="ax_select">
								<input type="checkbox" id="select" name="select" notbeauty=true />
							</div>
						</td>
						<td class="padding">
							<div class="ax_row_node ellipsis">
								<span id="nodename" class="ellipsis"></span>
							</div>
						</td>
						<td class="padding">
							<div class="ax_row_user">
								<span id="opnames"></span>
							</div>
						</td>
						<td>
							<div class="ax_viewmorebtn" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>" onclick="viewMore(this);" style="display:none;"></div>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>

	<div id="defaultitem" style="display: none;">
		<div class="ax_row">
			<div class="defaultitem">
				<span><%=SystemEnv.getHtmlLabelName(83781,user.getLanguage())%></span>
			</div>
		</div>
	</div>
</div>