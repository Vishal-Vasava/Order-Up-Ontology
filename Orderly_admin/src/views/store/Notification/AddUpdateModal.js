// ** React Imports
import { useState, useEffect } from "react";

// ** Third Party Components

import { X } from "react-feather";
import Select from 'react-select'
import makeAnimated from 'react-select/animated'
import { selectThemeColors } from '@utils'

const options = [
  { label: "All User", value: "all_user" },
  { label: "All Customer", value: "all_customer" },
  { label: "All Fleet Managers", value: "all_fleet_managers" },
  { label: "Selected User", value: "selected_user" }

];

const options1 = [
  { label: "All User", value: "all_user" },
  { label: "All Customer", value: "all_customer" },
  { label: "All Fleet Managers", value: "all_fleet_managers" },
  { label: "Selected User", value: "selected_user" }

];

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
import { updateEvent } from "../../components/calendar/store";

const AddUpdateModal = ({ open, handleModal, activity, isadd }) => {
  const animatedComponents = makeAnimated()

  const [inputValues, setInputValue] = useState({
    title: activity.title,
    desc: activity.description,
    sendTo:{label:"", value:""},
    selectUser:null,
  })

  const [allUsers, setAllUsers] = useState([])

  const [validation, setValidation] = useState({
    title: "",
    desc: "",
    sendTo:"",
    selectUser:"",
  });

  function handleChange(name, value) {
    setInputValue({ ...inputValues, [name]: value });
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

    if (name === "sendTo") {
      //last Name validation
      if (!value?.value) {
        errors.sendTo = "This is required";
      } else {
        errors.sendTo = "";
      }
    }

    if (inputValues?.sendTo?.value === "selected_user") {

     if (name === "selectUser") {
      //last Name validation
      if (!value?.length) {
        errors.selectUser = "This is required";
      } else {
        errors.selectUser = "";
      }
    }}
    
  } 

  const getAllUsers = () => {
    axios
    .get("/admin/users?all_user=true", { headers: { Authorization: `Bearer ${token}` } })
    .then((response) => {

      const usersListFormat = response.data.map((i) => {
        return {label:i.first_name + " " +i.last_name, value:i._id}
      })
      setAllUsers(usersListFormat);
      
    })
    .catch((err) => {
      console.log(err);
    });
  }

  useEffect(() => {
    getAllUsers()
  },[])

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

    if (!inputValues.sendTo?.value) {
      errors.sendTo = "This is required";
    } else {
      errors.sendTo = "";
    }

    if (inputValues?.sendTo?.value === "selected_user") {
      if (!inputValues.selectUser?.length) {
        errors.selectUser = "This is required";
      } else {
        errors.selectUser = "";
      }

    }else{
      errors.selectUser = "";
      
    }

    setValidation({ ...validation, errors });

    if (validation.title === "" && validation.desc === "" && validation?.sendTo === "" && validation?.selectUser === "") {
      isadd ? AddType() : UpdateMenuCatagory();
    }
  };


  console.log("incdscv", inputValues , validation);
  useEffect(() => {
    if (!isadd) {
      setInputValue({ ...inputValues, title: activity.name });
    }
  }, [activity]);
  const token = localStorage.getItem("token");

  const navigate = useNavigate();

  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const AddType = () => {
let userList = []
    if(inputValues?.selectUser?.length){

     userList = inputValues?.selectUser.map((i) => {
      return i.value
    })
  }

    console.log("usecsvv", userList);
   
    // const formData = new FormData();

    // formData.append("certificates", 10)
    
    axios
    .post("/admin/notifications/create", {
      title:inputValues?.title,
      description:inputValues?.desc,
      type:inputValues?.sendTo?.value,
      user: inputValues?.sendTo === "selected_user" ?userList : []
  },{ headers: { Authorization: `Bearer ${token}` } })
    .then((response) => {

      
      navigate(`${process.env.REACT_APP_FOLDER}/notifications`);
      // setModal(false)
      toast.success("Successfully created.");
      
    })
    .catch((err) => {
     // toast.error(err.response.data.message);
    });
    
   
    
    
  };

  const UpdateMenuCatagory = () => {
    // formData.append("id", activity.id);
    // formData.append("name", inputValues.title);
    // formData.append("desc", inputValues.desc);
    // formData.append("image", inputValues.logoImageFile);
    // formData.append("banner", inputValues.bannerImageFile);

    // formData.append("certificates", 10);

    axios({
      method: "put",
      url: `admin/faq/update/${activity._id}`,

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: inputValues,
    })
      .then((response) => {
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/notifications`);
        // setModal(false)
        toast.success("Successfully updated.");
      })
      .catch((err) => {
        console.log(err);
        toast.error(
          err.response.data.message
            ? err.response.data.message
            : "Something wrong"
        );
      });
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
          {isadd ? "Send Notifications" : `View Notifications #${activity._id}`}
        </h5>
      </ModalHeader>
      <ModalBody className="flex-grow-1">
        <div className="mb-1" style={{ padding: "10px" }}>
          <Row>
            <Col md={12}>
              <div className="mb-1">
                <Label className="form-label" for="input-default">
                  Title
                </Label>
                <Input
                  type="textarea"
                  id="input-default"
                  placeholder={"Please eneter title"}
                  value={inputValues.title}
                  name="title"
                  maxLength={100}
                  rows={2}
                  invalid={validation.title ? true : false}
                  onChange={(e) => handleChange("title", e.target.value)}
                />
                {validation.title && (
                  <p
                    className="text-danger ms-1 mb-0"
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
                  Description
                </Label>
                <Input
                  type="textarea"
                  id="input-default"
                  placeholder={"Please enter description 200 char max"}
                  maxLength={200}
                  name="desc"
                  rows={4}
                  value={inputValues.desc}
                  invalid={validation.desc ? true : false}
                  onChange={(e) => handleChange("desc", e.target.value)}
                />
                {validation.desc && (
                  <p
                    className="text-danger ms-1 mb-0"
                    style={{ marginTop: "6px" }}
                  >
                    {validation.desc}
                  </p>
                )}
              </div>
            </Col>
            <Col sm='12' className='mb-1'>
              <Label className='form-label' for='Status'>
                Send To*              </Label>

              <Select
                isClearable={false}
                theme={selectThemeColors}
                closeMenuOnSelect={true}
                components={animatedComponents}
                value={inputValues.sendTo}

                onChange={(e) => {
                  handleChange("sendTo", e)

                }
                }

                options={options}
                className='react-select'
                classNamePrefix='select'
              />
              {validation.sendTo && (
                <p
                  className="text-danger mb-0"
                  style={{ marginTop: "6px" }}
                >
                  {validation.sendTo}
                </p>
              )}
            </Col>
            {inputValues?.sendTo.value === "selected_user" ?
            <Col sm='12' className='mb-1'>
              <Label className='form-label' for='Status'>
              Select Users*              </Label>

              <Select
                isClearable={false}
                isMulti
                theme={selectThemeColors}
                closeMenuOnSelect={true}
                components={animatedComponents}
                value={inputValues.selectUser}

                onChange={(e) => {
                  console.log("cdsfs",e);
                  handleChange("selectUser", e)
                  
                }
                }

                options={allUsers}
                className='react-select'
                classNamePrefix='select'
              />
              {validation.selectUser && (
                <p
                  className="text-danger mb-0"
                  style={{ marginTop: "6px" }}
                >
                  {validation.selectUser}
                </p>
              )}
            </Col>:""}
          </Row>

          <div>
            {isadd ? (
              <Button className="me-1" color="primary" onClick={handleSubmit}>
                Add
              </Button>
            ) : (
              <Button className="me-1" color="primary" onClick={handleSubmit}>
                Update
              </Button>
            )}

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
