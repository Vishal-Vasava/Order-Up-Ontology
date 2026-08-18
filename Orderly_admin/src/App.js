import React, { Suspense,useState } from "react";
import { Toaster } from "react-hot-toast";
import { useNavigate } from "react-router-dom";
import SetupInterceptors from "./SetupInterceptor";

// ** Router Import
import Router from "./router/Router";


function NavigateFunctionComponent(props) {
  let navigate = useNavigate();
  const [ran,setRan] = useState(false);

  {/* only run setup once */}
  if(!ran){
     SetupInterceptors(navigate);
     setRan(true);
  }
  return <></>;
}


const App = () => {
  return (
    <Suspense fallback={null}>
      <div><Toaster/></div> 
      {<NavigateFunctionComponent />}
      <Router />
    </Suspense>
  );
};

export default App;
