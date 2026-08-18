import axios from 'axios'
var counter_load=0;
const SetupInterceptors = (navigate) => {
    axios.interceptors.request.use(
      
      config => {
        counter_load++;
        document.body.classList.add('loading-indicator');
        const token = localStorage.getItem("token");
        return config
      },
      error => {
        // Promise.reject(error)
      }
    )
    axios.interceptors.response.use(
      res => {
        counter_load--;
        if(counter_load == 0)
        document.body.classList.remove('loading-indicator');
        return res
      },
      err => {
        counter_load--;
        if(counter_load == 0)
        document.body.classList.remove('loading-indicator');
        if(err.response && err.response.status && err.response.status == 401) {
          navigate(`${process.env.REACT_APP_FOLDER}/login`);
          // throw new Error(err.response.data.message);
        } else {
          return Promise.reject(err)
          // throw new Error(err.response.data.message);
        }
        
      }
    )
  
  };
  export default SetupInterceptors;
  