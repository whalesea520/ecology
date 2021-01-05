<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
   String correspondField = Util.null2String(request.getParameter("correspondField"));
    String isbill = Util.null2String(request.getParameter("isbill"));
    String subCompanyFieldSql = Util.null2String(request.getParameter("subCompanyFieldSql"));
    String yearFieldSql = Util.null2String(request.getParameter("yearFieldSql"));
    String monthFieldSql = Util.null2String(request.getParameter("monthFieldSql"));
    String departmentFieldSql = Util.null2String(request.getParameter("departmentFieldSql"));
    String dateFieldSql = Util.null2String(request.getParameter("dateFieldSql"));
    String selectFieldSql = Util.null2String(request.getParameter("selectFieldSql"));
    String selectCorrespondField = Util.null2String(request.getParameter("selectCorrespondField"));
    String correspondDate = Util.null2String(request.getParameter("correspondDate"));
    int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")));
    int tempFieldId = Util.getIntValue(Util.null2String(request.getParameter("tempFieldId")));
    int wfid = Util.getIntValue(Util.null2String(request.getParameter("wfid")));
    boolean canEdit = "true".equals(Util.null2String(request.getParameter("canEdit")));


%>

<script type="text/javascript">
    var colors = new Array("#4F81BD", "#4F81BD", "#4F81BD", "#4F81BD", "#4F81BD");
    var colors1 = new Array("#C0504D", "#C0504D", "#C0504D", "#C0504D", "#C0504D");
    jQuery(document).ready(function () {
        load();
        <%if (canEdit){%>
        registerDragEvent();
        jQuery("tr.notMove").bind("mousedown", function () {
            return false;
        });
        <%}%>
        var isLastSelectS = getLastSelectS();
        var isLastMechS = getLastMechS();
        var isLastDataS = getLastDataS();
        if (isLastSelectS == 0) {
            hideEle("trFieldSequenceShow");
            jQuery("#sltCorrespondField").empty();
        } else {
            var dateSeqselect = jQuery("#sltCorrespondField").val();
            addSltField(dateSeqselect);
        }
        if (isLastMechS == 0) {
            jQuery("#struSeqselect").empty();
            hideEle("struSequenceShow");
        } else {
            var struSeqselect = jQuery("#struSeqselect").val();
            addStruField(struSeqselect);
        }
        if (isLastDataS == 0) {
            jQuery("#dateSeqselect").empty();
            hideEle("dateSequenceShow");
        } else {
            var dateSeqselect = jQuery("#dateSeqselect").val();
            addDateField(dateSeqselect);
        }
    });

    function changeCurrentDate() {
        var dateSeqselect = jQuery("#dateSeqselect").val();
        addDateField(dateSeqselect);
    }

    function changeCurrentField() {
        var struSeqselect = jQuery("#struSeqselect").val();
        addStruField(struSeqselect);
    }

    function changeSltCurrentField() {
        var struSeqselect = jQuery("#sltCorrespondField").val();
        addSltField(struSeqselect);
    }


    function addSltField(sltSeqselect) {
        var allordereles = null;
        if (!sltSeqselect) return;
        allordereles = jQuery("select[name^=selectField_]");
        var oldval = jQuery("#sltCorrespondField").val();
        jQuery("#sltCorrespondField").selectbox("detach");
        jQuery("#sltCorrespondField").empty();
        var option = "";
        allordereles.each(function (i, e) {
            var dataval = $(e).val();
            var datatext = $(e).find("option:selected").text();
            if (oldval == dataval || dataval == "<%=selectCorrespondField %>") {
                option += "<option value='" + dataval + "' selected >" + datatext + "</option>";
            } else {
                option += "<option value='" + dataval + "'>" + datatext + "</option>";
            }
        });
        jQuery("#sltCorrespondField").append(option);
        jQuery("#sltCorrespondField").selectbox("attach");
    }

    function addDateField(dateSeqselect) {
        var allordereles = null;
        if (!dateSeqselect) return;
        if (dateSeqselect == "1") {
            allordereles = jQuery("select[name^=selectYear_]");
        }
        if (dateSeqselect == "2") {
            allordereles = jQuery("select[name^=selectMonth_]");
        }
        if (dateSeqselect == "3") {
            allordereles = jQuery("select[name^=selectDay_]");
        }
        jQuery("#dateCorrespondField").selectbox("detach");
        jQuery("#dateCorrespondField").empty();
        var option = "";
        allordereles.each(function (i, e) {
            var dataval = $(e).val();
            var datatext = $(e).find("option:selected").text();
            if (dataval == "<%=correspondDate%>") {
                option += "<option value='" + dataval + "' selected >" + datatext + "</option>";
            } else {
                option += "<option value='" + dataval + "'>" + datatext + "</option>";
            }
        });
        jQuery("#dateCorrespondField").append(option);
        jQuery("#dateCorrespondField").selectbox("attach");
    }

    function addStruField(struSeqselect) {
        var allordereles = null;
        if (!struSeqselect) return;
        if (struSeqselect == "3") {
            allordereles = jQuery("select[name^=selectDept_]");
        }
        if (struSeqselect == "2") {
            allordereles = jQuery("select[name^=selectSub_]");
        }
        if (struSeqselect == "1") {
            allordereles = jQuery("select[name^=selectSupSub_]");
        }
        jQuery("#struCorrespondField").selectbox("detach");
        jQuery("#struCorrespondField").empty();
        var option = "";
        allordereles.each(function (i, e) {
            var dataval = $(e).val();
            var datatext = $(e).find("option:selected").text();
            if (dataval == "<%=correspondField%>") {
                option += "<option value='" + dataval + "' selected >" + datatext + "</option>";
            } else {
                option += "<option value='" + dataval + "'>" + datatext + "</option>";
            }
        });
        jQuery("#struCorrespondField").append(option);
        jQuery("#struCorrespondField").selectbox("attach");
    }

    function toShowGroup(obj) {
        var isChecked = obj.checked;
        if (isChecked) {
            showGroup("groupShow");
            showEle("itemShow");
            showItemAreaNew();
        } else {
            hideGroup("groupShow");
            hideEle("itemShow");
        }
    }

    function showItemAreaNew() {
        var tr = jQuery(".groupHeadHide").closest("tr.groupHeadHide");
        if (tr.length > 0) {
            tr.attr("_show", "true");
            tr.click();
        }
    }

    function clickPrompt() {
        var ischeck = jQuery("input[name=workflowSeqAlone]").attr("checked");

        if (!ischeck) {
            top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(129507, user.getLanguage())%>", function () {
                jQuery("input[name=workflowSeqAlone]").val("0");
            }, function () {
                jQuery("input[name=workflowSeqAlone]").val("1");
                jQuery("input[name=workflowSeqAlone]").attr("checked", true);
                changeSwitchStatus(jQuery("input[name=workflowSeqAlone]"), true);
            }, 320, 90, true);
        } else {
            jQuery("input[name=workflowSeqAlone]").val("1");
        }
    }

    function registerDragEvent() {
        var fixHelper = function (e, ui) {
            ui.children().each(function () {
                $(this).width($(this).width());     //在拖动时，拖动行的cell（单元格）宽度会发生改变。在这里做了处理就没问题了

                $(this).height($(this).height());
            });
            return ui;
        };

        var copyTR = null;
        var startIdx = 0;

        jQuery("#codeRule tbody tr").bind("mousedown", function (e) {
            copyTR = jQuery(this).next("tr.Spacing");
        });

        jQuery("#codeRule tbody tr").bind("mouseover", function (e) {
            showMoveIcon(this);
        });

        jQuery("#codeRule tbody tr").bind("mouseout", function (e) {
            hideMoveIcon(this);
        });

        jQuery("#codeRule tbody").sortable({                //这里是talbe tbody，绑定 了sortable
            helper: fixHelper,                  //调用fixHelper
            axis: "y",
            start: function (e, ui) {
                ui.helper.addClass("e8_hover_tr")     //拖动时的行，要用ui.helper
                if (ui.item.hasClass("notMove")) {
                    e.stopPropagation();
                }
                if (copyTR) {
                    copyTR.hide();
                }
                startIdx = ui.item.get(0).rowIndex;
                return ui;
            },
            stop: function (e, ui) {
                ui.item.removeClass("e8_hover_tr"); //释放鼠标时，要用ui.item才是释放的行
                if (copyTR) {
                    if (ui.item.get(0).rowIndex > startIdx) {
                        ui.item.before(copyTR.clone().show());
                    } else {
                        ui.item.after(copyTR.clone().show());
                    }
                    copyTR.remove();
                    copyTR = null;
                    proView();
                }
                return ui;
            }
        });
    }

    function beforeSeqSave(obj) {
        jQuery("#wfconcrete").val(obj);
        onSave();
        frmCoder.target = "wfcodeframe";
        frmCoder.submit();
    }

    function openDialogBeforSave(obj) {
        var wfconcrete = jQuery(obj).parent().parent().parent().find("td::eq(0)").attr("concrete");
        var wfcodevalue = jQuery(obj).parent().parent().find("select[name^=select]").val();
        jQuery("#wfconcrete").val(wfconcrete);
        jQuery("#wfcodevalue").val(wfcodevalue);
        onSave();
        frmCoder.target = "wfcodeframe";
        frmCoder.submit();
    }

    function flowCodeSave(obj) {
        obj.disabled = true;
        onSave();
        jQuery("#wfconcrete").val("");
        frmCoder.target = "wfcodeframe";
        jQuery("#frmCoder").removeAttr("target");
        frmCoder.submit();
    }

    function onSave() {
        // obj.disabled=true;
        var postValueStr = "";
        jQuery("tr[customer1]").each(function (index, obj) {
            var codeTitle = $(obj).find("td::eq(0)").attr("codevalue");
            codeTitle = jQuery.trim(codeTitle);
            var codeTypeTag = "";   //checkbox input div
            var codeTypeTr = $(obj).find("td::eq(1)").children(":first");
            if (codeTypeTr) {
                codeTypeTag = codeTypeTr.attr("tagName");
            }
            var codeValue;
            var codeType;
            var codeSelect = "";

            var concrete = $(obj).find("td::eq(0)").attr("concrete")
            concrete = jQuery.trim(concrete);

            if (codeTypeTag == "INPUT") {
                codeValue = $(obj).find("td::eq(1)").children(":first").val();
                if ($(obj).find("td::eq(1)").children(":first").attr("type") == "text") {
                    //var isincode =  $(obj).find("td::eq(1)").children(":first").attr("isShowCode");
                    codeValue = $(obj).find("td::eq(1)").children(":first").val();
                    if (codeValue == "") codeValue = "[(*_*)]";
                    codeType = 2
                    if (codeSelect == "")
                        codeSelect = "[(*_*)]";
                } else if ($(obj).find("td::eq(1)").children(":first").attr("type") == "checkbox") {
                    codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked") == true ? "1" : "0";
                    codeType = 1      //input
                    var selectObjs = $(obj).find("td::eq(1)").find("select");
                    if (selectObjs.length >= 1) {
                        codeType = 3   //year
                        codeValue = codeValue + "|" + $(selectObjs).find(":first").val();
                    }
                    if (codeSelect == "")
                        codeSelect = "[(*_*)]";
                }
            } else if (codeTypeTag == "SELECT") {
                //var isincode =  $(obj).find("td::eq(1)").children(":first").attr("isShowCode");
                codeValue = $(obj).find("td::eq(1)").children(":first").val();

                if ($(obj).find("td::eq(1)").children().length == 8 || $(obj).find("td::eq(1)").children().length == 10) {
                    codeSelect = $(obj).find("td::eq(1)").children().eq(2).val();
                }
                if (codeSelect == "") {
                    codeSelect = "[(*_*)]";
                }
                //if(isincode == "0"){
                //	codeValue = "-1";
                //}
                codeType = 5;
            }
            postValueStr += codeTitle + "\u001b" + codeValue + "\u001b" + codeSelect + "\u001b" + concrete + "\u001b" + codeType + "\u0007";
        })

        postValueStr = postValueStr.substring(0, postValueStr.length - 1);
        jQuery("#postValue").val(postValueStr);
    }

    function load() {  //检查Imag的状态

        var img_ups = document.getElementsByName("img_up");
        for (var index_up = 0; index_up < img_ups.length; index_up++) {
            var img_up = img_ups[index_up];
            if (index_up == 0) {
                img_up.style.visibility = 'hidden';
                img_up.style.width = 0;
            }
            else {
                img_up.style.visibility = 'visible';
                img_up.style.width = 10;
            }
        }

        var img_downs = document.getElementsByName("img_down");
        for (var index_down = 0; index_down < img_downs.length; index_down++) {
            var img_down = img_downs[index_down];
            if (index_down == img_downs.length - 1) {
                img_down.style.visibility = 'hidden';
                img_down.style.width = 0;
            }

            else {
                img_down.style.visibility = 'visible';
                img_down.style.width = 10;
            }
        }
        //onHideInput();
        proView();

//  jQuery("tr[customer1]").hover(function () {
//		 var objadd = $(this).find("input[name = 'addInputCol']");
//		 var objdel = $(this).find("input[name = 'deleteInputCol']");
//		 var isshow = $(this).find("td::eq(0)").text()+"";
//		 isshow = $.trim(isshow);
//		 var bl = false;
//		 jQuery("#TR_pro").children("td").each(function(index,obj){
//			 var codeTitle = $(obj).find("td::eq(0)").text()+"";
//			 if(codeTitle == isshow){
//				 bl = true;
//				 return;
//			 }else{
//			 }
//		 });
//		 if(bl){
//			 objdel.show();
//		 }else{
//			 objadd.show();
//		 }
//  }, function () {
//	  $(this).find("input[name = 'addInputCol']").hide();//隐藏
//	  $(this).find("input[name = 'deleteInputCol']").hide();//隐藏
//  });
    }

    function proView() {
        var TR_doc = jQuery("#TR_pro");
        jQuery(TR_doc).children("td").remove();
        jQuery("tr[customer1]").each(function (index, obj) {
            var codeTitle = $(obj).find("td::eq(0)").text()
            codeTitle = jQuery.trim(codeTitle)
            var codeTypeTag = $(obj).find("td::eq(1)").children(":first").attr("tagName")
            var codeValue;
            if (codeTypeTag == "INPUT") {
                codeValue = $(obj).find("td::eq(1)").children(":first").val();

                if ($(obj).find("td::eq(1)").children(":first").attr("type") == "text") {
                    codeValue = $(obj).find("td::eq(1)").children(":first").val();
                } else if ($(obj).find("td::eq(1)").children(":first").attr("type") == "checkbox") {
                    codeValue = $(obj).find("td::eq(1)").children(":first").attr("checked") == true ? "1" : "0";
                }
            }
            else if (codeTypeTag == "DIV") {
                codeValue = $(obj).find("td::eq(1)").children(":first").text();
            } else if (codeTypeTag == "SELECT") {

                //objSelect=TR_member.childNodes[1].firstChild;
                codeValue = $(obj).find("td::eq(1)").children(":first").find("option:selected").text();
                //alert("codeValueselect = "+codeValue);
            }
            //var isincode =  $(obj).find("td::eq(1)").children(":first").attr("isShowCode");
            //if(isincode == "1"){
            if (codeTypeTag == "INPUT" || codeTypeTag == "SELECT" || codeTypeTag == "DIV" && codeValue != "不使用") {
                if (codeTypeTag == "INPUT") {
                    if ($(obj).find("td::eq(1)").children(":first").attr("type") == "checkbox" && codeValue == "0") {
                        return true;
                    } else if ($(obj).find("td::eq(1)").children(":first").attr("type") == "checkbox" && codeValue == "1") {
                        var selectObjs = $(obj).find("td::eq(1)").find("select");
                        if (selectObjs.length >= 1) {
                            if ($(selectObjs).find(":first").val() == "0") codeValue = "**";
                            else codeValue = "****";
                        }
                    }
                }

                var tempTd = document.createElement("TD");
                var tempTable = document.createElement("TABLE");
                jQuery(tempTable).css("border", "1px solid #0070C0");
                jQuery(tempTable).css("border-right", "none");
                //jQuery(tempTable).css("border-left","1px solid #0070C0");
                var newRow = tempTable.insertRow(-1);
                var newRowMiddle = tempTable.insertRow(-1);
                var newRow1 = tempTable.insertRow(-1);


                var newCol = newRow.insertCell(-1);
                var newColMiddle = newRowMiddle.insertCell(-1);
                var newCol1 = newRow1.insertCell(-1);

                jQuery(newRowMiddle).css("height", "1px");
                jQuery(newRowMiddle).css("background-color", "#0070C0");
                jQuery(newRowMiddle).css("background-repeat", "repeat-x");
                //newColMiddle.className="Line";
                newCol.innerHTML = "<font color=" + colors[index % 5] + ">" + codeTitle + "</font>";
                if (codeValue == "1") {
                    codeValue = "****";
                } else if (codeValue == "0") {
                    codeValue = "**";
                }
                newCol1.innerHTML = "<font color=" + colors1[index % 5] + ">" + codeValue + "</font>";
                //alert(codeValue);
//	        if(codeValue != null && codeValue != ""){
                jQuery(tempTd).append(tempTable);
                //tempTd.appendChild(tempTable);
                jQuery(TR_doc).append(tempTd);
                //TR_doc.appendChild(tempTd);
//	        }
                //}
            }
        })
    }

    function addNewCol() {
        var url = "/workflow/workflow/WFCodeAdd.jsp?wfid=<%=wfid%>";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.callbackfun = function (paramobj, data) {
            if (data) {
                var manifestation = data.manifestation;
                var fieldType = data.fieldType;
                var fieldValue = data.fieldValue;
                var fieldtext = data.fieldtext;
                if (manifestation == "1") {
                    if (fieldType == "1" && hasSelect("1", fieldtext)) {//部门
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else if (fieldType == "2" && hasSelect("2", fieldtext)) {//分部
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else if (fieldType == "3" && hasSelect("3", fieldtext)) {//上级分部
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else {
                        addSelectCol(manifestation, fieldType, fieldValue);
                    }
                }

                if (manifestation == "2") {
                    if (hasSelect("0", fieldtext)) {//选择框

                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else {
                        addSelectCol(manifestation, fieldType, fieldValue);
                    }
                }

                if (manifestation == "3") {
                    if (fieldType == "4") {
                        if (hasThreeSelect()) {
                            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129511, user.getLanguage())%>");
                            return false;
                        } else {
                            //zzw 2016-11-21 QC:233516
                            addThreeSelectCol();
                            changeCurrentDate();
                        }
                    } else if (fieldType == "5" && hasSelect("5", fieldtext)) {
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else if (fieldType == "6" && hasSelect("6", fieldtext)) {
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else if (fieldType == "7" && hasSelect("7", fieldtext)) {
                        top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
                        return false;
                    } else {
                        addSelectCol(manifestation, fieldType, fieldValue);
                        changeCurrentDate();
                    }
                }
            }
            proView();
        };
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>";
        dialog.Width = 550;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
        //if (window.event) {
        //	window.event.cancelBubble = true;
        //}else{
        //	event.stopPropagation();
        //}
    }

    function hasSelect(fieldType, fieldtext) {
        var hasAready = false;
        var allorders = new Array();
        var allordereles = null;
        if (fieldType == null) reurn;
        if (fieldType == "0") {
            allordereles = jQuery("select[name^=selectField_]");
        } else if (fieldType == "1") {
            allordereles = jQuery("select[name^=selectDept_]");
        } else if (fieldType == "2") {
            allordereles = jQuery("select[name^=selectSub_]");
        } else if (fieldType == "3") {
            allordereles = jQuery("select[name^=selectSupSub_]");
        } else if (fieldType == "5") {
            allordereles = jQuery("select[name^=selectYear_]");
        } else if (fieldType == "6") {
            allordereles = jQuery("select[name^=selectMonth_]");
        } else if (fieldType == "7") {
            allordereles = jQuery("select[name^=selectDay_]");
        }
        allordereles.each(function (i, e) {
            allorders.push($(e).find("option:selected").text());
        });
        if (allorders.contains(fieldtext)) {
            hasAready = true;
        }
        return hasAready;
    }

    function hasThreeSelect() {
        var hasAready = false;
        var allorders = new Array();
        var allordereles0 = jQuery("select[name^=selectYear_]");
        var allordereles1 = jQuery("select[name^=selectMonth_]");
        var allordereles2 = jQuery("select[name^=selectDay_]");
        allordereles0.each(function (i, e) {
            allorders.push($(e).find("option:selected").text());
        });
        allordereles1.each(function (i, e) {
            allorders.push($(e).find("option:selected").text());
        });
        allordereles2.each(function (i, e) {
            allorders.push($(e).find("option:selected").text());
        });
        if (allorders.contains("当前年份") || allorders.contains("当前月份") || allorders.contains("当前日期")) {
            hasAready = true;
        }
        return hasAready;
    }

    function addThreeSelectCol() {
        for (var s = 5; s < 8; s++) {
            var oTable = $G("codeRule");
            //var ncol = oTable.rows[0].cells.length;
            var ncol = 2;
            var oRow = oTable.insertRow(-1);
            oRow.style.height = 24;
            oRow.setAttribute("customer1", "member");
            var nextYearnum = getNextYearNum();
            var nextMonthnum = getNextMonthNum();
            var nextDaynum = getNextDayNum();
            for (var j = 0; j < ncol; j++) {
                var oCell = oRow.insertCell(j);
                oCell.style.height = 24;
                switch (j) {
                    case 0:
                        oCell.setAttribute("class", "fieldName");
                        oCell.colSpan = 1;
                        var sHtml = "<span movingicon style='display:inline-block;width:20px;'><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>";
                        if (s == "5") {
                            oCell.setAttribute("codevalue", nextYearnum);
                            oCell.setAttribute("concrete", "4");
                            sHtml += " <%=SystemEnv.getHtmlLabelName(445, user.getLanguage()) %>";
                        } else if (s == "6") {
                            oCell.setAttribute("codevalue", nextMonthnum);
                            oCell.setAttribute("concrete", "5");
                            sHtml += " <%=SystemEnv.getHtmlLabelName(6076, user.getLanguage()) %>";
                        } else if (s == "7") {
                            oCell.setAttribute("codevalue", nextDaynum);
                            oCell.setAttribute("concrete", "6");
                            sHtml += " <%=SystemEnv.getHtmlLabelName(390, user.getLanguage()) %>";
                        } else {
                            return;
                        }
                        oCell.innerHTML = sHtml;
                        break;
                    case 1:
                        oCell.setAttribute("class", "field");
                        oCell.colSpan = 2;
                        var codeMValue = "-1";
                        ;

                        if (s == "5") {
                            var sHtml = "<select class='inputstyle' name='selectYear_" + nextYearnum + "' onchange='checkselect(5,this)'>";
                            <%
                            RecordSet.executeSql(yearFieldSql);
                            while(RecordSet.next()){
                            tempFieldId = RecordSet.getInt("ID");
                            %>
                            sHtml += "<option value='<%=tempFieldId%>' ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                            <%}%>
                            sHtml += "<option value='-2' selected ><%=SystemEnv.getHtmlLabelName(22793, user.getLanguage()) %></option>";
                            sHtml += "</select>";
                            sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                            sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                            sHtml += "<input type='hidden'  name='selectNum5' value='" + nextYearnum + "' >";
                        } else if (s == "6") {
                            var sHtml = "<select class='inputstyle' name='selectMonth_" + nextMonthnum + "' onchange='checkselect(6,this)'>";
                            <%
                            RecordSet.executeSql(monthFieldSql);
                            while(RecordSet.next()){
                            tempFieldId = RecordSet.getInt("ID");
                            %>
                            sHtml += "<option value='<%=tempFieldId%>' ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                            <%}%>
                            sHtml += "<option value='-2' selected ><%=SystemEnv.getHtmlLabelName(22794, user.getLanguage()) %></option>";
                            sHtml += "</select>";
                            sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                            sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                            sHtml += "<input type='hidden'  name='selectNum6' value='" + nextMonthnum + "' >";
                        } else if (s == "7") {
                            var sHtml = "<select class='inputstyle' name='selectDay_" + nextDaynum + "' onchange='checkselect(7,this)'>";
                            <%
                            RecordSet.executeSql(dateFieldSql);
                            while(RecordSet.next()){
                            tempFieldId = RecordSet.getInt("ID");
                            %>
                            sHtml += "<option value='<%=tempFieldId%>' ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                            <%}%>
                            sHtml += "<option value='-2' selected ><%=SystemEnv.getHtmlLabelName(15625, user.getLanguage()) %></option>";
                            sHtml += "</select>";
                            sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                            sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                            sHtml += "<input type='hidden'  name='selectNum7' value='" + nextDaynum + "' >";
                        } else {
                            return;
                        }
                        oCell.innerHTML = sHtml;
                        break;
                }
            }
            beautySelect();


            addline();
            jQuery(oRow).bind("mouseover", function (e) {
                showMoveIcon(this);
            });

            jQuery(oRow).bind("mouseout", function (e) {
                hideMoveIcon(this);
            });
        }
        jQuery("#dateSeqselect").selectbox("detach");
        jQuery("#dateSeqselect").empty();
        var option = "<option value='3'><%=SystemEnv.getHtmlLabelName(390, user.getLanguage()) %></option>";
        option += "<option value='2'><%=SystemEnv.getHtmlLabelName(6076, user.getLanguage()) %></option>";
        option += "<option value='1'><%=SystemEnv.getHtmlLabelName(445, user.getLanguage()) %></option>";
        jQuery("#dateSeqselect").append(option);
        jQuery("#dateSeqselect").selectbox("attach");
    }

    function addSelectCol(manifestation, fieldType, fieldValue) {
        var oTable = $G("codeRule");
        //var ncol = oTable.rows[0].cells.length;
        var ncol = 2;
        var oRow = oTable.insertRow(-1);
        oRow.style.height = 24;
        oRow.setAttribute("customer1", "member");
        for (j = 0; j < ncol; j++) {
            var oCell = oRow.insertCell(j);
            oCell.style.height = 24;
            switch (j) {
                case 0:
                    oCell.setAttribute("class", "fieldName");
                    oCell.colSpan = 1;
                    var sHtml = "<span movingicon style='display:inline-block;width:20px;'><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>";
                    if (manifestation == "2") {
                        var nextnum = getNextSelNum();
                        oCell.setAttribute("codevalue", nextnum);//选择框

                        oCell.setAttribute("concrete", "0");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(22755, user.getLanguage()) %>";
                    } else if (manifestation == "1" && fieldType == "1") {
                        var nextnum = getNextDeptNum();
                        oCell.setAttribute("codevalue", nextnum);//部门
                        oCell.setAttribute("concrete", "1");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(124, user.getLanguage()) %>";
                        //在机构单独流水中添加部门选项
                        if (!getSelectItem("1")) {
                            jQuery("#struSeqselect").selectbox("detach");
                            //jQuery("#struSeqselect option[value='3']").remove();
                            var option = "<option value='3'><%=SystemEnv.getHtmlLabelName(124, user.getLanguage()) %></option>";
                            jQuery("#struSeqselect").append(option);
                            jQuery("#struSeqselect").selectbox("attach");
                        }
                    } else if (manifestation == "1" && fieldType == "2") {
                        var nextnum = getNextSubNum();
                        oCell.setAttribute("codevalue", nextnum);//分部
                        oCell.setAttribute("concrete", "2");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(141, user.getLanguage()) %>";
                        //在机构单独流水中添加分部选项
                        if (!getSelectItem("2")) {
                            jQuery("#struSeqselect").selectbox("detach");
                            //jQuery("#struSeqselect option[value='2']").remove();
                            var option = "<option value='2'><%=SystemEnv.getHtmlLabelName(141, user.getLanguage()) %></option>";
                            jQuery("#struSeqselect").append(option);
                            jQuery("#struSeqselect").selectbox("attach");
                        }
                    } else if (manifestation == "1" && fieldType == "3") {
                        var nextnum = getNextSupSubNum();
                        oCell.setAttribute("codevalue", nextnum);//上级分部
                        oCell.setAttribute("concrete", "3");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(22753, user.getLanguage()) %>";
                        //在机构单独流水中添加上级分部选项
                        if (!getSelectItem("3")) {
                            jQuery("#struSeqselect").selectbox("detach");
                            //jQuery("#struSeqselect option[value='1']").remove();
                            var option = "<option value='1'><%=SystemEnv.getHtmlLabelName(22753, user.getLanguage()) %></option>";
                            jQuery("#struSeqselect").append(option);
                            jQuery("#struSeqselect").selectbox("attach");
                        }
                    } else if (manifestation == "3" && fieldType == "5") {
                        var nextnum = getNextYearNum();
                        oCell.setAttribute("codevalue", nextnum);//年

                        oCell.setAttribute("concrete", "4");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(445, user.getLanguage()) %>";
                        //在日期单独流水中添加年选项
                        if (!getSelectItem("5")) {
                            jQuery("#dateSeqselect").selectbox("detach");
                            //jQuery("#dateSeqselect option[value='1']").remove();
                            var option = "<option value='1'><%=SystemEnv.getHtmlLabelName(445, user.getLanguage()) %></option>";
                            jQuery("#dateSeqselect").append(option);
                            jQuery("#dateSeqselect").selectbox("attach");
                        }
                    } else if (manifestation == "3" && fieldType == "6") {
                        var nextnum = getNextMonthNum();
                        oCell.setAttribute("codevalue", nextnum);//月

                        oCell.setAttribute("concrete", "5");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(6076, user.getLanguage()) %>";
                        //在日期单独流水中添加月选项
                        if (!getSelectItem("6")) {
                            jQuery("#dateSeqselect").selectbox("detach");
                            //jQuery("#dateSeqselect option[value='2']").remove();
                            var option = "<option value='2'><%=SystemEnv.getHtmlLabelName(6076, user.getLanguage()) %></option>";
                            jQuery("#dateSeqselect").append(option);
                            jQuery("#dateSeqselect").selectbox("attach");
                        }
                    } else if (manifestation == "3" && fieldType == "7") {
                        var nextnum = getNextDayNum();
                        oCell.setAttribute("codevalue", nextnum);//日

                        oCell.setAttribute("concrete", "6");
                        sHtml += " <%=SystemEnv.getHtmlLabelName(390, user.getLanguage()) %>";
                        //在日期单独流水中添加日选项
                        if (!getSelectItem("7")) {
                            jQuery("#dateSeqselect").selectbox("detach");
                            //jQuery("#dateSeqselect option[value='3']").remove();
                            var option = "<option value='3'><%=SystemEnv.getHtmlLabelName(390, user.getLanguage()) %></option>";
                            jQuery("#dateSeqselect").append(option);
                            jQuery("#dateSeqselect").selectbox("attach");
                        }
                    } else {
                        return;
                    }
                    oCell.innerHTML = sHtml;
                    break;
                case 1:
                    oCell.setAttribute("class", "field");
                    oCell.colSpan = 2;
                    var codeMValue = "-1";
                    ;
                    if (manifestation == "2") {//选择框

                        var nextnum = getNextSelNum();
                        var sHtml = "<select class='inputstyle' name='selectField_" + nextnum + "' onchange='checkselect(0,this)'>";
                        <%
                        RecordSet.executeSql(selectFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "</select>";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<span id=\"selectSpan\" name=\"selectSpan\">";
                        sHtml += "<button type=\"button\"  class=\"e8_btn_top middle\" style=\"border:1px solid #aecef1 !important\" onclick=\"openDialogBeforSave(this);\" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>";
                        sHtml += "</span>";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum0' value='" + nextnum + "' >";
                    } else if (manifestation == "1" && fieldType == "1") {//部门
                        var nextnum = getNextDeptNum();
                        var sHtml = "<select class='inputstyle' name='selectDept_" + nextnum + "' onchange='checkselect(1,this)'>";
                        <%
                        RecordSet.executeSql(departmentFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "<option value='-2' ";
                        if (fieldValue == "1") {
                            sHtml += "selected ";
                        }
                        sHtml += "><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage()) %></option>";
                        sHtml += "</select>";
                        //sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<select class=inputstyle id='deptselect" + nextnum + "' name='deptselect" + nextnum + "' onchange='changedept(" + nextnum + ")'>";
                        sHtml += "<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>";
                        sHtml += "<option value=1><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>";
                        sHtml += "</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<span id='deptspan" + nextnum + "' name='deptspan" + nextnum + "' > ";
                        sHtml += "<button type=\"button\"  class=\"e8_btn_top middle\" style=\"border:1px solid #aecef1 !important\" onclick=\"openDialogBeforSave(this);\" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>";
                        sHtml += "</span> ";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum1' value='" + nextnum + "' >";
                    } else if (manifestation == "1" && fieldType == "2") {//分部
                        var nextnum = getNextSubNum();
                        var sHtml = "<select class='inputstyle' name='selectSub_" + nextnum + "' onchange='checkselect(2,this)'>";
                        <%
                        RecordSet.executeSql(subCompanyFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "<option value='-2' ";
                        if (fieldValue == "4") {
                            sHtml += "selected ";
                        }
                        sHtml += "><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage()) %></option>";
                        sHtml += "</select>";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<select class=inputstyle id='subselect" + nextnum + "' name='subselect" + nextnum + "' onchange='changesub(" + nextnum + ")'>";
                        sHtml += "<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>";
                        sHtml += "<option value=1><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>";
                        sHtml += "</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<span id='subComspan" + nextnum + "' name='subComspan" + nextnum + "' > ";
                        sHtml += "<button type=\"button\"  class=\"e8_btn_top middle\" style=\"border:1px solid #aecef1 !important\" onclick=\"openDialogBeforSave(this);\" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>";
                        sHtml += "</span> ";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum2' value='" + nextnum + "' >";
                    } else if (manifestation == "1" && fieldType == "3") {//上级分部
                        var nextnum = getNextSupSubNum();
                        var sHtml = "<select class='inputstyle' name='selectSupSub_" + nextnum + "' onchange='checkselect(3,this)'>";
                        <%
                        RecordSet.executeSql(subCompanyFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "<option value='-2' ";
                        if (fieldValue == "7") {
                            sHtml += "selected ";
                        }
                        sHtml += "><%=SystemEnv.getHtmlLabelName(22787, user.getLanguage()) %></option>";
                        sHtml += "</select>";
                        sHtml += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<%=SystemEnv.getHtmlLabelName(15935,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<select class=inputstyle id='supselect" + nextnum + "' name='supselect" + nextnum + "' onchange='changesup(" + nextnum + ")'>";
                        sHtml += "<option value=0><%=SystemEnv.getHtmlLabelName(22764,user.getLanguage())%></option>";
                        sHtml += "<option value=1><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>";
                        sHtml += "</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        sHtml += "<span id='supSubspan" + nextnum + "' name='supSubspan" + nextnum + "' > ";
                        sHtml += "<button type=\"button\"  class=\"e8_btn_top middle\" style=\"border:1px solid #aecef1 !important\" onclick=\"openDialogBeforSave(this);\" ><%=SystemEnv.getHtmlLabelName(33872,user.getLanguage())%></button>";
                        sHtml += "</span> ";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum3' value='" + nextnum + "' >";
                    } else if (manifestation == "3" && fieldType == "5") {//年

                        var nextnum = getNextYearNum();
                        var sHtml = "<select class='inputstyle' name='selectYear_" + nextnum + "' onchange='checkselect(5,this)'>";
                        <%
                        RecordSet.executeSql(yearFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "<option value='-2' ";
                        if (fieldValue == "11") {
                            sHtml += "selected ";
                        }
                        sHtml += "><%=SystemEnv.getHtmlLabelName(22793, user.getLanguage()) %></option>";
                        sHtml += "</select>";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum5' value='" + nextnum + "' >";
                    } else if (manifestation == "3" && fieldType == "6") {//月

                        var nextnum = getNextMonthNum();
                        var sHtml = "<select class='inputstyle' name='selectMonth_" + nextnum + "' onchange='checkselect(6,this)'>";
                        <%
                        RecordSet.executeSql(monthFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "<option value='-2' ";
                        if (fieldValue == "12") {
                            sHtml += "selected ";
                        }
                        sHtml += "><%=SystemEnv.getHtmlLabelName(22794, user.getLanguage()) %></option>";
                        sHtml += "</select>";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum6' value='" + nextnum + "' >";
                    } else if (manifestation == "3" && fieldType == "7") {//日

                        var nextnum = getNextDayNum();
                        var sHtml = "<select class='inputstyle' name='selectDay_" + nextnum + "' onchange='checkselect(7,this)'>";
                        <%
                        RecordSet.executeSql(dateFieldSql);
                        while(RecordSet.next()){
                        tempFieldId = RecordSet.getInt("ID");
                        %>
                        var tempFieldId = "<%=tempFieldId%>";
                        sHtml += "<option value='<%=tempFieldId%>' ";
                        if (tempFieldId == fieldValue) {
                            sHtml += "selected";
                        }
                        sHtml += "><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>";
                        <%}%>
                        sHtml += "<option value='-2' ";
                        if (fieldValue == "13") {
                            sHtml += "selected ";
                        }
                        sHtml += "><%=SystemEnv.getHtmlLabelName(15625, user.getLanguage()) %></option>";
                        sHtml += "</select>";
                        sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                        sHtml += "<input type='button' style='Float:right;' name='addInputCol' class='addbtn' accesskey='A' onclick='addStringCol(this)' title='<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>'>";
                        sHtml += "<input type='hidden'  name='selectNum7' value='" + nextnum + "' >";
                    } else {
                        return;
                    }

                    oCell.innerHTML = sHtml;
                    break;
            }
        }
        beautySelect();
        addline();

        jQuery(oRow).bind("mouseover", function (e) {
            showMoveIcon(this);
        });

        jQuery(oRow).bind("mouseout", function (e) {
            hideMoveIcon(this);
        });

    }

    //获取下一个字符串编号
    function getNextNumber() {
        var allorders = new Array();
        var allordereles = jQuery("input[name^=sortNum]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    function addStringCol(obj) {
        var oTable = $G("codeRule");
        //var ncol = oTable.rows[0].cells.length;
        var ncol = 2;
        var trSeq = $(obj).closest("tr").index();
        var oRow = oTable.insertRow(trSeq + 1);

        oRow.style.height = 24;
        var nextnum = getNextNumber();
        oRow.id = "fieldString" + nextnum;
        oRow.name = "fieldString" + nextnum;
        oRow.setAttribute("customer1", "member");
        for (j = 0; j < ncol; j++) {
            var oCell = oRow.insertCell(j);
            oCell.style.height = 24;
            switch (j) {
                case 0:
                    oCell.setAttribute("class", "fieldName");
                    oCell.setAttribute("codevalue", nextnum);
                    oCell.setAttribute("concrete", "7");
                    oCell.colSpan = 1;
                    var sHtml = "<span movingicon style='display:inline-block;width:20px;'><img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/></span>";
                    sHtml += "<%=SystemEnv.getHtmlLabelName(27903,user.getLanguage()) %>" + (nextnum);
                    oCell.innerHTML = sHtml;
                    break;
                case 1:
                    oCell.setAttribute("class", "field");
                    oCell.colSpan = 2;
                    var sHtml = "<input type='text' name='inputt" + nextnum + "' onchange='proView()' class='inputstyle' value='' isshowcode='0'>";
                    sHtml += "<input type='button' style='Float:right;' name='deleteInputCol' class='delbtn' accesskey='E' onclick='deleteCol(this)' title='E-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>'>";
                    sHtml += "<input type='hidden'  name='sortNum" + nextnum + "' value='" + nextnum + "' >";
                    oCell.innerHTML = sHtml;
                    break;
            }
        }
        addline();
        jQuery(oRow).bind("mouseover", function (e) {
            showMoveIcon(this);
        });

        jQuery(oRow).bind("mouseout", function (e) {
            hideMoveIcon(this);
        });
    }

    //获取下一个选择框编号

    function getNextSelNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum0]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //获取下一个部门编号

    function getNextDeptNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum1]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //获取下一个分部编号

    function getNextSubNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum2]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //获取下一个上级分部编号

    function getNextSupSubNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum3]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //获取下一个年编号
    function getNextYearNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum5]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //获取下一个月字段编号
    function getNextMonthNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum6]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
            //alert("$(e).val() = "+$(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //获取下一个日字段编号
    function getNextDayNum() {
        var allorders = new Array();
        var allordereles = jQuery("input[name=selectNum7]");
        allordereles.each(function (i, e) {
            allorders.push($(e).val());
        });

        if (allorders.length == 0) {
            return 1;
        } else {
            var num = allorders.length;
            var i = 1;
            for (i = 1; i <= num; i++) {
                if (!allorders.contains(i)) {
                    return i;
                }
            }
            return i;
        }
    }

    //添加横线
    function addline() {
        var oTable = $G("codeRule");
        var oRow1 = oTable.insertRow(-1);
        //oRow1.style.height=1;
        oRow1.setAttribute("height", "1px");
        oRow1.setAttribute("class", "Spacing");

        var oCell1 = oRow1.insertCell(-1);
        oCell1.setAttribute("class", "paddingLeft0");

        oCell1.colSpan = 3;
        var oDiv = document.createElement("div");

        oDiv.setAttribute("class", "intervalDivClass");
        oCell1.appendChild(oDiv);

        var isLastSelectS = getLastSelectS();
        var isLastMechS = getLastMechS();
        var isLastDataS = getLastDataS();
        if (isLastSelectS == 1) {
            showEle("trFieldSequenceShow");
            changeSltCurrentField();
        }

        if (isLastMechS == 1) {
            showEle("struSequenceShow");
            var struSeqselect = jQuery("#struSeqselect").val();
            addStruField(struSeqselect);
        } else {
            changeCurrentField();
        }
        if (isLastDataS == 1) {
            showEle("dateSequenceShow");
        } else {
            changeCurrentDate();
        }
        proView();
    }

    function getLastItem(concrete) {
        var hasAready = false;
        var allordereles = null;
        if (concrete == "1") {
            allordereles = jQuery("select[name^=selectDept_]");
        } else if (concrete == "2") {
            allordereles = jQuery("select[name^=selectSub_]");
        } else if (concrete == "3") {
            allordereles = jQuery("select[name^=selectSupSub_]");
        } else if (concrete == "5") {
            allordereles = jQuery("select[name^=selectYear_]");
        } else if (concrete == "6") {
            allordereles = jQuery("select[name^=selectMonth_]");
        } else if (concrete == "7") {
            allordereles = jQuery("select[name^=selectDay_]");
        }
        if (allordereles && allordereles.length > 1) {
            hasAready = true;
        }
        return hasAready;
    }

    function getSelectItem(item) {
        var hasAready = false;
        if (item == "1") {
            jQuery("#struSeqselect").each(function (i, e) {
                if ($(e).val() == "3") {
                    hasAready = true;
                }
            });
        } else if (item == "2") {
            jQuery("#struSeqselect").each(function (i, e) {
                if ($(e).val() == "2") {
                    hasAready = true;
                }
            });
        } else if (item == "3") {
            jQuery("#struSeqselect").each(function (i, e) {
                if ($(e).val() == "1") {
                    hasAready = true;
                }
            });
        } else if (item == "5") {
            jQuery("#dateSeqselect").each(function (i, e) {
                if ($(e).val() == "1") {
                    hasAready = true;
                }
            });
        } else if (item == "6") {
            jQuery("#dateSeqselect").each(function (i, e) {
                if ($(e).val() == "2") {
                    hasAready = true;
                }
            });
        } else if (item == "7") {
            jQuery("#dateSeqselect").each(function (i, e) {
                if ($(e).val() == "3") {
                    hasAready = true;
                }
            });
        }
        return hasAready;
    }

    function removeMechS(concrete) {//机构
        concrete = jQuery.trim(concrete);
        if (concrete == "1" && !getLastItem("1")) {
            jQuery("#struSeqselect").selectbox("detach");
            jQuery("#struSeqselect option[value='3']").remove();
            jQuery("#struSeqselect").selectbox("attach");
        }
        if (concrete == "2" && !getLastItem("2")) {
            jQuery("#struSeqselect").selectbox("detach");
            jQuery("#struSeqselect option[value='2']").remove();
            jQuery("#struSeqselect").selectbox("attach");
        }
        if (concrete == "3" && !getLastItem("3")) {
            jQuery("#struSeqselect").selectbox("detach");
            jQuery("#struSeqselect option[value='1']").remove();
            jQuery("#struSeqselect").selectbox("attach");
        }
        //jQuery("#select_id").append("<option value='Value'>Text</option>");
    }

    function removeDataS(concrete) {//日期
        concrete = jQuery.trim(concrete);
        if (concrete == "4" && !getLastItem("5")) {
            jQuery("#dateSeqselect").selectbox("detach");
            jQuery("#dateSeqselect option[value='1']").remove();
            jQuery("#dateSeqselect").selectbox("attach");
        }
        if (concrete == "5" && !getLastItem("6")) {
            jQuery("#dateSeqselect").selectbox("detach");
            jQuery("#dateSeqselect option[value='2']").remove();
            jQuery("#dateSeqselect").selectbox("attach");
        }
        if (concrete == "6" && !getLastItem("7")) {
            jQuery("#dateSeqselect").selectbox("detach");
            jQuery("#dateSeqselect option[value='3']").remove();
            jQuery("#dateSeqselect").selectbox("attach");
        }
    }

    function deleteCol(obj) {
        top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function () {
            var removeNum = jQuery(obj).parent().parent().find("td::eq(0)").attr("concrete");
            removeMechS(removeNum);
            removeDataS(removeNum);
            jQuery(obj).parent().parent().remove();
            proView();
            var isLastSelectS = getLastSelectS();
            var isLastMechS = getLastMechS();
            var isLastDataS = getLastDataS();
            if (isLastSelectS == 0) {
                hideEle("trFieldSequenceShow");
            } else {
                changeSltCurrentField();
            }

            if (isLastMechS == 0) {
                hideEle("struSequenceShow");
                jQuery("input[name=struSeqAlone]").val(0);
            } else {
                changeCurrentField();
            }
            if (isLastDataS == 0) {
                hideEle("dateSequenceShow");
            } else {
                changeCurrentDate();
            }
        }, function () {
        }, 320, 90, true);
    }

    //选择框

    function getLastSelectS() {
        var isSelect = "0";
        var allordereles = null;
        allordereles = jQuery("select[name^=selectField_]");

        if (allordereles && allordereles.length > 0) {
            isSelect = "1";
        }
        return isSelect;
    }

    //机构
    function getLastMechS() {
        var isSelect = "0";
        var allordereles1 = null;
        var allordereles2 = null;
        var allordereles3 = null;
        allordereles1 = jQuery("select[name^=selectDept_]");
        allordereles2 = jQuery("select[name^=selectSub_]");
        allordereles3 = jQuery("select[name^=selectSupSub_]");

        if ((allordereles1 && allordereles1.length > 0) || (allordereles2 && allordereles2.length > 0) || (allordereles3 && allordereles3.length > 0)) {
            isSelect = "1";
        }
        return isSelect;
    }

    //日期
    function getLastDataS() {
        var isSelect = "0";
        var allordereles1 = null;
        var allordereles2 = null;
        var allordereles3 = null;
        allordereles1 = jQuery("select[name^=selectYear_]");
        allordereles2 = jQuery("select[name^=selectMonth_]");
        allordereles3 = jQuery("select[name^=selectDay_]");
        if ((allordereles1 && allordereles1.length > 0) || (allordereles2 && allordereles2.length > 0) || (allordereles3 && allordereles3.length > 0)) {
            isSelect = "1";
        }
        return isSelect;
    }

    function changeTrFieldSequenceAlone(obj) {
        var selectFieldId = obj.value;
        if (selectFieldId > 0) {
            trFieldSequenceAlone.style.display = ''
            trLineFieldSequenceAlone.style.display = ''
        } else {
            trFieldSequenceAlone.style.display = 'none'
            trLineFieldSequenceAlone.style.display = 'none'
        }
    }

    function changesup(opt) {
        var supselect = jQuery("#supselect" + opt).find("option:selected").val();
        if (supselect == "0") {
            jQuery("#supSubspan" + opt).css("display", "");
        } else {
            jQuery("#supSubspan" + opt).css("display", "none");
        }
    }

    function changesub(opt) {
        var subselect = jQuery("#subselect" + opt).find("option:selected").val();
        if (subselect == "0") {
            jQuery("#subComspan" + opt).css("display", "");
        } else {
            jQuery("#subComspan" + opt).css("display", "none");
        }
    }

    function changedept(opt) {
        var deptselect = jQuery("#deptselect" + opt).find("option:selected").val();
        if (deptselect == "0") {
            jQuery("#deptspan" + opt).css("display", "");
        } else {
            jQuery("#deptspan" + opt).css("display", "none");
        }
    }

    function shortNameSetting(workflowId, formId, isBill, fieldId) {
        var url = "/workflow/workflow/WorkflowShortNameSetting.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill + "&fieldId=" + fieldId + "&ajax=1";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(690,user.getLanguage())%>";
        dialog.Width = 550;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();

        //window.location = "WorkflowShortNameSetting.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&fieldId=" + fieldId+ "&ajax=1";
    }

    function supSubComAbbr(workflowId, formId, isBill, fieldId) {
        //window.location = "WorkflowSupSubComAbbr.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&fieldId=" + fieldId+ "&ajax=1";
        var url = "/workflow/workflow/WorkflowSupSubComAbbr.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill + "&fieldId=" + fieldId + "&ajax=1";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>";
        dialog.Width = 550;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
    }

    function subComAbbr(workflowId, formId, isBill, fieldId) {
        //window.location = "WorkflowSubComAbbr.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&fieldId=" + fieldId+ "&ajax=1";
        var url = "/workflow/workflow/WorkflowSubComAbbr.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill + "&fieldId=" + fieldId + "&ajax=1";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
        dialog.Width = 550;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
    }

    function deptAbbr(workflowId, formId, isBill, fieldId) {

        //window.location = "WorkflowDeptAbbr.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&fieldId=" + fieldId+ "&ajax=1" ;
        var url = "/workflow/workflow/WorkflowDeptAbbr.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill + "&fieldId=" + fieldId + "&ajax=1";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
        dialog.Width = 550;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
    }

    function codeSeqSet(workflowId, formId, isBill) {
        //window.location = "WorkflowCodeSeqSet.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&ajax=1" ;
        var url = "/workflow/workflow/WorkflowCodeSeqSet.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill + "&ajax=1&dialog=1";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(20578,user.getLanguage())%>";
        dialog.Width = 850;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
    }

    function codeSeqReservedSet(workflowId, formId, isBill) {
        //window.location = "WorkflowCodeSeqReservedSet.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&ajax=1" ;
        var url = "/workflow/workflow/WorkflowCodeSeqReservedSet.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill + "&ajax=1&dialog=1";
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%>";
        dialog.Width = 850;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
    }

    function codeSeqReservedSetForDigit(workflowId, formId, isBill) {
        //window.location = "WorkflowCodeSeqReservedSet.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill+ "&ajax=1" ;
        var url = "/workflow/workflow/WFCodeReservedForDigit.jsp?workflowId=" + workflowId + "&formId=" + formId + "&isBill=" + isBill;
        var dialog = new window.top.Dialog();
        dialog.currentWindow = window;
        dialog.URL = url;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(22779,user.getLanguage())%>";
        dialog.Width = 850;
        dialog.Height = 550;
        dialog.Drag = true;
        dialog.maxiumnable = true;
        dialog.show();
    }


    function imgUpOnclick(index) {

        var checkbox1Stats = 0;
        var checkbox2Stats = 0;
        var obj1 = document.getElementById("TR_" + index);

        var checkbox1 = obj1.childNodes[1].firstChild;
        if (checkbox1.type == "checkbox") checkbox1Stats = checkbox1.checked;

        //var obj2 = obj1.previousSibling.previousSibling;
        //var checkbox2 =obj2.childNodes[1].firstChild;
        var obj2 = jQuery(obj1).prevAll("tr[customer1]").filter("tr:visible:first");
        var checkbox2 = $(obj2).find("td::eq(1)").children(":first");

        if (checkbox2.type == "checkbox") checkbox2Stats = checkbox2.checked;


        $(obj1).swap(obj2);
        if (checkbox1Stats != 0) {
            checkbox1.checked = checkbox1Stats;
        }

        if (checkbox2Stats != 0) {
            checkbox2Stats.checked = checkbox2Stats;
        }
        load();
    }

    function showMoveIcon(me, e) {
        e = e || window.event;
        var o = e.relatedTarget || e.toElement;

        if (o.tagName != 'IMG') {
            $(me).find('span[movingicon]').html("<img src='/proj/img/move-hot_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/>");
        }
    }

    function hideMoveIcon(me, e) {
        e = e || window.event;
        var o = e.relatedTarget || e.toElement;

        if (o == null || o.tagName != 'IMG') {
            $(me).find('span[movingicon]').html("<img src='/proj/img/move_wev8.png' title='<%=SystemEnv.getHtmlLabelName(82783, user.getLanguage())%>'/>");
        }
    }

    function showBt(obj) {
        $(obj).removeClass("btstyle01").addClass("btstyle02");
    }

    function hiddenBt(obj) {
        $(obj).removeClass("btstyle02").addClass("btstyle01");
    }

    function addField() {
        var title = "<%=SystemEnv.getHtmlLabelName(17998,user.getLanguage())%>";
        var url = "";
        <%if(formid < 0){%>
        url = "/workflow/field/addfield0.jsp?formid="+<%=formid%>+
        "&dialog=1&fromWFCode=wfcode&isbill=<%=isbill%>"
        <%}else{%>
        url = "/workflow/selectItem/selectItemMain.jsp?topage=BillManagementFieldAdd0&type=1&billId=<%=formid%>&fromWFCode=wfcode&isbill=<%=isbill%>"
        <%}%>
        var diag_vote = new window.top.Dialog();
        diag_vote.currentWindow = window;
        diag_vote.URL = url;
        diag_vote.callbackfun = function (paramobj, id1) {
            if (id1) {
                var lableid = id1.lableid;
                var idcode = id1.idcode;
                jQuery("#selectField").selectbox("detach");
                var option = "<option value='" + idcode + "'>" + lableid + "</option>";
                jQuery("#selectField").append(option);
                jQuery("#selectField").selectbox("attach");
            }
        }
        diag_vote.Width = 1020;
        diag_vote.Height = 580;
        diag_vote.Title = title
        diag_vote.Drag = true;
        diag_vote.show();

    }

    function imgDownOnclick(index) {

        var checkbox1Stats = 0;
        var checkbox2Stats = 0;
        var obj1 = document.getElementById("TR_" + index);

        var checkbox1 = obj1.childNodes[1].firstChild;
        if (checkbox1.type == "checkbox") checkbox1Stats = checkbox1.checked;

        //var obj2 = obj1.nextSibling.nextSibling;
        //var checkbox2 =obj2.childNodes[1].firstChild;
        var obj2 = jQuery(obj1).nextAll("tr[customer1]").filter("tr:visible:first");
        var checkbox2 = $(obj2).find("td::eq(1)").children(":first");

        if (checkbox2.type == "checkbox") checkbox2Stats = checkbox2.checked;


        $(obj1).swap(obj2);
        if (checkbox1Stats != 0) {
            checkbox1.checked = checkbox1Stats;
        }

        if (checkbox2Stats != 0) {
            checkbox2Stats.checked = checkbox2Stats;
        }
        load();

    }

    function hasSelectNew(fieldType, fieldtext) {
        var hasAready = false;
        var allorders = new Array();
        var allordereles = null;
        var index = 0;
        if (fieldType == "0") {
            allordereles = jQuery("select[name^=selectField_]");
        } else if (fieldType == "1") {
            allordereles = jQuery("select[name^=selectDept_]");
        } else if (fieldType == "2") {
            allordereles = jQuery("select[name^=selectSub_]");
        } else if (fieldType == "3") {
            allordereles = jQuery("select[name^=selectSupSub_]");
        } else if (fieldType == "5") {
            allordereles = jQuery("select[name^=selectYear_]");
        } else if (fieldType == "6") {
            allordereles = jQuery("select[name^=selectMonth_]");
        } else if (fieldType == "7") {
            allordereles = jQuery("select[name^=selectDay_]");
        }
        allordereles.each(function (i, e) {
            var selecttext = $(e).find("option:selected").text();
            if (selecttext == fieldtext) {
                index++;
            }
        });
        if (index > 1) {
            hasAready = true;
        }
        return hasAready;
    }

    function checkselect(fieldType, obj) {
        var fieldtext = jQuery(obj).find("option:selected").text();
        if (fieldType == "0" && hasSelectNew("0", fieldtext)) {//选择
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else if (fieldType == "1" && hasSelectNew("1", fieldtext)) {//部门
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else if (fieldType == "2" && hasSelectNew("2", fieldtext)) {//分部
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else if (fieldType == "3" && hasSelectNew("3", fieldtext)) {//上级分部
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else if (fieldType == "5" && hasSelectNew("5", fieldtext)) {
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else if (fieldType == "6" && hasSelectNew("6", fieldtext)) {
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else if (fieldType == "7" && hasSelectNew("7", fieldtext)) {
            jQuery(obj).selectbox("detach");
            var oldval = jQuery(obj).attr("oldval");
            jQuery(obj).val(oldval);
            jQuery(obj).selectbox("attach");
            top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(129509, user.getLanguage())%>" + fieldtext + "，<%=SystemEnv.getHtmlLabelName(129510, user.getLanguage())%>");
            return false;
        } else {
            var oldval = jQuery(obj).val();
            jQuery(obj).attr("oldval", oldval);
            proView();
            changeSltCurrentField();
        }
    }

    function getShowNodesUrl() {
        var wfid = "<%=wfid%>";
        var selectids = jQuery("#wfcode").val();
        if (selectids == "") {
            selectids = "0";
        }
        var urls = "/workflow/workflow/WFCodeBrowser.jsp?wfid=" + wfid + "_" + selectids;
        urls = "/systeminfo/BrowserMain.jsp?url=" + urls
        return urls;
    }

    jQuery.fn.swap = function (other) {
        $(this).replaceWith($(other).after($(this).clone(true)));
    };
</script>