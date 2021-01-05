class Root extends React.Component {
    render() {
        return (
            <Provider store={store}>
                <Router history={browserHistory}>
                    <Route path="/">
                        {Formmode.router}
                    </Route>
                </Router>
            </Provider>
        );
    }
};