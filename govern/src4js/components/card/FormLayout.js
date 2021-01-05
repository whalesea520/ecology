import React from 'react';
import FormLayoutTr from './FormLayoutTr'
import Immutable from 'immutable'
import ImageTr from './ImageTr'
const is = Immutable.is;

class FormLayout extends React.Component {

    render() {
        const { getFieldProps } = this.props;

        const { symbol, className, etables, colheads, rowheads, rowattrs, colattrs } = this.props;
        const { ecMap, mainFields, detailTable, mainData, detailData, type, modeInfo } = this.props;
        const { functionAttr, modeField, orderlyjson, backgroundImage, floatingObjectArray } = this.props;

        let sumWidth = 0;
        let _colheads = new Array();
        let find = false;
        for (var item in colheads) {
            _colheads.push({ id: item, h: colheads[item] });
            sumWidth += parseInt(colheads[item]);
            if (colheads[item].indexOf("%") >= 0) {
                find = true;
            }
        }

        _colheads = _colheads.sort((a, b) => {
            return parseInt(a.id.substring(4)) - parseInt(b.id.substring(4));
        });
        let style = {};
        if(symbol != "replyTable"){
            style = { margin: "0 auto" };
        }
        if (find) style.width = "100%";

        let _rowheads = new Array();
        for (var item in rowheads) {
            _rowheads.push({ id: item, h: rowheads[item] });
        }

        _rowheads = _rowheads.sort((a, b) => {
            return parseInt(a.id.substring(4)) - parseInt(b.id.substring(4));
        });

        let cols = _colheads ? _colheads.length : 0;
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
            const row = rowArr.length > 0 ? rowArr[1] : -1;
            const rowHeight = r;
            trArr.push(<FormLayoutTr
                getFieldProps={getFieldProps}
                type={type}
                modeInfo={modeInfo}
                symbol={symbol}
                row={row}
                cols={cols}
                rowHeight={rowHeight}
                ecMap={ecMap}
                style={style}
                mainFields={mainFields}
                detailTable={detailTable}
                mainData={mainData}
                detailData={detailData}
                etables={etables}
                rowattrs={rowattrs}
                colattrs={colattrs}
                functionAttr={functionAttr}
                modeField={modeField}
                orderlyjson={orderlyjson} />);
        })
        /*let imageTr;
        if (backgroundImage || floatingObjectArray) {
            let backGrounds;
            let floating = new Array();
            if (backgroundImage) {
                let url = backgroundImage.indexOf("http://") > -1 ? backgroundImage : "http://192.168.31.92:8070" + backgroundImage;
                backGrounds = <img
                    src={url}
                    style={{ position: "absolute", zIndex: "-100", top: "0px", left: "0px" }}
                />
            }
            if (floatingObjectArray) {
                let floatingImgArr = floatingObjectArray.floatingObjects;
                if (floatingImgArr) {
                    for (let i = 0; i < floatingImgArr.length; i++) {
                        let floatingImg = floatingImgArr[i];
                        let x = floatingImg ? floatingImg.x + "px" : "";
                        let y = floatingImg ? floatingImg.y + "px" : "";
                        let width = floatingImg ? floatingImg.width + "px" : "";
                        let height = floatingImg ? floatingImg.height + "px" : "";
                        let src = floatingImg ? floatingImg.src : "";
                        let url = src.indexOf("http://") > -1 ? src : "http://192.168.31.92:8070" + src;
                        if (x && y && width && height && src) {
                            floating.push(<div
                                style={{ position: "absolute", zIndex: "99999", padding: "0px", margin: "0px", width: width, height: height, top: y, left: x }}
                            >
                                <img
                                    src={url}
                                    style={{ width: "100%", height: "100%" }}
                                />
                            </div>)
                        }
                    }
                }
            }
            imageTr = <tr>
                <td
                    colspan={cols}
                    style={{ position: "relative", padding: "0px !important", margin: "0px !important" }}
                >
                    {backGrounds}
                    {floating}
                </td>
            </tr>
        }*/

        return (
            <div>
                <table className={className} style={style}>
                    <colgroup>
                        {
                            _colheads.map((o) => {
                                return (
                                    <col style={{ width: o.h }} />
                                )
                            })
                        }
                    </colgroup>
                    <tbody>
                        {trArr}
                    </tbody>
                </table>
            </div>
        )
    }
}

export default FormLayout