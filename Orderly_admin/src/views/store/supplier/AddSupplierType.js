// ** React Imports
import { useEffect, useState } from "react";

// ** Third Party Components
import Flatpickr from "react-flatpickr";
import { User, Briefcase, Mail, Calendar, DollarSign, X } from "react-feather";
import axios from "axios";
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
  InputGroup,
  InputGroupText,
} from "reactstrap";

// ** Styles
import "@styles/react/libs/flatpickr/flatpickr.scss";
// import veg from '../../src/images/veg.svg'
// import nonveg from '../../src/images/nonveg.svg'
import { useNavigate } from "react-router-dom";

import FormControl from "@mui/material/FormControl";
// import Select from '@mui/material/Select';
import Box from "@mui/material/Box";
import Select, { components } from "react-select"; // eslint-disable-line
import toast from "react-hot-toast";

// const colourOptions = {
//   Pending: { value: 'Pending', label: 'Pending' },
//   Accepted: { value: 'Accepted', label: 'Accepted' },
//   Preparing: { value: 'Preparing', label: 'Preparing' },
//   Ontheway: { value: 'On the way', label: 'On the way' },
//   Delivered: { value: 'Delivered', label: 'Delivered' },
//   Cancel: { value: 'Cancel', label: 'Cancel' }

// }

// const options = [
//   { label: "Breakfast", value: "1" },
//   { label: "Lunch", value: "2" },
//   { label: "Dinner", value: "3" }

// ];

const AddSupplierType = ({ open, handleModal }) => {
  // ** State

  // const [change, setChange] = useState(allData.order_status);
  const [activityTitle, setActivityTitle] = useState("");
  const [productDescription, setProductDescription] = useState("");
  const [productPrice, setProductPrice] = useState("");
  const [productType, setProductType] = useState("");
  const [changeCatagory, setChangeCatagory] = useState("");
  const [activities, setActivities] = useState("");

  console.log("activities", activities);
  // console.log("productDescription", productDescription);
  // console.log("productPrice", productPrice);
  console.log("changeCatagory", changeCatagory.value);
  const animatedComponents = makeAnimated();

  // console.log("change", menuItem);
  const token = localStorage.getItem("token");
  const navigate = useNavigate();

  // ** Custom close btn
  const CloseBtn = (
    <X className="cursor-pointer" size={15} onClick={handleModal} />
  );

  const createMenuItem = () => {
    axios
      .post(
        "/activities/create",
        {
          title: activityTitle,
          image:
            "https://res.cloudinary.com/swiggy/image/upload/fl_lossy,f_auto,q_auto,w_208,h_208,c_fit/maqv3yizxwkyjbkhb2la",
        },
        { headers: { Authorization: `Bearer ${token}` } }
      )
      .then((response) => {
        console.log("orderlisting", response);
        // navigate(`${process.env.REACT_APP_FOLDER}/menu-item`);
        // toast.success(response.data.message);
      })
      .catch((err) => {
        console.log(err);
        toast.error(err.response.data.message);
      });
  };

  const handleOnchange = (val) => {
    console.log("val", val);
    setChangeCatagory(val);
  };
  useEffect(() => {
    axios
      .get("/menu/get", { headers: { Authorization: `Bearer ${token}` } })
      .then((res) => {
        const menuArray = res.data.data.map((item) => {
          return { label: item.title, value: item.id };
        });

        setActivities(menuArray);
        // setMenuget(response.data.data)
        // console.log("orderlisting", response)
        // navigate("/menu-item")
      })
      .catch((err) => {
        console.log(err);
      });
  }, []);

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
        <h5 className="modal-title">Tour Create</h5>
      </ModalHeader>
      <ModalBody className="flex-grow-1">
        <div className="mb-1" style={{ padding: "10px" }}>
          <div className="mb-1">
            <Label className="form-label" for="inputFile">
              Add Tour Images
            </Label>
            <Input type="file" id="inputFile" name="fileInput" multiple />
          </div>

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Tour Name
            </Label>
            <Input
              type="text"
              id="input-default"
              placeholder="Enter Product Name"
              value={activityTitle}
              onChange={(e) => setActivityTitle(e.target.value)}
            />
          </div>

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Tour Short Discription
            </Label>
            <Input
              type="textarea"
              id="input-default"
              placeholder="Enter Product Short Discription"
              value={productDescription}
              onChange={(e) => setProductDescription(e.target.value)}
            />
          </div>

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Tour Full Discription
            </Label>
            <Input
              type="textarea"
              id="input-default"
              placeholder="Enter Product Full Discription"
              value={productDescription}
              onChange={(e) => setProductDescription(e.target.value)}
            />
          </div>

          <div className="mb-1">
            <Label className="form-label" for="input-default">
              Enter Tour Price
            </Label>
            <Input
              type="number"
              id="input-default"
              placeholder=" Enter Tour Price"
              value={productPrice}
              onChange={(e) => setProductPrice(e.target.value)}
            />
          </div>
          <div className="mb-1">
            <div className="mb-1">
              <Label className="form-label" for="input-default">
                Activity Title
              </Label>
              {/* <Select
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
              /> */}
            </div>
          </div>
        </div>

        <div>
          <Button className="me-1" color="primary" onClick={createMenuItem}>
            Add Item
          </Button>
          <Button color="secondary" onClick={handleModal} outline>
            Cancel
          </Button>
        </div>
      </ModalBody>
    </Modal>
  );
};

export default AddSupplierType;
