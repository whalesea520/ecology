import React from 'react';
import FormLayoutTr from './FormLayoutTr'
import ImageTr from './ImageTr'

class FormDetailLayout extends React.Component {
    render() {
        const { getFieldProps } = this.props

        const { symbol, detailLayout, mainFields, detailTable, mainData, detailData, type, modeInfo, modeField } = this.props;
        const { functionAttr, orderlyjson } = this.props;
        const detailValue = detailData && detailData[symbol];
        const detailArr = detailValue ? detailValue.data : {};
        let rowheads = detailLayout ? detailLayout.rowheads : {};
        const colheads = detailLayout ? detailLayout.colheads : {};
        const ec = detailLayout ? detailLayout.ec : {};
        const backgroundImage = detailLayout ? detailLayout.backgroundImage : null;
        const floatingObjectArray = detailLayout ? detailLayout.floatingObjectArray : null;
        const headRow = detailLayout ? (detailLayout.edtitleinrow ? parseInt(detailLayout.edtitleinrow) : 0) : 0;
        const bodyRow = detailLayout ? (detailLayout.edtailinrow ? parseInt(detailLayout.edtailinrow) : 0) : 0;
        const isSeniorSet = detailLayout ? (detailLayout.seniorset == "1") : "0";

        let addColType = 0;
        if (headRow == 0 || bodyRow == 0 || bodyRow <= headRow) {
            return (<div>对不起，表头标识、表尾标识设置异常，无法渲染明细！</div>)
        }

        const ecMap = new Array();
        for (let i = 0, l = ec.length; i < l; i++) {
            let cellObj = ec[i];
            let key = cellObj.id;
            ecMap[key] = cellObj;
        }

        const rowattrs = detailLayout.rowattrs;
        const colattrs = detailLayout.colattrs;

        let _rowheads = new Array();
        for (var item in rowheads) {
            _rowheads.push({ id: item, h: rowheads[item] });
        }

        _rowheads = _rowheads.sort((a, b) => {
            return parseInt(a.id.substring(4)) - parseInt(b.id.substring(4));
        });

        let _colheads = new Array();
        for (var item in colheads) {
            _colheads.push({ id: item, w: colheads[item] });
        }

        _colheads = _colheads.sort((a, b) => {
            return parseInt(a.id.substring(4)) - parseInt(b.id.substring(4));
        });

        let cols = _colheads.length;
        let trArr = new Array();
        if(backgroundImage || floatingObjectArray){
            trArr.push(<ImageTr
                backgroundImage={backgroundImage}
                floatingObjectArray={floatingObjectArray}
                cols={cols}
            />) ;
        }
        _rowheads.map((o) => {
            const r = o.h;
            const k = o.id;
            const rowArr = k.split("_");
            const row = parseInt(rowArr.length > 0 ? rowArr[1] : -1);
            const rowHeight = r;
            if (row === headRow + 1) {    //位于表头表尾标识之间
                if (!isSeniorSet)
                    addColType = 3;
                //let j = 0;
                //for(var item in detailArr){
                for (let j = 0, l = detailArr.length; j < l; j++) {
                    let cellObj = detailArr[j];
                    for (let i = row; i < bodyRow; i++) {
                        trArr.push(<FormLayoutTr
                            getFieldProps={getFieldProps}
                            modeInfo={modeInfo}
                            symbol={symbol}
                            row={i}
                            cols={cols}
                            drowIndex={j}
                            addColType={addColType}
                            rowHeight={rowHeight}
                            ecMap={ecMap}
                            mainFields={mainFields}
                            detailTable={detailTable}
                            mainData={cellObj}
                            etables={null}
                            cellInfo={null}
                            rowattrs={rowattrs}
                            colattrs={colattrs}
                            type={type}
                            detailData={detailData}
                            functionAttr={functionAttr}
                            modeField={modeField}
                            orderlyjson={orderlyjson}
                        />);
                    }
                    //j++;
                }
            } else if (row < headRow || (isSeniorSet && row > bodyRow)) {
                if (!isSeniorSet)
                    addColType = (row === headRow - 1) ? 2 : 1;
                trArr.push(<FormLayoutTr
                    getFieldProps={getFieldProps}
                    modeInfo={modeInfo}
                    symbol={symbol}
                    row={row}
                    cols={cols}
                    addColType={addColType}
                    rowHeight={rowHeight}
                    ecMap={ecMap}
                    etables={null}
                    cellInfo={null}
                    mainFields={mainFields}
                    detailTable={detailTable}
                    mainData={mainData}
                    detailData={detailData}
                    rowattrs={rowattrs}
                    colattrs={colattrs}
                    type={type}
                    modeField={modeField}
                    functionAttr={functionAttr}
                    orderlyjson={orderlyjson} />);

            }

        })

        let backGrounds;
        if (backgroundImage) {
            let url = backgroundImage.indexOf("http://") > -1 ? backgroundImage : "http://192.168.31.92:8070" + backgroundImage;
            backGrounds = <tr>
                <td
                    colspan={cols}
                    style={{ position: "relative", padding: "0px !important", margin: "0px !important" }}
                >
                    <img
                        src={url}
                        style={{ position: "absolute", zIndex: "-100", top: "0px", left: "0px" }}
                    />
                </td>
            </tr>
        }

        return (
            <div className="excelDetailTableDiv">
                <table className="excelDetailTable" style={{ width: "100%" }}>
                    <colgroup>
                        {!isSeniorSet &&
                            <col style={{ width: "5%" }} />}
                        {
                            _colheads.map((o) => {
                                return (
                                    <col style={{ width: o.w }} />
                                )
                            })
                        }
                    </colgroup>
                    <tbody>
                        {backGrounds}
                        {trArr}
                    </tbody>
                </table>
            </div>
        )
    }
}
export default FormDetailLayout