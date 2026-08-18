// ** React Imports
import { useState, useEffect } from "react";

// ** Third Party Components

import { X,Image } from "react-feather";



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
import userPlaceHolder from "../../../assets/images/avatars/backBanner.jpeg";



const AddUpdateModal = ({ open, handleModal, activity, isadd }) => {
  // ** State
  const [title, setTitle] = useState(activity.title);
  const [desc, setDesc] = useState(activity.description);

  const [check, setCheck] = useState(false);
  const [logoImage, setlogoImage] = useState(activity.image);
  const [bannerImage, setBannerImage] = useState(activity.banner);
  const [activityImageFile, setactivityImageFile] = useState();
  const [bannerImageFile, setBannerImageFile] = useState();


  const [inputValues, setInputValue] = useState({
    title: activity.title,
    desc: activity.description,
    iconFile: "",
  });

  const [validation, setValidation] = useState({
    title: "",
    desc: "",
    iconFile: "",

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

    if (isadd) {
      if (name === "iconFile") {
        //last Name validation
        if (!value.name) {
          errors.iconFile = "Icon is required";
        } else {
          errors.iconFile = "";
        }
      }


    } else {
      errors.iconFile = ""

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

  

    



    if (isadd) {
      if (!inputValues?.iconFile?.name) {
        errors.iconFile = "Icon is required"
      } else {
        errors.iconFile = ""

      }


    } else {
      errors.iconFile = ""

    }

    setValidation({ ...validation, errors });


    if (
      validation.title === "" &&
      validation.desc === "" &&
      validation.iconFile === "" 
     

    ) {
      isadd ? AddType() : UpdateMenuCatagory()
    }
  };




  useEffect(() => {
    if (!isadd) {

      setTitle(activity.title ? activity.title : '');
      // setBannerImage(activity.banner_url)
      setlogoImage(activity.image_url)
      setCheck(activity.status ? activity.status : false)
    }

  }, [activity]);
  const token = localStorage.getItem("token");

  const navigate = useNavigate();

  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const AddType = () => {
    const formData = new FormData();
    formData.append("title", inputValues.title);
    formData.append("description", inputValues.desc);
    formData.append("image", inputValues.iconFile);
    // formData.append("banner", bannerImageFile);
    // formData.append("status", check);
    // formData.append("certificates", 10);
    axios({
      method: "post",
      url: "/admin/gallery/create",

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {
        console.log("menuItmeStaus", response);
        handleModal();
        // navigate(`${process.env.REACT_APP_FOLDER}/activity-listing`);
        // setModal(false)
        toast.success("Added successfully");
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error(err.response.data.message);
      });

  }



  const UpdateMenuCatagory = () => {
    const formData = new FormData();

    formData.append("id", activity.id);
    formData.append("title", inputValues.title);
    formData.append("description", inputValues.desc);
    formData.append("image", inputValues.iconFile);
    // formData.append("banner", bannerImageFile);
    // formData.append("status", check);
    // formData.append("certificates", 10);

    axios({
      method: "put",
      url: `/admin/gallery/update/${activity.id}`,

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {
        console.log("menuItmeStaus", response);
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/gallery`);
        // setModal(false)
        toast.success("Updated successfully!");
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error(err.response.data.message ? err.response.data.message : "Something wrong");
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
          {isadd ? 'Add SKU Gallery' : `Update SKU Gallery #${activity.id}`}
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
                  type="text"
                  id="input-default"
                  placeholder={'Enter Title'}
                  value={inputValues.title}
                  onChange={(e) => {
                    handleChange("title", e.target.value)
                  }
                  }
                />
                {validation.title && (
                  <p
                    className="text-danger mb-0"
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
                  placeholder={'Enter Description'}
                  value={inputValues.desc}
                  onChange={(e) => {
                    handleChange("desc", e.target.value)
                  }
                  }

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
              Image <span><i>( Recommend Size : 400 x 300 )</i></span>
            </Label>
            <div>
              <img
                src={logoImage ? logoImage : userPlaceHolder}
                //   src={logoImage}
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
                    handleChange("iconFile", e.target.files[0]);
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
            {validation.iconFile && (
              <p
                className="text-danger mb-0"
                style={{ marginTop: "6px" }}
              >
                {validation.iconFile}
              </p>
            )}
          </div>


          {/* <div
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
          </div> */}

          <div className="  mt-1">
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
