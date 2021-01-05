import React from 'react';
import * as parse from '../../util/parseAttr'
import { Checkbox } from 'antd'
import FormCellType from './FormCellType'

const findRowSpan = (row, col, ecMap) => {
    let find = false;
    for (let j = col; j >= 0 && !find; j--) {
        for (let i = row - 1; i >= 0 && !find; i--) {
            const cellObj = ecMap[i + "," + j];
            const rowSpan = cellObj ? (cellObj["rowspan"] || 1) : 0;
            const colSpan = cellObj ? (cellObj["colspan"] || 1) : 0;
            if (rowSpan > 1 && rowSpan >= (row - i + 1) && colSpan >= (col - j + 1)) {
                find = true;
            }
        }
    }
    return find;
}

class FormLayoutTr extends React.Component {
    render() {
        const { getFieldProps } = this.props
        const { symbol, row, cols, drowIndex, rowHeight, ecMap, style, etables, type } = this.props
        const { mainFields, detailTable, mainData, detailData, rowattrs, colattrs, from, addColType, modeInfo, modeField } = this.props;
        const { functionAttr, orderlyjson } = this.props;
        
        let colCell = new Array();
        let col = 0;
        while (col < cols) {
            const rc = row + "," + col;
            const cellObj = ecMap[rc];
            const cellColAttrs = colattrs ? colattrs["col_" + col] : null;
            const colSpan = cellObj ? (cellObj["colspan"] || 1) : 0;
            const rowSpan = cellObj ? (cellObj["rowspan"] || 1) : 0;
            if (findRowSpan(row, col, ecMap)) {
                col += 1;
            } else if (!cellObj) {
                colCell.push(<td></td>);
                col += 1;
            }
            else {
                const cellAttr = parse.getCellAttr(cellObj, cellColAttrs, rowHeight);
                let tdClassName = "etype_" + (cellObj ? cellObj["etype"] : 1);
                if (cellAttr.class) tdClassName += " " + cellAttr.class;
                if (col === 0 && symbol.indexOf("detail_") > -1 && addColType > 0) {  //低级模式增加序号列
                    if (addColType === 1)
                        colCell.push(<td style={cellAttr.styleObj}><div style={cellAttr.innerStyleObj}></div></td>);
                    else if (addColType === 2)
                        colCell.push(<td style={cellAttr.styleObj}><div style={cellAttr.innerStyleObj}>
                            <Checkbox disabled /></div></td>);
                    else if (addColType === 3)
                        colCell.push(<td style={cellAttr.styleObj}><div style={cellAttr.innerStyleObj}>
                            <Checkbox disabled /><span id={"serialnum_" + drowIndex}>{parseInt(drowIndex) + 1}</span></div></td>);
                }
                //console.log(cellAttr.styleObj);
                colCell.push(<td rowSpan={rowSpan} colSpan={colSpan} className={tdClassName} style={cellAttr.styleObj}>
                    <div id={cellAttr.cusid} name={cellAttr.cusname} className={cellAttr.cusclass} style={cellAttr.innerStyleObj}>
                        <FormCellType
                            getFieldProps={getFieldProps}
                            modeInfo={modeInfo}
                            type={type}
                            symbol={symbol}
                            drowIndex={drowIndex}
                            cellObj={cellObj}
                            etables={etables}
                            mainFields={mainFields}
                            detailTable={detailTable}
                            mainData={mainData}
                            detailData={detailData}
                            functionAttr={functionAttr}
                            modeField={modeField}
                            orderlyjson={orderlyjson} />
                    </div></td>);
                col += parseInt(colSpan);
            }

        }
        const rowCusAttr = rowattrs ? rowattrs["row_" + row] : null;
        const rowAttr = parse.getRowAttr(rowHeight, rowCusAttr);
        return (
            <tr id={rowAttr.id} name={rowAttr.name} className={rowAttr.class} style={rowAttr.styleObj}>{colCell}</tr>
        )
    }
}

export default FormLayoutTr