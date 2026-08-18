// ** React Imports
import React, { useState, useEffect } from "react";

// ** Third Party Components

import { X } from "react-feather";

import PhoneInput from "react-phone-input-2";

import "react-phone-input-2/lib/bootstrap.css";
import InputPasswordToggle from "@components/input-password-toggle";

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
import { map } from "jquery";

const AddUpdateStaff = ({ open, handleModal, activity, isadd }) => {
  // ** State
  const [title, setTitle] = useState(activity.supplier_type);
  const [check, setCheck] = useState(false);
  const [activityImageModal, setactivityImageModal] = useState(activity.image);
  const [activityImageFile, setactivityImageFile] = useState();
  const [phone, setPhone] = useState("");
  const [error, setError] = useState("");

  const [combinePhone, setCombine] = useState("");
  const [countryCode, setCountryCode] = useState("");
  const [id, setId] = useState("");
  const [titleData, setTitleData] = useState([
    {
      id: 1,
      lang: "en",
      name: "first_name",
      titles: "First Name",
      placeholder: "Enter First Name",
      value: "",
      type: "text",
      required: true,
      haserror: false,
      errmsg: "",
    },
    {
      id: 2,
      lang: "en",
      name: "last_name",
      titles: "Last Name",
      placeholder: "Enter Last Name",
      value: "",
      type: "text",
      required: true,
      haserror: false,
      errmsg: "",
    },
    {
      id: 3,
      lang: "en",
      name: "email",
      titles: "Email",
      placeholder: "Enter the Email",
      value: "",
      type: "email",
      required: true,
      haserror: false,
      errmsg: "",
    },
    {
      id: 4,
      lang: "en",
      name: "confirmemail",
      titles: "Confirm Email",
      placeholder: "Enter the Confirm Email",
      value: "",
      type: "email",
      required: true,
      haserror: false,
      errmsg: "",
    },
    {
      id: 5,
      lang: "en",
      name: "Password",
      titles: "Password",
      placeholder: "Enter the Password",
      value: "",
      type: "password",
      haserror: false,
      errmsg: "",
    },
    {
      id: 6,
      lang: "en",
      name: "Confirm Password",
      titles: "Confirm Password",
      placeholder: "Enter the Confirm Password",
      value: "",
      type: "password",
      haserror: false,
      errmsg: "",
    },
  ]);
  console.log("titledata", titleData);

  useEffect(() => {
    if (isadd) {
    }
  }, isadd);

  const isFormValid = () => {
    let isValid = true;
    let inputItem = [...titleData];
    inputItem.map((j) => {
      if (j.required && j.value.trim() == "") {
        isValid = false;
        return (j.errmsg = `${j.titles} Required`);
      } else {
        return (j.errmsg = "");
      }
    });

    let passwordData = inputItem.filter((i) => {
      return i.type == "email";
    });
    passwordData.map((j) => {
      if (j.type == "email" && j.value.trim() == "") {
        isValid = false;
        return (j.errmsg = `${j.titles} Required`);
      }
    });

    if (titleData[2]["value"].trim() != titleData[3]["value"].trim()) {
      inputItem[3]["errmsg"] = "Email and confirm email should same";
    }

    if (isadd) {
      let passwordData = inputItem.filter((i) => {
        return i.type == "password";
      });
      passwordData.map((j) => {
        if (j.type == "password" && j.value.trim() == "") {
          isValid = false;
          return (j.errmsg = `${j.titles} Required`);
        }
      });

      if (titleData[4]["value"].trim() != titleData[5]["value"].trim()) {
        inputItem[5]["errmsg"] = "Password and confirm password should same";
      }
    }
    setTitleData(inputItem);
    return isValid;
  };

  useEffect(() => {
    if (!isadd) {
      let newdata = [...titleData];
      newdata[0]["value"] = activity.first_name ? activity.first_name : null;
      newdata[1]["value"] = activity.last_name ? activity.last_name : null;
      newdata[2]["value"] = activity.email ? activity.email : null;
      newdata[3]["value"] = activity.email ? activity.email : null;

      //change title for password
      newdata[4]["titles"] = "Set New Password";
      newdata[5]["titles"] = "Confirm New Password";

      setTitleData(newdata);
      const reducedPhone =
        activity.phone_number &&
        activity.phone_number.replace(activity.country_code, "");
      setCombine(
        activity.phone_number && activity.country_code
          ? `${activity.country_code}${activity.phone_number}`
          : null
      );
      setCountryCode(activity.country_code ? activity.country_code : null);
      setPhone(reducedPhone);
      setCheck(
        activity.status ? (activity.status === "Approve" ? true : false) : false
      );
      setId(activity.id ? activity.id : false);
      console.log(activity, "act  ");
    }
  }, [activity]);
  const token = localStorage.getItem("token");

  const navigate = useNavigate();

  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const AddType = () => {
    // const formData = new FormData();
    // formData.append("first_name", titleData[0]["value"]);
    // formData.append("last_name", titleData[1]["value"]);
    // formData.append("email", titleData[2]["value"]);
    // formData.append("phoneNumber", titleData[2]["value"]);
    // formData.append("status", check);
    // formData.append("certificates", 10);

    if (!isFormValid()) {
      return false;
    }

    let parameters = {
      first_name: titleData[0]["value"],
      last_name: titleData[1]["value"],
      email: titleData[2]["value"],
      country_code: countryCode,
      phone_number: phone,
      password: titleData[4]["value"],

      status: check === true ? "Approve" : "Pending",
    };
    axios({
      method: "post",
      url: "/supplier/createstaffmember ",

      headers: {
        "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: parameters,
    })
      .then((response) => {
        console.log("menuItmeStaus", response);
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/staff`);
        // setModal(false)
        toast.success(response.data.message);
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error(err.response.data.message);
      });
  };
  const GoogleTranslate = async (value) => {
    await axios
      .post(
        "/admin/translate",
        {
          text: value,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        const res = response.data.data;
        let newdata = [...titleData];
        newdata[1]["value"] = res.ko;
        newdata[2]["value"] = res.ja;
        setTitleData(newdata);
        console.log("filterData", filterData);
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };
  console.log("sppp", check);
  const UpdateMenuCatagory = () => {
    let check1 = check === true ? "Approve" : "Pending";
    if (!isFormValid()) {
      return false;
    }
    let parameters = {
      id: id,
      first_name: titleData[0]["value"],
      last_name: titleData[1]["value"],
      email: titleData[2]["value"],
      country_code: countryCode,
      phone_number: phone,
      status: check1,
    };

    axios({
      method: "post",
      url: "/supplier/updatestaffmember",

      headers: {
        "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: parameters,
    })
      .then((response) => {
        console.log("menuItmeStaus", response);
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/staff`);
        // setModal(false)
        toast.success(response.data.message);
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error(err.response.data.message);
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
          {isadd ? "Add staff Member" : `Update Staff Member  #${activity.id}`}
        </h5>
      </ModalHeader>
      <ModalBody className="flex-grow-1">
        <div className="mb-1" style={{ padding: "10px" }}>
          {titleData.map((item, index) => {
            return !isadd && item.type === "password" ? (
              <div />
            ) : (
              <Row key={index}>
                <Col md={12}>
                  <div className="mb-1">
                    <Label className="form-label" for="input-default">
                      {item.titles}
                    </Label>
                    {item.type === "password" ? (
                      <>
                        <InputPasswordToggle
                          className="input-group-merge"
                          id="login-password"
                          onChange={(e) => {
                            let newdata = [...titleData];
                            newdata[index]["value"] = e.target.value;
                            setTitleData(newdata);
                          }}
                        />
                        <p style={{ color: "red" }}>{item.errmsg}</p>
                      </>
                    ) : (
                      <>
                        <Input
                          type={item.type}
                          id="input-default"
                          placeholder={item.placeholder}
                          value={item.value}
                          onChange={(e) => {
                            let newdata = [...titleData];
                            newdata[index]["value"] = e.target.value;
                            setTitleData(newdata);
                          }}
                        />
                        <p style={{ color: "red" }}>{item.errmsg}</p>
                      </>
                    )}
                  </div>
                </Col>
              </Row>
            );
          })}
          <Col className="mb-1" xs={12}>
            <Label className="form-label" for="phoneNumber">
              Phone Number
            </Label>
            <PhoneInput
              id="phoneNumber"
              name="phoneNumber"
              country={"us"}
              alwaysDefaultMask={true}
              defaultMask={"... .... ......"}
              value={combinePhone}
              inputStyle={{ width: "100%" }}
              onChange={(phone, country) => {
                console.log("counter 1234", country);
                setCombine(phone);
                setCountryCode(country.dialCode);
                const reducedPhone = phone.replace(country.dialCode, "");

                setPhone(reducedPhone);
              }}
            />
          </Col>
          <div
            className="d-flex flex-column mb-1"
            style={{ marginTop: "0.5rem" }}
          >
            <Label for="switch-success" className="form-check-label mb-50">
              Status {check === true ? "Approve" : "Pending"}
            </Label>
            <div className="form-switch form-check-success">
              <Input
                type="switch"
                id="switch-success"
                name="success"
                checked={check}
                onChange={(e) =>
                  setCheck(e.target.checked === true ? true : false)
                }
              />
            </div>
          </div>

          <p style={{ color: "red" }}>{error}</p>

          <div>
            {isadd ? (
              <Button className="me-1" color="primary" onClick={AddType}>
                Add
              </Button>
            ) : (
              <Button
                className="me-1"
                color="primary"
                onClick={UpdateMenuCatagory}
              >
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

export default AddUpdateStaff;
