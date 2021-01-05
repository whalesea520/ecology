import { Row, Col, Card, Tooltip } from 'antd';

import WeaTools from '../../plugin/wea-tools';
class PortalPage extends React.Component {

    constructor(props) {
        super(props);
        this.isMounted = false;
        this.state = {
            winWidth: document.body.offsetWidth,
            winHeight: document.body.offsetHeight,
        };
    }

    componentWillUnmount() {
        this.isMounted = false;
    }

    componentDidMount() {
        this.isMounted = true;
        this.scrollPage();
        jQuery(window).resize(() => {
            this.isMounted && this.scrollPage();
        });
    }

    scrollPage = () => {
        this.setState({ winHeight: document.body.offsetHeight, winWidth: document.body.offsetWidth });
    }

    openList = (category) => {
        let url = "/govern/spa/index1.html#/formmode/governor?cid=" + category.id;
        let id = "2";
        if (category.type == "task") {
            url = "/govern/spa/index1.html#/formmode/task?dealtype=" + category.dealtype;
            id = category.id;
        }

        WeaTools.onUrl(id, category.objname, url);
    }

    getCards = (index, height, padding) => {
        const categorys = this.props.categorys;
        const countMap = this.props.countMap;
        let obj = {};
        if (index < 6) {
            obj = categorys[index];
        } else if (index == 6) {
            let count = countMap["0"] ? countMap["0"] : 0;
            obj = { type: "task", id: "5", objname: "主办任务", dealtype: "0", count: count, color: "#7cc5e9", background: "url(/govern/image/zhuban.png)" }
        } else if (index == 7) {
            let count = countMap["1"] ? countMap["1"] : 0;
            obj = { type: "task", id: "6", objname: "协办任务", dealtype: "1", count: count, color: "#7cc5e9", background: "url(/govern/image/xieban.png)" }
        }
        if (obj) {
            return (
                <Card onClick={this.openList.bind(this, obj)} className="Dblist" style={{ marginBottom: padding }} bordered={false}>
                    <div className="container" style={{ height: height, background: obj.color || "#62d7d3" }}>
                        <div className="icon" style={{ backgroundImage: obj.background || "url(/govern/image/zhishi.png)" }}></div>
                        <div className="dot">{obj.count}</div>
                        &nbsp; &nbsp;
                        <div style={{ height: "1px", position: "absolute", top: "67%", background: "#17a0ac", width: "100%" }}></div>
                                    <div className="name">
                            {obj.objname}
                        </div>
                    </div>
                </Card>
            )
        }
    }

    render() {
        let { winWidth, winHeight } = this.state;
        let pad = (winWidth < 1200) ? 10 : winWidth * 0.17;
        //let height = winWidth * 0.078;
        let height = winHeight * 0.181
        let padding = winHeight * 0.03;
        let lHeight = height * 2 + padding;
        let standerWidth = winWidth - pad * 2;
        //let cardCol0 = this.getCards(0);
        //console.log("pad", pad, "height", height, "padding", padding, "lHeight", lHeight);
        return (
            <div style={{ width: winWidth }}>
                <div style={{ padding: "50px " + pad + "px", /*background: "#f0f2f5" */background: "url(/govern/image/04.jpg)" }}>
                    <Row gutter={24}>
                        <Col xl={14} lg={24} md={24} sm={24} xs={24} style={{ marginBottom: padding, width: parseInt(standerWidth * (14 / 24)) }}>
                            <Card className="Dblist" bordered={false}>
                                <iframe src={this.props.portalLink} frameborder="0" style={{ border: 0, width: "100%", height: lHeight }} />
                            </Card>
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24} style={{ width: parseInt(standerWidth * (5 / 24)) }}>
                            {this.getCards(6, height, padding)}
                            {this.getCards(0, height, padding)}
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24} style={{ width: parseInt(standerWidth * (5 / 24)) }}>
                            {this.getCards(7, height, padding)}
                            {this.getCards(1, height, padding)}
                        </Col>
                    </Row>

                    <Row gutter={24}>
                        <Col xl={7} lg={24} md={24} sm={24} xs={24} style={{ marginBottom: padding, width: parseInt(standerWidth * (7 / 24)) }}>
                            <Card className="Dblist" style={{ marginBottom: padding, background: "#f0f2f5" }} bordered={false}>
                                <iframe src={"/govern/view/echart/govern_bar.jsp?height=" + parseInt(lHeight)} frameborder="0"
                                    style={{ border: 0, width: "100%", height: lHeight, overflow: "hidden" }} />
                            </Card>
                        </Col>
                        <Col xl={7} lg={24} md={24} sm={24} xs={24} style={{ marginBottom: padding, width: parseInt(standerWidth * (7 / 24)) }}>
                            <Card className="Dblist" style={{ marginBottom: padding, background: "#f0f2f5" }} bordered={false}>
                                <iframe src={"/govern/view/echart/govern_pie.jsp?height=" + parseInt(lHeight)} frameborder="0"
                                    style={{ border: 0, width: "100%", height: lHeight, overflow: "hidden" }} />
                            </Card>
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24} style={{ width: parseInt(standerWidth * (5 / 24)) }}>
                            {this.getCards(2, height, padding)}
                            {this.getCards(4, height, padding)}
                        </Col>
                        <Col xl={5} lg={24} md={24} sm={24} xs={24} style={{ width: parseInt(standerWidth * (5 / 24)) }}>
                            {this.getCards(3, height, padding)}
                            {this.getCards(5, height, padding)}
                        </Col>
                    </Row>
                </div >
            </div >
        )
    }

}

export default PortalPage