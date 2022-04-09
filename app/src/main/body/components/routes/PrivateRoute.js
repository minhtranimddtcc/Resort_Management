import React, { useContext } from 'react';
import { Route, Redirect } from "react-router-dom";
import Auth from '../../../helpers/Auth';

export default function PrivateRoute({component: Component,...rest}){
    const { isAuthenticated } = useContext(Auth);
    return (
        <Route
        {...rest}
        render={props => {
          if (isAuthenticated) {
            return <Component {...props} />;
          } else {
            return (
              <Redirect
                to={{
                  pathname: "/",
                  state: {
                    from: props.location
                  }
                }}
              />
            );
          }
        }}
      />
    );

};