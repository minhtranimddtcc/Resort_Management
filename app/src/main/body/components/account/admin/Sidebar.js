import './Sidebar.css';
import React from 'react';
import { useHistory, useLocation } from 'react-router-dom';


function Sidebar() {
    const location = useLocation();
    const history = useHistory();
    
    // leftArrow.onClick = function(){
    //     sideBar.classList.toggle("active");
    // }
    function leftArrow_handle(){
        let leftArrow = document.getElementById('leftArrow');
        let sideBar = document.querySelector(".sidebar");
        let rightArrow = document.getElementById('rightArrow');
        let sidebarTitle = document.querySelector('.sidebarTitle');
        let otherpage = document.querySelector('.otherpage');
        sideBar.classList.toggle("active");
        leftArrow.classList.toggle("active");
        rightArrow.classList.toggle("active");
        sidebarTitle.classList.toggle("active");
        otherpage.classList.toggle('active');
    }
    function rightArrow_handle(){
        let rightArrow = document.getElementById('rightArrow');
        let sideBar = document.querySelector(".sidebar");
        let leftArrow = document.getElementById('leftArrow');
        let sidebarTitle = document.querySelector('.sidebarTitle');
        let otherpage = document.querySelector('.otherpage');
        sideBar.classList.remove('active');
        rightArrow.classList.remove("active");
        leftArrow.classList.remove("active");
        sidebarTitle.classList.remove("active");
        otherpage.classList.remove('active');
    }
    return (
        <div className="sidebar">
            <ul className="sidebarList">
                <li className="sidebarTitle"> Dashboard </li>
                <i className="fas fa-angle-double-left" onClick = {leftArrow_handle} id="leftArrow"></i>
                <i className="fas fa-angle-double-right" onClick = {rightArrow_handle} id="rightArrow"></i>
                <li className={`sidebarListItem ${location.pathname==='/admin'  ?'active':''}`} onClick={()=>history.push('/admin')}>
                    <div>
                        <i className="fas fa-home"></i>
                        <span className = "labelIcon">Home</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/customer'?'active':''}`} onClick={()=>history.push('/admin/customer')}>
                    <div>
                        <i className="fas fa-users"></i>
                        <span className = "labelIcon">Customer</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname.startsWith('/admin/reservation')?'active':''}`} onClick={()=>history.push('/admin/reservation')}>
                    <div>
                        <i className="fas fa-receipt"></i>
                        <span className = "labelIcon">Reservation</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/roomtype'?'active':''}`} onClick={()=>history.push('/admin/roomtype')}>
                    <div>
                        <i className="fas fa-bed"></i>
                        <span className = "labelIcon">Room Type</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/settings'?'active':''}`} onClick={()=>history.push('/admin/settings')}>
                    <div>
                        <i className="fas fa-cog"></i>
                        <span className = "labelIcon">Settings</span>
                    </div>
                </li>
            </ul>
        </div>
    );
}

export default Sidebar;