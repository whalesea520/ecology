// JavaScript Document
<!--
/*
@ JavaScript Clone table header
@ 作者：宋延军
@ 功能：冻结锁定 表格头 和 列
@ 日期：2012-03-19 下午13:17:41
@ 邮箱：songyanju_stars@126.com
@ QQ号：181744926

@ 页面加载调用：
	jQuery(document).ready(function () {
            FixTable("MyTable", 2, 600, 400);
        });
*/

    function FixTable(TableID, FixColumnNumber, width, height) {
    /// <summary>
    ///     锁定表头和列
    ///     <para> http://blog.csdn.net/SongYanJun2011 </para>
    /// </summary>
    /// <param name="TableID" type="String">
    ///     要锁定的Table的ID
    /// </param>
    /// <param name="FixColumnNumber" type="Number">
    ///     要锁定列的个数
    /// </param>
    /// <param name="width" type="Number">
    ///     显示的宽度
    /// </param>
    /// <param name="height" type="Number">
    ///     显示的高度
    /// </param>
    if (jQuery("#" + TableID + "_tableLayout").length != 0) {
        jQuery("#" + TableID + "_tableLayout").before(jQuery("#" + TableID));
        jQuery("#" + TableID + "_tableLayout").empty();
    }
    else {
        jQuery("#" + TableID).after("<div id='" + TableID + "_tableLayout' style='overflow:hidden;height:" + height + "px; width:" + width + "px;'></div>");
    }
    jQuery('<div id="' + TableID + '_tableFix"></div>'
    + '<div id="' + TableID + '_tableHead"></div>'
    + '<div id="' + TableID + '_tableColumn"></div>'
    + '<div id="' + TableID + '_tableData"></div>').appendTo("#" + TableID + "_tableLayout");
    var oldtable = jQuery("#" + TableID);
    var tableFixClone = oldtable.clone(true);
    tableFixClone.attr("id", TableID + "_tableFixClone");
    jQuery("#" + TableID + "_tableFix").append(tableFixClone);
    var tableHeadClone = oldtable.clone(true);
    tableHeadClone.attr("id", TableID + "_tableHeadClone");
    jQuery("#" + TableID + "_tableHead").append(tableHeadClone);
    var tableColumnClone = oldtable.clone(true);
    tableColumnClone.attr("id", TableID + "_tableColumnClone");
    jQuery("#" + TableID + "_tableColumn").append(tableColumnClone);
    jQuery("#" + TableID + "_tableData").append(oldtable);
    jQuery("#" + TableID + "_tableLayout table").each(function () {
        jQuery(this).css("margin", "0");
    });
    var HeadHeight = jQuery("#" + TableID + "_tableHead thead").height();
    HeadHeight += 2;
    jQuery("#" + TableID + "_tableHead").css("height", HeadHeight);
    jQuery("#" + TableID + "_tableFix").css("height", HeadHeight);
    var ColumnsWidth = 0;
    var ColumnsNumber = 0;
    jQuery("#" + TableID + "_tableColumn tr:last td:lt(" + FixColumnNumber + ")").each(function () {
        ColumnsWidth += jQuery(this).outerWidth(true);
        ColumnsNumber++;
    });
    ColumnsWidth += 2;
    if ($.browser.msie) {
        switch ($.browser.version) {
            case "7.0":
                if (ColumnsNumber >= 3) ColumnsWidth--;
                break;
            case "8.0":
                if (ColumnsNumber >= 2) ColumnsWidth--;
                break;
        }
    }
    jQuery("#" + TableID + "_tableColumn").css("width", ColumnsWidth);
    jQuery("#" + TableID + "_tableFix").css("width", ColumnsWidth);
    jQuery("#" + TableID + "_tableData").scroll(function () {
        jQuery("#" + TableID + "_tableHead").scrollLeft(jQuery("#" + TableID + "_tableData").scrollLeft());
        jQuery("#" + TableID + "_tableColumn").scrollTop(jQuery("#" + TableID + "_tableData").scrollTop());
    });
    jQuery("#" + TableID + "_tableFix").css({ "overflow": "hidden", "position": "relative", "z-index": "50", "background-color": "Silver" });
    jQuery("#" + TableID + "_tableHead").css({ "overflow": "hidden", "width": width - 17, "position": "relative", "z-index": "45", "background-color": "Silver" });
    jQuery("#" + TableID + "_tableColumn").css({ "overflow": "hidden", "height": height - 17, "position": "relative", "z-index": "40", "background-color": "Silver" });
    jQuery("#" + TableID + "_tableData").css({ "overflow": "scroll", "width": width, "height": height, "position": "relative", "z-index": "35" });
    if (jQuery("#" + TableID + "_tableHead").width() > jQuery("#" + TableID + "_tableFix table").width()) {
        jQuery("#" + TableID + "_tableHead").css("width", jQuery("#" + TableID + "_tableFix table").width());
        jQuery("#" + TableID + "_tableData").css("width", jQuery("#" + TableID + "_tableFix table").width() + 17);
    }
    if (jQuery("#" + TableID + "_tableColumn").height() > jQuery("#" + TableID + "_tableColumn table").height()) {
        jQuery("#" + TableID + "_tableColumn").css("height", jQuery("#" + TableID + "_tableColumn table").height());
        jQuery("#" + TableID + "_tableData").css("height", jQuery("#" + TableID + "_tableColumn table").height() + 17);
    }
    jQuery("#" + TableID + "_tableFix").offset(jQuery("#" + TableID + "_tableLayout").offset());
    jQuery("#" + TableID + "_tableHead").offset(jQuery("#" + TableID + "_tableLayout").offset());
    jQuery("#" + TableID + "_tableColumn").offset(jQuery("#" + TableID + "_tableLayout").offset());
    jQuery("#" + TableID + "_tableData").offset(jQuery("#" + TableID + "_tableLayout").offset());
}

//-->