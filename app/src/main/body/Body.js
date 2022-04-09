import React from 'react';
import { Route, Switch } from 'react-router-dom';
import PrivateRoute from './components/routes/PrivateRoute';
import "./Body.css";
import Login from './components/account/Login';
import FormReservation from './components/FormReservation';
import RoomList from './components/RoomList';
import Admin from './components/account/Admin';
function Body(props) {
    return (
        <div className="body">
            <Switch>
                <Route path="/reservation" exact>
                    <FormReservation />
                </Route>
                <PrivateRoute path="/my-room" exact component={RoomList} />
                <Route path="/login" exact>
                    <Login />
                </Route>
                <PrivateRoute path="/admin" component={Admin} />
            </Switch>
        </div>
    );
}

export default Body;