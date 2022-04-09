import React from "react";
import Body from "./body/Body";
import Header from "./header/Header";

function Main(props) {
    return (
        <React.Fragment>
            <Header/>
            <Body/>
        </React.Fragment>
    );
}

export default Main;