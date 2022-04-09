import React, { useRef,useContext, useEffect } from 'react';
import { Link, useHistory, useLocation } from 'react-router-dom';
import Auth from '../helpers/Auth';
import "./Header.css";
import logo from './images/logo.jpg';
function Header() {
    const history = useHistory();
    const location = useLocation();
    const auth = useContext(Auth);
    const isAuthenticated = auth.isAuthenticated;
    const DOMList = {
        accountButton: useRef(),
        accountMenu: useRef(),
        navBar: useRef(),
        navButton: useRef(),
        reservation: useRef()
    }

    useEffect(() => {
        if (location.pathname === "/reservation") {
            DOMList.reservation.current.classList.add("active");
        } else {
            DOMList.reservation.current.classList.remove("active");
        }
        // eslint-disable-next-line
    }, [location]);


    function Reservation_handle() {
        history.push("/reservation");
    }

    function Nav_handle() {
        DOMList.navBar.current.classList.toggle('active');
        DOMList.navButton.current.classList.toggle('active');
    }
    
    function Account_handle() {
        if (DOMList.accountButton.current.classList.contains('active')) {
            DOMList.accountButton.current.classList.remove('active');
            DOMList.accountMenu.current.classList.remove('active');
        } else {
            DOMList.accountButton.current.classList.add('active');
            DOMList.accountMenu.current.classList.add('active');
            DOMList.navBar.current.classList.remove('active');
            DOMList.navButton.current.classList.remove('active');
        }
    }

    return (
        <header className="header">
            <Link to="/" className="logo"><img src={logo} alt=""/>Hotel<span>California</span></Link>
            <nav id="nav-nav" className="navbar" ref={DOMList.navBar}>
                <Link to="/">Trang chủ</Link>
                <Link to="/reservation" onClick={Reservation_handle} ref={DOMList.reservation}>Đặt phòng</Link>
                <Link to="/news">Tin tức</Link>
                <Link to="/contact">Liên hệ</Link>
            </nav>
            <div className="icons">
                <div id="nav-btn" onClick={Nav_handle} className="fas fa-bars" ref={DOMList.navButton}></div>
                <div id="account-btn" onClick={Account_handle} className="fas fa-user" ref={DOMList.accountButton}></div>
            </div>
            <div className="dropdown" id="account-setting" ref={DOMList.accountMenu}>
                {!isAuthenticated && <Link to="/login">Đăng nhập</Link>}
                {!isAuthenticated && <Link to="/signin">Đăng ký</Link>}
                {isAuthenticated && <Link to="/admin">Quản lý resort</Link>}
                {isAuthenticated && <Link to="/account">Quản lý tài khoản</Link>}
                {isAuthenticated && <hr></hr>}
                {isAuthenticated && <Link to="/" onClick={()=>auth.unauthenticate()} style={{cursor:"pointer"}}>Đăng xuất<i className="fas fa-sign-out-alt"></i></Link>}
            </div>
        </header>
    );
}
export default Header;