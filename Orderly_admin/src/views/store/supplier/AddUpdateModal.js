// ** React Imports
import { useState, useEffect } from "react";

// ** Third Party Components

import { X,Image } from "react-feather";
import Select from "react-select";
import { selectThemeColors } from "@utils";



// ** Reactstrap Imports
import {
  Modal,
  Input,
  Label,
  Button,
  ModalHeader,
  ModalBody,
  InputGroup,
  InputGroupText,
  Row,
  Col,
} from "reactstrap";

// ** Styles
import "@styles/react/libs/flatpickr/flatpickr.scss";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";

import { IconButton } from "@mui/material";
import { PhotoCamera } from "@mui/icons-material";
import userPlaceHolder from "../../../assets/images/avatars/avatar-blank.png";
import userProfile from "../../../assets/images/avatars/Logo.jpeg";
import userBackBanner from "../../../assets/images/avatars/backBanner.jpeg";
import { updateEvent } from "../../components/calendar/store";

import makeAnimated from "react-select/animated";


const animatedComponents = makeAnimated();

// const allSchedule = {}



const AddUpdateModal = ({ open, handleModal, activity, isadd }) => {
  // ** State
  const [title, setTitle] = useState(activity.name);
  const [desc, setDesc] = useState(activity.desc);

  const [check, setCheck] = useState(false);
  const [currency, setCurrency] = useState();
  const [logoImage, setlogoImage] = useState(activity.image);
  const [bannerImage, setBannerImage] = useState(activity.banner);
  const [activityImageFile, setactivityImageFile] = useState();
  const [bannerImageFile, setBannerImageFile] = useState();
  const [allCurrency, setAllCurrency] = useState([]);
  const [allSchedule, setAllSchedule] = useState({days:[{label : "Select Days",value:""}],frequency:[{label : "Select Frequency",value:""}]});
  const [urgentDelivery, setUrgentDelivery] = useState(false);
 
  const [inputValues, setInputValue] = useState({
    title: activity.name,
    desc: activity.desc,
    bannerImageFile:"",
    logoImageFile:"",
    currency : "",
    selectCurrency: {
      label: activity?._currency?.name,
      value: activity?._currency?._id,
    },
    selectschedule: {
      days: {label:activity?._schedule?.days,value:activity?._schedule?.days},
      frequency:{label:activity?._schedule?.frequency,value:activity?._schedule?.frequency}
    },
    deliveryCharge : activity?.urgent_delivery_charge,
    // urgent_delivery : activity?.urgent_delivery,
  });

  const [validation, setValidation] = useState({
    title: "",
    desc: "",
    banner:"",
    logo:"",
    selectCurrency : "",

  });

  

  const getRecord = () => {
    axios
      .get("/admin/currency", { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        const currency = response.data;
        const allCurrency = currency.map((i) => {
          return { label: i.name, value: i._id };
        });
        setAllCurrency(allCurrency);
      })
      .catch((err) => {});

    axios
      .get("/admin/schedules", { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        let allSchedules = {
          days : response.data.days,
          frequency: response.data.frequency
        };

        allSchedules.days = allSchedules.days.map((i) => {
          return { label: i, value: i };
        });
        allSchedules.days.unshift({label : "Select Days",value:""})
        allSchedules.frequency = allSchedules.frequency.map((i) => {
          return { label: i, value: i };
        });
        allSchedules.frequency.unshift({label : "Select Frequency",value:""})
        let _allSchedule = {};
        _allSchedule.days = allSchedules.days;
        _allSchedule.frequency = allSchedules.frequency;
        setAllSchedule(_allSchedule);
      })
      .catch((err) => {});

      
        
  };

  function handleChange(name, value) {
    let inpName = name;
    let inpVal = value;
    if(name == 'schedule_days') {
      let val = inputValues.selectschedule;
      val.days = value;
      inpName = 'selectschedule'
      inpVal = val;
    }
    else if(name == 'schedule_frequency') {
      let val = inputValues.selectschedule;
      val.frequency = value;
      inpName = 'selectschedule'
      inpVal = val;
    }
    setInputValue({ ...inputValues, [inpName]: inpVal });
    let errors = validation;

    
    if (name === "title") {
      //first Name validation
      if (!value.trim()) {
        errors.title = "Title is required";
      } else {
        errors.title = "";
      }
    }

    if (name === "desc") {
      //last Name validation
      if (!value.trim()) {
        errors.desc = "Description is required";
      } else {
        errors.desc = "";
      }
    }
    
    if (name === "deliveryCharge") {
      if (value < 0) {
        errors.delivery_charge = "Invalid Delivery Charge";
      } else {
        errors.delivery_charge = "";
      }
    }

    if (name === "schedule_days") {
      if (!value?.value) {
        errors.schedule_days = "Please select schedule days";
      } else {
        errors.schedule_days = "";
      }
    }

    if (name === "schedule_frequency") {
      if (!value?.value) {
        errors.schedule_frequency = "Please select schedule frequency";
      } else {
        errors.schedule_frequency = "";
      }
    }

    

    
if(isadd){
    if (name === "logoImageFile") {
      //last Name validation
      if (!value?.name) {
        errors.logoImageFile = "Logo is required";
      } else {
        errors.logoImageFile = "";
      }
    } 

    if (name === "bannerImageFile") {
      //last Name validation
      if (!value?.name) {
        errors.bannerImageFile = "Banner is required";
      } else {
        errors.bannerImageFile = "";
      }
    } 
  }else{

   
      errors.bannerImageFile = ""
      errors.logoImageFile = ""
    
  }
  
     
    
    
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    let errors = validation;
    

    //title validation
    if (!inputValues.title?.trim()) {
      errors.title = "Title is required";
    } else {
      errors.title = "";
    }

    //description  validation
    if (!inputValues.desc?.trim()) {
      errors.desc = "Description is required";
    } else {
      errors.desc = "";
    }
    if (!inputValues.selectCurrency?.value) {
      errors.selectCurrency = "Please select Currency";
    } else {
      errors.selectCurrency = "";
    }

    
    if (inputValues.deliveryCharge?.value < 0) {
      errors.delivery_charge = "Invalid Delivery Charge";
    } else {
      errors.delivery_charge = "";
    }

    

    
    if (!inputValues.selectschedule.days?.value) {
      errors.schedule_days = "Please select schedule days";
    } else {
      errors.schedule_days = "";
    }
    

    
    if (!inputValues.selectschedule.frequency?.value) {
        errors.schedule_frequency = "Please select schedule frequency";
      } else {
        errors.schedule_frequency = "";
      }

    
    if(isadd){
    if(!inputValues?.logoImageFile?.name){
      errors.logoImageFile = "Logo is required"
    }else{
      errors.logoImageFile = ""

    }

    if(!inputValues?.bannerImageFile?.name){
      errors.bannerImageFile = "Banner is required"
    }else{
      errors.bannerImageFile = ""

    }
  }else{
    errors.bannerImageFile = ""
    errors.logoImageFile = ""
  }
   
    setValidation({ ...validation, errors });
   
    
    if (
      validation.title === "" &&
      validation.desc === "" && 
      validation.logoImageFile === "" &&
      validation.bannerImageFile === "" &&
      validation.selectCurrency === "" 
    ) {
      isadd ? AddType() : UpdateMenuCatagory() 
    }
  };


  useEffect(() => {
    getRecord();
  }, []);


  useEffect(() => {
    if (!isadd) { 
       
      // setTitle( activity.name ? activity.name : null);
    setInputValue({ ...inputValues, title : activity.name });

      setBannerImage(activity.banner_url)
      setlogoImage(activity.icon_url)
      setCheck(activity.status ? activity.status : false)
      setUrgentDelivery(activity.urgent_delivery ? activity.urgent_delivery : false)
      setCurrency(activity?._currency?._id);
    } else {
      setBannerImage(userBackBanner ? userBackBanner : userPlaceHolder); 
      setlogoImage(userProfile ? userProfile : userPlaceHolder)
    }

  }, [activity]);
  const token = localStorage.getItem("token");

  const navigate = useNavigate();

  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const AddType = () => {
    const formData = new FormData();
    formData.append("name", inputValues.title);
    formData.append("desc",inputValues.desc);
    formData.append("image", inputValues.logoImageFile);
    formData.append("banner", inputValues.bannerImageFile);
    formData.append("status", check);
    formData.append("_currency", inputValues?.selectCurrency?.value);
    formData.append("schedule_days", inputValues?.selectschedule?.days?.value);
    formData.append("schedule_frequency", inputValues?.selectschedule?.frequency?.value);
    formData.append("urgent_delivery",urgentDelivery);
    formData.append("urgent_delivery_charge",inputValues.deliveryCharge ?? 0);
    // formData.append("certificates", 10);
    axios({
      method: "post",
      url: "/admin/store/create",
      
      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {
        handleModal();
        // navigate(`${process.env.REACT_APP_FOLDER}/activity-listing`);
        // setModal(false)
        toast.success("Store create Successfully");
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error("Something went wrong!");
      });

  }


 
  const UpdateMenuCatagory = () => {
    const formData = new FormData();

    formData.append("id", activity.id);
    formData.append("name", inputValues.title);
    formData.append("desc", inputValues.desc);
    formData.append("image", inputValues.logoImageFile);
    formData.append("banner", inputValues.bannerImageFile);
    formData.append("status", check);
    formData.append("_currency", inputValues?.selectCurrency?.value);
    formData.append("schedule_days", inputValues?.selectschedule?.days?.value);
    formData.append("schedule_frequency", inputValues?.selectschedule?.frequency?.value);
    formData.append("urgent_delivery",urgentDelivery);
    formData.append("urgent_delivery_charge",inputValues.deliveryCharge ?? 0);
    // formData.append("certificates", 10);

    axios({
      method: "put",
      url: `/admin/store/update/${activity.id}`,

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/supplier-listing`);
        // setModal(false)
        toast.success("Store Update Successfully");
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error("Something went wrong!");
      });
  };

  // styles for the select
  const customStyles = {
    // option: (provided, state) => ({
    //   ...provided,
    //   borderBottom: "1px solid #dede",
    //   color: state.isSelected ? "#53e3a6" : "green",
    //   backgroundColor: "white",
    //   padding: 10
    // }),
    // control: (base, state) => ({
    //   ...base,
    //   color: state.isSelected ? "#53e3a6" : "green",
    //   border: "1px solid rgba(255, 255, 255, 0.4)",
    //   boxShadow: "none",
    //   margin: 20,
    //   "&:hover": {
    //     border: "1px solid rgba(255, 255, 255, 0.4)"
    //   }
    // }),
    placeholder: (base) => ({
      ...base,

      fontSize: "1em",
      color: "#53e3a6",
      fontWeight: 200,
      position: 'absolute',
      

    })
  };

  return (
    <Modal
      isOpen={open}
      toggle={handleModal}
      className="sidebar-lg"
      modalClassName="modal-slide-in"
      contentClassName="pt-0"
    >

      <ModalHeader
        className="mb-1"
        toggle={handleModal}
        close={CloseBtn}
        tag="div"
      >
        <h5 classNam="modal-title">
          {isadd ? 'Add Store Information' : `Update Store Information1 #${activity.id}`}
        </h5>
      </ModalHeader>
      <ModalBody className="flex-grow-1">
        <div className="mb-1" style={{ padding: "10px" }}>
          <Row>
              <Col md={12}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Store name*
                  </Label>
                  <Input
                    type="text"
                    id="input-default"
                    placeholder={'Enter Store name'}
                    value={inputValues.title}
                    name="title"
                    invalid={validation.title ? true : false}
                   
                    onChange={(e) => handleChange("title", e.target.value)}

                  />
                   {validation.title && (
                      <p
                        className="text-danger  mb-0"
                        style={{ marginTop: "6px" }}
                      >
                        {validation.title}
                      </p>
                    )}
                </div>
              </Col>
              <Col md={12}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Store Description*
                  </Label>
                  <Input
                    type="textarea"
                    id="input-default"
                    placeholder={'Enter Store name'}
                    name="desc"
                    value={inputValues.desc}
                    invalid={validation.desc ? true : false}

                    onChange={(e) => handleChange("desc", e.target.value)}

                  />
                    {validation.desc && (
                      <p
                        className="text-danger mb-0"
                        style={{ marginTop: "6px" }}
                      >
                        {validation.desc}
                      </p>
                    )}
                </div>
              </Col>

            </Row> 


         


          <div className="flex justify-end items-end">
            <Label
              className="form-label"
              for="input-default"
            // style={{  marginLeft: "1rem" }}
            >
              Icon* <span><i>( Recommend Size : 300 x 300 )</i></span>
            </Label>
            <div>
              
              <img
                // src={inputValues.logoImageUrl ? inputValues.logoImageUrl : (userProfile ? userProfile : userPlaceHolder)}
                src={logoImage}
                style={{
                  objectFit: "cover",
                  width: "100px",
                  height: "100px",
                  border: "1px solid #d3d3d3",
                  padding: "0.2rem",
                }}
              />
              <input
                hidden
                accept="image/*"
                id="icon-button-file1"
                type="file"
                onChange={(e) => {

                  if (e.target.files.length) {
               
                  setlogoImage(
                    URL.createObjectURL(e.target.files[0])
                  );
                   
                  handleChange("logoImageFile",e.target.files[0])
                  }
                }}
              />
              <label htmlFor="icon-button-file1">
                  <IconButton
                    color="primary"
                    className="p-0 ml-6"
                    aria-label="upload picture"
                    component="span"
                    style={{ marginLeft: "1rem" }}
                  ><small>Upload </small>
                    <Image size={20} />
                  </IconButton>
                </label>
              
            </div>
            {validation.logoImageFile && (
                      <p
                        className="text-danger mb-0"
                        style={{ marginTop: "6px" }}
                      >
                        {validation.logoImageFile}
                      </p>
                    )}
          </div>
          <div className="flex justify-end items-end">
            <Label
              className="form-label"
              for="input-default"
            // style={{  marginLeft: "1rem" }}
            >
              Banner* <span><i>( Recommend Size : 800 x 400 )</i></span>
            </Label>
            <div>
               
              <img
                src={bannerImage}
                // src={inputValues.bannerImageUrl ? inputValues.bannerImageUrl : (userBackBanner ? userBackBanner : userPlaceHolder)}
                //   src={logoImage}
                style={{
                  objectFit: "cover",
                  width: "200px",
                  height: "100px",
                  border: "1px solid #d3d3d3",
                  padding: "0.2rem",
                }}
              />
              <input
                hidden
                accept="image/*"
                id="icon-button-file12"
                type="file"
                onChange={(e) => {
                  if (e.target.files.length) {
                    // var b_url = URL.createObjectURL(e.target.files[0])
                    setBannerImage(
                      URL.createObjectURL(e.target.files[0])
                    );
                  handleChange("bannerImageFile",e.target.files[0])

                  
                  
                  }
                }}
              />
              <label htmlFor="icon-button-file1">
                  <IconButton
                    color="primary"
                    className="p-0 ml-6"
                    aria-label="upload picture"
                    component="span"
                    style={{ marginLeft: "1rem" }}
                  ><small>Upload </small>
                    <Image size={20} />
                  </IconButton>
                </label>
            </div>
          </div>
          {validation.bannerImageFile && (
                      <p
                        className="text-danger mb-0"
                        style={{ marginTop: "6px" }}
                      >
                        {validation.bannerImageFile}
                      </p>
                    )}
          <div
            className="d-flex flex-column mb-1"
            style={{ marginTop: "0.5rem" }}
          >
            <Label for="switch-success" className="form-check-label mb-50">
              Activity {check === true ? "ON" : "OFF"}
            </Label>
            <div className="form-switch form-check-success">
              <Input
                type="switch"
                id="switch-success"
                name="success"
                checked={check}
                onChange={(e) => setCheck(e.target.checked ? true : false)}
              />
            </div>
          </div>

          <div
          className="d-flex flex-column mb-1"
          style={{ marginTop: "0.5rem" }}>
            <Label for="drop-currency" className="form-check-label mb-50">
              Currency
            </Label>
            
            <Select
              id="drop-currency"
              isClearable={false}
              theme={selectThemeColors}
              closeMenuOnSelect={true}
              components={animatedComponents}
              value={inputValues.selectCurrency}
              onChange={(e) => {
                handleChange("selectCurrency", e);
                setCurrency(e.value);
              }}
              options={allCurrency}
              className="react-select"
              classNamePrefix="select"
                />
              {validation.selectCurrency && (
                <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                  {validation.selectCurrency}
                </p>
              )}
            

          </div>

          <div
            className="d-flex flex-column mb-1"
            style={{ marginTop: "0.5rem" }}>

              
            <Label className='form-check-label mb-50' >
              Schedule
            </Label>
            <Select
            // type="text"
              id="drop-schedule-days"
              isClearable={false}
              theme={selectThemeColors}
              closeMenuOnSelect={true}
              components={animatedComponents}
              value={inputValues.selectschedule.days.value ? inputValues.selectschedule.days : allSchedule.days[0]}
              onChange={(e) => {
                handleChange("schedule_days", e);
                // setCurrency(e.value);
              }}
              options={allSchedule.days}
              className="react-select"
              classNamePrefix="select"
              Placeholder={"Search Country...."}
              // styles={customStyles}
                />
              {validation.schedule_days && (
                <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                  {validation.schedule_days}
                </p>
              )}


          </div>

          <div
            className="d-flex flex-column mb-1"
            style={{ marginTop: "0.5rem" }}>

            <Select
              id="drop-schedule-frequency"
              isClearable={false}
              theme={selectThemeColors}
              closeMenuOnSelect={true}
              components={animatedComponents}
              value={inputValues.selectschedule.frequency.value ? inputValues.selectschedule.frequency : allSchedule.frequency[0]}
              onChange={(e) => {
                handleChange("schedule_frequency", e);
                // setCurrency(e.value);
              }}
              options={allSchedule.frequency}
              className="react-select"
              classNamePrefix="select"
                />
              {validation.schedule_frequency && (
                <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                  {validation.schedule_frequency}
                </p>
              )}


          </div>
          <div
            className="d-flex flex-column mb-1"
            style={{ marginTop: "0.5rem" }}
          >
            <Label for="switch-success" className="form-check-label mb-50">
              Urgent Delivery {urgentDelivery === true ? "ON" : "OFF"}
            </Label>
            <div className="form-switch form-check-success">
              <Input
                type="switch"
                id="switch-urgent"
                name="urgent_delivery"
                checked={urgentDelivery}
                onChange={(e) => setUrgentDelivery(e.target.checked ? true : false)}
              />
            </div>
          </div>

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Urgent Delivery Charge*
            </Label>
            <Input
              type="number"
              id="input-default"
              placeholder={'Enter Urgent Delivery Charge'}
              value={inputValues.deliveryCharge ?? 0}
              name="delivery_charge"
              min="0"
              // invalid={validation.title ? true : false}
              
              onChange={(e) => handleChange("deliveryCharge", e.target.value)}

            />
              {validation.delivery_charge && (
                <p
                  className="text-danger  mb-0"
                  style={{ marginTop: "6px" }}
                >
                  {validation.delivery_charge}
                </p>
              )}
          </div>

          <div>
            {isadd ?
              <Button
                className="me-1"
                color="primary"
                onClick={handleSubmit}
              >
                Add
              </Button>
              :
              <Button
                className="me-1"
                color="primary"
                onClick={handleSubmit}
              >
                Update
              </Button>
            }

            <Button color="secondary" onClick={handleModal} outline>
              Cancel
            </Button>
          </div>
        </div>
      </ModalBody>
    </Modal>
  );
};

export default AddUpdateModal;
