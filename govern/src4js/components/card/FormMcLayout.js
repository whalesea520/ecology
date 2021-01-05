import FormCellType from './FormCellType';
import * as parse from '../../util/parseAttr'
import Immutable from 'immutable';
import {is} from 'immutable'

class FormMcLayout extends React.Component{

    render() {
        const {mcpoint,content,mainData,detailTable,cellInfo} = this.props;
        const {type, modeInfo, functionAttr, orderlyjson, etables, mainFields, detailData, modeField}  = this.props;
        const rowCount = content.rowcount;
        const ec = content.ec;
        const ecMap = {};
        for (let i = 0, l = ec.length; i < l; i++) {
            let cellObj = ec[i];
            let key = cellObj.id;
            ecMap[key] = cellObj;
        }
        let mcCells = new Array();
        for(let r=0; r<rowCount; r++){
            const cellObj = ecMap[r+",0"];
            if(cellObj){
                let className = "span_mc etype_"+cellObj.etype;
                const mcCellAttr = parse.getMcCellAttr(cellObj);
                className += mcCellAttr.cusclass ? (" "+mcCellAttr.cusclass) : "";
                mcCells.push(<span id={mcCellAttr.cusid} name={mcCellAttr.cusname} className={className} style={mcCellAttr.innerStyleObj}>
                                <FormCellType 
                                    symbol={mcpoint} 
                                    cellInfo={cellInfo} 
                                    cellObj={cellObj} 
                                    mainData={mainData} 
                                    detailData={detailData}
                                    cellInfo={cellInfo}
                                    type={type}
                                    modeInfo={modeInfo}
                                    functionAttr={functionAttr}
                                    orderlyjson={orderlyjson}
                                    etables={etables}
                                    mainFields={mainFields}
                                    modeField={modeField}/></span>);
                const brObj = ecMap[r+",1"];
                brObj && brObj.etype === "14" && brObj.brsign === "Y" && mcCells.push(<br/>);
            }
        }
        return (
            <div>{mcCells}</div>
        );
    }
}

export default FormMcLayout
