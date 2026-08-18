// ** React Imports
import { useState, useEffect } from "react";

// ** Third Party Components

import { Image, X } from "react-feather";
import Select from "react-select";

import makeAnimated from "react-select/animated";
import CollectionsIcon from "@mui/icons-material/Collections";
import { selectThemeColors } from "@utils";
const options = [
  { label: "Pending", value: 0 },
  { label: "Approve", value: 1 },
  { label: "Reject", value: 2 },
  { label: "Inactive", value: 3 },
];

const deletedOptions = [
  {
    label: "Yes",
    value: "true",
  },
  {
    label: "No",
    value: "false",
  },
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
import userPlaceHolder1 from "../../../assets/images/avatars/avatar-blank.png";
import userPlaceHolder from "../../../assets/images/avatars/backBanner.jpeg";
import ShowSKUGallery from "./ShowSKUGallery";

const AddUpdateModal = ({ open, handleModal, activity, isadd }) => {
  console.log("sdfgsgdss", activity);
  // ** State
  const [title, setTitle] = useState(activity.name);
  const [desc, setDesc] = useState(activity.desc);
  console.log("csvssv", activity);
  const [check, setCheck] = useState(true);
  const [logoImage, setlogoImage] = useState(activity?.image_url);
  const [bannerImage, setBannerImage] = useState(activity.banner);
  const [activityImageFile, setactivityImageFile] = useState();
  const [bannerImageFile, setBannerImageFile] = useState();
  const [skuModal, setSkuModal] = useState(false);
  const [imageId, setImageId] = useState("");
  const [allStores, setAllStores] = useState([]);
  const [allFilters, setAllFilters] = useState([]);
  const [returnPolicy, setReturnsPolicy] = useState([]);
  const [producerID, setProducerID] = useState(null);
  const [estimatedDeliverys, setEstimetedDeliveries] = useState([]);

  const [inputValues, setInputValue] = useState({
    productImageFile: "",
    selectStore: {
      label: activity?._producer?.name,
      value: activity?._producer?._id,
    },
    productName: activity?.name,
    Rate: activity?.price,
    quantity: activity?.qty,
    deleted:
      activity?.deleted === true
        ? { label: "Yes", value: "true" }
        : { label: "No", value: "false" },
    desc: activity?.desc,
    selectFilters : activity?._filters?.map((filter_item) => {
      return {label: filter_item.name,value: filter_item._id}
    }),
    returnPolicy: {
      label: activity?._returnPolicy?.title,
      value: activity?._returnPolicy?._id,
    },
    estimatedDeilivery: {
      label: activity?._estimatedPickup?.title,
      value: activity?._estimatedPickup?._id,
    },
  });

  const [validation, setValidation] = useState({
    productImageFile: "",
    selectStore: "",
    productName: "",
    Rate: "",
    quantity: "",
    deleted: "",
    desc: "",
    returnPolicy: "",
    estimatedDeilivery: "",
  });

  const getRecord = () => {
    axios
      .get("/admin/stores", { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        console.log("activities", response.data);
        const stores = response.data;
        const allStore = stores.map((i) => {
          return { label: i.name, value: i._id };
        });
        console.log("csdvs", allStore);
        setAllStores(allStore);
      })
      .catch((err) => {});
  };

  const getReturnPolicy = () => {
    axios
      .get("/admin/returnpolicy/get", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        console.log("activities returns", response.data);
        const returns = response.data;
        const allPolicy = returns.map((i) => {
          return { label: i.title, value: i._id };
        });

        setReturnsPolicy(allPolicy);
      })
      .catch((err) => {});
  };

  const getEstimatedDilivery = (id) => {
    axios
      .get(`/admin/estimatedpickup/get/${id}`, {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        console.log("activities Estimated", response.data);
        const dilivery = response.data;
        const diliveries = dilivery.map((i) => {
          return { label: i.title, value: i._id };
        });

        setEstimetedDeliveries(diliveries);
      })
      .catch((err) => {
        console.log("err", err);
      });
  };

  const getFilters = () => {
    axios
      .get("/admin/store/filters", { headers: { Authorization: `Bearer ${token}` } })
      .then((response) => {
        const filters_data = response.data;
        const allFilters = filters_data.map((i) => {
          return { label: i.name, value: i._id };
        });
        setAllFilters(allFilters);
      })
      .catch((err) => {});
  };

  useEffect(() => {
    getRecord();
    getReturnPolicy();
    getFilters();
  }, []);

  useEffect(() => {
    if (producerID) {
      getEstimatedDilivery(producerID);
    }
  }, [producerID]);

  function handleChange(name, value) {
    setInputValue({ ...inputValues, [name]: value });
    let errors = validation;

    if (name === "productName") {
      //first Name validation
      if (!value.trim()) {
        errors.productName = "Product Name is required";
      } else {
        errors.productName = "";
      }
    }

    if (name === "Rate") {
      //last Name validation
      if (!value.trim()) {
        errors.Rate = "Rate is required";
      } else {
        errors.Rate = "";
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

    if (name === "selectStore") {
      //last Name validation
      if (!value) {
        errors.selectStore = "Store is required";
      } else {
        errors.selectStore = "";
      }
    }

    

    if (name === "estimatedDeilivery") {
      //last Name validation
      if (!value) {
        errors.estimatedDeilivery = "This field is required";
      } else {
        errors.estimatedDeilivery = "";
      }
    }
    if (name === "returnPolicy") {
      //last Name validation
      if (!value) {
        errors.returnPolicy = "This field is required";
      } else {
        errors.returnPolicy = "";
      }
    }

    if (name === "deleted") {
      //last Name validation
      if (!value) {
        errors.deleted = "Deleted is required";
      } else {
        errors.deleted = "";
      }
    }

    if (name === "quantity") {
      //last Name validation
      if (!value) {
        errors.quantity = "Quantity is required";
      } else {
        errors.quantity = "";
      }
    }

    if (isadd) {
      if (name === "productImageFile" && logoImage) {
        //last Name validation
        if (!value?.name || !logoImage) {
          errors.productImageFile = "ProductImage is required";
        } else {
          errors.productImageFile = "";
        }
      }
    } else {
      errors.productImageFile = "";
    }
  }

  const handleSubmit = (e) => {
    e.preventDefault();
    let errors = validation;

    //title validation
    if (!inputValues.productName?.trim()) {
      errors.productName = "Product Name is required";
    } else {
      errors.productName = "";
    }

    //description  validation
    if (!inputValues.desc?.trim()) {
      errors.desc = "Description is required";
    } else {
      errors.desc = "";
    }

    if (!inputValues.Rate) {
      errors.Rate = "Rate is required";
    } else {
      errors.Rate = "";
    }

    // if (!inputValues.deleted?.value) {
    //   errors.deleted = "Deleted is required";
    // } else {
    //   errors.deleted = "";
    // }

    if (!inputValues.selectStore?.value) {
      errors.selectStore = "Store is required";
    } else {
      errors.selectStore = "";
    }

    if (!inputValues.estimatedDeilivery?.value) {
      errors.estimatedDeilivery = "This field is required";
    } else {
      errors.estimatedDeilivery = "";
    }

    if (!inputValues.returnPolicy?.value) {
      errors.returnPolicy = "This field is required";
    } else {
      errors.returnPolicy = "";
    }

    if (!inputValues.quantity) {
      errors.quantity = "Quantity is required";
    } else {
      errors.quantity = "";
    }

    if (isadd) {
      if (!inputValues?.productImageFile?.name && !logoImage) {
        errors.productImageFile = "Product Image is required";
      } else {
        errors.productImageFile = "";
      }
    } else {
      errors.productImageFile = "";
    }

    setValidation({ ...validation, errors });

    if (
      validation.productName === "" &&
      validation.desc === "" &&
      validation.productImageFile === "" &&
      validation.Rate === "" &&
      // validation.deleted === "" &&
      validation.selectStore === "" &&
      validation.quantity === "" &&
      validation.returnPolicy === "" &&
      validation.estimatedDeilivery === ""
    ) {
      isadd ? AddType() : UpdateMenuCatagory();
    }
  };

  const animatedComponents = makeAnimated();

  useEffect(() => {
    if (!isadd) {
      // setBannerImage(activity.banner_url)
      setlogoImage(activity.image_url);
      setCheck(activity.visible ? activity.visible : false);
      setProducerID(activity?._producer?._id);
    }
  }, [activity]);
  const token = localStorage.getItem("token");

  const navigate = useNavigate();

  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const AddType = () => {
    const formData = new FormData();
    formData.append("name", inputValues?.productName);
    formData.append("desc", inputValues?.desc);
    formData.append("price", inputValues.Rate);
    formData.append("qty", inputValues.quantity);
    formData.append("_producer", inputValues?.selectStore?.value);
    formData.append("_creator", "647b6c826893e85117c2135b");
    formData.append("visible", check);
    if (imageId) {
      formData.append("image_id", imageId);
    } else {
      formData.append("image", inputValues?.productImageFile);
    }
    
    
    if(inputValues?.selectFilters?.length){

      inputValues.selectFilters.forEach((item) => {
        formData.append("_filters[]", item.value);
     })
    }
    // formData.append("_filters[]", filterList);
    formData.append("_returnPolicy", inputValues?.returnPolicy?.value);
    formData.append("_estimatedPickup", inputValues?.estimatedDeilivery?.value);
    // formData.append("certificates", 10);
    axios({
      method: "post",
      url: "/admin/inventory/create",

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {
        console.log("menuItmeStaus", response);
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/products`);
        // setModal(false)
        toast.success("Products Add Successfully");
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error(err.response.data.message);
      });
  };

  const UpdateMenuCatagory = () => {
    const formData = new FormData();

    formData.append("id", activity.id);
    formData.append("name", inputValues?.productName);
    formData.append("desc", inputValues?.desc);
    formData.append("price", inputValues.Rate);
    formData.append("qty", inputValues.quantity);
    formData.append("image", inputValues?.productImageFile);
    formData.append("_producer", inputValues?.selectStore?.value);
    formData.append("visible", check);
    formData.append("deleted", inputValues?.deleted?.value);
    formData.append("_creator", "647b6c826893e85117c2135b");
    formData.append("image_id", imageId);
    formData.append("_returnPolicy", inputValues?.returnPolicy?.value);
    formData.append("_estimatedPickup", inputValues?.estimatedDeilivery?.value);

    if(inputValues?.selectFilters?.length){

      inputValues.selectFilters.forEach((item) => {
        formData.append("_filters[]", item.value);
     })
    }
    // formData.append("certificates", 10);

    axios({
      method: "put",
      url: `admin/inventory/update/${activity.id}`,

      headers: {
        // "content-type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      data: formData,
    })
      .then((response) => {
        console.log("menuItmeStaus", response);
        handleModal();
        navigate(`${process.env.REACT_APP_FOLDER}/products`);

        toast.success("Products Update Successfully!");
      })
      .catch((err) => {
        console.log(err);
        // console.log("err",);
        toast.error(
          err.response.data.message
            ? err.response.data.message
            : "Something wrong"
        );
      });
  };

  return (
    <>
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
            {isadd ? "Add Product" : `Update Product `}
          </h5>
          {isadd ? "" : <h5 classNam="modal-title">#{activity.id}</h5>}
        </ModalHeader>
        <ModalBody className="flex-grow-1">
          <div className="mb-1" style={{ padding: "10px" }}>
            <div className="flex justify-end items-end mb-1">
              <Label
                className="form-label"
                for="input-default"
                // style={{  marginLeft: "1rem" }}
              >
                Product Image* <span><i>( Recommend Size : 400 x 300 )</i></span>
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
                      setlogoImage(URL.createObjectURL(e.target.files[0]));
                      handleChange("productImageFile", e.target.files[0]);
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
                  >
                    <Image size={20} />
                  </IconButton>
                </label>

                <IconButton
                  color="primary"
                  className="p-0 ml-6"
                  aria-label="upload picture"
                  component="span"
                  style={{ marginLeft: "1rem" }}
                  onClick={() => setSkuModal(true)}
                >
                  <CollectionsIcon />
                </IconButton>
                {/* <button onClick={() => setSkuModal(true)}>show Sky Gallary</button> */}

                {validation.productImageFile && (
                  <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                    {validation.productImageFile}
                  </p>
                )}
              </div>
            </div>
            <Row>
              <Col sm="12" className="mb-1">
                <Label className="form-label" for="Status">
                  Select Store*
                </Label>

                <Select
                  isClearable={false}
                  theme={selectThemeColors}
                  closeMenuOnSelect={true}
                  components={animatedComponents}
                  value={inputValues.selectStore}
                  onChange={(e) => {
                    handleChange("selectStore", e);
                    setProducerID(e.value);
                    console.log("vdsgsbsdbds", e);
                  }}
                  options={allStores}
                  className="react-select"
                  classNamePrefix="select"
                />
                {validation.selectStore && (
                  <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                    {validation.selectStore}
                  </p>
                )}
              </Col>
              <Col md={12}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Product Name
                  </Label>
                  <Input
                    type="text"
                    id="input-default"
                    placeholder={"Enter Product name"}
                    value={inputValues.productName}
                    name="productName"
                    onChange={(e) =>
                      handleChange("productName", e.target.value)
                    }
                  />
                  {validation.productName && (
                    <p
                      className="text-danger mb-0"
                      style={{ marginTop: "6px" }}
                    >
                      {validation.productName}
                    </p>
                  )}
                </div>
              </Col>
              <Col md={12}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Rate*
                  </Label>
                  <Input
                    type="number"
                    id="input-default"
                    placeholder={"Enter Rate"}
                    name="Rate"
                    value={inputValues.Rate}
                    onChange={(e) => handleChange("Rate", e.target.value)}
                  />
                  {validation.Rate && (
                    <p
                      className="text-danger mb-0"
                      style={{ marginTop: "6px" }}
                    >
                      {validation.Rate}
                    </p>
                  )}
                </div>
              </Col>

              <Col md={12}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Quantity*
                  </Label>
                  <Input
                    type="number"
                    id="input-default"
                    placeholder={"Enter Quantity"}
                    value={inputValues.quantity}
                    onChange={(e) => handleChange("quantity", e.target.value)}
                  />
                  {validation.quantity && (
                    <p
                      className="text-danger mb-0"
                      style={{ marginTop: "6px" }}
                    >
                      {validation.quantity}
                    </p>
                  )}
                </div>
              </Col>
              {isadd ? (
                ""
              ) : (
                <Col sm="12" className="mb-1">
                  <Label className="form-label" for="Status">
                    Deleted?*
                  </Label>

                  <Select
                    isClearable={false}
                    theme={selectThemeColors}
                    closeMenuOnSelect={true}
                    components={animatedComponents}
                    value={inputValues.deleted}
                    onChange={(e) => handleChange("deleted", e)}
                    options={deletedOptions}
                    className="react-select"
                    classNamePrefix="select"
                  />
                  {validation.deleted && (
                    <p
                      className="text-danger mb-0"
                      style={{ marginTop: "6px" }}
                    >
                      {validation.deleted}
                    </p>
                  )}
                </Col>
              )}
              <Col md={12}>
                <div className="mb-1">
                  <Label className="form-label" for="input-default">
                    Description*
                  </Label>
                  <Input
                    type="textarea"
                    id="input-default"
                    placeholder={"Enter Description"}
                    value={inputValues.desc}
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

              <Col sm="12" className="mb-1">
              <Label className="form-label" for="filter">
                  Filters
                </Label>

                <Select
                  isClearable={false}
                  theme={selectThemeColors}
                  closeMenuOnSelect={true}
                  components={animatedComponents}
                  value={inputValues.selectFilters}
                  onChange={(e) => handleChange("selectFilters", e)}
                  options={allFilters}
                  className="react-select"
                  classNamePrefix="select"
                  id="filter"
                  isMulti={true}
                />
              </Col>

              <Col sm="12" className="mb-1">
                <Label className="form-label" for="Status">
                  Return Policy*
                </Label>

                <Select
                  isClearable={false}
                  theme={selectThemeColors}
                  closeMenuOnSelect={true}
                  components={animatedComponents}
                  value={inputValues.returnPolicy}
                  onChange={(e) => handleChange("returnPolicy", e)}
                  options={returnPolicy}
                  className="react-select"
                  classNamePrefix="select"
                />
                {validation.returnPolicy && (
                  <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                    {validation.returnPolicy}
                  </p>
                )}
              </Col>
              <Col sm="12" className="mb-1">
                <Label className="form-label" for="Status">
                  Estimated Delivery*
                </Label>

                <Select
                  isClearable={false}
                  theme={selectThemeColors}
                  closeMenuOnSelect={true}
                  components={animatedComponents}
                  value={inputValues.estimatedDeilivery}
                  onChange={(e) => {
                    handleChange("estimatedDeilivery", e);
                  }}
                  options={estimatedDeliverys}
                  className="react-select"
                  classNamePrefix="select"
                />
                {validation.estimatedDeilivery && (
                  <p className="text-danger mb-0" style={{ marginTop: "6px" }}>
                    {validation.estimatedDeilivery}
                  </p>
                )}
              </Col>
            </Row>

            <div
              className="d-flex flex-column mb-1"
              style={{ marginTop: "0.5rem" }}
            >
              <Label for="switch-success" className="form-check-label mb-50">
                Product {check === true ? "Enable" : "Disable"}
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
      <ShowSKUGallery
        openModal={skuModal}
        setOpenModal={setSkuModal}
        setlogoImage={setlogoImage}
        setImageId={setImageId}
        setInputValue={setInputValue}
        inputValues={inputValues}
        title="Staff Members"
        subTitle="Staff Members Details"
      />
    </>
  );
};

export default AddUpdateModal;
