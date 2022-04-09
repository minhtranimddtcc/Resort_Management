import React, { useContext, useRef } from 'react';
import './Login.css'
import Auth from '../../../helpers/Auth';

function Login() {
    const auth = useContext(Auth);
    const username = useRef();
    const password = useRef();
    const rememberMe = useRef();
    function submitHandler(event){
        let usr = username.current.value;
        let pwd = password.current.value;
        let rem = rememberMe.current.checked;
        event.preventDefault();
        auth.authenticate(usr, pwd, rem);
    }
    return (
        <div className="login-form-container" id="login">
            <form onSubmit={submitHandler}>
                <h3>log in form</h3>
                <input type="text" placeholder="Enter your username" className="box" ref={username}/>
                <input type="password" placeholder="Enter your password" className="box" ref={password} />
                <div className="remember">
                    <input type="checkbox" name="" id="remember-me" ref={rememberMe}/>
                    <label htmlFor="remember-me">remember me</label>
                </div>
                <input type="submit" value="log in" className="btn" />
                <p>forget password? <a href="/#">Click here</a></p>
                <p>don't have an account? <a href="/#">Create one</a></p>
            </form>
        </div>
    );
}

export default Login;