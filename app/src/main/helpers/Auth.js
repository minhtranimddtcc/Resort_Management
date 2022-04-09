import Axios from 'axios';
import { createContext,useState,useEffect } from 'react';
import { useHistory } from 'react-router-dom';
const Auth = createContext({
    isAuthenticated: false,
    authenticate: ()=>{},
    unauthenticate: ()=>{}
})

export function AuthProvider(props){
    const [isAuthen, setIsAuthen] = useState(false);
    const history = useHistory();
    function authenticateHandler(username, password, rememberMe){
        if (isAuthen === true) return;
        Axios.get("http://localhost:3001/api/authenticate", {
            params: {
                username: username,
                password: password
            }
        }).then(
            (response) => {
                let message = response.data;
                if (message === "Success") {
                    setIsAuthen(true);
                    localStorage.setItem('rememberMe', rememberMe);
                    localStorage.setItem('username', rememberMe ? username:"");
                    localStorage.setItem('password', rememberMe ? password:"");
                    history.push('/admin');
                }
            }
        );
    }

    function unauthenticateHandler(){
        setIsAuthen(false);
        localStorage.setItem('rememberMe','false');
        localStorage.setItem('username','');
        localStorage.setItem('password','');
        history.push('/');
    }

    useEffect(()=>{
        const rem = localStorage.getItem('rememberMe') === 'true';
        if (rem) {
            const usr = localStorage.getItem('username');
            const pwd = localStorage.getItem('password');
            authenticateHandler(usr, pwd, rem);
        }
        // eslint-disable-next-line
    }, []);

    const context = {
        isAuthenticated: isAuthen,
        authenticate: authenticateHandler,
        unauthenticate: unauthenticateHandler
    }
    return <Auth.Provider value={context}>
        {props.children}
        </Auth.Provider>;
}

export default Auth;