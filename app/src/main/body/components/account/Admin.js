import React from 'react';
import './Admin.css';
import Sidebar from './admin/Sidebar';
import Home from './admin/Home';
import Customer from './admin/Customer';
import RoomType from './admin/RoomType';
import Reservation from './admin/Reservation';
import { Route,Switch } from 'react-router-dom';

function Admin() {
    return (
        <div className="container">
            <Sidebar />
            <div className ="otherpage">
                <Switch>
                     <Route path="/admin" exact> <Home/></Route>
                     <Route path="/admin/customer"> <Customer/></Route>
                     <Route path="/admin/reservation/:id"> <Reservation/></Route>
                    <Route path="/admin/roomtype"><RoomType/></Route>
                </Switch>
            </div>
        </div>
    );
}

export default Admin;