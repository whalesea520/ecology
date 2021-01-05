import React from 'react';

import FormField from './FormField'
import FormLabel from './FormLabel'
import FormDetailLayout from './FormDetailLayout'
import FormTabLayout from './FormTabLayout'
import DetailSumCell from './DetailSumCell'
import FormMcLayout from './FormMcLayout';
import { Button, Checkbox, Radio, Icon } from 'antd'
import { WeaCheckbox } from 'ecCom'
class FormCellType extends React.Component {

    addrow = () => {
        const { symbol, functionAttr } = this.props
        functionAttr.addrow(symbol);
    }

    delrow = () => {
        const { symbol, functionAttr } = this.props
        functionAttr.delrow(symbol);
    }

    checkRow = (value) =>{
        alert(value);
    }
    render() {
        const { getFieldProps } = this.props

        const { cellInfo, type, modeInfo, functionAttr, orderlyjson } = this.props;
        const { symbol, drowIndex, cellObj, etables, mainFields, detailTable, mainData, detailData, modeField } = this.props;
        
        const cellid = cellObj["id"];
        const cellmark = symbol + "_" + cellid.replace(",", "_");
        const etype = cellObj["etype"];
        const fieldid = cellObj["field"];
        const evalue = cellObj["evalue"];
        let cellElement = this.renderSpan(evalue);

        if (etype === "" || etype === "0" || etype === "1" || etype === "4" || etype === "6") { //文本、节点名称、图片
            cellElement = this.rendSpanHtml(this.transCellText(evalue));
        } else if (etype === "2" || etype === "3") { //字段名、字段值
            const tablekey = symbol.indexOf("detail_") > -1 ? symbol : "main";

            const fieldObj = mainFields && mainFields[fieldid];
            if (etype === "2") {
                cellElement = <FormLabel cellObj={cellObj} fieldObj={fieldObj} />

            }
            else if (etype === "3") {
                cellElement = <FormField modeInfo={modeInfo} functionAttr={functionAttr} symbol={symbol} getFieldProps={getFieldProps} type={type} cellObj={cellObj} fieldObj={fieldObj} formValue={mainData} drowIndex={drowIndex} />
            }
        } else if (etype === "7") { //明细
            const detail = cellObj["detail"];
            cellElement = <FormDetailLayout orderlyjson={orderlyjson} modeField={modeField} modeInfo={modeInfo} functionAttr={functionAttr} getFieldProps={getFieldProps} type={type} symbol={detail} detailLayout={etables[detail]} mainFields={mainFields} detailTable={detailTable} mainData={mainData} detailData={detailData} />
        } else if (etype === "10" && type != "0") { //明细增删按钮
            if (type == "1" || type == "2") {
                const detailTableAttr = detailTable && detailTable[symbol];
                const isadd = detailTableAttr && detailTableAttr.isadd;
                const isdelete = detailTableAttr && detailTableAttr.isdelete;
                cellElement = <div className="detailButtonDiv" style={{ width: "100px" }}>
                    <Button icon="plus-circle-o" onClick={this.addrow}>
                    </Button>
                    &nbsp;&nbsp;
                    <Button icon="minus-circle-o" onClick={this.delrow}>
                    </Button>
                </div>
            }
        } else if (etype === "11") { //链接
            const fieldtype = cellObj.fieldtype;
            const field = cellObj.field;
            const text = cellObj.evalue;
            let url = "";
            url = fieldtype == 1 ? "http://" : url;
            url = fieldtype == 2 ? "https://" : url;
            url = fieldtype == 3 ? "ftp://" : url;
            url = fieldtype == 4 ? "news://" : url;
            url += field;
            return (
                <a target="_blank" href={url}>{text}</a>
            );
        } else if (etype === "12") { //标签页
            const cellInfo = orderlyjson.cellInfo;
            const style = cellInfo ? cellInfo[cellmark + "_stylejson"] : "";
            return (
                <FormTabLayout
                    cellid={cellid}
                    tab={cellObj.tab}
                    etables={etables}
                    cellInfo={cellInfo}
                    style={style}
                    mainFields={mainFields}
                    detailTable={detailTable}
                    mainData={mainData}
                    detailData={detailData}
                    modeField={modeField}
                    functionAttr={functionAttr}
                    orderlyjson={orderlyjson}
                    modeInfo={modeInfo}
                    type={type} />
            );
        } else if (etype === "13") { //多内容
            const mcpoint = cellObj.mcpoint;
            const content = etables[mcpoint];
            return (
                <FormMcLayout
                    mcpoint={mcpoint}
                    content={content}
                    mainData={mainData}
                    cellInfo={cellInfo}
                    type={type}
                    modeInfo={modeInfo}
                    functionAttr={functionAttr}
                    orderlyjson={orderlyjson}
                    etables={etables}
                    mainFields={mainFields}
                    detailTable={detailTable}
                    mainData={mainData}
                    detailData={detailData}
                    modeField={modeField} />
            );
        } else if ( etype==="15" || etype==="16" || etype === "17") { //门户元素、iframe区域、扫码区
            const cellInfo = orderlyjson.cellInfo;
            const html = cellInfo ? cellInfo[cellmark + "_htmlstr"] : "";
            return this.renderHtml(html);
        } else if (etype === "18" || etype === "19") { //合计名称、合计值
            const fieldObj = mainFields && mainFields[fieldid];
            if (etype === "18") {
                const fieldlabel = fieldObj && fieldObj.fieldlabel;
                return this.renderSpan(fieldlabel + "(合计)");
            } else {
                let data = detailData[symbol]
                return <DetailSumCell modeField={modeField} data={data} symbol={symbol} fieldObj={fieldObj} />
            }
        } else if (etype === "20") { //明细全选
            cellElement = <Checkbox disabled />;
        } else if (etype === "21") { //明细单选
            let checkId = "_" + symbol + "_" + drowIndex;
            cellElement = <WeaCheckbox fieldName={checkId} onChange={this.checkRow} {...getFieldProps(checkId, { "initialValue": false }) } />;
        }
        else if (etype === "22") { //序号
            cellElement = <span id={"serialnum_" + drowIndex}>{parseInt(drowIndex) + 1}</span>;
        }
        return cellElement;
    }
    transCellText(content) {
        if (content === null || typeof content === "undefined")
            return "";
        return content.replace(/(\r\n|\r|\n)/g, "</br>").replace(/ /g, "&nbsp;");
    }
    renderSpan(content) {
        return <span>{content}</span>
    }
    rendSpanHtml(content) {
        return <span dangerouslySetInnerHTML={{ __html: content }}></span>
    }
    renderHtml(innerHTML) {
        return <div dangerouslySetInnerHTML={{ __html: innerHTML }} />
    }

}

export default FormCellType