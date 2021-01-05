import React from 'react';

class FormLabel extends React.Component {
    render() {
        const { cellObj, fieldObj } = this.props;
        const financial = cellObj["financial"];
        const fieldlabel = fieldObj && fieldObj["fieldlabel"];
        if (financial && financial.indexOf("1-") > -1) {     //财务表头
            const financialTypes = ["分", "角", "元", "十", "百", "千", "万", "十", "百", "千", "亿", "十"];
            const finaNum = parseInt(financial.split("-")[1] || "3");
            let showTds = new Array();
            for (let i = finaNum - 1; i >= 0; i--) {
                let itemBorder = "fborder1";
                if (i === 0)
                    itemBorder = "";
                else if (i === 2)
                    itemBorder = "fborder2";
                else if ((i - 2) % 3 === 0)
                    itemBorder = "fborder3";
                itemBorder = "finborder " + itemBorder;
                showTds.push(<td className={itemBorder}>{financialTypes[i]}</td>)
            }
            return (
                <div className="findiv">
                    <table className="fintable">
                        <tr className="ftoprow"><td colSpan={finaNum}>{fieldlabel}</td></tr>
                        <tr>{showTds}</tr>
                    </table>
                </div>
            )
        }
        return <div>{fieldlabel}</div>;
    }
}
export default FormLabel