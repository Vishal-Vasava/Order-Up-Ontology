// ** React Imports
import { useEffect, useState } from "react";

// ** Third Party Components
import Flatpickr from "react-flatpickr";
import { User, Briefcase, Mail, Calendar, DollarSign, X } from "react-feather";
import axios from "axios";

import Select, { components } from "react-select"; // eslint-disable-line
import { selectThemeColors } from "@utils";
import makeAnimated from "react-select/animated";

// ** Reactstrap Imports
import {
  Modal,
  Input,
  Label,
  Button,
  ModalHeader,
  ModalBody,
} from "reactstrap";

// ** Styles
import "@styles/react/libs/flatpickr/flatpickr.scss";
// import veg from '../../src/images/veg.svg'
// import nonveg from '../../src/images/nonveg.svg'
import { useNavigate } from "react-router-dom";

import FormControl from "@mui/material/FormControl";
import Box from "@mui/material/Box";
import toast from "react-hot-toast";

const EditMenuItemModal = ({ open, handleModal, menuItem }) => {
  // ** State

  // const [change, setChange] = useState(allData.order_status);
  const [productName, setProductName] = useState(menuItem.title);
  const [productPrice, setProductPrice] = useState(menuItem.price);
  const [time, aetProductTime] = useState(menuItem.time);

  // const [productType, setProductType] = useState(menuItem.veg);
  const [check, setCheck] = useState(menuItem.status);
  const [option, setOption] = useState();
  const [title, setTitle] = useState({
    label: menuItem.activity_title,
    value: menuItem.activity_id,
  });
  const token = localStorage.getItem("token");
  const navigate = useNavigate();

  const animatedComponents = makeAnimated();

  // ** Custom close btn
  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  useEffect(() => {
    axios
      .get("/activities/getsubactivity", {
        headers: { Authorization: `Bearer ${token}` },
      })
      .then((response) => {
        console.log("orderlisting", response.data.data);
        let newOption = [];
        response.data.data &&
          response.data.data.map((i) => {
            newOption.push({ label: i.title, value: i.id });
          });
        setOption(newOption);
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  }, []);

  const updateMenuItem = () => {
    axios
      .post(
        "/product/update",
        {
          id: menuItem.id,
          title: productName,
          price: productPrice,
          time: time,
          status: check,
          activity_id: title.value,
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        navigate(`${process.env.REACT_APP_FOLDER}/product-listing`);
        toast.success(response.data.message);
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };

  return (
    <Modal
      isOpen={open}
      toggle={handleModal}
      className="sidebar-sm"
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
          Update ProductID<b>#{menuItem.id}</b>
        </h5>
      </ModalHeader>{" "}
      <ModalBody className="flex-grow-1">
        <div className="mb-1" style={{ padding: "10px" }}>
          {/* <div className="mb-1">
            <Label className="form-label" for="inputFile">
              Add Product Image
            </Label>
            <Input type="file" id="inputFile" name="fileInput" />
          </div> */}

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Product Name
            </Label>
            <Input
              type="text"
              id="input-default"
              placeholder="Enter Product Name"
              value={productName}
              onChange={(e) => setProductName(e.target.value)}
            />
          </div>

          {/* <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Product Discription
            </Label>
            <Input
              type="text"
              id="input-default"
              placeholder="Enter Product Discription"
              value={productDescription}
              onChange={(e) => setProductDescription(e.target.value)}
            />
          </div> */}

          {/* <Label className='form-label' for='input-default'>
            Enter Product Type
          </Label> */}
          {/* <div style={{ display: "flex" }} className="mb-1">
            <div className="form-check form-check-success">
              <Input
                type="radio"
                name="ex1"
                id="ex1-inactive"
                value="1"
                onChange={(e) => setProductType(e.target.value)}
                defaultChecked={menuItem.veg === 1}
              />
              <Label className="form-check-label" for="ex1-inactive">
                veg
              </Label>
            </div>
            <div
              className="form-check form-check-danger"
              style={{ marginLeft: "20px" }}
            >
              <Input
                type="radio"
                id="ex1-active"
                value="0"
                name="ex1"
                onChange={(e) => setProductType(e.target.value)}
                defaultChecked={menuItem.veg === 0}
              />
              <Label className="form-check-label" for="ex1-active">
                non-veg
              </Label>
            </div>
          </div> */}
          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Product Price
            </Label>
            <Input
              type="number"
              id="input-default"
              placeholder=" Enter Product Base Price"
              value={productPrice}
              onChange={(e) => setProductPrice(e.target.value)}
            />
          </div>
          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Time
            </Label>
            <Input
              type="text"
              id="input-default"
              placeholder="Enter Product Name"
              value={time}
              onChange={(e) => setProductName(e.target.value)}
            />
          </div>

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Activity Title
            </Label>
            <Select
              isClearable={false}
              theme={selectThemeColors}
              closeMenuOnSelect={true}
              components={animatedComponents}
              value={title}
              onChange={(e) => {
                setTitle(e);
              }}
              defaultValue={{
                label: menuItem.activity_title,
                value: menuItem.activity_id,
              }}
              options={option}
              className="react-select"
              classNamePrefix="select"
            />
          </div>

          <div className="d-flex flex-column mb-1">
            <Label for="switch-success" className="form-check-label mb-50">
              Product {check === true ? "ON" : "OFF"}
            </Label>
            <div className="form-switch form-check-success">
              <Input
                type="switch"
                id="switch-success"
                name="success"
                checked={check}
                onChange={(e) => setCheck(e.target.checked ? true : false)}
                // onClick={MenuItemStatus}
              />
            </div>
          </div>

          <div>
            <Button className="me-1" color="primary" onClick={updateMenuItem}>
              Update
            </Button>
            <Button color="secondary" onClick={handleModal} outline>
              Cancel
            </Button>
          </div>
        </div>
      </ModalBody>
    </Modal>
  );
};

export default EditMenuItemModal;
