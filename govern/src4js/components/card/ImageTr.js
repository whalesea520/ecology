
class ImageTr extends React.Component {

    render() {
        const { backgroundImage, floatingObjectArray,cols } = this.props
        let imageTr;
        let backGrounds;
        let floating = new Array();
        if (backgroundImage) {
            //let url = backgroundImage.indexOf("http://") > -1 ? backgroundImage : "http://192.168.31.92:8070" + backgroundImage;
            let url= backgroundImage;
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
                    //let url = src.indexOf("http://") > -1 ? src : "http://192.168.31.92:8070" + src;
                    let url= src;
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
        return imageTr;
    }
}

export default ImageTr
