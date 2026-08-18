// ** React Imports
import { useState, useEffect } from "react";

// ** Third Party Components

import { X } from "react-feather";

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
  const [inputValues, setInputValue] = useState({
    question: activity.question,
    answer: activity.answer,
    order:activity?.order
  });

  const [validation, setValidation] = useState({
    title: "",
    desc: "",
  });

  function handleChange(name, value) {
    setInputValue({ ...inputValues, [name]: value });
    let errors = validation;

    if (name === "question") {
      //first Name validation
      if (!value.trim()) {
        errors.title = "Question is required";
      } else {
        errors.title = "";
      }
    }

    if (name === "answer") {
      //last Name validation
      if (!value.trim()) {
        errors.desc = "Answer is required";
      } else {
        errors.desc = "";
      }
    }
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    let errors = validation;

    //title validation
    if (!inputValues.question?.trim()) {
      errors.question = "Question is required";
    } else {
      errors.question = "";
    }

    //description  validation
    if (!inputValues.answer?.trim()) {
      errors.answer = "Answer is required";
    } else {
      errors.answer = "";
    }

    setValidation({ ...validation, errors });

    if (validation.question === "" && validation.answer === "") {
      isadd ? AddType() : UpdateMenuCatagory();
    }
  };

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
    // const formData = new FormData();

    // formData.append("certificates", 10);
    axios({
      method: "post",
      url: "admin/faq/create",

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: inputValues,
    })
      .then((response) => {
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/faq-listing`);
        // setModal(false)
        toast.success("Successfully created.");
      })
      .catch((err) => {
        console.log(err);

        toast.error(err.response.data.message);
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
        navigate(`${process.env.REACT_APP_FOLDER}/faq-listing`);
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
          {isadd ? "Add FAQ" : `Update FAQ #${activity._id}`}
        </h5>
      </ModalHeader>
      <ModalBody className="flex-grow-1">
        <div className="mb-1" style={{ padding: "10px" }}>
          <Row>
            <Col md={12}>
              <div className="mb-1">
                <Label className="form-label" for="input-default">
                  Question
                </Label>
                <Input
                  type="textarea"
                  id="input-default"
                  placeholder={"Please eneter question"}
                  value={inputValues.question}
                  name="question"
                  rows={2}
                  invalid={validation.question ? true : false}
                  onChange={(e) => handleChange("question", e.target.value)}
                />
                {validation.question && (
                  <p
                    className="text-danger ms-1 mb-0"
                    style={{ marginTop: "6px" }}
                  >
                    {validation.question}
                  </p>
                )}
              </div>
            </Col>
            <Col md={12}>
              <div className="mb-1">
                <Label className="form-label" for="input-default">
                  Answer
                </Label>
                <Input
                  type="textarea"
                  id="input-default"
                  placeholder={"Please enter answer"}
                  name="answer"
                  rows={4}
                  value={inputValues.answer}
                  invalid={validation.answer ? true : false}
                  onChange={(e) => handleChange("answer", e.target.value)}
                />
                {validation.answer && (
                  <p
                    className="text-danger ms-1 mb-0"
                    style={{ marginTop: "6px" }}
                  >
                    {validation.answer}
                  </p>
                )}
              </div>
            </Col>
            <Col md={12}>
              <div className="mb-1">
                <Label className="form-label" for="input-default">
                  Serial Number
                </Label>
                <Input
                  type="number"
                  id="input-default"
                  placeholder={"Please eneter serial Number"}
                  value={inputValues.order}
                  name="order"
                 
                  invalid={validation.order ? true : false}
                  onChange={(e) => handleChange("order", e.target.value)}
                />
               
              </div>
            </Col>
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
