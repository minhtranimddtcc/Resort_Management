import Main from './main/Main';
import { BrowserRouter as Router } from 'react-router-dom';
import { DBHelperProvider }  from './main/helpers/DBHelper';
import { AuthProvider } from './main/helpers/Auth';

function App() {
  return (
    <Router>
      <div className="App">
        <AuthProvider>
          <DBHelperProvider>
            <Main/>
          </DBHelperProvider>
        </AuthProvider>
      </div>
    </Router>
  );
}

export default App;
